/* ========================================================================== 

   Big Hero Megabot Inspired by the Movie "Big Hero 6" (2014)
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   A customizable interpretation of the small Megabots seen in "Big Hero 6".
   The character consists of three stacked spherical body sections, six tapered
   limbs, interchangeable connector styles, and a removable curved face plate.
   Magnet recesses are available for both body joints and the face.

   COORDINATES AND UNITS
   ---------------------
   All dimensions are millimetres.  In assembled mode the three body centres lie
   on the global Z axis, with the torso at Z=0.  The face points toward negative
   Y.  Limb orientation is stored as body index, polar angle, and azimuth angle.

   PRINTING STRATEGY
   -----------------
   print_layout places body sections on their flat joint surfaces, places limbs
   upright on flat-cut spherical bases, and rests the curved face like a shallow
   dome.  Optional loose joint connectors receive their own flattened build faces.

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */ 

/* [Settings] */
// Selects the complete assembly or a layout of separately printable components.
view_mode = "print_layout"; // [assembled, print_layout]

// Selects the visual motif generated on the curved face plate.
face_style = "happy"; // [happy, angry, surprised, robot]

// magnet creates matching recesses in face and head; fixed leaves no recess.
face_mount = "magnet"; // [magnet, fixed]

// Selects the connection system used by body sections and limbs:
// magnet recesses, ball connectors, fixed unions, straight links, or slotted
// snap-ball connectors.
joint_style = "magnet"; // [magnet, ball, fixed, link, snap]

// Separates detachable parts in assembled view to reveal their connection points.
explode_distance = 0; // [0:2:50]

/* [Body Parameters] */
// Diameter shared by the head, torso, and pelvis spheres.
body_diameter = 50; // [10:1:80]

// Vertical centre-to-centre spacing between adjacent body spheres.
body_z_offset = 40; // [20:1:60]

/* [Limb Parameters] */
// Depth removed from a sphere to create each flat body/limb contact surface.
flat_cut_depth = 1.5; // [0:0.5:10]

// Additional outward spacing between limb bases and body contact surfaces.
limb_outward_offset = 5; // [0:1:30]

// Diameter of the rounded limb base.
limb_base_diameter = 22; // [5:1:50]

// Base diameter of the tapered eight-sided limb shaft.
limb_cone_base_diameter = 30; // [5:1:50]

// Axial length of the smooth hulled transition from spherical base to shaft.
limb_transition_length = 10; // [0:1:30]

// Diameter at the narrow distal limb tip.
limb_tip_diameter = 9; // [2:1:30]

// Overall limb length from its build-plane base to the tip centre.
limb_length = 80; // [30:1:120]

// Diameter of the circular curved face-plate boundary.
face_diameter = 28; // [10:1:50]

/* [Joint & Magnet Parameters] */
// Diameter and insertion depth of cylindrical magnet recesses.
magnet_diameter = 4.96; // [3:0.1:15]
magnet_depth = 4.94; // [1:0.1:10]

// Diameter of ball-connector ends and their narrower joining neck.
joint_ball_diameter = 9; // [4:0.2:20]
joint_neck_diameter = 6; // [2:0.2:16]

/* [FDM 3D Printing Optimization] */
// Radial clearance added to magnet holes, ball sockets, and link sockets.
fdm_tolerance = 0.2; // [0:0.05:0.5]

// Depth removed from loose connector bottoms to create stable print surfaces.
connector_print_flat_cut = 1.5; // [0:0.1:4.5]

/* [Colors] */
// Preview colours for the body and layered face details.  Ordinary STL export
// does not retain OpenSCAD colour assignments.
body_color = "#1E66AE";
feature_white = "#FFFFFF";
feature_black = "#111111";

// Global fragment count for smooth body and face spheres.
$fn = 100;

// ---------------------------------------------------------------------------
// Derived connection geometry
// ---------------------------------------------------------------------------

// Convert the user-facing face diameter to the radius used internally.
face_r = face_diameter / 2;

// Convert the user-facing body diameter to the radius used internally.
body_r = body_diameter / 2;

// Radius of the circular plane created by cutting flat_cut_depth from body_r.
flat_r = sqrt(pow(body_r, 2) - pow(body_r - flat_cut_depth, 2));

// Convert user-facing limb diameters to radii used by OpenSCAD primitives.
limb_base_r = limb_base_diameter / 2;
limb_cone_base_r = limb_cone_base_diameter / 2;
limb_tip_r = limb_tip_diameter / 2;

// Convert user-facing connector diameters to internal radii.
joint_ball_radius = joint_ball_diameter / 2;
joint_neck_radius = joint_neck_diameter / 2;

// Guarantee that the rounded limb base fully covers the required contact circle.
safe_limb_base_r = max(limb_base_r, flat_r + 0.5);

// Raise the base sphere so its flat cut at Z=0 has exactly radius flat_r.
dome_center_z = sqrt(pow(safe_limb_base_r, 2) - pow(flat_r, 2));

// Keep the curved face thick enough to contain a magnet recess plus backing skin.
face_thickness = max(2.5, magnet_depth /2 + 0.4);

// Z centres of pelvis, torso, and head, addressed by indices 0, 1, and 2.
body_z = [-body_z_offset, 0, body_z_offset];

// Limb descriptors are [body index, polar angle from +Z, azimuth around Z].
// Mirrored azimuths place each left/right pair on opposite sides of the body.
limbs = [
    [2, 45, 180],  // Left horn
    [2, 45, 0],    // Right horn
    [1, 80, 180],  // Left arm
    [1, 80, 0],    // Right arm
    [0, 135, 180], // Left leg
    [0, 135, 0]    // Right leg
];

// Top-level view dispatcher.  Any value other than print_layout uses assembly.
module main() {
    if (view_mode == "print_layout") {
        print_layout();
    } else {
        assembled_model();
    }
}

// Invoke the selected model exactly once.
main();

// Builds the complete character in its functional orientation, with optional
// explosion offsets and visible connector samples between separated parts.
module assembled_model() {
    // Place head, torso, and pelvis at their configured Z centres.  Explosion
    // moves only the outer body sections away from the central torso.
    translate([0, 0, body_z[2] + explode_distance]) color(body_color) body_head();
    translate([0, 0, body_z[1]]) color(body_color) body_torso();
    translate([0, 0, body_z[0] - explode_distance]) color(body_color) body_pelvis();
    
    // Show magnets or loose mechanical connectors between body sections only in
    // an exploded, non-fixed assembly.
    if (explode_distance > 0 && joint_style != "fixed") {
        color("Silver") {
            if (joint_style == "magnet") {
                // Two centred cylinders visualize the inter-body magnets.
                translate([0, 0, body_z_offset/2 + explode_distance/2]) cylinder(h=magnet_depth*2, r=magnet_diameter/2, center=true, $fn=32);
                translate([0, 0, -body_z_offset/2 - explode_distance/2]) cylinder(h=magnet_depth*2, r=magnet_diameter/2, center=true, $fn=32);
            } else {
                // Mechanical styles use the same double-ended connector geometry
                // as the detachable limb joints.
                translate([0, 0, body_z_offset/2 + explode_distance/2]) rotate([0, 90, 0]) connector_flat_centered(joint_style, 0);
                translate([0, 0, -body_z_offset/2 - explode_distance/2]) rotate([0, 90, 0]) connector_flat_centered(joint_style, 0);
            }
        }
    }
    
    // Move the face plate forward along negative Y together with the exploded head.
    translate([0, -explode_distance, body_z[2] + explode_distance]) 
    curved_face_plate();
    
    // Visualize the face magnet midway between separated face and head surfaces.
    if (face_mount == "magnet" && explode_distance > 0) {
        color("Silver")
        translate([0, -body_r - explode_distance/2, body_z[2] + explode_distance])
        rotate([90,0,0]) cylinder(h=magnet_depth*2, r=magnet_diameter/2, center=true, $fn=32);
    }
    
    for (l = limbs) {
        // Decode this limb's target body elevation and two orientation angles.
        bz = body_z[l[0]];
        theta = l[1];
        phi = l[2];
        
        // Fixed limbs remain attached; detachable limbs move outward.
        actual_explode = (joint_style == "fixed") ? 0 : explode_distance;

        // Horns follow head explosion, legs follow pelvis explosion, and arms
        // remain at torso elevation.
        z_explode = (l[0] == 2) ? explode_distance : ((l[0] == 0) ? -explode_distance : 0);

        // Orient local limb +Z radially from its body sphere, then move its base
        // to the sphere's flat contact plane plus outward offset.
        translate([0, 0, bz + z_explode])
        rotate([0, 0, phi])
        rotate([0, theta, 0])
        translate([0, 0, body_r - flat_cut_depth + limb_outward_offset]) {
            translate([0, 0, actual_explode]) {
                if (joint_style == "fixed") {
                    // Pull fixed limbs inward so they overlap the body robustly.
                    translate([0, 0, -2 - limb_outward_offset]) color(body_color) limb();
                } else {
                    color(body_color) limb();
                }
            }
            if (joint_style == "ball" || joint_style == "snap" || joint_style == "link") {
                // Place a visible loose connector halfway across the exploded gap.
                color("Silver") 
                translate([0, 0, actual_explode / 2 - limb_outward_offset / 2]) 
                rotate([0, 90, 0])
                connector_flat_centered(joint_style, limb_outward_offset);
            }
        }
    }
}

// Arranges all printable components on stable flat faces with generous XY spacing.
module print_layout() {
    // Scale the layout grid from body diameter.
    spacing = body_r * 2.8;

    // Stand body sections on their existing flat neck/waist joint surfaces.  The
    // pelvis is flipped so its upper waist plane faces the build plate.
    translate([0, spacing, body_z_offset/2]) color(body_color) body_head();
    translate([0, 0, body_z_offset/2]) color(body_color) body_torso();
    translate([0, -spacing, body_z_offset/2]) rotate([180, 0, 0]) color(body_color) body_pelvis();
    
    // Print all six limbs upright on their flat-cut rounded bases.
    color(body_color)
    for (i=[0:5]) {
        // Two columns by three rows mirror the six-limb descriptor arrangement.
        x_pos = (i%2 == 0) ? -spacing : spacing;
        y_pos = spacing - floor(i/2)*spacing;
        translate([x_pos, y_pos, 0]) limb();
    }
    
    // Rest the curved face like a shallow dome on the build plate.  z_trans is
    // the sphere elevation where the circular face boundary touches Z=0.
    z_trans = -sqrt(pow(body_r, 2) - pow(face_r, 2));
    translate([spacing * 1.8, 0, z_trans])
    rotate([-90, 0, 0])
    curved_face_plate();
    
    // Arrange separately printable mechanical connectors below the main parts.
    if (joint_style == "ball" || joint_style == "snap" || joint_style == "link") {
        color("Silver") {
            for (i=[0:5]) {
                // Six longer connectors include the configured limb offset.
                translate([-spacing + i*20, -spacing * 1.8, 0])
                translate([0, 0, joint_ball_radius - connector_print_flat_cut]) 
                connector_printable(joint_style, limb_outward_offset);
            }
            for (i=[0:1]) {
                // Two shorter connectors join the three body sections.
                translate([spacing * 0.5 + i*20, -spacing * 1.8, 0])
                translate([0, 0, joint_ball_radius - connector_print_flat_cut]) 
                connector_printable(joint_style, 0);
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Body sections
// ---------------------------------------------------------------------------

// Builds the spherical head with a flat lower neck surface, optional neck socket,
// optional face-magnet recess, and two horn/ear joint cuts.
module body_head() {
    difference() {
        // Begin with the complete head sphere.
        sphere(r=body_r);
        
        // Remove the lower spherical cap at the torso connection.  The resulting
        // plane also serves as a support-free build surface in print_layout.
        translate([-body_r*2, -body_r*2, -body_r*4 - body_z_offset/2]) cube([body_r*4, body_r*4, body_r*4]);
        
        // Cut the selected detachable socket downward into the neck surface.
        if (joint_style != "fixed") {
            translate([0, 0, -body_z_offset/2]) rotate([180,0,0]) joint_socket(joint_style);
        }
        
        // Cut a face-magnet recess inward from the sphere's negative-Y surface.
        if (face_mount == "magnet") {
            translate([0, -body_r - 0.1, 0]) rotate([-90,0,0]) 
            cylinder(h=magnet_depth + 0.1, r=(magnet_diameter/2) + fdm_tolerance, $fn=32);
        }
        
        // Cut matching limb sockets at both horn descriptor orientations.
        for (l = limbs) if (l[0] == 2) {
            rotate([0, 0, l[2]]) rotate([0, l[1], 0])
            translate([0, 0, body_r - flat_cut_depth])
            joint_socket_body_cut(joint_style);
        }
    }
}

// Builds the central torso with flat upper/lower surfaces, two axial body-joint
// sockets, and two radial arm sockets.
module body_torso() {
    difference() {
        sphere(r=body_r);
        
        // Remove upper and lower caps at half the body-section spacing.
        translate([-body_r*2, -body_r*2, body_z_offset/2]) cube([body_r*4, body_r*4, body_r*4]);
        translate([-body_r*2, -body_r*2, -body_r*4 - body_z_offset/2]) cube([body_r*4, body_r*4, body_r*4]);
        
        // Cut head and pelvis connection sockets into opposite axial faces.
        if (joint_style != "fixed") {
            translate([0, 0, body_z_offset/2]) joint_socket(joint_style);
            translate([0, 0, -body_z_offset/2]) rotate([180,0,0]) joint_socket(joint_style);
        }
        
        // Cut arm sockets according to torso limb descriptors.
        for (l = limbs) if (l[0] == 1) {
            rotate([0, 0, l[2]]) rotate([0, l[1], 0])
            translate([0, 0, body_r - flat_cut_depth])
            joint_socket_body_cut(joint_style);
        }
    }
}

// Builds the lower spherical pelvis with a flat upper waist surface and two leg
// socket cuts.  Its rounded underside remains intact in assembled mode.
module body_pelvis() {
    difference() {
        sphere(r=body_r);
        
        // Remove the upper cap; after a 180-degree layout rotation this waist
        // plane becomes the pelvis build surface.
        translate([-body_r*2, -body_r*2, body_z_offset/2]) cube([body_r*4, body_r*4, body_r*4]);
        
        // Cut the selected detachable waist socket.
        if (joint_style != "fixed") {
            translate([0, 0, body_z_offset/2]) joint_socket(joint_style);
        }
        
        // Cut leg sockets according to pelvis limb descriptors.
        for (l = limbs) if (l[0] == 0) {
            rotate([0, 0, l[2]]) rotate([0, l[1], 0])
            translate([0, 0, body_r - flat_cut_depth])
            joint_socket_body_cut(joint_style);
        }
    }
}

// Cuts the half-space outside a limb contact plane and, for detachable styles,
// adds the selected socket cutter.  The caller orients local +Z away from body.
module joint_socket_body_cut(type) {
    // Remove all body material beyond the local tangent/contact plane.
    translate([-body_r*2, -body_r*2, 0]) cube([body_r*4, body_r*4, body_r*2]);
    if (type != "fixed") {
        joint_socket(type);
    }
}

// Builds one generic horn, arm, or leg.  All six instances share this geometry;
// their role is determined solely by placement in assembled_model().
module limb() {
    difference() {
        union() {
            // Start the rounded base sphere at the calculated elevation that
            // produces the desired contact radius after flattening at Z=0.
            translate([0, 0, dome_center_z]) {
                if (limb_transition_length > 0) {
                    // Hull the base sphere to a thin octagonal section for a soft
                    // transition into the tapered shaft.
                    hull() {
                        sphere(r=safe_limb_base_r);
                        translate([0, 0, limb_transition_length])
                        rotate([0, 0, 22.5])
                        cylinder(h=0.1, r=limb_cone_base_r, $fn=8);
                    }
                    translate([0, 0, limb_transition_length])
                    rotate([0, 0, 22.5])
                    cylinder(h=max(0.1, limb_length - dome_center_z - limb_transition_length), r1=limb_cone_base_r, r2=limb_tip_r, $fn=8);
                } else {
                    // With no transition, begin the tapered shaft directly at the
                    // base sphere's local centre elevation.
                    sphere(r=safe_limb_base_r);
                    rotate([0, 0, 22.5])
                    cylinder(h=max(0.1, limb_length - dome_center_z), r1=limb_cone_base_r, r2=limb_tip_r, $fn=8);
                }
            }
            // Round the narrow distal end with a tip sphere.
            translate([0, 0, limb_length]) sphere(r=limb_tip_r);
        }
        
        // Remove all material below Z=0 to create the flat printable limb base.
        translate([-100, -100, -200]) cube([200, 200, 200]);
        
        if (joint_style != "fixed") {
            // Mirror the socket so it cuts upward into the flattened base.
            mirror([0,0,1]) joint_socket(joint_style);
        }
    }
}

// Generates a negative socket cutter at a local contact plane of Z=0.
// Every cutter extends into negative Z so callers can orient the contact plane.
module joint_socket(type) {
    if (type == "magnet") {
        // Cylindrical magnet pocket with radial FDM clearance.
        translate([0,0,-magnet_depth]) cylinder(h=magnet_depth + 0.1, r=(magnet_diameter/2) + fdm_tolerance, $fn=32);
    } else if (type == "ball" || type == "snap") {
        // Ball cavity plus access neck.  Snap style slightly tightens the neck so
        // its opening can retain a slotted ball after insertion.
        neck_clearance = (type == "snap") ? -0.1 : fdm_tolerance;
        depth = joint_ball_radius + joint_neck_radius;
        translate([0,0,-depth]) sphere(r=joint_ball_radius + fdm_tolerance, $fn=32);
        translate([0,0,-depth]) cylinder(h=depth + 0.1, r=joint_neck_radius + neck_clearance, $fn=32);
    } else if (type == "link") {
        // Straight cylindrical socket for the simple double-ended link.
        translate([0,0,-7]) cylinder(h=7.1, r=4.2 + fdm_tolerance, $fn=32);
    }
}

// Builds one double-ended connector centred along local X.
// offset_length increases only the central span, allowing limb connectors to
// bridge outward offsets while body connectors remain short.
module connector_flat_centered(type, offset_length) {
    base_length = (joint_ball_radius + joint_neck_radius) * 2;
    conn_length = base_length + offset_length;
    half_l = conn_length / 2;
    
    if (type == "ball" || type == "snap") {
        difference() {
            union() {
                // Join two spherical ends with a centred cylindrical neck.
                translate([-half_l, 0, 0]) sphere(r=joint_ball_radius, $fn=32);
                translate([ half_l, 0, 0]) sphere(r=joint_ball_radius, $fn=32);
                rotate([0, 90, 0]) cylinder(h=conn_length, r=joint_neck_radius, center=true, $fn=32);
            }
            if (type == "snap") {
                // A thin full-length slot lets the snap connector flex during fit.
                cube([conn_length + 20, 1.2, joint_ball_radius*4], center=true);
            }
        }
    } else if (type == "link") {
        // Link style is a single straight cylindrical pin.
        rotate([0,90,0]) cylinder(h=14 + offset_length, r=4, center=true, $fn=32);
    }
}

// Converts a centred connector into a separately printable part by removing a
// lower slice from both ends to create stable build-plate contact.
module connector_printable(type, offset_length) {
    base_length = (joint_ball_radius + joint_neck_radius) * 2;
    conn_length = base_length + offset_length;
    difference() {
        connector_flat_centered(type, offset_length);
        // Oversized cube removes only the connector region below the requested
        // flat-cut elevation.
        translate([-conn_length, -20, -20 - joint_ball_radius + connector_print_flat_cut]) cube([conn_length * 2, 40, 20]);
    }
}

// Builds the removable curved face as concentric spherical-shell layers clipped
// by a circular boundary.  Separate coloured layers form frame and expression.
module curved_face_plate() {
    // Background colour depends on expression; surprised uses the neutral fallback.
    bg_color = (face_style == "happy") ? "#F2C94C" : 
               (face_style == "angry") ? "#D64545" : 
               (face_style == "robot") ? "#3C4652" : "#E2E8F0";

    difference() {
        // Face shell: subtract the body sphere from a larger sphere, then clip the
        // result to a face_r cylinder directed along Y.
        color(bg_color) intersection() {
            difference() { sphere(r=body_r + face_thickness); sphere(r=body_r); }
            rotate([90,0,0]) cylinder(h=body_r*3, r=face_r);
        }
        
        // Cut the magnet recess from the inner/back surface of a magnetic plate.
        if (face_mount == "magnet") {
            translate([0, -body_r - 0.1, 0]) rotate([-90,0,0]) 
            cylinder(h=magnet_depth + 0.1, r=(magnet_diameter/2) + fdm_tolerance, $fn=32);
        }
    }
    
    // Black frame: a very thin outer spherical shell clipped to an annular border.
    color(feature_black) intersection() {
        difference() { sphere(r=body_r + face_thickness + 0.1); sphere(r=body_r + face_thickness); }
        rotate([90,0,0]) difference() {
            cylinder(h=body_r*3, r=face_r);
            translate([0,0,-1]) cylinder(h=body_r*3+2, r=face_r - 1.5);
        }
    }
    
    // White eyes, teeth, or mouth fill: project the selected 2D motif through a
    // thin spherical detail layer and retain their intersection.
    color(feature_white) intersection() {
        difference() { sphere(r=body_r + face_thickness + 0.2); sphere(r=body_r + 1); }
        rotate([90,0,0]) linear_extrude(body_r*3) features_white_2d();
    }
    
    // Black pupils, mouth outlines, and expression details use the next shell.
    color(feature_black) intersection() {
        difference() { sphere(r=body_r + face_thickness + 0.3); sphere(r=body_r + 1); }
        rotate([90,0,0]) linear_extrude(body_r*3) features_black_2d();
    }
    
    // Robot-only red and silver motifs occupy two additional spherical layers.
    color("#D64545") intersection() {
        difference() { sphere(r=body_r + face_thickness + 0.25); sphere(r=body_r + 1); }
        rotate([90,0,0]) linear_extrude(body_r*3) features_color1_2d();
    }
    color("Silver") intersection() {
        difference() { sphere(r=body_r + face_thickness + 0.25); sphere(r=body_r + 1); }
        rotate([90,0,0]) linear_extrude(body_r*3) features_color2_2d();
    }
}

// Generates white 2D expression regions before they are wrapped onto the face.
module features_white_2d() {
    if (face_style == "happy" || face_style == "surprised") {
        // Paired white eye disks.
        translate([-5, 4]) circle(r=3.5);
        translate([ 5, 4]) circle(r=3.5);
    }
    if (face_style == "happy") {
        // Flattened white mouth interior.
        translate([0, -3.5]) scale([1, 0.5]) circle(r=6);
    }
    if (face_style == "angry") {
        // Slanted eye whites and a row of triangular teeth.
        translate([-5, 4]) rotate(-20) square([7, 4], center=true);
        translate([ 5, 4]) rotate(20) square([7, 4], center=true);
        for(i=[-3:3:3]) translate([i, -4.5]) polygon([[-1.5,0], [1.5,0], [0,2.5]]);
    }
}

// Generates pupils and dark mouth geometry for non-robot expressions.
module features_black_2d() {
    if (face_style == "happy" || face_style == "surprised") {
        translate([-5, 4]) circle(r=1.5);
        translate([ 5, 4]) circle(r=1.5);
    }
    if (face_style == "happy") {
        // Subtract the white mouth interior from a larger ellipse to leave an arc.
        difference() {
            translate([0, -4]) scale([1, 0.6]) circle(r=7);
            translate([0, -3.5]) scale([1, 0.5]) circle(r=6);
        }
    }
    if (face_style == "surprised") {
        // Simple circular open mouth.
        translate([0, -4]) circle(r=3.5);
    }
    if (face_style == "angry") {
        // Pupils plus a dark mouth with tooth silhouettes removed.
        translate([-5, 3.5]) circle(r=1.5);
        translate([ 5, 3.5]) circle(r=1.5);
        difference() {
            translate([0, -4]) scale([1, 0.5]) circle(r=6);
            for(i=[-3:3:3]) translate([i, -4.5]) polygon([[-1.5,-1], [1.5,-1], [0,2.5]]);
        }
    }
}

// Generates the first robot-specific colour layer: two red square eyes.
module features_color1_2d() {
    if (face_style == "robot") {
        translate([-6, 2]) square([4, 4], center=true);
        translate([ 6, 2]) square([4, 4], center=true);
    }
}

// Generates the second robot-specific colour layer: a silver mouth grille.
module features_color2_2d() {
    if (face_style == "robot") {
        translate([0, -4]) square([16, 4], center=true);
    }
}
