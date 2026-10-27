/* ========================================================================== 

   Modular Flower Pot Model for 3D Printing
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   DESCRIPTION
   -----------
   A customizable tapered flower pot divided into detachable radial and vertical
   sections.  Matching spherical pegs and sockets align the sections after they
   have been printed separately.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.  The assembled pot is centred on the global
   Z axis, starts at Z=0, and opens toward positive Z.  Radial sections advance
   counter-clockwise around Z when viewed from above.

   CONSTRUCTION
   ------------
   main_pot_shell() first creates one complete hollow pot.  Each printable piece
   is then isolated by intersecting that shell with one angular wedge and one
   horizontal height band.  Connector pegs are added and matching sockets are
   subtracted from the resulting section.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */ 


/* [Dimensions] */
// Outside radius at the top of the tapered wall, before the lip is added.
pot_top_radius = 100;     // [30:5:300]
// Outside radius at the bottom of the pot.
pot_bottom_radius = 70;   // [20:5:250]
// Total assembled pot height from the base to the upper rim.
pot_height = 150;         // [50:5:400]
// Requested radial thickness of the side wall.  A derived safety limit prevents
// it from consuming the entire bottom radius.
wall_thickness = 10;      // [4:1:30]
// Thickness of the solid base retained beneath the hollow interior.
bottom_thickness = 8;     // [2:1:30]
// Radius of the central drainage hole; set to zero to keep a closed base.
drain_hole_radius = 15;   // [0:1:50]

/* [Smooth Rim and Lip] */
// Additional radial width of the reinforced top lip.
lip_width = 8;            // [0:1:40]
// Vertical height of the straight cylindrical upper lip band.
lip_height = 10;          // [0:1:50]
// Height of the tapered outside transition into the wider lip.  The ramp avoids
// a sudden horizontal ledge that would otherwise require support.
lip_transition_height = 14; // [0:1:60]
// Radial depth and vertical height of the small bevel inside the pot mouth.
inner_rim_bevel = 3;      // [0:0.5:12]

/* [Sections] */
// Number of detachable angular sections around the circumference.
radial_pieces = 4;        // [1:1:16]
// Number of detachable horizontal layers stacked along Z.
height_pieces = 3;        // [1:1:10]

/* [Connectors] */
// Radial clearance added to receiving sockets relative to their matching pegs.
clearance = 0.25;         // [0:0.05:1.5]
// Requested radius of each spherical alignment connector.
connector_radius = 3;     // [1.5:0.25:8]

/* [Display] */
// Visual separation between neighbouring pieces in assembled preview mode.
// Set to zero to show all pieces in their true assembled positions.
explode_distance = 10;    // [0:1:100]
// Selects an exploded assembly, a tiled print arrangement, or one chosen piece.
display_mode = "assembled"; // [assembled, print_layout, single_piece]
// Zero-based angular index displayed in single_piece mode.
single_piece_radial_index = 0; // [0:1:15]
// Zero-based layer index displayed in single_piece mode.
single_piece_height_index = 0; // [0:1:9]

/* [Colors] */
// Four preview colours alternate according to radial and vertical piece indices.
// Colour assignments aid assembly inspection but are not stored in an STL file.
piece_color_1 = "#4E79A7"; // 7
piece_color_2 = "#F28E2B"; // 7
piece_color_3 = "#59A14F"; // 7
piece_color_4 = "#B07AA1"; // 7

// Global fragment count used for curved primitives in this model.
$fn = 44;

// Clamp the wall so at least 6 mm of usable radial space remains at the base.
effective_wall_thickness = min(wall_thickness, pot_bottom_radius - 6);

// Prevent the lip transition from extending below the solid base region.
effective_lip_transition_height = min(lip_transition_height, max(0, pot_height - lip_height - bottom_thickness));

// Keep connectors comfortably within the effective wall thickness.
effective_connector_radius = min(connector_radius, effective_wall_thickness * 0.38);

// Oversized radial envelope used to construct reliable clipping volumes.
outer_preview_radius = max(pot_top_radius + lip_width + 20, pot_bottom_radius + 20);

// Linearly interpolates the outside wall radius at any Z height.
function radius_at_height(height_value) = pot_bottom_radius + (pot_top_radius - pot_bottom_radius) * (height_value / pot_height);

// Selects one of four preview colours using a checkerboard-like index pattern.
function piece_color(radial_index, height_index) =
    ((radial_index + height_index) % 4 == 0) ? piece_color_1 :
    ((radial_index + height_index) % 4 == 1) ? piece_color_2 :
    ((radial_index + height_index) % 4 == 2) ? piece_color_3 : piece_color_4;

// Builds the complete unsliced pot shell used as source geometry by every piece.
// The outer body and optional lip are united first; the interior, rim bevel, and
// drainage hole are then removed in one difference operation.
module main_pot_shell() {
    difference() {
        union() {
            // Main tapered solid from which the hollow interior is removed below.
            cylinder(r1 = pot_bottom_radius, r2 = pot_top_radius, h = pot_height);

            // Smooth outside ramp leading into the lip, avoiding a ledge that
            // would require support when printed upright.
            if (lip_width > 0 && effective_lip_transition_height > 0) {
                transition_start_z = pot_height - lip_height - effective_lip_transition_height;
                translate([0, 0, transition_start_z])
                    cylinder(
                        r1 = radius_at_height(transition_start_z),
                        r2 = pot_top_radius + lip_width,
                        h = effective_lip_transition_height
                    );
            }

            // Straight reinforced lip band at the top of the pot.
            if (lip_width > 0 && lip_height > 0) {
                translate([0, 0, pot_height - lip_height])
                    cylinder(r = pot_top_radius + lip_width, h = lip_height);
            }
        }

        // Primary interior cutter begins above the retained bottom thickness.
        // Its upper radius leaves room for the separate inward rim bevel.
        translate([0, 0, bottom_thickness])
            cylinder(
                r1 = max(1, pot_bottom_radius - effective_wall_thickness),
                r2 = max(1, pot_top_radius - effective_wall_thickness - inner_rim_bevel),
                h = max(1, pot_height - bottom_thickness + 0.02)
            );
        if (inner_rim_bevel > 0) {
            // A second short frustum opens the inner edge toward the true wall
            // radius, producing a softer and easier-to-print mouth.
            translate([0, 0, pot_height - inner_rim_bevel])
                cylinder(
                    r1 = max(1, pot_top_radius - effective_wall_thickness - inner_rim_bevel),
                    r2 = max(1, pot_top_radius - effective_wall_thickness),
                    h = inner_rim_bevel + 0.04
                );
        }

        // Drainage cutter extends 1 mm beyond both sides of the base to guarantee
        // a clean through-hole after the boolean subtraction.
        if (drain_hole_radius > 0) {
            translate([0, 0, -1])
                cylinder(r = min(drain_hole_radius, max(1, pot_bottom_radius - effective_wall_thickness - 2)), h = bottom_thickness + 2);
        }
    }
}

// Creates the angular clipping wedge for one radial piece.
// The generated solid is deliberately much larger than the pot radius, ensuring
// the intersection boundary is controlled only by the wedge angles.
module radial_cut_volume(radial_index) {
    if (radial_pieces <= 1) {
        // A single radial piece receives a full circular clipping volume.
        translate([0, 0, -1]) cylinder(r = outer_preview_radius * 3, h = pot_height + 2, $fn = 48);
    } else {
        // Calculate the beginning and end angles of this zero-based sector.
        angle_start = radial_index * 360 / radial_pieces;
        angle_end = (radial_index + 1) * 360 / radial_pieces;

        // Sample the outer arc often enough to approximate the wedge smoothly.
        angle_step = max(2, (angle_end - angle_start) / 10);

        // Start at the origin, traverse the sampled arc, and explicitly append
        // the exact final angle so range rounding cannot leave the wedge short.
        polygon_points = concat(
            [[0, 0]],
            [for (current_angle = [angle_start : angle_step : angle_end])
                [outer_preview_radius * 3 * cos(current_angle), outer_preview_radius * 3 * sin(current_angle)]],
            [[outer_preview_radius * 3 * cos(angle_end), outer_preview_radius * 3 * sin(angle_end)]]
        );

        // Extrude slightly beyond the pot at both Z ends for robust intersection.
        translate([0, 0, -1])
            linear_extrude(height = pot_height + 2)
                polygon(polygon_points);
    }
}

// Creates the horizontal clipping band for one stacked height layer.
module height_cut_volume(height_index) {
    // Divide the total pot height into equal Z intervals.
    z_start = height_index * pot_height / height_pieces;
    z_end = (height_index + 1) * pot_height / height_pieces;

    // The oversized radius guarantees full coverage of the pot and lip.
    translate([0, 0, z_start])
        cylinder(r = outer_preview_radius * 3, h = z_end - z_start, $fn = 48);
}

// Places spherical pegs on the upper horizontal seam of one modular section.
// Setting socket=true increases each sphere by clearance so the same placement
// logic can also generate perfectly aligned receiving cutters.
module vertical_stack_pegs(radial_index, height_index, socket = false) {
    // The uppermost layer has no layer above it and therefore needs no top pegs.
    if (height_index < height_pieces - 1) {
        // Locate the shared horizontal seam and its mid-wall radial position.
        seam_z = (height_index + 1) * pot_height / height_pieces;
        seam_radius = radius_at_height(seam_z) - effective_wall_thickness * 0.5;

        // A one-piece circumference uses four distributed connectors; a radial
        // sector uses two connectors distributed within its own angular span.
        peg_count = (radial_pieces <= 1) ? 4 : 2;
        for (peg_number = [1 : peg_count]) {
            // Fractional placement avoids both angular edges of the section.
            local_fraction = peg_number / (peg_count + 1);
            peg_angle = radial_index * 360 / max(1, radial_pieces) + local_fraction * 360 / max(1, radial_pieces);
            translate([seam_radius * cos(peg_angle), seam_radius * sin(peg_angle), seam_z])
                sphere(r = effective_connector_radius + (socket ? clearance : 0), $fn = 32);
        }
    }
}

// Generates receiving sockets on the lower horizontal seam of a section by
// reusing the previous layer's upper-peg coordinates with socket clearance.
module vertical_stack_sockets(radial_index, height_index) {
    if (height_index > 0) {
        vertical_stack_pegs(radial_index, height_index - 1, true);
    }
}

// Places spherical pegs along the section's forward radial seam.
// socket=true expands the spheres for use as matching boolean cutters.
module radial_side_pegs(radial_index, height_index, socket = false) {
    if (radial_pieces > 1) {
        seam_angle = (radial_index + 1) * 360 / radial_pieces;
        peg_count = 2;
        for (peg_number = [1 : peg_count]) {
            // Distribute connectors vertically away from layer boundaries.
            local_fraction = peg_number / (peg_count + 1);
            peg_z = height_index * pot_height / height_pieces + local_fraction * pot_height / height_pieces;
            peg_radius_from_center = radius_at_height(peg_z) - effective_wall_thickness * 0.5;
            translate([peg_radius_from_center * cos(seam_angle), peg_radius_from_center * sin(seam_angle), peg_z])
                sphere(r = effective_connector_radius + (socket ? clearance : 0), $fn = 32);
        }
    }
}

// Cuts sockets into the section's trailing radial seam.  Modular arithmetic
// wraps radial index zero back to the final sector, closing the circumference.
module radial_side_sockets(radial_index, height_index) {
    if (radial_pieces > 1) {
        previous_radial_index = (radial_index + radial_pieces - 1) % radial_pieces;
        radial_side_pegs(previous_radial_index, height_index, true);
    }
}

// Creates one finished printable section.
// First isolate the requested shell region, then add this piece's outgoing pegs,
// and finally subtract sockets that receive pegs from neighbouring pieces.
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

// Displays every section in its assembled orientation with optional radial and
// vertical explosion offsets.  The offsets are preview aids, not connector gaps.
module assembled_pot() {
    for (height_index = [0 : height_pieces - 1]) {
        for (radial_index = [0 : radial_pieces - 1]) {
            // Use the sector's middle angle so every piece moves directly outward.
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

// Arranges all modular sections in a square-like grid for inspection or export.
// Each piece is lowered to Z=0 and rotated so its angular centre faces a common
// direction; users should still confirm final slicer orientation and spacing.
module print_layout() {
    total_sections = radial_pieces * height_pieces;

    // The ceiling of the square root gives enough columns for every section.
    columns = ceil(sqrt(total_sections));
    layout_spacing = (pot_top_radius + lip_width) * 2.7;
    for (height_index = [0 : height_pieces - 1]) {
        for (radial_index = [0 : radial_pieces - 1]) {
            // Flatten the two-dimensional pair of indices into one grid index.
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

// Displays one safely clamped section, moved to the build plane and rotated into
// the same standard orientation used by print_layout().
module selected_single_piece() {
    // Clamp user-facing indices to the currently configured piece counts.
    selected_radial = min(single_piece_radial_index, radial_pieces - 1);
    selected_height = min(single_piece_height_index, height_pieces - 1);
    section_start_z = selected_height * pot_height / height_pieces;
    middle_angle = (radial_pieces > 1) ? (selected_radial + 0.5) * 360 / radial_pieces : 0;
    translate([0, 0, -section_start_z])
        rotate([0, 0, -middle_angle])
            color(piece_color(selected_radial, selected_height))
                modular_section(selected_radial, selected_height);
}

// Top-level display dispatcher.  Unknown values intentionally fall back to the
// assembled view so the model never renders empty due to a mistyped mode.
if (display_mode == "print_layout") {
    print_layout();
} else if (display_mode == "single_piece") {
    selected_single_piece();
} else {
    assembled_pot();
}
