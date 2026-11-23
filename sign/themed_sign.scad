/* ==========================================================================

   Parametric Themed Name Sign and Keychain
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   Customizable raised-letter sign with a rounded Spider-Man theme or a
   pixel-corner Minecraft theme. Both styles support a door sign or a
   keychain, optional mounting holes, and separately colored relief layers.

   All dimensions are in millimeters. X runs along the sign, Y is its height,
   and Z is the extrusion direction (the back of the sign is at Z = 0).
   Colors are for preview and compatible multicolor export workflows; an STL
   does not store colors.

   This file is deliberately documented for safe parameter and geometry edits.
   ========================================================================== */

/* [Main settings] */
// The displayed name; leave empty for a sign with decorative graphics only.
name_text = "Theo";
// Select a wall/door sign or a keychain with an integral attachment tab.
plate_type = "door_sign"; // [door_sign:Door sign, keychain:Keychain]
// Select the theme used for the base outline and raised graphics.
theme = "spiderman"; // [spiderman:Spider-Man, minecraft:Minecraft]

/* [Spider-Man graphics] */
// Select the stylized spider emblem or mask motif.
spiderman_motif = "emblem"; // [emblem:Spider emblem, mask:Mask]
// Motif size relative to its theme-specific reference size; zero hides it.
motif_scale_percent = 0; // [0:5:220]
// Horizontal offset of the motif (mm).
motif_offset_x = 0; // [-70:1:70]
// Vertical offset of the motif (mm).
motif_offset_y = 0; // [-20:1:20]
// Show the clipped radial web behind the name and motif.
show_spider_web = true;

/* [Dimensions and mounting] */
// Derive plate width from the text-length estimate and use a preset height.
auto_size = true;
// Plate width when automatic sizing is disabled (mm).
manual_width = 140; // [50:5:250]
// Plate height when automatic sizing is disabled (mm).
manual_height = 48; // [20:2:100]
// Thickness of the backing plate (mm).
base_thickness = 3.2; // [2.0:0.2:8.0]
// Maximum height of raised text and decoration above the backing plate (mm).
relief_height = 1.5; // [0.6:0.2:3.0]
// Add two countersunk mounting holes to a door sign; ignored for keychains.
mount_holes = false;
// Through-hole diameter (mm).
hole_diameter = 4; // [2.5:0.5:6.0]

/* [Colors and appearance] */
// Apply the theme's default palette instead of the custom colors below.
use_theme_palette = true;
// Custom backing-plate color.
custom_base_color = "#C62828";
// Custom border, web, and emblem color.
custom_detail_color = "#141414";
// Custom raised-letter color.
custom_text_color = "#FFFFFF";
// Custom eye and experience-bar color.
custom_accent_color = "#FFFFFF";

/* [Hidden] */
// Facet count affects circles and rounded edges only.
$fn = 48;

// Keep the theme palette values in one place for easy restyling.
spidey_base   = "#C62828";
spidey_detail = "#141414";
spidey_text   = "#FFFFFF";
spidey_accent = "#FFFFFF";
mc_base       = "#2E7D32";
mc_detail     = "#151515";
mc_text       = "#FFFFFF";
mc_accent     = "#81C784";

base_color   = use_theme_palette ? (theme == "spiderman" ? spidey_base   : mc_base)   : custom_base_color;
detail_color = use_theme_palette ? (theme == "spiderman" ? spidey_detail : mc_detail) : custom_detail_color;
text_color   = use_theme_palette ? (theme == "spiderman" ? spidey_text   : mc_text)   : custom_text_color;
accent_color = use_theme_palette ? (theme == "spiderman" ? spidey_accent : mc_accent) : custom_accent_color;

is_keychain = plate_type == "keychain";
has_text = len(name_text) > 0;
plate_h = auto_size ? (is_keychain ? 28 : 50) : manual_height;
font_size = is_keychain ? min(13, plate_h * 0.44) : min(25, plate_h * 0.46);

// Approximate name width conservatively: the chosen font has variable glyph widths.
est_text_w = has_text ? max(1, len(name_text)) * font_size * 0.65 : 0;
mount_margin = (!is_keychain && mount_holes) ? 26 : 0;
badge_w = theme == "minecraft" ? (is_keychain ? 24 : 44) : (is_keychain ? 16 : 28);
auto_w = has_text
    ? max(is_keychain ? 65 : 125,
          badge_w + est_text_w + (is_keychain ? 16 : 28) + mount_margin)
    : (is_keychain ? 70 : 135);
plate_w = auto_size ? auto_w : manual_width;
border_w = is_keychain ? 1.5 : 2.5;
corner_radius = min(8, plate_h * 0.25);

// Reference motif heights (90 mm for the emblem, 42 mm for the mask) keep
// both motifs proportional to the chosen sign height.
motif_reference_h = spiderman_motif == "emblem" ? 90 : 42;
motif_height_fraction = spiderman_motif == "emblem"
    ? (is_keychain ? 0.82 : 0.88)
    : (is_keychain ? 0.78 : 0.84);
spidey_motif_scale = motif_scale_percent / 100 * plate_h * motif_height_fraction / motif_reference_h;

// Shared Minecraft coordinates prevent the detail outline and accent fill
// from drifting apart when dimensions or margins change.
function creeper_x() = -plate_w / 2 + (is_keychain ? 16 : 26);
function xp_x() = creeper_x() + (is_keychain ? 14 : 26);
function xp_width() = plate_w / 2 - xp_x()
    - (is_keychain ? 6 : (mount_holes ? 18 : 10));
function xp_y() = -plate_h / 2 + (is_keychain ? 5.5 : 8.5);
function xp_height() = is_keychain ? 2.2 : 3.6;
function text_position() = theme == "spiderman" ? [0, 0] : [
    ((-plate_w / 2 + (is_keychain ? 24 : 44))
     + (plate_w / 2 - (is_keychain ? 4 : (mount_holes ? 18 : 8)))) / 2,
    is_keychain ? 3.0 : 4.5
];

assert(plate_w > 2 * corner_radius && plate_h > 2 * corner_radius,
       "Plate dimensions must exceed twice the corner radius.");
assert(base_thickness > 0 && relief_height > 0,
       "Both extrusion heights must be positive.");
assert(hole_diameter > 0 && hole_diameter < plate_h,
       "Mounting-hole diameter must fit within the plate height.");

// --------------------------------------------------------------------------
// Model assembly: combine color-coded layers before subtracting all holes.
// --------------------------------------------------------------------------
nametag();

module nametag() {
    difference() {
        union() {
            color(base_color)
                linear_extrude(height = base_thickness)
                    base_plate_shape();

            color(detail_color)
                translate([0, 0, base_thickness])
                    linear_extrude(height = relief_height * 0.65)
                        details_layer_2d();

            color(accent_color)
                translate([0, 0, base_thickness])
                    linear_extrude(height = relief_height * 0.75)
                        accent_layer_2d();

            if (has_text) {
                // Dark outline is used for Spider-Man; Minecraft has no outline.
                if (theme == "spiderman")
                    color(detail_color)
                        translate([0, 0, base_thickness])
                            linear_extrude(height = relief_height * 0.88)
                                text_outline_2d();

                color(text_color)
                    translate([0, 0, base_thickness])
                        linear_extrude(height = relief_height)
                            text_core_2d();
            }
        }
        cutouts();
    }
}

// --------------------------------------------------------------------------
// Base and inner outlines for the two themes.
// --------------------------------------------------------------------------
module base_plate_shape() {
    if (theme == "minecraft") minecraft_plate_2d();
    else spiderman_plate_2d();
}

module inner_plate_shape() {
    if (theme == "minecraft") minecraft_plate_inner_2d();
    else spiderman_plate_inner_2d();
}

module spiderman_plate_2d() {
    union() {
        // Expand a centered rectangle to produce a plate with round corners.
        offset(r = corner_radius)
            square([plate_w - 2 * corner_radius,
                    plate_h - 2 * corner_radius], center = true);
        if (is_keychain)
            translate([-plate_w / 2 - 2, 0]) circle(d = 12);
    }
}

module spiderman_plate_inner_2d() {
    offset(r = corner_radius - border_w)
        square([plate_w - 2 * corner_radius,
                plate_h - 2 * corner_radius], center = true);
}

module minecraft_plate_2d() {
    step_size = is_keychain ? 2.5 : 4.5;
    union() {
        difference() {
            square([plate_w, plate_h], center = true);
            // The asymmetrical cutouts create a blocky pixel-corner pattern.
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * plate_w / 2, sy * plate_h / 2]) {
                    translate([-sx * step_size * 0.5, -sy * step_size * 0.5])
                        square([step_size, step_size], center = true);
                    translate([-sx * step_size * 1.5, -sy * step_size * 0.25])
                        square([step_size, step_size * 0.5], center = true);
                    translate([-sx * step_size * 0.25, -sy * step_size * 1.5])
                        square([step_size * 0.5, step_size], center = true);
                }
        }
        if (is_keychain)
            translate([-plate_w / 2 - 2, 0]) square([11, 11], center = true);
    }
}

module minecraft_plate_inner_2d() {
    step_size = is_keychain ? 2.5 : 4.5;
    inner_w = plate_w - 2 * border_w;
    inner_h = plate_h - 2 * border_w;
    difference() {
        square([inner_w, inner_h], center = true);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx * inner_w / 2, sy * inner_h / 2])
                translate([-sx * step_size * 0.5, -sy * step_size * 0.5])
                    square([step_size, step_size], center = true);
    }
}

// Cut through the keychain tab or the two door-sign mounting positions.
module cutouts() {
    if (is_keychain) {
        translate([-plate_w / 2 - 2, 0, -1])
            cylinder(h = base_thickness + relief_height + 2, d = 4.5);
    } else if (mount_holes) {
        hole_x = plate_w / 2 - 9;
        for (sx = [-1, 1])
            translate([sx * hole_x, 0, -1]) {
                cylinder(h = base_thickness + 2, d = hole_diameter);
                // Two-level conical recess, measured from its bottom.
                translate([0, 0, base_thickness - 1.2])
                    cylinder(h = relief_height + 2,
                             d1 = hole_diameter, d2 = hole_diameter + 3.5);
            }
    }
}

// --------------------------------------------------------------------------
// Raised border and the chosen theme's dark graphical elements.
// --------------------------------------------------------------------------
module details_layer_2d() {
    difference() {
        base_plate_shape();
        inner_plate_shape();
    }
    if (theme == "spiderman") spiderman_theme_details();
    else minecraft_theme_details();
}

module spiderman_theme_details() {
    if (show_spider_web)
        intersection() {
            inner_plate_shape();
            spiderman_web_rays();
        }

    if (motif_scale_percent > 0)
        translate([motif_offset_x, motif_offset_y])
            scale([spidey_motif_scale, spidey_motif_scale]) {
                if (spiderman_motif == "emblem") insomniac_spider_emblem_2d();
                else spiderman_mask_details_2d();
            }
}

// Stylized eight-legged emblem. The four right-side leg polygons are
// mirrored to the left to avoid duplicating their coordinates.
module insomniac_spider_emblem_2d() {
    union() {
        // Head and mandibles.
        polygon(points = [
            [0,16.5],[1.0,19.0],[2.4,21.6],[3.6,17.8],[3.8,15.0],
            [-3.8,15.0],[-3.6,17.8],[-2.4,21.6],[-1.0,19.0]
        ]);
        // Thorax.
        polygon(points = [
            [3.8,15.0],[5.4,11.5],[5.6,7.5],[4.6,4.0],
            [-4.6,4.0],[-5.6,7.5],[-5.4,11.5],[-3.8,15.0]
        ]);
        // Tapered abdomen with a small central bottom notch.
        polygon(points = [
            [4.4,4.0],[5.6,0.5],[5.8,-3.5],[4.8,-8.5],[3.2,-13.0],
            [1.5,-15.8],[0,-14.2],[-1.5,-15.8],[-3.2,-13.0],
            [-4.8,-8.5],[-5.8,-3.5],[-5.6,0.5],[-4.4,4.0]
        ]);
    }

    for (side = [0, 1]) mirror([side, 0, 0]) {
        // Upper inner leg.
        polygon(points = [
            [3.6,15.0],[4.2,16.6],[11.8,25.8],[14.2,22.8],
            [13.8,28.5],[15.0,36.5],[16.2,45.0],[15.2,38.0],
            [13.4,29.5],[11.2,21.8],[10.0,23.5],[4.2,13.8]
        ]);
        // Upper outer leg.
        polygon(points = [
            [4.6,12.8],[5.2,14.2],[18.5,24.8],[23.8,17.5],
            [26.2,26.5],[27.0,36.5],[25.8,28.5],[22.8,18.8],
            [17.2,22.2],[5.0,10.6]
        ]);
        // Lower outer leg.
        polygon(points = [
            [5.0,9.2],[5.5,10.4],[24.5,3.2],[28.5,-0.5],
            [23.5,-16.5],[19.5,-32.5],[21.2,-22.0],[24.8,-10.5],
            [26.5,-0.5],[22.8,2.0],[5.2,7.4]
        ]);
        // Lower inner leg.
        polygon(points = [
            [4.8,6.0],[5.2,7.2],[17.5,-4.5],[15.2,-18.0],
            [12.8,-32.0],[10.5,-45.0],[12.2,-33.0],[14.5,-19.0],
            [16.0,-5.5],[4.6,4.4]
        ]);
    }
}

// Mask contour, eye rims, and fine web lines.
module spiderman_mask_details_2d() {
    difference() {
        spiderman_head_contour();
        offset(r = -1.5) spiderman_head_contour();
    }
    for (side = [0, 1]) mirror([side, 0, 0]) spiderman_eye_rim();
    intersection() {
        spiderman_head_contour();
        union() {
            square([1.1, 46], center = true);
            for (angle = [24, 48, 72, 108, 132, 156])
                rotate([0, 0, angle]) square([44, 0.9], center = true);
            for (radius = [6, 12, 18, 24])
                difference() {
                    circle(r = radius);
                    circle(r = radius - 0.8);
                }
        }
    }
}

// Radial rays and concentric rings, cropped to the inner plate at call site.
module spiderman_web_rays() {
    line_w = is_keychain ? 0.7 : 1.1;
    max_diag = sqrt(plate_w * plate_w + plate_h * plate_h);
    translate([motif_offset_x, motif_offset_y]) {
        for (angle = [0:20:359])
            rotate([0, 0, angle])
                translate([0, -line_w / 2])
                    square([max_diag, line_w]);
        ring_spacing = is_keychain ? 5.5 : 9.0;
        for (ring_radius = [ring_spacing:ring_spacing:max_diag / 2])
            difference() {
                circle(r = ring_radius);
                circle(r = ring_radius - line_w);
            }
    }
}

module spiderman_head_contour() {
    hull() {
        translate([0, 5]) circle(r = 13);
        translate([0, -8]) circle(r = 9);
        translate([0, -15]) circle(r = 4.8);
    }
}

module spiderman_eye_rim() {
    polygon(points = [
        [2.0,-1.2],[3.4,4.2],[12.0,9.8],[15.0,7.2],
        [11.5,0.4],[5.2,-5.6],[2.4,-4.8]
    ]);
}

module spiderman_eye_white() {
    polygon(points = [
        [3.0,-0.8],[4.2,3.4],[11.0,8.0],[13.2,6.2],
        [10.2,0.8],[5.4,-4.2],[3.3,-3.6]
    ]);
}

// --------------------------------------------------------------------------
// Minecraft motif: an eight-cell Creeper face and a framed experience bar.
// --------------------------------------------------------------------------
module minecraft_theme_details() {
    pixel = is_keychain ? 1.8 : 3.4;
    translate([creeper_x(), 0]) {
        // One-cell border around the face grid.
        difference() {
            square([8 * pixel + 1.4, 8 * pixel + 1.4], center = true);
            square([8 * pixel, 8 * pixel], center = true);
        }
        translate([-4 * pixel, -4 * pixel]) {
            translate([1 * pixel, 4 * pixel]) square([2 * pixel, 2 * pixel]);
            translate([5 * pixel, 4 * pixel]) square([2 * pixel, 2 * pixel]);
            translate([3 * pixel, 3 * pixel]) square([2 * pixel, 1 * pixel]);
            translate([2 * pixel, 1 * pixel]) square([4 * pixel, 2 * pixel]);
            translate([2 * pixel, 0 * pixel]) square([1 * pixel, 1 * pixel]);
            translate([5 * pixel, 0 * pixel]) square([1 * pixel, 1 * pixel]);
        }
    }
    if (xp_width() > 15)
        translate([xp_x() + xp_width() / 2, xp_y()]) {
            difference() {
                square([xp_width(), xp_height()], center = true);
                square([xp_width() - 0.9, xp_height() - 0.9], center = true);
            }
            tick_count = floor(xp_width() / (is_keychain ? 6 : 10));
            for (i = [1:tick_count])
                translate([-xp_width() / 2 + i * xp_width() / (tick_count + 1), 0])
                    square([0.6, xp_height()], center = true);
        }
}

// Raised accent graphics: white eye lenses or the green XP-bar fill.
module accent_layer_2d() {
    if (theme == "spiderman") {
        if (spiderman_motif == "mask" && motif_scale_percent > 0)
            translate([motif_offset_x, motif_offset_y])
                scale([spidey_motif_scale, spidey_motif_scale])
                    for (side = [0, 1])
                        mirror([side, 0, 0]) spiderman_eye_white();
    } else if (xp_width() > 15) {
        translate([xp_x() + xp_width() / 2, xp_y()])
            square([xp_width() - 1.2, xp_height() - 1.2], center = true);
    }
}

// Theme-specific fonts provide consistent text layouts.
module text_core_2d() {
    font_choice = theme == "spiderman"
        ? "Liberation Sans:style=Bold Italic"
        : "Liberation Sans:style=Bold";
    translate(text_position())
        text(text = name_text, size = font_size, font = font_choice,
             halign = "center", valign = "center");
}

// Expand the final positioned text once to keep the outline aligned.
module text_outline_2d() {
    if (theme == "spiderman")
        offset(r = is_keychain ? 1.0 : 1.6)
            text_core_2d();
}
