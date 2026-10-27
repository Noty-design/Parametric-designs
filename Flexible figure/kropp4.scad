/* ========================================================================== 

   Flexible figure Model for 3D Printing
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   
   Description: This is a modular flexible figure with customizable parameters 
   for head shape, body, arms, and base. It's a totally meaningless figure, but 
   fun to print and play with.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to make safely.
   ========================================================================== */ 

// =============================================================================
// MODEL OVERVIEW
// =============================================================================
//
// This model is generated as a single horizontal assembly for FDM printing.
// The flexible torso is a thick 2D path extruded along Z. A base is attached to
// the path origin, while the head is placed at the far end of the spring path.
// Optional arms, hands, shoes, and a second interlocking base add character and
// allow the printed figure to stand upright after assembly.
//
// Units and coordinate system:
//   - All linear dimensions are millimeters.
//   - All rotations are degrees, following OpenSCAD conventions.
//   - X runs from the base toward the head along the flexible body.
//   - Y runs sideways across the body and between the arms/feet.
//   - Z is the print/extrusion direction; the build plate is normally Z = 0.
//
// Design strategy:
//   - Most flexible parts begin as 2D paths made from overlapping circles.
//   - hull() joins neighboring circles into continuous rounded struts.
//   - linear_extrude() turns the 2D paths into printable 3D components.
//   - Head profiles are built either by intersection with a dome or by stacking
//     thin offset layers connected with hull().
//   - Colors are preview aids. Standard STL files do not preserve them.
//
// Customizer notes:
//   OpenSCAD reads comments such as /* [Section] */ and // [min:step:max] to
//   construct the Customizer interface. Keep those annotations intact when
//   renaming or extending parameters.

/* [Head Shape & Expression] */
// Selects the outer head silhouette. Detailed skull and robot options bypass
// the generic head-profile system and use dedicated 3D geometry.
head_shape = "circle"; // [circle, square, hexagon, triangle, cat, bear, enderman, dragon, trex, triceratops, brachiosaurus, stegosaurus, dilophosaurus, creature_skull, robot_helmet]
// Rotates the complete head and face around local Z. This changes visual
// orientation in the flat print layout; use -90 degrees for an upright-facing
// head after the flexible figure is stood on its base.
head_rotation = 0; // [-180:15:180]
// Selects the expression used by simple head shapes. Creature and dinosaur
// heads use shape-specific facial details instead.
face_expression = "happy"; // [surprised, happy, sad, angry, neutral, winking]
// Master radius used by both generic and detailed head geometry.
head_radius = 20;        // [10:1:50]

/* [Head 3D Profile] */
// Selects how a generic 2D head silhouette gains depth above print_thickness.
head_profile = "half_sphere";  // [flat, half_sphere, contoured_curve, chamfered]
// Additional vertical height of the dome, contour, or chamfer above the base.
head_profile_height = 8; // [1:1:30]
// Maximum inward offset used by contoured_curve and chamfered profiles.
head_profile_inset = 6;  // [1:1:30]
// Number of stacked transition layers. Higher values improve smoothness but
// increase preview/render time and mesh complexity.
head_profile_steps = 16; // [5:1:64]
// Height added to eyes, mouths, and other face details above the head surface.
face_extrusion = 1.0;    // [0.2:0.2:5.0]

/* [Body & Arms] */
// Adds a rigid rectangular torso around the flexible spring path.
add_center_body = true;
// none removes arms, solid creates straight arms, and springy creates zigzags.
arm_style = "springy";   // [none, solid, springy]
// X position of the torso and both arm roots along the main spring.
body_position = 40;      // [10:5:150]
// Independent X adjustment for the rigid center-body block.
body_offset_x = 0;       // [-30:1:30]
// Independent X adjustment for both arm roots and all arm path points.
arm_offset_x = 0;        // [-30:1:30]
// Torso size along Y; half this value also determines arm root spacing.
body_width = 20;         // [10:1:60]
// Torso size along X.
body_length = 15;        // [5:1:40]
// Distance from each arm root to its hand along the Y direction.
arm_reach = 30;          // [10:5:80]
// Number of full lateral folds in each springy arm.
arm_zigzags = 3;         // [1:1:10]

/* [Base & Feet Settings] */
// Adds mirrored rounded shoes beside the main base.
add_feet = true;
// Length of each shoe from its spherical root to its tapered tip.
shoe_height = 20;        // [5:1:60]
// Radius of the shoe root; the tip uses 80 percent of this radius.
shoe_size = 6;           // [2:1:20]
// Moves both shoes along X relative to the main base.
shoe_offset_x = 0;       // [-30:1:30]
// Half-spacing between the two shoe centerlines along Y.
shoe_offset_y = 15;      // [0:1:50]
// Places the shoe origins along Z in the printed orientation.
shoe_offset_z = 12;      // [0:1:40]
// Tilts each shoe around X.
shoe_rot_x = 0;          // [-90:1:90]
// Tilts each shoe around Y.
shoe_rot_y = 0;          // [-90:1:90]
// Rotates the shoe direction in the XY plane. Mirroring makes the pair symmetric.
shoe_rot_z = 15;         // [-90:1:90]
// Adds a detached secondary base with two pegs matching holes in the main base.
two_piece_base = true; 
// Main and secondary base width along Y.
base_width = 40;         // [20:1:100]
// Base depth along X.
base_depth = 15;         // [5:1:50]
// Base thickness along Z in the print orientation.
base_height = 12;        // [2:1:40]

/* [Base Assembly Fit] */
// Radius of receiving holes in the main base. Keep larger than base_peg_radius.
base_hole_radius = 1.7;  // [1.0:0.1:4.0]
// Radius of pegs on the secondary base.
base_peg_radius = 1.5;   // [1.0:0.1:4.0]
// Engagement depth/height of the two assembly pegs.
base_peg_length = 4.0;   // [1.0:0.5:10.0]

/* [Spring Pattern] */
// zigzag uses sharp alternating folds; wave samples a sinusoidal centerline.
spring_style = "zigzag"; // [zigzag, wave]
// End-to-end body length along X, excluding the head radius.
spring_length = 80;      // [30:5:200]
// Peak-to-peak lateral range of the main spring along Y.
spring_width = 30;       // [10:1:100]
// Number of complete zigzags or sine-wave periods along spring_length.
zigzags = 10;            // [2:1:40]
// Diameter of the overlapping circles used to create flexible struts.
strut_width = 3;         // [1:0.5:10]

/* [Global Dimensions] */
// Shared Z thickness for spring, torso, arms, hands, and generic head base.
print_thickness = 10;    // [2:1:30]

/* [Colors] */
// Colors affect OpenSCAD preview only; regular STL export is geometry-only.
// Main and secondary base color.
base_color = "SteelBlue";
// Flexible spring and arm-strut color.
spring_color = "Silver";
// Head, hands, and shoes color.
head_color = "ForestGreen";
// Raised facial-detail color.
eye_color = "Black";
// Rigid center-body color.
body_color = "SteelBlue";

// =============================================================================
// PATH HELPERS AND DERIVED GEOMETRY
// =============================================================================

// Returns the final [X,Y] point from any non-empty path. Arms use this point to
// place their hands without duplicating the path-generation calculations.
function path_end(path) = path[len(path) - 1];

// Detailed heads already include their own face geometry and therefore must not
// receive the generic extruded face from face_details_3d().
function has_detailed_face() = head_shape == "creature_skull" || head_shape == "robot_helmet";

// Generates the main body's alternating zigzag centerline.
//
// The explicit start and end points lie on Y=0 so the spring meets the base and
// head centrally. Between them, odd and even indices alternate between positive
// and negative half-width. Two segments per requested zigzag produce a complete
// left-right fold while maintaining a total X length of spring_length.
function zigzag_body_path() = concat(
    [[0, 0]],
    [ for (i=[1 : zigzags*2-1]) [i * spring_length / (zigzags*2), (i%2==1) ? spring_width/2 : -spring_width/2] ],
    [[spring_length, 0]]
);

// Samples a sine-wave centerline. The angle advances through zigzags complete
// 360-degree periods while X advances uniformly from 0 to spring_length.
function wave_body_path(steps) = [
    for (i=[0:steps])
    [i * spring_length / steps, sin(i * 360 * zigzags / steps) * (spring_width/2)]
];

// Builds one arm centerline.
//
// y_dir is +1 for the right-side path and -1 for the mirrored left-side path.
// A solid arm contains only root and endpoint. A springy arm inserts alternating
// X offsets of +/-5 mm while progressing outward along Y. When the rigid torso is
// disabled, the arm root moves to half the spring width instead of body width.
function arm_path(y_dir, x_offset=0) = (arm_style == "solid") ?
    [[body_position + x_offset, y_dir * (add_center_body ? arm_start_width : 0)], [body_position + x_offset, y_dir * (arm_start_width + arm_reach)]] :
    concat(
        [[body_position + x_offset, y_dir * (add_center_body ? arm_start_width : 0)]],
        [ for (i=[1 : arm_zigzags*2-1]) [body_position + x_offset + ((i%2==1)? 5 : -5), y_dir * (arm_start_width + i * arm_reach / (arm_zigzags*2))] ],
        [[body_position + x_offset, y_dir * (arm_start_width + arm_reach)]]
    );

// Precompute both possible body paths. OpenSCAD variables are immutable values,
// so later modules can reuse these lists without rebuilding their expressions.
zigzag_path = zigzag_body_path();
// Twenty samples per period give the sinusoidal path a reasonably smooth shape.
wave_steps = zigzags * 20;
wave_path = wave_body_path(wave_steps);
// Select the path consumed by spring_body_3d().
active_path = spring_style == "zigzag" ? zigzag_path : wave_path;
// Root half-spacing shared by both arm paths.
arm_start_width = add_center_body ? body_width/2 : spring_width/2;
// Mirrored arm paths are calculated separately because their Y coordinates differ.
arm_path_R = arm_path(1, arm_offset_x);
arm_path_L = arm_path(-1, arm_offset_x);

// =============================================================================
// POLYLINE CONSTRUCTION
// =============================================================================

// Converts a list of [X,Y] points into a continuous rounded 2D strut.
// Each pair of adjacent points receives one circle at either end. hull() fills
// the convex region between them, and neighboring segments overlap at their
// shared circles. The result is a printable path with constant nominal width.
module native_polyline(path, width) {
    for (i = [0 : len(path) - 2]) {
        hull() {
            translate([path[i][0], path[i][1]]) circle(r=width/2, $fn=16);
            translate([path[i+1][0], path[i+1][1]]) circle(r=width/2, $fn=16);
        }
    }
}

// Convenience wrapper that turns a native 2D polyline into a 3D strut. The
// default extrusion height keeps the spring aligned with arms and body.
module extruded_polyline(path, width, height=print_thickness) {
    linear_extrude(height=height)
        native_polyline(path, width);
}

// Creates the two negative peg-hole cylinders used by the main base.
// The holes sit at one-quarter and three-quarters of the base width, providing
// symmetric support while leaving material around the center. Starting at
// Z=-0.1 and adding 0.2 mm to height guarantees a clean through-cut without
// coplanar faces at either end of the boolean subtraction.
module peg_holes_3d() {
    for (y=[-base_width/4, base_width/4]) {
        translate([-base_depth/2, y, -0.1])
            cylinder(h=base_peg_length + 0.2, r=base_hole_radius, $fn=64);
    }
}

// Builds the base permanently attached to the spring origin.
//
// The +1 mm X translation intentionally overlaps the base and the first spring
// segment, helping them export as one connected component. When a two-piece base
// is enabled, peg_holes_3d() is subtracted before optional shoes are added.
module main_base_3d() {
    color(base_color)
    translate([1, 0, 0])
    difference() {
        translate([-base_depth, -base_width/2, 0])
            cube([base_depth, base_width, base_height]);

        // A one-piece base remains solid because there is nothing to assemble.
        if (two_piece_base) peg_holes_3d();
    }

    // Shoes are separate positive geometry colored like the head and hands.
    if (add_feet) {
        color(head_color)
        for (side=[-1, 1]) {
            // side changes Y position. The conditional mirror gives both shoes
            // matching toe orientation while preserving one shoe definition.
            translate([-base_depth/2 + shoe_offset_x, side * shoe_offset_y, shoe_offset_z])
                mirror([0, side < 0 ? 1 : 0, 0]) shoe_3d();
        }
    }
}

// Builds the optional detached base half used for dual-sided standing support.
// It is moved away from the figure in negative X so it prints as a separate part.
// Two upward pegs match the hole positions in main_base_3d(). The -0.1 mm start
// creates a small overlap between peg and base, avoiding zero-thickness contact.
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

// Extrudes the currently selected body path at constant strut_width.
module spring_body_3d() {
    color(spring_color)
        extruded_polyline(active_path, strut_width);
}

// Adds the optional rigid torso. Its local corner is shifted by half body_width
// so the block remains centered on Y=0. body_offset_x adjusts it independently
// from the arms without changing the main spring path.
module center_body_3d() {
    if (add_center_body) {
        color(body_color)
        translate([body_position + body_offset_x, -body_width/2, 0])
            cube([body_length, body_width, print_thickness]);
    }
}

// Builds both flexible/solid arm struts and places one hand at each path endpoint.
// The struts share the body's print thickness. Hands are generated in the same
// XY plane and extruded separately so they can carry a different preview color.
module arms_3d() {
    if (arm_style != "none") {
        color(spring_color)
            linear_extrude(height=print_thickness) {
                native_polyline(arm_path_R, strut_width);
                native_polyline(arm_path_L, strut_width);
            }

        // Hands use head_color to group character skin/details visually.
        color(head_color) {
            for (side=[-1, 1]) {
                // Select the matching precomputed path for this side.
                path = side > 0 ? arm_path_R : arm_path_L;
                // Use the actual final path point so solid and springy arms both
                // place hands correctly when dimensions or offsets change.
                end = path_end(path);
                translate([end[0], end[1], 0])
                    linear_extrude(height=print_thickness) hand_2d(side);
            }
        }
    }
}

// Dispatches to one of three head-generation systems:
//   - creature_skull uses its dedicated detailed solid.
//   - robot_helmet uses its dedicated detailed solid.
//   - every other shape uses the generic profile around head_base_2d().
module selected_head_3d() {
    if (head_shape == "creature_skull") {
        detailed_skull_3d();
    } else if (head_shape == "robot_helmet") {
        detailed_robot_3d();
    } else {
        custom_head_3d();
    }
}

// Extrudes generic face details above the complete head profile. Dedicated skull
// and robot modules already add colored face geometry, so they are explicitly
// excluded by has_detailed_face(). The extrusion starts at print_thickness and
// extends through the profile height plus face_extrusion, ensuring that details
// intersect the head surface regardless of selected generic profile.
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

// Places the completed head beyond the end of the spring.
// spring_length reaches the body's final center point; adding head_radius-1
// overlaps the head edge and final spring segment by roughly 1 mm for a strong
// printable connection. Rotation encloses both head and face so they stay aligned.
module head_assembly_3d() {
    head_x = spring_length + head_radius - 1;

    translate([head_x, 0, 0]) {
        rotate([0, 0, head_rotation]) {
            color(head_color) selected_head_3d();
            face_details_3d();
        }
    }
}

// =============================================================================
// TOP-LEVEL ASSEMBLY
// =============================================================================

// Combines every enabled component. union() expresses design intent and lets
// OpenSCAD merge touching/overlapping parts where geometry actually intersects.
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

// Top-level invocation. Modules may be declared later in an OpenSCAD file, so
// the detailed head, shoe, hand, and face definitions below are still available.
flexi_figure_3d();

// =============================================================================
// DETAILED 3D HEAD: CREATURE SKULL
// =============================================================================

// Dedicated skull geometry that does not use head_base_2d() or custom_head_3d().
// The local origin matches the generic head origin, and all dimensions scale
// from head_radius, print_thickness, and head_profile_height.
module detailed_skull_3d() {
    // Short aliases keep the repeated proportional expressions readable.
    base_h = print_thickness;
    dome_h = head_profile_height;
    rad = head_radius;
    
    // Main cranium: a full-radius cylinder blended into a vertically scaled dome.
    hull() {
        cylinder(h=base_h, r=rad, $fn=64);
        translate([0, 0, base_h]) scale([1, 0.9, dome_h/rad]) sphere(r=rad, $fn=64);
    }
    // Positive-Y cheek/side lobe.
    hull() {
        translate([rad*0.3, rad*0.5, 0]) cylinder(h=base_h, r=rad*0.4, $fn=32);
        translate([rad*0.3, rad*0.5, base_h]) sphere(r=rad*0.4, $fn=32);
    }
    // Mirrored negative-Y cheek/side lobe.
    hull() {
        translate([rad*0.3, -rad*0.5, 0]) cylinder(h=base_h, r=rad*0.4, $fn=32);
        translate([rad*0.3, -rad*0.5, base_h]) sphere(r=rad*0.4, $fn=32);
    }
    // Forward muzzle/jaw blended from two lower cylinders into a raised dome.
    hull() {
        translate([rad*0.8, rad*0.2, 0]) cylinder(h=base_h, r=rad*0.3, $fn=32);
        translate([rad*0.8, -rad*0.2, 0]) cylinder(h=base_h, r=rad*0.3, $fn=32);
        translate([rad*0.8, 0, base_h]) scale([1, 0.5, dome_h/(rad*0.5)]) sphere(r=rad*0.5, $fn=32);
    }
    // Raised contrasting eye sockets, nose opening, and repeated teeth/ribs.
    color(eye_color) {
        translate([rad*0.2, rad*0.35, base_h + dome_h - 2]) cylinder(h=2 + face_extrusion, r=rad*0.25, $fn=32);
        translate([rad*0.2, -rad*0.35, base_h + dome_h - 2]) cylinder(h=2 + face_extrusion, r=rad*0.25, $fn=32);
        translate([rad*0.5, 0, base_h + dome_h - 4]) linear_extrude(height=4 + face_extrusion) polygon([[-rad*0.1, -rad*0.1], [rad*0.2, 0], [-rad*0.1, rad*0.1]]);
        // Five narrow cubes create evenly spaced vertical teeth across the jaw.
        for(y=[-rad*0.2:rad*0.1:rad*0.2]) {
            translate([rad*0.8, y, base_h + dome_h/2]) cube([rad*0.1, rad*0.05, dome_h + face_extrusion], center=true);
        }
    }
}

// =============================================================================
// DETAILED 3D HEAD: ROBOT HELMET
// =============================================================================

// Dedicated angular helmet with side pods and raised contrasting face panels.
// Like the skull, it scales entirely from the shared head parameters.
module detailed_robot_3d() {
    // Local aliases describe the helmet's base slab, raised shell, and radius.
    base_h = print_thickness;
    dome_h = head_profile_height;
    rad = head_radius;
    
    // Main helmet shell: hull() tapers from a wide lower box to a smaller upper box.
    hull() {
        translate([-rad*0.5, -rad*0.8, 0]) cube([rad*1.5, rad*1.6, base_h]);
        translate([-rad*0.4, -rad*0.7, base_h]) cube([rad*1.3, rad*1.4, dome_h]);
    }
    // Cylindrical side pods placed symmetrically along Y.
    translate([0, rad*0.8, 0]) cylinder(h=base_h + dome_h/2, r=rad*0.3, $fn=32);
    translate([0, -rad*0.8, 0]) cylinder(h=base_h + dome_h/2, r=rad*0.3, $fn=32);
    // Spherical caps round the tops of both side pods.
    translate([0, rad*0.8, base_h + dome_h/2]) sphere(r=rad*0.3, $fn=32);
    translate([0, -rad*0.8, base_h + dome_h/2]) sphere(r=rad*0.3, $fn=32);
    
    // Contrasting visor and a row of smaller lower face-panel details.
    color(eye_color) {
        translate([rad*0.7, 0, base_h]) {
            translate([0, 0, dome_h*0.6]) cube([rad*0.5, rad*1.2, dome_h*0.4 + face_extrusion], center=true);
            // Repeated narrow blocks create grille/indicator slots.
            for(y=[-rad*0.3 : rad*0.2 : rad*0.3]) {
                translate([rad*0.1, y, dome_h*0.2]) cube([rad*0.3, rad*0.05, dome_h*0.4 + face_extrusion], center=true);
            }
        }
    }
}

// =============================================================================
// FEET, HANDS, AND GENERIC HEAD PROFILE
// =============================================================================

// Builds one rounded shoe along local Z. hull() blends a full-size spherical
// heel/root into a smaller toe sphere at shoe_height. The final cube subtraction
// removes everything below local Z=0, producing a flat printable/assembly face.
// Rotation is applied before flattening, so the cut remains aligned with the
// shoe's local placement rather than following the tilted hull.
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

// Creates one simple 2D mitten-like hand. The main circle forms the palm and the
// smaller offset circle forms a thumb/finger bump. y_dir mirrors that bump for
// the opposite side while retaining one shared module.
module hand_2d(y_dir) {
    hull() {
        circle(r=6, $fn=32);
        translate([4, y_dir * 4]) circle(r=3, $fn=16); 
    }
}

// Builds a generic head from the selected 2D silhouette and 3D profile.
// Detailed skull and robot heads bypass this module in selected_head_3d().
module custom_head_3d() {
    if (head_profile == "half_sphere") {
        // Intersect a tall extrusion of the exact 2D silhouette with a composite
        // height envelope: a straight base cylinder plus a vertically scaled sphere.
        // The cylinder radius is intentionally oversized so head_base_2d(), not the
        // cylinder, controls the lower silhouette. The sphere creates the dome.
        intersection() {
            linear_extrude(height=print_thickness + head_profile_height + 10) head_base_2d();
            union() {
                cylinder(h=print_thickness, r=head_radius*3, $fn=64);
                translate([0, 0, print_thickness]) scale([1, 1, head_profile_height / (head_radius * 1.25)]) sphere(r=head_radius * 1.25, $fn=128);
            }
        }
    } else {
        // All non-spherical profiles begin with the same flat base extrusion.
        // Selecting "flat" stops here because neither profile branch below runs.
        linear_extrude(height=print_thickness) head_base_2d();
        if (head_profile == "contoured_curve") {
            // Approximate a quarter-sine rounding with head_profile_steps thin
            // offset silhouettes. sin() controls Z rise; 1-cos() controls inset.
            // Neighboring 0.01 mm slices are hulled to form watertight bands.
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
            // Linear alternative to the sine contour. Height and inset advance
            // uniformly at every step, producing a straight chamfered slope.
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

// =============================================================================
// GENERIC 2D HEAD SILHOUETTES
// =============================================================================

// Returns the outer 2D boundary used by custom_head_3d(). All shapes are centered
// near the local origin and scale from head_radius. union() combines decorative
// ears, horns, plates, and crests with a central skull shape; hull() is used when
// two lobes need a continuous organic transition.
module head_base_2d() {
    if (head_shape == "circle") {
        // Smooth circular head.
        circle(r=head_radius, $fn=64);
    } else if (head_shape == "square") {
        // Centered square sized to fit approximately inside the circular scale.
        square([head_radius*1.7, head_radius*1.7], center=true);
    } else if (head_shape == "hexagon") {
        // Six-sided circle primitive rotated to present a stable flat orientation.
        rotate(30) circle(r=head_radius*1.15, $fn=6);
    } else if (head_shape == "triangle") {
        // Three-sided circle primitive rotated to point in the desired direction.
        rotate(180) circle(r=head_radius*1.4, $fn=3);
    } else if (head_shape == "cat") {
        // Circular face plus two triangular ears on the positive-X side.
        union() {
            circle(r=head_radius, $fn=64);
            polygon([[head_radius*0.3, head_radius*0.6], [head_radius*0.9, head_radius*0.9], [head_radius*0.7, head_radius*0.2]]);
            polygon([[head_radius*0.3, -head_radius*0.6], [head_radius*0.9, -head_radius*0.9], [head_radius*0.7, -head_radius*0.2]]);
        }
    } else if (head_shape == "bear") {
        // Circular face plus two round ears mirrored across Y.
        union() {
            circle(r=head_radius, $fn=64);
            translate([head_radius*0.6, head_radius*0.7]) circle(r=head_radius*0.4, $fn=32);
            translate([head_radius*0.6, -head_radius*0.7]) circle(r=head_radius*0.4, $fn=32);
        }
    } else if (head_shape == "enderman") {
        // Block-like game-inspired head.
        square([head_radius*1.6, head_radius*1.6], center=true);
    } else if (head_shape == "dragon") {
        // Circular skull with paired horns and paired side spikes.
        union() {
            circle(r=head_radius, $fn=64);
            polygon([[head_radius*0.3, head_radius*0.7], [head_radius*0.9, head_radius*1.5], [head_radius*0.6, head_radius*0.6]]);
            polygon([[head_radius*0.3, -head_radius*0.7], [head_radius*0.9, -head_radius*1.5], [head_radius*0.6, -head_radius*0.6]]);
            polygon([[head_radius*0.8, -head_radius*0.2], [head_radius*1.4, -head_radius*0.4], [head_radius*0.7, -head_radius*0.6]]);
            polygon([[head_radius*0.8, head_radius*0.2], [head_radius*1.4, head_radius*0.4], [head_radius*0.7, head_radius*0.6]]);
        }
    } else if (head_shape == "trex") {
        // Two scaled circular lobes hulled into an elongated dinosaur skull.
        hull() {
            translate([0, head_radius*0.2]) scale([1, 0.8]) circle(r=head_radius*0.8, $fn=64);
            translate([0, -head_radius*0.4]) scale([1, 0.9]) circle(r=head_radius*0.6, $fn=64);
        }
    } else if (head_shape == "triceratops") {
        // Scalloped frill, central face, and two directional horn polygons.
        union() {
            // Five overlapping circles create the broad rear frill.
            for(a=[-60:30:60]) rotate(a) translate([0, head_radius*0.7]) circle(r=head_radius*0.4, $fn=32);
            circle(r=head_radius*0.8, $fn=64);
            translate([head_radius*0.3, head_radius*0.2]) rotate(-30) polygon([[-head_radius*0.2, 0], [0, head_radius*0.8], [head_radius*0.2, 0]]);
            translate([head_radius*0.3, -head_radius*0.2]) rotate(30) polygon([[-head_radius*0.2, 0], [0, -head_radius*0.8], [head_radius*0.2, 0]]);
        }
    } else if (head_shape == "brachiosaurus") {
        // Two overlapping circles form a soft high-crowned head.
        union() {
            circle(r=head_radius*0.7, $fn=64);
            translate([0, head_radius*0.5]) circle(r=head_radius*0.6, $fn=64); 
        }
    } else if (head_shape == "stegosaurus") {
        // Flattened central skull with three triangular dorsal plates.
        union() {
            scale([1, 0.8]) circle(r=head_radius*0.7, $fn=64);
            for(a=[-45, 0, 45]) rotate(a) translate([0, head_radius*0.6]) polygon([[-head_radius*0.3, 0], [0, head_radius*0.6], [head_radius*0.3, 0]]);
        }
    } else if (head_shape == "dilophosaurus") {
        // Elongated skull plus two narrow elliptical crests.
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

// Creates the flat artwork that is later extruded by face_details_3d().
//
// Coordinate note:
// The face is intentionally drawn in the same local XY plane as head_base_2d().
// Because the complete head is rotated onto the side of the figure, these local
// coordinates may not correspond to the apparent horizontal and vertical axes
// in the final assembled model.  All dimensions remain proportional to
// head_radius so that each face follows changes to the overall head size.
//
// The dinosaur, dragon, and Enderman heads have dedicated markings whose
// geometry is selected solely by head_shape.  The more general head shapes use
// face_expression instead.  Every primitive emitted here becomes raised face
// material; these shapes are not cut out of the head.
module face_2d() {
    if (head_shape == "enderman") {
        // Two long rectangular eyes reproduce the character's characteristic
        // narrow gaze.  Their offsets are mirrored around the head center.
        translate([head_radius*0.45, head_radius*0.1]) square([head_radius*0.6, head_radius*0.15], center=true);
        translate([-head_radius*0.45, head_radius*0.1]) square([head_radius*0.6, head_radius*0.15], center=true);
    } else if (head_shape == "dragon") {
        // Slanted, vertically compressed circles form a pair of reptilian eyes.
        translate([head_radius*0.4, head_radius*0.2]) rotate(20) scale([1, 0.3]) circle(r=head_radius*0.25, $fn=32);
        translate([-head_radius*0.4, head_radius*0.2]) rotate(-20) scale([1, 0.3]) circle(r=head_radius*0.25, $fn=32);

        // Small flattened ellipses mark the nostrils near the end of the snout.
        translate([head_radius*0.2, -head_radius*0.5]) scale([1, 0.5]) circle(r=head_radius*0.1, $fn=16);
        translate([-head_radius*0.2, -head_radius*0.5]) scale([1, 0.5]) circle(r=head_radius*0.1, $fn=16);

        // A triangular forehead mark adds a central horn-like accent.
        translate([0, head_radius*0.5]) polygon([[-head_radius*0.2, 0], [0, head_radius*0.3], [head_radius*0.2, 0]]);
    } else if (head_shape == "trex") {
        // Narrow angled eyes give the T. rex an aggressive expression.
        translate([head_radius*0.35, head_radius*0.3]) rotate(-15) scale([1, 0.5]) circle(r=head_radius*0.15, $fn=32);
        translate([-head_radius*0.35, head_radius*0.3]) rotate(15) scale([1, 0.5]) circle(r=head_radius*0.15, $fn=32);

        // Matching rectangular brow ridges reinforce the eye angles.
        translate([head_radius*0.35, head_radius*0.45]) rotate(-15) square([head_radius*0.4, head_radius*0.1], center=true);
        translate([-head_radius*0.35, head_radius*0.45]) rotate(15) square([head_radius*0.4, head_radius*0.1], center=true);

        // Two small circular nostrils sit near the center of the snout.
        translate([head_radius*0.2, -head_radius*0.1]) circle(r=head_radius*0.06, $fn=16);
        translate([-head_radius*0.2, -head_radius*0.1]) circle(r=head_radius*0.06, $fn=16);

        // Five evenly spaced downward-pointing triangles create exposed teeth.
        // The loop index controls only horizontal spacing; every tooth has the
        // same size and vertical position.
        translate([0, -head_radius*0.3]) for(i=[-2:2]) translate([i*head_radius*0.18, 0]) polygon([[-head_radius*0.07, 0], [0, -head_radius*0.25], [head_radius*0.07, 0]]);
    } else if (head_shape == "triceratops") {
        // Central snout detail, followed by a mirrored pair of eyes.
        translate([0, -head_radius*0.2]) circle(r=head_radius*0.15, $fn=32);
        translate([head_radius*0.4, 0]) circle(r=head_radius*0.12, $fn=32);
        translate([-head_radius*0.4, 0]) circle(r=head_radius*0.12, $fn=32);

        // The lower triangle gives the mouth a simple pointed silhouette.
        translate([0, -head_radius*0.6]) polygon([[-head_radius*0.2, 0], [0, -head_radius*0.3], [head_radius*0.2, 0]]);
    } else if (head_shape == "brachiosaurus") {
        // Small high-set nostrils suit the rounded top of the long-necked head.
        translate([head_radius*0.15, head_radius*0.7]) circle(r=head_radius*0.08, $fn=16);
        translate([-head_radius*0.15, head_radius*0.7]) circle(r=head_radius*0.08, $fn=16);

        // Large, widely separated circular eyes create a gentle expression.
        translate([head_radius*0.4, head_radius*0.1]) circle(r=head_radius*0.12, $fn=32);
        translate([-head_radius*0.4, head_radius*0.1]) circle(r=head_radius*0.12, $fn=32);

        // Subtracting the offset rectangle from the circle leaves a curved
        // smile arc rather than a filled circular mouth.
        translate([0, -head_radius*0.4]) difference() { circle(r=head_radius*0.3, $fn=32); translate([0, head_radius*0.1]) square([head_radius*0.8, head_radius*0.4], center=true); }
    } else if (head_shape == "stegosaurus") {
        // Compact circular eyes match the broad, flattened skull profile.
        translate([head_radius*0.3, head_radius*0.1]) circle(r=head_radius*0.1, $fn=32);
        translate([-head_radius*0.3, head_radius*0.1]) circle(r=head_radius*0.1, $fn=32);

        // A small downward triangle acts as a minimal mouth detail.
        translate([0, -head_radius*0.4]) polygon([[-head_radius*0.15, 0], [0, -head_radius*0.2], [head_radius*0.15, 0]]);
    } else if (head_shape == "dilophosaurus") {
        // Mirrored slanted ellipses provide alert, predatory eyes.
        translate([head_radius*0.35, head_radius*0.1]) rotate(-10) scale([1, 0.6]) circle(r=head_radius*0.15, $fn=32);
        translate([-head_radius*0.35, head_radius*0.1]) rotate(10) scale([1, 0.6]) circle(r=head_radius*0.15, $fn=32);

        // Small nostrils are placed low on the elongated muzzle.
        translate([head_radius*0.15, -head_radius*0.6]) circle(r=head_radius*0.06, $fn=16);
        translate([-head_radius*0.15, -head_radius*0.6]) circle(r=head_radius*0.06, $fn=16);

        // Three triangular teeth are distributed symmetrically across the jaw.
        translate([0, -head_radius*0.3]) for(i=[-1:1]) translate([i*head_radius*0.2, 0]) polygon([[-head_radius*0.08, 0], [0, -head_radius*0.15], [head_radius*0.08, 0]]);
    } else {
        // All remaining head profiles use the selectable generic expressions.
        // In this coordinate system the two eye positions differ mainly along
        // local Y, while the mouth is offset toward negative local X.
        if (face_expression == "surprised") {
            // Two round eyes and a flattened oval open mouth.
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.2, 0]) scale([1, 0.7]) circle(r=head_radius*0.2, $fn=64);
        } else if (face_expression == "happy") {
            // Round eyes accompany a smile made from a partially clipped disk.
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);

            // Removing the translated rectangle leaves the smiling arc.
            translate([-head_radius*0.1, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        } else if (face_expression == "sad") {
            // The eyes remain round while the mouth's clipping direction is
            // reversed relative to the happy expression, producing a frown.
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.3, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([-head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        } else if (face_expression == "angry") {
            // Rotated rectangular eyes create opposing inward slopes.
            translate([head_radius*0.3, head_radius*0.35]) rotate(-20) square([head_radius*0.1, head_radius*0.25], center=true);
            translate([head_radius*0.3, -head_radius*0.35]) rotate(20) square([head_radius*0.1, head_radius*0.25], center=true);

            // A clipped circular frown completes the angry expression.
            translate([-head_radius*0.25, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([-head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        } else if (face_expression == "neutral") {
            // Round eyes and a straight rectangular mouth keep the face neutral.
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([-head_radius*0.2, 0]) square([head_radius*0.08, head_radius*0.4], center=true);
        } else if (face_expression == "winking") {
            // One round eye and one narrow rectangular eye form the wink.
            translate([head_radius*0.3, head_radius*0.35]) circle(r=head_radius*0.12, $fn=64);
            translate([head_radius*0.3, -head_radius*0.35]) square([head_radius*0.08, head_radius*0.25], center=true);

            // Reuse the happy clipped-disk mouth for a playful expression.
            translate([-head_radius*0.1, 0]) difference() {
                circle(r=head_radius*0.25, $fn=64);
                translate([head_radius*0.15, 0]) square([head_radius*0.5, head_radius*0.6], center=true);
            }
        }
    }
}
