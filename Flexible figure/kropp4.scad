/* [Head Shape & Expression] */
// Shape of the head
head_shape = "circle"; // [circle, square, hexagon, triangle, cat, bear, enderman, dragon, trex, triceratops, brachiosaurus, stegosaurus, dilophosaurus, creature_skull, robot_helmet]
// Rotation of the head (Default -90 makes it point UP when standing on the base)
head_rotation = 0; // [-180:15:180]
// Choose facial expression (Only applies to simple shapes)
face_expression = "happy"; // [surprised, happy, sad, angry, neutral, winking]
// Size/radius of the head
head_radius = 20;        // [10:1:50]

/* [Head 3D Profile] */
// Shape of the top of the head
head_profile = "half_sphere";  // [flat, half_sphere, contoured_curve, chamfered]
// Vertical height of the rounding/dome
head_profile_height = 8; // [1:1:30]
// Horizontal inset of the curve
head_profile_inset = 6;  // [1:1:30]
// Smoothness / number of layers
head_profile_steps = 16; // [5:1:64]
// How far the face details stick out
face_extrusion = 1.0;    // [0.2:0.2:5.0]

/* [Body & Arms] */
// Add a solid center block to the body?
add_center_body = true;
// Style of the arms
arm_style = "springy";   // [none, solid, springy]
// Position of the arms/center body along the spring
body_position = 40;      // [10:5:150]
// Fine-tune position of the center body forwards/backwards (X-axis offset)
body_offset_x = 0;       // [-30:1:30]
// Fine-tune position of the arms forwards/backwards (X-axis offset)
arm_offset_x = 0;        // [-30:1:30]
// Width of the center body block
body_width = 20;         // [10:1:60]
// Length of the center body block
body_length = 15;        // [5:1:40]
// How far the arms reach outwards
arm_reach = 30;          // [10:5:80]
// Number of zigzags for springy arms
arm_zigzags = 3;         // [1:1:10]

/* [Base & Feet Settings] */
// Add detailed feet/shoes to the base?
add_feet = true;
// Extrude height of the shoes (How far they stick out when standing)
shoe_height = 20;        // [5:1:60]
// Size/thickness of the shoes
shoe_size = 6;           // [2:1:20]
// Move shoes up/down when standing (X-axis offset)
shoe_offset_x = 0;       // [-30:1:30]
// Move shoes sideways from center (Y-axis offset)
shoe_offset_y = 15;      // [0:1:50]
// Move shoes forward/backward (Z-axis offset)
shoe_offset_z = 12;      // [0:1:40]
// Tilt the shoes left/right (X rotation)
shoe_rot_x = 0;          // [-90:1:90]
// Tilt the shoes forward/backward (Y rotation)
shoe_rot_y = 0;          // [-90:1:90]
// Point the toes inward/outward (Z rotation)
shoe_rot_z = 15;         // [-90:1:90]
// Make the base in two pieces for dual-sided standing stability?
two_piece_base = true; 
// Width of the base (Y-axis)
base_width = 40;         // [20:1:100]
// Depth of the base (X-axis footprint when standing)
base_depth = 15;         // [5:1:50]
// Printed height of the base piece
base_height = 12;        // [2:1:40]

/* [Base Assembly Fit] */
// Size of the holes in the main base
base_hole_radius = 1.7;  // [1.0:0.1:4.0]
// Size of the pegs on the secondary base
base_peg_radius = 1.5;   // [1.0:0.1:4.0]
// Length of the pegs
base_peg_length = 4.0;   // [1.0:0.5:10.0]

/* [Spring Pattern] */
// Style of the spring
spring_style = "zigzag"; // [zigzag, wave]
// Total length of the spring
spring_length = 80;      // [30:5:200]
// Width of the spring
spring_width = 30;       // [10:1:100]
// Number of waves/folds
zigzags = 10;            // [2:1:40]
// Thickness of the spring wire
strut_width = 3;         // [1:0.5:10]

/* [Global Dimensions] */
// Extruded Z-thickness for the spring and details
print_thickness = 10;    // [2:1:30]

/* [Colors] */
base_color = "SteelBlue";
spring_color = "Silver";
head_color = "ForestGreen";
eye_color = "Black";
body_color = "SteelBlue";

// --- Helpers & Computed Paths ---
function path_end(path) = path[len(path) - 1];
function has_detailed_face() = head_shape == "creature_skull" || head_shape == "robot_helmet";

function zigzag_body_path() = concat(
    [[0, 0]],
    [ for (i=[1 : zigzags*2-1]) [i * spring_length / (zigzags*2), (i%2==1) ? spring_width/2 : -spring_width/2] ],
    [[spring_length, 0]]
);

function wave_body_path(steps) = [
    for (i=[0:steps])
    [i * spring_length / steps, sin(i * 360 * zigzags / steps) * (spring_width/2)]
];

function arm_path(y_dir, x_offset=0) = (arm_style == "solid") ?
    [[body_position + x_offset, y_dir * (add_center_body ? arm_start_width : 0)], [body_position + x_offset, y_dir * (arm_start_width + arm_reach)]] :
    concat(
        [[body_position + x_offset, y_dir * (add_center_body ? arm_start_width : 0)]],
        [ for (i=[1 : arm_zigzags*2-1]) [body_position + x_offset + ((i%2==1)? 5 : -5), y_dir * (arm_start_width + i * arm_reach / (arm_zigzags*2))] ],
        [[body_position + x_offset, y_dir * (arm_start_width + arm_reach)]]
    );

zigzag_path = zigzag_body_path();
wave_steps = zigzags * 20;
wave_path = wave_body_path(wave_steps);
active_path = spring_style == "zigzag" ? zigzag_path : wave_path;
arm_start_width = add_center_body ? body_width/2 : spring_width/2;
arm_path_R = arm_path(1, arm_offset_x);
arm_path_L = arm_path(-1, arm_offset_x);

// --- Native Polyline Module ---
module native_polyline(path, width) {
    for (i = [0 : len(path) - 2]) {
        hull() {
            translate([path[i][0], path[i][1]]) circle(r=width/2, $fn=16);
            translate([path[i+1][0], path[i+1][1]]) circle(r=width/2, $fn=16);
        }
    }
}

module extruded_polyline(path, width, height=print_thickness) {
    linear_extrude(height=height)
        native_polyline(path, width);
}

module peg_holes_3d() {
    for (y=[-base_width/4, base_width/4]) {
        translate([-base_depth/2, y, -0.1])
            cylinder(h=base_peg_length + 0.2, r=base_hole_radius, $fn=64);
    }
}

module main_base_3d() {
    color(base_color)
    translate([1, 0, 0])
    difference() {
        translate([-base_depth, -base_width/2, 0])
            cube([base_depth, base_width, base_height]);

        if (two_piece_base) peg_holes_3d();
    }

    if (add_feet) {
        color(head_color)
        for (side=[-1, 1]) {
            translate([-base_depth/2 + shoe_offset_x, side * shoe_offset_y, shoe_offset_z])
                mirror([0, side < 0 ? 1 : 0, 0]) shoe_3d();
        }
    }
}

module secondary_base_3d() {
    if (two_piece_base) {
        color(base_color)
        translate([-base_depth*2 - 20, 0, 0]) {
            translate([0, -base_width/2, 0]) cube([base_depth, base_width, base_height]);

            for (y=[-base_width/4, base_width/4]) {
                translate([base_depth/2, y, base_height - 0.1])
                    cylinder(h=base_peg_length + 0.1, r=base_peg_radius, $fn=64);
            }
        }
    }
}

module spring_body_3d() {
    color(spring_color)
        extruded_polyline(active_path, strut_width);
}

module center_body_3d() {
    if (add_center_body) {
        color(body_color)
        translate([body_position + body_offset_x, -body_width/2, 0])
            cube([body_length, body_width, print_thickness]);
    }
}

module arms_3d() {
    if (arm_style != "none") {
        color(spring_color)
            linear_extrude(height=print_thickness) {
                native_polyline(arm_path_R, strut_width);
                native_polyline(arm_path_L, strut_width);
            }

        color(head_color) {
            for (side=[-1, 1]) {
                path = side > 0 ? arm_path_R : arm_path_L;
                end = path_end(path);
                translate([end[0], end[1], 0])
                    linear_extrude(height=print_thickness) hand_2d(side);
            }
        }
    }
}

module selected_head_3d() {
    if (head_shape == "creature_skull") {
        detailed_skull_3d();
    } else if (head_shape == "robot_helmet") {
        detailed_robot_3d();
    } else {
        custom_head_3d();
    }
}

module face_details_3d() {
    if (!has_detailed_face()) {
        face_start_z = print_thickness;
        face_total_h = head_profile_height + face_extrusion;

        color(eye_color)
        translate([0, 0, face_start_z])
            linear_extrude(height=face_total_h)
                face_2d();
    }
}

module head_assembly_3d() {
    head_x = spring_length + head_radius - 1;

    translate([head_x, 0, 0]) {
        rotate([0, 0, head_rotation]) {
            color(head_color) selected_head_3d();
            face_details_3d();
        }
    }
}

// --- Assembly ---
module flexi_figure_3d() {
    union() {
        main_base_3d();
        secondary_base_3d();
        spring_body_3d();
        center_body_3d();
        arms_3d();
        head_assembly_3d();
    }
}

flexi_figure_3d();

// 3D FULLY DETAILED HEAD: SKULL
module detailed_skull_3d() {
    base_h = print_thickness;
    dome_h = head_profile_height;
    rad = head_radius;
    
    hull() {
        cylinder(h=base_h, r=rad, $fn=64);
        translate([0, 0, base_h]) scale([1, 0.9, dome_h/rad]) sphere(r=rad, $fn=64);
    }
    hull() {
        translate([rad*0.3, rad*0.5, 0]) cylinder(h=base_h, r=rad*0.4, $fn=32);
        translate([rad*0.3, rad*0.5, base_h]) sphere(r=rad*0.4, $fn=32);
    }
    hull() {
        translate([rad*0.3, -rad*0.5, 0]) cylinder(h=base_h, r=rad*0.4, $fn=32);
        translate([rad*0.3, -rad*0.5, base_h]) sphere(r=rad*0.4, $fn=32);
    }
    hull() {
        translate([rad*0.8, rad*0.2, 0]) cylinder(h=base_h, r=rad*0.3, $fn=32);
        translate([rad*0.8, -rad*0.2, 0]) cylinder(h=base_h, r=rad*0.3, $fn=32);
        translate([rad*0.8, 0, base_h]) scale([1, 0.5, dome_h/(rad*0.5)]) sphere(r=rad*0.5, $fn=32);
    }
    color(eye_color) {
        translate([rad*0.2, rad*0.35, base_h + dome_h - 2]) cylinder(h=2 + face_extrusion, r=rad*0.25, $fn=32);
        translate([rad*0.2, -rad*0.35, base_h + dome_h - 2]) cylinder(h=2 + face_extrusion, r=rad*0.25, $fn=32);
        translate([rad*0.5, 0, base_h + dome_h - 4]) linear_extrude(height=4 + face_extrusion) polygon([[-rad*0.1, -rad*0.1], [rad*0.2, 0], [-rad*0.1, rad*0.1]]);
        for(y=[-rad*0.2:rad*0.1:rad*0.2]) {
            translate([rad*0.8, y, base_h + dome_h/2]) cube([rad*0.1, rad*0.05, dome_h + face_extrusion], center=true);
        }
    }
}

// 3D FULLY DETAILED HEAD: ROBOT HELMET
module detailed_robot_3d() {
    base_h = print_thickness;
    dome_h = head_profile_height;
    rad = head_radius;
    
    hull() {
        translate([-rad*0.5, -rad*0.8, 0]) cube([rad*1.5, rad*1.6, base_h]);
        translate([-rad*0.4, -rad*0.7, base_h]) cube([rad*1.3, rad*1.4, dome_h]);
    }
    translate([0, rad*0.8, 0]) cylinder(h=base_h + dome_h/2, r=rad*0.3, $fn=32);
    translate([0, -rad*0.8, 0]) cylinder(h=base_h + dome_h/2, r=rad*0.3, $fn=32);
    translate([0, rad*0.8, base_h + dome_h/2]) sphere(r=rad*0.3, $fn=32);
    translate([0, -rad*0.8, base_h + dome_h/2]) sphere(r=rad*0.3, $fn=32);
    
    color(eye_color) {
        translate([rad*0.7, 0, base_h]) {
            translate([0, 0, dome_h*0.6]) cube([rad*0.5, rad*1.2, dome_h*0.4 + face_extrusion], center=true);
            for(y=[-rad*0.3 : rad*0.2 : rad*0.3]) {
                translate([rad*0.1, y, dome_h*0.2]) cube([rad*0.3, rad*0.05, dome_h*0.4 + face_extrusion], center=true);
            }
        }
    }
}

// 3D module for Feet/Shoes
module shoe_3d() {
    difference() {
        rotate([shoe_rot_x, shoe_rot_y, shoe_rot_z])
        hull() {
            sphere(r=shoe_size, $fn=32);
            translate([0, 0, shoe_height]) sphere(r=shoe_size*0.8, $fn=32);
        }
        translate([0, 0, -50]) cube([100, 100, 100], center=true);
    }
}

// 2D module for Hands
module hand_2d(y_dir) {
    hull() {
        circle(r=6, $fn=32);
        translate([4, y_dir * 4]) circle(r=3, $fn=16); 
    }
}

// 3D module for Head
module custom_head_3d() {
    if (head_profile == "half_sphere") {
        intersection() {
            linear_extrude(height=print_thickness + head_profile_height + 10) head_base_2d();
            union() {
                cylinder(h=print_thickness, r=head_radius*3, $fn=64);
                translate([0, 0, print_thickness]) scale([1, 1, head_profile_height / (head_radius * 1.25)]) sphere(r=head_radius * 1.25, $fn=128);
            }
        }
    } else {
        linear_extrude(height=print_thickness) head_base_2d();
        if (head_profile == "contoured_curve") {
            for (i=[1:head_profile_steps]) {
                a1 = (i-1) * 90 / head_profile_steps;
                a2 = i * 90 / head_profile_steps;
                z1 = print_thickness + head_profile_height * sin(a1);
                z2 = print_thickness + head_profile_height * sin(a2);
                inset1 = head_profile_inset * (1 - cos(a1));
                inset2 = head_profile_inset * (1 - cos(a2));
                hull() {
                    translate([0, 0, z1]) linear_extrude(height=0.01) offset(delta = -inset1) head_base_2d();
                    translate([0, 0, z2-0.01]) linear_extrude(height=0.01) offset(delta = -inset2) head_base_2d();
                }
            }
        } else if (head_profile == "chamfered") {
            for (i=[1:head_profile_steps]) {
                z1 = print_thickness + (i-1) * head_profile_height / head_profile_steps;
                z2 = print_thickness + i * head_profile_height / head_profile_steps;
                inset1 = (i-1) * head_profile_inset / head_profile_steps;
                inset2 = i * head_profile_inset / head_profile_steps;
                hull() {
                    translate([0, 0, z1]) linear_extrude(height=0.01) offset(delta = -inset1) head_base_2d();
                    translate([0, 0, z2-0.01]) linear_extrude(height=0.01) offset(delta = -inset2) head_base_2d();
                }
            }
        }
    }
}

// 2D module for the outer shape of the head
module head_base_2d() {
    if (head_shape == "circle") {
        circle(r=head_radius, $fn=64);
    } else if (head_shape == "square") {
        square([head_radius*1.7, head_radius*1.7], center=true);
    } else if (head_shape == "hexagon") {
        rotate(30) circle(r=head_radius*1.15, $fn=6);
    } else if (head_shape == "triangle") {
        rotate(180) circle(r=head_radius*1.4, $fn=3);
    } else if (head_shape == "cat") {
        union() {
            circle(r=head_radius, $fn=64);
            polygon([[head_radius*0.3, head_radius*0.6], [head_radius*0.9, head_radius*0.9], [head_radius*0.7, head_radius*0.2]]);
            polygon([[head_radius*0.3, -head_radius*0.6], [head_radius*0.9, -head_radius*0.9], [head_radius*0.7, -head_radius*0.2]]);
        }
    } else if (head_shape == "bear") {
        union() {
            circle(r=head_radius, $fn=64);
            translate([head_radius*0.6, head_radius*0.7]) circle(r=head_radius*0.4, $fn=32);
            translate([head_radius*0.6, -head_radius*0.7]) circle(r=head_radius*0.4, $fn=32);
        }
    } else if (head_shape == "enderman") {
        square([head_radius*1.6, head_radius*1.6], center=true);
    } else if (head_shape == "dragon") {
        union() {
            circle(r=head_radius, $fn=64);
            polygon([[head_radius*0.3, head_radius*0.7], [head_radius*0.9, head_radius*1.5], [head_radius*0.6, head_radius*0.6]]);
            polygon([[head_radius*0.3, -head_radius*0.7], [head_radius*0.9, -head_radius*1.5], [head_radius*0.6, -head_radius*0.6]]);
            polygon([[head_radius*0.8, -head_radius*0.2], [head_radius*1.4, -head_radius*0.4], [head_radius*0.7, -head_radius*0.6]]);
            polygon([[head_radius*0.8, head_radius*0.2], [head_radius*1.4, head_radius*0.4], [head_radius*0.7, head_radius*0.6]]);
        }
    } else if (head_shape == "trex") {
        hull() {
            translate([0, head_radius*0.2]) scale([1, 0.8]) circle(r=head_radius*0.8, $fn=64);
            translate([0, -head_radius*0.4]) scale([1, 0.9]) circle(r=head_radius*0.6, $fn=64);
        }
    } else if (head_shape == "triceratops") {
        union() {
            for(a=[-60:30:60]) rotate(a) translate([0, head_radius*0.7]) circle(r=head_radius*0.4, $fn=32);
            circle(r=head_radius*0.8, $fn=64);
            translate([head_radius*0.3, head_radius*0.2]) rotate(-30) polygon([[-head_radius*0.2, 0], [0, head_radius*0.8], [head_radius*0.2, 0]]);
            translate([head_radius*0.3, -head_radius*0.2]) rotate(30) polygon([[-head_radius*0.2, 0], [0, -head_radius*0.8], [head_radius*0.2, 0]]);
        }
    } else if (head_shape == "brachiosaurus") {
        union() {
            circle(r=head_radius*0.7, $fn=64);
            translate([0, head_radius*0.5]) circle(r=head_radius*0.6, $fn=64); 
        }
    } else if (head_shape == "stegosaurus") {
        union() {
            scale([1, 0.8]) circle(r=head_radius*0.7, $fn=64);
            for(a=[-45, 0, 45]) rotate(a) translate([0, head_radius*0.6]) polygon([[-head_radius*0.3, 0], [0, head_radius*0.6], [head_radius*0.3, 0]]);
        }
    } else if (head_shape == "dilophosaurus") {
        union() {
            hull() {
                translate([0, head_radius*0.2]) circle(r=head_radius*0.8, $fn=64);
                translate([0, -head_radius*0.4]) circle(r=head_radius*0.5, $fn=64);
            }
            translate([head_radius*0.3, head_radius*0.3]) rotate(20) scale([0.3, 1]) circle(r=head_radius*0.8, $fn=64);
            translate([head_radius*0.3, -head_radius*0.3]) rotate(-20) scale([0.3, 1]) circle(r=head_radius*0.8, $fn=64);
        }
    }
}

// 2D module for generating face details
module face_2d() {
    if (head_shape == "enderman") {
        translate([head_radius*0.45, head_radius*0.1]) square([head_radius*0.6, head_radius*0.15], center=true);
        translate([-head_radius*0.45, head_radius*0.1]) square([head_radius*0.6, head_radius*0.15], center=true);
    } else if (head_shape == "dragon") {
        translate([head_radius*0.4, head_radius*0.2]) rotate(20) scale([1, 0.3]) circle(r=head_radius*0.25, $fn=32);
        translate([-head_radius*0.4, head_radius*0.2]) rotate(-20) scale([1, 0.3]) circle(r=head_radius*0.25, $fn=32);
        translate([head_radius*0.2, -head_radius*0.5]) scale([1, 0.5]) circle(r=head_radius*0.1, $fn=16);
        translate([-head_radius*0.2, -head_radius*0.5]) scale([1, 0.5]) circle(r=head_radius*0.1, $fn=16);
        translate([0, head_radius*0.5]) polygon([[-head_radius*0.2, 0], [0, head_radius*0.3], [head_radius*0.2, 0]]);
    } else if (head_shape == "trex") {
        translate([head_radius*0.35, head_radius*0.3]) rotate(-15) scale([1, 0.5]) circle(r=head_radius*0.15, $fn=32);
        translate([-head_radius*0.35, head_radius*0.3]) rotate(15) scale([1, 0.5]) circle(r=head_radius*0.15, $fn=32);
        translate([head_radius*0.35, head_radius*0.45]) rotate(-15) square([head_radius*0.4, head_radius*0.1], center=true);
        translate([-head_radius*0.35, head_radius*0.45]) rotate(15) square([head_radius*0.4, head_radius*0.1], center=true);
        translate([head_radius*0.2, -head_radius*0.1]) circle(r=head_radius*0.06, $fn=16);
        translate([-head_radius*0.2, -head_radius*0.1]) circle(r=head_radius*0.06, $fn=16);
        translate([0, -head_radius*0.3]) for(i=[-2:2]) translate([i*head_radius*0.18, 0]) polygon([[-head_radius*0.07, 0], [0, -head_radius*0.25], [head_radius*0.07, 0]]);
    } else if (head_shape == "triceratops") {
        translate([0, -head_radius*0.2]) circle(r=head_radius*0.15, $fn=32);
        translate([head_radius*0.4, 0]) circle(r=head_radius*0.12, $fn=32);
        translate([-head_radius*0.4, 0]) circle(r=head_radius*0.12, $fn=32);
        translate([0, -head_radius*0.6]) polygon([[-head_radius*0.2, 0], [0, -head_radius*0.3], [head_radius*0.2, 0]]);
    } else if (head_shape == "brachiosaurus") {
        translate([head_radius*0.15, head_radius*0.7]) circle(r=head_radius*0.08, $fn=16);
        translate([-head_radius*0.15, head_radius*0.7]) circle(r=head_radius*0.08, $fn=16);
        translate([head_radius*0.4, head_radius*0.1]) circle(r=head_radius*0.12, $fn=32);
        translate([-head_radius*0.4, head_radius*0.1]) circle(r=head_radius*0.12, $fn=32);
        translate([0, -head_radius*0.4]) difference() { circle(r=head_radius*0.3, $fn=32); translate([0, head_radius*0.1]) square([head_radius*0.8, head_radius*0.4], center=true); }
    } else if (head_shape == "stegosaurus") {
        translate([head_radius*0.3, head_radius*0.1]) circle(r=head_radius*0.1, $fn=32);
        translate([-head_radius*0.3, head_radius*0.1]) circle(r=head_radius*0.1, $fn=32);
        translate([0, -head_radius*0.4]) polygon([[-head_radius*0.15, 0], [0, -head_radius*0.2], [head_radius*0.15, 0]]);
    } else if (head_shape == "dilophosaurus") {
        translate([head_radius*0.35, head_radius*0.1]) rotate(-10) scale([1, 0.6]) circle(r=head_radius*0.15, $fn=32);
        translate([-head_radius*0.35, head_radius*0.1]) rotate(10) scale([1, 0.6]) circle(r=head_radius*0.15, $fn=32);
        translate([head_radius*0.15, -head_radius*0.6]) circle(r=head_radius*0.06, $fn=16);
        translate([-head_radius*0.15, -head_radius*0.6]) circle(r=head_radius*0.06, $fn=16);
        translate([0, -head_radius*0.3]) for(i=[-1:1]) translate([i*head_radius*0.2, 0]) polygon([[-head_radius*0.08, 0], [0, -head_radius*0.15], [head_radius*0.08, 0]]);
    } else {
        if (face_expression == "surprised") {
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.2, 0]) scale([1, 0.7]) circle(r=head_radius*0.2, $fn=64);
        } else if (face_expression == "happy") {
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.1, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        } else if (face_expression == "sad") {
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.3, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([-head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        } else if (face_expression == "angry") {
            translate([head_radius*0.3, head_radius*0.35]) rotate(-20) square([head_radius*0.1, head_radius*0.25], center=true);
            translate([head_radius*0.3, -head_radius*0.35]) rotate(20) square([head_radius*0.1, head_radius*0.25], center=true);
            translate([-head_radius*0.25, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([-head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        } else if (face_expression == "neutral") {
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.2, 0]) square([head_radius*0.08, head_radius*0.4], center=true);
        } else if (face_expression == "winking") {
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) square([head_radius*0.08, head_radius*0.25], center=true);
            translate([-head_radius*0.1, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        }
    }
}
