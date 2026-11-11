/* [Visningsläge och Layout] */
// Välj visning av foderdelarna
view_mode = "print_layout"; // [assembly: Komplett fodermontage, print_layout: Utskriftslayout alla delar, corner: Enskild hörnbit, straight: Enskild rak sektion, splice_key: Enskilt skarvkex]

/* [Uppdelningsmetod] */
// Hur de raka bitarna delas upp
split_mode = "max_plus_passbit"; // [max_plus_passbit: Maxlängd med passbit, jamn_fordelning: Jämnt fördelade bitar]

/* [Val av sidor] */
// Ta med överstycke topp
include_top = true;

// Ta med understycke botten
include_bottom = false;

// Ta med vänster sida
include_left = true;

// Ta med höger sida
include_right = true;

/* [Fönsterstorlek och Automatisk beräkning] */
// Fönstrets dagmått öppningsbredd mm
window_width = 900; // [300:50:2000]

// Fönstrets dagmått öppningshöjd mm
window_height = 830; // [300:50:2200]

// Maxlängd per utskriven bit mm
max_piece_length = 260; // [100:10:300]

// Hörnbitens benlängd mm
corner_arm_length = 130; // [70:5:200]

/* [Mått Profil] */
// Fodrets totala bredd på väggen mm
casing_width = 60; // [40:1:120]

// Fodrets tjocklek mm
casing_thickness = 8; // [8:1:25]

// Avrundningsradie på ytterkant framsida mm
edge_radius = 4; // [0.5:0.5:10]

// Klackens djup in i fönsterkarm smyg mm
klack_depth = 30; // [4:1:35]

// Klackens tjocklek bredd mm
klack_thickness = 5; // [4:1:25]

// Innerhörnets radie i falsen mm
inner_corner_radius = 0; // [0.0:0.5:3.0]

// Profilstil
profile_style = "klackfoder"; // [klackfoder: Klackfoder med ren 90 graders fals, slat_single: Slät med en rundad ytterkant, slat_double: Slät med två rundade kanter, allmoge: Klassisk allmogeprofil]

/* [Klack Avfasning] */
// Avfasad klack med mjuk övergång
enable_klack_chamfer = true;

// Avfasningens bredd i botten mm
klack_chamfer_width = 15; // [1:0.5:15]

// Avfasningens höjd på sidan mm
klack_chamfer_depth = 25; // [1:0.5:25]

// Mjuk övergångsradie mm
chamfer_blend_radius = 1.5; // [0.5:0.5:4]

/* [Skarvning och Montering] */
// Invändiga fickor för skarvkex
enable_splice_slots = true;

// Toleransglapp för skarvkex mm
joint_clearance = 0.25; // [0.1:0.05:0.5]

// Dekorativ 45 graders geringslinje på hörnet
decorative_miter_line = false;

// Försänkta monteringshål
enable_screw_holes = false;

// Skruvhålsdiameter mm
screw_diameter = 4; // [3.0:0.5:6.0]

/* [Färger] */
casing_color = "#F4F5F7"; // Vit foderfärg
key_color = "#C88A4A";    // Träfärg kex

/* [Kvalitet] */
$fn = 64;

// Bredd på den plana raka delen av fodret
flat_portion_width = (profile_style == "klackfoder") ? (casing_width - klack_thickness) : casing_width;

// Skarvens centrering mitt i den raka delen
slot_center_pos = flat_portion_width / 2;

// Kexets dimensioner
pocket_w = 14 + joint_clearance * 2;
pocket_h = 5 + joint_clearance * 2;
pocket_depth = 270;

//-------------------------------------------------------------
// LOGIK FÖR HÖRN OCH SIDOR
//-------------------------------------------------------------

has_tl = include_top && include_left;
has_tr = include_top && include_right;
has_bl = include_bottom && include_left;
has_br = include_bottom && include_right;

total_corners = (has_tl ? 1 : 0) + (has_tr ? 1 : 0) + (has_bl ? 1 : 0) + (has_br ? 1 : 0);

corner_reach = corner_arm_length - casing_width;

// Beräkna total rak sträcka för varje sida
top_start_x = has_tl ? corner_reach : 0;
top_end_x = has_tr ? (window_width - corner_reach) : window_width;
top_span = include_top ? max(0, top_end_x - top_start_x) : 0;

bot_start_x = has_bl ? corner_reach : 0;
bot_end_x = has_br ? (window_width - corner_reach) : window_width;
bot_span = include_bottom ? max(0, bot_end_x - bot_start_x) : 0;

left_start_y = has_bl ? corner_reach : 0;
left_end_y = has_tl ? (window_height - corner_reach) : window_height;
left_span = include_left ? max(0, left_end_y - left_start_y) : 0;

right_start_y = has_br ? corner_reach : 0;
right_end_y = has_tr ? (window_height - corner_reach) : window_height;
right_span = include_right ? max(0, right_end_y - right_start_y) : 0;

// Funktioner för exakta bitlängder
function calc_num_pieces(span, max_len, mode) =
    (span <= 0) ? 0 :
    (mode == "jamn_fordelning") ? ceil(span / max_len) :
    let(
        n_full = floor(span / max_len),
        rem = span - n_full * max_len
    )
    (rem > 0) ? (n_full + 1) : max(1, n_full);

function calc_piece_len(i, span, max_len, mode) =
    (mode == "jamn_fordelning") ?
        (span / ceil(span / max_len)) :
        let(
            n_full = floor(span / max_len),
            rem = span - n_full * max_len,
            has_rem = (rem > 0),
            need_adj = (has_rem && rem < 45 && n_full >= 1),
            adj_full = need_adj ? (max_len - (45 - rem)) : max_len,
            adj_rem = need_adj ? 45 : rem
        )
        (i < n_full - (need_adj ? 1 : 0)) ? max_len :
        (need_adj && i == n_full - 1) ? adj_full :
        adj_rem;

function calc_offset(i, span, max_len, mode) =
    (i <= 0) ? 0 :
    calc_offset(i - 1, span, max_len, mode) + calc_piece_len(i - 1, span, max_len, mode);

num_top_pieces = calc_num_pieces(top_span, max_piece_length, split_mode);
num_bot_pieces = calc_num_pieces(bot_span, max_piece_length, split_mode);
num_left_pieces = calc_num_pieces(left_span, max_piece_length, split_mode);
num_right_pieces = calc_num_pieces(right_span, max_piece_length, split_mode);

total_straights = num_top_pieces + num_bot_pieces + num_left_pieces + num_right_pieces;

keys_from_corners = (has_tl ? 2 : 0) + (has_tr ? 2 : 0) + (has_bl ? 2 : 0) + (has_br ? 2 : 0);
keys_from_top = (num_top_pieces > 1) ? (num_top_pieces - 1) : 0;
keys_from_bot = (num_bot_pieces > 1) ? (num_bot_pieces - 1) : 0;
keys_from_left = (num_left_pieces > 1) ? (num_left_pieces - 1) : 0;
keys_from_right = (num_right_pieces > 1) ? (num_right_pieces - 1) : 0;
total_keys = keys_from_corners + keys_from_top + keys_from_bot + keys_from_left + keys_from_right;

//-------------------------------------------------------------
// HUVUDLOGIK
//-------------------------------------------------------------

if (view_mode == "assembly") {
    foder_only_assembly();
} else if (view_mode == "print_layout") {
    full_kit_print_layout();
} else if (view_mode == "corner") {
    color(casing_color)
        mitered_corner_part(corner_arm_length);
} else if (view_mode == "straight") {
    sample_len = (num_top_pieces > 0) ? calc_piece_len(0, top_span, max_piece_length, split_mode) : max_piece_length;
    color(casing_color)
        straight_piece_part(sample_len);
} else if (view_mode == "splice_key") {
    color(key_color)
        splice_key_part();
}

//-------------------------------------------------------------
// 2D PROFIL
//-------------------------------------------------------------
module foder_profile_2d() {
    if (profile_style == "klackfoder") {
        difference() {
            union() {
                hull() {
                    translate([edge_radius, edge_radius]) circle(r=edge_radius);
                    translate([edge_radius, casing_thickness - edge_radius]) circle(r=edge_radius);
                    translate([casing_width - 0.5, 0]) square([0.5, casing_thickness]);
                }
                klack_2d();
            }
            if (inner_corner_radius > 0) {
                translate([casing_width - klack_thickness, 0])
                difference() {
                    translate([-inner_corner_radius, -inner_corner_radius])
                        square([inner_corner_radius, inner_corner_radius]);
                    translate([-inner_corner_radius, 0])
                        circle(r=inner_corner_radius);
                }
            }
        }
    } else if (profile_style == "slat_single") {
        hull() {
            translate([edge_radius, edge_radius]) circle(r=edge_radius);
            translate([edge_radius, casing_thickness - edge_radius]) circle(r=edge_radius);
            translate([casing_width - 0.5, 0]) square([0.5, casing_thickness]);
        }
    } else if (profile_style == "slat_double") {
        hull() {
            translate([edge_radius, edge_radius]) circle(r=edge_radius);
            translate([edge_radius, casing_thickness - edge_radius]) circle(r=edge_radius);
            translate([casing_width - edge_radius, edge_radius]) circle(r=edge_radius);
            translate([casing_width - edge_radius, casing_thickness - edge_radius]) circle(r=edge_radius);
        }
    } else if (profile_style == "allmoge") {
        difference() {
            square([casing_width, casing_thickness]);
            translate([9, casing_thickness + 3.5]) circle(r=9);
            translate([17, casing_thickness + 0.2]) circle(r=2.5);
            translate([casing_width * 0.56, casing_thickness + 7.5]) circle(r=10.5);
            translate([casing_width - 11, casing_thickness + 0.5]) circle(r=2.5);
            translate([casing_width, casing_thickness]) circle(r=1.5);
        }
    }
}

module klack_2d() {
    x0 = casing_width - klack_thickness;
    x1 = casing_width;
    y0 = -klack_depth;
    
    if (enable_klack_chamfer) {
        ch_x = min(klack_chamfer_width, klack_thickness - 0.5);
        ch_y = min(klack_chamfer_depth, klack_depth - 0.5);
        r = min(chamfer_blend_radius, min(ch_x, ch_y) / 2);
        
        difference() {
            translate([x0, y0]) square([klack_thickness, klack_depth]);
            
            translate([x1, y0])
            difference() {
                translate([-ch_x - 1, -1])
                    square([ch_x + 2, ch_y + 2]);
                    
                hull() {
                    translate([-ch_x, r])
                        circle(r=r);
                    translate([-r, ch_y])
                        circle(r=r);
                    translate([-ch_x - 5, r])
                        square([5, ch_y]);
                    translate([-ch_x - 5, ch_y])
                        square([ch_x + 5, 5]);
                }
            }
        }
    } else {
        translate([x0, y0]) square([klack_thickness, klack_depth]);
    }
}

//-------------------------------------------------------------
// SKARVKEX OCH HÅL
//-------------------------------------------------------------
module splice_key_part() {
    kw = 14 - joint_clearance * 2;
    kh = 5 - joint_clearance * 2;
    kl = 38;
    
    difference() {
        hull() {
            translate([1, 1, 1]) cube([kw - 2, kl - 2, kh - 2]);
            translate([2, 2, 0]) cube([kw - 4, kl - 4, kh]);
        }
        translate([-1, kl / 2 - 0.75, -1])
            cube([kw + 2, 1.5, kh + 2]);
    }
}

module countersunk_hole() {
    cylinder(d=screw_diameter, h=casing_thickness * 4, center=true);
    translate([0, 0, casing_thickness - 3.2])
        cylinder(d1=screw_diameter, d2=screw_diameter * 2.2, h=3.5);
    translate([0, 0, casing_thickness + 0.2])
        cylinder(d=screw_diameter * 2.2, h=10);
}

//-------------------------------------------------------------
// 90 GRADERS HÖRNBIT
//-------------------------------------------------------------
module mitered_corner_part(arm_len) {
    cut_box = arm_len * 3;
    z_min = -klack_depth - 10;
    z_h = casing_thickness + klack_depth + 20;
    
    difference() {
        union() {
            difference() {
                multmatrix([
                    [0, 0, 1, 0],
                    [1, 0, 0, 0],
                    [0, 1, 0, 0],
                    [0, 0, 0, 1]
                ])
                linear_extrude(height=arm_len)
                    foder_profile_2d();
                    
                rotate([0, 0, 45])
                translate([-cut_box / 2, 0, z_min])
                    cube([cut_box, cut_box, z_h]);
            }
            
            difference() {
                multmatrix([
                    [1, 0, 0, 0],
                    [0, 0, 1, 0],
                    [0, 1, 0, 0],
                    [0, 0, 0, 1]
                ])
                linear_extrude(height=arm_len)
                    foder_profile_2d();
                    
                rotate([0, 0, 45])
                translate([-cut_box / 2, -cut_box, z_min])
                    cube([cut_box, cut_box, z_h]);
            }
        }
        
        if (decorative_miter_line) {
            rotate([0, 0, 45])
            translate([0, 0, casing_thickness])
            rotate([45, 0, 0])
            translate([0, -0.4, -0.4])
                cube([casing_width * 1.5, 0.8, 0.8]);
        }
        
        if (enable_splice_slots) {
            translate([arm_len - pocket_depth, slot_center_pos - pocket_w / 2, casing_thickness / 2 - pocket_h / 2])
                cube([pocket_depth + 1, pocket_w, pocket_h]);
                
            translate([slot_center_pos - pocket_w / 2, arm_len - pocket_depth, casing_thickness / 2 - pocket_h / 2])
                cube([pocket_w, pocket_depth + 1, pocket_h]);
        }
        
        if (enable_screw_holes) {
            translate([arm_len * 0.65, slot_center_pos, 0])
                countersunk_hole();
            translate([slot_center_pos, arm_len * 0.65, 0])
                countersunk_hole();
        }
    }
}

//-------------------------------------------------------------
// RAK FODERSEKTION
//-------------------------------------------------------------
module straight_piece_part(len) {
    difference() {
        multmatrix([
            [1, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 1]
        ])
        linear_extrude(height=len)
            foder_profile_2d();
            
        if (enable_splice_slots) {
            translate([slot_center_pos - pocket_w / 2, -1, casing_thickness / 2 - pocket_h / 2])
                cube([pocket_w, pocket_depth + 1, pocket_h]);
                
            translate([slot_center_pos - pocket_w / 2, len - pocket_depth, casing_thickness / 2 - pocket_h / 2])
                cube([pocket_w, pocket_depth + 1, pocket_h]);
        }
        
        if (enable_screw_holes) {
            if (len >= 120) {
                translate([slot_center_pos, 35, 0]) countersunk_hole();
                translate([slot_center_pos, len - 35, 0]) countersunk_hole();
            } else {
                translate([slot_center_pos, len / 2, 0]) countersunk_hole();
            }
        }
    }
}

//-------------------------------------------------------------
// FODERMONTAGE
//-------------------------------------------------------------
module foder_only_assembly() {
    W = window_width;
    H = window_height;
    
    color(casing_color) {
        if (has_bl) {
            translate([-casing_width, -casing_width, 0])
                mitered_corner_part(corner_arm_length);
        }
        if (has_br) {
            translate([W, 0, 0])
            mirror([1, 0, 0])
            translate([-casing_width, -casing_width, 0])
                mitered_corner_part(corner_arm_length);
        }
        if (has_tl) {
            translate([0, H, 0])
            mirror([0, 1, 0])
            translate([-casing_width, -casing_width, 0])
                mitered_corner_part(corner_arm_length);
        }
        if (has_tr) {
            translate([W, H, 0])
            mirror([1, 0, 0])
            mirror([0, 1, 0])
            translate([-casing_width, -casing_width, 0])
                mitered_corner_part(corner_arm_length);
        }
    }
    
    // Topp
    if (include_top && num_top_pieces > 0) {
        color(casing_color) {
            for (i = [0 : num_top_pieces - 1]) {
                p_len = calc_piece_len(i, top_span, max_piece_length, split_mode);
                x_pos = top_start_x + calc_offset(i, top_span, max_piece_length, split_mode);
                translate([x_pos, H + casing_width, 0])
                multmatrix([
                    [0, 1, 0, 0],
                    [-1, 0, 0, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, 1]
                ])
                    straight_piece_part(p_len);
            }
        }
    }
    
    // Botten
    if (include_bottom && num_bot_pieces > 0) {
        color(casing_color) {
            for (i = [0 : num_bot_pieces - 1]) {
                p_len = calc_piece_len(i, bot_span, max_piece_length, split_mode);
                x_pos = bot_start_x + calc_offset(i, bot_span, max_piece_length, split_mode);
                translate([x_pos, -casing_width, 0])
                multmatrix([
                    [0, 1, 0, 0],
                    [1, 0, 0, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, 1]
                ])
                    straight_piece_part(p_len);
            }
        }
    }
    
    // Vänster
    if (include_left && num_left_pieces > 0) {
        color(casing_color) {
            for (j = [0 : num_left_pieces - 1]) {
                p_len = calc_piece_len(j, left_span, max_piece_length, split_mode);
                y_pos = left_start_y + calc_offset(j, left_span, max_piece_length, split_mode);
                translate([-casing_width, y_pos, 0])
                    straight_piece_part(p_len);
            }
        }
    }
    
    // Höger
    if (include_right && num_right_pieces > 0) {
        color(casing_color) {
            for (j = [0 : num_right_pieces - 1]) {
                p_len = calc_piece_len(j, right_span, max_piece_length, split_mode);
                y_pos = right_start_y + calc_offset(j, right_span, max_piece_length, split_mode);
                translate([W + casing_width, y_pos, 0])
                mirror([1, 0, 0])
                    straight_piece_part(p_len);
            }
        }
    }
}

//-------------------------------------------------------------
// UTSKRIFTSLAYOUT ALLA DELAR MED DERAS FAKTISKA LÄNGDER
//-------------------------------------------------------------
module full_kit_print_layout() {
    spacing_x = casing_width + 15;
    corner_spacing = corner_arm_length + 20;
    
    // Rad 1: Hörnbitar
    if (total_corners > 0) {
        color(casing_color) {
            for (c = [0 : total_corners - 1]) {
                translate([c * corner_spacing, 0, 0])
                    mitered_corner_part(corner_arm_length);
            }
        }
    }
    
    y_straight_start = (total_corners > 0) ? (corner_arm_length + 25) : 0;
    
    // Raka bitar utlagda per sida med sina verkliga längder och passbitar
    color(casing_color) {
        // Toppbitar
        if (num_top_pieces > 0) {
            for (t = [0 : num_top_pieces - 1]) {
                p_len = calc_piece_len(t, top_span, max_piece_length, split_mode);
                translate([t * spacing_x, y_straight_start, 0])
                    straight_piece_part(p_len);
            }
        }
        
        // Bottenbitar
        offset_bot = num_top_pieces * spacing_x;
        if (num_bot_pieces > 0) {
            for (b = [0 : num_bot_pieces - 1]) {
                p_len = calc_piece_len(b, bot_span, max_piece_length, split_mode);
                translate([offset_bot + b * spacing_x, y_straight_start, 0])
                    straight_piece_part(p_len);
            }
        }
        
        // Vänsterbitar
        offset_left = (num_top_pieces + num_bot_pieces) * spacing_x;
        if (num_left_pieces > 0) {
            for (l = [0 : num_left_pieces - 1]) {
                p_len = calc_piece_len(l, left_span, max_piece_length, split_mode);
                translate([offset_left + l * spacing_x, y_straight_start, 0])
                    straight_piece_part(p_len);
            }
        }
        
        // Högerbitar
        offset_right = (num_top_pieces + num_bot_pieces + num_left_pieces) * spacing_x;
        if (num_right_pieces > 0) {
            for (r = [0 : num_right_pieces - 1]) {
                p_len = calc_piece_len(r, right_span, max_piece_length, split_mode);
                translate([offset_right + r * spacing_x, y_straight_start, 0])
                    straight_piece_part(p_len);
            }
        }
    }
    
    // Skarvkex
    if (total_keys > 0) {
        keys_per_row = 12;
        color(key_color) {
            for (k = [0 : total_keys - 1]) {
                row = floor(k / keys_per_row);
                col = k % keys_per_row;
                translate([col * 22, -45 - row * 45, 0])
                rotate([0, 0, 90])
                    splice_key_part();
            }
        }
    }
}
