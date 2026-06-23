/* [Dimensions] */
// Top outside radius of the pot wall below the lip
pot_top_radius = 100;     // [30:5:300]
// Bottom outside radius of the pot
pot_bottom_radius = 70;   // [20:5:250]
// Total assembled height of the pot
pot_height = 150;         // [50:5:400]
// Printable wall thickness
wall_thickness = 10;      // [4:1:30]
// Thickness of the bottom base
bottom_thickness = 8;     // [2:1:30]
// Radius of the center drain hole, set to 0 for no hole
drain_hole_radius = 15;   // [0:1:50]

/* [Smooth Rim and Lip] */
// Extra outward width of the reinforced rim lip
lip_width = 8;            // [0:1:40]
// Vertical height of the straight upper lip band
lip_height = 10;          // [0:1:50]
// Height of the outside ramp into the lip for support-free printing
lip_transition_height = 14; // [0:1:60]
// Small inside bevel at the mouth of the pot
inner_rim_bevel = 3;      // [0:0.5:12]

/* [Sections] */
// Number of attachable sections around the circumference
radial_pieces = 4;        // [1:1:16]
// Number of attachable sections stacked in height
height_pieces = 3;        // [1:1:10]

/* [Connectors] */
// Extra clearance around receiving sockets
clearance = 0.25;         // [0:0.05:1.5]
// Connector peg radius
connector_radius = 3;     // [1.5:0.25:8]

/* [Display] */
// Separate sections slightly in assembled view
explode_distance = 10;    // [0:1:100]
// Display mode
display_mode = "assembled"; // [assembled, print_layout, single_piece]
// Radial section shown in single_piece mode
single_piece_radial_index = 0; // [0:1:15]
// Height section shown in single_piece mode
single_piece_height_index = 0; // [0:1:9]

/* [Colors] */
piece_color_1 = "#4E79A7"; // 7
piece_color_2 = "#F28E2B"; // 7
piece_color_3 = "#59A14F"; // 7
piece_color_4 = "#B07AA1"; // 7
$fn = 44;

effective_wall_thickness = min(wall_thickness, pot_bottom_radius - 6);
effective_lip_transition_height = min(lip_transition_height, max(0, pot_height - lip_height - bottom_thickness));
effective_connector_radius = min(connector_radius, effective_wall_thickness * 0.38);
outer_preview_radius = max(pot_top_radius + lip_width + 20, pot_bottom_radius + 20);

function radius_at_height(height_value) = pot_bottom_radius + (pot_top_radius - pot_bottom_radius) * (height_value / pot_height);
function piece_color(radial_index, height_index) =
    ((radial_index + height_index) % 4 == 0) ? piece_color_1 :
    ((radial_index + height_index) % 4 == 1) ? piece_color_2 :
    ((radial_index + height_index) % 4 == 2) ? piece_color_3 : piece_color_4;

module main_pot_shell() {
    difference() {
        union() {
            // Main tapered pot wall.
            cylinder(r1 = pot_bottom_radius, r2 = pot_top_radius, h = pot_height);

            // Smooth outside ramp leading into the lip, avoiding a support-needing ledge.
            if (lip_width > 0 && effective_lip_transition_height > 0) {
                transition_start_z = pot_height - lip_height - effective_lip_transition_height;
                translate([0, 0, transition_start_z])
                    cylinder(
                        r1 = radius_at_height(transition_start_z),
                        r2 = pot_top_radius + lip_width,
                        h = effective_lip_transition_height
                    );
            }

            // Straight reinforced lip band at the top.
            if (lip_width > 0 && lip_height > 0) {
                translate([0, 0, pot_height - lip_height])
                    cylinder(r = pot_top_radius + lip_width, h = lip_height);
            }
        }

        // Hollow interior with a slight inward bevel at the rim for a softer printable edge.
        translate([0, 0, bottom_thickness])
            cylinder(
                r1 = max(1, pot_bottom_radius - effective_wall_thickness),
                r2 = max(1, pot_top_radius - effective_wall_thickness - inner_rim_bevel),
                h = max(1, pot_height - bottom_thickness + 0.02)
            );
        if (inner_rim_bevel > 0) {
            translate([0, 0, pot_height - inner_rim_bevel])
                cylinder(
                    r1 = max(1, pot_top_radius - effective_wall_thickness - inner_rim_bevel),
                    r2 = max(1, pot_top_radius - effective_wall_thickness),
                    h = inner_rim_bevel + 0.04
                );
        }

        // Drainage hole in the base.
        if (drain_hole_radius > 0) {
            translate([0, 0, -1])
                cylinder(r = min(drain_hole_radius, max(1, pot_bottom_radius - effective_wall_thickness - 2)), h = bottom_thickness + 2);
        }
    }
}

module radial_cut_volume(radial_index) {
    if (radial_pieces <= 1) {
        translate([0, 0, -1]) cylinder(r = outer_preview_radius * 3, h = pot_height + 2, $fn = 48);
    } else {
        angle_start = radial_index * 360 / radial_pieces;
        angle_end = (radial_index + 1) * 360 / radial_pieces;
        angle_step = max(2, (angle_end - angle_start) / 10);
        polygon_points = concat(
            [[0, 0]],
            [for (current_angle = [angle_start : angle_step : angle_end])
                [outer_preview_radius * 3 * cos(current_angle), outer_preview_radius * 3 * sin(current_angle)]],
            [[outer_preview_radius * 3 * cos(angle_end), outer_preview_radius * 3 * sin(angle_end)]]
        );
        translate([0, 0, -1])
            linear_extrude(height = pot_height + 2)
                polygon(polygon_points);
    }
}

module height_cut_volume(height_index) {
    z_start = height_index * pot_height / height_pieces;
    z_end = (height_index + 1) * pot_height / height_pieces;
    translate([0, 0, z_start])
        cylinder(r = outer_preview_radius * 3, h = z_end - z_start, $fn = 48);
}

module vertical_stack_pegs(radial_index, height_index, socket = false) {
    if (height_index < height_pieces - 1) {
        seam_z = (height_index + 1) * pot_height / height_pieces;
        seam_radius = radius_at_height(seam_z) - effective_wall_thickness * 0.5;
        peg_count = (radial_pieces <= 1) ? 4 : 2;
        for (peg_number = [1 : peg_count]) {
            local_fraction = peg_number / (peg_count + 1);
            peg_angle = radial_index * 360 / max(1, radial_pieces) + local_fraction * 360 / max(1, radial_pieces);
            translate([seam_radius * cos(peg_angle), seam_radius * sin(peg_angle), seam_z])
                sphere(r = effective_connector_radius + (socket ? clearance : 0), $fn = 32);
        }
    }
}

module vertical_stack_sockets(radial_index, height_index) {
    if (height_index > 0) {
        vertical_stack_pegs(radial_index, height_index - 1, true);
    }
}

module radial_side_pegs(radial_index, height_index, socket = false) {
    if (radial_pieces > 1) {
        seam_angle = (radial_index + 1) * 360 / radial_pieces;
        peg_count = 2;
        for (peg_number = [1 : peg_count]) {
            local_fraction = peg_number / (peg_count + 1);
            peg_z = height_index * pot_height / height_pieces + local_fraction * pot_height / height_pieces;
            peg_radius_from_center = radius_at_height(peg_z) - effective_wall_thickness * 0.5;
            translate([peg_radius_from_center * cos(seam_angle), peg_radius_from_center * sin(seam_angle), peg_z])
                sphere(r = effective_connector_radius + (socket ? clearance : 0), $fn = 32);
        }
    }
}

module radial_side_sockets(radial_index, height_index) {
    if (radial_pieces > 1) {
        previous_radial_index = (radial_index + radial_pieces - 1) % radial_pieces;
        radial_side_pegs(previous_radial_index, height_index, true);
    }
}

module modular_section(radial_index, height_index) {
    difference() {
        union() {
            intersection() {
                main_pot_shell();
                radial_cut_volume(radial_index);
                height_cut_volume(height_index);
            }
            vertical_stack_pegs(radial_index, height_index, false);
            radial_side_pegs(radial_index, height_index, false);
        }
        vertical_stack_sockets(radial_index, height_index);
        radial_side_sockets(radial_index, height_index);
    }
}

module assembled_pot() {
    for (height_index = [0 : height_pieces - 1]) {
        for (radial_index = [0 : radial_pieces - 1]) {
            middle_angle = (radial_pieces > 1) ? (radial_index + 0.5) * 360 / radial_pieces : 0;
            radial_explode = (radial_pieces > 1) ? explode_distance : 0;
            translate([
                radial_explode * cos(middle_angle),
                radial_explode * sin(middle_angle),
                height_index * explode_distance
            ])
                color(piece_color(radial_index, height_index))
                    modular_section(radial_index, height_index);
        }
    }
}

module print_layout() {
    total_sections = radial_pieces * height_pieces;
    columns = ceil(sqrt(total_sections));
    layout_spacing = (pot_top_radius + lip_width) * 2.7;
    for (height_index = [0 : height_pieces - 1]) {
        for (radial_index = [0 : radial_pieces - 1]) {
            section_index = height_index * radial_pieces + radial_index;
            x_position = (section_index % columns) * layout_spacing;
            y_position = floor(section_index / columns) * layout_spacing;
            section_start_z = height_index * pot_height / height_pieces;
            middle_angle = (radial_pieces > 1) ? (radial_index + 0.5) * 360 / radial_pieces : 0;
            translate([x_position, y_position, -section_start_z])
                rotate([0, 0, -middle_angle])
                    color(piece_color(radial_index, height_index))
                        modular_section(radial_index, height_index);
        }
    }
}

module selected_single_piece() {
    selected_radial = min(single_piece_radial_index, radial_pieces - 1);
    selected_height = min(single_piece_height_index, height_pieces - 1);
    section_start_z = selected_height * pot_height / height_pieces;
    middle_angle = (radial_pieces > 1) ? (selected_radial + 0.5) * 360 / radial_pieces : 0;
    translate([0, 0, -section_start_z])
        rotate([0, 0, -middle_angle])
            color(piece_color(selected_radial, selected_height))
                modular_section(selected_radial, selected_height);
}

if (display_mode == "print_layout") {
    print_layout();
} else if (display_mode == "single_piece") {
    selected_single_piece();
} else {
    assembled_pot();
}
