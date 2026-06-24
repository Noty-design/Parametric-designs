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

/* [Connector Systems] */
// Use the original loose peg and socket system
use_socket_pegs = true;
// Use loose internal dovetail keys on the inside of vertical radial seams
use_inner_dovetail_keys = true;
// Add small snap-retention dimples for the loose internal dovetail keys
use_inner_snap_locks = false;

/* [Separate Peg Connectors] */
// Peg radius; matching sockets include clearance automatically
connector_radius = 3;     // [1.5:0.25:8]
// Length of each loose connector peg
connector_length = 18;    // [8:1:50]
// Extra clearance added to socket holes
connector_clearance = 0.25; // [0:0.05:1.5]
// Number of vertical pegs along each horizontal seam per section
vertical_pegs_per_section = 2; // [1:1:5]
// Number of side pegs along each vertical seam per section
side_pegs_per_section = 2; // [1:1:5]
// Keep socket holes centered in the pot wall thickness
socket_auto_center = true;
// Manual radial adjustment for all socket holes. Positive moves holes outward, negative moves inward.
socket_radial_offset = 0; // [-20:0.5:20]
// Manual angular adjustment for vertical peg holes on horizontal seams.
vertical_socket_angle_offset = 0; // [-30:0.5:30]
// Extra radial adjustment for vertical peg holes on horizontal seams only.
vertical_socket_radial_offset = 0; // [-20:0.5:20]
// Tangential adjustment for vertical peg holes on horizontal seams only.
vertical_socket_tangent_offset = 0; // [-20:0.5:20]
// Extra radial adjustment for side sockets only. Positive moves holes outward, negative moves inward.
side_socket_radial_offset = 0; // [-20:0.5:20]
// Tangential adjustment for side sockets only. Positive moves the socket center along the seam direction.
side_socket_tangent_offset = 0; // [-20:0.5:20]
// Manual height adjustment for side seam sockets. Positive moves holes upward.
side_socket_z_offset = 0; // [-30:0.5:30]
// Manual angle adjustment for side sockets only.
side_socket_axis_angle_offset = 0; // [-30:0.5:30]
// Show loose printable pegs next to the pot
show_loose_pegs = true;

/* [Inner Dovetail Keys] */
// Number of loose inner keys per vertical radial seam and height section
inner_keys_per_vertical_seam = 1; // [1:1:5]
// Width of each loose inner key across the seam
inner_key_width = 16; // [6:1:40]
// Height of each loose inner key
inner_key_height = 28; // [8:1:80]
// Depth of the internal dovetail pocket into the pot wall
inner_key_depth = 3; // [1:0.5:10]
// Clearance added to the recessed pocket around the loose key
inner_key_clearance = 0.35; // [0:0.05:1.5]
// Dovetail taper ratio. Smaller top makes the key more dovetail-like.
inner_key_top_width_ratio = 0.65; // [0.3:0.05:1]
// Keep keys away from horizontal section boundaries
inner_key_z_margin = 8; // [0:1:40]
// Radial adjustment for the internal dovetail pockets and keys
inner_key_radial_offset = 0; // [-10:0.5:10]
// Tangential adjustment along the seam plane
inner_key_tangent_offset = 0; // [-10:0.5:10]
// Show loose printable inner keys next to the pot
show_inner_keys = true;

/* [Inner Snap Retention] */
// Radius of the small retention bumps on loose inner keys
inner_snap_radius = 1.0; // [0.3:0.1:3]
// How far the snap bump protrudes into its matching recess
inner_snap_depth = 0.45; // [0.1:0.05:1.5]
// Extra clearance for the snap recesses in the pot wall
inner_snap_clearance = 0.25; // [0:0.05:1]
// Position of snap bumps along the key height
inner_snap_position_fraction = 0.32; // [0.15:0.05:0.45]

/* [Display] */
// Separate sections slightly in assembled view
explode_distance = 10;    // [0:1:100]
// Display mode
display_mode = "assembled"; // [assembled, print_layout, single_piece, pegs_only, inner_keys_only]
// Radial section shown in single_piece mode
single_piece_radial_index = 0; // [0:1:15]
// Height section shown in single_piece mode
single_piece_height_index = 0; // [0:1:9]

/* [Colors] */
piece_color_1 = "#4E79A7"; // 7
piece_color_2 = "#F28E2B"; // 7
piece_color_3 = "#59A14F"; // 7
piece_color_4 = "#B07AA1"; // 7
peg_color = "#DDDDDD";     // 7
inner_key_color = "#CCCCCC"; // 7
$fn = 48;

effective_wall_thickness = min(wall_thickness, pot_bottom_radius - 6);
effective_lip_transition_height = min(lip_transition_height, max(0, pot_height - lip_height - bottom_thickness));
effective_connector_radius = min(connector_radius, effective_wall_thickness * 0.38);
effective_inner_key_depth = min(inner_key_depth, effective_wall_thickness * 0.7);
socket_radius = effective_connector_radius + connector_clearance;
outer_preview_radius = max(pot_top_radius + lip_width + 20, pot_bottom_radius + 20);

function radius_at_height(height_value) = pot_bottom_radius + (pot_top_radius - pot_bottom_radius) * (height_value / pot_height);
function inner_radius_at_height(height_value) = max(1, radius_at_height(height_value) - effective_wall_thickness);
function socket_center_radius(height_value) = radius_at_height(height_value) - (socket_auto_center ? effective_wall_thickness * 0.5 : 0) + socket_radial_offset;
function vertical_socket_center_radius(height_value) = socket_center_radius(height_value) + vertical_socket_radial_offset;
function side_socket_center_radius(height_value) = socket_center_radius(height_value) + side_socket_radial_offset;
function inner_key_center_radius(height_value, pocket_clearance = 0) = inner_radius_at_height(height_value) + (effective_inner_key_depth + pocket_clearance) * 0.5 + inner_key_radial_offset;
function piece_color(radial_index, height_index) =
    ((radial_index + height_index) % 4 == 0) ? piece_color_1 :
    ((radial_index + height_index) % 4 == 1) ? piece_color_2 :
    ((radial_index + height_index) % 4 == 2) ? piece_color_3 : piece_color_4;

function vertical_joint_peg_count() = use_socket_pegs ? radial_pieces * max(0, height_pieces - 1) * ((radial_pieces <= 1) ? max(3, vertical_pegs_per_section * 2) : vertical_pegs_per_section) : 0;
function side_joint_peg_count() = (use_socket_pegs && radial_pieces > 1) ? radial_pieces * height_pieces * side_pegs_per_section : 0;
function total_loose_peg_count() = vertical_joint_peg_count() + side_joint_peg_count();
function total_inner_key_count() = (use_inner_dovetail_keys && radial_pieces > 1) ? radial_pieces * height_pieces * inner_keys_per_vertical_seam : 0;

module rounded_dowel(dowel_radius, dowel_length) {
    rotate([0, 90, 0])
        union() {
            cylinder(r = dowel_radius, h = dowel_length, center = true, $fn = 40);
            translate([0, 0, dowel_length / 2]) sphere(r = dowel_radius, $fn = 40);
            translate([0, 0, -dowel_length / 2]) sphere(r = dowel_radius, $fn = 40);
        }
}

module vertical_dowel(dowel_radius, dowel_length) {
    union() {
        cylinder(r = dowel_radius, h = dowel_length, center = true, $fn = 40);
        translate([0, 0, dowel_length / 2]) sphere(r = dowel_radius, $fn = 40);
        translate([0, 0, -dowel_length / 2]) sphere(r = dowel_radius, $fn = 40);
    }
}

module dovetail_key_body(key_width, key_depth, key_height, clearance = 0) {
    bottom_width = key_width + clearance * 2;
    top_width = key_width * inner_key_top_width_ratio + clearance * 2;
    depth_value = key_depth + clearance * 2;
    linear_extrude(height = key_height + clearance * 2, center = true)
        polygon([
            [-depth_value / 2, -bottom_width / 2],
            [ depth_value / 2, -top_width / 2],
            [ depth_value / 2,  top_width / 2],
            [-depth_value / 2,  bottom_width / 2]
        ]);
}

module loose_inner_key() {
    union() {
        dovetail_key_body(inner_key_width, effective_inner_key_depth, inner_key_height, 0);
        if (use_inner_snap_locks) {
            for (z_sign = [-1, 1]) {
                translate([effective_inner_key_depth / 2 + inner_snap_depth * 0.5, 0, z_sign * inner_key_height * inner_snap_position_fraction])
                    sphere(r = inner_snap_radius, $fn = 24);
            }
        }
    }
}

module inner_key_recess_at(seam_angle, key_z) {
    recess_clearance = inner_key_clearance;
    recess_radius = inner_key_center_radius(key_z, recess_clearance);
    translate([
        recess_radius * cos(seam_angle) + inner_key_tangent_offset * cos(seam_angle + 90),
        recess_radius * sin(seam_angle) + inner_key_tangent_offset * sin(seam_angle + 90),
        key_z
    ])
        rotate([0, 0, seam_angle])
            dovetail_key_body(inner_key_width, effective_inner_key_depth, inner_key_height, recess_clearance);
}

module inner_snap_recesses_at(seam_angle, key_z) {
    if (use_inner_snap_locks) {
        recess_radius = inner_key_center_radius(key_z, inner_key_clearance);
        for (z_sign = [-1, 1]) {
            translate([
                recess_radius * cos(seam_angle) + inner_key_tangent_offset * cos(seam_angle + 90),
                recess_radius * sin(seam_angle) + inner_key_tangent_offset * sin(seam_angle + 90),
                key_z + z_sign * inner_key_height * inner_snap_position_fraction
            ])
                rotate([0, 90, seam_angle])
                    cylinder(r = inner_snap_radius + inner_snap_clearance, h = inner_snap_depth + inner_key_clearance + 1.0, center = true, $fn = 24);
        }
    }
}

module main_pot_shell() {
    difference() {
        union() {
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

            if (lip_width > 0 && lip_height > 0) {
                translate([0, 0, pot_height - lip_height])
                    cylinder(r = pot_top_radius + lip_width, h = lip_height);
            }
        }

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
        angle_step = max(2, (angle_end - angle_start) / 12);
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

module vertical_socket_holes_for_section(radial_index, height_index) {
    // Loose vertical dowels fit into matching top/bottom sockets between stacked sections.
    if (use_socket_pegs && height_pieces > 1) {
        for (seam_direction = [-1, 1]) {
            seam_z = (seam_direction < 0) ? height_index * pot_height / height_pieces : (height_index + 1) * pot_height / height_pieces;
            if (seam_z > 0 && seam_z < pot_height) {
                seam_radius = vertical_socket_center_radius(seam_z);
                peg_count = (radial_pieces <= 1) ? max(3, vertical_pegs_per_section * 2) : vertical_pegs_per_section;
                for (peg_number = [1 : peg_count]) {
                    local_fraction = peg_number / (peg_count + 1);
                    section_angle = 360 / max(1, radial_pieces);
                    section_start_angle = radial_index * section_angle;
                    peg_angle = section_start_angle + local_fraction * section_angle + vertical_socket_angle_offset;
                    translate([
                        seam_radius * cos(peg_angle) + vertical_socket_tangent_offset * cos(peg_angle + 90),
                        seam_radius * sin(peg_angle) + vertical_socket_tangent_offset * sin(peg_angle + 90),
                        seam_z
                    ])
                        vertical_dowel(socket_radius, connector_length + 0.4);
                }
            }
        }
    }
}

module side_socket_holes_for_section(radial_index, height_index) {
    // Loose horizontal dowels bridge the vertical radial seams.
    if (use_socket_pegs && radial_pieces > 1) {
        for (side_selector = [0, 1]) {
            seam_angle = (radial_index + side_selector) * 360 / radial_pieces;
            for (peg_number = [1 : side_pegs_per_section]) {
                local_fraction = peg_number / (side_pegs_per_section + 1);
                section_height = pot_height / height_pieces;
                peg_z = height_index * section_height + local_fraction * section_height + side_socket_z_offset;
                peg_z_safe = min(pot_height - socket_radius - 0.2, max(socket_radius + 0.2, peg_z));
                peg_radius_from_center = side_socket_center_radius(peg_z_safe);
                translate([
                    peg_radius_from_center * cos(seam_angle) + side_socket_tangent_offset * cos(seam_angle + 90),
                    peg_radius_from_center * sin(seam_angle) + side_socket_tangent_offset * sin(seam_angle + 90),
                    peg_z_safe
                ])
                    rotate([0, 0, seam_angle + 90 + side_socket_axis_angle_offset])
                        rounded_dowel(socket_radius, connector_length + 0.4);
            }
        }
    }
}

module inner_key_recesses_for_section(radial_index, height_index) {
    if (use_inner_dovetail_keys && radial_pieces > 1) {
        section_height = pot_height / height_pieces;
        usable_height = max(1, section_height - inner_key_z_margin * 2);
        for (side_selector = [0, 1]) {
            seam_angle = (radial_index + side_selector) * 360 / radial_pieces;
            for (key_number = [1 : inner_keys_per_vertical_seam]) {
                local_fraction = key_number / (inner_keys_per_vertical_seam + 1);
                raw_key_z = height_index * section_height + inner_key_z_margin + local_fraction * usable_height;
                key_z = min(pot_height - inner_key_height / 2 - 0.2, max(inner_key_height / 2 + 0.2, raw_key_z));
                inner_key_recess_at(seam_angle, key_z);
                inner_snap_recesses_at(seam_angle, key_z);
            }
        }
    }
}

module modular_section(radial_index, height_index) {
    difference() {
        intersection() {
            main_pot_shell();
            radial_cut_volume(radial_index);
            height_cut_volume(height_index);
        }
        vertical_socket_holes_for_section(radial_index, height_index);
        side_socket_holes_for_section(radial_index, height_index);
        inner_key_recesses_for_section(radial_index, height_index);
    }
}

module loose_connector_pegs() {
    total_peg_count = total_loose_peg_count();
    if (total_peg_count > 0) {
        columns = ceil(sqrt(total_peg_count));
        spacing = connector_length + effective_connector_radius * 5;
        for (peg_index = [0 : total_peg_count - 1]) {
            x_position = (peg_index % columns) * spacing;
            y_position = floor(peg_index / columns) * spacing;
            translate([x_position, y_position, effective_connector_radius])
                color(peg_color)
                    rounded_dowel(effective_connector_radius, connector_length);
        }
    }
}

module loose_inner_keys() {
    key_count = total_inner_key_count();
    if (key_count > 0) {
        columns = ceil(sqrt(key_count));
        spacing_x = inner_key_width + 8;
        spacing_y = inner_key_height + 8;
        for (key_index = [0 : key_count - 1]) {
            x_position = (key_index % columns) * spacing_x;
            y_position = floor(key_index / columns) * spacing_y;
            translate([x_position, y_position, inner_key_height / 2])
                rotate([90, 0, 0])
                    color(inner_key_color)
                        loose_inner_key();
        }
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
    if (show_loose_pegs && use_socket_pegs) {
        translate([outer_preview_radius * 1.65, -outer_preview_radius * 0.7, 0])
            loose_connector_pegs();
    }
    if (show_inner_keys && use_inner_dovetail_keys) {
        translate([outer_preview_radius * 1.65, outer_preview_radius * 0.35, 0])
            loose_inner_keys();
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
    rows = ceil(total_sections / columns);
    if (show_loose_pegs && use_socket_pegs) {
        translate([0, rows * layout_spacing + connector_length, 0])
            loose_connector_pegs();
    }
    if (show_inner_keys && use_inner_dovetail_keys) {
        translate([outer_preview_radius, rows * layout_spacing + connector_length, 0])
            loose_inner_keys();
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
    if (show_loose_pegs && use_socket_pegs) {
        translate([outer_preview_radius * 0.9, 0, 0])
            loose_connector_pegs();
    }
    if (show_inner_keys && use_inner_dovetail_keys) {
        translate([outer_preview_radius * 0.9, outer_preview_radius * 0.35, 0])
            loose_inner_keys();
    }
}

if (display_mode == "print_layout") {
    print_layout();
} else if (display_mode == "single_piece") {
    selected_single_piece();
} else if (display_mode == "pegs_only") {
    loose_connector_pegs();
} else if (display_mode == "inner_keys_only") {
    loose_inner_keys();
} else {
    assembled_pot();
}
