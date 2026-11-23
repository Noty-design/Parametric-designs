// =====================================================================
// Parametrisk Namnskylt: Spindelmannen & Minecraft
// Dörrskylt & Nyckelring
// - Spindelmannen: Insomniac-spindelemblem (eller mask) och nät
// - Justerbar storlek & position för Spindelmannen-motivet
// - Minecraft: Klassisk Creeper till vänster med XP-bar under texten
// =====================================================================

/* [Huvudinställningar / Main Settings] */
// Namn som ska visas på skylten (lämna tomt för enbart emblem)
name_text = "Theo";
// Typ av skylt
plate_type = "door_sign"; // [door_sign:Dörrskylt, keychain:Nyckelring]
// Tema för skylten
theme = "spiderman"; // [spiderman:Spindelmannen, minecraft:Minecraft]

/* [Spindelmannen-inställningar / Spider-Man Controls] */
// Välj motiv i bakgrunden för Spindelmannen
spiderman_motif = "emblem"; // [emblem:Spindel-Emblemet (Insomniac), mask:Ansikte/Mask]
// Storlek på motivet i procent
motif_scale_percent = 0; // [40:5:220]
// Flytta motivet i sidled (X-axel i mm)
motif_offset_x = 0; // [-70:1:70]
// Flytta motivet i höjdled (Y-axel i mm)
motif_offset_y = 0; // [-20:1:20]
// Visa spindelnät i bakgrunden
show_spider_web = true;

/* [Mått & Justering / Dimensions] */
// Automatisk storleksanpassning efter textlängd
auto_size = true;
// Manuell bredd i mm (om automatisk storlek är avstängd)
manual_width = 140; // [50:5:250]
// Manuell höjd i mm (om automatisk storlek är avstängd)
manual_height = 48; // [20:2:100]
// Basplattans tjocklek (mm)
base_thickness = 3.2; // [2.0:0.2:8.0]
// Höjd på upphöjd text och dekorativa detaljer (mm)
relief_height = 1.5; // [0.6:0.2:3.0]
// Skruvhål för dörrskylt (endast för dörrskylt)
mount_holes = false;
// Skruvhålens diameter (mm)
hole_diameter = 4; // [2.5:0.5:6.0]

/* [Färger & Utseende / Colors] */
// Använd temats standardfärger
use_theme_palette = true;
// Egen basfärg
custom_base_color = "#C62828";
// Egen detaljfärg
custom_detail_color = "#141414";
// Egen textfärg
custom_text_color = "#FFFFFF";
// Egen accentfärg
custom_accent_color = "#FFFFFF";

/* [Dolda beräkningar] */
$fn = 48;

// Färgpaletter
spidey_base   = "#C62828"; // Spidey Röd
spidey_detail = "#141414"; // Svart nät & emblem
spidey_text   = "#FFFFFF"; // Vit text
spidey_accent = "#FFFFFF"; // Accent / Ögon
mc_base   = "#2E7D32";     // Minecraft Gräsgrön
mc_detail = "#151515";     // Creeper Svart / Pixelkontur
mc_text   = "#FFFFFF";     // Vit text
mc_accent = "#81C784";     // Ljusgrön XP / Accent

base_color   = use_theme_palette ? (theme == "spiderman" ? spidey_base : mc_base) : custom_base_color;
detail_color = use_theme_palette ? (theme == "spiderman" ? spidey_detail : mc_detail) : custom_detail_color;
text_color   = use_theme_palette ? (theme == "spiderman" ? spidey_text : mc_text) : custom_text_color;
accent_color = use_theme_palette ? (theme == "spiderman" ? spidey_accent : mc_accent) : custom_accent_color;

is_keychain = (plate_type == "keychain");

// Storleksberäkning
default_h = is_keychain ? 28 : 50;
plate_h = auto_size ? default_h : manual_height;

font_size = is_keychain ? min(13, plate_h * 0.44) : min(25, plate_h * 0.46);
has_text = (len(name_text) > 0);
text_len = max(1, len(name_text));
est_text_w = has_text ? (text_len * font_size * 0.65) : 0;
mount_margin = (!is_keychain && mount_holes) ? 26 : 0;

// Skyltens bredd
badge_w = (theme == "minecraft") ? (is_keychain ? 24 : 44) : (is_keychain ? 16 : 28);
auto_w = has_text 
    ? max(is_keychain ? 65 : 125, badge_w + est_text_w + (is_keychain ? 16 : 28) + mount_margin)
    : (is_keychain ? 70 : 135);
plate_w = auto_size ? auto_w : manual_width;

border_w = is_keychain ? 1.5 : 2.5;
corner_radius = min(8, plate_h * 0.25);

// Beräknad skalning för Spiderman-motivet
// Emblemet är ~90 enheter högt, masken är ~42 enheter hög
spidey_motif_scale = (motif_scale_percent / 100) * (
    (spiderman_motif == "emblem")
        ? (is_keychain ? (plate_h * 0.82 / 90) : (plate_h * 0.88 / 90))
        : (is_keychain ? (plate_h * 0.78 / 42) : (plate_h * 0.84 / 42))
);

// =====================================================================
// Huvudmontering
// =====================================================================
nametag();

module nametag() {
    difference() {
        union() {
            // 1. Basplatta
            color(base_color)
            linear_extrude(height = base_thickness)
            base_plate_shape();

            // 2. Detaljlager (Ram & temagrafik / emblem)
            color(detail_color)
            translate([0, 0, base_thickness])
            linear_extrude(height = relief_height * 0.65)
            details_layer_2d();

            // 3. Accentlager (Vita ögon för mask / Ljusgrön XP-bar för Minecraft)
            color(accent_color)
            translate([0, 0, base_thickness])
            linear_extrude(height = relief_height * 0.75)
            accent_layer_2d();

            // 4. Textkontur (Svart ram för Spiderman för perfekt kontrast mot motivet)
            if (has_text) {
                color(detail_color)
                translate([0, 0, base_thickness])
                linear_extrude(height = relief_height * 0.88)
                text_outline_2d();

                // 5. Upphöjd text
                color(text_color)
                translate([0, 0, base_thickness])
                linear_extrude(height = relief_height)
                text_core_2d();
            }
        }

        // Hål för skruvar eller nyckelringsögla
        cutouts();
    }
}

// =====================================================================
// Basplattans form
// =====================================================================
module base_plate_shape() {
    if (theme == "minecraft") {
        minecraft_plate_2d();
    } else {
        spiderman_plate_2d();
    }
}

module inner_plate_shape() {
    if (theme == "minecraft") {
        minecraft_plate_inner_2d();
    } else {
        spiderman_plate_inner_2d();
    }
}

module spiderman_plate_2d() {
    union() {
        offset(r = corner_radius)
            square([plate_w - 2 * corner_radius, plate_h - 2 * corner_radius], center = true);

        if (is_keychain) {
            translate([-plate_w / 2 - 2, 0])
                circle(d = 12);
        }
    }
}

module spiderman_plate_inner_2d() {
    offset(r = corner_radius - border_w)
        square([plate_w - 2 * corner_radius, plate_h - 2 * corner_radius], center = true);
}

module minecraft_plate_2d() {
    step = is_keychain ? 2.5 : 4.5;
    union() {
        difference() {
            square([plate_w, plate_h], center = true);
            // Stegade pixel-hörn
            for (sx = [-1, 1], sy = [-1, 1]) {
                translate([sx * plate_w / 2, sy * plate_h / 2]) {
                    translate([-sx * step * 0.5, -sy * step * 0.5])
                        square([step, step], center = true);
                    translate([-sx * step * 1.5, -sy * step * 0.25])
                        square([step, step * 0.5], center = true);
                    translate([-sx * step * 0.25, -sy * step * 1.5])
                        square([step * 0.5, step], center = true);
                }
            }
        }
        if (is_keychain) {
            translate([-plate_w / 2 - 2, 0])
                square([11, 11], center = true);
        }
    }
}

module minecraft_plate_inner_2d() {
    step = is_keychain ? 2.5 : 4.5;
    w_in = plate_w - 2 * border_w;
    h_in = plate_h - 2 * border_w;
    difference() {
        square([w_in, h_in], center = true);
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * w_in / 2, sy * h_in / 2]) {
                translate([-sx * step * 0.5, -sy * step * 0.5])
                    square([step, step], center = true);
            }
        }
    }
}

// =====================================================================
// Utskärningar (Hål)
// =====================================================================
module cutouts() {
    if (is_keychain) {
        // Nyckelringshål
        translate([-plate_w / 2 - 2, 0, -1])
            cylinder(h = base_thickness + relief_height + 2, d = 4.5);
    } else if (mount_holes) {
        // Försänkta skruvhål för dörrskylt
        hole_x = plate_w / 2 - 9;
        for (sx = [-1, 1]) {
            translate([sx * hole_x, 0, -1]) {
                cylinder(h = base_thickness + 2, d = hole_diameter);
                translate([0, 0, base_thickness - 1.2])
                    cylinder(h = relief_height + 2, d1 = hole_diameter, d2 = hole_diameter + 3.5);
            }
        }
    }
}

// =====================================================================
// Detaljlager (Ram och temagrafik)
// =====================================================================
module details_layer_2d() {
    // 1. Yttre upphöjd ram
    difference() {
        base_plate_shape();
        inner_plate_shape();
    }

    // 2. Temaspecifik grafik
    if (theme == "spiderman") {
        spiderman_theme_details();
    } else {
        minecraft_theme_details();
    }
}

// ---------------------------------------------------------------------
// SPIDERMAN: Nät & Justerbart emblem / mask bakom texten
// ---------------------------------------------------------------------
module spiderman_theme_details() {
    // Bakgrundsspindelnät (strikt klippt inuti plattan)
    if (show_spider_web) {
        intersection() {
            inner_plate_shape();
            spiderman_web_rays();
        }
    }

    // Spindelmannen-motiv (Insomniac Spider Emblem eller Mask)
    translate([motif_offset_x, motif_offset_y])
    scale([spidey_motif_scale, spidey_motif_scale]) {
        if (spiderman_motif == "emblem") {
            insomniac_spider_emblem_2d();
        } else {
            spiderman_mask_details_2d();
        }
    }
}

// =====================================================================
// Exakt Insomniac / Spider-Man Spindel-emblem från bilden
// =====================================================================
module insomniac_spider_emblem_2d() {
    // 1. Central kropp (Huvud, Thorax, Abdomen)
    union() {
        // Huvud med spetsiga horn / mandibler
        polygon(points = [
            [0, 16.5],
            [1.0, 19.0],
            [2.4, 21.6],
            [3.6, 17.8],
            [3.8, 15.0],
            [-3.8, 15.0],
            [-3.6, 17.8],
            [-2.4, 21.6],
            [-1.0, 19.0]
        ]);

        // Mellankropp (Thorax)
        polygon(points = [
            [3.8, 15.0],
            [5.4, 11.5],
            [5.6, 7.5],
            [4.6, 4.0],
            [-4.6, 4.0],
            [-5.6, 7.5],
            [-5.4, 11.5],
            [-3.8, 15.0]
        ]);

        // Bakkropp (Abdomen) med skarp avsmalning och botteninskärning
        polygon(points = [
            [4.4, 4.0],
            [5.6, 0.5],
            [5.8, -3.5],
            [4.8, -8.5],
            [3.2, -13.0],
            [1.5, -15.8],
            [0, -14.2],
            [-1.5, -15.8],
            [-3.2, -13.0],
            [-4.8, -8.5],
            [-5.8, -3.5],
            [-5.6, 0.5],
            [-4.4, 4.0]
        ]);
    }

    // 2. 8 Spindelben (4 på vardera sida via spegling)
    for (m = [0, 1]) mirror([m, 0, 0]) {
        // Ben 1: Inre övre ben (når högst upp, böjd nålspets)
        polygon(points = [
            [3.6, 15.0],
            [4.2, 16.6],
            [11.8, 25.8],
            [14.2, 22.8],
            [13.8, 28.5],
            [15.0, 36.5],
            [16.2, 45.0],
            [15.2, 38.0],
            [13.4, 29.5],
            [11.2, 21.8],
            [10.0, 23.5],
            [4.2, 13.8]
        ]);

        // Ben 2: Yttre övre ben (når upp och ut)
        polygon(points = [
            [4.6, 12.8],
            [5.2, 14.2],
            [18.5, 24.8],
            [23.8, 17.5],
            [26.2, 26.5],
            [27.0, 36.5],
            [25.8, 28.5],
            [22.8, 18.8],
            [17.2, 22.2],
            [5.0, 10.6]
        ]);

        // Ben 3: Yttre nedre ben (sträcker sig till det breda sidoknät)
        polygon(points = [
            [5.0, 9.2],
            [5.5, 10.4],
            [24.5, 3.2],
            [28.5, -0.5],
            [23.5, -16.5],
            [19.5, -32.5],
            [21.2, -22.0],
            [24.8, -10.5],
            [26.5, -0.5],
            [22.8, 2.0],
            [5.2, 7.4]
        ]);

        // Ben 4: Inre nedre ben (lång graciös kurva nedåt till skarp spets)
        polygon(points = [
            [4.8, 6.0],
            [5.2, 7.2],
            [17.5, -4.5],
            [15.2, -18.0],
            [12.8, -32.0],
            [10.5, -45.0],
            [12.2, -33.0],
            [14.5, -19.0],
            [16.0, -5.5],
            [4.6, 4.4]
        ]);
    }
}

// Spiderman Maskdetaljer
module spiderman_mask_details_2d() {
    difference() {
        spiderman_head_contour();
        offset(r = -1.5) spiderman_head_contour();
    }

    for (m = [0, 1]) mirror([m, 0, 0]) {
        spiderman_eye_rim();
    }

    intersection() {
        spiderman_head_contour();
        union() {
            square([1.1, 46], center = true);
            for (a = [24, 48, 72, 108, 132, 156]) {
                rotate([0, 0, a]) square([44, 0.9], center = true);
            }
            for (rad = [6, 12, 18, 24]) {
                difference() {
                    circle(r = rad);
                    circle(r = rad - 0.8);
                }
            }
        }
    }
}

module spiderman_web_rays() {
    line_w = is_keychain ? 0.7 : 1.1;
    max_diag = sqrt(plate_w * plate_w + plate_h * plate_h);

    translate([motif_offset_x, motif_offset_y]) {
        for (a = [0 : 20 : 359]) {
            rotate([0, 0, a])
                translate([0, -line_w / 2])
                    square([max_diag, line_w]);
        }

        step_r = is_keychain ? 5.5 : 9.0;
        for (r_ring = [step_r : step_r : max_diag / 2]) {
            difference() {
                circle(r = r_ring);
                circle(r = r_ring - line_w);
            }
        }
    }
}

module spiderman_head_contour() {
    hull() {
        translate([0, 5]) circle(r = 13);
        translate([0, -8]) circle(r = 9.0);
        translate([0, -15]) circle(r = 4.8);
    }
}

module spiderman_eye_rim() {
    polygon(points = [
        [2.0, -1.2],
        [3.4, 4.2],
        [12.0, 9.8],
        [15.0, 7.2],
        [11.5, 0.4],
        [5.2, -5.6],
        [2.4, -4.8]
    ]);
}

module spiderman_eye_white() {
    polygon(points = [
        [3.0, -0.8],
        [4.2, 3.4],
        [11.0, 8.0],
        [13.2, 6.2],
        [10.2, 0.8],
        [5.4, -4.2],
        [3.3, -3.6]
    ]);
}

// ---------------------------------------------------------------------
// MINECRAFT: Klassisk layout (Creeper till vänster, XP-bar under text)
// ---------------------------------------------------------------------
module minecraft_theme_details() {
    badge_x = -plate_w / 2 + (is_keychain ? 16 : 26);
    p = is_keychain ? 1.8 : 3.4;

    // 1. Ikonisk 8x8 Creeper Face till vänster
    translate([badge_x, 0]) {
        difference() {
            square([8 * p + 1.4, 8 * p + 1.4], center = true);
            square([8 * p, 8 * p], center = true);
        }

        translate([-4 * p, -4 * p]) {
            translate([1 * p, 4 * p]) square([2 * p, 2 * p]);
            translate([5 * p, 4 * p]) square([2 * p, 2 * p]);
            translate([3 * p, 3 * p]) square([2 * p, 1 * p]);
            translate([2 * p, 1 * p]) square([4 * p, 2 * p]);
            translate([2 * p, 0 * p]) square([1 * p, 1 * p]);
            translate([5 * p, 0 * p]) square([1 * p, 1 * p]);
        }
    }

    // 2. Minecraft XP-bar kontur under texten
    bar_x = badge_x + (is_keychain ? 14 : 26);
    bar_w = plate_w - bar_x - (plate_w / 2) - (is_keychain ? 6 : (mount_holes ? 18 : 10));
    bar_y = is_keychain ? -plate_h / 2 + 5.5 : -plate_h / 2 + 8.5;
    bar_h = is_keychain ? 2.2 : 3.6;

    if (bar_w > 15) {
        translate([bar_x + bar_w / 2, bar_y]) {
            difference() {
                square([bar_w, bar_h], center = true);
                square([bar_w - 0.9, bar_h - 0.9], center = true);
            }
            num_ticks = floor(bar_w / (is_keychain ? 6 : 10));
            for (i = [1 : num_ticks]) {
                translate([-bar_w / 2 + i * (bar_w / (num_ticks + 1)), 0])
                    square([0.6, bar_h], center = true);
            }
        }
    }
}

// =====================================================================
// Accentlager
// =====================================================================
module accent_layer_2d() {
    if (theme == "spiderman") {
        if (spiderman_motif == "mask") {
            // Vita ögonlinser (följer samma position och skalning som masken)
            translate([motif_offset_x, motif_offset_y])
            scale([spidey_motif_scale, spidey_motif_scale]) {
                for (m = [0, 1]) mirror([m, 0, 0]) {
                    spiderman_eye_white();
                }
            }
        }
    } else {
        // Ljusgrön fyllning i XP-baren under texten för Minecraft
        badge_x = -plate_w / 2 + (is_keychain ? 16 : 26);
        bar_x = badge_x + (is_keychain ? 14 : 26);
        bar_w = plate_w - bar_x - (plate_w / 2) - (is_keychain ? 6 : (mount_holes ? 18 : 10));
        bar_y = is_keychain ? -plate_h / 2 + 5.5 : -plate_h / 2 + 8.5;
        bar_h = is_keychain ? 2.2 : 3.6;

        if (bar_w > 15) {
            translate([bar_x + bar_w / 2, bar_y]) {
                square([bar_w - 1.2, bar_h - 1.2], center = true);
            }
        }
    }
}

// =====================================================================
// Textposition & utformning
// =====================================================================
function get_text_pos() = 
    (theme == "spiderman") 
        ? [0, 0] 
        : [
            ((-plate_w / 2 + (is_keychain ? 24 : 44)) + (plate_w / 2 - (is_keychain ? 4 : (mount_holes ? 18 : 8)))) / 2,
            is_keychain ? 3.0 : 4.5
          ];

module text_core_2d() {
    pos = get_text_pos();
    font_choice = (theme == "spiderman") 
        ? "Liberation Sans:style=Bold Italic" 
        : "Liberation Sans:style=Bold";

    translate(pos)
        text(
            text = name_text,
            size = font_size,
            font = font_choice,
            halign = "center",
            valign = "center"
        );
}

module text_outline_2d() {
    pos = get_text_pos();
    outline_r = is_keychain ? 1.0 : 1.6;

    if (theme == "spiderman") {
        translate(pos)
            offset(r = outline_r)
                text_core_2d();
    }
}
