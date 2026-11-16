/* ==========================================================================

   Parametric Print-in-Place Rotational Hinge (A)
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   A parametric articulated link system with a vertical-axis pin-and-ring
   hinge. The individual links are printed in place.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */

/* [Chain and body] */
// Number of articulated bodies printed together. Begin with three for a fit test.
segments = 3;            // Start with 3; change to 6, 10, ... later
// 2D body outline: rounded rectangle, tapered polygon, or six-sided profile.
body_shape = "rounded"; // "rounded", "tapered", or "hex"
// Length of an individual link body along X, excluding the hinge.
body_length = 12;
// Maximum link-body width in Y.
body_width = 13.5;
// Z extrusion height of each link body (mm).
body_height = 6.2;
// Centre-to-centre distance between adjacent link bodies along X.
segment_pitch = 20;      // Center-to-center spacing along X

/* [Print-in-place clearances] */
// Radial clearance around the captive hinge parts in the build plane (mm).
clearance_xy = 0.35;     // Radial clearance for FDM; test 0.30-0.45
// Vertical gap above the female bearing before the male retaining bridge (mm).
clearance_z = 0.40;      // Axial clearance above bearing

/* [Hinge and bearing dimensions] */
// Radius of the rotating centre pin.
pin_radius = 1.70;
// Radius of the retaining flange that prevents the pin pulling out.
retainer_radius = 2.60;
// Outside radius of the stationary female bearing.
ring_outer_radius = 4.25;
// Height of the female bearing ring from the build plate.
ring_height = 4.75;
// Height of the lower flange at the build plate.
retainer_base_height = 0.85;
// Z height where the female bearing's internal taper begins.
bevel_start_z = 1.00;
// Z height where the taper finishes at the narrow pin bore.
bevel_end_z = 1.90;
// Calculated thickness above the bearing; derived from other dimensions.
bridge_thickness = body_height - ring_height - clearance_z;
// Width of the neck joining the male hinge assembly to the link body.
neck_width = 2.7;

/* [Pivot placement] */
// X offset from link centre to the male pivot.
male_offset = 10.8; // Pivot location to the right of segment center
// Derived offset from the next body's centre to the matching female bearing.
female_offset = segment_pitch - male_offset;
// Corner rounding radius used by the rounded body option.
corner_radius = 1.6;

/* [Render quality] */
$fn = 72;

// Parameter safety checks. Clearances protect the captive moving parts.
assert(segments >= 2, "At least two links are required.");
assert(clearance_xy > 0.20, "The clearance should be tested, preferably >=0.3 mm.");
assert(bridge_thickness > 0.70, "The top retaining bridge is too thin.");
assert(pin_radius+clearance_xy < retainer_radius,
       "The retaining flanges would not catch the bearing.");
assert(retainer_radius+clearance_xy < ring_outer_radius-0.9,
       "The bearing wall below the inner shoulder is too thin.");

// Builds the selected two-dimensional body outline before Z extrusion.
module segment_outline(index=0) {
    if (body_shape == "rounded") {
        offset(r=corner_radius)
            square([body_length-2*corner_radius,
                    body_width-2*corner_radius], center=true);
    } else if (body_shape == "tapered") {
        polygon(points=[
            [-body_length/2, -body_width*0.36],
            [-body_length/2,  body_width*0.36],
            [ body_length/2,  body_width*0.50],
            [ body_length/2, -body_width*0.50]
        ]);
    } else {
        circle(d=body_width, $fn=6);
    }
}

// Female half: closed bearing ring with a stepped/tapered internal lip.
// Its bottom opening clears the male lower retainer on the first layer.
// The internal taper steps inward above that lower retainer.
// Generates the captive female ring, including lower entry and tapered throat.
module female_bearing() {
    bore_middle = pin_radius + clearance_xy;
    bore_bottom = retainer_radius + clearance_xy;
    difference() {
        cylinder(h=ring_height, r=ring_outer_radius);
        union() {
            translate([0,0,-0.05])
                cylinder(h=bevel_start_z+0.05, r=bore_bottom);
            translate([0,0,bevel_start_z])
                cylinder(h=bevel_end_z-bevel_start_z,
                         r1=bore_bottom, r2=bore_middle);
            translate([0,0,bevel_end_z])
                cylinder(h=ring_height-bevel_end_z+0.05,
                         r=bore_middle);
        }
    }
}

// Male half: pin + lower retainer on the bed + upper retainer/bridge.
// The upper bridge joins the pin to its owning body ABOVE the bearing.
// Generates the male pivot, retainers, and overhead link-to-pin bridge.
module male_pin_and_bridge() {
    bridge_z = ring_height + clearance_z;
    union() {
        cylinder(h=bridge_z + 0.05, r=pin_radius);
        cylinder(h=retainer_base_height, r=retainer_radius);
        translate([0,0,bridge_z])
            cylinder(h=body_height-bridge_z, r=retainer_radius);
        translate([0,0,bridge_z])
            linear_extrude(height=body_height-bridge_z)
                hull() {
                    circle(d=neck_width);
                    translate([-male_offset + body_length/2 - 0.1, 0])
                        circle(d=neck_width);
                }
    }
}

// Every part is a separate solid while still mechanically interlocked.
// Never union neighboring segments into a rigid chain.
// Positions one link and adds joints only where neighbours exist.
module link(index) {
    translate([index*segment_pitch, 0, 0]) {
        linear_extrude(height=body_height)
            segment_outline(index);
        if (index > 0)
            translate([-female_offset,0,0]) female_bearing();
        if (index < segments-1)
            translate([male_offset,0,0]) male_pin_and_bridge();
    }
}

// Top-level dispatcher: print each link as an independent moving part.
for (i=[0:segments-1]) link(i);
