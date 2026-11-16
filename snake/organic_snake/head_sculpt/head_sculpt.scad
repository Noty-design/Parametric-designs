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
/* [Sculpt details] */
orbital_depth = 2.1;     // [0.5:0.1:3.0]
brow_height = 1.75;       // [0:0.1:3.0]
eye_size = 1.0;         // [0.7:0.05:1.3]
show_eyes = true;
render_mode = "presentation"; // [presentation,solid]
/* [Mesh] */
longitudinal_steps = 96; // [48:4:120]
per_side_steps = 44;     // [24:2:64]
$fn=36;

// X stations: nose at +48; back cut at -54. These independently control
// dorsal ridge, overall plan width, cheek/jaw, and skull proportions.
skull_width = [
 [-54,16.5],[-46,18.0],[-38,20.5],[-29,23.5],[-20,25.2],[-9,25.3],
 [3,23.8],[13,21.2],[22,18.6],[31,16.3],[38,15.7],[42,15.0],
 [45,13.4],[48,12.4],[51,11.0],[54,8.6],[56.5,5.7],[58,0.2]
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
function clampi(i,n) = max(0,min(n-1,i));
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
function cross_section(x) = let(
 w=curve(skull_width,x)*head_width_scale,
 hi=curve(skull_top,x)*head_height_scale,
 low=curve(skull_bottom,x)*head_height_scale,
 lip=curve(lip_height,x)*head_height_scale,
 muzzle=gaussian((x-31)/15),
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
function eye_r(x,t) = let(dx=(x+8.0)/(8.5*eye_size), dt=(t-3.0+0.17*dx)/(0.86*eye_size))
 sqrt(dx*dx+dt*dt);
// Normal-oriented eye/socket/eyelid relief on the actual lateral skin.
function eye_socket(x,t) = orbital_depth*exp(-pow(eye_r(x,t)/0.88,2.4)) - 1.12*gaussian(eye_r(x,t)/0.42);
function brow_ridge(x,t) = brow_height*gaussian((x+8)/13)*gaussian((t-2.30)/0.39);
function cheek_full(x,t) = 1.20*gaussian((x+8)/18)*gaussian((t-4.18)/0.38);
function nasal_bulge(x,t) = 1.0*gaussian((x-34)/11)*gaussian((t-2.7)/1.1);
function mouth_indent(x,t) = 0.29*gaussian((x-32)/19)*gaussian((t-5.00)/0.073);
function surface_at(x,t,side) = let(
 r=cross_section(x),
 y0=rail_interp(r,t,0),
 z0=rail_interp(r,t,1),
 eye=eye_socket(x,t),
 brow=brow_ridge(x,t),
 cheek=cheek_full(x,t),
 nose=nasal_bulge(x,t)
) [
 x*head_length_scale,
 side*(y0 -eye +brow*.55+cheek*.8 +nose*.25-mouth_indent(x,t)),
 z0 +brow*.70-eye*.26+cheek*.20+nose*.5
];
M=longitudinal_steps;
N=per_side_steps;
R=2*N;
function x_at(i)=-54+(58+54)*i/M;
function skin_vertex(i,j)=let(x=x_at(i))
 j < N ? surface_at(x,8*j/N,1):surface_at(x,8*(2*N-j)/N,-1);
function vertex_index(i,j)=i*R+j;
module head_skin(){
  pts=concat([for(i=[0:M],j=[0:R-1]) skin_vertex(i,j)],
    [[-54*head_length_scale,0,0]],[[58*head_length_scale,0,0]]);
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
  cx=-8.0; ct=3.00; rx=8.2*eye_size; rt=.70*eye_size;
  count=36; rings=4;
  function ept(r,a,d) = let(
    xx=cx+rx*r*cos(a),
    tt=ct+rt*r*sin(a)-0.20*r*cos(a),
    p=surface_at(xx,tt,side)
  ) [p[0],p[1]+side*d,p[2]+0.08];
  // Thin skin-conformal sheet, not part of printable solid.
  c=ept(0,0,.34);
  pp=concat([c],[for(n=[1:rings],i=[0:count-1]) ept(n/rings,i*360/count,.34)]);
  function vid(n,i)=1+(n-1)*count+i;
  tri=concat(
    [for(i=[0:count-1]) [0,vid(1,i),vid(1,(i+1)%count)]],
    [for(n=[1:rings-1],i=[0:count-1]) each [
       [vid(n,i),vid(n+1,i),vid(n+1,(i+1)%count)],
       [vid(n,i),vid(n+1,(i+1)%count),vid(n,(i+1)%count)]
     ]]
  );
  color([0.78,0.77,0.70]) polyhedron(points=pp,faces=side==1?tri:[for(f=tri) [f[0],f[2],f[1]]]);
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
