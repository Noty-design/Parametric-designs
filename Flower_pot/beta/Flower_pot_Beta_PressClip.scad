/* ========================================================================== 

   Modular Flower Pot Press-Clip Beta Model for 3D Printing
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   DESCRIPTION
   -----------
   An experimental modular flower pot divided into angular sectors and horizontal
   layers.  Sections use removable capsule-ended dowels, internal press clips,
   and local reinforcement pads around connector recesses.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.  The assembled pot is centred on global Z,
   starts at Z=0, and opens upward.  Angles advance counter-clockwise around Z
   when viewed from above.  Local radial axes point away from the centre and
   tangent axes follow the circumference.

   CONSTRUCTION
   ------------
   A complete reinforced pot is intersected with one angular wedge and one height
   band per printable section.  Matching peg sockets and press-clip recesses are
   subtracted afterward.  Small overlaps improve boolean and printed connectivity.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */ 
   
/* [Dimensions] */
// Outside top radius, outside bottom radius, and assembled pot height.
pot_top_radius = 100;     // [30:5:300]
pot_bottom_radius = 70;   // [20:5:250]
pot_height = 150;         // [50:5:400]
// Requested wall thickness and retained solid base thickness.
wall_thickness = 10;      // [4:1:30]
bottom_thickness = 8;     // [2:1:30]
// Radius of the central drainage hole; zero disables the hole.
drain_hole_radius = 15;   // [0:1:50]

/* [Smooth Rim and Lip] */
// Additional lip radius, straight lip height, support-conscious transition
// height, and inside rim bevel size.
lip_width = 8;            // [0:1:40]
lip_height = 10;          // [0:1:50]
lip_transition_height = 14; // [0:1:60]
inner_rim_bevel = 3;      // [0:0.5:12]

/* [Sections] */
// Number of angular sectors and vertically stacked layers.
radial_pieces = 4;        // [1:1:16]
height_pieces = 3;        // [1:1:10]

/* [Connector Systems] */
// Master switches for dowels, clips on radial seams, and clips on layer seams.
use_socket_pegs = true;
use_inner_press_clips = true;
use_vertical_seam_press_clips = true;
use_horizontal_seam_press_clips = true;

/* [Separate Peg Connectors] */
// Dowel radius, straight length, socket clearance, and counts per seam family.
connector_radius = 3;     // [1.5:0.25:8]
connector_length = 18;    // [8:1:50]
connector_clearance = 0.25; // [0:0.05:1.5]
vertical_pegs_per_section = 2; // [1:1:5]
side_pegs_per_section = 2; // [1:1:5]
// Automatically positions socket centres halfway through the general wall.
socket_auto_center = true;
// Shared radial correction followed by vertical-socket-specific adjustments.
socket_radial_offset = 0; // [-20:0.5:20]
vertical_socket_angle_offset = 0; // [-30:0.5:30]
vertical_socket_radial_offset = 0; // [-20:0.5:20]
vertical_socket_tangent_offset = 0; // [-20:0.5:20]
vertical_socket_length_extra = 0.4; // [0:0.1:20]
// Radial-seam socket position, orientation, and cutter-length adjustments.
side_socket_radial_offset = 0; // [-20:0.5:20]
side_socket_tangent_offset = 0; // [-20:0.5:20]
side_socket_z_offset = 0; // [-30:0.5:30]
side_socket_axis_angle_offset = 0; // [-30:0.5:30]
side_socket_length_extra = 0.4; // [0:0.1:20]
// Displays the calculated number of separately printable dowels.
show_loose_pegs = true;

/* [Local Connector Reinforcements] */
// Add local pads on the inside wall around peg sockets.
// Intended to allow a thin general wall, for example 3 mm.
use_connector_bosses = true;

// Distance each connector reinforcement extends inward from the inner wall.
connector_boss_inward_depth = 2.4; // [0.5:0.1:8]

// Extra material around each socket, measured from its edge.
connector_boss_margin = 1.8; // [0.5:0.1:6]

// Small overlap into the existing wall that guarantees a solid union.
connector_boss_wall_overlap = 0.6; // [0.2:0.1:2]

// Reinforcement height around vertical sockets at horizontal seams.
vertical_connector_boss_height = 8; // [3:0.5:20]

// Additional tangential reinforcement length beyond side socket ends.
side_connector_boss_length_margin = 2; // [0:0.5:10]

/* [Local Press Clip Reinforcements] */
// Add local pads behind the recessed press-clip pockets.
use_press_clip_bosses = true;

// Additional inward wall thickness behind each press-clip recess.
press_clip_boss_inward_depth = 1.8; // [0.5:0.1:8]

// Extra material around the complete press-clip recess outline.
press_clip_boss_margin = 1.5; // [0.5:0.1:6]

// Overlap into the original wall that guarantees a solid union.
press_clip_boss_wall_overlap = 0.6; // [0.2:0.1:2]

/* [Inner Press Clips] */
// Selects a capsule-like rounded bar or an O---O dogbone silhouette.
press_clip_style = "rounded_bar"; // [rounded_bar, dogbone]
// End radius, neck width, total length, and extruded depth of each clip.
press_clip_end_radius = 4; // [2:0.5:12]
press_clip_neck_width = 4; // [1.5:0.5:12]
press_clip_length = 24; // [10:1:70]
press_clip_depth = 2.2; // [1:0.5:8]
press_clip_clearance = 0.35; // [0:0.05:1.5]
// Horizontal split in each end of the loose clip for spring compression. 0 disables it.
press_clip_split_gap = 0.7; // [0:0.1:3]
// Fine radial, tangential, and angular corrections for clip recess placement.
press_clip_radial_offset = 0; // [-10:0.5:10]
press_clip_tangent_offset = 0; // [-10:0.5:10]
press_clip_angle_offset = 0; // [-30:0.5:30]
// Extra twist of the recess outline within the wall plane.
press_clip_recess_twist_angle = 0; // [-30:0.5:30]
// Automatically follows the conical inner wall angle.
press_clip_auto_wall_tilt = true;
// Fine correction added to the calculated wall angle.
press_clip_wall_tilt_offset = 0; // [-15:0.1:15]
// Fixed tilt used only when automatic wall tilt is disabled.
press_clip_wall_tilt_angle = 0; // [-30:0.1:30]
press_clip_z_margin = 10; // [0:1:40]
// Number of clips distributed across each enabled seam family.
vertical_press_clips_per_seam = 1; // [1:1:5]
horizontal_press_clips_per_section = 1; // [1:1:5]
show_press_clips = true;
// Show the recess cutter geometry as solid debug shapes together with the pot.
show_press_clip_recess_debug = false;

/* [Display] */
// Explosion distance, output mode, and zero-based single-piece indices.
explode_distance = 10;    // [0:1:100]
display_mode = "assembled"; // [assembled, print_layout, single_piece, pegs_only, press_clips_only, press_recesses_only]
single_piece_radial_index = 0; // [0:1:15]
single_piece_height_index = 0; // [0:1:9]

/* [Colors] */
// Preview colours for pot pieces, loose connectors, and debug cutters.
piece_color_1 = "#4E79A7"; // 7
piece_color_2 = "#F28E2B"; // 7
piece_color_3 = "#59A14F"; // 7
piece_color_4 = "#B07AA1"; // 7
peg_color = "#DDDDDD";     // 7
press_clip_color = "#CCCCCC"; // 7
press_recess_debug_color = "#FF3333"; // 7
// Global fragment count used by curved primitives.
$fn = 48;

// ---------------------------------------------------------------------------
// Derived dimensions
// ---------------------------------------------------------------------------
// Clamp wall and connector dimensions to retain usable pot geometry.
effective_wall_thickness = min(wall_thickness, pot_bottom_radius - 6);
// Keep the lip transition above the bottom region.
effective_lip_transition_height = min(lip_transition_height, max(0, pot_height - lip_height - bottom_thickness));
effective_connector_radius = min(connector_radius, effective_wall_thickness * 0.38);
effective_press_clip_depth = min(press_clip_depth, effective_wall_thickness * 0.65);
// Receiving socket radius includes fit clearance.
socket_radius = effective_connector_radius + connector_clearance;
// Oversized radial envelope used by section clipping volumes.
outer_preview_radius = max(pot_top_radius + lip_width + 20, pot_bottom_radius + 20);

// Tangential and vertical dimensions of local connector reinforcement pads.
connector_boss_tangent_width =
    2 * (socket_radius + connector_boss_margin);

side_connector_boss_tangent_width =
    connector_length + 2 * side_connector_boss_length_margin;

side_connector_boss_height =
    2 * (socket_radius + connector_boss_margin);

// Linearly interpolates outside wall radius at height z.
function radius_at_height(z) =
    pot_bottom_radius + (pot_top_radius - pot_bottom_radius) * (z / pot_height);

// Inside radius after subtracting effective wall thickness.
function inner_radius_at_height(z) =
    max(1, radius_at_height(z) - effective_wall_thickness);

// Nominal socket centre, optionally centred in the wall, plus shared correction.
function socket_center_radius(z) =
    radius_at_height(z)
    - (socket_auto_center ? effective_wall_thickness * 0.5 : 0)
    + socket_radial_offset;

// Final centre radii for vertical and tangent-oriented socket families.
function vertical_socket_center_radius(z) =
    socket_center_radius(z) + vertical_socket_radial_offset;

// Applies the independent radial correction used by side socket cutters.
function side_socket_center_radius(z) =
    socket_center_radius(z) + side_socket_radial_offset;

// Calculates the conical wall tilt from radial change over pot height.
function pot_wall_tilt_angle() =
    atan((pot_top_radius - pot_bottom_radius) / pot_height);

// Selects automatic wall-following clip tilt or the fixed manual value.
function effective_press_clip_wall_tilt() =
    press_clip_auto_wall_tilt
        ? pot_wall_tilt_angle() + press_clip_wall_tilt_offset
        : press_clip_wall_tilt_angle;

// Recess depth includes fit clearance on both broad clip faces.
function press_clip_recess_depth() =
    effective_press_clip_depth + press_clip_clearance * 2;

// Alternates four preview colours by section indices.
function piece_color(ri, hi) =
    ((ri + hi) % 4 == 0) ? piece_color_1 :
    ((ri + hi) % 4 == 1) ? piece_color_2 :
    ((ri + hi) % 4 == 2) ? piece_color_3 : piece_color_4;

// Counts the loose dowels required across all horizontal joints.
function vertical_joint_peg_count() =
    use_socket_pegs
        ? radial_pieces * max(0, height_pieces - 1)
          * ((radial_pieces <= 1)
                ? max(3, vertical_pegs_per_section * 2)
                : vertical_pegs_per_section)
        : 0;

// Counts the loose dowels required across all radial joints.
function side_joint_peg_count() =
    (use_socket_pegs && radial_pieces > 1)
        ? radial_pieces * height_pieces * side_pegs_per_section
        : 0;

// Total number of separately printable dowels.
function total_loose_peg_count() =
    vertical_joint_peg_count() + side_joint_peg_count();

// Total number of clips required by all enabled seam systems.
function total_press_clip_count() =
    use_inner_press_clips
        ? ((use_vertical_seam_press_clips && radial_pieces > 1)
            ? radial_pieces * height_pieces * vertical_press_clips_per_seam
            : 0)
          + ((use_horizontal_seam_press_clips && height_pieces > 1)
            ? radial_pieces * (height_pieces - 1) * horizontal_press_clips_per_section
            : 0)
        : 0;

// Creates a capsule-ended dowel aligned with local X.
module rounded_dowel(r, len) {
    rotate([0, 90, 0])
        union() {
            cylinder(r = r, h = len, center = true, $fn = 40);
            translate([0, 0, len / 2]) sphere(r = r, $fn = 40);
            translate([0, 0, -len / 2]) sphere(r = r, $fn = 40);
        }
}

// Creates the same capsule-ended dowel aligned with local Z.
module vertical_dowel(r, len) {
    union() {
        cylinder(r = r, h = len, center = true, $fn = 40);
        translate([0, 0, len / 2]) sphere(r = r, $fn = 40);
        translate([0, 0, -len / 2]) sphere(r = r, $fn = 40);
    }
}

// Builds an O---O dogbone outline from two ends and a rectangular neck.
// clearance expands the outline when it is used as a recess cutter.
module dogbone_base_2d(len, end_r, neck_w, clearance = 0) {
    er = end_r + clearance;
    nw = neck_w + clearance * 2;

    union() {
        translate([-len / 2, 0]) circle(r = er, $fn = 36);
        translate([ len / 2, 0]) circle(r = er, $fn = 36);
        square([len, nw], center = true);
    }
}

// Builds a smooth capsule outline by hulling two circular endpoints.
module rounded_bar_base_2d(len, end_r, neck_w, clearance = 0) {
    er = end_r + clearance;
    nw = max(neck_w + clearance * 2, er * 1.6);

    hull() {
        translate([-len / 2, 0]) circle(r = nw / 2, $fn = 36);
        translate([ len / 2, 0]) circle(r = nw / 2, $fn = 36);
    }
}

// Selects the clip silhouette and optionally cuts spring slots into loose clips.
// Recess cutters pass split_gap=0 and therefore remain continuous.
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

// Extrudes a selected clip outline into a thin radial-wall-normal solid.
// orientation chooses whether its long axis follows the tangent or vertical axis.
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

// Positions one clearance-expanded recess against the sloped inside wall while
// correcting radial and Z placement for the cutter's tilted half-depth.
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

// Creates a rectangular connector boss overlapping the inner wall.  Its local
// X dimension is radial depth, Y is tangent width, and Z is pad height.
module inner_wall_reinforcement_pad(
    angle,
    z,
    tangent_width,
    pad_height
) {
    wall_tilt = effective_press_clip_wall_tilt();

    pad_depth =
        connector_boss_inward_depth
        + connector_boss_wall_overlap;

    // The pad extends inward into the pot while overlapping the
    // original inner wall slightly, so it remains a single solid.
    pad_center_radius =
        inner_radius_at_height(z)
        - connector_boss_inward_depth / 2
        + connector_boss_wall_overlap / 2;

    translate([
        pad_center_radius * cos(angle),
        pad_center_radius * sin(angle),
        z
    ])
        rotate([0, 0, angle])
            rotate([0, wall_tilt, 0])
                cube(
                    [
                        pad_depth,
                        tangent_width,
                        pad_height
                    ],
                    center = true
                );
}

// Adds connector bosses at both internal horizontal boundaries of one section.
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
                        connector_boss_tangent_width,
                        vertical_connector_boss_height
                    );
                }
            }
        }
    }
}

// Adds connector bosses along both radial seam planes of one section.
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
                    max(socket_radius + 0.2, z+5)
                );

                inner_wall_reinforcement_pad(
                    a,
                    zsafe,
                    side_connector_boss_tangent_width,
                    side_connector_boss_height
                );
            }
        }
    }
}

// Emits both connector-reinforcement families for one modular section.
module connector_bosses_for_section(ri, hi) {
    vertical_connector_bosses_for_section(ri, hi);
    side_connector_bosses_for_section(ri, hi);
}

// Creates a wall-following reinforcement pad behind one press-clip recess.
// Pad footprint includes both enlarged ends and the configured margin.
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

// Adds clip reinforcement along both vertical radial seams of one section.
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

// Adds vertically oriented clip reinforcement at internal horizontal seams.
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

// Emits both press-clip reinforcement families for one modular section.
module press_clip_bosses_for_section(ri, hi) {
    vertical_press_clip_bosses_for_section(ri, hi);
    horizontal_press_clip_bosses_for_section(ri, hi);
}

// Builds the complete hollow pot before modular slicing.  The tapered body and
// optional lip are united; interior, rim bevel, and drainage hole are subtracted.
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

// Creates an oversized angular clipping wedge for radial section ri.
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

// Creates an oversized horizontal clipping band for height layer hi.
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

// Places vertical capsule-shaped socket cutters at both internal horizontal
// boundaries of a section, using the same distribution as the loose dowels.
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

// Places tangent-oriented capsule socket cutters on both radial section seams.
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

// Distributes tangent-oriented clip recesses along both vertical radial seams.
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

// Distributes vertically oriented clip recesses across internal layer seams.
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

// Emits every clip cutter in the configured pot for dedicated debug display.
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

// Creates one finished section: intersect the reinforced shell with its angular
// wedge and height band, then subtract all matching sockets and clip recesses.
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

// Arranges the exact required number of separately printable dowels in a compact
// near-square grid on the build plane.
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

// Arranges the exact required number of separately printable clips in a grid.
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

// Displays every section in assembled orientation with optional explosion,
// debug cutters, and loose connector sets positioned beside the pot.
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
}

// Arranges every section in a square-like grid, lowers each layer to Z=0, and
// rotates sectors into a consistent orientation before adding loose parts.
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

// Displays one safely clamped section index plus any enabled loose connector sets.
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
}

// Top-level display dispatcher.  Unknown values fall back to assembled_pot().
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
