/* ========================================================================== 

   Standalone flex spring / zig-zag body
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   DESCRIPTION
   -----------
   A flexible zig-zag wall spring that can be clipped into a horizontal cylinder,
   generated as a flat wall, or closed into a donut-shaped ring.  Donut mode can
   use either a flat extrusion or a round toroidal envelope.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.  Linear spring modes run from X=0 to
   X=spring_length and alternate across Y.  Z is the extrusion/build direction.
   Donut mode is centred on global X/Y and closes around the Z axis.

   CONSTRUCTION
   ------------
   Every zig-zag link is a hull between overlapping endpoint cylinders.  The
   complete wall core is optionally intersected with a flattened cylindrical or
   toroidal envelope.  Intentional overlap helps neighbouring links become one
   robust exported mesh.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */ 

// The cylindrical mode uses a constant round envelope lying along X, with the
// same thin zig-zag wall pattern clipped inside it.

/* [Spring shape] */
// Selects a horizontal cylindrical envelope, the original flat wall, or a closed
// donut/ring path.
spring_shape = "cylinder"; // ["cylinder", "flat", "donut"]

// Selects a straight Z extrusion or a round toroidal envelope in donut mode.
donut_profile = "flat"; // ["flat", "round"]

/* [Spring size] */
// End-to-end length along X in cylinder and flat modes.
spring_length = 100;

// Diameter of the cylindrical clipping envelope and flat-mode cut width.
spring_max_width = 26;

// Legacy taper values retained for compatibility with older Customizer presets.
// The current wall-path functions do not use either value.
spring_start_width = 14.5;
spring_end_width = 8;

// Number of links in the alternating path.  Donut mode rounds odd values up to
// the next even number so alternating offsets meet cleanly at the loop closure.
zig_zags = 46;

/* [Spring section] */
// Legacy section diameter retained for preset compatibility; current geometry
// uses wall_thickness instead.
spring_diameter = 1.6;

// Z extrusion height used by flat mode and the flat donut profile.
spring_height = 11.5;

// Amount removed from the lower round envelope to create build-plate contact.
flat_bottom_depth = 0.45;

// Radial/Y distance between the envelope side and alternating path centreline.
// Negative values push the path toward or beyond the nominal envelope boundary;
// the final intersection still clips geometry to the selected envelope.
side_margin = -1.1;

/* [Wall spring] */
// Diameter of endpoint cylinders and resulting zig-zag wall thickness.
wall_thickness = 1.1;

// Extension beyond each link endpoint so adjacent hulls overlap robustly.
link_overlap = 0.25;

/* [Round donut spring] */
// Outside diameter of the complete donut spring.
donut_outer_diameter = 100;

// Radial width of the flat ring and nominal diameter of the round tube envelope.
donut_ring_thickness = 10.1;

// Debug switch: false intersects the donut wall with its round envelope; true
// unions both solids so their complete overlap relationship remains visible.
show_donut_intersektion = false;

/* [Preview] */
// Preview colour of the complete selected spring.
spring_color = "YellowGreen";

// Fragment count used for circular sections and revolved envelope geometry.
preview_fn = 16;
$fn = preview_fn;

// Restricts v to the inclusive numeric interval lo..hi.
function clamp(v, lo, hi) = min(max(v, lo), hi);

// Returns n unchanged when even or advances it by one when odd.
function make_even(n) = n + (n % 2);

// Converts cylinder diameter to radius while retaining a small positive minimum.
function cylinder_radius() = max(0.1, spring_max_width / 2);

// Radius of the round donut tube, constrained to exceed half wall thickness.
function donut_tube_radius() =
    max(wall_thickness / 2 + 0.01, donut_ring_thickness / 2);

// Outside radius of the complete donut.
function donut_outer_radius() =
    donut_outer_diameter / 2;

// Inside ring radius after subtracting radial ring thickness.
function donut_inner_radius() =
    max(0.01, donut_outer_radius() - donut_ring_thickness);

// Mid-radius followed by the donut's alternating zig-zag path.
function donut_center_radius() =
    (donut_outer_radius() + donut_inner_radius()) / 2;

// Maximum inward/outward path displacement that fits the requested ring width
// after accounting for side margin and half the generated wall thickness.
function donut_zigzag_amplitude(thickness) =
    max(
        0,
        donut_ring_thickness / 2 -  side_margin - thickness / 2
    );

// Returns the alternating radial offset at normalized loop position t.
// round() assigns each half-step boundary to its nearest zig-zag node.
function donut_zigzag_y(t, thickness, zags = make_even(zig_zags)) =
    let(
        i = round(t * zags),
        center_offset = donut_zigzag_amplitude(thickness)
    )
    // Alternating sign moves successive nodes outside and inside the centre radius.
    ((i % 2 == 0) ? 1 : -1) * center_offset;

// Returns the alternating Y coordinate at normalized linear position t.
function spring_y(t, thickness) =
    // Convert the normalized position t into a zig-zag index.
    let(
        i = round(t * zig_zags),
        // Compute how far from the cylinder center the zig-zag line should be.
        center_offset = max(thickness, cylinder_radius() - side_margin - thickness / 2)
    )
    // Alternate direction for each zig-zag segment and apply the computed offset.
    ((i % 2 == 0) ? 1 : -1) * center_offset;


// Creates a large positive-Z clipping box whose lower face is the build plane.
// Intersecting with this volume removes all geometry below Z=0.
module build_plate_cut(width = spring_max_width) {
    translate([spring_length / 2, 0, 500])
        cube([spring_length * 3, width * 3, 1000], center = true);
}

// Builds the horizontal cylindrical envelope used by cylindrical spring mode.
module lying_cylinder_envelope() {
    // Lower the cylinder axis by the clamped flattening depth.
    r = cylinder_radius();
    z_center = r - clamp(flat_bottom_depth, 0, r * 1.8);

    intersection() {
        // Rotate the cylinder axis from Z to X and extend its length slightly
        // beyond both spring ends for reliable clipping.
        translate([spring_length / 2, 0, z_center])
            rotate([0, 90, 0])
                cylinder(r = r, h = spring_length + wall_thickness + link_overlap * 4, center = true);
        // Remove the lower circular segment for build-plate contact.
        build_plate_cut(spring_max_width);
    }
}

// Creates the large positive-Z clipping box used by the donut envelope.
module donut_build_plate_cut() {
    // Include wall and overlap allowances beyond the nominal outside radius.
    outer_r = donut_outer_diameter / 2 + wall_thickness + link_overlap * 4;

    translate([0, 0, 500])
        cube([outer_r * 2.5, outer_r * 2.5, 1000], center = true);
}

// Builds a toroidal envelope with a flattened underside for round donut mode.
module donut_envelope() {
    intersection() {
        // Revolve a circular tube section around the donut centre radius and
        // lower it by flat_bottom_depth relative to the build plane.
        translate([0, 0, donut_tube_radius() - flat_bottom_depth])
            rotate_extrude($fn = preview_fn)
                translate([donut_center_radius(), 0, 0])
                    circle(r = donut_tube_radius(), $fn = preview_fn);

        // Keep only geometry at or above Z=0.
        donut_build_plate_cut();
    }
}

// Builds the complete untrimmed linear zig-zag wall.
// height is the Z extrusion and bottom_z is its starting elevation.
module full_height_wall_core(height, bottom_z) {
    // Ensure overlap is non-negative so adjacent links merge cleanly.
    overlap = max(0, link_overlap);

    // Union all zig-zag segment hulls into a single continuous wall core.
    union() {
        // Iterate over every segment of the zig-zag spring.
        for (i = [0 : zig_zags - 1]) {
            // Normalized position along the spring for the segment start.
            t1 = i / zig_zags;
            // Normalized position along the spring for the segment end.
            t2 = (i + 1) / zig_zags;
            // X coordinate of the segment start.
            x1 = t1 * spring_length;
            // Y coordinate of the segment start from the zig-zag function.
            y1 = spring_y(t1, wall_thickness);
            // X coordinate of the segment end.
            x2 = t2 * spring_length;
            // Y coordinate of the segment end from the zig-zag function.
            y2 = spring_y(t2, wall_thickness);
            // Delta in X between segment endpoints.
            dx = x2 - x1;
            // Delta in Y between segment endpoints.
            dy = y2 - y1;
            // Length of the segment, clamped to avoid division by zero.
            len = max(0.001, sqrt(dx * dx + dy * dy));
            // X component of the normalized segment direction.
            ux = dx / len;
            // Y component of the normalized segment direction.
            uy = dy / len;

            // Hull two cylinders at the segment endpoints to create a smooth link.
            hull() {
                translate([x1 - ux * overlap, y1 - uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
                translate([x2 + ux * overlap, y2 + uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
            }
        }
    }
}

// Produces the finished cylindrical spring by clipping an oversized wall core to
// the flattened lying-cylinder envelope.
module cylindrical_wall_spring() {
    r = cylinder_radius();

    intersection() {
        full_height_wall_core(r * 2 + 2, -1);
        lying_cylinder_envelope();
    }
}

// Builds a closed, untrimmed donut zig-zag wall around the Z axis.
module donut_wall_core(height, bottom_z) {
    // Enforce an even path count and sufficient overlap at every node.
    zz = make_even(zig_zags);
    overlap = max(0, link_overlap, wall_thickness * 0.25);
    joint_radius = wall_thickness / 2 + overlap;

    assert(
    donut_ring_thickness > wall_thickness + 2 * max(0, side_margin),
    "donut_ring_thickness is too small for wall_thickness and side_margin.");

    // Report automatic odd-to-even correction without altering the parameter.
    if (zig_zags != zz)
        echo(str("Warning: zig_zags must be even for donut_wall_core(); using ", zz, " instead of ", zig_zags, "."));

    union() {
        // Construct every ring segment from two alternating radial endpoints.
        for (i = [0 : zz - 1]) {
            // Convert normalized path positions to polar angles.
            t1 = i / zz;
            t2 = (i + 1) / zz;
            phi1 = t1 * 360;
            phi2 = t2 * 360;
            r1 = donut_center_radius() + donut_zigzag_y(t1, wall_thickness, zz);
            r2 = donut_center_radius() + donut_zigzag_y(t2, wall_thickness, zz);
            x1 = r1 * cos(phi1);
            y1 = r1 * sin(phi1);
            x2 = r2 * cos(phi2);
            y2 = r2 * sin(phi2);
            dx = x2 - x1;
            dy = y2 - y1;
            len = max(0.001, sqrt(dx * dx + dy * dy));
            ux = dx / len;
            uy = dy / len;

            // Extend both endpoint cylinders along the segment direction before
            // hulling them into an overlapping link.
            hull() {
                translate([x1 - ux * overlap, y1 - uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
                translate([x2 + ux * overlap, y2 + uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
            }
        }

        // Add enlarged cylinders at every node so all neighbouring link hulls
        // merge reliably, including the final-to-first loop closure.
        for (i = [0 : zz - 1]) {
            t = i / zz;
            phi = t * 360;
            r = donut_center_radius() + donut_zigzag_y(t, wall_thickness, zz);

            translate([r * cos(phi), r * sin(phi), bottom_z])
                cylinder(r = joint_radius, h = height);
        }
    }
}

// Selects the requested donut profile and debug boolean behaviour.
module donut_wall_spring() {
    if (donut_profile == "round") {
        if (show_donut_intersektion == false) {
            // Normal round mode clips the wall core to the toroidal envelope.
            intersection() {
                donut_wall_core(
                    height = donut_tube_radius() * 2 + 2,
                    bottom_z = -2
                );

                donut_envelope();
            }
        }
        else if (show_donut_intersektion) {
            // Debug mode preserves both complete solids as a union.
            union() {
                donut_wall_core(
                    height = donut_tube_radius() * 2 + 2,
                    bottom_z = -2
                );

                donut_envelope();
            }
        }
    } else {
        // Flat mode uses the untrimmed vertical extrusion directly.
        donut_wall_core(spring_height, 0);
    }
}

// Produces the legacy flat spring by clipping its wall core only at the build
// plane; no cylindrical side envelope is applied.
module original_wall_spring() {
    intersection() {
        full_height_wall_core(spring_height, 0);
        build_plate_cut(spring_max_width);
    }
}

// Top-level shape dispatcher and preview colour assignment.
color(spring_color)
if (spring_shape == "donut") {
    donut_wall_spring();
} else if (spring_shape == "cylinder") {
    cylindrical_wall_spring();
} else {
    original_wall_spring();
}
