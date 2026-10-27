/* ========================================================================== 

   Minecraft Money Box Model for 3D Printing
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   
   DESCRIPTION
   -----------
   A block-shaped, Minecraft-inspired money box with a removable coin-slot lid,
   optional arms and legs, and independently selectable pixel patterns on all
   four vertical walls.  Patterns may be raised or recessed.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.  In the model's construction coordinates the
   body occupies X=0..body_width, Y=0..body_depth, and Z=0..body_height.  The
   front wall is at Y=0, the back at positive Y, the left at X=0, and the right
   at positive X.  Assembled mode recentres the body around global X/Y.

   PRINTING STRATEGY
   -----------------
   Raised pixels use 45-degree-style bevels to reduce unsupported overhangs.
   The lid includes a hollow locating plug and is flipped in print-layout mode.
   Colours are preview aids and are not retained by ordinary STL export.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */ 

/* [Size] */

// Outside body dimensions along X, Y, and Z.
body_width = 120;                 // [60:5:140]
body_depth = 120;                 // [60:5:140]
body_height = 120;               // [70:5:170]

// Thickness of the four vertical body walls.
wall_thickness = 3;            // [2.4:0.2:6]

// Thickness retained beneath the hollow money compartment.
bottom_thickness = 3;            // [3:0.5:8]

/* [Removable Lid] */

// Thickness of the flat top plate.
lid_thickness = 4;               // [3:0.5:7]

// Distance the lid extends beyond each outside body wall.
lid_overhang = 1.5;              // [0.5:0.5:4]

// Depth of the locating plug that enters the body opening.
lid_plug_depth = 5;              // [2:0.5:8]

// Wall thickness of the hollow locating plug.
lid_plug_wall = 2.4;             // [1.6:0.2:4]

// Per-side fit clearance between plug and inside body walls.
lid_clearance = 0.35;            // [0.15:0.05:0.7]

// Length and width of the rectangular coin opening through the lid.
coin_slot_length = 50;           // [25:1:60]
coin_slot_width = 6;             // [3:0.5:10]

/* [Minecraft Patterns] */

// Independently selected eight-by-eight pixel motif for each vertical wall.
// plain suppresses pattern geometry on that wall.
front_pattern = "creeper";       // [plain,creeper,grass,stone,diamond_ore,crafting]
back_pattern = "creeper";    // [plain,creeper,grass,stone,diamond_ore,crafting]
left_pattern = "crafting";          // [plain,creeper,grass,stone,diamond_ore,crafting]
right_pattern = "crafting";         // [plain,creeper,grass,stone,diamond_ore,crafting]

// raised adds external relief; recessed cuts pixels into the wall and leaves a
// thin contrasting floor at the back of each recess.
pattern_mode = "raised";          // [raised,recessed]

// Overall square span occupied by each wall's eight-by-eight pattern grid.
pattern_size = 76;                // [60:2:76]

// Gap removed between adjacent pixel cells.
pattern_gap = 3;                // [0.5:0.1:1.8]

// Embed depth inside the wall for raised pixels, ensuring a reliable union.
pattern_depth = 0.7;              // [0.3:0.1:2]

// Distance raised relief projects outside the wall.  Its bevel is shaped for
// support-conscious printing rather than as a vertical-sided block.
pattern_protrusion = 2;         // [0.3:0.1:3]

// Cutter depth used when recessed pattern mode is selected.
pattern_recess_depth = 1.2;       // [0.5:0.1:2.4]

/* [Arms and Legs] */

// Independently enable block-style arm and leg pairs.
include_arms = false;              //
include_legs = false;              //

// Arm dimensions: outward width, front-to-back depth, and vertical height.
arm_width = 14;                   // [8:1:22]
arm_depth = 20;                   // [10:1:30]
arm_height = 68;                  // [35:2:95]

// Leg dimensions: side-to-side width, outward depth, and vertical height.
leg_width = 22;                   // [12:1:32]
leg_depth = 15;                   // [8:1:25]
leg_height = 36;                  // [20:2:55]

/* [Display and Colour] */

// assembled places the lid on the body; print_layout places both parts
// separately with the lid inverted onto a printable face.
display_mode = "print_layout";       // [assembled,print_layout]

// Preview colours assigned to the body, lid, limbs, and pixel details.
body_color = "ForestGreen";       //
lid_color = "DarkGreen";         //
limb_color = "SeaGreen";         //
pattern_color = "LimeGreen";      //

// Global curved-primitive resolution.  Most geometry is deliberately blocky,
// but this setting remains available for any future rounded additions.
$fn = 50;

// Tiny overlap/overcut distance used to avoid coincident boolean surfaces.
preview_epsilon = 0.05;

// Derived inside opening dimensions after subtracting both wall thicknesses.
inner_width = body_width - 2 * wall_thickness;
inner_depth = body_depth - 2 * wall_thickness;

// Derived plug dimensions after applying fit clearance on both sides.
plug_outer_width = inner_width - 2 * lid_clearance;
plug_outer_depth = inner_depth - 2 * lid_clearance;

// Returns the occupied [column,row] coordinates for a named eight-by-eight motif.
// Each coordinate list is data only; wall_pattern() turns it into geometry.
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

// Calculates one pixel's common grid dimensions and wall-relative position,
// then forwards them to child geometry.  This utility centralizes the eight-cell
// grid math for extensions that choose to use child modules.
module pixel_coordinates(column, row, wall_name) {
    // Grid pitch includes both the solid pixel size and its surrounding gap.
    pixel_pitch = pattern_size / 8;
    pixel_size = pixel_pitch - pattern_gap;

    // Front/back span along X; left/right span along Y.
    wall_span = (wall_name == "front" || wall_name == "back") ? body_width : body_depth;

    // Column zero starts at the wall-relative left edge of the centred pattern.
    horizontal_position = wall_span/2 - pattern_size/2 + column*pixel_pitch + pattern_gap/2;

    // Rows are numbered from the top of the pattern downward.
    vertical_position = body_height/2 + pattern_size/2 - (row+1)*pixel_pitch + pattern_gap/2;

    // Expose calculated values to the first child module as special arguments.
    children(0, pixel_size, horizontal_position, vertical_position);
}

// Builds one raised pixel on the requested wall.
// Every raised pixel has a support-conscious bevel between its embedded wall
// block and its smaller outside face.  Bevel depth is capped so a non-zero flat
// outer face always remains.
module raised_pixel(column, row, wall_name) {
    // Repeat the grid-position calculations locally because this module emits
    // differently oriented primitives for each wall.
    pixel_pitch = pattern_size / 8;
    pixel_size = pixel_pitch - pattern_gap;
    horizontal_position = ((wall_name == "front" || wall_name == "back") ? body_width : body_depth)/2
                          - pattern_size/2 + column*pixel_pitch + pattern_gap/2;
    vertical_position = body_height/2 + pattern_size/2 - (row+1)*pixel_pitch + pattern_gap/2;
    bevel = min(pattern_protrusion, pixel_size/2-0.25);
    outer_size = pixel_size - 2*bevel;

    // Thin hull slices define the inner and outer boundaries of the bevel.
    skin = 0.04;

    if (wall_name == "front") {
        // Embedded front-wall block extends along positive Y.
        translate([horizontal_position, -preview_epsilon, vertical_position])
            cube([pixel_size, pattern_depth+preview_epsilon, pixel_size]);
        hull() {
            // Hull the full-size wall face to a smaller face at negative Y.
            translate([horizontal_position, -skin, vertical_position]) cube([pixel_size, skin, pixel_size]);
            translate([horizontal_position+bevel, -pattern_protrusion, vertical_position+bevel])
                cube([outer_size, skin, outer_size]);
        }
    } else if (wall_name == "back") {
        // Mirror placement to the back wall and project toward positive Y.
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
        // Rotate the conceptual pixel so depth runs along positive X, with the
        // visible bevel projecting toward negative X.
        translate([-preview_epsilon, body_depth-horizontal_position-pixel_size, vertical_position])
            cube([pattern_depth+preview_epsilon, pixel_size, pixel_size]);
        hull() {
            translate([-skin, body_depth-horizontal_position-pixel_size, vertical_position])
                cube([skin, pixel_size, pixel_size]);
            translate([-pattern_protrusion, body_depth-horizontal_position-pixel_size+bevel,
                       vertical_position+bevel]) cube([skin, outer_size, outer_size]);
        }
    } else if (wall_name == "right") {
        // Mirror the left-wall construction and project toward positive X.
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

// Creates either a full-depth recess cutter or a thin floor insert for one cell.
// floor=false emits the cutter used by hollow_bank_body(); floor=true emits the
// visible backing geometry added later in pattern_color.
module recessed_pixel(column, row, wall_name, floor=false) {
    pixel_pitch = pattern_size / 8;
    pixel_size = pixel_pitch - pattern_gap;
    horizontal_position = ((wall_name == "front" || wall_name == "back") ? body_width : body_depth)/2
                          - pattern_size/2 + column*pixel_pitch + pattern_gap/2;
    vertical_position = body_height/2 + pattern_size/2 - (row+1)*pixel_pitch + pattern_gap/2;

    // The floor is intentionally thin and slightly overlapped to prevent gaps.
    floor_thickness = 0.2;
    used_depth = floor ? floor_thickness+0.1 : pattern_recess_depth+preview_epsilon;

    // Each branch maps the common pixel grid onto the corresponding wall plane.
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

// Expands one named motif into individual pixel solids on one wall.
// operation selects raised relief, recess cutters, or recess-floor inserts.
module wall_pattern(style, wall_name, operation="raised") {
    if (style != "plain")
        for (cell = pattern_cells(style))
            if (operation == "raised") raised_pixel(cell[0], cell[1], wall_name);
            else if (operation == "cut") recessed_pixel(cell[0], cell[1], wall_name, false);
            else recessed_pixel(cell[0], cell[1], wall_name, true);
}

// Applies the chosen operation to all four independently configured walls.
module all_patterns(operation="raised") {
    wall_pattern(front_pattern, "front", operation);
    wall_pattern(back_pattern, "back", operation);
    wall_pattern(left_pattern, "left", operation);
    wall_pattern(right_pattern, "right", operation);
}

// Builds the hollow body and optionally subtracts recessed pattern cells.
module hollow_bank_body() {
    difference() {
        // Start with the complete outside block.
        cube([body_width, body_depth, body_height]);

        // Remove the money compartment from above the retained bottom thickness
        // through the open top of the body.
        translate([wall_thickness, wall_thickness, bottom_thickness])
            cube([inner_width, inner_depth, body_height-bottom_thickness+preview_epsilon]);
        if (pattern_mode == "recessed") all_patterns("cut");
    }
}

// Adds a matched pair of rectangular arms when enabled.
// Each arm overlaps its adjacent body wall by preview_epsilon for a sound union.
module arms() {
    if (include_arms) {
        translate([-arm_width, (body_depth-arm_depth)/2, 0])
            cube([arm_width+preview_epsilon, arm_depth, arm_height]);
        translate([body_width-preview_epsilon, (body_depth-arm_depth)/2, 0])
            cube([arm_width+preview_epsilon, arm_depth, arm_height]);
    }
}

// Adds two forward-projecting rectangular legs when enabled.
module legs() {
    if (include_legs) {
        // Keep a fixed central gap and mirror leg placement around body_width/2.
        leg_gap = 8;
        translate([body_width/2-leg_gap/2-leg_width, -leg_depth, 0])
            cube([leg_width, leg_depth+preview_epsilon, leg_height]);
        translate([body_width/2+leg_gap/2, -leg_depth, 0])
            cube([leg_width, leg_depth+preview_epsilon, leg_height]);
    }
}

// Combines the body, selected pattern treatment, and optional limbs.
// Recessed pattern floors are added after the body has had matching cavities cut.
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

// Creates the removable lid, hollow locating plug, and through coin slot.
module removable_lid() {
    difference() {
        union() {
            // Flat lid plate overhangs the body equally on all four sides.
            translate([-lid_overhang, -lid_overhang, 0])
                cube([body_width+2*lid_overhang, body_depth+2*lid_overhang, lid_thickness]);
            difference() {
                // Outer plug enters the body opening below the lid plate.
                translate([wall_thickness+lid_clearance, wall_thickness+lid_clearance, -lid_plug_depth])
                    cube([plug_outer_width, plug_outer_depth, lid_plug_depth+preview_epsilon]);
                // Remove the plug interior, leaving lid_plug_wall on every side.
                translate([wall_thickness+lid_clearance+lid_plug_wall,
                           wall_thickness+lid_clearance+lid_plug_wall,
                           -lid_plug_depth-preview_epsilon])
                    cube([plug_outer_width-2*lid_plug_wall,
                          plug_outer_depth-2*lid_plug_wall,
                          lid_plug_depth+2*preview_epsilon]);
            }
        }

        // Cut the centred coin slot fully through the lid plate.
        translate([body_width/2-coin_slot_length/2,
                   body_depth/2-coin_slot_width/2, -preview_epsilon])
            cube([coin_slot_length, coin_slot_width, lid_thickness+2*preview_epsilon]);
    }
}

// Top-level display dispatcher.
if (display_mode == "assembled") {
    // Recentre the body around global X/Y, then place the lid at body_height.
    translate([-body_width/2, -body_depth/2, 0]) bank_body_complete();
    color(lid_color) translate([-body_width/2, -body_depth/2, body_height]) removable_lid();
} else {
    // Keep the body at its construction origin and place the inverted lid beside
    // it.  The offset includes possible arm width plus additional clearance.
    bank_body_complete();
    color(lid_color)
        translate([body_width+arm_width+24, body_depth, lid_thickness])
            rotate([180,0,0]) removable_lid();
}
