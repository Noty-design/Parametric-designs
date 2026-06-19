// Standalone flex spring / zig-zag body.
// The active cylindrical mode is a constant round cylinder lying along X,
// with the same thin zig-zag wall/sheet pattern clipped inside it.

/* [Spring size] */
// Total length of the spring.
spring_length = 100;
// Diameter of the lying cylinder body.
spring_max_width = 26;
// Kept for compatibility with older presets; ignored in cylindrical mode.
spring_start_width = 14.5;
// Kept for compatibility with older presets; ignored in cylindrical mode.
spring_end_width = 8;
// Number of zig-zag wall elements.
zig_zags = 45;

/* [Spring section] */
// Kept for compatibility with older presets. The wall design uses wall_thickness.
spring_diameter = 1.6;
// Height used only by the original non-cylindrical wall style.
spring_height = 11.5;
// true: round lying cylinder with zig-zag walls. false: old flat wall style.
cylindrical_shape = true;
// Amount cut from the bottom of the cylinder for build-plate contact.
flat_bottom_depth = 0.45;
// Distance from cylinder side to zig-zag centerline.
side_margin = 1.0;

/* [Wall spring] */
// Thickness of the thin zig-zag walls/sheets.
wall_thickness = 0.8;
// Small overlap between neighboring links so STL export becomes one robust body.
link_overlap = 0.15;

/* [Preview] */
spring_color = "YellowGreen";
preview_fn = 16;
$fn = preview_fn;

function clamp(v, lo, hi) = min(max(v, lo), hi);
function cylinder_radius() = max(0.1, spring_max_width / 2);
function spring_y(t, thickness) =
    let(
        i = round(t * zig_zags),
        center_offset = max(thickness, cylinder_radius() - max(0, side_margin) - thickness / 2)
    )
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

module full_height_wall_core(height, bottom_z) {
    overlap = max(0, link_overlap);

    union() {
        for (i = [0 : zig_zags - 1]) {
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

module original_wall_spring() {
    intersection() {
        full_height_wall_core(spring_height, 0);
        build_plate_cut(spring_max_width);
    }
}

color(spring_color)
if (cylindrical_shape) {
    cylindrical_wall_spring();
} else {
    original_wall_spring();
}
