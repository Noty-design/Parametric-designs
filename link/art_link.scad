// art_link.scad - Artikulerad länk - en del av länken

// ===== Parametrar =====
link_length = 50;        // Längden på länken (mm)
link_body_radius = 10;        // Radien på cylindern (mm)
groove_depth = 6;        // Djupet på sfäriska urgröpningen (mm)
rod_thickness = 3;          // tjocklek på den rundade staven
rod_radius = 1.5;             // radius connected to link body radius
rod_pos_x = -1.0 ; // X-position för länkstaven
resolution = 64;         // Aukter för cylindern och sfären
num_links = 1;           // Antal länkdelar i kedjan
clarens = 0;             // Avstånd mellan länkarna (mm)


// ===== Moduler =====

// Huvudcylinder som ligger horisontellt
module main_cylinder() {
    rotate([0, 90, 0])
        cylinder(h = link_length, r = link_body_radius, center = true, $fn = resolution);
}

// Sfärisk urgröpning i cylinderändarna
module end_groove(position = 1) {
    translate([position * link_length / 2, 0, 0])
        sphere(r = groove_depth, $fn = resolution);
}

// Länkstav som består av en enda halvdounat form mellan toppen och botten på -X-änden
module link_rod() {
    translate([-link_length / 2 - rod_pos_x, 0, 0])
        rotate([0, 90, 90])
            rotate_extrude(angle = 180, $fn = resolution)
                translate([link_body_radius +rod_radius, 0, 0])
                    circle(r = rod_thickness, $fn = resolution);
    
    translate([link_length / 2 + rod_pos_x, 0, 0])
        rotate([0, 0, -90])
            rotate_extrude(angle = 180, $fn = resolution)
                translate([link_body_radius +rod_radius, 0, 0])
                    circle(r = rod_thickness, $fn = resolution);
}

// Artikulerad länk - huvudmodul
module articulated_link_part() {
    union() {
        // Huvudcylinder med sfäriska urgröpningar i ändarna
        difference() {
            main_cylinder();
            end_groove(1);
            end_groove(-1);
        }

        // Länkstav mellan +Z och -Z på -X-änden
        link_rod();
    }
}

// Kedja - flera länkdelar sammankopplade
module link_chain(count = 1) {
    for (i = [0 : count - 1]) {
            translate([i * (link_length + clarens), 0, 0])
                articulated_link_part();
    }
}

// ===== Rendering =====
link_chain(num_links);
