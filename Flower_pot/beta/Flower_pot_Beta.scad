/* [Dimensions] */
pot_top_radius = 100;     // [30:5:300]
pot_bottom_radius = 70;   // [20:5:250]
pot_height = 150;         // [50:5:400]
wall_thickness = 3;       // [3:0.5:30]
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
connector_radius = 2;     // [0.8:0.1:8]
connector_length = 12;    // [8:1:50]
connector_clearance = 0.25; // [0:0.05:1.5]
vertical_pegs_per_section = 2; // [1:1:5]
side_pegs_per_section = 2; // [1:1:5]
// Keep every peg socket hidden below the outside surface.
hide_sockets_from_outside = true;

// Minimum unbroken outer skin above every socket.
socket_outer_skin = 0.8; // [0.4:0.1:3]

// Extra safety inset for preview/render rounding and low $fn facets.
socket_hide_safety_margin = 0.25; // [0:0.05:1]

// Minimum material behind the socket on the inside boss.
socket_inner_skin = 0.8; // [0.4:0.1:3]

// Allow the local connector bosses to grow automatically when needed.
connector_boss_auto_depth = true;

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

/* [Local Connector Reinforcements] */
// Add local pads on the inside wall around peg sockets.
// Intended to allow a thin general wall, for example 3 mm.
use_connector_bosses = true;

// Minimum inward depth. Automatic sizing may increase it when needed.
connector_boss_min_inward_depth = 1.0; // [0.5:0.1:8]

// Additional material around each socket after automatic sizing.
connector_boss_extra_margin = 1.2; // [0.4:0.1:6]

// Small overlap into the existing wall to guarantee a solid union.
connector_boss_wall_overlap = 0.6; // [0.2:0.1:2]

// Extra safety added to automatically calculated boss height/width.
connector_boss_size_safety = 0.8; // [0:0.1:3]

// Extra allowance for bosses that follow the conical wall.
connector_boss_tilt_height_allowance = 0.8; // [0:0.1:4]

// Manual vertical correction for connector bosses. Normally leave at 0.
connector_boss_z_offset = 0; // [-5:0.1:5]

/* [Local Press Clip Reinforcements] */
// Add local pads behind the recessed press-clip pockets.
use_press_clip_bosses = true;

// Additional wall thickness behind each press-clip recess.
press_clip_boss_inward_depth = 1.8; // [0.5:0.1:8]

// Extra material around the press-clip recess outline.
press_clip_boss_margin = 1.5; // [0.5:0.1:6]

// Overlap into the original wall to guarantee a solid union.
press_clip_boss_wall_overlap = 0.6; // [0.2:0.1:2]

/* [Inner Press Clips] */
// rounded_bar is the press-in bar style. dogbone is the O---O style.
press_clip_style = "rounded_bar"; // [rounded_bar, dogbone]
press_clip_end_radius = 4; // [2:0.5:12]
press_clip_neck_width = 4; // [1.5:0.5:12]
press_clip_length = 24; // [10:1:70]
press_clip_depth = 2.2; // [1:0.5:8]
press_clip_clearance = 0.35; // [0:0.05:1.5]
// Horizontal split in each end of the loose clip for spring compression. 0 disables it.
press_clip_split_gap = 0.7; // [0:0.1:3]
press_clip_radial_offset = 0; // [-10:0.5:10]
press_clip_tangent_offset = 0; // [-10:0.5:10]
press_clip_angle_offset = 0; // [-30:0.5:30]
// Extra twist of the recess shape in the wall plane.
press_clip_recess_twist_angle = 0; // [-30:0.5:30]
// Automatically follow the conical inner wall angle.
press_clip_auto_wall_tilt = true;
// Fine correction added to the calculated wall angle.
press_clip_wall_tilt_offset = 0; // [-15:0.1:15]
// Used only when automatic wall tilt is disabled.
press_clip_wall_tilt_angle = 0; // [-30:0.1:30]
press_clip_z_margin = 10; // [0:1:40]
vertical_press_clips_per_seam = 1; // [1:1:5]
horizontal_press_clips_per_section = 1; // [1:1:5]
show_press_clips = true;
// Show the recess cutter geometry as solid debug shapes together with the pot.
show_press_clip_recess_debug = false;

/* [Display] */
explode_distance = 10;    // [0:1:100]
display_mode = "assembled"; // [assembled, print_layout, single_piece, pegs_only, press_clips_only, press_recesses_only]
single_piece_radial_index = 0; // [0:1:15]
single_piece_height_index = 0; // [0:1:9]

/* [Calculated Radius Report] */
// Print calculated top/bottom radii and diameters in the OpenSCAD console.
show_radius_report = true;

// Include the conservative local connector/press-clip boss envelope.
include_bosses_in_radius_report = true;

// Show the calculated values directly in the OpenSCAD model view.
show_radius_report_in_model = true;

// Show guide rings for the calculated effective inner top/bottom radius.
show_radius_guide_rings = true;

// Text size for the in-model report.
radius_report_text_size = 6; // [3:0.5:16]

// Distance from the pot to the report panel.
radius_report_panel_offset = 30; // [5:1:150]

/* [Colors] */
piece_color_1 = "#4E79A7"; // 7
piece_color_2 = "#F28E2B"; // 7
piece_color_3 = "#59A14F"; // 7
piece_color_4 = "#B07AA1"; // 7
peg_color = "#DDDDDD";     // 7
press_clip_color = "#CCCCCC"; // 7
press_recess_debug_color = "#FF3333"; // 7
radius_report_color = "#111111"; // 7
radius_guide_ring_color = "#FF00FF"; // 7
$fn = 48;

effective_wall_thickness = min(wall_thickness, pot_bottom_radius - 6);
effective_lip_transition_height = min(lip_transition_height, max(0, pot_height - lip_height - bottom_thickness));
// Peg/socket size is independent of the general wall thickness.
// Local bosses provide the required extra material.
effective_connector_radius = connector_radius;
effective_press_clip_depth = min(
    press_clip_depth,
    effective_wall_thickness * 0.65
);
socket_radius = connector_radius + connector_clearance;
outer_preview_radius = max(pot_top_radius + lip_width + 20, pot_bottom_radius + 20);

function connector_boss_edge_margin() =
    connector_boss_extra_margin
    + connector_boss_size_safety;

function vertical_connector_boss_tangent_width() =
    2 * (
        socket_radius
        + connector_boss_edge_margin()
    );

// vertical_dowel() includes the cylinder length plus one spherical
// end radius above and below the cylinder.
function vertical_connector_boss_height() =
    connector_length
    + vertical_socket_length_extra
    + 2 * socket_radius
    + 2 * connector_boss_edge_margin()
    + connector_boss_tilt_height_allowance;

// rounded_dowel() includes the same spherical extension along its axis.
function side_connector_boss_tangent_width() =
    connector_length
    + side_socket_length_extra
    + 2 * socket_radius
    + 2 * connector_boss_edge_margin();

function side_connector_boss_height() =
    2 * (
        socket_radius
        + connector_boss_edge_margin()
    );

function radius_at_height(z) =
    pot_bottom_radius + (pot_top_radius - pot_bottom_radius) * (z / pot_height);

function inner_wall_bottom_radius() =
    max(1, pot_bottom_radius - effective_wall_thickness);

function inner_wall_top_radius() =
    max(
        1,
        pot_top_radius
        - effective_wall_thickness
        - inner_rim_bevel
    );

function inner_radius_at_height(z) =
    inner_wall_bottom_radius()
    + (
        inner_wall_top_radius()
        - inner_wall_bottom_radius()
    ) * (z / pot_height);

function centered_socket_radius(z) =
    radius_at_height(z)
    - effective_wall_thickness * 0.5;

// Radial change per millimetre of height.
function outer_wall_radius_slope() =
    (pot_top_radius - pot_bottom_radius) / pot_height;

// A vertical socket spans several millimetres above and below its centre.
// On a conical pot, its lower portion is closer to the outside surface.
// This extra inset prevents that lower part from breaking through.
function vertical_socket_slope_compensation() =
    abs(outer_wall_radius_slope())
    * (
        connector_length
        + vertical_socket_length_extra
    ) / 2;

// A tangent-oriented side socket moves farther from the pot centre toward
// both ends. This sagitta compensation keeps its ends below the outside skin.
function side_socket_curve_compensation(z) =
    let(
        outer_safe_radius =
            max(
                1,
                radius_at_height(z)
                - socket_outer_skin
                - socket_radius
            ),
        half_socket_length =
            (
                connector_length
                + side_socket_length_extra
            ) / 2
    )
    sqrt(
        outer_safe_radius * outer_safe_radius
        + half_socket_length * half_socket_length
    )
    - outer_safe_radius;

function hidden_vertical_socket_radius(z) =
    radius_at_height(z)
    - socket_outer_skin
    - socket_radius
    - vertical_socket_slope_compensation()
    - socket_hide_safety_margin;

function hidden_side_socket_radius(z) =
    radius_at_height(z)
    - socket_outer_skin
    - socket_radius
    - side_socket_curve_compensation(z)
    - socket_hide_safety_margin;

function socket_center_radius(z) =
    centered_socket_radius(z) + socket_radial_offset;

function vertical_socket_center_radius(z) =
    (
        hide_sockets_from_outside
            ? hidden_vertical_socket_radius(z)
            : centered_socket_radius(z)
    )
    + socket_radial_offset
    + vertical_socket_radial_offset;

function side_socket_center_radius(z) =
    (
        hide_sockets_from_outside
            ? hidden_side_socket_radius(z)
            : centered_socket_radius(z)
    )
    + socket_radial_offset
    + side_socket_radial_offset;

function connector_boss_outer_radius(z) =
    inner_radius_at_height(z)
    + connector_boss_wall_overlap;

function connector_boss_required_inner_radius(
    socket_center_r
) =
    socket_center_r
    - socket_radius
    - socket_inner_skin;

function connector_boss_inner_radius(
    z,
    socket_center_r
) =
    connector_boss_auto_depth
        ? min(
            inner_radius_at_height(z)
                - connector_boss_min_inward_depth,
            connector_boss_required_inner_radius(
                socket_center_r
            )
        )
        : inner_radius_at_height(z)
            - connector_boss_min_inward_depth;

function connector_boss_inward_depth_at(
    z,
    socket_center_r
) =
    connector_boss_outer_radius(z)
    - connector_boss_inner_radius(
        z,
        socket_center_r
    );

function connector_boss_center_radius(
    z,
    socket_center_r
) =
    (
        connector_boss_outer_radius(z)
        + connector_boss_inner_radius(
            z,
            socket_center_r
        )
    ) / 2;

function pot_wall_tilt_angle() =
    atan(
        (
            inner_wall_top_radius()
            - inner_wall_bottom_radius()
        ) / pot_height
    );

function effective_press_clip_wall_tilt() =
    press_clip_auto_wall_tilt
        ? pot_wall_tilt_angle() + press_clip_wall_tilt_offset
        : press_clip_wall_tilt_angle;

function press_clip_recess_depth() =
    effective_press_clip_depth + press_clip_clearance * 2;

// Conservative socket centre used for estimating the deepest
// connector boss at a given height.
function report_socket_center_radius(z) =
    min(
        vertical_socket_center_radius(z),
        side_socket_center_radius(z)
    );

function connector_boss_inner_radius_for_report(z) =
    (
        include_bosses_in_radius_report
        && use_connector_bosses
        && use_socket_pegs
    )
        ? connector_boss_inner_radius(
            z,
            report_socket_center_radius(z)
        )
        : inner_radius_at_height(z);

function press_clip_boss_inner_radius_for_report(z) =
    (
        include_bosses_in_radius_report
        && use_press_clip_bosses
        && use_inner_press_clips
    )
        ? inner_radius_at_height(z)
            - press_clip_boss_inward_depth
        : inner_radius_at_height(z);

function effective_inner_radius_with_bosses(z) =
    min(
        inner_radius_at_height(z),
        connector_boss_inner_radius_for_report(z),
        press_clip_boss_inner_radius_for_report(z)
    );

function effective_top_inner_radius_with_bosses() =
    effective_inner_radius_with_bosses(pot_height);

function effective_bottom_inner_radius_with_bosses() =
    effective_inner_radius_with_bosses(0);

function piece_color(ri, hi) =
    ((ri + hi) % 4 == 0) ? piece_color_1 :
    ((ri + hi) % 4 == 1) ? piece_color_2 :
    ((ri + hi) % 4 == 2) ? piece_color_3 : piece_color_4;

function vertical_joint_peg_count() =
    use_socket_pegs
        ? radial_pieces * max(0, height_pieces - 1)
          * ((radial_pieces <= 1)
                ? max(3, vertical_pegs_per_section * 2)
                : vertical_pegs_per_section)
        : 0;

function side_joint_peg_count() =
    (use_socket_pegs && radial_pieces > 1)
        ? radial_pieces * height_pieces * side_pegs_per_section
        : 0;

function total_loose_peg_count() =
    vertical_joint_peg_count() + side_joint_peg_count();

function total_press_clip_count() =
    use_inner_press_clips
        ? ((use_vertical_seam_press_clips && radial_pieces > 1)
            ? radial_pieces * height_pieces * vertical_press_clips_per_seam
            : 0)
          + ((use_horizontal_seam_press_clips && height_pieces > 1)
            ? radial_pieces * (height_pieces - 1) * horizontal_press_clips_per_section
            : 0)
        : 0;

module rounded_dowel(r, len) {
    rotate([0, 90, 0])
        union() {
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

module dogbone_base_2d(len, end_r, neck_w, clearance = 0) {
    er = end_r + clearance;
    nw = neck_w + clearance * 2;

    union() {
        translate([-len / 2, 0]) circle(r = er, $fn = 36);
        translate([ len / 2, 0]) circle(r = er, $fn = 36);
        square([len, nw], center = true);
    }
}

module rounded_bar_base_2d(len, end_r, neck_w, clearance = 0) {
    er = end_r + clearance;
    nw = max(neck_w + clearance * 2, er * 1.6);

    hull() {
        translate([-len / 2, 0]) circle(r = nw / 2, $fn = 36);
        translate([ len / 2, 0]) circle(r = nw / 2, $fn = 36);
    }
}

module press_clip_2d(
    len,
    end_r,
    neck_w,
    clearance = 0,
    style = press_clip_style,
    split_gap = press_clip_split_gap
) {
    difference() {
        if (style == "dogbone")
            dogbone_base_2d(len, end_r, neck_w, clearance);
        else
            rounded_bar_base_2d(len, end_r, neck_w, clearance);

        // Horizontal spring slot in each end.
        // The recess has no slot because split_gap is set to 0 there.
        if (split_gap > 0 && clearance == 0) {
            slot_len = end_r * 1.7;

            for (s = [-1, 1])
                translate([s * (len / 2 + end_r * 0.18), 0])
                    square([slot_len, split_gap], center = true);
        }
    }
}

module flat_press_clip(
    len = press_clip_length,
    end_r = press_clip_end_radius,
    neck_w = press_clip_neck_width,
    depth = effective_press_clip_depth,
    clearance = 0,
    orientation = "tangent",
    split_gap = press_clip_split_gap,
    style = press_clip_style
) {
    // Local coordinates after placement:
    // X = radial wall-normal direction
    // Y = tangent direction
    // Z = vertical direction
    rotate([0, 90, 0])
        linear_extrude(
            height = depth + clearance * 2,
            center = true
        )
            if (orientation == "vertical")
                press_clip_2d(
                    len,
                    end_r,
                    neck_w,
                    clearance,
                    style,
                    split_gap
                );
            else
                rotate([0, 0, 90])
                    press_clip_2d(
                        len,
                        end_r,
                        neck_w,
                        clearance,
                        style,
                        split_gap
                    );
}

module placed_press_clip_recess(
    angle,
    z,
    orientation = "tangent"
) {
    wall_tilt = effective_press_clip_wall_tilt();
    half_depth = press_clip_recess_depth() / 2;

    // Place the cutter from the inner wall surface along the wall normal.
    // This keeps the upper and lower cutter edges at approximately equal
    // depth in the conical wall.
    recess_radius =
        inner_radius_at_height(z)
        + half_depth * cos(wall_tilt)
        + press_clip_radial_offset;

    recess_z =
        z
        - half_depth * sin(wall_tilt);

    translate([
        recess_radius * cos(angle)
            + press_clip_tangent_offset * cos(angle + 90),

        recess_radius * sin(angle)
            + press_clip_tangent_offset * sin(angle + 90),

        recess_z
    ])
        rotate([0, 0, angle + press_clip_recess_twist_angle])
            rotate([0, wall_tilt, 0])
                flat_press_clip(
                    clearance = press_clip_clearance,
                    orientation = orientation,
                    split_gap = 0
                );
}

module inner_wall_reinforcement_pad(
    angle,
    socket_z,
    tangent_width,
    pad_height,
    socket_center_r,
    tangent_offset = 0
) {
    pad_depth =
        connector_boss_inward_depth_at(
            socket_z,
            socket_center_r
        );

    pad_center_radius =
        connector_boss_center_radius(
            socket_z,
            socket_center_r
        );

    // IMPORTANT: connector bosses are not tilted. Their vertical centre
    // is exactly the same Z coordinate as the socket centre, so the boss
    // extends equally far above and below the complete socket geometry.
    translate([
        pad_center_radius * cos(angle)
            + tangent_offset * cos(angle + 90),

        pad_center_radius * sin(angle)
            + tangent_offset * sin(angle + 90),

        socket_z + connector_boss_z_offset
    ])
        rotate([0, 0, angle])
            cube(
                [
                    pad_depth,
                    tangent_width,
                    pad_height
                ],
                center = true
            );
}

module vertical_connector_bosses_for_section(ri, hi) {
    if (
        use_connector_bosses
        && use_socket_pegs
        && height_pieces > 1
    ) {
        for (sd = [-1, 1]) {
            seam_z =
                (sd < 0)
                    ? hi * pot_height / height_pieces
                    : (hi + 1) * pot_height / height_pieces;

            if (seam_z > 0 && seam_z < pot_height) {
                count =
                    (radial_pieces <= 1)
                        ? max(
                            3,
                            vertical_pegs_per_section * 2
                        )
                        : vertical_pegs_per_section;

                section_angle =
                    360 / max(1, radial_pieces);

                for (pn = [1 : count]) {
                    frac = pn / (count + 1);

                    a =
                        ri * section_angle
                        + frac * section_angle
                        + vertical_socket_angle_offset;

                    inner_wall_reinforcement_pad(
                        a,
                        seam_z,
                        vertical_connector_boss_tangent_width(),
                        vertical_connector_boss_height(),
                        vertical_socket_center_radius(seam_z),
                        vertical_socket_tangent_offset
                    );
                }
            }
        }
    }
}

module side_connector_bosses_for_section(ri, hi) {
    if (
        use_connector_bosses
        && use_socket_pegs
        && radial_pieces > 1
    ) {
        for (ss = [0, 1]) {
            a = (ri + ss) * 360 / radial_pieces;

            for (pn = [1 : side_pegs_per_section]) {
                frac =
                    pn / (side_pegs_per_section + 1);

                section_height =
                    pot_height / height_pieces;

                z =
                    hi * section_height
                    + frac * section_height
                    + side_socket_z_offset;

                zsafe = min(
                    pot_height - socket_radius - 0.2,
                    max(socket_radius + 0.2, z)
                );

                inner_wall_reinforcement_pad(
                    a,
                    zsafe,
                    side_connector_boss_tangent_width(),
                    side_connector_boss_height(),
                    side_socket_center_radius(zsafe),
                    side_socket_tangent_offset
                );
            }
        }
    }
}

module connector_bosses_for_section(ri, hi) {
    vertical_connector_bosses_for_section(ri, hi);
    side_connector_bosses_for_section(ri, hi);
}

module press_clip_reinforcement_pad(
    angle,
    z,
    orientation = "tangent"
) {
    wall_tilt = effective_press_clip_wall_tilt();

    pad_depth =
        press_clip_boss_inward_depth
        + press_clip_boss_wall_overlap;

    pad_center_radius =
        inner_radius_at_height(z)
        - press_clip_boss_inward_depth / 2
        + press_clip_boss_wall_overlap / 2;

    // Increase the pad footprint around the clip recess.
    pad_length =
        press_clip_length
        + 2 * (
            press_clip_end_radius
            + press_clip_boss_margin
        );

    pad_width =
        max(
            press_clip_neck_width,
            2 * press_clip_end_radius
        )
        + 2 * press_clip_boss_margin;

    translate([
        pad_center_radius * cos(angle),
        pad_center_radius * sin(angle),
        z
    ])
        rotate([0, 0, angle + press_clip_recess_twist_angle])
            rotate([0, wall_tilt, 0])
                cube(
                    orientation == "vertical"
                        ? [
                            pad_depth,
                            pad_width,
                            pad_length
                        ]
                        : [
                            pad_depth,
                            pad_length,
                            pad_width
                        ],
                    center = true
                );
}

module vertical_press_clip_bosses_for_section(ri, hi) {
    if (
        use_press_clip_bosses
        && use_inner_press_clips
        && use_vertical_seam_press_clips
        && radial_pieces > 1
    ) {
        section_height = pot_height / height_pieces;

        usable_height = max(
            1,
            section_height - press_clip_z_margin * 2
        );

        for (ss = [0, 1]) {
            seam_angle =
                (ri + ss) * 360 / radial_pieces;

            for (kn = [1 : vertical_press_clips_per_seam]) {
                frac =
                    kn / (vertical_press_clips_per_seam + 1);

                z =
                    hi * section_height
                    + press_clip_z_margin
                    + frac * usable_height;

                press_clip_reinforcement_pad(
                    seam_angle,
                    z,
                    "tangent"
                );
            }
        }
    }
}

module horizontal_press_clip_bosses_for_section(ri, hi) {
    if (
        use_press_clip_bosses
        && use_inner_press_clips
        && use_horizontal_seam_press_clips
        && height_pieces > 1
    ) {
        for (sd = [-1, 1]) {
            seam_z =
                (sd < 0)
                    ? hi * pot_height / height_pieces
                    : (hi + 1) * pot_height / height_pieces;

            if (seam_z > 0 && seam_z < pot_height) {
                section_angle =
                    360 / max(1, radial_pieces);

                for (
                    kn = [1 : horizontal_press_clips_per_section]
                ) {
                    frac =
                        kn
                        / (
                            horizontal_press_clips_per_section
                            + 1
                        );

                    a =
                        ri * section_angle
                        + frac * section_angle
                        + press_clip_angle_offset;

                    press_clip_reinforcement_pad(
                        a,
                        seam_z,
                        "vertical"
                    );
                }
            }
        }
    }
}

module press_clip_bosses_for_section(ri, hi) {
    vertical_press_clip_bosses_for_section(ri, hi);
    horizontal_press_clip_bosses_for_section(ri, hi);
}

module main_pot_shell() {
    difference() {
        union() {
            cylinder(
                r1 = pot_bottom_radius,
                r2 = pot_top_radius,
                h = pot_height
            );

            if (lip_width > 0 && effective_lip_transition_height > 0) {
                transition_start_z =
                    pot_height
                    - lip_height
                    - effective_lip_transition_height;

                translate([0, 0, transition_start_z])
                    cylinder(
                        r1 = radius_at_height(transition_start_z),
                        r2 = pot_top_radius + lip_width,
                        h = effective_lip_transition_height
                    );
            }

            if (lip_width > 0 && lip_height > 0)
                translate([0, 0, pot_height - lip_height])
                    cylinder(
                        r = pot_top_radius + lip_width,
                        h = lip_height
                    );
        }

        translate([0, 0, bottom_thickness])
            cylinder(
                r1 = max(
                    1,
                    pot_bottom_radius - effective_wall_thickness
                ),
                r2 = max(
                    1,
                    pot_top_radius
                    - effective_wall_thickness
                    - inner_rim_bevel
                ),
                h = max(
                    1,
                    pot_height - bottom_thickness + 0.02
                )
            );

        if (inner_rim_bevel > 0)
            translate([0, 0, pot_height - inner_rim_bevel])
                cylinder(
                    r1 = max(
                        1,
                        pot_top_radius
                        - effective_wall_thickness
                        - inner_rim_bevel
                    ),
                    r2 = max(
                        1,
                        pot_top_radius - effective_wall_thickness
                    ),
                    h = inner_rim_bevel + 0.04
                );

        if (drain_hole_radius > 0)
            translate([0, 0, -1])
                cylinder(
                    r = min(
                        drain_hole_radius,
                        max(
                            1,
                            pot_bottom_radius
                            - effective_wall_thickness
                            - 2
                        )
                    ),
                    h = bottom_thickness + 2
                );
    }
}

module radial_cut_volume(ri) {
    if (radial_pieces <= 1) {
        translate([0, 0, -1])
            cylinder(
                r = outer_preview_radius * 3,
                h = pot_height + 2,
                $fn = 48
            );
    } else {
        a0 = ri * 360 / radial_pieces;
        a1 = (ri + 1) * 360 / radial_pieces;
        astep = max(2, (a1 - a0) / 12);

        pts = concat(
            [[0, 0]],
            [
                for (a = [a0 : astep : a1])
                    [
                        outer_preview_radius * 3 * cos(a),
                        outer_preview_radius * 3 * sin(a)
                    ]
            ],
            [[
                outer_preview_radius * 3 * cos(a1),
                outer_preview_radius * 3 * sin(a1)
            ]]
        );

        translate([0, 0, -1])
            linear_extrude(height = pot_height + 2)
                polygon(pts);
    }
}

module height_cut_volume(hi) {
    z0 = hi * pot_height / height_pieces;
    z1 = (hi + 1) * pot_height / height_pieces;

    translate([0, 0, z0])
        cylinder(
            r = outer_preview_radius * 3,
            h = z1 - z0,
            $fn = 48
        );
}

module vertical_socket_holes_for_section(ri, hi) {
    if (use_socket_pegs && height_pieces > 1) {
        for (sd = [-1, 1]) {
            seam_z =
                (sd < 0)
                    ? hi * pot_height / height_pieces
                    : (hi + 1) * pot_height / height_pieces;

            if (seam_z > 0 && seam_z < pot_height) {
                seam_radius =
                    vertical_socket_center_radius(seam_z);

                count =
                    (radial_pieces <= 1)
                        ? max(
                            3,
                            vertical_pegs_per_section * 2
                        )
                        : vertical_pegs_per_section;

                for (pn = [1 : count]) {
                    frac = pn / (count + 1);
                    section_angle =
                        360 / max(1, radial_pieces);

                    a =
                        ri * section_angle
                        + frac * section_angle
                        + vertical_socket_angle_offset;

                    translate([
                        seam_radius * cos(a)
                            + vertical_socket_tangent_offset
                            * cos(a + 90),

                        seam_radius * sin(a)
                            + vertical_socket_tangent_offset
                            * sin(a + 90),

                        seam_z
                    ])
                        vertical_dowel(
                            socket_radius,
                            connector_length
                            + vertical_socket_length_extra
                        );
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
                frac =
                    pn / (side_pegs_per_section + 1);

                section_height =
                    pot_height / height_pieces;

                z =
                    hi * section_height
                    + frac * section_height
                    + side_socket_z_offset;

                zsafe = min(
                    pot_height - socket_radius - 0.2,
                    max(socket_radius + 0.2, z)
                );

                r = side_socket_center_radius(zsafe);

                translate([
                    r * cos(a)
                        + side_socket_tangent_offset
                        * cos(a + 90),

                    r * sin(a)
                        + side_socket_tangent_offset
                        * sin(a + 90),

                    zsafe
                ])
                    rotate([
                        0,
                        0,
                        a
                        + 90
                        + side_socket_axis_angle_offset
                    ])
                        rounded_dowel(
                            socket_radius,
                            connector_length
                            + side_socket_length_extra
                        );
            }
        }
    }
}

module vertical_press_clip_recesses_for_section(ri, hi) {
    if (
        use_inner_press_clips
        && use_vertical_seam_press_clips
        && radial_pieces > 1
    ) {
        section_height = pot_height / height_pieces;

        usable_height = max(
            1,
            section_height - press_clip_z_margin * 2
        );

        for (ss = [0, 1]) {
            seam_angle =
                (ri + ss) * 360 / radial_pieces;

            for (kn = [1 : vertical_press_clips_per_seam]) {
                frac =
                    kn / (vertical_press_clips_per_seam + 1);

                z =
                    hi * section_height
                    + press_clip_z_margin
                    + frac * usable_height;

                placed_press_clip_recess(
                    seam_angle,
                    z,
                    "tangent"
                );
            }
        }
    }
}

module horizontal_press_clip_recesses_for_section(ri, hi) {
    if (
        use_inner_press_clips
        && use_horizontal_seam_press_clips
        && height_pieces > 1
    ) {
        for (sd = [-1, 1]) {
            seam_z =
                (sd < 0)
                    ? hi * pot_height / height_pieces
                    : (hi + 1) * pot_height / height_pieces;

            if (seam_z > 0 && seam_z < pot_height) {
                section_angle =
                    360 / max(1, radial_pieces);

                for (
                    kn = [1 : horizontal_press_clips_per_section]
                ) {
                    frac =
                        kn
                        / (
                            horizontal_press_clips_per_section
                            + 1
                        );

                    a =
                        ri * section_angle
                        + frac * section_angle
                        + press_clip_angle_offset;

                    placed_press_clip_recess(
                        a,
                        seam_z,
                        "vertical"
                    );
                }
            }
        }
    }
}

module all_press_clip_recesses() {
    if (use_inner_press_clips) {
        for (hi = [0 : height_pieces - 1]) {
            for (ri = [0 : radial_pieces - 1]) {
                vertical_press_clip_recesses_for_section(
                    ri,
                    hi
                );

                horizontal_press_clip_recesses_for_section(
                    ri,
                    hi
                );
            }
        }
    }
}

module modular_section(ri, hi) {
    difference() {
        intersection() {
            union() {
                main_pot_shell();
                connector_bosses_for_section(ri, hi);
                press_clip_bosses_for_section(ri, hi);
            }

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
        spacing =
            connector_length
            + effective_connector_radius * 5;

        for (i = [0 : n - 1])
            translate([
                (i % cols) * spacing,
                floor(i / cols) * spacing,
                effective_connector_radius
            ])
                color(peg_color)
                    rounded_dowel(
                        effective_connector_radius,
                        connector_length
                    );
    }
}

module loose_press_clips() {
    n = total_press_clip_count();

    if (n > 0) {
        cols = ceil(sqrt(n));

        spacing_x =
            press_clip_length
            + press_clip_end_radius * 4
            + 12;

        spacing_y =
            press_clip_end_radius * 5
            + 8;

        for (i = [0 : n - 1])
            translate([
                (i % cols) * spacing_x,
                floor(i / cols) * spacing_y,
                effective_press_clip_depth / 2
            ])
                color(press_clip_color)
                    flat_press_clip(
                        split_gap = press_clip_split_gap
                    );
    }
}

module radius_report_line(label_text, value_text, y_position) {
    translate([0, y_position, 0])
        linear_extrude(height = 0.8)
            text(
                str(label_text, value_text),
                size = radius_report_text_size,
                halign = "left",
                valign = "baseline"
            );
}

module radius_report_panel() {
    panel_x =
        pot_top_radius
        + lip_width
        + radius_report_panel_offset;

    panel_z = pot_height * 0.55;

    translate([panel_x, 0, panel_z])
        rotate([90, 0, 90])
            color(radius_report_color)
                union() {
                    radius_report_line(
                        "Outer top R: ",
                        str(pot_top_radius, " mm"),
                        0
                    );

                    radius_report_line(
                        "Outer bottom R: ",
                        str(pot_bottom_radius, " mm"),
                        -radius_report_text_size * 1.35
                    );

                    radius_report_line(
                        "Inner top R: ",
                        str(
                            effective_top_inner_radius_with_bosses(),
                            " mm"
                        ),
                        -radius_report_text_size * 2.70
                    );

                    radius_report_line(
                        "Inner bottom R: ",
                        str(
                            effective_bottom_inner_radius_with_bosses(),
                            " mm"
                        ),
                        -radius_report_text_size * 4.05
                    );

                    radius_report_line(
                        "Peg D: ",
                        str(2 * connector_radius, " mm"),
                        -radius_report_text_size * 5.40
                    );

                    radius_report_line(
                        "Socket D: ",
                        str(2 * socket_radius, " mm"),
                        -radius_report_text_size * 6.75
                    );
                }
}

module radius_guide_ring(radius_value, z_value) {
    color(radius_guide_ring_color)
        translate([0, 0, z_value])
            difference() {
                cylinder(
                    r = radius_value + 0.35,
                    h = 0.7,
                    center = true,
                    $fn = 96
                );

                cylinder(
                    r = max(0.1, radius_value - 0.35),
                    h = 1.1,
                    center = true,
                    $fn = 96
                );
            }
}

module radius_report_visuals() {
    if (show_radius_report_in_model)
        radius_report_panel();

    if (show_radius_guide_rings) {
        radius_guide_ring(
            effective_bottom_inner_radius_with_bosses(),
            0.8
        );

        radius_guide_ring(
            effective_top_inner_radius_with_bosses(),
            pot_height - 0.8
        );
    }
}

module assembled_pot() {
    for (hi = [0 : height_pieces - 1]) {
        for (ri = [0 : radial_pieces - 1]) {
            mid =
                (radial_pieces > 1)
                    ? (ri + 0.5) * 360 / radial_pieces
                    : 0;

            rex =
                (radial_pieces > 1)
                    ? explode_distance
                    : 0;

            translate([
                rex * cos(mid),
                rex * sin(mid),
                hi * explode_distance
            ])
                color(piece_color(ri, hi))
                    modular_section(ri, hi);
        }
    }

    if (show_press_clip_recess_debug)
        color(press_recess_debug_color, 0.45)
            all_press_clip_recesses();

    if (show_loose_pegs && use_socket_pegs)
        translate([
            outer_preview_radius * 1.65,
            -outer_preview_radius * 0.7,
            0
        ])
            loose_connector_pegs();

    if (show_press_clips && use_inner_press_clips)
        translate([
            outer_preview_radius * 1.65,
            outer_preview_radius * 0.35,
            0
        ])
            loose_press_clips();

    radius_report_visuals();
}

module print_layout() {
    total_sections =
        radial_pieces * height_pieces;

    cols = ceil(sqrt(total_sections));

    layout_spacing =
        (pot_top_radius + lip_width) * 2.7;

    for (hi = [0 : height_pieces - 1]) {
        for (ri = [0 : radial_pieces - 1]) {
            si = hi * radial_pieces + ri;

            mid =
                (radial_pieces > 1)
                    ? (ri + 0.5) * 360 / radial_pieces
                    : 0;

            translate([
                (si % cols) * layout_spacing,
                floor(si / cols) * layout_spacing,
                -hi * pot_height / height_pieces
            ])
                rotate([0, 0, -mid])
                    color(piece_color(ri, hi))
                        modular_section(ri, hi);
        }
    }

    rows = ceil(total_sections / cols);

    if (show_loose_pegs && use_socket_pegs)
        translate([
            0,
            rows * layout_spacing + connector_length,
            0
        ])
            loose_connector_pegs();

    if (show_press_clips && use_inner_press_clips)
        translate([
            outer_preview_radius,
            rows * layout_spacing + connector_length,
            0
        ])
            loose_press_clips();
}

module selected_single_piece() {
    sr = min(
        single_piece_radial_index,
        radial_pieces - 1
    );

    sh = min(
        single_piece_height_index,
        height_pieces - 1
    );

    mid =
        (radial_pieces > 1)
            ? (sr + 0.5) * 360 / radial_pieces
            : 0;

    translate([
        0,
        0,
        -sh * pot_height / height_pieces
    ])
        rotate([0, 0, -mid])
            color(piece_color(sr, sh))
                modular_section(sr, sh);

    if (show_loose_pegs && use_socket_pegs)
        translate([
            outer_preview_radius * 0.9,
            0,
            0
        ])
            loose_connector_pegs();

    if (show_press_clips && use_inner_press_clips)
        translate([
            outer_preview_radius * 0.9,
            outer_preview_radius * 0.35,
            0
        ])
            loose_press_clips();

    radius_report_visuals();
}

if (show_radius_report) {
    echo("=== FLOWER POT RADIUS REPORT ===");

    echo(
        str(
            "Outer bottom radius: ",
            pot_bottom_radius,
            " mm | diameter: ",
            2 * pot_bottom_radius,
            " mm"
        )
    );

    echo(
        str(
            "Outer top radius: ",
            pot_top_radius,
            " mm | diameter: ",
            2 * pot_top_radius,
            " mm"
        )
    );

    echo(
        str(
            "Inner bottom radius without bosses: ",
            inner_radius_at_height(0),
            " mm | diameter: ",
            2 * inner_radius_at_height(0),
            " mm"
        )
    );

    echo(
        str(
            "Inner top radius without bosses: ",
            inner_radius_at_height(pot_height),
            " mm | diameter: ",
            2 * inner_radius_at_height(pot_height),
            " mm"
        )
    );

    echo(
        str(
            "Conservative inner bottom radius with bosses: ",
            effective_bottom_inner_radius_with_bosses(),
            " mm | diameter: ",
            2 * effective_bottom_inner_radius_with_bosses(),
            " mm"
        )
    );

    echo(
        str(
            "Conservative inner top radius with bosses: ",
            effective_top_inner_radius_with_bosses(),
            " mm | diameter: ",
            2 * effective_top_inner_radius_with_bosses(),
            " mm"
        )
    );

    echo(
        str(
            "Peg diameter: ",
            2 * connector_radius,
            " mm | socket diameter: ",
            2 * socket_radius,
            " mm"
        )
    );
}

if (display_mode == "print_layout") {
    print_layout();
} else if (display_mode == "single_piece") {
    selected_single_piece();
} else if (display_mode == "pegs_only") {
    loose_connector_pegs();
} else if (display_mode == "press_clips_only") {
    loose_press_clips();
} else if (display_mode == "press_recesses_only") {
    color(press_recess_debug_color, 0.85)
        all_press_clip_recesses();
} else {
    assembled_pot();
}
