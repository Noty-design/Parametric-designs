/* ==========================================================================

   Parametric Modular Snap-Fit Cylindrical Hinge (D)
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   Reusable cylindrical snap-fit hinge with a shaft supported at both ends.
   The cube body is optional. without it the male and female carriers can be 
   used to mount to other models. Just export as STL and assamble with the 
   other model in the slicer. 

   COORDINATES AND UNITS
   ---------------------
   Dimensions in millimetres; angles in degrees. In Array mode, the shaft
   runs along local Y. The Five Sides cube is centred at the origin:
   Front +X, Back -X, Left +Y, Right -Y and Top +Z.
   ========================================================================== */

/* [Layout] */
// Five Sides: independently configurable connectors on five faces.
// Array: multiple hinge stations evenly distributed along a common axis.
layout_mode = "Five Sides"; // [Five Sides, Array]
// Set all faces alike, or choose Custom to configure them individually.
all_sides = "Custom"; // [Custom, None, Male, Female]
/* [Connections (Five Sides)] */
front = "female"; // [none, male, female]
back = "male"; // [none, male, female]
left = "male"; // [none, male, female]
right = "none"; // [none, male, female]
top = "none"; // [none, male, female]
/* [Hinge configuration] */
// Array view/export choice; Five Sides displays the selected face ports.
view_mode = "Assembly"; // [Male, Female, Assembly, Print Male, Print Female]
// Array shaft orientation; in Five Sides this sets the lateral-port axes.
// The Top port always has a horizontal bending axis.
hinge_axis = "Horizontal"; // [Horizontal, Vertical]
// Array: one shaft per station, or one continuous shaft across the array.
// In Five Sides each face has an independent shaft.
shaft_mode = "Separate"; // [Separate, Continuous]
// Five Sides: one central cube. Array: an optional cube on each carrier.
// Disable to use standalone hinge mounting features in another model.
include_cube_body = true; // [false, true]

/* [Station distribution] */
// Width of ONE station along its shaft. In Five Sides mode this is
// the width of EACH port; count and total_width are Array-only.
link_width = 10; // [6:0.5:40]
// Number of stations, in Array mode only.
link_count = 5; // [1:1:30]
// Array mode: OUTSIDE width from the first hinge station's outer face (Y=0)
// to the last hinge station's outer face (Y=total_width).
// Five 10 mm stations over 200 mm -> centres at 5, 52.5, 100, 147.5, 195.
// For one station, only link_width determines its width.
total_width = 200; // [0:1:400]

/* [Joint dimensions] */
shaft_radius = 2.6; // [1.5:0.1:6]
socket_outer_radius = 4.8; // [3.5:0.1:10]
// Narrower than shaft radius so the C-ring retains the pin.
mouth_half_width = 2.32; // [1:0.05:5]
// Thickness of each outer male supporting arm along the shaft.
fork_arm_thickness = 1.1; // [0.8:0.1:3]
// Gap between fork inner faces and the female bearing ends.
axial_end_gap = 0.2; // [0.1:0.05:0.6]
// Outer fork boss radius provides axial end retention.
fork_end_radius = 3.6; // [2.5:0.1:8]
// Spacing measured radially between shaft and socket bore.
joint_fit = "Loose"; // [Firm, Loose, Very Loose]

/* [Mount and optional cube] */
// From shaft centre to mounting-bar centre along X.
mount_offset = 7.2;
mount_bar_thickness = 2.4;
mount_bar_height = 6.5;
// Array mode: cube projects away from the hinge.
// Five Sides mode: a single central cube has dimensions
// [cube_length, link_width, cube_height]; mount rails overlap its faces.
cube_length = 12;
cube_height = 7;
// Used only by the Array Assembly preview; rotates around the shaft.
assembly_angle = 0; // [-90:5:90]

/* [Quality] */
resolution = 64; // [32:16:128]
$fn = resolution;

/* [Hidden] */
eps = 0.02;
function radial_gap(fit) =
    fit == "Firm" ? -0.02 :
    fit == "Loose" ? 0.16 :
    fit == "Very Loose" ? 0.32 : undef;
radial_clearance = radial_gap(joint_fit);
function bearing_start() = fork_arm_thickness + axial_end_gap;
function bearing_width() = link_width-2*bearing_start();

assert(!is_undef(radial_clearance), "Joint fit must be Firm/Loose/Very Loose.");
assert(hinge_axis=="Horizontal" || hinge_axis=="Vertical");
assert(layout_mode=="Array" || layout_mode=="Five Sides", "Choose Array or Five Sides.");
assert(all_sides=="Custom" || all_sides=="None" || all_sides=="Male" || all_sides=="Female");
function valid_side(v) = v=="none" || v=="male" || v=="female";
assert(valid_side(front) && valid_side(back) && valid_side(left) && valid_side(right) && valid_side(top));
assert(shaft_mode=="Separate" || shaft_mode=="Continuous");
assert(link_count>=1 && link_count<=30 && floor(link_count)==link_count);
assert(link_width>=6 && bearing_width()>=3, "Increase link_width for the bearing.");
assert(total_width>=0);
assert(layout_mode!="Array" || link_count==1 ||
  total_width>=link_count*link_width+(link_count-1)*0.5,
  "Total Width must fit all stations plus >= 0.5 mm between neighbours.");
assert(shaft_radius>1);
assert(socket_outer_radius>shaft_radius + max(radial_clearance,0) + 1.1);
assert(mouth_half_width<shaft_radius-0.20 && mouth_half_width>0,
  "C-mouth must be narrower than shaft radius.");
assert(fork_end_radius > shaft_radius+max(radial_clearance,0)+0.4);
assert(fork_end_radius < socket_outer_radius-0.5);
assert(fork_arm_thickness>=0.8 && axial_end_gap>=0.1);
assert(mount_offset>=socket_outer_radius+1.6,
  "Mount bar must clear the C-bearing.");
assert(cube_length>2 && cube_height>=4 && mount_bar_height>=4);
assert(abs(assembly_angle)<=90);

// Orient Y shaft along Z when the vertical variant is selected.
module assembled_pose() {
  if(hinge_axis=="Vertical") rotate([90,0,0]) children();
  else children();
}

// Centred cylinders oriented along the hinge (Y) axis.
module y_cylinder(r,length,cy=0) {
  translate([0,cy,0]) rotate([90,0,0]) cylinder(r=r,h=length,center=true);
}

// A stand-alone male mounting rail; always connects both end supports.
module male_rail(cy) {
  translate([-mount_offset,cy,0])
    cube([mount_bar_thickness,link_width,mount_bar_height],center=true);
}

// End support at each station endpoint: the arc-shaped end boss and
// short radial arm are joined by a solid hull; no central neck exists.
module male_fork_arm(cy) {
  hull() {
    translate([-mount_offset,cy,0])
      cube([mount_bar_thickness, fork_arm_thickness, mount_bar_height],center=true);
    y_cylinder(fork_end_radius,fork_arm_thickness,cy);
  }
}

module male_fork_station(cy, with_cube=include_cube_body) {
  male_rail(cy);
  male_fork_arm(cy-link_width/2+fork_arm_thickness/2);
  male_fork_arm(cy+link_width/2-fork_arm_thickness/2);
  if(shaft_mode=="Separate")
    y_cylinder(shaft_radius,link_width,cy);
  if(with_cube)
    translate([-mount_offset-mount_bar_thickness/2-cube_length/2+0.1,cy,0])
      cube([cube_length,link_width,cube_height],center=true);
}

// Continuous spindle covers Y=0 through Y=total_width for multiple
// stations. For a single station it spans just link_width (Y=0..link_width).
// n=1 is also used to create one independent port on a selected face.
module D_male_array(with_cube=include_cube_body, n=link_count, span=total_width) {
  len_y = n==1 ? link_width : span;
  union() {
    if(shaft_mode=="Continuous")
      y_cylinder(shaft_radius,len_y,len_y/2);
    for(i=[0:n-1])
      male_fork_station(link_width/2 + (n==1 ? 0 : i*(span-link_width)/(n-1)),with_cube);
  }
}

// Female slit goes to X<0, toward the male mounting rail.
module female_bearing(cy) {
  translate([0,cy,0])
    difference() {
      y_cylinder(socket_outer_radius,bearing_width());
      y_cylinder(shaft_radius+radial_clearance,bearing_width()+2*eps);
      // Open C-shaped throat, flared toward -X. A uniform mouth between
      // the two lips avoids a central male neck cutting into rotation.
      rotate([90,0,0])
        linear_extrude(height=bearing_width()+2*eps,center=true)
          polygon(points=[
            [-socket_outer_radius-2.0,-socket_outer_radius-0.8],
            [-socket_outer_radius+0.3,-socket_outer_radius-0.3],
            [-shaft_radius*0.65,-mouth_half_width],
            [0.30,-mouth_half_width],
            [0.30,mouth_half_width],
            [-shaft_radius*0.65,mouth_half_width],
            [-socket_outer_radius+0.3,socket_outer_radius+0.3],
            [-socket_outer_radius-2.0,socket_outer_radius+0.8]
          ]);
    }
}

module female_mount(cy, with_cube=include_cube_body) {
  // The full-width mounting rail makes the socket usable without a cube.
  translate([mount_offset,cy,0])
    cube([mount_bar_thickness,link_width,mount_bar_height],center=true);
  // One centred web supports the open socket behind its bore. The web
  // is separated from the running surface of the cylindrical axle.
  hull() {
    translate([mount_offset,cy,0])
      cube([mount_bar_thickness,bearing_width(),mount_bar_height],center=true);
    translate([socket_outer_radius-0.35,cy,0])
      cube([0.9,bearing_width(),3.0],center=true);
  }
  if(with_cube)
    translate([mount_offset+mount_bar_thickness/2+cube_length/2-0.1,cy,0])
      cube([cube_length,link_width,cube_height],center=true);
}

module D_female_array(with_cube=include_cube_body, n=link_count, span=total_width) {
  union() {
    for(i=[0:n-1]) {
      cy=link_width/2 + (n==1 ? 0 : i*(span-link_width)/(n-1));
      female_bearing(cy);
      female_mount(cy,with_cube);
    }
  }
}

// For assemblies the two separately printable parts are OVERLAID around
// the same shaft and must not be exported as a single fused STL.
module D_assembly() {
  D_male_array();
  rotate([0,assembly_angle,0]) D_female_array();
}

// Print pose: station/shaft Y=0 maps to build-plate Z=0;
// the far outer face maps to Z=total_width (or link_width for one station).
module upright_print_pose() {
  rotate([90,0,0]) children();
}

// Face index order: Front (+X), Back (-X), Left (+Y), Right (-Y), Top (+Z).
function selected_side(i) =
  all_sides == "Male" ? "male" :
  all_sides == "Female" ? "female" :
  all_sides == "None" ? "none" :
  [front,back,left,right,top][i];

// Each canonical connector shaft runs along local +Y. For a female port
// we turn its mounting rail (originally on +X) toward the cube (-X);
// this also turns the female snap mouth outward (+X).
module port_geometry(kind, vertical=false) {
  if (kind=="male") {
    if(vertical)
      rotate([90,0,0]) translate([0,-link_width/2,0])
        D_male_array(with_cube=false,n=1,span=link_width);
    else
      translate([0,-link_width/2,0])
        D_male_array(with_cube=false,n=1,span=link_width);
  } else if(kind=="female") {
    if(vertical)
      rotate([90,0,0]) rotate([0,0,180]) translate([0,-link_width/2,0])
        D_female_array(with_cube=false,n=1,span=link_width);
    else
      rotate([0,0,180]) translate([0,-link_width/2,0])
        D_female_array(with_cube=false,n=1,span=link_width);
  }
}

// Horizontal placement yaw makes local +X point outward from each side.
// Local Y is the tangential hinge axis. The 0.60 overlap into the host
// body avoids coplanar-only contact between mounting rails and cube.
module placed_side_port(i,kind) {
  yaw = [0,180,90,-90][i];
  face = i < 2 ? cube_length/2 : link_width/2;
  rotate([0,0,yaw])
    translate([face+mount_offset-0.60,0,0])
      port_geometry(kind,hinge_axis=="Vertical");
}

// Top: +X maps to +Z. Use a horizontal shaft even when lateral ports use
// vertical axes: a +Z-oriented pin would act as a swivel, not a bend hinge.
module placed_top_port(kind) {
  rotate([0,-90,0])
    translate([cube_height/2+mount_offset-0.60,0,0])
      port_geometry(kind,false);
}

// Build one optional central cube and whichever of the five ports are on.
// Without the cube, ports remain separate mounting features. Fuse them to
// another solid before exporting a single combined printable body.
module D_five_side() {
  union() {
    if(include_cube_body)
      cube([cube_length,link_width,cube_height],center=true);
    for(i=[0:3])
      if(selected_side(i)!="none") placed_side_port(i,selected_side(i));
    if(selected_side(4)!="none") placed_top_port(selected_side(4));
  }
}

if(layout_mode=="Five Sides")
  D_five_side();
else if(view_mode=="Male")
  assembled_pose() D_male_array();
else if(view_mode=="Female")
  assembled_pose() D_female_array();
else if(view_mode=="Assembly")
  assembled_pose() D_assembly();
else if(view_mode=="Print Male")
  upright_print_pose() D_male_array();
else if(view_mode=="Print Female")
  upright_print_pose() D_female_array();
