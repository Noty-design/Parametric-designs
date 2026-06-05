/* ==========================================================================
    Dovetail from the box/ bin model, extracted and parameterized for stand-alone use.
    The dovetail can be screwed or glued to the back of what needs to be mounted.
    
    Designed by Notydesign
/* ==========================================================================

/* [Display options] */
show_dovetail = true;         // Render the mating male dovetail.
show_bracket = true;          // Render the mating female bracket.

//Female backstop bottom/top
mirror_backstop = false;          // Mirror the view by rotating 180° around Y axis
color = "#4682B4";

/* [Dovetail male parameters] */
dovetail_width_wide = 22;
dovetail_width_narrow = 15;
dovetail_depth = 4.5;
dovetail_tolerance = 0.25;
dovetail_plate_width = 24;
dovetail_plate_thickness = 2.4;
dovetail_plate_height = 70;


/* [Dovetail male screw hole parameters] */
show_dovetail_screw_holes = true;
dovetail_screw_count = 2;
dovetail_screw_row_count = 1;
dovetail_screw_row_spacing = 20;
dovetail_screw_edge_margin = 6;
mount_screw_hole_diameter = 4;

/* [Dovetail female parameters] */
// Adds extra height to the female. 0 = same height as male
dovetail_female_extra_height = 5;
female_backstop = 5.0; // stopping for the dovetail

/* [Dovetail female screw hole parameters] */
// Female screw hole parameters (independent from male)
show_female_screw_holes = true;
dovetail_female_screw_count = 2;
dovetail_female_screw_row_count = 1;
dovetail_female_screw_row_spacing = 20;
dovetail_female_screw_edge_margin = 6;
dovetail_female_mount_screw_hole_diameter = 4;

/* [Helper variables] */
distance_between_brackets = -5.0;


/* Main preview */
if (mirror_backstop) {
    translate([0, 0, dovetail_plate_height])
    rotate([0, 180, 0]) {
        if (show_dovetail) {
            dovetail_male();
        }
        if (show_bracket) {
            dovetail_female();
        }
    }
} else {
    if (show_dovetail) {
        dovetail_male();
    }
    if (show_bracket) {
        dovetail_female();
    }
}

module dovetail_male() {
    color(color)
    difference() {
        union() {
            // Solid dovetail plate base with a stop in the Y direction to prevent over-insertion
            translate([-dovetail_plate_width/2, 0, 0])
            cube([dovetail_plate_width, dovetail_plate_thickness, dovetail_plate_height]);

            // Create the dovetail profile using hull to ensure clean geometry without coplanar faces
            translate([0, 0, dovetail_plate_height/2])
            hull() {
                translate([0, -0.01, 0])
                cube([dovetail_width_narrow, 0.01, dovetail_plate_height], center=true);

                translate([0, -dovetail_depth, 0])
                cube([dovetail_width_wide, 0.01, dovetail_plate_height], center=true);
            }
        }

        if (show_dovetail_screw_holes) {
            // Calculate hole positions based on the number of screws and edge margins
            hole_positions = (dovetail_screw_count == 1) ? [0]
                : [for (i = [0 : dovetail_screw_count - 1])
                    -dovetail_plate_width/2 + dovetail_screw_edge_margin + i * (dovetail_plate_width - 2 * dovetail_screw_edge_margin) / max(1, dovetail_screw_count - 1)];
            // Calculate row positions based on the number of rows and spacing
            row_count = max(1, dovetail_screw_row_count);
            row_positions = (row_count == 1) ? [dovetail_plate_height/2]
                : [for (r = [0 : row_count - 1])
                    dovetail_plate_height/2 - ((row_count - 1) * dovetail_screw_row_spacing) / 2 + r * dovetail_screw_row_spacing];
            // Create holes at the calculated positions, adding extra length to ensure they go through the entire piece
            for (x_pos = hole_positions) {
                for (z_pos = row_positions) {
                    translate([x_pos, dovetail_plate_thickness/2, z_pos])
                    rotate([90, 0, 0])
                    // Added 5 extra length to ensure the hole goes through the entire piece, even with slight misalignments
                    cylinder(h = dovetail_depth + dovetail_plate_thickness + 5, d = mount_screw_hole_diameter, center = true, $fn = 48);
                }
            }
        }
    }
}

module dovetail_female() {
    color(color)
    translate([0, distance_between_brackets, 0])
    difference() {
        // Solid receiving block with a stop in the Z direction
        translate([-dovetail_plate_width/2, -dovetail_depth - dovetail_plate_thickness - dovetail_tolerance, -female_backstop])
        cube([dovetail_plate_width, dovetail_depth + dovetail_plate_thickness + dovetail_tolerance, dovetail_plate_height + dovetail_female_extra_height + female_backstop]);

        // Carve the matching dovetail cavity, expanded upward with extra height
        translate([0, 0, dovetail_plate_height/2 + dovetail_female_extra_height/2])
        hull() {
            translate([0, 0, 0])
            // added 0.1 to avoid coplanar faces which can cause rendering issues in some viewers
            cube([dovetail_width_narrow + dovetail_tolerance, 0.01, dovetail_plate_height + dovetail_female_extra_height + 0.1], center=true);

            translate([0, -dovetail_depth, 0])
            cube([dovetail_width_wide + dovetail_tolerance, 0.01, dovetail_plate_height + dovetail_female_extra_height], center=true);
        }

        if (show_female_screw_holes) {
            hole_positions = (dovetail_female_screw_count == 1) ? [0]
                : [for (i = [0 : dovetail_female_screw_count - 1])
                    -dovetail_plate_width/2 + dovetail_female_screw_edge_margin + i * (dovetail_plate_width - 2 * dovetail_female_screw_edge_margin) / max(1, dovetail_female_screw_count - 1)];

            row_count = max(1, dovetail_female_screw_row_count);
            row_positions = (row_count == 1) ? [dovetail_plate_height/2 + dovetail_female_extra_height/2]
                : [for (r = [0 : row_count - 1])
                    dovetail_plate_height/2 + dovetail_female_extra_height/2 - ((row_count - 1) * dovetail_female_screw_row_spacing) / 2 + r * dovetail_female_screw_row_spacing];
            
            for (x_pos = hole_positions) {
                for (z_pos = row_positions) {
                    translate([x_pos, -dovetail_plate_thickness/2, z_pos])
                    rotate([90, 0, 0])
                    // Added 5 extra length to ensure the hole goes through the entire piece, even with slight misalignments
                    cylinder(h = dovetail_depth + dovetail_plate_thickness + 6, d = dovetail_female_mount_screw_hole_diameter, center = true, $fn = 48);
                }
            }
        }
    }
}
