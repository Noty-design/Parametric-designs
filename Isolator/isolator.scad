/* [Kedja] */
// Antal separata isolatorer i kedjan
insulator_count = 1;              // [1:1:20]
// Antal keramiska plattor/skärmar per isolator
plates_per_insulator = 4;         // [1:1:14]
// Mellanrum mellan två isolatorer
insulator_gap = 26;               // [8:1:60]
// Typ av länk mellan isolatorerna
link_style = "half_donuts";       // [full_rings, half_donuts, none]
// Visa halva ändlänkar även längst upp och längst ned på kedjan
show_end_half_links = false;      // [true, false]

/* [Måttvisning] */
// Visa måttlinjer för total höjd och bredd per isolator
dimension_display = "first_insulator"; // [off, first_insulator, all_insulators]
// Avstånd från modellen till måttlinjerna
dimension_offset = 9;             // [3:1:40]
// Textstorlek för måttangivelser
dimension_text_size = 3;          // [1.5:0.5:12]
// Tjocklek på måttlinjerna
_dimension_line_radius = 0.18;    // [0.08:0.02:1]
// Längd på ändmarkeringar/tickar
_dimension_tick_length = 2.5;     // [1:0.5:10]
// Antal decimaler i måtttexten, 0 ger heltal
_dimension_decimals = 1;          // [0:1:2]
// Färg på måttlinjer och måtttext
dimension_color = "DeepSkyBlue";  // 24

/* [Hål för egna länkar] */
// Aktivera genomgående hål i ändbeslagen för egna länkar
custom_link_holes_enabled = true; // [true, false]
// Var hålen ska placeras
custom_link_hole_placement = "chain_ends"; // [chain_ends, every_insulator_end]
// Radie på hålen för egna länkar
custom_link_hole_radius = 1.8;    // [0.8:0.1:8]
// Riktning på hålen sett ovanifrån
custom_link_hole_rotation_z = 0;  // [0:5:175]
// Höjdposition i ändbeslaget, 0.5 är mitt i beslaget
custom_link_hole_cap_position = 0.5; // [0.15:0.05:0.85]
// Extra längd på hålskärningen så hålet säkert går igenom hela beslaget
custom_link_hole_extra_cut = 6;   // [1:1:20]

/* [Rotation av Half Links] */
// Roterar alla Half Links runt X-axeln, så länken kan luta framåt/bakåt längs bågen
half_link_rotation_x = 0;         // [-90:5:90]
// Roterar alla Half Links runt Y-axeln, så länken kan luta åt sidan längs bågen
half_link_rotation_y = 0;         // [-90:5:90]
// Roterar alla Half Links runt kedjans centrumaxel
half_link_rotation_z = 0;         // [0:5:355]
// Extra Z-rotation per isolator, praktiskt för spiralvriden kedja
half_link_rotation_step_per_insulator = 0; // [-90:5:90]
// Extra X-rotation för den nedre halvlänken på varje isolator
lower_half_link_extra_rotation_x = 0; // [-90:5:90]
// Extra Y-rotation för den nedre halvlänken på varje isolator
lower_half_link_extra_rotation_y = 0; // [-90:5:90]
// Extra Z-rotation för den nedre halvlänken på varje isolator
lower_half_link_extra_rotation_z = 0; // [-180:5:180]
// Extra X-rotation för den övre halvlänken på varje isolator
upper_half_link_extra_rotation_x = 0; // [-90:5:90]
// Extra Y-rotation för den övre halvlänken på varje isolator
upper_half_link_extra_rotation_y = 0; // [-90:5:90]
// Extra Z-rotation för den övre halvlänken på varje isolator
upper_half_link_extra_rotation_z = 0; // [-180:5:180]

/* [Keramiska isolatorplattor] */
// Ytterradie på varje isolatorplatta
plate_outer_radius = 4;           // [4:1:70]
// Radie på den centrala keramiska kroppen
plate_neck_radius = 2;            // [2:1:28]
// Tjocklek på plattans ytterkant
plate_rim_thickness = 1;          // [1:0.5:9]
// Total höjd på varje keramisk platta
plate_height = 2;                 // [3:1:24]
// Avstånd mellan plattornas centrum inom en isolator
plate_spacing = 3;                // [4:1:28]
// Rundad pärla längs ytterkanten. Används bara när support_friendly_plates=false.
edge_bead_radius = 0.5;           // [0.4:0.1:4]
// Gör plattorna mer självbärande för FDM-utskrift utan stöd
support_friendly_plates = true;   // [true, false]
// Maximal radieökning per mm höjd på undersidan, 1.0 motsvarar ungefär 45 grader
plate_underside_slope = 1.0;      // [0.4:0.1:1.4]
// Hur rund/konvex skivan blir uppåt. Högre värde ger mjukare kupning.
plate_upward_rounding = 1.45;     // [0.8:0.05:2.5]
// Hur djupt V-/konformen går från ytterkant ned mot mitten
plate_cone_depth = 1.65;          // [0.4:0.05:12]
// Rundning i övergången mellan kon, hals och ytterkant
plate_cone_rounding = 0.22;       // [0:0.02:2]
// Tjocklek på den plana ytterkanten i supportvänligt läge
plate_support_rim_thickness = 0.55; // [0.1:0.05:4]
// Kurvning på undersidans skål. Högre värde ger mer urgröpt/mjuk skål.
plate_bowl_curve = 1.65;          // [0.7:0.05:3]
// Hur mycket skålen är uppfylld: 0 är djup/tom skål, 1 är nästan platt ovansida
plate_bowl_fill = 0.12;           // [0:0.02:1]
// Antal punkter i den rundade rotationsprofilen
plate_profile_steps = 10;         // [5:1:24]

/* [Metallbeslag] */
// Radie på den genomgående centrumstaven
center_rod_radius = 2;            // [1.5:0.1:10]
// Radie på ändbeslagen
end_cap_radius = 3;               // [5:1:30]
// Höjd på varje ändbeslag
end_cap_height = 4;               // [3:1:22]
// Radie på den utstickande tappen ovanför/under ändbeslaget
end_terminal_radius = 2.7;        // [0.8:0.1:20]
// Synlig höjd på den utstickande tappen ovanför/under ändbeslaget
end_terminal_height = 2;          // [0.2:0.1:30]
// Extra överlapp mellan delar så modellen blir sammanhängande
connection_overlap = 1;           // [0.2:0.1:5]

/* [Länkar] */
// Radie till centrumlinjen i länkringen/halvdonuten
link_ring_radius = 3;             // [5:1:40]
// Godstjocklek på länkarna
link_ring_thickness = 2;          // [1:0.2:10]
// Överlappsvinkel där två halvdonuts möts, ger bättre sammanfogning
half_link_overlap_angle = 8;      // [0:1:24]
// Radie på små förstärkningsnabbar där halvdonuten möter ändbeslaget
link_lug_radius = 2;              // [2:0.2:12]

/* [Utskrift och färg] */
// Fragmentupplösning för runda former
curve_resolution = 72;            // [24:12:144]
ceramic_color = "Ivory";          // 24
metal_color = "DimGray";          // 24
link_color = "SlateGray";         // 24

$fn = curve_resolution;

ceramic_stack_height = (plates_per_insulator - 1) * plate_spacing + plate_height;
unit_height = ceramic_stack_height + 2 * end_cap_height;
unit_pitch = unit_height + insulator_gap;
body_chain_height = insulator_count * unit_height + (insulator_count - 1) * insulator_gap;
insulator_visual_radius = max(plate_outer_radius + edge_bead_radius, end_cap_radius * 1.08, link_style == "none" ? 0 : link_ring_radius + link_ring_thickness);
insulator_visual_width = insulator_visual_radius * 2;

dimension_text_height_string = str("H ", rounded_value(unit_height), " mm");
dimension_text_width_string = str("B ", rounded_value(insulator_visual_width), " mm");

union() {
    isolator_chain();
    if (dimension_display != "off")
        dimension_annotations();
}

function rounded_value(value) =
    _dimension_decimals == 0 ? round(value) :
    _dimension_decimals == 1 ? round(value * 10) / 10 :
    round(value * 100) / 100;

module isolator_chain() {
    translate([0, 0, -body_chain_height / 2])
    difference() {
        union() {
            for (insulator_index = [0 : insulator_count - 1]) {
                translate([0, 0, insulator_index * unit_pitch])
                    single_insulator(insulator_index);
            }

            if (link_style == "full_rings" && insulator_count > 1) {
                for (link_index = [0 : insulator_count - 2]) {
                    link_center_z = (link_index + 1) * unit_pitch - insulator_gap / 2;
                    translate([0, 0, link_center_z])
                        rotate([half_link_rotation_x, half_link_rotation_y, half_link_rotation_z + link_index * half_link_rotation_step_per_insulator])
                            full_connector_link();
                }
            }
        }

        if (custom_link_holes_enabled)
            custom_link_holes();
    }
}

module dimension_annotations() {
    translate([0, 0, -body_chain_height / 2])
    color(dimension_color)
    union() {
        if (dimension_display == "all_insulators") {
            for (dimension_index = [0 : insulator_count - 1]) {
                translate([0, 0, dimension_index * unit_pitch])
                    single_insulator_dimensions(dimension_index);
            }
        } else {
            single_insulator_dimensions(0);
        }
    }
}

module single_insulator_dimensions(dimension_index) {
    height_line_x = insulator_visual_radius + dimension_offset;
    width_line_z = -dimension_offset;
    dimension_front_y = -insulator_visual_radius - dimension_offset * 0.8;
    label_side_x = height_line_x + dimension_text_size * 2.1;
    label_bottom_z = width_line_z - dimension_text_size * 1.6;

    // Höjdmått: total höjd från botten till toppen på en isolator inklusive ändbeslagen.
    translate([height_line_x, dimension_front_y, unit_height / 2])
        cylinder(h=unit_height, r=_dimension_line_radius, center=true);
    translate([height_line_x, dimension_front_y, 0])
        x_dimension_tick(_dimension_tick_length);
    translate([height_line_x, dimension_front_y, unit_height])
        x_dimension_tick(_dimension_tick_length);
    translate([height_line_x, dimension_front_y, unit_height / 2])
        x_dimension_tick(_dimension_tick_length * 0.65);
    dimension_label([label_side_x, dimension_front_y, unit_height / 2], dimension_text_height_string, 90);

    // Breddmått: största diameter för isolatorn, inklusive plattor/beslag och eventuell länkprofil.
    translate([0, dimension_front_y, width_line_z])
        rotate([0, 90, 0])
            cylinder(h=insulator_visual_width, r=_dimension_line_radius, center=true);
    translate([-insulator_visual_radius, dimension_front_y, width_line_z])
        z_dimension_tick(_dimension_tick_length);
    translate([insulator_visual_radius, dimension_front_y, width_line_z])
        z_dimension_tick(_dimension_tick_length);
    dimension_label([0, dimension_front_y, label_bottom_z], dimension_text_width_string, 0);
}

module x_dimension_tick(tick_length) {
    rotate([0, 90, 0])
        cylinder(h=tick_length, r=_dimension_line_radius, center=true);
}

module z_dimension_tick(tick_length) {
    cylinder(h=tick_length, r=_dimension_line_radius, center=true);
}

module dimension_label(label_position, label_text, label_angle) {
    translate(label_position)
        rotate([90, 0, label_angle])
            linear_extrude(height=0.45, center=true)
                text(label_text, size=dimension_text_size, halign="center", valign="center");
}

module custom_link_holes() {
    if (custom_link_hole_placement == "every_insulator_end") {
        for (insulator_index = [0 : insulator_count - 1]) {
            bottom_hole_z = insulator_index * unit_pitch + end_cap_height * custom_link_hole_cap_position;
            top_hole_z = insulator_index * unit_pitch + unit_height - end_cap_height * custom_link_hole_cap_position;

            translate([0, 0, bottom_hole_z])
                horizontal_link_hole();
            translate([0, 0, top_hole_z])
                horizontal_link_hole();
        }
    } else {
        bottom_hole_z = end_cap_height * custom_link_hole_cap_position;
        top_hole_z = (insulator_count - 1) * unit_pitch + unit_height - end_cap_height * custom_link_hole_cap_position;

        translate([0, 0, bottom_hole_z])
            horizontal_link_hole();
        translate([0, 0, top_hole_z])
            horizontal_link_hole();
    }
}

module horizontal_link_hole() {
    rotate([0, 0, custom_link_hole_rotation_z])
        rotate([0, 90, 0])
            cylinder(h=end_cap_radius * 2 + custom_link_hole_extra_cut, r=custom_link_hole_radius, center=true);
}

module single_insulator(insulator_index) {
    base_half_link_rotation_z = half_link_rotation_z + insulator_index * half_link_rotation_step_per_insulator;

    union() {
        color(metal_color)
            center_hardware(unit_height);

        color(ceramic_color)
            translate([0, 0, end_cap_height])
                ceramic_stack();

        color(metal_color) {
            translate([0, 0, 0])
                end_cap(false);
            translate([0, 0, unit_height - end_cap_height])
                end_cap(true);
        }

        if (link_style == "half_donuts") {
            if (show_end_half_links || insulator_index > 0) {
                translate([0, 0, -insulator_gap / 2])
                    rotate([
                        half_link_rotation_x + lower_half_link_extra_rotation_x,
                        half_link_rotation_y + lower_half_link_extra_rotation_y,
                        base_half_link_rotation_z + lower_half_link_extra_rotation_z
                    ])
                        half_donut_link("lower_half");
            }

            if (show_end_half_links || insulator_index < insulator_count - 1) {
                translate([0, 0, unit_height + insulator_gap / 2])
                    rotate([
                        half_link_rotation_x + upper_half_link_extra_rotation_x,
                        half_link_rotation_y + upper_half_link_extra_rotation_y,
                        base_half_link_rotation_z + upper_half_link_extra_rotation_z
                    ])
                        half_donut_link("upper_half");
            }
        }
    }
}

module ceramic_stack() {
    union() {
        cylinder(h=ceramic_stack_height, r=plate_neck_radius * 0.86);

        for (plate_index = [0 : plates_per_insulator - 1]) {
            translate([0, 0, plate_index * plate_spacing + plate_height / 2])
                ceramic_plate();
        }
    }
}

module ceramic_plate() {
    if (support_friendly_plates)
        support_friendly_ceramic_plate();
    else
        classic_ceramic_plate();
}

module classic_ceramic_plate() {
    union() {
        rotate_extrude(convexity=10)
            polygon(points=[
                [0, -plate_height / 2],
                [plate_neck_radius * 0.90, -plate_height / 2],
                [plate_outer_radius, -plate_rim_thickness / 2],
                [plate_outer_radius, plate_rim_thickness / 2],
                [plate_neck_radius * 0.98, plate_height / 2],
                [0, plate_height / 2]
            ]);

        torus(plate_outer_radius - edge_bead_radius * 0.45, edge_bead_radius);

        cylinder(h=plate_height * 1.15, r=plate_neck_radius, center=true);
    }
}

function clamped_plate_cone_depth() =
    min(plate_height, max(0.05, plate_cone_depth));

function clamped_plate_cone_rounding() =
    min(
        plate_cone_rounding,
        (plate_outer_radius - plate_neck_radius) * 0.24,
        clamped_plate_cone_depth() * 0.35
    );

function plate_top_z() = plate_height / 2;
function plate_bowl_low_z() = plate_top_z() - clamped_plate_cone_depth();
function plate_rim_bottom_z() =
    plate_top_z() - min(plate_support_rim_thickness, clamped_plate_cone_depth() * 0.65);
function plate_bowl_inside_low_z() =
    plate_bowl_low_z() +
    (plate_top_z() - plate_bowl_low_z()) * min(1, max(0, plate_bowl_fill));

function support_plate_bottom_radius(t) =
    plate_neck_radius +
    (plate_outer_radius - plate_neck_radius) *
    pow(t, plate_upward_rounding);

function support_plate_bottom_z(t) =
    plate_bowl_low_z() +
    (plate_rim_bottom_z() - plate_bowl_low_z()) *
    pow(t, plate_bowl_curve / max(0.1, plate_underside_slope));

function support_plate_inside_radius(t) =
    plate_neck_radius +
    (plate_outer_radius - plate_neck_radius) *
    pow(t, 1 / max(0.1, plate_bowl_curve));

function support_plate_inside_z(t) =
    plate_bowl_inside_low_z() +
    (plate_top_z() - plate_bowl_inside_low_z()) *
    pow(t, plate_bowl_curve);

function support_plate_top_radius(t) =
    plate_neck_radius +
    (plate_outer_radius - plate_neck_radius) *
    (1 - pow(1 - t, plate_upward_rounding));

function support_plate_bottom_point(i) =
    let(t = i / plate_profile_steps)
    [
        support_plate_bottom_radius(t),
        support_plate_bottom_z(t)
    ];

function support_plate_inside_point(i) =
    let(t = i / plate_profile_steps)
    [
        support_plate_inside_radius(t),
        support_plate_inside_z(t)
    ];

function support_plate_top_point(i) =
    let(t = i / plate_profile_steps)
    [
        support_plate_top_radius(t),
        plate_height / 2 - t * plate_height * 0.42
    ];

module support_friendly_ceramic_plate() {
    union() {
        rotate_extrude(convexity=10)
            let(r = clamped_plate_cone_rounding())
            polygon(points=concat(
                [
                    [0, plate_bowl_low_z()],
                    [plate_neck_radius, plate_bowl_low_z()],
                    [plate_neck_radius + r * 0.35, plate_bowl_low_z() + r * 0.10],
                    [plate_neck_radius + r, plate_bowl_low_z() + r * 0.45]
                ],
                [for (i = [1 : plate_profile_steps]) support_plate_bottom_point(i)],
                [
                    [plate_outer_radius, plate_rim_bottom_z() + r],
                    [plate_outer_radius, plate_top_z()],
                    [plate_outer_radius - r * 0.45, plate_top_z() - r * 0.08]
                ],
                [for (i = [plate_profile_steps - 1 : -1 : 1]) support_plate_inside_point(i)],
                [
                    [plate_neck_radius + r, plate_bowl_inside_low_z() + r * 0.35],
                    [plate_neck_radius + r * 0.35, plate_bowl_inside_low_z() + r * 0.08],
                    [plate_neck_radius, plate_bowl_inside_low_z()],
                    [0, plate_bowl_inside_low_z()]
                ]
            ));

        cylinder(h=plate_height * 1.15, r=plate_neck_radius, center=true);
    }
}

module center_hardware(hardware_height) {
    union() {
        cylinder(h=hardware_height, r=center_rod_radius);

        translate([0, 0, end_cap_height - connection_overlap])
            cylinder(h=connection_overlap * 2, r=end_cap_radius * 0.82);

        translate([0, 0, hardware_height - end_cap_height - connection_overlap])
            cylinder(h=connection_overlap * 2, r=end_cap_radius * 0.82);
    }
}

module end_cap(is_top) {
    union() {
        cylinder(h=end_cap_height, r=end_cap_radius);

        translate([0, 0, end_cap_height / 2])
            cylinder(h=end_cap_height * 0.42, r=end_cap_radius * 1.08, center=true, $fn=6);

        if (is_top) {
            translate([0, 0, end_cap_height - connection_overlap])
                cylinder(h=connection_overlap + end_terminal_height, r=end_terminal_radius);
        } else {
            translate([0, 0, -end_terminal_height])
                cylinder(h=connection_overlap + end_terminal_height, r=end_terminal_radius);
        }
    }
}

module full_connector_link() {
    color(link_color)
    union() {
        rotate([90, 0, 0])
            torus(link_ring_radius, link_ring_thickness);

        cylinder(h=insulator_gap + 2 * connection_overlap, r=center_rod_radius * 0.72, center=true);
    }
}

module half_donut_link(which_half) {
    color(link_color)
    union() {
        if (which_half == "lower_half") {
            rotate([90, 0, 0])
                partial_torus(link_ring_radius, link_ring_thickness, -half_link_overlap_angle / 2, 180 + half_link_overlap_angle);

            translate([0, 0, link_ring_radius - link_ring_thickness * 0.35])
                cylinder(h=max(link_ring_thickness, connection_overlap), r=link_lug_radius, center=true);
        } else {
            rotate([90, 0, 0])
                partial_torus(link_ring_radius, link_ring_thickness, 180 - half_link_overlap_angle / 2, 180 + half_link_overlap_angle);

            translate([0, 0, -link_ring_radius + link_ring_thickness * 0.35])
                cylinder(h=max(link_ring_thickness, connection_overlap), r=link_lug_radius, center=true);
        }

        translate([link_ring_radius, 0, 0])
            sphere(r=link_ring_thickness * 1.03);
        translate([-link_ring_radius, 0, 0])
            sphere(r=link_ring_thickness * 1.03);
    }
}

module torus(major_radius, minor_radius) {
    rotate_extrude(convexity=10)
        translate([major_radius, 0, 0])
            circle(r=minor_radius);
}

module partial_torus(major_radius, minor_radius, start_angle, sweep_angle) {
    rotate([0, 0, start_angle])
        rotate_extrude(angle=sweep_angle, convexity=10)
            translate([major_radius, 0, 0])
                circle(r=minor_radius);
}
