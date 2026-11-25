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

// Head and neck, facing left. Rounded muzzle, cheeks, ears and a swept mane.
// All artwork below uses the same normalized coordinates.
module u_face() {
    u_curve([-13,0],[
        [[-11,7],[-13,14],[-20,19]],
        [[-24,22],[-29,20],[-35,23]],
        [[-40,25],[-40,30],[-35,33]],
        [[-29,37],[-24,45],[-18,51]],
        [[-14,56],[-8,58],[-2,57]],
        [[-3,62],[-2,67],[1,68]],
        [[5,66],[8,61],[9,55]],
        [[20,52],[25,41],[24,29]],
        [[24,16],[17,8],[15,0]],
        [[7,-3],[-5,-3],[-13,0]]
    ]);
}

module u_mane() {
    u_curve([-12,52],[
        [[-3,62],[12,62],[20,52]],
        [[31,45],[30,34],[25,29]],
        [[34,25],[32,16],[26,11]],
        [[34,7],[28,-2],[17,-3]],
        [[8,-6],[1,-1],[2,5]],
        [[13,10],[15,17],[12,24]],
        [[9,31],[17,38],[10,44]],
        [[4,49],[-5,45],[-12,52]]
    ]);
}

module u_horn() {
    u_curve([-20,49],[
        [[-22,57],[-26,68],[-25,74]],
        [[-23,75],[-16,63],[-10,52]],
        [[-13,49],[-17,48],[-20,49]]
    ]);
}

module u_head_shape() {
    union() { u_face(); u_mane(); u_horn(); }
}

module u_eye() {
    if (unicorn_eye_style == "open") {
        // Large friendly eye, with a separate highlight above the dark layer.
        translate([-18.5,36.5]) rotate(-12) scale([0.86,1.12]) circle(r=4.1,$fn=48);
        u_stroke([[-21.3,39],[-24.2,41.8]],1.5);
        u_stroke([[-19.2,40.2],[-20.7,43]],1.4);
    } else {
        u_stroke([[-23,37],[-21,35.4],[-18,35],[-15,36],[-13,38]],2.0);
        u_stroke([[-22,36],[-24,38.5]],1.7);
        u_stroke([[-19,35.4],[-20,39]],1.5);
    }
    // Muzzle and smile.
    translate([-34,28.9]) scale([1.2,.8]) circle(r=1.35,$fn=24);
    u_stroke([[-36,25.2],[-33,23.8],[-29,24.2]],1.5);
    // Interior of ear.
    u_curve([1,57],[
        [[1,60],[1,64],[2,64]],
        [[4,62],[6,59],[6,56]],
        [[4,55],[2,56],[1,57]]
    ]);
}

module u_head_dark() {
    difference() {
        union() {
            u_mane();
            u_eye();
            difference() {
                u_face();
                offset(delta=-1.25) u_face();
                translate([-45,-9]) square([70,23]);
            }
        }
        u_horn();
    }
}

module u_head_gold() {
    u_horn();
}

module u_head_highlights() {
    if (unicorn_eye_style == "open")
        translate([-19.7,38.4]) circle(r=1.65,$fn=32);
    // Flowing locks cut into the raised mane and decorative horn ridges.
    u_stroke([[16,49],[22,45],[24,40],[23,35]],1.7);
    u_stroke([[23,28],[27,24],[26,19],[21,14]],1.7);
    u_stroke([[25,10],[26,6],[22,2],[16,0]],1.7);
    for(t=[0.28,0.52,0.75])
        translate([-19-5*t,51+21*t])
            rotate(-31) square([5.2,1.2],center=true);
}

// Complete unicorn, with a generously sized torso for the name.
// The silhouette uses softly curved limbs and a broad, swept tail.
module u_horse_body() {
    u_curve([-42,6],[
        [[-34,18],[-16,24],[4,24]],
        [[18,24],[32,22],[43,23]],
        [[56,24],[64,16],[63,5]],
        [[62,-5],[52,-10],[38,-11]],
        [[18,-12],[-2,-12],[-18,-11]],
        [[-31,-10],[-40,-5],[-42,6]]
    ]);
}

// Continuous shoulder and neck transition; overlaps the head and torso.
module u_neck_bridge() {
    hull() {
        translate([-34,8]) scale([1.0,1.15]) circle(r=9,$fn=36);
        translate([-18,14]) scale([1.25,1.0]) circle(r=11,$fn=36);
        translate([-10,10]) scale([1.35,0.95]) circle(r=10,$fn=36);
    }
}

module u_front_leg(x,dy=0) {
    u_back_leg(x,dy);
}

module u_back_leg(x,dy=0) {
    translate([x,dy]) scale([0.72,1]) u_curve([-9,6],[
        [[-12,-5],[-10,-13],[-5,-20]],
        [[0,-26],[1,-29],[-1,-34]],
        [[-3,-38],[-5,-40],[-6,-42]],
        [[-7,-43.5],[-6,-44],[-4,-44]],
        [[0,-44],[5,-44],[8,-44]],
        [[10,-44],[11,-43],[10,-41]],
        [[8,-37],[9,-33],[12,-28]],
        [[16,-20],[14,-12],[10,-5]],
        [[7,1],[6,5],[3,7]],
        [[-1,9],[-6,9],[-9,6]]
    ]);
}

// Solid hoof caps follow the leg outline; slightly sloping upper edges.
module u_hoof(x,dy=0,rear=false) {
    intersection() {
        if (rear) u_back_leg(x,dy);
        else u_front_leg(x,dy);
        translate([x,dy]) polygon([[-18,-48],[20,-48],[20,-37.8],[-18,-39.2]]);
    }
}

module u_tail() {
    u_curve([53,16],[
        [[67,26],[80,23],[81,9]],
        [[82,-3],[70,-5],[72,-15]],
        [[74,-20],[79,-20],[84,-17]],
        [[83,-31],[67,-35],[61,-25]],
        [[54,-14],[64,-7],[65,2]],
        [[65,9],[61,12],[53,9]],
        [[50,10],[50,14],[53,16]]
    ]);
}

module u_full_head() {
    translate([-33,7]) scale([0.86,0.86]) children();
}

module u_horse_shape() {
    union() {
        u_horse_body();
        u_neck_bridge();
        u_full_head() u_head_shape();
        u_front_leg(-27,0);
        u_front_leg(-8,3);
        u_back_leg(25,3);
        u_back_leg(49,0);
        u_tail();
    }
}

module u_horse_dark() {
    u_full_head() difference() { offset(delta=0.12) offset(delta=-0.12) u_head_dark(); offset(delta=0.02) u_horn(); }
    u_tail();
    u_hoof(-27,0);
    u_hoof(-8,3);
    u_hoof(25,3,true);
    u_hoof(49,0,true);
}

// Space for complete sparkles, expressed in normalized horse coordinates.
module u_horse_star_space() {
    difference() {
        offset(delta=-1.2) u_horse_body();
        if (has_text)
            scale([1/u_fs,1/u_fs])
                offset(delta=0.8+u_outline) u_name();
        offset(delta=1) u_horse_dark();
    }
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
module u_horse_stars() {
    if (unicorn_show_stars)
        for (star=[[4,17,2.4],[21,17.5,3.0],[33,18,2.0],[43,10,2.6],[38,-6.5,2.3]])
            u_whole_star([star[0],star[1]],is_keychain ? max(star[2],1.45/u_fs) : star[2]);
}
module u_horse_gold() {
    u_full_head() u_head_gold();
    u_horse_stars();
}

module u_horse_highlights() {
    u_full_head() u_head_highlights();
    u_stroke([[62,16],[70,13],[73,7],[70,1]],2.0);
    u_stroke([[67,-8],[64,-16],[66,-23],[72,-26]],2.0);
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
u_head_ref_h = 78;
u_width = auto_size ?
    (u_full ? (is_keychain?max(72,min(115,50+u_chars*4)):
                 max(155,min(250,105+u_chars*12))) :
        max(is_keychain?70:125,
            (is_keychain?9:16)*u_chars*.85+
            (u_inside?(is_keychain?28:44):0)+
            (u_mount?36:20))) : manual_width;
// Full horse has a fixed aspect ratio; manual width controls its total size.
u_fs = u_width/150;
u_factor = unicorn_motif_scale/100;
u_hs = u_top ? min(u_h*.95/78*u_factor,u_width*.68/70) :
    min((u_h-2*(u_border+2))/78*u_factor,u_width*.36/70);
u_left = -u_width/2+(u_mount?17:0)+u_border+3;
u_head_x = u_top?0:u_left+36*u_hs;
u_head_y = u_top?u_h/2-5:-(71/2)*u_hs;
u_text_left = u_inside?u_head_x+34*u_hs+4:
    -u_width/2+u_border+(u_mount?16:5);
u_text_right = u_width/2-u_border-(u_mount?16:5);
u_text_w = max(1,u_text_right-u_text_left);
u_text_x = (u_full?6*u_fs:(u_text_left+u_text_right)/2) + unicorn_text_offset_x;
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
module u_tab() {
    if(is_keychain)
        translate(u_full?[-65*u_fs,31*u_fs]:[-u_width/2-2,0])
            circle(d=12);
}
module u_base() {
    union() {
        if(u_full) u_scaled_horse() u_horse_shape();
        else {
            u_round_plate();
            if(u_top) u_scaled_head() u_head_shape();
        }
        u_tab();
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
    if (u_inside) offset(delta=-0.10) offset(delta=0.10) u_dark_raw();
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
        translate(concat(u_full?[-65*u_fs,31*u_fs]:[-u_width/2-2,0],[-1]))
            cylinder(h=base_thickness+relief_height+2,d=4.5);
    else if(mount_holes)
        for(x=u_full?[-26*u_fs,46*u_fs]:[-u_width/2+9,u_width/2-9])
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
