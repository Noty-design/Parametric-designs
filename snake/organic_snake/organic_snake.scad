/*
Organic Snake - concept sculpt v28 (almond eye refinement)
A single continuous parametric OpenSCAD shell, no links or joints.
Reference: design_references/koncept/ChatGPT Image Nov 13, 2026, 07_32_22 AM-1.png
Dimensions in mm. Straight orientation for morphology acceptance.
*/
$fn=48;
view_mode="body"; // [body,head]
head_width_scale=1.0;  // [0.85:0.05:1.25]
body_width_scale=1.0;  // [0.85:0.05:1.25]
head_height_scale=1.0; // [0.85:0.05:1.25]
eye_depth=2.8; // [0.5:0.1:3.3]
eye_inner_lift=0.14; // [0.2:0.02:0.85]
eye_rim_height=0.34; // [0:0.02:0.6]
// Eye shape directly in longitudinal and vertical millimeter coordinates.
eye_length_radius_mm=8.6; // [6:0.2:13]
eye_vertical_radius_mm=4.7; // [3:0.2:7]
eye_center_height_mm=2.8; // [0:0.2:6] relative to head center
eye_rise_per_mm=0.18; // [-0.2:0.02:0.35] posterior rise
brow_height=0.85; // [0:0.1:2]
curve_amplitude=24; // [0:1:22]
section_step=1.45;
ring_faces=64;
// Station: x, half-width, full height, underside height
profile_source=[
 [-18.0,1.75,4.25,1.48],
 [-17.2,3.65,5.65,1.30],
 [-16.0,4.85,6.60,1.20],
 [-14.5,5.60,7.0,1.14],
 [-12.0,6.30,7.6,1.07],
 [-10.0,6.70,8.0,1.00],
 [-8.5,7.35,8.4,0.96],
 [-5.6,8.25,9.3,0.92],
 [-2.5,9.15,10.1,0.87],
 [1.0,9.95,10.9,0.82],
 [6.0,11.15,12.1,0.77],
 [12.0,12.45,13.9,0.70],
 [19.0,14.00,15.9,0.65],
 [28.0,16.2,19.4,0.60],
 [38.0,17.6,20.6,0.65],
 [48.0,15.8,19.1,0.65],
 [58.0,11.3,16.9,0.70],
 [68.0,10.9,16.0,0.65],
 [80.0,12.5,18.7,0.60],
 [95.0,13.9,21.0,0.65],
 [112.0,14.0,21.6,0.65],
 [132.0,13.4,20.7,0.65],
 [155.0,11.5,18.9,0.70],
 [180.0,9.9,16.8,0.75],
 [208.0,8.0,14.0,0.85],
 [235.0,6.1,11.0,1.05],
 [260.0,4.3,8.0,1.25],
 [284.0,2.7,5.1,1.6],
 [302.0,1.45,3.2,2.5],
 [312.0,0.20,0.75,4.8]
];
// Muzzle length: 0 is exactly v16. Default shortens the nose about 8 mm.
muzzle_shortening_mm=11; // [0:1:12]
function muzzle_map_t(x)=max(0,min(1,(19-x)/37));
function muzzle_map(x)=let(t=muzzle_map_t(x))
  x+muzzle_shortening_mm*(t*t*(3-2*t));
// All body stations at x >= 19 mm are unchanged.
profile=[for(p=profile_source) [muzzle_map(p[0]),p[1],p[2],p[3]]];

function clamp(x,a,b)=max(a,min(b,x));
function find_seg(x,k=0)=k>=len(profile)-2 ? len(profile)-2 :
    x<profile[k+1][0] ? k : find_seg(x,k+1);
function grade(i,j,c)=(profile[j][c]-profile[i][c])/
 (profile[j][0]-profile[i][0]);
function interp(x,c)=let(
 i=find_seg(x),xa=profile[i][0],xb=profile[i+1][0],h=xb-xa,
 t=clamp((x-xa)/h,0,1),
 m0=i==0 ? grade(i,i+1,c) : grade(i-1,i+1,c),
 m1=i==len(profile)-2 ? grade(i,i+1,c) : grade(i,i+2,c))
 (2*t*t*t-3*t*t+1)*profile[i][c]
 +(t*t*t-2*t*t+t)*h*m0
 +(-2*t*t*t+3*t*t)*profile[i+1][c]
 +(t*t*t-t*t)*h*m1;
function angular_dist(a,b)=abs(((a-b+540)%360)-180);
function near_pair(a,l,r)=min(angular_dist(a,l),angular_dist(a,r));
function gaussian(x)=exp(-x*x);
// Vertical oval in physical coordinates: not an angular ring or separate lens.
// Fast eye metric reuses the per-vertex head height and vertical coordinate.
// No recursive section_height/interp call per eye surface evaluation.
function eye_r_fast(x,a,h,vert)=let(
 dz=(h/2)*vert,
 target_z=eye_center_height_mm+(x-23.5)*eye_rise_per_mm,
 side_angle=min(angular_dist(a,0),angular_dist(a,180))
)
 sqrt(pow((x-23.5)/eye_length_radius_mm,2)
   + pow((dz-target_z)/eye_vertical_radius_mm,2)
   + pow(side_angle/75,5));
function eye_relief_r(r)=
    eye_depth*(exp(-pow(r/0.96,2.25))-eye_inner_lift*exp(-pow(r/0.44,2)));
function eye_lip_r(r)=
    eye_rim_height*exp(-pow((r-1.10)/0.44,2));
function brow(x,a)=brow_height*
    gaussian((x-31)/12)*
    gaussian(near_pair(a,49,131)/13);
function nostril(x,a)=0.42*
    gaussian((x-7)/1.9)*
    gaussian(near_pair(a,39,141)/10);
function lip_line(x,a)=0.35*
    gaussian((x-19)/15)*
    gaussian(near_pair(a,330,210)/5.2);
// Fuller, lower cheeks beneath the eyes; never new standalone blobs.
function cheek_rounding(x,a)=2.0*
    gaussian((x-25)/13)*
    gaussian(near_pair(a,325,215)/23);
function head_blend(x)=clamp((72-x)/14,0,1);
function halfwidth(x)=max(0.18,interp(x,1))*
    (x<72?head_width_scale:body_width_scale);
function section_height(x)=max(0.65,interp(x,2))*
    (x<72?head_height_scale:1);
function center_y(x)=curve_amplitude*sin((x+2)*360/300);
function center_y_grad(x)=curve_amplitude*(2*PI/300)*cos((x+2)*360/300);
function elliptic(c,n)=sign(c)*pow(abs(c),2/n);
// These are shallow visual surface creases, NOT functional segments.
show_seams=true;
seam_fraction=0.052;
seam_halfwidth=1.35;
seam_positions=[59,84,110,136,162,187,210,232,252,271,289,301];
function seam_dist(x)=min([for(j=seam_positions) abs(x-j)]);
function seam_gain(x)=show_seams ?
  1-seam_fraction*exp(-pow(seam_dist(x)/seam_halfwidth,2)) : 1;
function surface_pt(x,a)=let(
    h=section_height(x)*seam_gain(x),hw=halfwidth(x)*seam_gain(x),
    n=x<58?2.12:2.0,
    radial=elliptic(cos(a),n),
    vert=elliptic(sin(a),n),
    // Eye effect is exactly negligible outside x=0..50; skip expensive math there.
    eye_metric=(x<0 || x>50) ? 100 : eye_r_fast(x,a,h,vert),
    ed=eye_relief_r(eye_metric),
    er=eye_lip_r(eye_metric),
    bb=brow(x,a),
    dd=nostril(x,a),
    ll=lip_line(x,a),
    yoff=sign(radial)*(er+bb*0.8-ed-dd-ll+cheek_rounding(x,a))*abs(radial),
    ybase=hw*radial+yoff,
    slope=center_y_grad(x),
    norm=sqrt(1+slope*slope),
    z=interp(x,3)+h/2+(h/2)*vert+bb*0.18-er*0.04-ed*0.08)
  [x-(slope/norm)*ybase, center_y(x)+ybase/norm, z];
x_first=profile[0][0];
x_last=profile[len(profile)-1][0];
steps=ceil((x_last-x_first)/section_step);
// Preserve face count while allocating more longitudinal rings to the eye region.
function xv(i)=let(t=i/steps,f=0.30,cut=56)
  t<=f ? x_first+(cut-x_first)*t/f
       : cut+(x_last-cut)*(t-f)/(1-f);
function idx(i,j)=i*ring_faces+j;
// Redistribute vertices around the lateral eye without adding triangles.
// The warp is monotonic and vanishes before the first body seam.
function eye_sample_angle(a,x)=a-13*sin(2*a)*clamp((61-x)/13,0,1);
module skin_mesh() {
 vertices=concat(
  [for(i=[0:steps],j=[0:ring_faces-1])
    surface_pt(xv(i),eye_sample_angle(360*j/ring_faces,xv(i)))],
  [[x_first,center_y(x_first),interp(x_first,3)+section_height(x_first)/2]],
  [[x_last,center_y(x_last),interp(x_last,3)+section_height(x_last)/2]]
 );
 front=(steps+1)*ring_faces;
 rear=front+1;
 faces=concat(
  [for(i=[0:steps-1],j=[0:ring_faces-1]) each [
    [idx(i,j),idx(i,(j+1)%ring_faces),idx(i+1,(j+1)%ring_faces)],
    [idx(i,j),idx(i+1,(j+1)%ring_faces),idx(i+1,j)]
  ]],
  [for(j=[0:ring_faces-1]) [front,idx(0,(j+1)%ring_faces),idx(0,j)]],
  [for(j=[0:ring_faces-1]) [rear,idx(steps,j),idx(steps,(j+1)%ring_faces)]]
 );
 polyhedron(points=vertices,faces=[for(face=faces) [face[0],face[2],face[1]]],convexity=10);
}
// Carve almond-like eye sockets into the lateral head surfaces.
// The cutters are separate shallow indents, not holes or separate objects.
// Local feature alignment follows the body centerline when curve_amplitude changes.
module at_curve(x) {
 translate([x,center_y(x),0])
 rotate([0,0,atan(center_y_grad(x))])
 translate([-x,0,0]) children();
}
// The almond-shaped eye is now sculpted directly into the analytic surface
// using eye_relief/eye_lip. No separate lens or shell penetrations.
module nostril_socket(side=1) {
 // Keep nostrils anchored on the shortened muzzle instead of their old X.
 let(x=muzzle_map(-11))
 at_curve(x)
 translate([x,side*5.8,4.0])
 scale([0.95,1.25,0.55]) sphere(r=1,$fn=40);
}
// A fine, shallow cheek/mouth crease, following the curved shell.
function cheek_z(x)=interp(x,3)+section_height(x)*0.27;
module mouth_crease(side=1){
 for(x=[0:2:36])
  hull(){
   at_curve(x)
   translate([x,side*halfwidth(x)*0.89,cheek_z(x)])
   sphere(r=0.26,$fn=14);
   at_curve(x+2)
   translate([x+2,side*halfwidth(x+2)*0.89,cheek_z(x+2)])
   sphere(r=0.26,$fn=14);
  }
}
module sculpted_body(){
 difference() {
  skin_mesh();
  for(side=[-1,1]) {
   nostril_socket(side);
   mouth_crease(side);
  }
 }
}
if(view_mode=="head")
 intersection() {
  sculpted_body();
  translate([-20,-40,-5])cube([87,80,40]);
 }
else sculpted_body();
