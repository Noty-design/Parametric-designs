// Standalone flex spring / zig-zag body.
// The active cylindrical mode is a constant round cylinder lying along X,
// with the same thin zig-zag wall/sheet pattern clipped inside it.

/* [Spring shape] */
// Shape mode for the spring: "cylinder", "flat", or "donut".
spring_shape = "cylinder"; // ["cylinder", "flat", "donut"]
// Donut profile: flat sheet or round tube.
donut_profile = "flat"; // ["flat", "round"]
/* [Spring size] */
// Total length of the spring.
spring_length = 100;
// Diameter of the lying cylinder body.
spring_max_width = 26;
// Kept for compatibility with older presets; ignored in cylindrical mode.
spring_start_width = 14.5;
// Kept for compatibility with older presets; ignored in cylindrical mode.
spring_end_width = 8;
// Number of zig-zag wall elements. Donut mode uses an even number so the loop closes cleanly.
zig_zags = 46;

/* [Spring section] */
// Kept for compatibility with older presets. The wall design uses wall_thickness.
spring_diameter = 1.6;
// Height used only by the original non-cylindrical wall style.
spring_height = 11.5;
// Amount cut from the bottom of the cylinder for build-plate contact.
flat_bottom_depth = 0.45;
// Distance from cylinder side to zig-zag centerline.
side_margin = -1.1;

/* [Wall spring] */
// Thickness of the thin zig-zag walls/sheets.
wall_thickness = 1.1;
// Small overlap between neighboring links so STL export becomes one robust body.
link_overlap = 0.25;

/* [Round donut spring] */
// Outer diameter of the whole donut/ring.
donut_outer_diameter = 100;
// Thickness/diameter of the donut tube itself.
donut_ring_thickness = 10.1;
show_donut_intersektion = false;

/* [Preview] */
spring_color = "YellowGreen";
preview_fn = 16;
$fn = preview_fn;

function clamp(v, lo, hi) = min(max(v, lo), hi);
function make_even(n) = n + (n % 2);
function cylinder_radius() = max(0.1, spring_max_width / 2);

function donut_tube_radius() =
    max(wall_thickness / 2 + 0.01, donut_ring_thickness / 2);

function donut_outer_radius() =
    donut_outer_diameter / 2;

function donut_inner_radius() =
    max(0.01, donut_outer_radius() - donut_ring_thickness);

function donut_center_radius() =
    (donut_outer_radius() + donut_inner_radius()) / 2;

function donut_zigzag_amplitude(thickness) =
    max(
        0,
        donut_ring_thickness / 2 -  side_margin - thickness / 2
    );

function donut_zigzag_y(t, thickness, zags = make_even(zig_zags)) =
    let(
        i = round(t * zags),
        center_offset = donut_zigzag_amplitude(thickness)
    )
    ((i % 2 == 0) ? 1 : -1) * center_offset; // Small constant offset to help prevent self-intersection in the round tube profile.

function spring_y(t, thickness) =
    // Convert the normalized position t into a zig-zag index.
    let(
        i = round(t * zig_zags),
        // Compute how far from the cylinder center the zig-zag line should be.
        center_offset = max(thickness, cylinder_radius() - side_margin - thickness / 2)
    )
    // Alternate direction for each zig-zag segment and apply the computed offset.
    ((i % 2 == 0) ? 1 : -1) * center_offset;



module build_plate_cut(width = spring_max_width) {
    translate([spring_length / 2, 0, 500])
        cube([spring_length * 3, width * 3, 1000], center = true);
}

module lying_cylinder_envelope() {
    r = cylinder_radius();
    z_center = r - clamp(flat_bottom_depth, 0, r * 1.8);

    intersection() {
        translate([spring_length / 2, 0, z_center])
            rotate([0, 90, 0])
                cylinder(r = r, h = spring_length + wall_thickness + link_overlap * 4, center = true);
        build_plate_cut(spring_max_width);
    }
}

module donut_build_plate_cut() {
    outer_r = donut_outer_diameter / 2 + wall_thickness + link_overlap * 4;

    translate([0, 0, 500])
        cube([outer_r * 2.5, outer_r * 2.5, 1000], center = true);
}

module donut_envelope() {
    intersection() {
        translate([0, 0, donut_tube_radius() - flat_bottom_depth])
            rotate_extrude($fn = preview_fn)
                translate([donut_center_radius(), 0, 0])
                    circle(r = donut_tube_radius(), $fn = preview_fn);

        donut_build_plate_cut();
    }
}

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

module cylindrical_wall_spring() {
    r = cylinder_radius();

    intersection() {
        full_height_wall_core(r * 2 + 2, -1);
        lying_cylinder_envelope();
    }
}

module donut_wall_core(height, bottom_z) {
    zz = make_even(zig_zags);
    overlap = max(0, link_overlap, wall_thickness * 0.25);
    joint_radius = wall_thickness / 2 + overlap;

    assert(
    donut_ring_thickness > wall_thickness + 2 * max(0, side_margin),
    "donut_ring_thickness är för liten för wall_thickness och side_margin.");

    if (zig_zags != zz)
        echo(str("Warning: zig_zags must be even for donut_wall_core(); using ", zz, " instead of ", zig_zags, "."));

    union() {
        for (i = [0 : zz - 1]) {
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

            hull() {
                translate([x1 - ux * overlap, y1 - uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
                translate([x2 + ux * overlap, y2 + uy * overlap, bottom_z])
                    cylinder(r = wall_thickness / 2, h = height);
            }
        }

        for (i = [0 : zz - 1]) {
            t = i / zz;
            phi = t * 360;
            r = donut_center_radius() + donut_zigzag_y(t, wall_thickness, zz);

            translate([r * cos(phi), r * sin(phi), bottom_z])
                cylinder(r = joint_radius, h = height);
        }
    }
}

module donut_wall_spring() {
    if (donut_profile == "round") {
        if (show_donut_intersektion == false) {
            intersection() {
                donut_wall_core(
                    height = donut_tube_radius() * 2 + 2,
                    bottom_z = -2
                );

                donut_envelope();
            }
        }
        else if (show_donut_intersektion) {
            union() {
                donut_wall_core(
                    height = donut_tube_radius() * 2 + 2,
                    bottom_z = -2
                );

                donut_envelope();
            }
        }
    } else {
        donut_wall_core(spring_height, 0);
    }
}

module original_wall_spring() {
    intersection() {
        full_height_wall_core(spring_height, 0);
        build_plate_cut(spring_max_width);
    }
}

color(spring_color)
if (spring_shape == "donut") {
    donut_wall_spring();
} else if (spring_shape == "cylinder") {
    cylindrical_wall_spring();
} else {
    original_wall_spring();
}
