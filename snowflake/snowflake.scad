/* ==========================================================================

   Parametric Snowflake Ornament Generator
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs

   DESCRIPTION
   -----------
   Thirty-six numbered snowflake designs in three families:
     Gallery 1: Classic and Minimal (designs 1-12)
     Gallery 2: Crystalline and Geometric (designs 13-24)
     Gallery 3: Organic and Intricate (designs 25-36)


   PRINTING AND AUTOMATIC SIZE ADAPTATION
   --------------------------------------
   Units: millimeters. Set snowflake_diameter first. Main-arm thickness,
   branch thickness/length, hub, decorative rings and hanger dimensions
   scale automatically, while printable minimum widths are respected.
   Fewer branch pairs and secondary twigs are generated for small ornaments.
   The proportion factors below adjust the shape, NOT absolute millimeters.
  ========================================================================== */

/* [Ornament and display] */
ornament_type = "flat"; // [flat:Flat ornament, interlocking:Two-panel 3D ornament]
// View mode applies to an individual design and to the selected gallery.
view_mode = "print"; // [print:Print layout, assembled:Assembly preview]
// Select a gallery independently; None shows the single chosen design.
gallery = "none"; // [none:No gallery, gallery_1:Gallery 1 - Classic, gallery_2:Gallery 2 - Crystalline, gallery_3:Gallery 3 - Intricate]
part_selection = "both"; // [both:Both panels, panel_a:Top-slotted panel A, panel_b:Bottom-slotted panel B]
// Catalog uses design_number (1-36). Named styles and procedural remain available.
snowflake_style = "catalog"; // [catalog:36 numbered designs, procedural:Seeded generator, classic:Classic, crystal:Crystal, fern:Fern, dendrite:Dendrite, stellar:Stellar, needle:Needle, lace:Lace, plate:Plate, geometric:Geometric, coral:Coral, willow:Willow]
design_number = 1; // [1:1:36]
variation_seed = 17; // [0:1:99999]

/* [Snowflake dimensions] */
// Diameter is the primary size setting; everything decorative follows it.
snowflake_diameter = 90; // [30:5:300]
// Keep material thickness independent: it controls printed strength and slot fit.
panel_thickness = 2.4; // [1.6:0.2:4]
// Minimum printable line width; default supports three 0.4 mm extrusion lines.
minimum_feature_width = 1.2; // [0.8:0.2:2.0]
print_spacing = 12; // [4:1:30]

/* [Geometry proportions] */
// 1.00 reproduces the original 90 mm reference proportions. Smaller/larger
// diameters change the geometry automatically; these factors tune its style.
arm_thickness_factor = 1.00; // [0.60:0.05:1.60]
branch_thickness_factor = 1.00; // [0.60:0.05:1.60]
branch_length_factor = 1.00; // [0.60:0.05:1.60]
branch_density_factor = 1.00; // [0.60:0.05:1.50]
center_size_factor = 1.00; // [0.65:0.05:1.35]
center_line_factor = 1.00; // [0.65:0.05:1.40]

/* [Procedural branching] */
branch_angle = 45; // [20:1:75]
branch_variation = 0.25; // [0:0.05:0.45]
// Automatic detail reduction for small snowflakes prevents clogged branches.
// Factor 1.00 is recommended; more detail is only added when space permits.
detail_factor = 1.00; // [0.00:0.25:1.50]
resolution = 28; // [12:4:64]

/* [Center decoration] */
show_hexagon = true;
center_pattern = "hexagon"; // [hexagon:Hexagonal ring, double_hexagon:Two hexagonal rings, circle:Circular ring, star:Six-point star, none:No frame]
hexagon_radius_ratio = 0.40; // [0.25:0.01:0.55]
flat_center_cutout = false;

/* [Hanging feature] */
// The hanging feature is always attached directly to a selected radial arm.
hanger_style = "arm_hole"; // [arm_hole:Reinforced hole in arm, arm_loop:Ring on arm tip, none:No hanging feature]
hanger_arm_index = 1; // [0:1:5]
// Hanger dimensions are also scaled to the chosen ornament size.
// The hole retains a 2.2 mm minimum for thin cord at miniature sizes.
hanger_size_factor = 1.00; // [0.75:0.05:1.40]

/* [Surface finish] */
// Convex clips the complete snowflake against a single spherical-cap lens.
surface_finish = "flat"; // [flat:Flat upper surface, convex:Convex raised upper surface]
convex_height = 1.0; // [0.2:0.2:2.6]
// Number of radial slices in the continuous spherical-cap roof.
// More slices improve finish but make the 3D Boolean slower.
convex_steps = 18; // [8:2:32]

/* [Colored accent / multi-material inlay] */
// Color follows the narrow branch centerlines, not a filled hub disk.
// Through-body mode creates TWO COMPLEMENTARY printable material bodies,
// without overlapping volumes. Import exported Base and Accent as parts of
// one object in the slicer, keeping their shared coordinates unchanged.
// Overlay mode retains the optional old top/bottom surface icing.
accent_enabled = false;
accent_color = "#6EC9EF";
accent_sides = "both"; // [top:Top side, bottom:Bottom side, both:Both sides]
// Through-body is the recommended mode for precise multi-material slicing.
accent_construction = "through"; // [through:Through-body material, overlay:Surface-only icing]
// Follow matches the base surface and its convex lens. Raised adds extra height.
accent_height_mode = "follow"; // [follow:Same thickness as snowflake, raised:Raised color]
accent_raise_sides = "both"; // [top:Top side, bottom:Bottom side, both:Both sides]
// Raised extension on selected face(s), relative to the panel thickness.
accent_raise_factor = 0.10; // [0:0.05:0.75]
// Automatic accent height: a fraction of the structural panel thickness.
accent_height_factor = 0.25; // [0.05:0.05:0.50]
// 0 uses automatic height; any positive value overrides it in millimeters.
// Extremely thin values (e.g. 0.01 mm) are preview-only for most FDM printers.
accent_thickness = 0; // [0:0.01:2.00]
// Relative length of the branch tracing, retaining the same design topology.
accent_scale = 0.99; // [0.80:0.01:1.00]
// Relative narrowing of the accent lines: 0.45 means 55% of the branch width.
// Unlike a millimeter offset, this ratio scales with snowflake diameter.
accent_inset = 0.45; // [0:0.05:0.75]
// Minimum width of the color trace (mm), typically 0.45-0.50 for a 0.4 nozzle.
accent_min_line_width = 0.44; // [0.40:0.02:1.20]
// Further reduce the tracing over the thicker six main arms and central hub.
accent_main_arm_factor = 0.75; // [0.40:0.05:1.00]
accent_center_factor = 0.75; // [0.40:0.05:1.00]
// In Through mode, export Base and Accent separately as two slicer parts.
// The two legacy side exports work only in Overlay mode.
export_component = "all"; // [all:Show both materials, base:Base only, accent:Through-body accent only, accent_top:Overlay top only, accent_bottom:Overlay bottom only]

/* [Interlocking fit] */
slot_clearance = 0.30; // [0.10:0.05:0.80]

/* [Assembly preview] */
assembled_second_color = "#93D2F3";

/* [Hidden] */
$fn = resolution;
R = snowflake_diameter / 2;
raised_height = surface_finish == "convex" ? convex_height : 0;
// One material height is used in all geometry and interlocking-slot calculations.
accent_height = accent_thickness > 0 ? accent_thickness :
                panel_thickness * accent_height_factor;
overlay_color = accent_enabled && accent_construction == "overlay";
through_color = accent_enabled && accent_construction == "through";
accent_raise_height = panel_thickness * accent_raise_factor;
accent_top_height = overlay_color && accent_sides != "bottom" ? accent_height :
                    through_color && accent_height_mode == "raised" &&
                    accent_raise_sides != "bottom" ? accent_raise_height : 0;
accent_bottom_height = overlay_color && accent_sides != "top" ? accent_height :
                       through_color && accent_height_mode == "raised" &&
                       accent_raise_sides != "top" ? accent_raise_height : 0;
// All exported material bodies share one coordinate system. Their combined
// outside height determines the width of interlocking slots.
full_panel_height = panel_thickness + raised_height + accent_top_height + accent_bottom_height;
slot_width = full_panel_height + slot_clearance;

// Relative values follow the 90 mm reference design, with physical minimums.
// The center has enough material around the two-part assembly slot.
arm_width = max(minimum_feature_width * 1.25,
                snowflake_diameter * 0.040 * arm_thickness_factor);
branch_width = max(minimum_feature_width,
                   snowflake_diameter * (2.1 / 90) * branch_thickness_factor);
branch_length = snowflake_diameter * (12 / 90) * branch_length_factor;
center_radius = max(snowflake_diameter * (7 / 90) * center_size_factor,
                    slot_width / 2 + arm_width / 2 + minimum_feature_width * 0.55);
hexagon_width = max(minimum_feature_width,
                    snowflake_diameter * (2.2 / 90) * center_line_factor);
ring_r = R * hexagon_radius_ratio;

// Independent printability cap: no more branches than the diameter can fit.
branch_pairs = clamp(round(snowflake_diameter / 22 * branch_density_factor), 2, 6);
max_branch_pairs = clamp(floor(snowflake_diameter / 12.5 * branch_density_factor), 2, 8);
size_detail_cap = snowflake_diameter < 45 ? 0 : snowflake_diameter < 80 ? 1 : 2;

hanger_hole_diameter = max(2.2, min(4.5,
                            snowflake_diameter * (3.2 / 90) * hanger_size_factor));
hanger_wall = max(minimum_feature_width,
                  snowflake_diameter * (1.8 / 90) * hanger_size_factor);
hanger_outer_diameter = max(hanger_hole_diameter + 2 * hanger_wall,
                            snowflake_diameter * 0.10 * hanger_size_factor);
hole_boss_radius = hanger_hole_diameter / 2 + hanger_wall;
hanger_inset = max(snowflake_diameter * (5.5 / 90),
                   hole_boss_radius + minimum_feature_width * 0.5);
hole_position = R - hanger_inset;
slot_end = R + hanger_outer_diameter + max(2, snowflake_diameter * 0.055);

assert(accent_scale > 0 && accent_scale <= 1 && accent_height > 0 &&
       accent_inset >= 0 && accent_inset < 0.80,
       "Choose a valid relative accent scale, width and height.");
assert(!overlay_color || accent_height <= panel_thickness,
       "The surface icing must not be thicker than the structural base.");
assert(accent_raise_factor >= 0 && accent_raise_factor <= 0.75 &&
       accent_min_line_width >= 0.40,
       "Invalid accent height factor or printable line width.");
assert(design_number >= 1 && design_number <= 36, "Design number must be 1-36.");
assert(snowflake_diameter >= 30 && panel_thickness > 0,
       "Choose a diameter of at least 30 mm and a positive panel thickness.");
assert(center_radius > slot_width / 2 + arm_width / 2,
       "Cannot fit a structurally sound center hub around the assembly slot.");
assert(ring_r > center_radius + minimum_feature_width * 0.45,
       "Reduce center size/height or increase diameter for the center frame.");
assert(hanger_style != "arm_hole" ||
       hole_position > ring_r + hole_boss_radius + minimum_feature_width * 0.2,
       "Hanger and center frame require a larger diameter or smaller proportions.");
assert(hanger_style != "arm_loop" ||
       hanger_outer_diameter >= hanger_hole_diameter + 2 * hanger_wall,
       "The hanging ring wall needs more material.");

// A reproducible pseudo-random value. It changes branching but not symmetry.
function noise(seed, step) =
    let(v = sin((seed + 19) * 91.17 + (step + 7) * 137.49) * 43758.5453)
    v - floor(v);
function jitter(seed, step) = (noise(seed, step) * 2 - 1) * branch_variation;
function clamp(x, lo, hi) = max(lo, min(hi, x));
function xy_polar(r, a) = [r * cos(a), r * sin(a)];
function design_group(n) = n <= 12 ? 1 : n <= 24 ? 2 : 3;
function design_style(n) =
    ["classic", "needle", "stellar", "crystal", "geometric", "plate",
     "lace", "willow", "coral", "fern", "dendrite", "crystal",
     "crystal", "geometric", "lace", "plate", "stellar", "needle",
     "geometric", "crystal", "lace", "plate", "stellar", "coral",
     "fern", "dendrite", "coral", "willow", "lace", "dendrite",
     "fern", "coral", "dendrite", "willow", "fern", "lace"][clamp(n, 1, 36) - 1];
function chosen_style(n, seed) =
    snowflake_style == "catalog" ? design_style(n) :
    snowflake_style == "procedural" ?
      ["classic", "crystal", "fern", "dendrite", "stellar", "needle",
       "lace", "plate", "geometric", "coral", "willow"][seed % 11] :
    snowflake_style;
// Each design uses its own stable branching fingerprint.
function design_seed(n, seed) = seed + 197 * n;
function style_density(style) =
    style == "dendrite" ? 1.35 : style == "needle" ? 1.25 :
    style == "stellar" ? 0.85 : style == "plate" ? 0.55 :
    style == "geometric" ? 0.80 : style == "coral" ? 1.10 : 1;
function style_angle(style) =
    style == "needle" ? 24 : style == "willow" ? 65 :
    style == "coral" ? 53 : style == "stellar" ? 60 : branch_angle;
function style_length(style) =
    style == "needle" ? 0.67 : style == "plate" ? 0.55 :
    style == "geometric" ? 0.71 : style == "dendrite" ? 1.15 :
    style == "willow" ? 1.18 : 1;
// Design-specific topology and proportions make these more than 36 random seeds.
function design_count(n, style) =
    let(group = design_group(n), local_n = (n - 1) % 12)
    clamp(round(branch_pairs * style_density(style) +
        (group == 1 ? -1 + local_n % 3 :
         group == 2 ? local_n % 3 : 1 + local_n % 3)), 1, max_branch_pairs);
function design_fork_count(n) =
    snowflake_style == "catalog" ?
    min(round((design_group(n) == 3 ? 2 :
               design_group(n) == 2 ? 1 + n % 2 : 1) * detail_factor),
        size_detail_cap) :
    min(round(detail_factor), size_detail_cap);
function design_angle_offset(n) =
    snowflake_style == "catalog" ? [-12, -6, 0, 7, 14, -3][n % 6] : 0;
function design_span(n) =
    snowflake_style == "catalog" ? [0.76, 1.04, 1.19, 0.93][n % 4] : 1;
function design_motif(n) = snowflake_style == "catalog" ? n % 6 : 0;
function safe_y(x, y) = clamp(y, -x * tan(25), x * tan(25));

module strut(a, b, width) {
    hull() {
        translate(a) circle(d = width);
        translate(b) circle(d = width);
    }
}
module diamond(center_x, center_y, size_x, size_y) {
    translate([center_x, center_y])
        polygon([[-size_x, 0], [0, size_y], [size_x, 0], [0, -size_y]]);
}

// One branch pair, mirrored about the main arm. All endpoints stay inside
// a 50-degree sector, leaving open space between adjacent snowflake arms.
module branch_pair(n, seed, style, index, count,
                   width_factor = 1, min_line_width = minimum_feature_width) {
    x0 = R * (0.27 + (0.53 * index / max(1, count - 1)));
    len = min(branch_length * style_length(style) * design_span(n) *
              clamp(1 + jitter(seed, index * 7 + 5), 0.60, 1.40), R * 0.34);
    theta = clamp(style_angle(style) + design_angle_offset(n) +
                  15 * jitter(seed, index * 7 + 9), 18, 74);
    x1 = min(R - max(minimum_feature_width * 0.75, arm_width * 0.35),
             x0 + len * cos(theta));
    y1 = safe_y(x1, len * sin(theta));
    width = max(min_line_width,
                branch_width * (style == "needle" ? 0.8 : 1) * width_factor);
    detail = design_fork_count(n);
    for (side = [-1, 1]) {
        strut([x0, 0], [x1, side * y1], width);
        // Crystalline elbow geometry, still supported by the primary strut.
        if (design_group(n) == 2 && design_motif(n) == 1)
            strut([x0 + (x1 - x0) * 0.45, side * y1 * 0.45],
                  [min(R - 1.2, x1 + len * 0.12), side * safe_y(x1, y1 * 0.78)],
                  max(min_line_width, width * 0.80));
        if (detail > 0 && (style == "fern" || style == "dendrite" ||
                           style == "lace" || style == "willow" ||
                           style == "coral" || design_group(n) == 3))
            for (j = [0 : detail - 1]) {
                t = (j + 1) / (detail + 1);
                ax = x0 + (x1 - x0) * (0.38 + 0.52 * t);
                ay = y1 * (0.38 + 0.52 * t);
                bx = min(R - 1.2, ax + len * (0.20 + 0.07 * t));
                by = safe_y(bx, ay + len * (0.13 + 0.07 * noise(seed, 51 + j + index)));
                strut([ax, side * ay], [bx, side * by], max(min_line_width, width * 0.78));
            }
        if ((style == "coral" || style == "stellar") && detail > 0) {
            x2 = min(R - 1.0, x1 + len * 0.15);
            strut([x1 - 0.6, side * y1],
                  [x2, side * safe_y(x2, y1 + len * 0.11)], max(min_line_width, width * 0.77));
        }
        if (design_group(n) >= 2 && design_motif(n) == 2 && index % 2 == 0)
            diamond(x1 - minimum_feature_width * 0.28, side * y1,
                    max(min_line_width * 0.75, R * 0.033 * width_factor),
                    max(min_line_width * 0.80, R * 0.038 * width_factor));
    }
}

module arm_2d(n, seed, style,
              width_factor = 1, min_line_width = minimum_feature_width,
              main_arm_factor = 1) {
    count = design_count(n, style);
    tip_x = R - arm_width / 2;
    strut([0, 0], [tip_x, 0],
          max(min_line_width, arm_width * width_factor * main_arm_factor));
    for (i = [0 : count - 1])
        branch_pair(n, seed, style, i, count, width_factor, min_line_width);

    // Optional spine features distinguish needle, crystal and fern designs.
    if (style == "crystal" || style == "geometric" || design_motif(n) == 3)
        diamond(R - arm_width * 1.2, 0,
                arm_width * 1.0 * width_factor,
                arm_width * 0.85 * width_factor);
    if (style == "needle" || (design_group(n) == 2 && design_motif(n) == 4))
        for (i = [0 : 2], side = [-1, 1]) {
            x = R * (0.38 + 0.16 * i);
            strut([x, 0], [x + R * 0.095, side * R * 0.065],
                  max(min_line_width, branch_width * 0.8 * width_factor));
        }
    // Short spine diamonds imitate facets in highly crystalline designs.
    if (design_group(n) == 2 && design_motif(n) == 5)
        for (i = [0 : 2])
            diamond(R * (0.41 + i * 0.18), 0,
                    arm_width * 0.6 * width_factor,
                    arm_width * 0.47 * width_factor);
}

module hex_frame(r, width) {
    for (a = [0 : 60 : 300])
        strut(xy_polar(r, a), xy_polar(r, a + 60), width);
}
module center_frame_2d(n, style) {
    if (show_hexagon && center_pattern != "none") {
        if (center_pattern == "hexagon" || center_pattern == "double_hexagon")
            hex_frame(ring_r, hexagon_width);
        if (center_pattern == "double_hexagon")
            hex_frame(ring_r * 0.69, max(minimum_feature_width, hexagon_width * 0.8));
        if (center_pattern == "circle")
            difference() { circle(r = ring_r); circle(r = ring_r - hexagon_width); }
        if (center_pattern == "star")
            for (a = [0 : 60 : 300])
                strut(xy_polar(ring_r, a), xy_polar(ring_r * 0.56, a + 30), hexagon_width);
    }
    if (style == "plate") {
        circle(r = max(center_radius + max(minimum_feature_width,
                                            snowflake_diameter * (3 / 90)),
                       ring_r * 0.80), $fn = 6);
        for (a = [0 : 60 : 300]) rotate(a)
            strut([0, 0], [R * 0.65, 0], arm_width * 1.55);
    }
    if (style == "lace" || (design_group(n) >= 2 && n % 4 == 0))
        hex_frame(ring_r * 0.67, max(minimum_feature_width, hexagon_width * 0.75));
    if (design_group(n) == 2 && n % 3 == 0)
        for (a = [0 : 60 : 300])
            // Extend across the hub boundary rather than merely touching it;
            // exact tangency at 30 mm produces non-manifold STL edges.
            strut(xy_polar(min(ring_r * 0.50, center_radius), a + 30),
                  xy_polar(ring_r, a), max(minimum_feature_width, hexagon_width * 0.70));
    if (design_group(n) == 3 && n % 4 == 1)
        hex_frame(ring_r * 0.79, max(1.6, hexagon_width * 0.80));
}

module arm_hanger_solid_2d() {
    if (hanger_style == "arm_hole")
        translate([hole_position, 0]) circle(r = hole_boss_radius);
    else if (hanger_style == "arm_loop") {
        loop_center = R + hanger_outer_diameter * 0.28;
        strut([R - arm_width, 0], [loop_center, 0],
              max(arm_width, hanger_wall * 2));
        translate([loop_center, 0]) circle(d = hanger_outer_diameter);
    }
}
module arm_hanger_hole_2d() {
    if (hanger_style == "arm_hole")
        translate([hole_position, 0]) circle(d = hanger_hole_diameter);
    else if (hanger_style == "arm_loop")
        translate([R + hanger_outer_diameter * 0.28, 0])
            circle(d = hanger_hole_diameter);
}

module snowflake_solid_2d(n, seed, with_hanger) {
    style = chosen_style(n, seed);
    union() {
        circle(r = center_radius);
        for (a = [0 : 60 : 300]) rotate(a) arm_2d(n, design_seed(n, seed), style);
        center_frame_2d(n, style);
        if (with_hanger && hanger_style != "none")
            rotate(hanger_arm_index * 60) arm_hanger_solid_2d();
    }
}
module slot_2d(direction) {
    if (direction == "top")
        translate([-slot_width / 2, 0]) square([slot_width, slot_end]);
    else if (direction == "bottom")
        translate([-slot_width / 2, -slot_end]) square([slot_width, slot_end]);
}
module snowflake_profile_2d(slot_direction, with_hanger, n, seed) {
    difference() {
        snowflake_solid_2d(n, seed, with_hanger);
        if (slot_direction != "none") slot_2d(slot_direction);
        if (with_hanger && hanger_style != "none")
            rotate(hanger_arm_index * 60) arm_hanger_hole_2d();
        if (slot_direction == "none" && flat_center_cutout)
            circle(d = min(5, center_radius * 0.9), $fn = 6);
    }
}

// A single spherical cap acts as a roof over the ENTIRE snowflake silhouette.
// Intersecting it with the extruded 2D profile trims every branch to the same
// continuous lens: the center is thickest and the tips taper to base thickness.
// The flat radial skirt retains the outermost arm edges and the hanging loop.
module spherical_lens_volume(with_hanger, body_height = panel_thickness) {
    lens_radius = R + ((with_hanger && hanger_style == "arm_loop") ?
                       hanger_outer_diameter * 0.28 : 0);
    outer_radius = R + hanger_outer_diameter + arm_width + branch_width;
    sphere_radius = (lens_radius * lens_radius + convex_height * convex_height)
                    / (2 * convex_height);
    rotate_extrude(convexity = 12, $fn = max(64, resolution * 3))
        polygon(points = concat(
            [[0, 0], [outer_radius, 0],
             [outer_radius, body_height], [lens_radius, body_height]],
            [for (step = [convex_steps - 1 : -1 : 0])
                let(r = lens_radius * step / convex_steps)
                [r, body_height + sqrt(max(0, sphere_radius * sphere_radius - r * r))
                    - (sphere_radius - convex_height)]
            ]));
}

// Trace the SAME branch grammar as the structural body, but replace the filled
// center disk with six connected, slender radial spokes. This avoids the large
// block of accent color in the hub and reduces the width of all thick branches.
// Each line width is proportional to its original branch, not a fixed mm offset.
// Clip to the unchanged panel footprint so slots, hanging holes and outer edges
// remain intact for multicolor slicing and interlocking assembly.
module accent_profile_2d(slot_direction, with_hanger, n, seed) {
    style = chosen_style(n, seed);
    accent_ratio = max(0.20, 1 - accent_inset);
    accent_min_width = max(accent_min_line_width, minimum_feature_width * 0.35);
    intersection() {
        snowflake_profile_2d(slot_direction, with_hanger, n, seed);
        scale([accent_scale, accent_scale])
            union() {
                for (a = [0 : 60 : 300]) rotate(a)
                    arm_2d(n, design_seed(n, seed), style,
                           accent_ratio, accent_min_width,
                           accent_main_arm_factor);
                // Connect all six traced arms without recreating a filled hub.
                circle(d = max(accent_min_width,
                               arm_width * accent_ratio *
                               accent_main_arm_factor * accent_center_factor));
            }
    }
}

// Envelope between the original spherical lens roof and the same roof raised
// by one accent thickness. A revolved strip is far cheaper than subtracting two
// 3D lenses; unlike raised lines, it conforms to ALL snowflake branches.
module spherical_lens_accent_shell(with_hanger) {
    lens_radius = R + ((with_hanger && hanger_style == "arm_loop") ?
                       hanger_outer_diameter * 0.28 : 0);
    outer_radius = R + hanger_outer_diameter + arm_width + branch_width;
    sphere_radius = (lens_radius * lens_radius + convex_height * convex_height)
                    / (2 * convex_height);
    rotate_extrude(convexity = 12, $fn = max(64, resolution * 3))
        polygon(points = concat(
            [[0, panel_thickness + convex_height + accent_top_height]],
            [for (step = [1 : convex_steps])
                let(r = lens_radius * step / convex_steps)
                [r, panel_thickness + sqrt(max(0, sphere_radius * sphere_radius - r * r))
                    - (sphere_radius - convex_height) + accent_top_height]],
            [[outer_radius, panel_thickness + accent_top_height],
             [outer_radius, panel_thickness], [lens_radius, panel_thickness]],
            [for (step = [convex_steps - 1 : -1 : 0])
                let(r = lens_radius * step / convex_steps)
                [r, panel_thickness + sqrt(max(0, sphere_radius * sphere_radius - r * r))
                    - (sphere_radius - convex_height)]]
        ));
}

// Single structural solid before the color-volume partition. On convex
// variants this includes every branch clipped by the original spherical lens.
module panel_core_shape(slot_direction, with_hanger, n, seed) {
    if (surface_finish == "convex")
        intersection() {
            linear_extrude(height = panel_thickness + raised_height + 0.02, convexity = 12)
                snowflake_profile_2d(slot_direction, with_hanger, n, seed);
            spherical_lens_volume(with_hanger);
        }
    else
        linear_extrude(height = panel_thickness, convexity = 12)
            snowflake_profile_2d(slot_direction, with_hanger, n, seed);
}

// The long cutter creates a genuine through-body cavity for the other color.
// Subtract across the full roof, leaving no coincident horizontal cap faces.
module accent_full_depth_cutter(slot_direction, with_hanger, n, seed) {
    translate([0, 0, -0.05])
        linear_extrude(height = panel_thickness + raised_height + 0.10, convexity = 12)
            accent_profile_2d(slot_direction, with_hanger, n, seed);
}

// The base and accent are spatially complementary: neither overlaps the other.
module panel_base(slot_direction, with_hanger, n, seed) {
    translate([0, 0, accent_bottom_height])
        if (through_color)
            difference() {
                panel_core_shape(slot_direction, with_hanger, n, seed);
                accent_full_depth_cutter(slot_direction, with_hanger, n, seed);
            }
        else
            panel_core_shape(slot_direction, with_hanger, n, seed);
}

// The other filament takes the *same* through-cut profile, trimmed to the
// original exact convex roof. Optional top and bottom extensions are attached
// to this same body instead of making more independent overlay bodies.
module panel_through_accent(slot_direction, with_hanger, n, seed) {
    // A single color body, continuous from the underside to the lens roof.
    // No coincident 3D unions, even when the accent is raised on both faces.
    if (surface_finish == "convex")
        intersection() {
            linear_extrude(height = full_panel_height + 0.02, convexity = 12)
                accent_profile_2d(slot_direction, with_hanger, n, seed);
            spherical_lens_volume(with_hanger,
                                  panel_thickness + accent_top_height + accent_bottom_height);
        }
    else
        linear_extrude(height = full_panel_height, convexity = 12)
            accent_profile_2d(slot_direction, with_hanger, n, seed);
}

// Upper accent follows the actual spherical cap rather than standing above it
// on unrelated ribs; the flat setting uses an ordinary extruded layer.
module panel_top_accent(slot_direction, with_hanger, n, seed) {
    translate([0, 0, accent_bottom_height])
        if (surface_finish == "convex")
            intersection() {
                linear_extrude(height = panel_thickness + raised_height + accent_top_height + 0.02,
                               convexity = 12)
                    accent_profile_2d(slot_direction, with_hanger, n, seed);
                spherical_lens_accent_shell(with_hanger);
            }
        else
            translate([0, 0, panel_thickness])
                linear_extrude(height = accent_top_height, convexity = 12)
                    accent_profile_2d(slot_direction, with_hanger, n, seed);
}

// The bottom material starts on the print bed so a multicolor printer can
// deposit this color first, then the body, then the upper accent.
module panel_bottom_accent(slot_direction, with_hanger, n, seed) {
    linear_extrude(height = accent_bottom_height, convexity = 12)
        accent_profile_2d(slot_direction, with_hanger, n, seed);
}

// Export the two non-overlapping materials separately for slicer assembly.
// In Overlay mode the older individual upper/lower exports remain available.
module printable_panel(slot_direction, with_hanger, n = design_number,
                       seed = variation_seed, panel_color = "#E8F5FF") {
    if (export_component == "all" || export_component == "base")
        color(panel_color) panel_base(slot_direction, with_hanger, n, seed);
    if (accent_enabled) {
        if (through_color) {
            if (export_component == "all" || export_component == "accent")
                color(accent_color)
                    panel_through_accent(slot_direction, with_hanger, n, seed);
        } else {
            if (accent_top_height > 0 &&
                (export_component == "all" || export_component == "accent_top"))
                color(accent_color) panel_top_accent(slot_direction, with_hanger, n, seed);
            if (accent_bottom_height > 0 &&
                (export_component == "all" || export_component == "accent_bottom"))
                color(accent_color) panel_bottom_accent(slot_direction, with_hanger, n, seed);
        }
    }
}

module print_layout(n = design_number, seed = variation_seed, selected_parts = part_selection) {
    if (ornament_type == "flat") printable_panel("none", true, n, seed);
    else {
        pitch = snowflake_diameter + hanger_outer_diameter + print_spacing;
        if (selected_parts == "both" || selected_parts == "panel_a")
            translate([selected_parts == "both" ? -pitch / 2 : 0, 0, 0])
                printable_panel("top", false, n, seed);
        if (selected_parts == "both" || selected_parts == "panel_b")
            translate([selected_parts == "both" ? pitch / 2 : 0, 0, 0])
                printable_panel("bottom", true, n, seed, assembled_second_color);
    }
}
// Center both perpendicular panels on the same geometric origin.
// The assembly preview is not an STL print layout; keeping its central
// crossing at [0, 0, 0] also centers each item inside the gallery grid.
module assembled_preview(n = design_number, seed = variation_seed, selected_parts = part_selection) {
    if (ornament_type == "flat") printable_panel("none", true, n, seed);
    else {
        if (selected_parts == "both" || selected_parts == "panel_a")
            rotate([90, 0, 0])
                translate([0, 0, -full_panel_height / 2])
                    printable_panel("top", false, n, seed, "#E8F5FF");
        if (selected_parts == "both" || selected_parts == "panel_b")
            rotate([0, 0, 90]) rotate([90, 0, 0])
                translate([0, 0, -full_panel_height / 2])
                    printable_panel("bottom", true, n, seed, assembled_second_color);
    }
}

// Each gallery follows View mode and Ornament type. Both interlocking parts
// are always shown in the gallery, regardless of single-design part selection.
module gallery_ornament(n) {
    if (view_mode == "assembled") assembled_preview(n, variation_seed, "both");
    else print_layout(n, variation_seed, "both");
}
module gallery_preview(group) {
    two_panel_print = ornament_type == "interlocking" && view_mode == "print";
    scale_factor = two_panel_print ? 0.28 : 0.38;
    layout_width = two_panel_print ?
        2 * snowflake_diameter + hanger_outer_diameter + print_spacing :
        snowflake_diameter + hanger_outer_diameter;
    pitch_x = layout_width * scale_factor + 17;
    pitch_y = (snowflake_diameter + hanger_outer_diameter) * scale_factor + 19;
    for (i = [0 : 11]) {
        n = (group - 1) * 12 + i + 1;
        row = floor(i / 4);
        column = i % 4;
        translate([(column - 1.5) * pitch_x, (1 - row) * pitch_y, 0]) {
            scale(scale_factor) gallery_ornament(n);
            // Numbering is for visual selection only; it is never exported.
            translate([0, -R * scale_factor - 6.0, 0])
                linear_extrude(height = 0.6)
                    text(str("Design ", n), size = 3.5,
                         halign = "center", valign = "center");
        }
    }
}

if (gallery == "gallery_1") gallery_preview(1);
else if (gallery == "gallery_2") gallery_preview(2);
else if (gallery == "gallery_3") gallery_preview(3);
else if (view_mode == "assembled") assembled_preview();
else print_layout();
