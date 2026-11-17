/* ============================================================================
  Organic Snake — head sculpt, multi-rail anatomical skin
  Designed by Notydesign | CC BY-NC-SA 4.0
  Source: https://github.com/Noty-design/Parametric-designs
  DESCRIPTION
  Standalone head; no links or body. Independent 3D rails define the cranial
  dome, orbital brow, cheek, upper lip, lower jaw and chin. A piecewise cubic
  spatial skin interpolates these rails: NOT an elliptical radial sweep.
  X positive points to rounded nose, Z positive up; dimensions mm.
  License: https://creativecommons.org/licenses/by-nc-sa/4.0/
============================================================================ */
/* [Head proportions] */
head_length_scale = 1.00; // [0.85:0.05:1.20]
head_width_scale = 1.00;  // [0.80:0.05:1.25]
head_height_scale = 1.00; // [0.80:0.05:1.25]
// Shortens the muzzle without reversing any profile stations. 1 = original length.
snout_length_ratio = 0.63; // [0.55:0.02:1.00]
// Tip station may be shortened without changing eye and skull proportions.
// This avoids a needle-like snout while preserving the skull rails.
nose_tip_station = 49.0; // [47:0.5:58]
// Length of the rounded tip in original (uncompressed) X coordinates.
nose_rounding_mm = 16.0; // [10:0.5:18]
// Round the muzzle without changing the eye or rear cranial anatomy.
nose_profile_softness = 1.0; // [0:0.05:1]
nose_blend_start = 16.0; // [8:1:25]
/* [Sculpt details] */
orbital_depth = 1.70;     // [0.5:0.1:3.0]
brow_height = 1.52;       // [0:0.1:3.0]
eye_size = 1.0;         // [0.7:0.05:1.3]
show_eyes = true;
render_mode = "presentation"; // [presentation,solid]
/* [Mesh] */
longitudinal_steps = 116; // [48:4:120]
per_side_steps = 48;     // [24:2:64]
$fn=36;

// Profile coordinates: original nose station +58, back cut -54. These independently control
// dorsal ridge, overall plan width, cheek/jaw, and skull proportions.
skull_width = [
 [-54,16.5],[-46,18.0],[-38,20.5],[-29,23.5],[-20,25.2],[-9,25.3],
 [3,23.8],[13,21.2],[22,19.1],[31,17.6],[38,16.4],[42,15.2],
 [45,14.2],[48,13.2],[51,11.7],[54,9.5],[56.5,6.3],[58,0.2]
];
skull_top = [
 [-54,15.8],[-46,17.5],[-38,20.2],[-29,23.3],[-20,25.5],[-9,25.0],
 [3,21.9],[13,18.4],[22,14.2],[31,10.9],[38,8.5],[43,7.8],
 [46,7.0],[51,6.1],[54,5.5],[56.5,3.7],[58,0.1]
];
skull_bottom = [
 [-54,-10.2],[-46,-11.2],[-38,-12.7],[-29,-13.7],[-20,-14.1],[-9,-13.7],
 [3,-12.4],[13,-11.3],[22,-9.9],[31,-8.3],[38,-6.6],[43,-5.5],
 [46,-5.0],[51,-4.5],[54,-4.0],[56.5,-2.6],[58,-0.2]
];
lip_height = [
 [-54,-0.8],[-38,-1.3],[-24,-1.7],[-10,-1.9],[3,-2.1],
 [16,-2.5],[28,-2.2],[39,-1.7],[44,-1.2],[51,-0.85],[56,-0.45],[58,0]
];
function clamp(v,a,b) = max(a,min(b,v));
function gaussian(v) = exp(-v*v);
function seg(a,x,i=0) = i >= len(a)-2 ? len(a)-2 : x < a[i+1][0] ? i : seg(a,x,i+1);
function slope(a,k) = k <= 0 ? (a[1][1]-a[0][1])/(a[1][0]-a[0][0]) :
  k >= len(a)-1 ? (a[len(a)-1][1]-a[len(a)-2][1])/(a[len(a)-1][0]-a[len(a)-2][0]) :
  (a[k+1][1]-a[k-1][1])/(a[k+1][0]-a[k-1][0]);
function curve(a,x) = let(i=seg(a,x),h=a[i+1][0]-a[i][0],t=clamp((x-a[i][0])/h,0,1))
 (2*t*t*t-3*t*t+1)*a[i][1]+(t*t*t-2*t*t+t)*h*slope(a,i)
 +(-2*t*t*t+3*t*t)*a[i+1][1]+(t*t*t-t*t)*h*slope(a,i+1);
function catmull(p0,p1,p2,p3,t) = 0.5*((2*p1)+(-p0+p2)*t+(2*p0-5*p1+4*p2-p3)*t*t+(-p0+3*p1-3*p2+p3)*t*t*t);
function rail_interp(pts,t,k) = let(i=min(len(pts)-2,floor(t)),f=t-i)
 catmull(pts[max(0,i-1)][k],pts[i][k],pts[i+1][k],pts[min(len(pts)-1,i+2)][k],f);
// Ellipsoidal rounding of the tip instead of collapsing width and height linearly.
function nose_cap_start()=nose_tip_station-nose_rounding_mm;
function cap_progress(x)=clamp((x-nose_cap_start())/nose_rounding_mm,0,1);
// Independent 3D rails for the unrounded head and muzzle transition.
function cranial_section(x) = let(
 w=curve(skull_width,x)*head_width_scale,
 hi=curve(skull_top,x)*head_height_scale,
 low=(curve(skull_bottom,x)+1.0*gaussian((x-5)/30))*head_height_scale,
 lip=curve(lip_height,x)*head_height_scale,
 cranium=gaussian((x+19)/22),
 cheek=gaussian((x-2)/22),
 bridge=gaussian((x-24)/19)
) [
 [0,hi+1.1*bridge],                              // 0 crown centre
 [w*.49, hi*.93 + 0.4*cranium+0.9*bridge],        // 1 frontonasal plane
 [w*.76, hi*.69 + 1.6*cranium],                   // 2 supraorbital ridge
 [w*.88, lip+(hi-lip)*.45+1.8*cheek*clamp(w/13,0,1)],             // 3 eye socket / cheekbone
 [w*1.00, lip+(3.4+0.8*cheek)*clamp(w/13,0,1)],                     // 4 cheek prominence
 [w*.97, lip],                                    // 5 upper jaw edge
 [w*.82, lip+(low-lip)*.41],                      // 6 lower jaw side
 [w*.56, lip+(low-lip)*.84],                      // 7 mandible curve
 [0,low]                                          // 8 chin centre
];
// Anatomical cranial rails are unchanged behind the muzzle. From the bridge
// forward, gradually round the lateral cheek and lip into a single nasal shell.
function nose_section_blend(x) = let(u=clamp((x-nose_blend_start)/(nose_cap_start()-nose_blend_start),0,1))
 nose_profile_softness*u*u*(3-2*u);
function mix(a,b,u) = a*(1-u)+b*u;
function oval_muzzle(x) = let(
 w=curve(skull_width,x)*head_width_scale,
 hi=curve(skull_top,x)*head_height_scale,
 low=(curve(skull_bottom,x)+1.0*gaussian((x-5)/30))*head_height_scale,
 h=hi-low, mid=(hi+low)/2,
 bridge=1.1*gaussian((x-24)/19)
 ) [
 [0,hi+bridge],
 [w*.50,hi+bridge-h*.06],
 [w*.79,hi-h*.19],
 [w*.96,hi-h*.37],
 [w*1.00,mid+h*.02],
 [w*.92,low+h*.34],
 [w*.75,low+h*.15],
 [w*.44,low+h*.035],
 [0,low]
 ];
function cross_section(x) = let(a=cranial_section(x),b=oval_muzzle(x),q=nose_section_blend(x))
 [for (k=[0:8]) [mix(a[k][0],b[k][0],q),mix(a[k][1],b[k][1],q)]];
function eye_r(x,t) = let(dx=(x-(-1.50))/(10.20*eye_size),
  taper=max(0.54, 1-0.48*pow(abs(dx),1.8)),
  dt=(t-3.00+0.20*dx)/(0.65*eye_size*taper))
 sqrt(dx*dx+dt*dt);
// Normal-oriented eye/socket/eyelid relief on the actual lateral skin.
function eye_socket(x,t) = orbital_depth*exp(-pow(eye_r(x,t)/0.93,2.2)) - 0.80*gaussian(eye_r(x,t)/0.47);
function brow_ridge(x,t) = brow_height*gaussian((x-(-1.50))/14)*gaussian((t-2.42)/0.52);
function cheek_full(x,t) = 1.24*gaussian((x-(-1.50))/19)*gaussian((t-4.18)/0.46);
function nasal_bulge(x,t) = 1.0*gaussian((x-34)/11)*gaussian((t-2.7)/1.1);
function mouth_indent(x,t) = 0.2*gaussian((x-32)/19)*gaussian((t-5.00)/0.073);
function anatomical_surface_at(x,t,side) = let(
 r=cross_section(x),
 y0=rail_interp(r,t,0),
 z0=rail_interp(r,t,1),
 eye=eye_socket(x,t),
 brow=brow_ridge(x,t),
 cheek=cheek_full(x,t),
 nose=nasal_bulge(x,t)
) [
 body_x(x)*head_length_scale,
 side*(y0 -eye +brow*.55+cheek*.8 +nose*.25-mouth_indent(x,t)),
 z0 +brow*.70-eye*.26+cheek*.20+nose*.5
];

// The nasal tip is a *single anatomical surface*, not an inset oval ring.
// Match the tangent of each 3D rail at the joining station (C1 transition),
// then shrink its transverse dimensions continuously to the rounded apex.
function nose_center_z() =
 let(c=nose_cap_start()) (anatomical_surface_at(c,0,1)[2] + anatomical_surface_at(c,8,1)[2])/2;
function surface_at(x,t,side) = x <= nose_cap_start() ?
 anatomical_surface_at(x,t,side) : let(
  a=nose_cap_start(), u=cap_progress(x), L=nose_rounding_mm,
  p=anatomical_surface_at(a,t,side),
  pm=anatomical_surface_at(a-0.30,t,side),
  r=max(0.018,sqrt(max(0,1-u*u))),
  deriv_y=(p[1]-pm[1])/0.30,
  deriv_z=(p[2]-pm[2])/0.30,
  tangent=L*u*pow(1-u,2),
  zc=nose_center_z()
 ) [
  body_x(x)*head_length_scale,
  p[1]*r + deriv_y*tangent,
  zc+(p[2]-zc)*r + deriv_z*tangent
 ];
M=longitudinal_steps;
N=per_side_steps;
R=2*N;
// Adaptively sample the nasal rounding: finer longitudinal rings near the tip.
function x_at(i)=let(u=i/M, transition=0.71, neck=nose_tip_station-14)
 u<=transition ? -54+(neck+54)*(u/transition)
 : neck+(nose_tip_station-neck)*((u-transition)/(1-transition));
function body_x(x) = x <= 15 ? x : 15 + (x-15)*snout_length_ratio;

// Guard against accidentally reversing or duplicating X control stations.
function strictly_ascending(a) = min([for (k=[0:len(a)-2]) a[k+1][0]-a[k][0]]) > 0;
assert(nose_cap_start() > nose_blend_start+2, "Nose blending needs positive rail length.");
assert(strictly_ascending(skull_width) && strictly_ascending(skull_top)
  && strictly_ascending(skull_bottom) && strictly_ascending(lip_height),
  "X coordinates in all profile arrays must increase strictly.");
function skin_vertex(i,j)=let(x=x_at(i))
 j < N ? surface_at(x,8*j/N,1):surface_at(x,8*(2*N-j)/N,-1);
function vertex_index(i,j)=i*R+j;
module head_skin(){
  pts=concat([for(i=[0:M],j=[0:R-1]) skin_vertex(i,j)],
    [[-54*head_length_scale,0,0]],[[body_x(nose_tip_station)*head_length_scale,0,nose_center_z()]]);
  cap0=(M+1)*R; cap1=cap0+1;
  faces=concat(
    [for(i=[0:M-1],j=[0:R-1]) each [
      [vertex_index(i,j),vertex_index(i+1,j),vertex_index(i+1,(j+1)%R)],
      [vertex_index(i,j),vertex_index(i+1,(j+1)%R),vertex_index(i,(j+1)%R)]
    ]],
    [for(j=[0:R-1]) [cap0,vertex_index(0,j),vertex_index(0,(j+1)%R)]],
    [for(j=[0:R-1]) [cap1,vertex_index(M,(j+1)%R),vertex_index(M,j)]]
  );
  polyhedron(points=pts,faces=[for(f=faces) [f[0],f[2],f[1]]],convexity=10);
}
// Pearl-ivory inner eye: an inset almond, not a black painted hole.
// Presentation color solids are omitted in render_mode=solid for a one-part STL.
module eye_inset(side=1){
  cx=-1.50; ct=3.00; rx=9.38*eye_size; rt=0.53*eye_size;
  count=36; rings=4;
  function ept(r,a,d) = let(
    xx=cx+rx*r*cos(a),
    tt=ct+rt*r*sin(a)*(1-0.46*pow(abs(cos(a)),1.5))-0.20*r*cos(a),
    p=surface_at(xx,tt,side)
  ) [p[0],p[1]+side*d,p[2]+0.04];
  // Thin skin-conformal sheet, not part of printable solid.
  c=ept(0,0,.28);
  pp=concat([c],[for(n=[1:rings],i=[0:count-1]) ept(n/rings,i*360/count,.28)]);
  function vid(n,i)=1+(n-1)*count+i;
  tri=concat(
    [for(i=[0:count-1]) [0,vid(1,i),vid(1,(i+1)%count)]],
    [for(n=[1:rings-1],i=[0:count-1]) each [
       [vid(n,i),vid(n+1,i),vid(n+1,(i+1)%count)],
       [vid(n,i),vid(n+1,(i+1)%count),vid(n,(i+1)%count)]
     ]]
  );
  color([0.82,0.81,0.76]) polyhedron(points=pp,faces=side==1?tri:[for(f=tri) [f[0],f[2],f[1]]]);
}
module nostril_mark(side=1) {
 color([0.46,0.42,0.34])
 translate(surface_at(37,3.6,side))
 scale([0.85,0.38,0.28])sphere(r=1,$fn=20);
}
color([0.92,0.89,0.82]) head_skin();
if(render_mode=="presentation"){
  if(show_eyes) for(side=[-1,1]) eye_inset(side);
  for(side=[-1,1]) nostril_mark(side);
}
