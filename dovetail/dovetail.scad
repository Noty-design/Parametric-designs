/* ========================================================================== */ // Starts the file header.
/* Dovetail from the box/bin model, extracted and parameterized. */ // Describes the model origin.
/* The dovetail can be screwed or glued to the back of what is mounted. */ // Describes the intended use.
/* Designed by Notydesign. */ // Credits the original designer.
/* Comments and documentation added for easier maintenance. */ // States why the file is heavily commented.
/* ========================================================================== */ // Ends the file header.
// All dimensions in this file are millimeters. // Defines the unit used by every numeric dimension.
// X is width, Y is depth/thickness, and Z is height. // Defines the coordinate convention.
// OpenSCAD Customizer reads section titles written inside square brackets. // Explains the bracketed headings below.

/* [Display options] */ // Groups settings that control preview visibility.
show_dovetail = true; // Shows the male dovetail part.
show_bracket = true; // Shows the female bracket part.
mirror_backstop = false; // Rotates the preview 180 degrees around the Y axis so the stop is mirrored.
color = "#4682B4"; // Sets the preview color for both generated parts.

/* [Dovetail male parameters] */ // Groups the main dimensions for the male dovetail.
dovetail_width_wide = 22; // Sets the widest width of the dovetail profile at the outer face.
dovetail_width_narrow = 15; // Sets the narrowest width of the dovetail profile near the plate.
dovetail_depth = 4.5; // Sets how far the dovetail profile projects in the Y direction.
dovetail_tolerance = 0.25; // Sets clearance between the male and female parts for 3D printing fit.
dovetail_plate_width = 24; // Sets the width of the male mounting plate.
dovetail_plate_thickness = 2.4; // Sets the thickness of the male mounting plate.
dovetail_plate_height = 70; // Sets the total height of the male dovetail part.

/* [Dovetail male screw hole parameters] */ // Groups screw-hole settings for the male part.
show_dovetail_screw_holes = true; // Enables through screw holes in the male part.
dovetail_screw_count = 2; // Sets the number of screw holes per row in the X direction.
dovetail_screw_row_count = 1; // Sets the number of screw rows in the Z direction.
dovetail_screw_row_spacing = 20; // Sets the center-to-center spacing between screw rows.
dovetail_screw_edge_margin = 6; // Sets the margin from each side edge to the outermost screw hole.
mount_screw_hole_diameter = 4; // Sets the diameter of the male screw holes.

/* [Dovetail male countersink parameters] */ // Groups countersink settings for the male screw holes.
male_screw_countersink_style = "none"; // [none, cone, cylinder, nut]
male_screw_countersink_side = "back"; // Selects the countersink side: front, back, or both.
male_screw_countersink_diameter = 8; // Sets the outer diameter of the male countersink.
male_screw_countersink_depth = 1.6; // Sets how deep the male countersink cuts into the part.
male_screw_nut_size = "M4"; // [M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, M13, M14]

/* [Dovetail female parameters] */ // Groups the main dimensions for the female bracket.
dovetail_female_extra_height = 5; // Adds extra height above the nominal male-part height.
dovetail_female_extra_width = 0; // Adds extra side material to the female block.
dovetail_female_rail_rib_depth = 0; // Adds outside 45-degree strengthening ribs when greater than zero.
dovetail_female_backstop_bridge_height = 0.6; // Keeps a small solid bridge above the stop so the bracket remains one connected body.
female_backstop = 5.0; // Sets the stop height below the slot so the male part cannot slide through.

/* [Dovetail female screw hole parameters] */ // Groups screw-hole settings for the female part.
show_female_screw_holes = true; // Enables through screw holes in the female part.
dovetail_female_screw_count = 2; // Sets the number of female screw holes per row in the X direction.
dovetail_female_screw_row_count = 1; // Sets the number of female screw rows in the Z direction.
dovetail_female_screw_row_spacing = 20; // Sets the center-to-center spacing between female screw rows.
dovetail_female_screw_edge_margin = 6; // Sets the margin from each female side edge to the outermost screw hole.
dovetail_female_mount_screw_hole_diameter = 4; // Sets the diameter of the female screw holes.

/* [Metric nut countersink parameters] */ // Groups settings for hexagonal metric-nut-shaped countersinks.
metric_nut_countersink_clearance = 0.25; // Adds extra flat-to-flat clearance to metric nut pockets for printer tolerance.

/* [Dovetail female countersink parameters] */ // Groups countersink settings for the female screw holes.
female_screw_countersink_style = "none"; // [none, cone, cylinder, nut]
female_screw_countersink_side = "front"; // Selects the countersink side: front, back, or both.
female_screw_countersink_diameter = 8; // Sets the outer diameter of the female countersink.
female_screw_countersink_depth = 1.6; // Sets how deep the female countersink cuts into the part.
female_screw_nut_size = "M4"; // [M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, M13, M14]

/* [Helper variables] */ // Groups internal helper values.
distance_between_brackets = -5.0; // Offsets the female bracket in Y so both parts are visible in preview.

/* Main preview */ // Starts the top-level rendering logic.
if (mirror_backstop) { // Uses a rotated render group when the mirrored view is enabled.
    translate([0, 0, dovetail_plate_height]) // Moves the model upward before rotation so it stays near the work plane.
    rotate([0, 180, 0]) { // Rotates the selected preview geometry 180 degrees around the Y axis.
        if (show_dovetail) { // Checks whether the male part should be displayed.
            dovetail_male(); // Renders the male dovetail part.
        } // Ends the mirrored male-part visibility check.
        if (show_bracket) { // Checks whether the female bracket should be displayed.
            dovetail_female(); // Renders the female bracket part.
        } // Ends the mirrored female-part visibility check.
    } // Ends the rotated preview group.
} else { // Uses the normal orientation when mirroring is disabled.
    if (show_dovetail) { // Checks whether the male part should be displayed.
        dovetail_male(); // Renders the male dovetail part.
    } // Ends the male-part visibility check.
    if (show_bracket) { // Checks whether the female bracket should be displayed.
        dovetail_female(); // Renders the female bracket part.
    } // Ends the female-part visibility check.
} // Ends the top-level rendering logic.

module dovetail_male() { // Defines the male part with plate, dovetail profile, and optional screw holes.
    color(color) // Applies the preview color to the male part.
    difference() { // Creates the final shape by subtracting holes from the solid geometry.
        union() { // Combines the mounting plate and dovetail profile into one body.
            translate([-dovetail_plate_width / 2, 0, 0]) // Centers the mounting plate in the X direction.
            cube([dovetail_plate_width, dovetail_plate_thickness, dovetail_plate_height]); // Creates the flat mounting plate.

            translate([0, 0, dovetail_plate_height / 2]) // Moves the profile so it is centered over the part height.
            hull() { // Builds a trapezoid-like dovetail profile between two thin rectangles.
                translate([0, -0.01, 0]) // Places the narrow profile line near the plate face.
                cube([dovetail_width_narrow, 0.01, dovetail_plate_height], center = true); // Creates the narrow side of the dovetail profile.

                translate([0, -dovetail_depth, 0]) // Places the wide profile line at the outer Y position.
                cube([dovetail_width_wide, 0.01, dovetail_plate_height], center = true); // Creates the wide side of the dovetail profile.
            } // Ends the hull used for the male profile.
        } // Ends the male solid geometry.

        if (show_dovetail_screw_holes) { // Cuts screw holes only when the setting is enabled.
            hole_positions = (dovetail_screw_count == 1) ? [0] // Uses the center position when only one screw hole is requested.
                : [for (i = [0 : dovetail_screw_count - 1]) // Calculates multiple screw holes evenly across the plate width.
                    -dovetail_plate_width / 2 + dovetail_screw_edge_margin + i * (dovetail_plate_width - 2 * dovetail_screw_edge_margin) / max(1, dovetail_screw_count - 1)]; // Returns X positions with edge margins.
            row_count = max(1, dovetail_screw_row_count); // Ensures at least one screw row is used.
            row_positions = (row_count == 1) ? [dovetail_plate_height / 2] // Centers a single row on the part height.
                : [for (r = [0 : row_count - 1]) // Calculates multiple rows in the Z direction.
                    dovetail_plate_height / 2 - ((row_count - 1) * dovetail_screw_row_spacing) / 2 + r * dovetail_screw_row_spacing]; // Returns Z positions centered around the part midpoint.
            for (x_pos = hole_positions) { // Iterates over every calculated X position.
                for (z_pos = row_positions) { // Iterates over every calculated Z position.
                    screw_hole_with_countersink( // Cuts one through hole and any requested countersink.
                        x_pos = x_pos, // Passes the screw-hole X position.
                        y_pos = dovetail_plate_thickness / 2, // Places the cutter through the plate in the Y direction.
                        z_pos = z_pos, // Passes the screw-hole Z position.
                        hole_length = dovetail_depth + dovetail_plate_thickness + 5, // Makes the cutter longer than the part so it fully clears the geometry.
                        hole_diameter = mount_screw_hole_diameter, // Passes the male screw-hole diameter.
                        countersink_style = male_screw_countersink_style, // Passes the selected countersink style.
                        countersink_side = male_screw_countersink_side, // Passes the selected countersink side.
                        countersink_diameter = male_screw_countersink_diameter, // Passes the countersink diameter.
                        countersink_depth = male_screw_countersink_depth, // Passes the countersink depth.
                        nut_size = male_screw_nut_size, // Passes the selected male nut-pocket size.
                        front_surface_y = -dovetail_depth, // Defines the front surface at the dovetail side.
                        back_surface_y = dovetail_plate_thickness // Defines the back surface at the plate side.
                    ); // Ends the hole-and-countersink cutter call.
                } // Ends the Z-position loop.
            } // Ends the X-position loop.
        } // Ends the male screw-hole condition.
    } // Ends the male difference operation.
} // Ends the male dovetail module.

module dovetail_female() { // Defines the female bracket with receiving slot, stop, ribs, and screw holes.
    dovetail_female_width = dovetail_plate_width + dovetail_female_extra_width; // Calculates the total female block width.
    dovetail_female_bridge_height = min(dovetail_female_backstop_bridge_height, max(0, dovetail_female_extra_height)); // Limits the bridge height to the available extra height.
    dovetail_female_slot_height = dovetail_plate_height + dovetail_female_extra_height - dovetail_female_bridge_height + 0.1; // Calculates the slot cutter height with a small overlap.

    color(color) // Applies the preview color to the female bracket.
    translate([0, distance_between_brackets, 0]) // Moves the female bracket in Y for a clearer preview.
    difference() { // Creates the female bracket by subtracting slot and holes from the block.
        union() { // Combines the solid block and optional ribs.
            translate([-dovetail_female_width / 2, -dovetail_depth - dovetail_plate_thickness - dovetail_tolerance, -female_backstop]) // Places the block with the stop below the zero plane.
            cube([dovetail_female_width, dovetail_depth + dovetail_plate_thickness + dovetail_tolerance, dovetail_plate_height + dovetail_female_extra_height + female_backstop]); // Creates the solid receiving block.

            if (dovetail_female_rail_rib_depth > 0) { // Adds ribs only when rib depth is enabled.
                female_rail_ribs(dovetail_female_width, dovetail_female_rail_rib_depth); // Creates strengthening ribs along the outside of the slot rails.
            } // Ends the rib condition.
        } // Ends the female solid geometry.

        translate([0, 0, dovetail_female_bridge_height + dovetail_female_slot_height / 2]) // Positions the slot cutter above the stop and bridge.
        hull() { // Builds a trapezoid-like negative volume matching the male profile.
            translate([0, 0, 0]) // Places the narrow negative profile line at the slot front.
            cube([dovetail_width_narrow + dovetail_tolerance, 0.01, dovetail_female_slot_height], center = true); // Cuts the narrow slot side with tolerance.

            translate([0, -dovetail_depth, 0]) // Places the wide negative profile line farther back in the slot.
            cube([dovetail_width_wide + dovetail_tolerance, 0.01, dovetail_female_slot_height], center = true); // Cuts the wide slot side with tolerance.
        } // Ends the hull used to cut the female slot.

        if (show_female_screw_holes) { // Cuts female screw holes only when the setting is enabled.
            female_front_screw_surface_y = -dovetail_depth; // Defines the slot-bottom/front surface Y position for countersinks.
            female_back_screw_surface_y = -dovetail_depth - dovetail_plate_thickness - dovetail_tolerance; // Defines the back surface Y position for countersinks.

            hole_positions = (dovetail_female_screw_count == 1) ? [0] // Uses the center position when only one female screw hole is requested.
                : [for (i = [0 : dovetail_female_screw_count - 1]) // Calculates multiple female screw holes evenly across the width.
                    -dovetail_female_width / 2 + dovetail_female_screw_edge_margin + i * (dovetail_female_width - 2 * dovetail_female_screw_edge_margin) / max(1, dovetail_female_screw_count - 1)]; // Returns X positions with female edge margins.

            row_count = max(1, dovetail_female_screw_row_count); // Ensures at least one female screw row is used.
            row_positions = (row_count == 1) ? [dovetail_plate_height / 2 + dovetail_female_extra_height / 2] // Centers a single row over the active female height.
                : [for (r = [0 : row_count - 1]) // Calculates multiple female rows in the Z direction.
                    dovetail_plate_height / 2 + dovetail_female_extra_height / 2 - ((row_count - 1) * dovetail_female_screw_row_spacing) / 2 + r * dovetail_female_screw_row_spacing]; // Returns Z positions centered around the female bracket.

            for (x_pos = hole_positions) { // Iterates over every calculated female X position.
                for (z_pos = row_positions) { // Iterates over every calculated female Z position.
                    screw_hole_with_countersink( // Cuts one female through hole and any requested countersink.
                        x_pos = x_pos, // Passes the screw-hole X position.
                        y_pos = -dovetail_plate_thickness / 2, // Places the cutter through the female block wall.
                        z_pos = z_pos, // Passes the screw-hole Z position.
                        hole_length = dovetail_depth + dovetail_plate_thickness + 6, // Makes the cutter long enough to fully clear the female wall.
                        hole_diameter = dovetail_female_mount_screw_hole_diameter, // Passes the female screw-hole diameter.
                        countersink_style = female_screw_countersink_style, // Passes the female countersink style.
                        countersink_side = female_screw_countersink_side, // Passes the female countersink side.
                        countersink_diameter = female_screw_countersink_diameter, // Passes the female countersink diameter.
                        countersink_depth = female_screw_countersink_depth, // Passes the female countersink depth.
                        nut_size = female_screw_nut_size, // Passes the selected female nut-pocket size.
                        front_surface_y = female_front_screw_surface_y, // Defines the female front surface for countersinking.
                        back_surface_y = female_back_screw_surface_y // Defines the female back surface for countersinking.
                    ); // Ends the female hole-and-countersink cutter call.
                } // Ends the female Z-position loop.
            } // Ends the female X-position loop.
        } // Ends the female screw-hole condition.
    } // Ends the female difference operation.
} // Ends the female bracket module.

module female_rail_ribs(female_width, rib_depth) { // Defines optional outside strengthening ribs for the female bracket.
    rib_height = dovetail_plate_height + dovetail_female_extra_height + female_backstop; // Calculates the full rib height including the stop.
    rib_y_back = -dovetail_depth - dovetail_plate_thickness - dovetail_tolerance; // Defines the back Y position of each rib.
    rib_y_front = -dovetail_depth; // Defines the front Y position of each rib near the slot.
    rib_width = min(rib_depth, max(0.01, dovetail_female_extra_width / 2 + (dovetail_plate_width - dovetail_width_wide - dovetail_tolerance) / 2)); // Limits rib width so it fits beside the slot.

    for (side = [-1, 1]) { // Creates one rib on the left side and one on the right side.
        hull() { // Builds a tapered rib between a wider rear edge and a narrow front edge.
            translate([side * (female_width / 2 - rib_width / 2), rib_y_back, rib_height / 2 - female_backstop]) // Places the wide rear edge of the rib.
            cube([rib_width, 0.01, rib_height], center = true); // Creates the wide rear rib face.

            translate([side * (female_width / 2 - rib_width / 2), rib_y_front, rib_height / 2 - female_backstop]) // Places the narrow front edge of the rib.
            cube([0.01, 0.01, rib_height], center = true); // Creates the rib tip near the slot.
        } // Ends the hull for one rib.
    } // Ends the side loop for the ribs.
} // Ends the rib module.

module screw_hole_with_countersink( // Defines a through hole with an optional countersink.
    x_pos, // Receives the hole X position.
    y_pos, // Receives the hole Y position.
    z_pos, // Receives the hole Z position.
    hole_length, // Receives the cutting length of the hole.
    hole_diameter, // Receives the hole diameter.
    countersink_style, // Receives the countersink style.
    countersink_side, // Receives which side should be countersunk.
    countersink_diameter, // Receives the countersink diameter.
    countersink_depth, // Receives the countersink depth.
    nut_size, // Receives the selected metric nut-pocket size.
    front_surface_y, // Receives the front surface Y position.
    back_surface_y // Receives the back surface Y position.
) { // Starts the hole module body.
    translate([x_pos, y_pos, z_pos]) // Places the cylinder where the hole should be cut.
    rotate([90, 0, 0]) // Rotates the cylinder so the hole runs along the Y axis.
    cylinder(h = hole_length, d = hole_diameter, center = true, $fn = 48); // Creates the negative cylinder for the round through hole.

    if (countersink_style != "none" && countersink_depth > 0) { // Creates countersinks only when a style and positive depth are set.
        if (countersink_side == "front" || countersink_side == "both") { // Checks whether the front side should be countersunk.
            screw_countersink_at( // Cuts one countersink at the front surface.
                x_pos = x_pos, // Passes the hole X position.
                surface_y = front_surface_y, // Passes the front surface Y position.
                z_pos = z_pos, // Passes the hole Z position.
                hole_diameter = hole_diameter, // Passes the through-hole diameter.
                countersink_style = countersink_style, // Passes the countersink style.
                countersink_diameter = countersink_diameter, // Passes the countersink diameter.
                countersink_depth = countersink_depth, // Passes the countersink depth.
                nut_size = nut_size, // Passes the selected metric nut-pocket size.
                inward_direction_y = (front_surface_y < back_surface_y) ? 1 : -1 // Calculates the inward cutting direction from the front surface.
            ); // Ends the front countersink call.
        } // Ends the front countersink condition.

        if (countersink_side == "back" || countersink_side == "both") { // Checks whether the back side should be countersunk.
            screw_countersink_at( // Cuts one countersink at the back surface.
                x_pos = x_pos, // Passes the hole X position.
                surface_y = back_surface_y, // Passes the back surface Y position.
                z_pos = z_pos, // Passes the hole Z position.
                hole_diameter = hole_diameter, // Passes the through-hole diameter.
                countersink_style = countersink_style, // Passes the countersink style.
                countersink_diameter = countersink_diameter, // Passes the countersink diameter.
                countersink_depth = countersink_depth, // Passes the countersink depth.
                nut_size = nut_size, // Passes the selected metric nut-pocket size.
                inward_direction_y = (back_surface_y < front_surface_y) ? 1 : -1 // Calculates the inward cutting direction from the back surface.
            ); // Ends the back countersink call.
        } // Ends the back countersink condition.
    } // Ends the countersink logic.
} // Ends the hole-with-countersink module.

function nut_corner_to_corner_diameter(nut_size, hole_diameter) = // Converts the selected nut size to a hex corner-to-corner diameter.
    max((metric_nut_across_flats(nut_size) + metric_nut_countersink_clearance) / cos(30), hole_diameter / cos(30)); // Keeps the hex pocket at least as wide as the round hole.

function metric_nut_across_flats(nut_size) = // Returns common ISO metric hex nut flat-to-flat width in millimeters.
    nut_size == "M2" ? 4 :
    nut_size == "M3" ? 5.5 :
    nut_size == "M4" ? 7 :
    nut_size == "M5" ? 8 :
    nut_size == "M6" ? 10 :
    nut_size == "M7" ? 11 :
    nut_size == "M8" ? 13 :
    nut_size == "M9" ? 15 :
    nut_size == "M10" ? 17 :
    nut_size == "M11" ? 18 :
    nut_size == "M12" ? 19 :
    nut_size == "M13" ? 21 :
    nut_size == "M14" ? 22 :
    4; // Falls back to an M2-sized flat width if an unknown value is used.

module screw_countersink_at( // Defines one countersink at a specified surface.
    x_pos, // Receives the countersink X position.
    surface_y, // Receives the Y position of the surface where the countersink starts.
    z_pos, // Receives the countersink Z position.
    hole_diameter, // Receives the base through-hole diameter.
    countersink_style, // Receives the countersink style.
    countersink_diameter, // Receives the requested countersink diameter.
    countersink_depth, // Receives the requested countersink depth.
    nut_size, // Receives the selected metric nut-pocket size.
    inward_direction_y // Receives the inward cutting direction along the Y axis.
) { // Starts the countersink module body.
    safe_countersink_diameter = max(countersink_diameter, hole_diameter); // Ensures the countersink is never smaller than the through hole.
    translate([x_pos, surface_y - inward_direction_y * 0.01, z_pos]) // Places the countersink with a tiny overlap against the surface.
    rotate([inward_direction_y > 0 ? -90 : 90, 0, 0]) { // Rotates the countersink so it cuts into the material.
        if (countersink_style == "cone") { // Selects a conical countersink.
            cylinder( // Creates the conical negative volume.
                h = countersink_depth + 0.02, // Adds a small extra depth for reliable boolean subtraction.
                d1 = safe_countersink_diameter, // Sets the outer diameter at the surface.
                d2 = hole_diameter, // Sets the inner diameter at the through hole.
                center = false, // Starts the cylinder at the surface instead of centering it.
                $fn = 64 // Uses more facets for a smoother countersink.
            ); // Ends the conical cylinder.
        } else if (countersink_style == "cylinder") { // Selects a cylindrical counterbore.
            cylinder( // Creates the cylindrical negative volume.
                h = countersink_depth + 0.02, // Adds a small extra depth for reliable boolean subtraction.
                d = safe_countersink_diameter, // Sets the counterbore diameter.
                center = false, // Starts the cylinder at the surface instead of centering it.
                $fn = 64 // Uses more facets for a smoother counterbore.
            ); // Ends the cylindrical counterbore.
        } else if (countersink_style == "nut") { // Selects a hexagonal metric nut pocket.
            rotate([0, 0, 30]) // Aligns the hex with flat sides across the visible pocket profile.
            cylinder( // Creates the hexagonal negative pocket for a metric nut.
                h = countersink_depth + 0.02, // Adds a small extra depth for reliable boolean subtraction.
                d = nut_corner_to_corner_diameter(nut_size, hole_diameter), // Uses the selected nut size plus clearance.
                center = false, // Starts the pocket at the surface instead of centering it.
                $fn = 6 // Uses six facets to match a hex nut.
            ); // Ends the hexagonal nut pocket.
        } // Ends the countersink-style selection.
    } // Ends the countersink rotation block.
} // Ends the single-countersink module.
