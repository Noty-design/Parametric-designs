/* [Storlek] */
body_width = 120;                 // [60:5:140]
body_depth = 120;                 // [60:5:140]
body_height = 120;               // [70:5:170]
wall_thickness = 3;            // [2.4:0.2:6]
bottom_thickness = 3;            // [3:0.5:8]

/* [Avtagbart lock] */
lid_thickness = 4;               // [3:0.5:7]
lid_overhang = 1.5;              // [0.5:0.5:4]
lid_plug_depth = 5;              // [2:0.5:8]
lid_plug_wall = 2.4;             // [1.6:0.2:4]
lid_clearance = 0.35;            // [0.15:0.05:0.7]
coin_slot_length = 50;           // [25:1:60]
coin_slot_width = 6;             // [3:0.5:10]

/* [Minecraft-mönster] */
front_pattern = "creeper";       // [plain,creeper,grass,stone,diamond_ore,crafting]
back_pattern = "creeper";    // [plain,creeper,grass,stone,diamond_ore,crafting]
left_pattern = "crafting";          // [plain,creeper,grass,stone,diamond_ore,crafting]
right_pattern = "crafting";         // [plain,creeper,grass,stone,diamond_ore,crafting]
pattern_mode = "raised";          // [raised,recessed]
pattern_size = 76;                // [60:2:76]
pattern_gap = 3;                // [0.5:0.1:1.8]
// Infästningsdjup i väggen när mönstret är upphöjt.
pattern_depth = 0.7;              // [0.3:0.1:2]
// Utstick. Reliefen får 45-graders fasning och kan skrivas utan stöd.
pattern_protrusion = 2;         // [0.3:0.1:3]
// Djupet när mönstret är försjunket.
pattern_recess_depth = 1.2;       // [0.5:0.1:2.4]

/* [Armar och ben] */
include_arms = false;              //
include_legs = false;              //
arm_width = 14;                   // [8:1:22]
arm_depth = 20;                   // [10:1:30]
arm_height = 68;                  // [35:2:95]
leg_width = 22;                   // [12:1:32]
leg_depth = 15;                   // [8:1:25]
leg_height = 36;                  // [20:2:55]

/* [Visning och färg] */
display_mode = "print_layout";       // [assembled,print_layout]
body_color = "ForestGreen";       //
lid_color = "DarkGreen";         //
limb_color = "SeaGreen";         //
pattern_color = "LimeGreen";      //
$fn = 50;
preview_epsilon = 0.05;
inner_width = body_width - 2 * wall_thickness;
inner_depth = body_depth - 2 * wall_thickness;
plug_outer_width = inner_width - 2 * lid_clearance;
plug_outer_depth = inner_depth - 2 * lid_clearance;

function pattern_cells(style) =
    style == "creeper" ? [
        [1,1],[2,1],[5,1],[6,1],[1,2],[2,2],[5,2],[6,2],
        [3,3],[4,3],[3,4],[4,4],
        [2,5],[3,5],[4,5],[5,5],[2,6],[5,6],[2,7],[5,7]
    ] :
    style == "grass" ? [
        [0,0],[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
        [0,1],[2,1],[3,1],[5,1],[7,1],[1,2],[2,2],[5,2],[6,2],
        [0,4],[3,3],[7,4],[1,6],[4,5],[6,7]
    ] :
    style == "stone" ? [
        [1,0],[1,1],[2,1],[2,2],[3,2],[5,0],[5,1],
        [6,3],[5,3],[5,4],[4,4],[2,5],[3,5],[2,6],[1,6],[1,7]
    ] :
    style == "diamond_ore" ? [
        [1,1],[2,0],[2,1],[2,2],[3,1],
        [5,3],[6,2],[6,3],[6,4],[7,3],
        [2,6],[3,5],[3,6],[3,7],[4,6]
    ] :
    style == "crafting" ? [
        [0,0],[1,0],[2,0],[5,0],[6,0],[7,0],
        [0,1],[2,1],[5,1],[7,1],[0,2],[1,2],[2,2],[5,2],[6,2],[7,2],
        [3,4],[4,4],[3,5],[4,5],[2,6],[5,6],[1,7],[6,7]
    ] : [];

module pixel_coordinates(column, row, wall_name) {
    pixel_pitch = pattern_size / 8;
    pixel_size = pixel_pitch - pattern_gap;
    wall_span = (wall_name == "front" || wall_name == "back") ? body_width : body_depth;
    horizontal_position = wall_span/2 - pattern_size/2 + column*pixel_pitch + pattern_gap/2;
    vertical_position = body_height/2 + pattern_size/2 - (row+1)*pixel_pitch + pattern_gap/2;
    children(0, pixel_size, horizontal_position, vertical_position);
}

// Varje upphöjd pixel har en 45-graders undersida och fasade kanter.
// pattern_protrusion är begränsad så att en plan yttermitt alltid återstår.
module raised_pixel(column, row, wall_name) {
    pixel_pitch = pattern_size / 8;
    pixel_size = pixel_pitch - pattern_gap;
    horizontal_position = ((wall_name == "front" || wall_name == "back") ? body_width : body_depth)/2
                          - pattern_size/2 + column*pixel_pitch + pattern_gap/2;
    vertical_position = body_height/2 + pattern_size/2 - (row+1)*pixel_pitch + pattern_gap/2;
    bevel = min(pattern_protrusion, pixel_size/2-0.25);
    outer_size = pixel_size - 2*bevel;
    skin = 0.04;

    if (wall_name == "front") {
        translate([horizontal_position, -preview_epsilon, vertical_position])
            cube([pixel_size, pattern_depth+preview_epsilon, pixel_size]);
        hull() {
            translate([horizontal_position, -skin, vertical_position]) cube([pixel_size, skin, pixel_size]);
            translate([horizontal_position+bevel, -pattern_protrusion, vertical_position+bevel])
                cube([outer_size, skin, outer_size]);
        }
    } else if (wall_name == "back") {
        translate([body_width-horizontal_position-pixel_size, body_depth-pattern_depth, vertical_position])
            cube([pixel_size, pattern_depth+preview_epsilon, pixel_size]);
        hull() {
            translate([body_width-horizontal_position-pixel_size, body_depth, vertical_position])
                cube([pixel_size, skin, pixel_size]);
            translate([body_width-horizontal_position-pixel_size+bevel,
                       body_depth+pattern_protrusion-skin, vertical_position+bevel])
                cube([outer_size, skin, outer_size]);
        }
    } else if (wall_name == "left") {
        translate([-preview_epsilon, body_depth-horizontal_position-pixel_size, vertical_position])
            cube([pattern_depth+preview_epsilon, pixel_size, pixel_size]);
        hull() {
            translate([-skin, body_depth-horizontal_position-pixel_size, vertical_position])
                cube([skin, pixel_size, pixel_size]);
            translate([-pattern_protrusion, body_depth-horizontal_position-pixel_size+bevel,
                       vertical_position+bevel]) cube([skin, outer_size, outer_size]);
        }
    } else if (wall_name == "right") {
        translate([body_width-pattern_depth, horizontal_position, vertical_position])
            cube([pattern_depth+preview_epsilon, pixel_size, pixel_size]);
        hull() {
            translate([body_width, horizontal_position, vertical_position])
                cube([skin, pixel_size, pixel_size]);
            translate([body_width+pattern_protrusion-skin, horizontal_position+bevel,
                       vertical_position+bevel]) cube([skin, outer_size, outer_size]);
        }
    }
}

module recessed_pixel(column, row, wall_name, floor=false) {
    pixel_pitch = pattern_size / 8;
    pixel_size = pixel_pitch - pattern_gap;
    horizontal_position = ((wall_name == "front" || wall_name == "back") ? body_width : body_depth)/2
                          - pattern_size/2 + column*pixel_pitch + pattern_gap/2;
    vertical_position = body_height/2 + pattern_size/2 - (row+1)*pixel_pitch + pattern_gap/2;
    floor_thickness = 0.2;
    used_depth = floor ? floor_thickness+0.1 : pattern_recess_depth+preview_epsilon;

    if (wall_name == "front")
        translate([horizontal_position,
                   floor ? pattern_recess_depth-floor_thickness : -preview_epsilon,
                   vertical_position]) cube([pixel_size, used_depth, pixel_size]);
    else if (wall_name == "back")
        translate([body_width-horizontal_position-pixel_size,
                   floor ? body_depth-pattern_recess_depth-0.1 : body_depth-pattern_recess_depth,
                   vertical_position]) cube([pixel_size, used_depth, pixel_size]);
    else if (wall_name == "left")
        translate([floor ? pattern_recess_depth-floor_thickness : -preview_epsilon,
                   body_depth-horizontal_position-pixel_size, vertical_position])
            cube([used_depth, pixel_size, pixel_size]);
    else if (wall_name == "right")
        translate([floor ? body_width-pattern_recess_depth-0.1 : body_width-pattern_recess_depth,
                   horizontal_position, vertical_position]) cube([used_depth, pixel_size, pixel_size]);
}

module wall_pattern(style, wall_name, operation="raised") {
    if (style != "plain")
        for (cell = pattern_cells(style))
            if (operation == "raised") raised_pixel(cell[0], cell[1], wall_name);
            else if (operation == "cut") recessed_pixel(cell[0], cell[1], wall_name, false);
            else recessed_pixel(cell[0], cell[1], wall_name, true);
}

module all_patterns(operation="raised") {
    wall_pattern(front_pattern, "front", operation);
    wall_pattern(back_pattern, "back", operation);
    wall_pattern(left_pattern, "left", operation);
    wall_pattern(right_pattern, "right", operation);
}

module hollow_bank_body() {
    difference() {
        cube([body_width, body_depth, body_height]);
        translate([wall_thickness, wall_thickness, bottom_thickness])
            cube([inner_width, inner_depth, body_height-bottom_thickness+preview_epsilon]);
        if (pattern_mode == "recessed") all_patterns("cut");
    }
}

module arms() {
    if (include_arms) {
        translate([-arm_width, (body_depth-arm_depth)/2, 0])
            cube([arm_width+preview_epsilon, arm_depth, arm_height]);
        translate([body_width-preview_epsilon, (body_depth-arm_depth)/2, 0])
            cube([arm_width+preview_epsilon, arm_depth, arm_height]);
    }
}

module legs() {
    if (include_legs) {
        leg_gap = 8;
        translate([body_width/2-leg_gap/2-leg_width, -leg_depth, 0])
            cube([leg_width, leg_depth+preview_epsilon, leg_height]);
        translate([body_width/2+leg_gap/2, -leg_depth, 0])
            cube([leg_width, leg_depth+preview_epsilon, leg_height]);
    }
}

module bank_body_complete() {
    union() {
        color(body_color) hollow_bank_body();
        color(pattern_color)
            if (pattern_mode == "raised") all_patterns("raised");
            else all_patterns("floor");
        color(limb_color) arms();
        color(limb_color) legs();
    }
}

module removable_lid() {
    difference() {
        union() {
            translate([-lid_overhang, -lid_overhang, 0])
                cube([body_width+2*lid_overhang, body_depth+2*lid_overhang, lid_thickness]);
            difference() {
                translate([wall_thickness+lid_clearance, wall_thickness+lid_clearance, -lid_plug_depth])
                    cube([plug_outer_width, plug_outer_depth, lid_plug_depth+preview_epsilon]);
                translate([wall_thickness+lid_clearance+lid_plug_wall,
                           wall_thickness+lid_clearance+lid_plug_wall,
                           -lid_plug_depth-preview_epsilon])
                    cube([plug_outer_width-2*lid_plug_wall,
                          plug_outer_depth-2*lid_plug_wall,
                          lid_plug_depth+2*preview_epsilon]);
            }
        }
        translate([body_width/2-coin_slot_length/2,
                   body_depth/2-coin_slot_width/2, -preview_epsilon])
            cube([coin_slot_length, coin_slot_width, lid_thickness+2*preview_epsilon]);
    }
}

if (display_mode == "assembled") {
    translate([-body_width/2, -body_depth/2, 0]) bank_body_complete();
    color(lid_color) translate([-body_width/2, -body_depth/2, body_height]) removable_lid();
} else {
    bank_body_complete();
    color(lid_color)
        translate([body_width+arm_width+24, body_depth, lid_thickness])
            rotate([180,0,0]) removable_lid();
}