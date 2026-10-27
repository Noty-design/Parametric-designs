/* ========================================================================== 

   High-Voltage Insulator Model for 3D Printing
   Designed by Notydesign
   License: CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
   Source: https://github.com/Noty-design/Parametric-designs
   
   DESCRIPTION
   -----------
   This is a parametric model of a high-voltage suspension-insulator chain.
   It can be configured as a single decorative insulator or as a longer chain
   assembled from repeated ceramic and metal units.  Optional connector styles,
   attachment holes, and dimension annotations make the model useful for display
   pieces, earrings, keychains, scale scenes, and related decorative projects.

   COORDINATE SYSTEM AND UNITS
   ---------------------------
   All dimensions are in millimetres.  The chain runs along the global Z axis,
   with its total body height centred around Z=0 by isolator_chain().  X and Y
   span the circular cross-section.  Positive Z points toward the top fitting.

   MODEL STRUCTURE
   ---------------
   Each repeated unit consists of a central metal rod, two end caps, a stack of
   ceramic plates, and optional connector geometry.  The ceramic plates can use
   either a traditional profile or a support-conscious FDM profile.  Calculated
   dimensions below the Customizer parameters keep all repeated units aligned.

   PRINTING NOTES
   --------------
   The support-friendly plate profile is intended to reduce severe underside
   overhangs, but suitable orientation, layer height, and support settings still
   depend on the selected dimensions and printer.  Preview colours are visual
   aids only; STL export does not retain OpenSCAD colour assignments.

   This file is intentionally heavily commented so that future parameter and
   geometry changes are easier to understand and make safely.
   ========================================================================== */ 


/* [Chain] */

// Number of complete insulator units in the vertical chain.
// Increasing this value repeats the ceramic stack, fittings, and applicable
// connector components while preserving insulator_gap between adjacent units.
insulator_count = 1;              // [1:1:20]

// Number of ceramic plates, or sheds, in each repeated insulator unit.
plates_per_insulator = 4;         // [1:1:14]

// Clear axial distance reserved between the bodies of adjacent units.
// Connector geometry is centred inside this gap.
insulator_gap = 26;               // [8:1:60]

// Selects how neighbouring units are connected:
// - full_rings: one complete torus and central joining pin per internal gap;
// - half_donuts: complementary semicircular links attached to unit ends;
// - none: no generated connector links.
link_style = "half_donuts";       // [full_rings, half_donuts, none]

// Adds otherwise-unpaired half links to the outermost ends of the chain.
// Internal half links are generated regardless of this setting when required.
show_end_half_links = false;      // [true, false]

/* [Dimension Display] */

// Controls the optional printable/visible dimension annotations:
// - off: no annotations;
// - first_insulator: annotate only the first unit;
// - all_insulators: repeat the annotations for every unit.
dimension_display = "first_insulator"; // [off, first_insulator, all_insulators]

// Clearance between the model envelope and its dimension lines.
dimension_offset = 9;             // [3:1:40]

// Character size used for generated height and width labels.
dimension_text_size = 3;          // [1.5:0.5:12]

// Radius of the cylindrical dimension lines and ticks.
// The leading underscore marks this as an advanced/internal-style control.
_dimension_line_radius = 0.18;    // [0.08:0.02:1]

// Length of the perpendicular ticks at dimension endpoints.
_dimension_tick_length = 2.5;     // [1:0.5:10]

// Number of decimal places shown in generated dimension text.
// Supported values are zero, one, or two decimal places.
_dimension_decimals = 1;          // [0:1:2]

// Preview colour shared by all dimension lines, ticks, and labels.
dimension_color = "DeepSkyBlue";  // 24

/* [Holes for Custom Links] */

// Subtracts transverse through-holes from selected end caps so external rings,
// wire, cord, or user-designed links can be fitted after printing.
custom_link_holes_enabled = true; // [true, false]

// Chooses whether holes appear only at the two chain extremities or at both
// end caps of every individual insulator unit.
custom_link_hole_placement = "chain_ends"; // [chain_ends, every_insulator_end]

// Radius of each custom-link hole; the finished diameter is twice this value.
custom_link_hole_radius = 1.8;    // [0.8:0.1:8]

// Rotates the horizontal hole axis around Z when viewed from above.
custom_link_hole_rotation_z = 0;  // [0:5:175]

// Normalized axial position within an end cap: 0.5 places the hole halfway
// through the cap height, while lower or higher values shift it toward an edge.
custom_link_hole_cap_position = 0.5; // [0.15:0.05:0.85]

// Extra cutter length beyond the cap diameter, ensuring a clean through-hole
// even when cap dimensions or hole direction are changed.
custom_link_hole_extra_cut = 6;   // [1:1:20]

/* [Half-Link Rotation] */

// Global X rotation applied to every half link.  This tilts the link forward or
// backward relative to the chain axis.
half_link_rotation_x = 0;         // [-90:5:90]

// Global Y rotation applied to every half link, providing a sideways tilt.
half_link_rotation_y = 0;         // [-90:5:90]

// Global rotation around the chain's Z axis.
half_link_rotation_z = 0;         // [0:5:355]

// Additional Z rotation accumulated for each successive unit.  Non-zero values
// can produce a progressively twisted or helical-looking chain.
half_link_rotation_step_per_insulator = 0; // [-90:5:90]

// Lower-link-only X adjustment, added after the global X rotation.
lower_half_link_extra_rotation_x = 0; // [-90:5:90]

// Lower-link-only Y adjustment, added after the global Y rotation.
lower_half_link_extra_rotation_y = 0; // [-90:5:90]

// Lower-link-only Z adjustment, added to the global and per-unit rotations.
lower_half_link_extra_rotation_z = 0; // [-180:5:180]

// Upper-link-only X adjustment, added after the global X rotation.
upper_half_link_extra_rotation_x = 0; // [-90:5:90]

// Upper-link-only Y adjustment, added after the global Y rotation.
upper_half_link_extra_rotation_y = 0; // [-90:5:90]

// Upper-link-only Z adjustment, added to the global and per-unit rotations.
upper_half_link_extra_rotation_z = 0; // [-180:5:180]

/* [Ceramic Insulator Plates] */

// Maximum outside radius of each ceramic plate or shed.
plate_outer_radius = 4;           // [4:1:70]

// Radius of the central ceramic neck running through the plate stack.
plate_neck_radius = 2;            // [2:1:28]

// Axial thickness of the outer rim in the classic plate profile.
plate_rim_thickness = 1;          // [1:0.5:9]

// Overall axial height allocated to one ceramic plate profile.
plate_height = 2;                 // [3:1:24]

// Centre-to-centre axial spacing of neighbouring plates in one stack.
plate_spacing = 3;                // [4:1:28]

// Radius of the rounded bead around a classic plate's outer edge.
// This parameter is unused when support_friendly_plates is enabled.
edge_bead_radius = 0.5;           // [0.4:0.1:4]

// Selects the continuously curved, support-conscious FDM plate profile instead
// of the classic polygon-and-bead construction.
support_friendly_plates = true;   // [true, false]

// Shapes the lower transition of support-friendly plates.  A value of 1.0 is
// approximately equivalent to a 45-degree radial increase per millimetre.
plate_underside_slope = 1.0;      // [0.4:0.1:1.4]

// Exponent controlling how gently the outer radius expands upward.
// Higher values create a smoother, more convex upper transition.
plate_upward_rounding = 1.45;     // [0.8:0.05:2.5]

// Vertical depth of the bowl/cone from the upper rim toward the central neck.
plate_cone_depth = 1.65;          // [0.4:0.05:12]

// Small blending distance used around the neck, cone, and outer rim corners.
plate_cone_rounding = 0.22;       // [0:0.02:2]

// Axial thickness of the nearly vertical outer rim in support-friendly mode.
plate_support_rim_thickness = 0.55; // [0.1:0.05:4]

// Curvature exponent for the underside and inner bowl transitions.
// Higher values make the bowl appear deeper and more gently scooped.
plate_bowl_curve = 1.65;          // [0.7:0.05:3]

// Controls how filled the bowl is: 0 retains the deepest cavity, while 1 moves
// the inner low point close to the top and produces an almost flat upper bowl.
plate_bowl_fill = 0.12;           // [0:0.02:1]

// Number of sampled points in each curved section of the revolved profile.
// More steps improve smoothness at the cost of additional mesh complexity.
plate_profile_steps = 10;         // [5:1:24]

/* [Metal Hardware] */

// Radius of the continuous metal rod passing through each insulator unit.
center_rod_radius = 2;            // [1.5:0.1:10]

// Main radius of the cylindrical metal fitting at each end of a unit.
end_cap_radius = 3;               // [5:1:30]

// Axial height of each end cap.
end_cap_height = 4;               // [3:1:22]

// Radius of the terminal pin projecting beyond each end cap.
end_terminal_radius = 2.7;        // [0.8:0.1:20]

// Visible length of the terminal pin outside its end cap.
end_terminal_height = 2;          // [0.2:0.1:30]

// Deliberate overlap between adjoining solids.  It prevents coincident faces
// and helps boolean union operations produce connected printable geometry.
connection_overlap = 1;           // [0.2:0.1:5]

/* [Links] */

// Major radius from a link's centre to the centreline of its round section.
link_ring_radius = 3;             // [5:1:40]

// Minor radius, or material thickness, of full and partial torus links.
link_ring_thickness = 2;          // [1:0.2:10]

// Extra angular sweep added where complementary half links meet.  The overlap
// reduces gaps caused by exact semicircle boundaries.
half_link_overlap_angle = 8;      // [0:1:24]

// Radius of the reinforcing lug joining each half link to an end fitting.
link_lug_radius = 2;              // [2:0.2:12]

/* [Printing and Colour] */

// Global fragment count used by circles, cylinders, spheres, and toroidal
// shapes unless a primitive explicitly supplies its own resolution.
curve_resolution = 72;            // [24:12:144]

// Preview colours for ceramic, metal hardware, and connector components.
// These affect OpenSCAD display only and are not preserved in ordinary STL.
ceramic_color = "Ivory";          // 24
metal_color = "DimGray";          // 24
link_color = "SlateGray";         // 24

// Apply the selected circular resolution globally to subsequent primitives.
$fn = curve_resolution;

// ---------------------------------------------------------------------------
// Derived dimensions
// ---------------------------------------------------------------------------
// These values are calculated from the Customizer settings and should normally
// not be edited directly.  Keeping the relationships in one place ensures that
// repeated units, connectors, cutters, and annotations share the same layout.

// Axial extent from the bottom of the first ceramic plate to the top of the
// final plate.  Adjacent plate centres are separated by plate_spacing.
ceramic_stack_height = (plates_per_insulator - 1) * plate_spacing + plate_height;

// Total solid body height of one unit: ceramic stack plus two metal end caps.
unit_height = ceramic_stack_height + 2 * end_cap_height;

// Repetition pitch from the bottom of one unit to the bottom of the next.
unit_pitch = unit_height + insulator_gap;

// Combined height occupied by all unit bodies and all gaps between them.
// Optional terminal links and dimension annotations are deliberately excluded.
body_chain_height = insulator_count * unit_height + (insulator_count - 1) * insulator_gap;

// Conservative radial envelope used to position width annotations outside the
// widest relevant part.  The third candidate vanishes when links are disabled.
insulator_visual_radius = max(plate_outer_radius + edge_bead_radius, end_cap_radius * 1.08, link_style == "none" ? 0 : link_ring_radius + link_ring_thickness);

// Full annotated width is twice the radial envelope.
insulator_visual_width = insulator_visual_radius * 2;

// Prepare human-readable labels once so every repeated annotation uses the same
// rounding rules and exact text.  H means height and B means breadth/width.
dimension_text_height_string = str("H ", rounded_value(unit_height), " mm");
dimension_text_width_string = str("B ", rounded_value(insulator_visual_width), " mm");

// ---------------------------------------------------------------------------
// Top-level assembly
// ---------------------------------------------------------------------------
// The physical chain is always generated.  Dimension geometry is added as a
// separate union member only when requested by dimension_display.
union() {
    isolator_chain();
    if (dimension_display != "off")
        dimension_annotations();
}

// Rounds a numeric dimension to the configured display precision.
// Multiplication before round(), followed by matching division, preserves one
// or two decimal places without changing any actual model dimensions.
function rounded_value(value) =
    _dimension_decimals == 0 ? round(value) :
    _dimension_decimals == 1 ? round(value * 10) / 10 :
    round(value * 100) / 100;

// Builds, centres, and perforates the complete repeated insulator chain.
//
// The local construction starts at Z=0.  The outer translation moves the body
// midpoint to the global origin.  A difference() then subtracts optional custom
// link holes from the union of all unit bodies and full-ring connectors.
module isolator_chain() {
    // Centre the total body span around global Z=0.
    translate([0, 0, -body_chain_height / 2])
    difference() {
        union() {
            // Place one complete unit at each unit-pitch interval.
            for (insulator_index = [0 : insulator_count - 1]) {
                translate([0, 0, insulator_index * unit_pitch])
                    single_insulator(insulator_index);
            }

            // Full rings are chain-level parts because each ring belongs to the
            // gap between two units rather than to either individual unit.
            if (link_style == "full_rings" && insulator_count > 1) {
                for (link_index = [0 : insulator_count - 2]) {
                    // Centre the connector halfway through its corresponding gap.
                    link_center_z = (link_index + 1) * unit_pitch - insulator_gap / 2;
                    translate([0, 0, link_center_z])
                        // Apply global tilt plus any progressive per-gap twist.
                        rotate([half_link_rotation_x, half_link_rotation_y, half_link_rotation_z + link_index * half_link_rotation_step_per_insulator])
                            full_connector_link();
                }
            }
        }

        // Cut holes after unioning all selected solids so one cutter pass handles
        // every requested end cap consistently.
        if (custom_link_holes_enabled)
            custom_link_holes();
    }
}

// Generates the complete optional dimension overlay in the same local frame as
// the uncentred chain, then applies the chain's centring translation and colour.
module dimension_annotations() {
    translate([0, 0, -body_chain_height / 2])
    color(dimension_color)
    union() {
        if (dimension_display == "all_insulators") {
            // Repeat dimensions at each unit's local origin.
            for (dimension_index = [0 : insulator_count - 1]) {
                translate([0, 0, dimension_index * unit_pitch])
                    single_insulator_dimensions(dimension_index);
            }
        } else {
            // The first unit begins at local Z=0, so no translation is needed.
            single_insulator_dimensions(0);
        }
    }
}

// Creates height and width dimensions for one unit whose bottom is at local Z=0.
// dimension_index is retained in the interface for clarity and future extension;
// unit placement is currently handled by the caller's translate().
module single_insulator_dimensions(dimension_index) {
    // Position the height line beyond the unit's maximum radial envelope.
    height_line_x = insulator_visual_radius + dimension_offset;

    // Place the width line below the unit's lower end.
    width_line_z = -dimension_offset;

    // Shift all annotations toward the viewer-facing side to avoid the model.
    dimension_front_y = -insulator_visual_radius - dimension_offset * 0.8;

    // Give the labels additional clearance from their dimension lines.
    label_side_x = height_line_x + dimension_text_size * 2.1;
    label_bottom_z = width_line_z - dimension_text_size * 1.6;

    // Height dimension: a vertical line spanning the complete unit, including
    // both end caps, with endpoint ticks and a shorter centre reference tick.
    translate([height_line_x, dimension_front_y, unit_height / 2])
        cylinder(h=unit_height, r=_dimension_line_radius, center=true);
    translate([height_line_x, dimension_front_y, 0])
        x_dimension_tick(_dimension_tick_length);
    translate([height_line_x, dimension_front_y, unit_height])
        x_dimension_tick(_dimension_tick_length);
    translate([height_line_x, dimension_front_y, unit_height / 2])
        x_dimension_tick(_dimension_tick_length * 0.65);
    dimension_label([label_side_x, dimension_front_y, unit_height / 2], dimension_text_height_string, 90);

    // Width dimension: rotate a cylinder onto X so it spans the largest expected
    // diameter, including plates, fittings, and the selected link profile.
    translate([0, dimension_front_y, width_line_z])
        rotate([0, 90, 0])
            cylinder(h=insulator_visual_width, r=_dimension_line_radius, center=true);

    // Vertical ticks mark both width endpoints.
    translate([-insulator_visual_radius, dimension_front_y, width_line_z])
        z_dimension_tick(_dimension_tick_length);
    translate([insulator_visual_radius, dimension_front_y, width_line_z])
        z_dimension_tick(_dimension_tick_length);

    // Keep the width label centred beneath its dimension line.
    dimension_label([0, dimension_front_y, label_bottom_z], dimension_text_width_string, 0);
}

// Produces a tick aligned with X by rotating a centred Z-axis cylinder.
module x_dimension_tick(tick_length) {
    rotate([0, 90, 0])
        cylinder(h=tick_length, r=_dimension_line_radius, center=true);
}

// Produces a centred tick along Z; no rotation is required.
module z_dimension_tick(tick_length) {
    cylinder(h=tick_length, r=_dimension_line_radius, center=true);
}

// Converts a text string into thin 3D geometry at the requested position.
// The first rotation places the text plane vertically.  label_angle then rotates
// it within that plane so height and width labels remain readable.
module dimension_label(label_position, label_text, label_angle) {
    translate(label_position)
        rotate([90, 0, label_angle])
            // A shallow centred extrusion gives labels visible thickness on both
            // sides of their placement plane.
            linear_extrude(height=0.45, center=true)
                text(label_text, size=dimension_text_size, halign="center", valign="center");
}

// Places the negative cutter solids used by isolator_chain() to create custom
// attachment holes.  Coordinates in this module use the chain's uncentred local
// frame because the parent difference() applies centring afterward.
module custom_link_holes() {
    if (custom_link_hole_placement == "every_insulator_end") {
        // Generate one lower and one upper cap hole for each repeated unit.
        for (insulator_index = [0 : insulator_count - 1]) {
            // The lower position is measured upward from the unit's bottom.
            bottom_hole_z = insulator_index * unit_pitch + end_cap_height * custom_link_hole_cap_position;

            // The upper position mirrors the normalized cap offset downward from
            // the unit's top surface.
            top_hole_z = insulator_index * unit_pitch + unit_height - end_cap_height * custom_link_hole_cap_position;

            translate([0, 0, bottom_hole_z])
                horizontal_link_hole();
            translate([0, 0, top_hole_z])
                horizontal_link_hole();
        }
    } else {
        // In chain_ends mode, cut only the bottom of the first unit and the top
        // of the last unit, regardless of the number of intermediate units.
        bottom_hole_z = end_cap_height * custom_link_hole_cap_position;
        top_hole_z = (insulator_count - 1) * unit_pitch + unit_height - end_cap_height * custom_link_hole_cap_position;

        translate([0, 0, bottom_hole_z])
            horizontal_link_hole();
        translate([0, 0, top_hole_z])
            horizontal_link_hole();
    }
}

// Builds one horizontal cylindrical cutter through an end cap.
// The inner Y rotation changes the cylinder axis from Z to X.  The outer Z
// rotation then selects any desired direction in the global XY plane.
module horizontal_link_hole() {
    rotate([0, 0, custom_link_hole_rotation_z])
        rotate([0, 90, 0])
            // The added cutter length guarantees that both cap walls are crossed.
            cylinder(h=end_cap_radius * 2 + custom_link_hole_extra_cut, r=custom_link_hole_radius, center=true);
}

// Assembles one complete insulator body at a local base elevation of Z=0.
// insulator_index controls the progressive Z rotation and determines whether
// this unit is at a chain boundary when outer half links are hidden.
module single_insulator(insulator_index) {
    // Accumulate any requested twist as the chain index increases.
    base_half_link_rotation_z = half_link_rotation_z + insulator_index * half_link_rotation_step_per_insulator;

    union() {
        // The central rod and its internal overlap collars span the whole unit.
        color(metal_color)
            center_hardware(unit_height);

        // Ceramic geometry begins directly above the lower end cap.
        color(ceramic_color)
            translate([0, 0, end_cap_height])
                ceramic_stack();

        // Build lower and upper end caps in the same orientation-aware module.
        color(metal_color) {
            translate([0, 0, 0])
                end_cap(false);
            translate([0, 0, unit_height - end_cap_height])
                end_cap(true);
        }

        // Half-donut connectors belong to individual unit ends.  Adjacent units
        // contribute complementary halves that meet inside each chain gap.
        if (link_style == "half_donuts") {
            // Suppress the very bottom half unless exposed end links are enabled.
            if (show_end_half_links || insulator_index > 0) {
                translate([0, 0, -insulator_gap / 2])
                    // Combine global orientation, lower-only correction, and the
                    // unit's accumulated twist before creating the lower half.
                    rotate([
                        half_link_rotation_x + lower_half_link_extra_rotation_x,
                        half_link_rotation_y + lower_half_link_extra_rotation_y,
                        base_half_link_rotation_z + lower_half_link_extra_rotation_z
                    ])
                        half_donut_link("lower_half");
            }

            // Suppress the very top half unless exposed end links are enabled.
            if (show_end_half_links || insulator_index < insulator_count - 1) {
                translate([0, 0, unit_height + insulator_gap / 2])
                    // Apply the corresponding upper-only correction values.
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

// Builds the ceramic portion of one unit around a continuous central neck.
module ceramic_stack() {
    union() {
        // The slightly reduced radius avoids unwanted coplanar surfaces where the
        // individual plate hubs overlap the common ceramic core.
        cylinder(h=ceramic_stack_height, r=plate_neck_radius * 0.86);

        // Centre each plate within its allocated plate_height at regular spacing.
        for (plate_index = [0 : plates_per_insulator - 1]) {
            translate([0, 0, plate_index * plate_spacing + plate_height / 2])
                ceramic_plate();
        }
    }
}

// Dispatches to the requested ceramic plate construction.  Both variants are
// centred around their local Z=0 so ceramic_stack() can position them uniformly.
module ceramic_plate() {
    if (support_friendly_plates)
        support_friendly_ceramic_plate();
    else
        classic_ceramic_plate();
}

// Builds the traditional plate profile from a revolved six-point cross-section,
// a rounded outer bead, and a central reinforcing cylinder.
module classic_ceramic_plate() {
    union() {
        // Revolve the radial/Z profile around Z.  The points travel from the
        // lower axis outward, up around the rim, and back to the upper axis.
        rotate_extrude(convexity=10)
            polygon(points=[
                [0, -plate_height / 2],
                [plate_neck_radius * 0.90, -plate_height / 2],
                [plate_outer_radius, -plate_rim_thickness / 2],
                [plate_outer_radius, plate_rim_thickness / 2],
                [plate_neck_radius * 0.98, plate_height / 2],
                [0, plate_height / 2]
            ]);

        // Add a toroidal bead near the outer radius for a rounded edge detail.
        torus(plate_outer_radius - edge_bead_radius * 0.45, edge_bead_radius);

        // Overlap a central cylinder with the revolved profile to reinforce its
        // neck and ensure a robust union with the stack's continuous core.
        cylinder(h=plate_height * 1.15, r=plate_neck_radius, center=true);
    }
}

// ---------------------------------------------------------------------------
// Support-friendly ceramic profile calculations
// ---------------------------------------------------------------------------
// The following functions describe a two-dimensional radial/Z cross-section.
// support_friendly_ceramic_plate() samples these curves, concatenates the points
// into a closed polygon, and revolves that polygon around the Z axis.

// Restricts cone depth to a small positive value through the full plate height.
// This prevents an inverted or zero-height profile if parameters are customized
// outside the suggested Customizer range.
function clamped_plate_cone_depth() =
    min(plate_height, max(0.05, plate_cone_depth));

// Limits corner blending by the user request, available radial width, and cone
// depth.  The smallest limit wins so rounded transitions cannot cross each other.
function clamped_plate_cone_rounding() =
    min(
        plate_cone_rounding,
        (plate_outer_radius - plate_neck_radius) * 0.24,
        clamped_plate_cone_depth() * 0.35
    );

// Z coordinate of the plate's uppermost rim.
function plate_top_z() = plate_height / 2;

// Lowest Z coordinate of the bowl, derived from the clamped cone depth.
function plate_bowl_low_z() = plate_top_z() - clamped_plate_cone_depth();

// Lower edge of the outer vertical rim.  Rim thickness is capped to 65 percent
// of cone depth so it cannot consume the entire curved transition.
function plate_rim_bottom_z() =
    plate_top_z() - min(plate_support_rim_thickness, clamped_plate_cone_depth() * 0.65);

// Inner bowl floor after applying plate_bowl_fill.  Clamping the fill ratio to
// 0..1 keeps the point between the outer bowl low point and top rim.
function plate_bowl_inside_low_z() =
    plate_bowl_low_z() +
    (plate_top_z() - plate_bowl_low_z()) * min(1, max(0, plate_bowl_fill));

// Returns the radius of the lower outer surface at normalized progress t.
// t=0 starts at the neck and t=1 reaches plate_outer_radius.
function support_plate_bottom_radius(t) =
    plate_neck_radius +
    (plate_outer_radius - plate_neck_radius) *
    pow(t, plate_upward_rounding);

// Returns the Z coordinate of the lower outer surface at normalized progress t.
// plate_underside_slope affects the curve exponent and is protected from zero.
function support_plate_bottom_z(t) =
    plate_bowl_low_z() +
    (plate_rim_bottom_z() - plate_bowl_low_z()) *
    pow(t, plate_bowl_curve / max(0.1, plate_underside_slope));

// Returns the radius of the inner bowl at normalized progress t.  This uses the
// reciprocal bowl exponent so its curvature complements the Z interpolation.
function support_plate_inside_radius(t) =
    plate_neck_radius +
    (plate_outer_radius - plate_neck_radius) *
    pow(t, 1 / max(0.1, plate_bowl_curve));

// Returns the inner bowl's Z coordinate from its filled low point to the rim.
function support_plate_inside_z(t) =
    plate_bowl_inside_low_z() +
    (plate_top_z() - plate_bowl_inside_low_z()) *
    pow(t, plate_bowl_curve);

// Calculates a rounded top-surface radius.  This helper documents an alternate
// top curve and is available for future profile variants; the current polygon
// construction does not call it directly.
function support_plate_top_radius(t) =
    plate_neck_radius +
    (plate_outer_radius - plate_neck_radius) *
    (1 - pow(1 - t, plate_upward_rounding));

// Converts sample index i into one [radius, Z] point on the lower outer curve.
function support_plate_bottom_point(i) =
    let(t = i / plate_profile_steps)
    [
        support_plate_bottom_radius(t),
        support_plate_bottom_z(t)
    ];

// Converts sample index i into one [radius, Z] point on the inner bowl curve.
function support_plate_inside_point(i) =
    let(t = i / plate_profile_steps)
    [
        support_plate_inside_radius(t),
        support_plate_inside_z(t)
    ];

// Returns a point on an alternative sloping top profile.  Like
// support_plate_top_radius(), this helper is currently defined for experimentation
// and future variants but is not consumed by the active polygon.
function support_plate_top_point(i) =
    let(t = i / plate_profile_steps)
    [
        support_plate_top_radius(t),
        plate_height / 2 - t * plate_height * 0.42
    ];

// Constructs the FDM-oriented ceramic plate by revolving one closed profile.
// The polygon is assembled in traversal order: lower axis and neck transition,
// sampled underside, outer rim, reversed inner bowl, then back to the axis.
module support_friendly_ceramic_plate() {
    union() {
        rotate_extrude(convexity=10)
            // A local alias keeps the profile point expressions compact.
            let(r = clamped_plate_cone_rounding())
            polygon(points=concat(
                // Begin on the axis at the bowl's low elevation, move to the
                // neck, and introduce a rounded transition toward the underside.
                [
                    [0, plate_bowl_low_z()],
                    [plate_neck_radius, plate_bowl_low_z()],
                    [plate_neck_radius + r * 0.35, plate_bowl_low_z() + r * 0.10],
                    [plate_neck_radius + r, plate_bowl_low_z() + r * 0.45]
                ],

                // Sample the support-conscious underside from neck to outer rim.
                [for (i = [1 : plate_profile_steps]) support_plate_bottom_point(i)],

                // Travel vertically around the outer rim and start the return
                // toward the inner bowl with a small rounded inset.
                [
                    [plate_outer_radius, plate_rim_bottom_z() + r],
                    [plate_outer_radius, plate_top_z()],
                    [plate_outer_radius - r * 0.45, plate_top_z() - r * 0.08]
                ],

                // Reverse the sampled index so the polygon returns from the
                // outer edge toward the centre without crossing itself.
                [for (i = [plate_profile_steps - 1 : -1 : 1]) support_plate_inside_point(i)],

                // Blend back into the neck and finally close on the central axis.
                [
                    [plate_neck_radius + r, plate_bowl_inside_low_z() + r * 0.35],
                    [plate_neck_radius + r * 0.35, plate_bowl_inside_low_z() + r * 0.08],
                    [plate_neck_radius, plate_bowl_inside_low_z()],
                    [0, plate_bowl_inside_low_z()]
                ]
            ));

        // The overlapping neck cylinder strengthens the plate centre and ensures
        // reliable contact with the continuous core created by ceramic_stack().
        cylinder(h=plate_height * 1.15, r=plate_neck_radius, center=true);
    }
}

// Builds the continuous internal metal hardware for one complete unit.
// hardware_height normally equals unit_height, but remains an argument so this
// helper can be reused for another axial span if the design is extended.
module center_hardware(hardware_height) {
    union() {
        // Main rod running from the lower to the upper surface of the unit.
        cylinder(h=hardware_height, r=center_rod_radius);

        // Lower collar overlaps both the rod and lower end-cap region.
        translate([0, 0, end_cap_height - connection_overlap])
            cylinder(h=connection_overlap * 2, r=end_cap_radius * 0.82);

        // Upper collar mirrors the lower collar beneath the top end cap.
        translate([0, 0, hardware_height - end_cap_height - connection_overlap])
            cylinder(h=connection_overlap * 2, r=end_cap_radius * 0.82);
    }
}

// Creates one metal end fitting at local Z=0.
// is_top selects which direction the terminal pin projects:
// - true: upward from the upper face;
// - false: downward below the lower face.
module end_cap(is_top) {
    union() {
        // Cylindrical core of the fitting.
        cylinder(h=end_cap_height, r=end_cap_radius);

        // A six-sided, slightly wider centre band gives the fitting a nut-like
        // profile and an easily printable visual detail.
        translate([0, 0, end_cap_height / 2])
            cylinder(h=end_cap_height * 0.42, r=end_cap_radius * 1.08, center=true, $fn=6);

        if (is_top) {
            // Start inside the cap by connection_overlap so the upper terminal
            // forms a robust union rather than touching at one coplanar face.
            translate([0, 0, end_cap_height - connection_overlap])
                cylinder(h=connection_overlap + end_terminal_height, r=end_terminal_radius);
        } else {
            // The lower terminal starts below Z=0 and extends upward into the cap
            // by connection_overlap for the same reason.
            translate([0, 0, -end_terminal_height])
                cylinder(h=connection_overlap + end_terminal_height, r=end_terminal_radius);
        }
    }
}

// Builds a complete ring connector centred in a gap between two units.
module full_connector_link() {
    color(link_color)
    union() {
        // torus() is originally centred around Z; rotating it 90 degrees around
        // X places the ring in the vertical XZ plane alongside the chain axis.
        rotate([90, 0, 0])
            torus(link_ring_radius, link_ring_thickness);

        // The centred pin spans the entire gap and overlaps the adjacent fittings.
        cylinder(h=insulator_gap + 2 * connection_overlap, r=center_rod_radius * 0.72, center=true);
    }
}

// Builds one complementary half of a donut-shaped connector.
// which_half must be "lower_half" for the lower orientation; every other value
// selects the upper orientation.  The two angular sweeps intentionally overlap.
module half_donut_link(which_half) {
    color(link_color)
    union() {
        if (which_half == "lower_half") {
            // Sweep slightly more than 180 degrees, sharing half of the requested
            // overlap angle on each side of the nominal semicircle boundary.
            rotate([90, 0, 0])
                partial_torus(link_ring_radius, link_ring_thickness, -half_link_overlap_angle / 2, 180 + half_link_overlap_angle);

            // Reinforcing lug near the uppermost point joins this lower half to
            // the corresponding terminal/end-fitting region.
            translate([0, 0, link_ring_radius - link_ring_thickness * 0.35])
                cylinder(h=max(link_ring_thickness, connection_overlap), r=link_lug_radius, center=true);
        } else {
            // Start near 180 degrees to form the complementary upper semicircle.
            rotate([90, 0, 0])
                partial_torus(link_ring_radius, link_ring_thickness, 180 - half_link_overlap_angle / 2, 180 + half_link_overlap_angle);

            // Mirror the attachment lug to the lower side of the ring.
            translate([0, 0, -link_ring_radius + link_ring_thickness * 0.35])
                cylinder(h=max(link_ring_thickness, connection_overlap), r=link_lug_radius, center=true);
        }

        // Slightly oversized spheres round and reinforce both cut endpoints of
        // the partial torus, reducing sharp seams where complementary halves meet.
        translate([link_ring_radius, 0, 0])
            sphere(r=link_ring_thickness * 1.03);
        translate([-link_ring_radius, 0, 0])
            sphere(r=link_ring_thickness * 1.03);
    }
}

// Creates a complete torus around the Z axis.
// major_radius locates the circular section's centreline; minor_radius is the
// radius of that section and therefore controls the torus material thickness.
module torus(major_radius, minor_radius) {
    rotate_extrude(convexity=10)
        translate([major_radius, 0, 0])
            circle(r=minor_radius);
}

// Creates an angular segment of a torus around Z.
// The profile is first swept through sweep_angle by rotate_extrude(), then the
// finished segment is rotated to begin at start_angle.
module partial_torus(major_radius, minor_radius, start_angle, sweep_angle) {
    rotate([0, 0, start_angle])
        rotate_extrude(angle=sweep_angle, convexity=10)
            translate([major_radius, 0, 0])
                circle(r=minor_radius);
}
