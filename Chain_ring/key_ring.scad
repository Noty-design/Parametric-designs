include <BOSL2/std.scad>
include <BOSL2/skin.scad>

/* [Ringens mått] */
// Ytterdiameter på nyckelringen.
ring_outer_diameter = 5;       // [5:1:100]
// Diameter på den runda tråden som bildar ringen.
wire_diameter = 1.5;              // [1:0.25:10]
// Antal spiralvarv/loopar i nyckelringen.
loop_count = 1.4;                 // [1:1:5]
// Öppningsvinkel mellan spiralens ändar för att likna en split-ring.
end_gap_angle = 5;             // [5:1:90]
// Extra radialt avstånd mellan varven, som andel av tråddiametern.
loop_clearance_factor = 2.6;   // [0:0.02:0.6]

/* [Utskrifts- och detaljinställningar] */
// Antal punkter per varv längs spiralen.
segments_per_loop = 96;         // [32:8:192]
// Upplösning på trådens runda tvärsnitt.
cross_section_segments = 16;    // [12:4:48]
// Liten platt undersida för stabilare 3D-utskrift.
flat_print_base = true;         // [true,false]
// Hur stor del av tråddiametern som planas av undertill.
base_flatten_amount = 0.1;     // [0:0.02:0.45]

/* [Utseende] */
ring_color = "DarkSlateGray";   // 24
end_cap_color = "SlateGray";    // 24
$fn = 64;

minimum_center_radius = max(0.01, wire_diameter / 2);
loop_pitch = wire_diameter * (1 + loop_clearance_factor);
required_radial_width = wire_diameter + max(0, loop_count - 1) * loop_pitch;
usable_outer_radius = max(ring_outer_diameter / 2 - wire_diameter / 2, minimum_center_radius + required_radial_width);
inner_center_radius = max(minimum_center_radius, usable_outer_radius - max(0, loop_count - 1) * loop_pitch);
actual_outer_diameter = 2 * (usable_outer_radius + wire_diameter / 2);
spiral_degrees = max(90, loop_count * 360 - end_gap_angle);
spiral_steps = max(16, ceil(segments_per_loop * spiral_degrees / 360));

keyring_model();

module keyring_model() {
    if (flat_print_base) {
        difference() {
            keyring_body();
            translate([0, 0, -wire_diameter / 2 - wire_diameter * base_flatten_amount - 0.5])
                cube([actual_outer_diameter + wire_diameter * 4, actual_outer_diameter + wire_diameter * 4, wire_diameter], center=true);
        }
    } else {
        keyring_body();
    }
}

module keyring_body() {
    union() {
        color(ring_color)
            path_sweep(circle_points(d=wire_diameter, n=cross_section_segments), spiral_path_points(), closed=false, method="natural");
        color(end_cap_color) {
            translate(spiral_point(0)) sphere(d=wire_diameter, $fn=cross_section_segments);
            translate(spiral_point(spiral_steps)) sphere(d=wire_diameter, $fn=cross_section_segments);
        }
    }
}

function spiral_radius(step_index) =
    inner_center_radius + (usable_outer_radius - inner_center_radius) * step_index / spiral_steps;

function spiral_angle(step_index) =
    -spiral_degrees / 2 + spiral_degrees * step_index / spiral_steps;

function spiral_point(step_index) =
    let(angle_value = spiral_angle(step_index), radius_value = spiral_radius(step_index))
    [radius_value * cos(angle_value), radius_value * sin(angle_value), 0];

function spiral_path_points() =
    [for (step_index = [0:spiral_steps]) spiral_point(step_index)];

function circle_points(d=1, n=24) =
    [for (point_index = [0:n-1])
        let(angle_value = 360 * point_index / n)
        [d / 2 * cos(angle_value), d / 2 * sin(angle_value)]
    ];
