/* ==========================================================================

   Parametric Themed Name Sign and Keychain
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   Customizable raised-letter sign with a rounded Spider-Man theme or a
   pixel-corner Minecraft theme, or three unicorn layouts. Each supports a door sign or a
   keychain, optional mounting holes, and separately colored relief layers.

   All dimensions are in millimeters. X runs along the sign, Y is its height,
   and Z is the extrusion direction (the back of the sign is at Z = 0).
   Colors are for preview and compatible multicolor export workflows; an STL
   does not store colors.

   This file is deliberately documented for safe parameter and geometry edits.
   ========================================================================== */

/* [Main settings] */
// The displayed name; leave empty for a sign with decorative graphics only.
name_text = "ELLA";
// Select a wall/door sign or a keychain with an integral attachment tab.
plate_type = "door_sign"; // [door_sign:Door sign, keychain:Keychain]
// Select the theme used for the base outline and raised graphics.
theme = "unicorn"; // [spiderman:Spider-Man, minecraft:Minecraft, unicorn:Unicorn]

/* [Unicorn graphics] */
// Select the complete unicorn silhouette, a head above the sign, or an inset motif.
unicorn_variant = "full_horse"; // [full_horse:Full unicorn, head_top:Head above sign, inside:Unicorn inside sign]
// Display small decorative sparkles.
unicorn_show_stars = true;
// Select the facial expression for every unicorn layout.
unicorn_eye_style = "closed"; // [closed:Closed eyes, open:Open eyes]
// Add a small swept eyelash to either eye expression.
unicorn_eye_lashes = true;
// Choose an attached loop or a hole in the artwork. Neck and mane use layout-specific anchors.
unicorn_keyhole_position = "loop"; // [loop:External loop, neck:Neck, mane:Mane]
// Move the hole or loop horizontally (mm). Near an edge, the base grows locally to support the hole.
unicorn_keyhole_offset_x = 0; // [-30:0.5:30]
// Move the hole or loop vertically (mm).
unicorn_keyhole_offset_y = 0; // [-30:0.5:30]
// Horizontal name position adjustment (mm).
unicorn_text_offset_x = 0; // [-40:0.5:40]
// Vertical name position adjustment (mm).
unicorn_text_offset_y = 0; // [-25:0.5:25]
// Relative size of the head for the two plate layouts.
unicorn_motif_scale = 100; // [70:5:120]

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
// Horizontal adjustment of the name (mm).
spiderman_text_offset_x = 0; // [-40:0.5:40]
// Vertical adjustment of the name (mm).
spiderman_text_offset_y = 0; // [-25:0.5:25]

/* [Minecraft text] */
// Horizontal adjustment of the name (mm).
minecraft_text_offset_x = 0; // [-40:0.5:40]
// Vertical adjustment of the name (mm).
minecraft_text_offset_y = 0; // [-25:0.5:25]
// Keep moved text within the reserved text zone; disable for free placement.
minecraft_limit_text_position = true;

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
if (theme == "unicorn") unicorn_nametag();
else nametag();

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
            if (is_keychain || (spiderman_motif == "emblem" && motif_scale_percent > 0)) offset(delta=-0.02) inner_plate_shape(); else inner_plate_shape();
            spiderman_web_rays();
        }

    if (motif_scale_percent > 0)
        if (spiderman_motif == "emblem")
            intersection() {
                inner_plate_shape();
                translate([motif_offset_x, motif_offset_y])
                    scale([spidey_motif_scale, spidey_motif_scale])
                        insomniac_spider_emblem_2d();
            }
        else
            translate([motif_offset_x, motif_offset_y])
                scale([spidey_motif_scale, spidey_motif_scale])
                    spiderman_mask_details_2d();
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
        polygon(points = [[3.6, 15.0], [4.2, 16.6], [11.8, 25.8], [13.4, 29.5], [15.2, 38.0], [16.2, 45.0], [15.0, 36.5], [13.8, 28.5], [14.2, 22.8], [11.2, 21.8], [10.0, 23.5], [4.2, 13.8]]);
        // Upper outer leg.
        polygon(points = [[4.6, 12.8], [5.2, 14.2], [18.5, 24.8], [25.8, 28.5], [27.0, 36.5], [26.2, 26.5], [23.8, 17.5], [22.8, 18.8], [17.2, 22.2], [5.0, 10.6]]);
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
            // Overlap the eye corners to avoid point-only pixel contacts.
            translate([3 * pixel - 0.02, 3 * pixel]) square([2 * pixel + 2 * 0.02, pixel + 0.02]);
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
// Approximate advances of the selected Liberation Sans Bold font, in cap-height units.
mc_glyphs = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 -_ÅÄÖåäöÉé.";
mc_advances = [1.05, 1.05, 1.05, 1.05, 0.969, 0.888, 1.131, 1.05, 0.404, 0.808, 1.05, 0.888, 1.211, 1.05, 1.131, 0.969, 1.131, 1.05, 0.969, 0.888, 1.05, 0.969, 1.372, 0.969, 0.969, 0.888, 0.808, 0.888, 0.808, 0.888, 0.808, 0.484, 0.888, 0.888, 0.404, 0.404, 0.808, 0.404, 1.292, 0.888, 0.888, 0.888, 0.888, 0.566, 0.808, 0.484, 0.888, 0.808, 1.131, 0.808, 0.808, 0.727, 0.808, 0.808, 0.808, 0.808, 0.808, 0.808, 0.808, 0.808, 0.808, 0.808, 0.404, 0.484, 0.808, 1.05, 1.05, 1.131, 0.808, 0.808, 0.888, 0.969, 0.808, 0.404];
function mc_glyph_width(c) =
    let(matches=search(c,mc_glyphs,1))
    len(matches)>0 ? mc_advances[matches[0]] : 1.6;
function mc_name_units(i=0) =
    i>=len(name_text) ? 0 : mc_glyph_width(name_text[i])+mc_name_units(i+1);
function mc_text_left() = max(-plate_w/2+(is_keychain?24:44),
    creeper_x()+(is_keychain?8:14.5)+1.2);
function mc_text_right() = plate_w/2-(is_keychain?4:(mount_holes?18:8));
function mc_text_available() = max(1,mc_text_right()-mc_text_left());

// The text positions are relative to each theme's established layout.
// At zero offset, no clipping or automatic repositioning is applied.
module text_core_2d() {
    font_choice = theme == "spiderman"
        ? "Liberation Sans:style=Bold Italic"
        : "Liberation Sans:style=Bold";
    if (theme == "minecraft") {
        available = mc_text_available();
        fitted_size = min(font_size, available / max(0.1, mc_name_units() * 1.03));
        center_x = (mc_text_left() + mc_text_right()) / 2;
        center_y = text_position()[1];
        estimated_half_w = min(available / 2, mc_name_units() * fitted_size * 1.03 / 2);
        x_min = mc_text_left() + estimated_half_w;
        x_max = mc_text_right() - estimated_half_w;
        y_min = max(-plate_h / 2 + border_w + fitted_size * 0.55,
                    xp_y() + xp_height() / 2 + fitted_size * 0.55 + 0.8);
        y_max = plate_h / 2 - border_w - fitted_size * 0.55;
        x_requested = center_x + minecraft_text_offset_x;
        y_requested = center_y + minecraft_text_offset_y;
        // Zero offsets exactly preserve the accepted geometry, even if a
        // manually undersized plate leaves no safe movement interval.
        x_final = !minecraft_limit_text_position || minecraft_text_offset_x == 0
            ? x_requested : (x_min <= x_max ? min(max(x_requested, x_min), x_max) : center_x);
        y_final = !minecraft_limit_text_position || minecraft_text_offset_y == 0
            ? y_requested : (y_min <= y_max ? min(max(y_requested, y_min), y_max) : center_y);
        translate([x_final, y_final])
            text(text = name_text, size = fitted_size, font = font_choice,
                 halign = "center", valign = "center");
    } else
        translate([text_position()[0] + spiderman_text_offset_x,
                   text_position()[1] + spiderman_text_offset_y])
            text(text = name_text, size = font_size, font = font_choice,
                 halign = "center", valign = "center");
}

// Expand the final positioned text once to keep the outline aligned.
module text_outline_2d() {
    if (theme == "spiderman")
        offset(r = is_keychain ? 1.0 : 1.6)
            text_core_2d();
}


// ==========================================================================
// UNICORN THEME
// Self-contained geometry: the original two themes remain unchanged.
// Curved outlines are sampled from cubic Bezier segments. No external SVGs,
// font icons, or mesh imports are required.
// ==========================================================================
function u_bezier(p0,p1,p2,p3,t) =
    (1-t)*(1-t)*(1-t)*p0 + 3*(1-t)*(1-t)*t*p1 +
    3*(1-t)*t*t*p2 + t*t*t*p3;

module u_curve(start,segments) {
    polygon(concat([start],[
        for(i=[0:len(segments)-1], j=[1:12])
            u_bezier(i==0?start:segments[i-1][2],
                segments[i][0],segments[i][1],segments[i][2],j/12)
    ]));
}

module u_stroke(points,w=1.8) {
    for(i=[0:len(points)-2])
        hull() {
            translate(points[i]) circle(d=w,$fn=20);
            translate(points[i+1]) circle(d=w,$fn=20);
        }
}

module u_sparkle(r=3) {
    polygon([for(i=[0:7]) let(a=90+i*45,rr=i%2==0?r:r*0.31)
        [rr*cos(a),rr*sin(a)]]);
}



















// A tiny geometric seed survives only when the complete star fits.
// Hulls reconstruct its eight wedges instead of clipping the star itself.
module u_star_seed(p,r) {
    intersection() {
        square([0.02,0.02],center=true);
        translate(-p) offset(r=-(r+0.05/u_fs)) u_horse_star_space();
    }
}
function u_star_point(r,i) =
    let(a=90+i*45,rr=i%2==0?r:r*0.31) [rr*cos(a),rr*sin(a)];
module u_whole_star(p,r) {
    if (r*u_fs >= 1.4)
        translate(p)
            for (i=[0:7])
                hull() {
                    u_star_seed(p,r);
                    translate(u_star_point(r,i)) u_star_seed(p,r);
                    translate(u_star_point(r,i+1)) u_star_seed(p,r);
                }
}


// Layout values are independent of the Spider-Man/Minecraft calculations.
u_full = unicorn_variant=="full_horse";
u_top = unicorn_variant=="head_top";
u_inside = unicorn_variant=="inside";
u_chars = max(1,len(name_text));
u_h = auto_size ? (is_keychain?28:50) : manual_height;
u_mount = !is_keychain && mount_holes;
u_border = is_keychain?1.4:2.2;
u_r = min(u_h/4,8);
u_head_ref_h = 56;
u_head_ref_w = 76;
u_width = auto_size ?
    (u_full ? (is_keychain?max(72,min(115,50+u_chars*4)):
                 max(155,min(250,105+u_chars*12))) :
        max(is_keychain?70:125,
            (is_keychain?9:16)*u_chars*.85+
            (u_inside?(is_keychain?28:44):0)+
            (u_mount?36:20))) : manual_width;
// Full horse has a fixed aspect ratio; manual width controls its total size.
u_fs = (u_full && is_keychain ? max(72,u_width) : u_width)/150;
u_factor = unicorn_motif_scale/100;
u_hs = u_top ? min(u_h*.95/u_head_ref_h*u_factor,u_width*.68/u_head_ref_w) :
    min((u_h-2*(u_border+2))/u_head_ref_h*u_factor,u_width*.36/u_head_ref_w);
u_left = -u_width/2+(u_mount?17:0)+u_border+3;
u_head_x = u_top?0:u_left+38*u_hs;
u_head_y = u_top?u_h/2-5:-24*u_hs;
u_text_left = u_inside?u_head_x+38*u_hs+4:
    -u_width/2+u_border+(u_mount?16:5);
u_text_right = u_width/2-u_border-(u_mount?16:5);
u_text_w = max(1,u_text_right-u_text_left);
u_text_x = (u_full?-3*u_fs:(u_text_left+u_text_right)/2) + unicorn_text_offset_x;
u_text_y = (u_full?3*u_fs:0) + unicorn_text_offset_y;
u_font = u_full?min(18,(u_mount?52:70)/u_chars)*u_fs:
    min(u_h*.44,u_text_w/(u_chars*.88));
u_outline = is_keychain?.55:.85;

u_base_color = use_theme_palette?"#FBE7F4":custom_base_color;
u_dark_color = use_theme_palette?"#653884":custom_detail_color;
u_name_color = use_theme_palette?"#FFFFFF":custom_text_color;
u_gold_color = use_theme_palette?"#F2B84D":custom_accent_color;

module u_scaled_head() {
    translate([u_head_x,u_head_y]) scale([u_hs,u_hs]) children();
}
module u_scaled_horse() {
    scale([u_fs,u_fs]) children();
}
module u_round_plate() {
    offset(r=u_r) square([u_width-2*u_r,u_h-2*u_r],center=true);
}
// Keychain attachment anchors and adjustable hole location.
function u_keyhole_anchor() = u_full ?
    [-24,36]*u_fs : [-u_width/2+4,0];
function u_keyhole_default() =
    unicorn_keyhole_position=="loop" ?
        (u_full ? [-10,48]*u_fs : [-u_width/2-2,0]) :
    u_full ?
        (unicorn_keyhole_position=="mane" ? [-20,36] : [-24,30])*u_fs :
        [u_head_x,u_head_y]+
            (unicorn_keyhole_position=="mane" ? [17.5,10] : [13.5,6])*u_hs;
function u_keyhole_xy() = u_keyhole_default()+
    [unicorn_keyhole_offset_x,unicorn_keyhole_offset_y];

// Connect the movable loop to a stable anchor; the 12 mm boss has a 4.5 mm hole.
// The support is invisible inside the existing base. If a user moves the
// hole close to or beyond the edge, a rounded local extension keeps it attached.
module u_keyhole_support() {
    hull() {
        translate(u_keyhole_default()) circle(d=7.7,$fn=64);
        translate(u_keyhole_xy()) circle(d=7.7,$fn=64);
    }
}

module u_keychain_loop() {
    hull() {
        translate(u_keyhole_anchor()) circle(d=7.5,$fn=64);
        translate(u_keyhole_xy()) circle(d=12,$fn=64);
    }
}
module u_base() {
    union() {
        if(u_full) u_scaled_horse() u_horse_shape();
        else {
            u_round_plate();
            if(u_top) u_scaled_head() u_head_shape();
        }
        if(is_keychain) {
            if(unicorn_keyhole_position=="loop") u_keychain_loop();
            else u_keyhole_support();
        }
    }
}
module u_border_shape() {
    difference() {
        u_round_plate();
        offset(delta=-u_border) u_round_plate();
        if(u_top) u_scaled_head() u_head_shape();
    }
}
module u_name() {
    translate([u_text_x,u_text_y])
        text(name_text,size=u_font,font="Liberation Sans:style=Bold",
            halign="center",valign="center");
}
module u_dark() {
    // Close tangential contacts in the assembled inset artwork.
    if (u_inside) offset(delta=-0.16) offset(delta=0.16) u_dark_raw();
    else u_dark_raw();
}
module u_dark_raw() {
    if(u_full) u_scaled_horse() u_horse_dark();
    else {
        u_border_shape();
        u_scaled_head() u_head_dark();
    }
    if(has_text) offset(r=u_outline) u_name();
}
module u_gold() {
    if(u_full) u_scaled_horse() u_horse_gold();
    else {
        u_scaled_head() u_head_gold();
        if(unicorn_show_stars && u_h>=26) {
            translate([u_text_x-u_text_w*.32,-u_h/2+u_border+4])
                u_sparkle(is_keychain?1.8:2.8);
            translate([u_text_x+u_text_w*.32,u_h/2-u_border-4])
                u_sparkle(is_keychain?1.8:2.8);
        }
    }
}
module u_highlights() {
    if(u_full) u_scaled_horse() u_horse_highlights();
    else u_scaled_head() u_head_highlights();
}
module u_holes() {
    if(is_keychain)
        translate(concat(u_keyhole_xy(),[-1]))
            cylinder(h=base_thickness+relief_height+2,d=4.5,$fn=64);
    else if(mount_holes)
        for(x=u_full?[-23*u_fs,23*u_fs]:[-u_width/2+9,u_width/2-9])
            translate([x,u_full?-2*u_fs:0,-1])
                cylinder(h=base_thickness+relief_height+2,d=hole_diameter);
}
module u_clipped() {
    intersection() { u_base(); children(); }
}
module unicorn_nametag() {
    difference() {
        union() {
            color(u_base_color)
                linear_extrude(height=base_thickness) u_base();
            color(u_dark_color)
                translate([0,0,base_thickness])
                linear_extrude(height=relief_height*.72) u_clipped() u_dark();
            color(u_gold_color)
                translate([0,0,base_thickness])
                linear_extrude(height=relief_height*.8) u_clipped() u_gold();
            color(u_base_color)
                translate([0,0,base_thickness])
                linear_extrude(height=relief_height*.9)
                u_clipped() u_highlights();
            if(has_text)
                color(u_name_color)
                    translate([0,0,base_thickness])
                    linear_extrude(height=relief_height) u_clipped() u_name();
        }
        u_holes();
    }
}


// Complete unicorn silhouette and matching relief artwork.
module u_horse_shape() {
    offset(r=0.35) offset(delta=-0.35)
        polygon([[-75,71.64],[-50.48,50.37],[-52.33,47.97],[-53.8,47.58],[-52.02,46.50],[-49.63,46.73],[-49.86,44.49],[-48.08,42.01],[-50.86,34.28],[-52.49,32.58],[-53.34,30.64],[-53.18,27.47],[-51.87,25.30],[-49.24,24.38],[-46.69,24.92],[-45.53,26.16],[-44.91,28.09],[-40.58,29.87],[-35.86,34.51],[-33.46,32.50],[-32.14,29.79],[-31.83,26.23],[-32.53,22.75],[-36.55,14.40],[-37.48,11.38],[-37.48,8.36],[-35.70,2.17],[-35.86,0.16],[-36.78,-0.46],[-45.68,0.16],[-50.86,-0.30],[-51.95,-1.77],[-54.27,-8.97],[-57.67,-15.77],[-54.58,-26.84],[-53.57,-27.53],[-51.56,-25.91],[-50.71,-23.51],[-51.10,-20.11],[-51.64,-19.41],[-53.26,-19.41],[-53.26,-18.25],[-49.94,-9.12],[-47.46,-5.25],[-43.21,-6.10],[-32.84,-10.20],[-28.74,-8.50],[-27.58,-8.50],[-25.64,-10.51],[-24.72,-14.15],[-24.79,-18.17],[-26.11,-23.12],[-29.13,-30.08],[-29.20,-34.88],[-33.46,-45.40],[-37.71,-50.82],[-39.03,-54.53],[-33.38,-55.30],[-31.83,-54.92],[-31.37,-52.91],[-31.83,-50.12],[-29.59,-47.65],[-28.82,-41.61],[-23.71,-33.33],[-22.55,-28.46],[-19.77,-22.50],[-17.14,-14.23],[-6.46,-14.07],[2.75,-12.99],[6.54,-18.09],[8.86,-25.91],[12.96,-35.11],[12.88,-39.29],[10.64,-46.33],[8.86,-49.97],[6.30,-51.98],[4.68,-55.92],[10.25,-55.77],[10.87,-53.29],[11.87,-52.67],[13.04,-50.58],[19.30,-33.49],[18.99,-31.24],[16.21,-26.22],[15.05,-21.03],[15.51,-16.16],[18.14,-8.27],[19.15,-7.50],[32.61,-17.63],[36.17,-21.03],[44.13,-33.41],[46.92,-42.38],[50.32,-48.73],[54.65,-53.14],[56.36,-52.21],[57.75,-50.04],[57.59,-47.88],[55.58,-45.01],[53.18,-44.63],[46.53,-30.24],[44.75,-22.58],[42.28,-20.57],[39.41,-15.15],[37.79,-10.51],[37.48,-5.64],[36.47,-1.07],[32.22,10.68],[34,10.22],[35.31,8.90],[36.86,2.72],[40.11,-1.46],[45.84,-5.10],[51.17,-6.88],[52.10,-11.05],[55.20,-15.23],[57.75,-16.93],[61.38,-18.09],[64.25,-17.78],[66.18,-15.85],[68.73,-16.39],[71.36,-19.33],[72.45,-24.36],[73.84,-22.74],[74.69,-20.26],[74.38,-16.86],[72.45,-12.91],[74.69,-10.13],[74.54,-6.64],[73.76,-5.25],[70.59,-8.50],[67.96,-9.58],[66.10,-9.43],[63.86,-8.04],[63.16,-6.57],[63.40,-0.46],[62,3.41],[59.30,6.35],[55.20,7.98],[57.28,8.83],[58.29,10.14],[58.60,12.54],[57.83,15.56],[56.20,12.70],[54.27,12.70],[52.33,14.86],[49.24,20.35],[47.46,21.82],[44.44,22.75],[40.88,22.67],[37.33,21.75],[34.85,20.28],[31.52,17.26],[28.74,16.56],[24.10,19.81],[18.45,21.13],[11.33,20.90],[0.19,18.96],[-2.20,22.06],[-4.37,22.67],[-6.69,22.60],[-7.77,23.37],[-7.54,33.66],[-8.86,36.83],[-11.10,39.38],[-9.01,40.62],[-8.08,43.41],[-8.78,42.56],[-10.33,42.17],[-13.27,42.48],[-14.74,43.17],[-16.05,44.80],[-18.06,49.44],[-19.53,51.14],[-23.32,53.08],[-26.96,53.39],[-26.26,54.31],[-26.26,55.63],[-27.58,57.80],[-30.44,58.88],[-29.36,57.56],[-29.28,56.25],[-30.29,54.93],[-31.52,54.47],[-37.64,55.01],[-40.19,54.24],[-44.37,56.71],[-43.98,55.09],[-44.29,52.23]]);
}
module u_horse_horn() {
    intersection() {
        u_horse_shape();
        polygon([[-80,75],[-43,52],[-50,49],[-76,67]]);
    }
}
module u_horse_mane() {
    intersection() {
        u_horse_shape();
        u_curve([-54,47],[
            [[-49,56],[-41,60],[-32,60]],
            [[-13,61],[-5,48],[-5,38]],
            [[-4,30],[-5,24],[1,19]],
            [[-9,16],[-18,24],[-20,32]],
            [[-23,43],[-30,48],[-37,48]],
            [[-42,47],[-48,42],[-54,47]]
        ]);
    }
}
module u_horse_tail() {
    intersection() {
        u_horse_shape();
        u_curve([28.5,16.5],[
            [[40,29],[72,26],[79,11]],
            [[85,-1],[84,-22],[72,-28]],
            [[53,-28],[37,-6],[32,10]],
            [[30,13],[29,15],[28.5,16.5]]
        ]);
    }
}
module u_horse_dark() {
    difference() {
        union() {
            u_horse_mane();
            u_horse_tail();
            if(unicorn_eye_style=="open") {
                translate([-42.8,40.65]) rotate(-22) scale([1.95,2.55]) circle(r=1,$fn=48);
                if(unicorn_eye_lashes) u_stroke([[-41.35,42.0],[-40.55,42.55],[-40.1,43.1]],0.72);
            } else {
                u_stroke([for(t=[0:0.05:1]) u_bezier([-45.0,41.4],[-43.5,39.5],[-41.5,39.65],[-39.8,41.5],t)],1.05);
                if(unicorn_eye_lashes) u_stroke([[-40.6,40.9],[-39.4,42.1]],0.75);
            }
            translate([-50.1,31.3]) rotate(-25) scale([1.2,0.7]) circle(r=1,$fn=28);
            u_stroke([for(t=[0:0.05:1]) u_bezier([-51.0, 28.1],[-49.5, 27.25],[-47.5, 27.4],[-46.25, 28.8],t)],0.95);
            polygon([[-57,-21],[-49,-20],[-48,-31],[-58,-31]]);
            polygon([[-41,-49],[-30,-49],[-30,-57],[-41,-57]]);
            polygon([[4,-51],[13,-51],[13,-57],[4,-57]]);
            polygon([[49,-47],[59,-45],[61,-53],[53,-56]]);
        }
        u_horse_horn();
    }
}
module u_horse_highlights() {
    if(unicorn_eye_style=="open") translate([-43.35,41.55]) circle(r=0.78,$fn=32);
    for(t=[0.26,0.48,0.70]) {
        p=[-75+26*t,71.64-20*t];
        translate(p) rotate(-55) square([4.5,0.85],center=true);
    }
    u_stroke([for(t=[0:0.05:1]) u_bezier([-35,54],[-21,54],[-17,43],[-15,36],t)],1.45);
    u_stroke([for(t=[0:0.05:1]) u_bezier([-15,33],[-15,27],[-10,24],[-5,23],t)],1.45);
    u_stroke([for(t=[0:0.05:1]) u_bezier([36,17],[48,23],[48,8],[56,6],t)],1.6);
    u_stroke([for(t=[0:0.05:1]) u_bezier([45,8],[43,-1],[58,-4],[61,-13],t)],1.6);
    u_stroke([for(t=[0:0.05:1]) u_bezier([60,-9],[61,-16],[69,-15],[72,-19],t)],1.4);
}
module u_horse_star_space() {
    difference() {
        intersection() { offset(delta=-1.2) u_horse_shape(); translate([-3,3]) square([54,30],center=true); }
        if(has_text) scale([1/u_fs,1/u_fs]) offset(delta=0.8+u_outline) u_name();
        offset(delta=1) u_horse_dark();
    }
}
module u_horse_gold() {
    u_horse_horn();
    if(unicorn_show_stars)
        for(star=[[-21,13,2.3],[-8,15,2], [7,14,2.8],[21,12,2.1],[19,-8,2.2]])
            let(p=[star[0],star[1]],r=star[2])
                if(r*u_fs>=1.4)
                    u_whole_star(p,r);
}

// The full horse and both head layouts share one silhouette and artwork.
module u_head_region() {
    polygon([[-85,80],[4,80],[4,21],[0,19],[-8,17],[-21,16],[-36,17],[-85,17]]);
}
module u_head_local() {
    translate([37.5,-20]) intersection() { u_head_region(); children(); }
}
module u_head_shape() {
    u_head_local() u_horse_shape();
}
module u_head_dark() {
    difference() {
        union() {
            u_head_local() u_horse_dark();
            // Outline makes the pale head legible against the plate.
            if(u_inside) difference() { u_head_shape(); offset(delta=-1.05) u_head_shape(); }
        }
        u_head_gold();
    }
}
module u_head_gold() {
    u_head_local() u_horse_horn();
}
module u_head_highlights() {
    u_head_local() u_horse_highlights();
}
