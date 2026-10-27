/* ========================================================================== 

   Standalone flex spring / zig-zag body
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   DESCRIPTION
   -----------
   Version 1 of a standalone flexible zig-zag wall spring.  It can be clipped to
   a horizontal, flattened cylindrical envelope or generated in its original
   flat-wall form.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.  The spring runs from X=0 to X=spring_length,
   alternates across Y, and is extruded along positive Z.  Cylindrical mode uses
   a round envelope whose axis lies along X.

   CONSTRUCTION
   ------------
   Each link is a hull between overlapping vertical endpoint cylinders.  The
   resulting continuous wall is intersected with either a flattened horizontal
   cylinder or a positive-Z build-plate clipping volume.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */ 

// Cylindrical mode uses a constant round body lying along X, with the same thin
// zig-zag wall pattern clipped inside it.

/* [Spring size] */
// End-to-end spring length along X.
spring_length = 100;

// Diameter of the cylindrical envelope and width of the flat clipping volume.
spring_max_width = 26;

// Legacy taper parameters retained for compatibility with older presets.
// The current path calculations do not consume either value.
spring_start_width = 14.5;
spring_end_width = 8;

// Number of individual links across the complete spring length.
zig_zags = 45;

/* [Spring section] */
// Legacy diameter retained for preset compatibility; current geometry uses
// wall_thickness instead.
spring_diameter = 1.6;

// Z extrusion height used by the original flat-wall mode.
spring_height = 11.5;

// Selects the lying-cylinder envelope when true or original flat wall when false.
cylindrical_shape = true;

// Depth removed from the cylinder underside to create a printable flat contact.
flat_bottom_depth = 0.45;

// Inward distance from each cylinder side to alternating path centrelines.
side_margin = 1.0;

/* [Wall spring] */
// Diameter of endpoint cylinders and resulting wall thickness.
wall_thickness = 0.8;

// Extension beyond each endpoint so neighbouring links overlap robustly.
link_overlap = 0.15;

/* [Preview] */
// Preview colour assigned to the selected spring mode.
spring_color = "YellowGreen";

// Global fragment count for the circular link and envelope sections.
preview_fn = 16;
$fn = preview_fn;

// Restricts v to the inclusive interval lo..hi.
function clamp(v, lo, hi) = min(max(v, lo), hi);

// Converts the configured cylinder diameter to a safely positive radius.
function cylinder_radius() = max(0.1, spring_max_width / 2);

// Returns the alternating Y coordinate at normalized length position t.
function spring_y(t, thickness) =
    let(
        // Assign t to the nearest zig-zag node.
        i = round(t * zig_zags),
        // Keep each wall centreline inside the cylinder after subtracting margin
        // and half wall thickness; never use less than one full thickness.
        center_offset = max(thickness, cylinder_radius() - max(0, side_margin) - thickness / 2)
    )
    // Alternate between positive and negative Y at successive nodes.
    ((i % 2 == 0) ? 1 : -1) * center_offset;

// Creates a large positive-Z clipping box whose lower face is the build plane.
module build_plate_cut(width = spring_max_width) {
    translate([spring_length / 2, 0, 500])
        cube([spring_length * 3, width * 3, 1000], center = true);
}

// Builds the flattened horizontal cylindrical envelope used in cylindrical mode.
module lying_cylinder_envelope() {
    // Lower the cylinder axis by the safely clamped flattening depth.
    r = cylinder_radius();
    z_center = r - clamp(flat_bottom_depth, 0, r * 1.8);

    intersection() {
        // Rotate the cylinder axis from Z onto X and extend it slightly beyond
        // both spring ends for dependable clipping.
        translate([spring_length / 2, 0, z_center])
            rotate([0, 90, 0])
                cylinder(r = r, h = spring_length + wall_thickness + link_overlap * 4, center = true);
        build_plate_cut(spring_max_width);
    }
}

// Builds the complete untrimmed zig-zag wall at the requested height/elevation.
module full_height_wall_core(height, bottom_z) {
    // Negative overlap is disallowed because it would separate adjacent links.
    overlap = max(0, link_overlap);

    union() {
        // Construct each link from its two normalized endpoint positions.
        for (i = [0 : zig_zags - 1]) {
            // Convert link indices into X/Y endpoints.
            t1 = i / zig_zags;
            t2 = (i + 1) / zig_zags;
            x1 = t1 * spring_length;
            y1 = spring_y(t1, wall_thickness);
            x2 = t2 * spring_length;
            y2 = spring_y(t2, wall_thickness);
            dx = x2 - x1;
            dy = y2 - y1;
            len = max(0.001, sqrt(dx * dx + dy * dy));
            ux = dx / len;
            uy = dy / len;

            // Extend endpoints along the normalized direction before hulling the
            // two cylinders into one overlapping, smoothly connected link.
            hull() {
                translate([x1 - ux * overlap, y1 - uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
                translate([x2 + ux * overlap, y2 + uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
            }
        }
    }
}

// Clips an oversized wall core to the flattened cylindrical envelope.
module cylindrical_wall_spring() {
    r = cylinder_radius();

    intersection() {
        full_height_wall_core(r * 2 + 2, -1);
        lying_cylinder_envelope();
    }
}

// Builds the legacy flat spring by clipping its wall only at the build plane.
module original_wall_spring() {
    intersection() {
        full_height_wall_core(spring_height, 0);
        build_plate_cut(spring_max_width);
    }
}

// Top-level mode dispatcher and preview colour assignment.
color(spring_color)
if (cylindrical_shape) {
    cylindrical_wall_spring();
} else {
    original_wall_spring();
}
        // Retain only the part at or above the build plane.
