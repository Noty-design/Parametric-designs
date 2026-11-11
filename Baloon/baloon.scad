include <BOSL2/std.scad>

/* [Balloon] */
total_height = 250; // [100:1:350]
balloon_radius = 100; // [35:1:140]
wall_thickness = 1.2; // [0.8:0.2:2.4]
fit_clearance = 0.3; // [0.1:0.05:0.6]
closure_length = 8; // [4:1:9]
upper_height_ratio = 1.05; // [1.05:0.01:1.4]
/* [Crown printing transition] */
// Maximum internal roof angle measured away from vertical.
// Lower values add more material but reduce unsupported layer offsets.
roof_overhang_angle = 49; // [45:1:65]
// Smoothly blend the thin curved shell into the reinforced crown.
transition_blend = 3; // [1:0.5:6]
crown_thickness = 1.6; // [1.2:0.2:3]
/* [Stick socket] */
stick_diameter = 5.5; // [3:0.5:12]
socket_clearance = 0.2; // [0:0.1:0.8]
neck_radius = 10; // [8:1:15]
neck_height = 14; // [10:1:24]
/* [Display] */
layout = "print"; // [print, assembled, exploded, section]
part_spacing = 14; // [5:1:35]
body_color = "#DD0000"; //
lid_color = "#DD0000"; //
curve_steps = 160; // [80:16:240]
$fn = 128;

reference_upper_height = max(upper_height_ratio*balloon_radius,closure_length+fit_clearance+balloon_radius);
reference_lower_height = neck_height+1.12*balloon_radius;
height_scale = total_height/(reference_lower_height+reference_upper_height);
upper_height = reference_upper_height*height_scale;
lower_height = reference_lower_height*height_scale;
actual_neck_height = neck_height*height_scale;
lower_body_height = lower_height-actual_neck_height;
neck_start_angle = asin(neck_radius/balloon_radius);
lower_ellipse_height = lower_body_height/cos(neck_start_angle);
socket_radius = (stick_diameter+socket_clearance)/2;
lip_outer_radius = balloon_radius-wall_thickness-fit_clearance;
lip_inner_radius = lip_outer_radius-wall_thickness;
actual_closure_length = closure_length*height_scale;
roof_slope = tan(roof_overhang_angle);
upper_roof_height = upper_height-max(wall_thickness,crown_thickness);
lower_roof_start = actual_neck_height-wall_thickness;

function unit_vector(vector) = vector/norm(vector);
function smooth_minimum(first,second,blend) = min(first,second)-pow(max(blend-abs(first-second),0),2)/(4*blend);
function upper_point(angle) = [balloon_radius*cos(angle),upper_height*sin(angle)];
function upper_normal(angle) = unit_vector([cos(angle)/balloon_radius,sin(angle)/upper_height]);
function lower_point(angle) = [balloon_radius*sin(angle),lower_height-lower_ellipse_height*cos(angle)];
function lower_normal(angle) = unit_vector([sin(angle)/balloon_radius,-cos(angle)/lower_ellipse_height]);
function upper_inner_point(angle) = let(
    parallel_point=upper_point(angle)-wall_thickness*upper_normal(angle),
    roof_radius=roof_slope*(upper_roof_height-parallel_point[1]))
    [max(0,smooth_minimum(parallel_point[0],roof_radius,transition_blend)),parallel_point[1]];
function lower_inner_point(angle) = let(
    parallel_point=lower_point(angle)-wall_thickness*lower_normal(angle),
    roof_radius=socket_radius+roof_slope*(parallel_point[1]-lower_roof_start))
    [max(socket_radius,smooth_minimum(parallel_point[0],roof_radius,transition_blend)),parallel_point[1]];

upper_outer_curve = [for(index=[0:curve_steps]) upper_point(90*index/curve_steps)];
// Sample only below the inner roof apex, then close on the axis.
upper_inner_curve = concat([for(index=[0:curve_steps]) let(inner_point=upper_inner_point(90*index/curve_steps)) if(inner_point[1]<upper_roof_height && inner_point[0]>0) inner_point],[[0,upper_roof_height]]);
lower_outer_curve = [for(index=[0:curve_steps]) lower_point(neck_start_angle+(90-neck_start_angle)*index/curve_steps)];
lower_inner_curve = [for(index=[0:curve_steps]) lower_inner_point(neck_start_angle+(90-neck_start_angle)*index/curve_steps)];

module lower_shell() {
    union() {
        rotate_extrude(convexity=10)
        polygon(concat(
            [[neck_radius,0],[neck_radius,2],[neck_radius-1,4],[neck_radius-1,actual_neck_height-2]],lower_outer_curve,
            [for(index=[len(lower_inner_curve)-1:-1:0]) lower_inner_curve[index]],
            [[socket_radius,lower_roof_start],[socket_radius,0]]));
        translate([0,0,lower_height]) rotate_extrude(convexity=10)
        polygon([
            [lip_inner_radius,-wall_thickness],
            [balloon_radius-0.2,-wall_thickness],
            [balloon_radius-0.2,-0.2],
            [lip_outer_radius,wall_thickness+fit_clearance],
            [lip_outer_radius,actual_closure_length-0.6],
            [lip_outer_radius-0.3,actual_closure_length],
            [lip_inner_radius,actual_closure_length]
        ]);
    }
}
module upper_shell() {
    rotate_extrude(convexity=10)
    polygon(concat(upper_outer_curve,[for(index=[len(upper_inner_curve)-1:-1:0]) upper_inner_curve[index]]));
}
module assembled_balloon() {
    color(body_color) lower_shell();
    translate([0,0,lower_height+(layout=="exploded" ? 24 : 0)]) color(lid_color) upper_shell();
}
if(layout=="print") {
    translate([-balloon_radius-part_spacing/2,0,lower_height+actual_closure_length])
    rotate([180,0,0]) color(body_color) lower_shell();
    translate([balloon_radius+part_spacing/2,0,0]) color(lid_color) upper_shell();
} else if(layout=="section") {
    difference() {
        assembled_balloon();
        translate([-balloon_radius-5,-balloon_radius-5,-1]) cube([2*balloon_radius+10,balloon_radius+5,total_height+30]);
    }
} else assembled_balloon();
