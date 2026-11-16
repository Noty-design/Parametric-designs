/* ==========================================================================

   Parametric Five-Sided Snap-Fit Ball Joint (C)
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   A configurable link with independent ball (male), socket (female), or
   unused connectors on four side faces and the top. The link body can be
   a rounded cube, cylinder, sphere, or truncated pyramid, with optional
   Swedish-letter or stylized animal-head decoration. 

   This file is intentionally heavily commented so future parameter and geometry
   changes are easier to understand and make safely.
   ========================================================================== */

/* [Preview and layouts] */
// Preview: single, gallery, pair, print_pair
// Select a single customizable link or a fixed gallery, paired preview, or print layout.
view_mode = "single"; // [single, gallery, shape_gallery, decoration_gallery, alphabet_gallery, pair, print_pair, top_pair, top_print_pair]
/* [Connections] */
// Independent port selections for a single link:
// LEFT (+Y) port of a single link: none, ball (male) or socket (female).
left = "male"; // [none, male, female]
// FRONT (+X) port. A front decoration needs this connection set to none.
front  = "female"; // [none, male, female]
// RIGHT (-Y) port: none, ball (male) or socket (female).
right = "none"; // [none, male, female]
// BACK (-X) port: none, ball (male) or socket (female).
back  = "male"; // [none, male, female]
// TOP (+Z) port. Top decorations require this port to be none.
top   = "male"; // [none, male, female]
/* [Body and Decoration] */
// Selects a rounded cube, cylindrical, spheroid or truncated-pyramid body.
body_shape = "Cube"; // [Cube, Cylinder, Sphere, Pyramid]
// No decoration, one Swedish letter, or a stylized snake, shark or dragon head.
decoration_mode = "None"; // [None, Letter, Snake Head, Shark Head, Dragon Head]
// A single uppercase Swedish letter when decoration_mode is Letter.
letter_text = "A"; // A-Z, Å, Ä, Ö
// Places the requested decoration on top or at the front (+X).
decoration_position = "Top"; // [Top, Front]
// Letter extrusion height; animal heads have fixed dimensions.
decoration_height = 1.1; // [0.6:0.1:2.0]
// Letter size multiplier; animal heads have fixed dimensions.
decoration_scale = 1.0; // [0.7:0.1:1.4]

/* [Body dimensions] */
// Nominal link-body length along X, excluding the external connectors (mm).
body_length=14;
// Nominal width along Y (mm).
body_width=12;
// Nominal body height along Z (mm).
body_height=5.6;
// Rounding radius used only by the Cube body option.
body_corner_r=2.0;

/* [Joint fit and socket dimensions] */
// Outside radius of the spherical male connector (mm).
ball_radius=2.8;
// Height of the male ball's centre from the build plane (mm).
ball_center_z=2.3;
// Fit modes; "Firm" targets angle retention via light radial preload.
// Choose Firm (-0.05 mm), Loose (+0.15 mm) or Very Loose (+0.35 mm) nominal radial fit.
joint_fit = "Firm"; // [Firm, Loose, Very Loose]
// Outside radius of the receiving socket body (mm).
socket_outer_radius=4.9;
// Z height of the socket (mm).
socket_height=5.6;
// Radius of the opening through the upper and lower socket surfaces.
socket_top_hole_radius=2.05;
// Half-width of the side-entry mouth into the female socket.
mouth_half_width=2.30;
// Radius of the neck joining the male ball to its link body.
stem_radius=1.45;
/* [Connector placement and render quality] */
// Connector offset beyond the link body's edge (mm).
neighbor_attach=5.5;
// Fragment count for rounded surfaces; higher values increase render cost.
resolution=64;
$fn=resolution;
// Derived distance from the body centre to the connector centre.
joint_offset=body_length/2+neighbor_attach;
// Separation distance between independent parts in gallery/print layouts (mm).
print_pitch=39;

/* [Hidden] */
// Radial difference socket radius minus ball radius (mm).
// Firm:       -0.05 mm nominal interference; requires physical PETG fit test.
// Loose:       0.15 mm nominal gap, slight intended resistance.
// Very Loose: +0.35 mm nominal radial clearance.
function fit_radial_clearance(mode) =
    mode=="Firm" ? -0.05 :
    mode=="Loose" ? 0.15 :
    mode=="Very Loose" ? 0.35 : undef;
socket_clearance=fit_radial_clearance(joint_fit);
assert(!is_undef(socket_clearance), "Choose Firm, Loose, or Very Loose");

assert(ball_radius+socket_clearance+1.0 < socket_outer_radius);
assert(mouth_half_width < ball_radius);
assert(socket_top_hole_radius < ball_radius);
assert(ball_center_z < ball_radius);
assert(stem_radius < mouth_half_width);
assert(neighbor_attach > socket_outer_radius);
// Accept only supported port types; a five-port link has independent faces.
function valid_port(v) = v=="none" || v=="male" || v=="female";
function valid_ports(p) = len(p)==5 && valid_port(p[0]) &&
  valid_port(p[1]) && valid_port(p[2]) && valid_port(p[3]) && valid_port(p[4]);

// Rounded rectangular body, extruded to the selected body height.
module rounded_body(){
  linear_extrude(height=body_height)
    offset(r=body_corner_r)
      square([body_length-2*body_corner_r,
              body_width-2*body_corner_r],center=true);
}

// Male ball and connecting stem. The lower ball is clipped to Z=0.
module male_ball(){
  // Connected to the right face of its owning body.
  // Sphere is clipped by the build plane at z=0 to create a footprint.
  intersection(){
    translate([joint_offset,0,ball_center_z]) sphere(r=ball_radius);
    translate([joint_offset-ball_radius-0.1,-ball_radius-0.1,0])
      cube([2*ball_radius+0.2,2*ball_radius+0.2,2*ball_radius+2]);
  }
  // Smooth horizontal neck between body and ball.
  translate([0,0,ball_center_z])
    hull(){
      translate([body_length/2-0.5,0,0]) sphere(r=stem_radius);
      translate([joint_offset-1,0,0]) sphere(r=stem_radius);
    }
}

// Snap-fit female socket with side entry and spherical bearing seat.
module female_socket(){
  translate([-joint_offset,0,0])
    difference(){
      cylinder(h=socket_height,r=socket_outer_radius);
      // Spherical seat, the intended bearing surface.
      translate([0,0,ball_center_z])
        sphere(r=ball_radius+socket_clearance);
      // Leave a top/bottom hole: no closed roof over the ball.
      translate([0,0,-0.05])
        cylinder(h=socket_height+0.1,r=socket_top_hole_radius);
      // Narrow throat, flared outward for additional horizontal swing.
      // Mouth faces left, toward the preceding segment's ball.
      linear_extrude(height=socket_height+0.2)
        translate([0,0,0])
          polygon(points=[
            [-socket_outer_radius-2,-5.5],
            [-socket_outer_radius+0.6,-3.7],
            [-3.1,-mouth_half_width],
            [0.3,-mouth_half_width],
            [0.3,mouth_half_width],
            [-3.1,mouth_half_width],
            [-socket_outer_radius+0.6,3.7],
            [-socket_outer_radius-2,5.5]
          ]);
    }
}

// Rear connector: solid bridge from the left face of the body to
// the RIGHT side of the female socket. It does not cover the opening.
module female_bridge(){
  translate([0,0,body_height/2])
    hull(){
      translate([-body_length/2+0.6,0,0])
        cube([1.4,4.0,body_height],center=true);
      translate([-joint_offset+socket_outer_radius-0.8,0,0])
        cube([1.2,3.4,body_height],center=true);
    }
}


// Rotate the +X ball and -X socket onto the requested side.
// Port placement preserves the bearing surface and throat geometry.
// Y-side modules are shifted by half the width/length difference so that
// the connector offset from the BODY EDGE equals neighbor_attach.
module placed_port(i,kind) {
  side_angle=[90,0,270,180][i];
  width_correction=(body_width-body_length)/2;
  side_shift= (i==0) ? [0,width_correction,0] :
              (i==2) ? [0,-width_correction,0] : [0,0,0];
  translate(side_shift)
    rotate([0,0,side_angle])
      if(kind=="male") male_ball();
      else if(kind=="female") {
        rotate([0,0,180]) { female_socket(); female_bridge(); }
      }
}

// Position the ball or socket module along the upward Z-axis.
// The +X male and -X female point outward after these rotations.
// The ball's flat lower face is created by the build plane;
// printability and snap insertion on the Z port need physical acceptance.
module placed_top(kind) {
  translate([ball_center_z,0,body_height-body_length/2])
    rotate([0,-90,0])
      if(kind=="male") male_ball();
      else if(kind=="female")
        rotate([0,0,180]) {
          female_socket();
          female_bridge();
        }
}


// Body profiles and decorations around the five-sided joint.
// Shape and decoration predicates used by the Customizer and model assertions.
function valid_shape(s)=s=="Cube"||s=="Cylinder"||s=="Sphere"||s=="Pyramid";
function valid_deco(d)=d=="None"||d=="Letter"||d=="Snake Head"||d=="Shark Head"||d=="Dragon Head";
swedish_alphabet=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
"Q","R","S","T","U","V","W","X","Y","Z","Å","Ä","Ö"];
function valid_letter(c)=len([for(a=swedish_alphabet) if(a==c) 1])==1;
function roof_z(shape)=shape=="Sphere"?body_height+1.0:body_height;

// Builds one of four body envelopes around the joint system.
module body_by_shape(shape) {
  assert(valid_shape(shape));
  if(shape=="Cube") rounded_body();
  else if(shape=="Cylinder")
    scale([body_length/body_width,1,1])
      cylinder(r=body_width/2,h=body_height);
  else if(shape=="Sphere")
    intersection() {
      translate([0,0,body_height*0.48])
        scale([1,body_width/body_length,body_height*0.68/(body_length/2)])
          sphere(r=body_length/2);
      translate([-body_length,-body_width,0])
        cube([2*body_length,2*body_width,body_height*3]);
    }
  else if(shape=="Pyramid")
    hull() {
      translate([0,0,0.12])
        cube([body_length,body_width,0.24],center=true);
      translate([0,0,body_height-0.12])
        cube([body_length*0.38,body_width*0.40,0.24],center=true);
    }
}

// Reinforces connector anchoring where body profiles taper.
module profile_land(i) {
  angle=[90,0,270,180][i];
  delta=(body_width-body_length)/2;
  translate(i==0?[0,delta,0]:i==2?[0,-delta,0]:[0,0,0])
    rotate([0,0,angle])
      hull() {
        translate([body_length/2-3.6,0,body_height/2])
          cube([2.6,3.4,3.3],center=true);
        translate([body_length/2-0.6,0,body_height/2])
          cube([2.3,3.4,3.3],center=true);
      }
}

// Creates an integral attachment land for decorations on the front (+X).
module front_deco_land() {
  hull() {
    translate([body_length/2-4.0,0,body_height/2])
      cube([2.2,3.8,3.5],center=true);
    translate([body_length/2-0.4,0,body_height/2])
      cube([2.4,3.8,3.5],center=true);
  }
}

// Adds a small round mounting platform for top/front decorations.
module decoration_badge(shape,pos) {
  if(pos=="Top")
    translate([0,0,roof_z(shape)-0.90])
      cylinder(r=4.35,h=1.12);
  else {
    front_deco_land();
    translate([body_length/2-0.85,0,body_height/2])
      rotate([0,90,0])
        cylinder(r=body_height/2-0.40,h=1.35);
  }
}

// Stylized snake head constructed from overlapping rounded volumes.
module animal_snake() {
  hull() {
    scale([1,1,0.77]) sphere(r=2.65);
    translate([5.2,0,-0.45])
      scale([1.15,0.78,0.55]) sphere(r=2.10);
  }
  for(s=[-1,1]) {
    translate([2.1,s*1.62,0.85]) sphere(r=0.58);
    translate([6.7,s*0.79,-0.20]) sphere(r=0.27);
  }
}

// Stylized shark head with dorsal fin and eyes.
module animal_shark() {
  hull() {
    scale([1.15,1.08,0.65]) sphere(r=2.80);
    translate([5.8,0,-0.60]) sphere(r=0.80);
  }
  hull() {
    translate([-0.5,0,1.55]) cube([2.7,1.3,0.85],center=true);
    translate([-1.3,0,3.95]) cube([0.36,0.40,0.35],center=true);
  }
  for(s=[-1,1]) translate([2.1,s*2.15,0.38]) sphere(r=0.41);
}

// Stylized dragon head with integrated horns and facial details.
module animal_dragon() {
  hull() {
    scale([1.05,1.10,0.86]) sphere(r=2.80);
    translate([5.35,0,-0.44])
      scale([1.10,0.77,0.62]) sphere(r=2.00);
  }
  for(s=[-1,1]) {
    hull() {
      translate([-0.7,s*1.95,1.05]) sphere(r=0.85);
      translate([-1.5,s*2.55,4.05]) sphere(r=0.20);
    }
    translate([2.30,s*1.73,0.75]) sphere(r=0.46);
    translate([6.32,s*0.75,-0.10]) sphere(r=0.28);
  }
}

// Dispatches the selected animal-head geometry.
module animal_head(kind) {
  if(kind=="Snake Head") animal_snake();
  else if(kind=="Shark Head") animal_shark();
  else if(kind=="Dragon Head") animal_dragon();
}

// Adds letters or animal heads to the body; height/scale control letters only.
module body_decoration(kind,letter,pos,shape) {
  assert(valid_deco(kind));
  assert(pos=="Top" || pos=="Front");
  if(kind=="Letter")
    assert(valid_letter(letter),"Letter: uppercase A-Z, Å, Ä, or Ö.");
  if(kind!="None") {
    if(kind=="Letter") {
      decoration_badge(shape,pos);
      if(pos=="Top")
        translate([0,0,roof_z(shape)+0.12])
          linear_extrude(height=decoration_height)
            scale([decoration_scale,decoration_scale,1])
              text(letter,size=4.7,font="DejaVu Sans:style=Bold",
                halign="center",valign="center");
      else
        translate([body_length/2+0.40,0,body_height/2])
          rotate([90,0,90])
            linear_extrude(height=decoration_height)
              scale([decoration_scale*0.70,decoration_scale*0.70,1])
                text(letter,size=4.7,font="DejaVu Sans:style=Bold",
                  halign="center",valign="center");
    } else if(pos=="Front") {
      front_deco_land();
      translate([body_length/2-1.5,0,body_height/2+0.1])
        animal_head(kind);
    } else {
      decoration_badge(shape,"Top");
      translate([0,0,roof_z(shape)+0.5])
        animal_head(kind);
    }
  }
}

// Port order NORTH, EAST, SOUTH, WEST, TOP.
// Combines one body, selected five connectors and optional decoration.
// Port order: LEFT(+Y), FRONT(+X), RIGHT(-Y), BACK(-X), TOP(+Z).
module C_five_side(ports=["none","male","none","female","none"],
    shape=body_shape,deco=decoration_mode,letter=letter_text,
    deco_position=decoration_position) {
  assert(valid_ports(ports), "Expected five none/male/female ports.");
  assert(valid_shape(shape) && valid_deco(deco));
  assert(deco=="None" || deco_position!="Top" || ports[4]=="none",
    "Top decoration requires top port = none.");
  assert(deco=="None" || deco_position!="Front" || ports[1]=="none",
    "Front decoration requires front port = none.");
  union() {
    body_by_shape(shape);
    if(shape!="Cube")
      for(i=[0:3]) if(ports[i]!="none") profile_land(i);
    for(i=[0:3]) if(ports[i]!="none") placed_port(i,ports[i]);
    if(ports[4]!="none") placed_top(ports[4]);
    body_decoration(deco,letter,deco_position,shape);
  }
}

// Exemplars: one, two, three, four or five independent ports.
// Examples of different male/female port combinations used by gallery mode.
gallery_ports=[
  ["none","none","none","none","male"],
  ["none","none","none","none","female"],
  ["male","female","male","female","male"],
  ["female","female","female","female","female"],
  ["female","male","none","male","female"],
  ["none","female","male","none","male"]
];

top_ball_z=body_height-body_length/2+joint_offset;

// Top-level preview dispatcher: displays the requested test arrangement.
if(view_mode=="single") {
  C_five_side([left,front,right,back,top]);
} else if(view_mode=="shape_gallery") {
  for(i=[0:3]) translate([(i%2)*print_pitch,floor(i/2)*print_pitch,0])
    C_five_side(["none","male","none","female","none"],
      shape=["Cube","Cylinder","Sphere","Pyramid"][i],deco="None");
} else if(view_mode=="decoration_gallery") {
  kinds=["None","Letter","Snake Head","Shark Head","Dragon Head"];
  for(i=[0:4]) translate([(i%3)*print_pitch,floor(i/3)*print_pitch,0])
    C_five_side(["none","none","none","female","none"],
      shape="Cube",deco=kinds[i],letter="Å",
      deco_position=i==1?"Top":"Front");
} else if(view_mode=="alphabet_gallery") {
  for(i=[0:len(swedish_alphabet)-1])
    translate([(i%5)*20,floor(i/5)*20,0])
      C_five_side(["none","none","none","none","none"],
        shape="Cube",deco="Letter",letter=swedish_alphabet[i],
        deco_position="Top");
} else if(view_mode=="gallery") {
  for(i=[0:len(gallery_ports)-1])
    translate([(i%3)*print_pitch,floor(i/3)*print_pitch,0])
      C_five_side(gallery_ports[i],shape="Cube",deco="None");
} else if(view_mode=="pair") {
  C_five_side(["none","male","none","none","none"],shape="Cube",deco="None");
  translate([2*joint_offset,0,0])
    C_five_side(["none","none","none","female","none"],shape="Cube",deco="None");
} else if(view_mode=="print_pair") {
  C_five_side(["none","male","none","none","none"],shape="Cube",deco="None");
  translate([print_pitch,0,0])
    C_five_side(["none","none","none","female","none"],shape="Cube",deco="None");
} else if(view_mode=="top_pair") {
  // Two separate parts facing each other. Mirrored top socket faces down;
  // the two joint center points coincide in this assembly preview.
  C_five_side(["none","none","none","none","male"],shape="Cube",deco="None");
  translate([0,0,2*top_ball_z])
    rotate([0,180,0])
      C_five_side(["none","none","none","none","female"],shape="Cube",deco="None");
} else if(view_mode=="top_print_pair") {
  // Bed layout. Separate parts with both build planes downward.
  C_five_side(["none","none","none","none","male"],shape="Cube",deco="None");
  translate([print_pitch,0,0])
    C_five_side(["none","none","none","none","female"],shape="Cube",deco="None");
}
