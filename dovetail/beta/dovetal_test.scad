$fn = 45;

/* [Mått] */
// Total höjd på båda delarna
hanger_height = 175;            // [60:5:250]
// Bredd på monteringsplattorna
plate_width = 70;               // [40:5:140]
// Tjocklek på varje monteringsplatta
plate_thickness = 11;            // [4:1:20]
// Avstånd mellan han- och hon-del i förhandsvisningen
part_spacing = 35;              // [10:5:80]

/* [Dovetail-profil] */
// Djup på dovetail-spåret/tappen
 dovetail_depth = 12;           // [6:1:30]
// Smal bredd vid halsen på hanen
male_neck_width = 22;           // [10:1:60]
// Bred bredd längst ut på hanen
male_head_width = 38;           // [16:1:90]
// Extra spel per sida i honans spår
fit_clearance = 0.7;           // [0:0.05:1.5]
// Material kvar längst ner i honan som stopp
bottom_stop_height = 10;        // [0:1:30]
// Fri marginal överst på hanens tapp
male_top_margin = 8;            // [2:1:25]

/* [Skruvhål] */
// Aktivera monteringshål
screw_holes_enabled = true;
// Diameter för skruvens genomgångshål
screw_clearance_diameter = 5;   // [3:0.5:10]
// Diameter för försänkning/skruvskalle
countersink_diameter = 10;      // [6:0.5:18]
// Djup på försänkningen
countersink_depth = 3;          // [1:0.5:8]
// Horisontellt avstånd mellan vänster och höger skruvhål
screw_spacing_width = 50;       // [20:1:110]
// Avstånd från topp/botten till skruvhålen
screw_vertical_margin = 20;     // [10:1:60]

/* [Färger] */
male_color = "SteelBlue";       // 24
female_color = "DarkOrange";    // 24
cut_preview_color = "LightGray";// 24

male_rail_height = max(10, hanger_height - bottom_stop_height - male_top_margin);
female_body_depth = plate_thickness + dovetail_depth + 2;
model_total_width = plate_width * 2 + part_spacing;

translate([-(plate_width + part_spacing) / 2, 0, 0])
color(male_color)
male_hanger();

translate([(plate_width + part_spacing) / 2, 0, 0])
color(female_color)
female_hanger();

module male_hanger() {
    difference() {
        union() {
            translate([-plate_width / 2, 0, 0])
                cube([plate_width, plate_thickness, hanger_height]);

            translate([0, plate_thickness - 0.02, bottom_stop_height])
                dovetail_prism(
                    profile_neck_width = male_neck_width,
                    profile_head_width = male_head_width,
                    profile_depth = dovetail_depth,
                    prism_height = male_rail_height
                );
        }

        if (screw_holes_enabled) {
            for (hole_x = [-screw_spacing_width / 2, screw_spacing_width / 2]) {
                for (hole_z = [screw_vertical_margin, hanger_height - screw_vertical_margin]) {
                    screw_hole_from_front(
                        hole_x = hole_x,
                        hole_z = hole_z,
                        body_depth = plate_thickness,
                        front_y = plate_thickness,
                        inward_direction = -1
                    );
                }
            }
        }
    }
}

module female_hanger() {
    difference() {
        translate([-plate_width / 2, 0, 0])
            cube([plate_width, female_body_depth, hanger_height]);

        translate([0, -0.05, bottom_stop_height])
            dovetail_prism(
                profile_neck_width = male_neck_width + 2 * fit_clearance,
                profile_head_width = male_head_width + 2 * fit_clearance,
                profile_depth = dovetail_depth + fit_clearance + 0.1,
                prism_height = hanger_height - bottom_stop_height + 0.2
            );

        if (screw_holes_enabled) {
            for (hole_x = [-screw_spacing_width / 2, screw_spacing_width / 2]) {
                for (hole_z = [screw_vertical_margin, hanger_height - screw_vertical_margin]) {
                    screw_hole_from_front(
                        hole_x = hole_x,
                        hole_z = hole_z,
                        body_depth = female_body_depth,
                        front_y = 0,
                        inward_direction = 1
                    );
                }
            }
        }
    }
}

module dovetail_prism(profile_neck_width, profile_head_width, profile_depth, prism_height) {
    linear_extrude(height = prism_height)
        polygon(points = [
            [-profile_neck_width / 2, 0],
            [ profile_neck_width / 2, 0],
            [ profile_head_width / 2, profile_depth],
            [-profile_head_width / 2, profile_depth]
        ]);
}

module screw_hole_from_front(hole_x, hole_z, body_depth, front_y, inward_direction) {
    translate([hole_x, body_depth / 2, hole_z])
        rotate([90, 0, 0])
            cylinder(h = body_depth + 4, d = screw_clearance_diameter, center = true);

    if (inward_direction > 0) {
        translate([hole_x, front_y - 0.01, hole_z])
            rotate([-90, 0, 0])
                cylinder(h = countersink_depth + 0.02, d1 = countersink_diameter, d2 = screw_clearance_diameter, center = false);
    } else {
        translate([hole_x, front_y + 0.01, hole_z])
            rotate([90, 0, 0])
                cylinder(h = countersink_depth + 0.02, d1 = countersink_diameter, d2 = screw_clearance_diameter, center = false);
    }
}
