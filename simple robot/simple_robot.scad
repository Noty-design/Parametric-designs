/* [Utskrift & Layout] */
layout_mode = "utskrift"; // [monterad, utskrift, ledtest]
// Material profile for ball joints; Manual uses joint_clearance.
material_profile = "PLA"; // [PLA,PETG,Manual]
// Retention at the entrance, independent of bearing clearance.
joint_fit = "Medium"; // [Loose,Medium,Tight]
// Radial bearing clearance in Manual, and clearance for the other joint types (mm).
joint_clearance = 0.2; // [0.1:0.05:0.6]
del_avstand = 16; // [5:1:40]

/* [Dimensioner & Form] */
skala = 1; // [0.5:0.1:2.0]
kant_avrundning = 3; // [1.0:0.5:6.0]
kropps_bredd = 36; // [20:2:60]
kropps_hojd = 46; // [30:2:80]
kropps_djup = 24; // [16:2:40]
arm_tjocklek = 14; // [8:2:24]
ben_tjocklek = 16; // [10:2:30]

/* [Megabot Detaljer] */
face_style = "visir"; // [visir, vanlig, cyklop, gas_mask]
joint_style = "kulled"; // [kulled, utan_leder, lankled, snappled]
show_chest_emblem = true;

/* [Färger (endast för montering)] */
armor_color = "SteelBlue";
joint_color = "DimGray";
face_color = "DeepSkyBlue";
$fn = 100;

// Dynamiska storleksberäkningar
function s(x) = x * skala;
tw = s(kropps_bredd);
th = s(kropps_hojd);
td = s(kropps_djup);
at = s(arm_tjocklek);
bt = s(ben_tjocklek);
br = s(kant_avrundning);

// Del-dimensioner
pelvis_w = tw - s(4);
pelvis_d = td - s(2);
pelvis_h = th * 0.45;

head_w = tw * 0.6;
head_d = td;
head_h = th * 0.5;

uarm_w = at;
uarm_d = at + s(2);
uarm_h = th * 0.7;

larm_w = at - s(2);
larm_d = at;
larm_h = th * 0.6;

thigh_w = bt;
thigh_d = bt + s(2);
thigh_h = th * 0.74;

calf_w = bt + s(2);
calf_d = bt + s(4);
calf_h = th * 0.78;

/* [Hidden] */
// All ball joints use a common size bounded by the narrowest socket land.
ball_c = material_profile == "PLA" ? 0.25 : material_profile == "PETG" ? 0.20 : joint_clearance;
ball_wall = max(0.9, s(1.1));
ball_relief = max(0.65, s(0.85));
ball_slot = max(0.75, s(0.9));
ball_land = min(uarm_w/2, uarm_d/2, thigh_w/2, thigh_d/2, pelvis_w/2-tw/4, pelvis_d/2, td/2);
ball_r = min(s(4.8), ball_land-ball_wall-ball_c);
ball_depth = ball_r*0.62;
ball_center = ball_r*1.38;
ball_gap = joint_style == "kulled" ? ball_center-ball_depth : 0;
ball_flex_depth = ball_depth+ball_r*0.65;
ball_stem = ball_r*0.60;
ball_lead = min(0.55, ball_r*0.12);
eps = 0.025;
function ball_deficit(fit) = min(ball_r*0.10,
    (fit=="Loose" ? 0.20 : fit=="Medium" ? 0.35 : 0.45) + (material_profile=="PETG" ? 0.05 : 0));
assert(joint_style!="kulled" || ball_r>=2.0, "Ball joint is too small for the selected dimensions and nozzle; increase scale or limb width.");
assert(joint_style!="kulled" || ball_depth+ball_r+ball_c < min(uarm_h,thigh_h,pelvis_h), "Ball socket exceeds the available part length.");

if (layout_mode == "ledtest") {
    assert(joint_style=="kulled", "Select kulled for the calibration plate.");
    joint_test_plate();
} else if (layout_mode == "utskrift") {
    pad = max(s(del_avstand), joint_style=="kulled" ? ball_center+ball_r+s(3) : s(del_avstand));
    
    // Överkropp
    translate([0, 0, td/2]) rotate([90,0,0]) color(armor_color) part_torso();
    
    // Huvud (Ovanför)
    translate([0, th/2 + head_h/2 + pad, head_d/2]) rotate([90,0,0]) color(armor_color) part_head();
    
    // Höft (Nedanför)
    translate([0, -(th/2 + pelvis_h/2 + pad), pelvis_d/2]) rotate([90,0,0]) color(armor_color) part_pelvis();
    
    // Armar (På sidorna)
    arm_x = tw/2 + uarm_w/2 + pad;
    translate([-arm_x, 0, uarm_d/2]) rotate([90,0,0]) color(armor_color) part_upper_arm(1);
    translate([arm_x, 0, uarm_d/2]) rotate([90,0,0]) color(armor_color) part_upper_arm(-1);
    
    larm_y = -(uarm_h/2 + larm_h/2 + pad);
    translate([-arm_x, larm_y, larm_d*0.55]) rotate([90,0,0]) color(armor_color) part_lower_arm(1);
    translate([arm_x, larm_y, larm_d*0.55]) rotate([90,0,0]) color(armor_color) part_lower_arm(-1);
    
    // Ben (Längre ut)
    leg_x = arm_x + max(uarm_w/2, larm_w/2) + thigh_w/2 + pad;
    translate([-leg_x, 0, thigh_d/2]) rotate([90,0,0]) color(armor_color) part_thigh(1);
    translate([leg_x, 0, thigh_d/2]) rotate([90,0,0]) color(armor_color) part_thigh(-1);
    
    calf_y = -(thigh_h/2 + calf_h/2 + pad);
    translate([-leg_x, calf_y, calf_d/2]) rotate([90,0,0]) color(armor_color) part_calf(1);
    translate([leg_x, calf_y, calf_d/2]) rotate([90,0,0]) color(armor_color) part_calf(-1);

} else {
    // Visa roboten monterad i 3D
    color(armor_color) assembled_robot();
}

module assembled_robot() {
    part_torso();
    
    translate([0, 0, th/2 + head_h/2 + ball_gap]) part_head();
    
    translate([0, 0, -th/2 - pelvis_h/2 - ball_gap]) {
        part_pelvis();
        // Höger ben
        translate([tw/4, 0, -pelvis_h/2 - thigh_h/2 - ball_gap]) { 
            part_thigh(1);
            translate([0, 0, -thigh_h/2 - calf_h/2 - ball_gap]) part_calf(1);
        }
        // Vänster ben
        translate([-tw/4, 0, -pelvis_h/2 - thigh_h/2 - ball_gap]) {
            part_thigh(-1);
            translate([0, 0, -thigh_h/2 - calf_h/2 - ball_gap]) part_calf(-1);
        }
    }
    
    // Höger Arm
    translate([tw/2 + uarm_w/2 + ball_gap, 0, th*0.25 - uarm_h*0.3]) {
        part_upper_arm(1);
        translate([0, 0, -uarm_h/2 - larm_h/2 - ball_gap]) part_lower_arm(1);
    }
    // Vänster Arm
    translate([-tw/2 - uarm_w/2 - ball_gap, 0, th*0.25 - uarm_h*0.3]) {
        part_upper_arm(-1);
        translate([0, 0, -uarm_h/2 - larm_h/2 - ball_gap]) part_lower_arm(-1);
    }
}

// ==========================================
// Mekaniska Leder (Skalade och Optimerade)
// ==========================================
module socket_cut(fit=joint_fit) {
    js = skala;
    c = joint_clearance;
    if (joint_style == "kulled") {
        // Independent flexible petals: a spherical bearing, a shallow retaining
        // throat, a lead-in, an annular isolation groove and four radial slots.
        seat = ball_r+ball_c;
        throat = ball_r-ball_deficit(fit);
        collar = seat+ball_wall;
        // Spherical seat and straight entry.
        translate([0,0,-ball_depth]) sphere(r=seat, $fn=48);
        translate([0,0,-ball_depth]) cylinder(h=ball_depth+eps, r=throat, $fn=48);
        translate([0,0,-ball_lead]) cylinder(h=ball_lead+eps, r1=throat, r2=ball_r+0.20, $fn=48);
        // The moat isolates the spring fingers from the surrounding armour.
        // Stop above the seat bottom to retain a continuous anchored root.
        translate([0,0,-ball_flex_depth]) difference() {
            cylinder(h=ball_flex_depth+eps,r=collar+ball_relief,$fn=48);
            translate([0,0,-eps]) cylinder(h=ball_flex_depth+3*eps,r=collar,$fn=48);
        }
        for(a=[0,90,180,270]) rotate([0,0,a])
            translate([0,-ball_slot/2,-ball_flex_depth+ball_slot/2])
                cube([collar+ball_relief+eps,ball_slot,ball_flex_depth-ball_slot/2+eps]);
    } else if (joint_style == "utan_leder") {
        translate([0,0,-9*js]) cylinder(h=10*js, r=4.5*js+c, $fn=6);
    } else if (joint_style == "lankled") {
        translate([0,0,-5*js]) cube([10*js+c, 20*js, 14*js], center=true);
        translate([0,0,-6*js]) rotate([90,0,0]) cylinder(h=20*js, r=2*js+c, center=true, $fn=16);
        translate([0,0,-1*js]) cube([10*js+c, 4*js, 4*js], center=true);
    } else if (joint_style == "snappled") {
        translate([0,0,-9*js]) linear_extrude(10*js) ratchet_gear(4.2*js+c, 5.7*js+c, 8);
    }
}

module plug_add() {
    js = skala;
    if (joint_style == "kulled") {
        // A narrower neck allows articulation; the ball stays solid.
        // Positive overlap anchors the stem inside the rounded body.
        anchor = max(0.8, s(0.8));
        translate([0,0,-anchor]) cylinder(h=ball_center+anchor, r=ball_stem, $fn=48);
        translate([0,0,ball_center]) sphere(r=ball_r, $fn=48);
    } else if (joint_style == "utan_leder") {
        cylinder(h=8*js, r=4.5*js, $fn=6);
    } else if (joint_style == "lankled") {
        translate([0,0,6*js]) cube([9*js, 10*js, 12*js], center=true);
        translate([0,0,6*js]) rotate([90,0,0]) cylinder(h=14*js, r=2*js, center=true, $fn=16);
        translate([0,0,11.5*js]) rotate([90,0,0]) cylinder(h=14*js, r1=2*js, r2=0.5*js, center=true, $fn=16);
    } else if (joint_style == "snappled") {
        linear_extrude(8*js) ratchet_gear(4*js, 5.5*js, 8);
    }
}

// Three independent socket/ball pairs printed in the same sideways orientation
// as the actual robot. Left to right: Loose, Medium, Tight.
module joint_test_plate() {
    w=2*(ball_r+ball_c+ball_wall+ball_relief+1.2);
    h=max(2*ball_r+4,ball_depth+ball_r+ball_c+2);
    pitch=w+8;
    for(i=[0:2]) {
        fit=["Loose","Medium","Tight"][i];
        translate([i*pitch,0,w/2]) rotate([90,0,0]) difference() {
            translate([0,0,-h/2]) body_block(w,w,h,min(s(1),w/8));
            socket_cut(fit);
        }
        translate([i*pitch,-h-ball_center-ball_r-5,w/2]) rotate([90,0,0]) union() {
            translate([0,0,-h/2]) body_block(w,w,h,min(s(1),w/8));
            plug_add();
        }
    }
}

module ratchet_gear(r_in, r_out, teeth) {
    polygon([
        for (i = [0 : teeth-1])
            for (pt = [
                [r_out * cos(i * 360 / teeth), r_out * sin(i * 360 / teeth)],
                [r_in * cos((i + 0.8) * 360 / teeth), r_in * sin((i + 0.8) * 360 / teeth)]
            ]) pt
    ]);
}

// ==========================================
// Kroppsdelar (Avrundad baksida för bädden)
// ==========================================
module body_block(w, d, h, r) {
    safe_r = min(r, w/2-0.01, d/2-0.01, h/2-0.01);
    hull() {
        // Framsidans hörn
        translate([ w/2-safe_r,  d/2-safe_r,  h/2-safe_r]) sphere(r=safe_r, $fn=24);
        translate([-w/2+safe_r,  d/2-safe_r,  h/2-safe_r]) sphere(r=safe_r, $fn=24);
        translate([ w/2-safe_r,  d/2-safe_r, -h/2+safe_r]) sphere(r=safe_r, $fn=24);
        translate([-w/2+safe_r,  d/2-safe_r, -h/2+safe_r]) sphere(r=safe_r, $fn=24);
        // Baksidans hörn (mot byggplattan)
        translate([ w/2-safe_r, -d/2+safe_r,  h/2-safe_r]) sphere(r=safe_r, $fn=24);
        translate([-w/2+safe_r, -d/2+safe_r,  h/2-safe_r]) sphere(r=safe_r, $fn=24);
        translate([ w/2-safe_r, -d/2+safe_r, -h/2+safe_r]) sphere(r=safe_r, $fn=24);
        translate([-w/2+safe_r, -d/2+safe_r, -h/2+safe_r]) sphere(r=safe_r, $fn=24);
    }
}

module part_torso() {
    difference() {
        union() {
            body_block(tw, td, th, br);
            // Bröstplatta
            translate([0, td/2, th*0.1]) body_block(tw*0.7, s(4), th*0.45, br*0.7);
            // Mage
            translate([0, td/2-s(1), -th*0.25]) body_block(tw*0.5, s(4), th*0.3, br*0.5);
            if (show_chest_emblem) {
                translate([0, td/2+s(2), th*0.17]) rotate([90,0,0]) cylinder(h=s(3), r=tw*0.15, center=true, $fn=6);
            }
        }
        translate([0, 0, th/2]) socket_cut(); // Nacke
        translate([0, 0, -th/2]) rotate([180,0,0]) socket_cut(); // Midja
        translate([tw/2, 0, th*0.25]) rotate([0, 90, 0]) socket_cut(); // Höger axel
        translate([-tw/2, 0, th*0.25]) rotate([0, -90, 0]) socket_cut(); // Vänster axel
    }
}

module part_pelvis() {
    difference() {
        union() {
            body_block(pelvis_w, pelvis_d, pelvis_h, br);
            // Bälte
            translate([0, pelvis_d/2, pelvis_h*0.1]) body_block(pelvis_w*0.4, s(4), pelvis_h*0.5, br*0.5);
            // Plugg till midja
            translate([0, 0, pelvis_h/2]) color(joint_color) plug_add();
        }
        translate([tw/4, 0, -pelvis_h/2]) rotate([180,0,0]) socket_cut();
        translate([-tw/4, 0, -pelvis_h/2]) rotate([180,0,0]) socket_cut();
    }
}

module part_head() {
    union() {
        body_block(head_w, head_d, head_h, br);
        // Ansiktsdetaljer
        color(face_color) {
            if (face_style == "visir") {
                translate([0, head_d/2, head_h*0.1]) body_block(head_w*0.8, s(4), head_h*0.3, br*0.5);
            } else if (face_style == "cyklop") {
                translate([0, head_d/2, head_h*0.1]) rotate([90,0,0]) cylinder(h=s(4), r=head_w*0.2, center=true);
            } else if (face_style == "gas_mask") {
                translate([0, head_d/2, -head_h*0.15]) body_block(head_w*0.55, s(6), head_h*0.3, br*0.7);
                for(x=[-head_w*0.2, head_w*0.2]) translate([x, head_d/2, head_h*0.15]) rotate([90,0,0]) cylinder(h=s(4), r=head_w*0.12, center=true);
            } else {
                for(x=[-head_w*0.2, head_w*0.2]) translate([x, head_d/2, head_h*0.1]) rotate([90,0,0]) cylinder(h=s(4), r=head_w*0.12, center=true);
            }
        }
        // Plugg till nacke
        translate([0, 0, -head_h/2]) rotate([180,0,0]) color(joint_color) plug_add();
    }
}

module part_upper_arm(side) {
    difference() {
        union() {
            body_block(uarm_w, uarm_d, uarm_h, br);
            // Axelskydd
            translate([side*uarm_w*0.15, uarm_d*0.1, uarm_h*0.3]) body_block(uarm_w*1.3, uarm_d*1.1, uarm_h*0.5, br);
            // Plugg till axel
            translate([-side*uarm_w/2, 0, uarm_h*0.3]) rotate([0, -side*90, 0]) color(joint_color) plug_add();
        }
        translate([0, 0, -uarm_h/2]) rotate([180,0,0]) socket_cut();
    }
}

module part_lower_arm(side) {
    union() {
        body_block(larm_w, larm_d, larm_h, br);
        // Hand
        translate([0, 0, -larm_h/2]) body_block(larm_w*0.8, larm_d*1.1, larm_h*0.35, br*0.8);
        translate([0, 0, larm_h/2]) color(joint_color) plug_add();
    }
}

module part_thigh(side) {
    difference() {
        union() {
            body_block(thigh_w, thigh_d, thigh_h, br);
            // Knäskydd
            translate([0, thigh_d/2, -thigh_h*0.35]) body_block(thigh_w*0.85, s(4), thigh_h*0.35, br*0.7);
            // Plugg till höft
            translate([0, 0, thigh_h/2]) color(joint_color) plug_add();
        }
        translate([0, 0, -thigh_h/2]) rotate([180,0,0]) socket_cut();
    }
}

module part_calf(side) {
    union() {
        body_block(calf_w, calf_d, calf_h, br);
        // Fot
        // Shift each foot outward only as much as required for a 0.8 mm gap.
        foot_offset = max(0, (calf_w*1.1-tw/2+0.8)/2);
        translate([side*foot_offset, calf_d*0.4, -calf_h*0.4]) body_block(calf_w*1.1, calf_d*1.3, calf_h*0.22, br*0.8);
        translate([0, 0, calf_h/2]) color(joint_color) plug_add();
    }
}
