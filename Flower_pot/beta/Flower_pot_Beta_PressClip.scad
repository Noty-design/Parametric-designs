/* [Dimensions] */
pot_top_radius = 100;     // [30:5:300]
pot_bottom_radius = 70;   // [20:5:250]
pot_height = 150;         // [50:5:400]
wall_thickness = 10;      // [4:1:30]
bottom_thickness = 8;     // [2:1:30]
drain_hole_radius = 15;   // [0:1:50]

/* [Smooth Rim and Lip] */
lip_width = 8;            // [0:1:40]
lip_height = 10;          // [0:1:50]
lip_transition_height = 14; // [0:1:60]
inner_rim_bevel = 3;      // [0:0.5:12]

/* [Sections] */
radial_pieces = 4;        // [1:1:16]
height_pieces = 3;        // [1:1:10]

/* [Connector Systems] */
use_socket_pegs = true;
use_inner_press_clips = true;
use_vertical_seam_press_clips = true;
use_horizontal_seam_press_clips = true;

/* [Separate Peg Connectors] */
connector_radius = 3;     // [1.5:0.25:8]
connector_length = 18;    // [8:1:50]
connector_clearance = 0.25; // [0:0.05:1.5]
vertical_pegs_per_section = 2; // [1:1:5]
side_pegs_per_section = 2; // [1:1:5]
socket_auto_center = true;
socket_radial_offset = 0; // [-20:0.5:20]
vertical_socket_angle_offset = 0; // [-30:0.5:30]
vertical_socket_radial_offset = 0; // [-20:0.5:20]
vertical_socket_tangent_offset = 0; // [-20:0.5:20]
vertical_socket_length_extra = 0.4; // [0:0.1:20]
side_socket_radial_offset = 0; // [-20:0.5:20]
side_socket_tangent_offset = 0; // [-20:0.5:20]
side_socket_z_offset = 0; // [-30:0.5:30]
side_socket_axis_angle_offset = 0; // [-30:0.5:30]
side_socket_length_extra = 0.4; // [0:0.1:20]
show_loose_pegs = true;

/* [Inner Press Dogbone Clips] */
press_clip_end_radius = 4; // [2:0.5:12]
press_clip_neck_width = 4; // [1.5:0.5:12]
press_clip_length = 24; // [10:1:70]
press_clip_depth = 2.5; // [1:0.5:8]
press_clip_clearance = 0.35; // [0:0.05:1.5]
press_clip_split_gap = 0.7; // [0:0.1:3]
press_clip_radial_offset = 0; // [-10:0.5:10]
press_clip_tangent_offset = 0; // [-10:0.5:10]
press_clip_angle_offset = 0; // [-30:0.5:30]
press_clip_z_margin = 10; // [0:1:40]
vertical_press_clips_per_seam = 1; // [1:1:5]
horizontal_press_clips_per_section = 1; // [1:1:5]
show_press_clips = true;

/* [Display] */
explode_distance = 10;    // [0:1:100]
display_mode = "assembled"; // [assembled, print_layout, single_piece, pegs_only, press_clips_only]
single_piece_radial_index = 0; // [0:1:15]
single_piece_height_index = 0; // [0:1:9]

/* [Colors] */
piece_color_1 = "#4E79A7"; // 7
piece_color_2 = "#F28E2B"; // 7
piece_color_3 = "#59A14F"; // 7
piece_color_4 = "#B07AA1"; // 7
peg_color = "#DDDDDD";     // 7
press_clip_color = "#CCCCCC"; // 7
$fn = 48;

effective_wall_thickness = min(wall_thickness, pot_bottom_radius - 6);
effective_lip_transition_height = min(lip_transition_height, max(0, pot_height - lip_height - bottom_thickness));
effective_connector_radius = min(connector_radius, effective_wall_thickness * 0.38);
effective_press_clip_depth = min(press_clip_depth, effective_wall_thickness * 0.65);
socket_radius = effective_connector_radius + connector_clearance;
outer_preview_radius = max(pot_top_radius + lip_width + 20, pot_bottom_radius + 20);

function radius_at_height(z) = pot_bottom_radius + (pot_top_radius - pot_bottom_radius) * (z / pot_height);
function inner_radius_at_height(z) = max(1, radius_at_height(z) - effective_wall_thickness);
function socket_center_radius(z) = radius_at_height(z) - (socket_auto_center ? effective_wall_thickness * 0.5 : 0) + socket_radial_offset;
function vertical_socket_center_radius(z) = socket_center_radius(z) + vertical_socket_radial_offset;
function side_socket_center_radius(z) = socket_center_radius(z) + side_socket_radial_offset;
function press_clip_center_radius(z, clearance = 0) = inner_radius_at_height(z) + (effective_press_clip_depth + clearance) * 0.5 + press_clip_radial_offset;
function piece_color(ri, hi) =
    ((ri + hi) % 4 == 0) ? piece_color_1 :
    ((ri + hi) % 4 == 1) ? piece_color_2 :
    ((ri + hi) % 4 == 2) ? piece_color_3 : piece_color_4;
function vertical_joint_peg_count() = use_socket_pegs ? radial_pieces * max(0, height_pieces - 1) * ((radial_pieces <= 1) ? max(3, vertical_pegs_per_section * 2) : vertical_pegs_per_section) : 0;
function side_joint_peg_count() = (use_socket_pegs && radial_pieces > 1) ? radial_pieces * height_pieces * side_pegs_per_section : 0;
function total_loose_peg_count() = vertical_joint_peg_count() + side_joint_peg_count();
function total_press_clip_count() = use_inner_press_clips ? ((use_vertical_seam_press_clips && radial_pieces > 1) ? radial_pieces * height_pieces * vertical_press_clips_per_seam : 0) + ((use_horizontal_seam_press_clips && height_pieces > 1) ? radial_pieces * (height_pieces - 1) * horizontal_press_clips_per_section : 0) : 0;

module rounded_dowel(r, len) {
    rotate([0, 90, 0]) union() {
        cylinder(r = r, h = len, center = true, $fn = 40);
        translate([0, 0, len / 2]) sphere(r = r, $fn = 40);
        translate([0, 0, -len / 2]) sphere(r = r, $fn = 40);
    }
}

module vertical_dowel(r, len) {
    union() {
        cylinder(r = r, h = len, center = true, $fn = 40);
        translate([0, 0, len / 2]) sphere(r = r, $fn = 40);
        translate([0, 0, -len / 2]) sphere(r = r, $fn = 40);
    }
}

module dogbone_2d(len, end_r, neck_w, clearance = 0) {
    er = end_r + clearance;
    nw = neck_w + clearance * 2;
    union() {
        translate([-len / 2, 0]) circle(r = er, $fn = 36);
        translate([ len / 2, 0]) circle(r = er, $fn = 36);
        square([len, nw], center = true);
    }
}

module press_clip_body(len = press_clip_length, end_r = press_clip_end_radius, neck_w = press_clip_neck_width, depth = effective_press_clip_depth, clearance = 0, orientation = "tangent", split_gap = press_clip_split_gap) {
    difference() {
        rotate([0, 90, 0])
            linear_extrude(height = depth + clearance * 2, center = true)
                if (orientation == "vertical")
                    dogbone_2d(len, end_r, neck_w, clearance);
                else
                    rotate([0, 0, 90]) dogbone_2d(len, end_r, neck_w, clearance);
        if (split_gap > 0 && clearance == 0) {
            if (orientation == "vertical") {
                for (s = [-1, 1])
                    translate([0, 0, s * len / 2]) cube([depth + 2, split_gap, end_r * 2.6], center = true);
            } else {
                for (s = [-1, 1])
                    translate([0, s * len / 2, 0]) cube([depth + 2, split_gap, end_r * 2.6], center = true);
            }
        }
    }
}

module main_pot_shell() {
    difference() {
        union() {
            cylinder(r1 = pot_bottom_radius, r2 = pot_top_radius, h = pot_height);
            if (lip_width > 0 && effective_lip_transition_height > 0) {
                transition_start_z = pot_height - lip_height - effective_lip_transition_height;
                translate([0, 0, transition_start_z])
                    cylinder(r1 = radius_at_height(transition_start_z), r2 = pot_top_radius + lip_width, h = effective_lip_transition_height);
            }
            if (lip_width > 0 && lip_height > 0)
                translate([0, 0, pot_height - lip_height]) cylinder(r = pot_top_radius + lip_width, h = lip_height);
        }
        translate([0, 0, bottom_thickness])
            cylinder(r1 = max(1, pot_bottom_radius - effective_wall_thickness), r2 = max(1, pot_top_radius - effective_wall_thickness - inner_rim_bevel), h = max(1, pot_height - bottom_thickness + 0.02));
        if (inner_rim_bevel > 0)
            translate([0, 0, pot_height - inner_rim_bevel])
                cylinder(r1 = max(1, pot_top_radius - effective_wall_thickness - inner_rim_bevel), r2 = max(1, pot_top_radius - effective_wall_thickness), h = inner_rim_bevel + 0.04);
        if (drain_hole_radius > 0)
            translate([0, 0, -1]) cylinder(r = min(drain_hole_radius, max(1, pot_bottom_radius - effective_wall_thickness - 2)), h = bottom_thickness + 2);
    }
}

module radial_cut_volume(ri) {
    if (radial_pieces <= 1) {
        translate([0, 0, -1]) cylinder(r = outer_preview_radius * 3, h = pot_height + 2, $fn = 48);
    } else {
        a0 = ri * 360 / radial_pieces;
        a1 = (ri + 1) * 360 / radial_pieces;
        astep = max(2, (a1 - a0) / 12);
        pts = concat([[0, 0]], [for (a = [a0 : astep : a1]) [outer_preview_radius * 3 * cos(a), outer_preview_radius * 3 * sin(a)]], [[outer_preview_radius * 3 * cos(a1), outer_preview_radius * 3 * sin(a1)]]);
        translate([0, 0, -1]) linear_extrude(height = pot_height + 2) polygon(pts);
    }
}

module height_cut_volume(hi) {
    z0 = hi * pot_height / height_pieces;
    z1 = (hi + 1) * pot_height / height_pieces;
    translate([0, 0, z0]) cylinder(r = outer_preview_radius * 3, h = z1 - z0, $fn = 48);
}

module vertical_socket_holes_for_section(ri, hi) {
    if (use_socket_pegs && height_pieces > 1) {
        for (sd = [-1, 1]) {
            seam_z = (sd < 0) ? hi * pot_height / height_pieces : (hi + 1) * pot_height / height_pieces;
            if (seam_z > 0 && seam_z < pot_height) {
                seam_radius = vertical_socket_center_radius(seam_z);
                count = (radial_pieces <= 1) ? max(3, vertical_pegs_per_section * 2) : vertical_pegs_per_section;
                for (pn = [1 : count]) {
                    frac = pn / (count + 1);
                    section_angle = 360 / max(1, radial_pieces);
                    a = ri * section_angle + frac * section_angle + vertical_socket_angle_offset;
                    translate([seam_radius * cos(a) + vertical_socket_tangent_offset * cos(a + 90), seam_radius * sin(a) + vertical_socket_tangent_offset * sin(a + 90), seam_z])
                        vertical_dowel(socket_radius, connector_length + vertical_socket_length_extra);
                }
            }
        }
    }
}

module side_socket_holes_for_section(ri, hi) {
    if (use_socket_pegs && radial_pieces > 1) {
        for (ss = [0, 1]) {
            a = (ri + ss) * 360 / radial_pieces;
            for (pn = [1 : side_pegs_per_section]) {
                frac = pn / (side_pegs_per_section + 1);
                section_height = pot_height / height_pieces;
                z = hi * section_height + frac * section_height + side_socket_z_offset;
                zsafe = min(pot_height - socket_radius - 0.2, max(socket_radius + 0.2, z));
                r = side_socket_center_radius(zsafe);
                translate([r * cos(a) + side_socket_tangent_offset * cos(a + 90), r * sin(a) + side_socket_tangent_offset * sin(a + 90), zsafe])
                    rotate([0, 0, a + 90 + side_socket_axis_angle_offset])
                        rounded_dowel(socket_radius, connector_length + side_socket_length_extra);
            }
        }
    }
}

module vertical_press_clip_recesses_for_section(ri, hi) {
    if (use_inner_press_clips && use_vertical_seam_press_clips && radial_pieces > 1) {
        section_height = pot_height / height_pieces;
        usable_height = max(1, section_height - press_clip_z_margin * 2);
        for (ss = [0, 1]) {
            seam_angle = (ri + ss) * 360 / radial_pieces;
            for (kn = [1 : vertical_press_clips_per_seam]) {
                frac = kn / (vertical_press_clips_per_seam + 1);
                z = hi * section_height + press_clip_z_margin + frac * usable_height;
                r = press_clip_center_radius(z, press_clip_clearance);
                translate([r * cos(seam_angle) + press_clip_tangent_offset * cos(seam_angle + 90), r * sin(seam_angle) + press_clip_tangent_offset * sin(seam_angle + 90), z])
                    rotate([0, 0, seam_angle])
                        press_clip_body(clearance = press_clip_clearance, orientation = "tangent", split_gap = 0);
            }
        }
    }
}

module horizontal_press_clip_recesses_for_section(ri, hi) {
    if (use_inner_press_clips && use_horizontal_seam_press_clips && height_pieces > 1) {
        for (sd = [-1, 1]) {
            seam_z = (sd < 0) ? hi * pot_height / height_pieces : (hi + 1) * pot_height / height_pieces;
            if (seam_z > 0 && seam_z < pot_height) {
                section_angle = 360 / max(1, radial_pieces);
                for (kn = [1 : horizontal_press_clips_per_section]) {
                    frac = kn / (horizontal_press_clips_per_section + 1);
                    a = ri * section_angle + frac * section_angle + press_clip_angle_offset;
                    r = press_clip_center_radius(seam_z, press_clip_clearance);
                    translate([r * cos(a) + press_clip_tangent_offset * cos(a + 90), r * sin(a) + press_clip_tangent_offset * sin(a + 90), seam_z])
                        rotate([0, 0, a])
                            press_clip_body(clearance = press_clip_clearance, orientation = "vertical", split_gap = 0);
                }
            }
        }
    }
}

module modular_section(ri, hi) {
    difference() {
        intersection() {
            main_pot_shell();
            radial_cut_volume(ri);
            height_cut_volume(hi);
        }
        vertical_socket_holes_for_section(ri, hi);
        side_socket_holes_for_section(ri, hi);
        vertical_press_clip_recesses_for_section(ri, hi);
        horizontal_press_clip_recesses_for_section(ri, hi);
    }
}

module loose_connector_pegs() {
    n = total_loose_peg_count();
    if (n > 0) {
        cols = ceil(sqrt(n));
        spacing = connector_length + effective_connector_radius * 5;
        for (i = [0 : n - 1])
            translate([(i % cols) * spacing, floor(i / cols) * spacing, effective_connector_radius])
                color(peg_color) rounded_dowel(effective_connector_radius, connector_length);
    }
}

module loose_press_clips() {
    n = total_press_clip_count();
    if (n > 0) {
        cols = ceil(sqrt(n));
        spacing_x = press_clip_length + press_clip_end_radius * 3;
        spacing_y = press_clip_end_radius * 5;
        for (i = [0 : n - 1])
            translate([(i % cols) * spacing_x, floor(i / cols) * spacing_y, effective_press_clip_depth / 2])
                color(press_clip_color) press_clip_body(split_gap = press_clip_split_gap);
    }
}

module assembled_pot() {
    for (hi = [0 : height_pieces - 1]) {
        for (ri = [0 : radial_pieces - 1]) {
            mid = (radial_pieces > 1) ? (ri + 0.5) * 360 / radial_pieces : 0;
            rex = (radial_pieces > 1) ? explode_distance : 0;
            translate([rex * cos(mid), rex * sin(mid), hi * explode_distance])
                color(piece_color(ri, hi)) modular_section(ri, hi);
        }
    }
    if (show_loose_pegs && use_socket_pegs)
        translate([outer_preview_radius * 1.65, -outer_preview_radius * 0.7, 0]) loose_connector_pegs();
    if (show_press_clips && use_inner_press_clips)
        translate([outer_preview_radius * 1.65, outer_preview_radius * 0.35, 0]) loose_press_clips();
}

module print_layout() {
    total_sections = radial_pieces * height_pieces;
    cols = ceil(sqrt(total_sections));
    layout_spacing = (pot_top_radius + lip_width) * 2.7;
    for (hi = [0 : height_pieces - 1]) {
        for (ri = [0 : radial_pieces - 1]) {
            si = hi * radial_pieces + ri;
            mid = (radial_pieces > 1) ? (ri + 0.5) * 360 / radial_pieces : 0;
            translate([(si % cols) * layout_spacing, floor(si / cols) * layout_spacing, -hi * pot_height / height_pieces])
                rotate([0, 0, -mid]) color(piece_color(ri, hi)) modular_section(ri, hi);
        }
    }
    rows = ceil(total_sections / cols);
    if (show_loose_pegs && use_socket_pegs)
        translate([0, rows * layout_spacing + connector_length, 0]) loose_connector_pegs();
    if (show_press_clips && use_inner_press_clips)
        translate([outer_preview_radius, rows * layout_spacing + connector_length, 0]) loose_press_clips();
}

module selected_single_piece() {
    sr = min(single_piece_radial_index, radial_pieces - 1);
    sh = min(single_piece_height_index, height_pieces - 1);
    mid = (radial_pieces > 1) ? (sr + 0.5) * 360 / radial_pieces : 0;
    translate([0, 0, -sh * pot_height / height_pieces])
        rotate([0, 0, -mid]) color(piece_color(sr, sh)) modular_section(sr, sh);
    if (show_loose_pegs && use_socket_pegs)
        translate([outer_preview_radius * 0.9, 0, 0]) loose_connector_pegs();
    if (show_press_clips && use_inner_press_clips)
        translate([outer_preview_radius * 0.9, outer_preview_radius * 0.35, 0]) loose_press_clips();
}

if (display_mode == "print_layout") {
    print_layout();
} else if (display_mode == "single_piece") {
    selected_single_piece();
} else if (display_mode == "pegs_only") {
    loose_connector_pegs();
} else if (display_mode == "press_clips_only") {
    loose_press_clips();
} else {
    assembled_pot();
}
