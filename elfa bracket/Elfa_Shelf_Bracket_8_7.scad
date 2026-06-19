/* [Orientation] */
model_rotation_x = 180; // [-360:1:360]
model_rotation_y = 0; // [-360:1:360]
model_rotation_z = 90; // [-360:1:360]

/* [Horizontal Layout] */
number_of_columns = 1;            // Number of vertical standards (skenor) to mount to
column_spacing_x = 85;            // Center-to-center distance between the columns (mm)

/* [Elfa Slot Spacing (Horizontal)] */
// Avstånd mellan insidorna på de två krokarna (mm)
tooth_inner_distance = 8.3;  
// Avstånd mellan utsidorna på de två krokarna (mm)
tooth_outer_distance = 13.5;  

/* [Information Display] */
// Visa uträknade mått som 3D-text ovanför modellen (stäng av innan utskrift)
show_measurement_text = false;

/* [Elfa Mount Settings] */
number_of_teeth = 2;              // Number of teeth (vertical hooks) per column
bracket_width_per_column = 24;    // The base width of the backplate covering one column group
backplate_thickness = 3;

/* [Strength Optimization] */
// How deep the hooks penetrate interiorly (mm)
tooth_embed_depth = 3;     
// Chamfer/fillet radius at the base of the hook inside the backplate (mm)
tooth_root_chamfer = 2.5;    

/* [Slicer Layer Overlap Optimization] */
// To prevent the slicer from creating a weak flat layer joint, a 3D foundation taper forces intersecting perimeters.
hook_base_width_fillet = 1;     // Taper lateral width left/right (adds total width at surface)
hook_base_height_fillet = 0;  // Taper vertically up/down along the backplate
hook_base_fillet_depth = 2;   // Length of taper transitioning outwards into the main hook

/* [Spacing & Height] */
tooth_pitch_y = 32;           // Standard Elfa pitch vertically (Center-to-Center distance)
tooth_vertical_offset = 1;   // Distance from bottom of bracket to first tooth
bracket_top_margin = 21;      // Margin above the top tooth

/* [Hook Profile (Elfa Style)] */
tooth_depth = 12;             // Depth penetrating the wall standard
tooth_top_y_front = 15;       // Front top height of the hook
tooth_top_y_back = 12;        // Sloped rear top height for insertion
tooth_gap_size = 20;          // Avståndet MELLAN en tands botten och nästa tands topp
notch_depth = 4.5;              // Clearance for standard wall thickness
notch_distance_from_bottom = 7; // Avstånd från krokens lägsta spets upp till hacket (vilar på skenan)
base_bottom_y = 8.8;            // Bottom angle thickness matching notch
hook_tip_chamfer = 2.5;       // Angled tip for smoother insertion

/* [Appearance] */
bracket_color = "#4682B4"; // SteelBlue
text_color = "#FFFFFF";    // White

// --- Calculations ---
tooth_width = (tooth_outer_distance - tooth_inner_distance) / 2;
calculated_tooth_pitch_x = tooth_inner_distance + tooth_width;

// Räkna ut totala höjden på tanden baserat på pitch och gap
calculated_tooth_total_height = tooth_pitch_y - tooth_gap_size;

// Auto-calculate structural dimensions
bracket_height = tooth_vertical_offset + ((number_of_teeth - 1) * tooth_pitch_y) + bracket_top_margin;
total_bracket_width = (number_of_columns - 1) * column_spacing_x + bracket_width_per_column;

rotate([model_rotation_x, model_rotation_y, model_rotation_z]) {
    if (show_measurement_text) {
        color(text_color)
        translate([0, 0, bracket_height + 5])
        rotate([90, 0, 0])
        linear_extrude(1)
        union() {
            text(str("Tandens Bredd: ", tooth_width, " mm"), size = 2.5, halign = "center", valign = "bottom");
            translate([0, -4, 0])
                text(str("Beraknad Tandhojd: ", calculated_tooth_total_height, " mm"), size = 2.5, halign = "center", valign = "bottom");
        }
    }

    color(bracket_color)
    union() {
        // Main solid support backplate spanning across all columns
        translate([-total_bracket_width/2, -backplate_thickness, 0])
            cube([total_bracket_width, backplate_thickness, bracket_height]);

        // Generate hook groups for each column
        for (col = [0 : number_of_columns - 1]) {
            x_col_offset = (col - (number_of_columns - 1) / 2) * column_spacing_x;
            
            translate([x_col_offset, 0, 0]) {
                // Left reinforced tooth column
                translate([-calculated_tooth_pitch_x/2, 0, 0])
                    tooth_column();

                // Right reinforced tooth column
                translate([calculated_tooth_pitch_x/2, 0, 0])
                    tooth_column();
            }
        }
    }
}

module tooth_column() {
    // Lägsta punkten på kroken i förhållande till toppkanten i Y (Depth)
    hook_bottom_z = tooth_top_y_back - calculated_tooth_total_height;
    // Uträknat Z-värde för hacket baserat på avståndet från krokens botten
    actual_notch_z = hook_bottom_z + notch_distance_from_bottom;
    
    for (i = [0 : number_of_teeth - 1]) {
        z_pos = tooth_vertical_offset + (i * tooth_pitch_y);
        
        translate([0, 0, z_pos]) {
            // 1. The core constant-thickness hook profile
            // Polygon X -> Depth (Y), Polygon Y -> Height (Z)
            rotate([90, 0, 90])
            linear_extrude(height=tooth_width, center=true)
            polygon([
                [-tooth_embed_depth, base_bottom_y - tooth_root_chamfer], 
                [0, base_bottom_y],                                       
                [notch_depth, actual_notch_z],                              
                [notch_depth, hook_bottom_z],                               
                [tooth_depth - hook_tip_chamfer, hook_bottom_z],            
                [tooth_depth, hook_bottom_z + hook_tip_chamfer],            
                [tooth_depth, tooth_top_y_back],                          
                [0, tooth_top_y_front],                                   
                [-tooth_embed_depth, tooth_top_y_front + tooth_root_chamfer] 
            ]);
            
            // 2. The 3D Tapered Foundation for Slicer Adhesion
            // Gradually slopes from a widened base footprint down to the bare hook shape.
            if (hook_base_fillet_depth > 0) {
                y_target = hook_base_fillet_depth;
                
                // Interpolate matching heights to follow the exact slopes of the hook profile
                t_bottom = y_target / notch_depth;
                z_bottom_taper = base_bottom_y * (1 - t_bottom) + actual_notch_z * t_bottom;
                
                t_top = y_target / tooth_depth;
                z_top_taper = tooth_top_y_front * (1 - t_top) + tooth_top_y_back * t_top;
                
                hull() {
                    // Wide foundation base deeply bonded with the backplate surface
                    rotate([90, 0, 90])
                    linear_extrude(height=tooth_width + hook_base_width_fillet*2, center=true)
                    polygon([
                        [-0.1, base_bottom_y - hook_base_height_fillet],
                        [0.1, base_bottom_y - hook_base_height_fillet],
                        [0.1, tooth_top_y_front + hook_base_height_fillet],
                        [-0.1, tooth_top_y_front + hook_base_height_fillet]
                    ]);
                    
                    // Merging smoothly into the exact hook dimensions at 'y_target'
                    rotate([90, 0, 90])
                    linear_extrude(height=tooth_width, center=true)
                    polygon([
                        [y_target - 0.1, z_bottom_taper],
                        [y_target, z_bottom_taper],
                        [y_target, z_top_taper],
                        [y_target - 0.1, z_top_taper]
                    ]);
                }
            }
        }
    }
}