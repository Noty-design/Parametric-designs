include <BOSL2/std.scad>
include <BOSL2/skin.scad>
include <BOSL2/rounding.scad>

// =============================================================================
// Pumpkin 2 FDM - permanently FDM-optimized Halloween pumpkin
// =============================================================================
//
// This standalone variant permanently uses the self-supporting FDM geometry.
// It contains no non-FDM silhouette, lid-cavity, or support-shelf branches.
// maximum_overhang_angle remains adjustable because it controls the optimized
// transition slope, but FDM optimization itself cannot be disabled.
//
// The model's main components:
//   1. A hollow pumpkin shell with optional face and surface pattern.
//   2. Removable top and/or bottom lid with bayonet or sliding fit.
//   3. Detachable stem, handle, arms, and feet.
//   4. Multiple arm types, including a skeleton arm with separate color/material detail.
//   5. Assembled preview and a spread-out layout for 3D printing.
//
// Dimensions are given in millimeters. OpenSCAD has no built-in units, so all numbers
// describing length, diameter, radius, clearance, or height must be interpreted as mm.
// Angles are specified in degrees, which is the OpenSCAD standard.
//
// Coordinate system:
//   X = left/right when viewing the pumpkin from the front.
//   Y = front/back; the face is cut into the pumpkin's negative Y side.
//   Z = height; the pumpkin's bottom normally sits at Z = 0.
//
// BOSL2 is primarily used for skin(), which creates solids by connecting a series of
// cross-sections. std.scad also provides helper functions such as unit().
// rounding.scad is included for compatibility with the model's BOSL2 environment.
//
// Important about colors and export:
//   color() affects OpenSCAD's preview and multi-color workflows, but a regular STL file
//   typically stores no color information. Export "Black base" and "White details" separately
//   if parts should be assigned different filaments in a slicer that works with separate mesh objects.
//
// Important about tolerances:
//   fit_clearance is used for lids, handle_fit_clearance for the handle, and
//   attachment_clearance for arms, feet, and stem. They are radial values;
//   the resulting diameter difference will therefore be twice as large.
//
// Important about rendering quality:
//   profile_points and vertical_slices strongly affect the pumpkin's skin()-mesh.
//   $fn controls other circles. High values yield smoother surfaces but longer F6-rendering
//   times and larger STL files. Reduce them temporarily during quick design iterations.
//
// OpenSCAD Customizer reads the headings and ranges below. Therefore, keep comments of type
// /* [Heading] */ and // [min:step:max] if new parameters are added or existing ones are renamed.
// comments of the form /* [Heading] */ and // [min:step:max] when adding new
// parameters or renaming existing ones.

// =============================================================================
// Customizable Parameters
// =============================================================================

/* [Dimensions] */
// The pumpkin's maximum width along the X axis.
pumpkin_width = 150; // [80:5:280]
// The pumpkin's maximum depth along the Y axis.
pumpkin_depth = 135; // [70:5:260]
// Total height of the pumpkin body, excluding stem and handle.
pumpkin_height = 125; // [70:5:240]
// Nominal wall thickness for shell, lids, and fitting parts.
wall_thickness = 3; // [2:0.5:6]

/* [Face and pattern] */
// Selects which 2D mask is cut through the pumpkin's front wall.
face_expression = "Scary"; // [Happy, Laughing, Silly, Winking, Surprised, Mischievous, Angry, Scary, Vampire, Ghost]
// Chooses radial pattern or separate ornaments on the pumpkin's exterior.
surface_pattern = "Ribs"; // [Ribs, Smooth, Spiral, Waves, Dots, Diamonds]
// Number of repetitions around the pumpkin for grooves and spiral tracks.
rib_count = 10; // [6:1:18]
// How deeply the radial patterns are recessed from the smooth base profile.
pattern_depth = 4; // [1:0.5:8]

/* [Lids] */
// Portions of the upper section as a separate top lid.
removable_top = true;
// Portions of the lower section as a separate bottom plate.
removable_bottom = false;
// Radial clearance between lid collar and locking ring; larger value yields looser fit.
fit_clearance = 0.35; // [0.15:0.05:0.8]
// Height of the collar that guides and holds a removable lid.
lip_height = 10; // [8:1:12]
// Bayonet provides twist lock; Slip_fit offers a simpler straight sliding fit.
lid_fastening = "Bayonet"; // [Bayonet, Slip_fit]
// How far the bayonet lug is rotated from entry hole to locked position.
locking_turn_angle = 20; // [15:1:30]
// Diameter of the three cylindrical bayonet lugs.
locking_tab_diameter = 4; // [3:0.5:5]
// Height/thickness of each bayonet lug.
locking_tab_height = 2.5; // [2:0.25:3]
// Radial material thickness around the body's bayonet tracks.
locking_ring_thickness = 3; // [3:0.5:5]
// Extra play around bayonet lugs and tracks for printing tolerance.
locking_clearance = 0.3; // [0.15:0.05:0.6]

/* [FDM settings] */
// Steepest allowed overhang measured from the horizontal plane. This value
// directly controls the permanently enabled self-supporting transitions.
maximum_overhang_angle = 40; // [30:1:45]

/* [Cable hole] */
// Creates a teardrop-shaped cable hole through the pumpkin's rear wall.
cable_hole_enabled = false;
// Diameter of the cable hole's round main section.
cable_hole_diameter = 8; // [4:0.5:20]
// Desired center height; automatically constrained by lid and wall thickness.
cable_hole_height = 30; // [15:1:80]

/* [Stem] */
// Visible height of the detachable, curved stem.
stem_height = 22; // [12:1:40]
// Radius where the stem meets the pumpkin's top side.
stem_base_radius = 6; // [5:0.5:10]
// Diameter of the stem's lug and corresponding hole in the pumpkin.
stem_peg_diameter = 5; // [3:0.5:8]
// How far the stem's lug extends into its mounting hole.
stem_peg_length = 6; // [4:1:10]
// Side offset at the stem tip; higher value yields stronger bend.
stem_curve = 8; // [0:1:15]
// Radial clearance in arm, foot, and stem attachments.
attachment_clearance = 0.25; // [0.1:0.05:0.6]

/* [Round handle with two flat cuts] */
// Enables handle plus the two holes in the pumpkin body.
print_handle = true;
// Width between the handle's center lines relative to the pumpkin's width.
// A smaller percentage pulls the handle sides closer to the pumpkin body.
handle_width_percent = 103; // [90:0.5:125]
// Diameter of the round grip before top and bottom faces are flattened.
handle_thickness = 8; // [6:0.5:14]
// Distance between the handle's two flat surfaces before FDM constraints.
handle_plate_thickness = 4; // [3:0.5:7]
// Free height between the pumpkin/stem top and the handle's inner arch.
handle_clearance = 28; // [15:1:65]
// Diameter of the handle's two mounting pins.
handle_pin_diameter = 6; // [5:0.5:10]
// Radial clearance between mounting pin and hole in the pumpkin.
handle_fit_clearance = 0.2; // [0.05:0.05:0.5]
// Vertical placement of handle mounts as fraction of pumpkin height.
handle_mount_fraction = 0.73; // [0.65:0.01:0.78]

/* [Arms and feet] */
// Enables arms plus arm holes in the pumpkin body.
print_arms = true;
// Lay flat keeps base angle; Reaching up rotates profile by 25 degrees.
arm_pose = "Lay flat"; // [Lay flat, Reaching up]
// Selects the arm's and hand's 2D silhouette.
arm_type = "Normal"; // [Normal, Claws, Skeleton, Holding lantern]
// For multi-color printing, black base and white details can be shown separately.
arm_part = "Complete arm"; // [Complete arm, Black base, White details]
// Enables raised bone markings on skeleton arms and feet.
skeleton_details = true;
// Color/material marking for the skeleton's supporting arm geometry.
skeleton_base_color = "Black"; // [Black, DimGray, DarkSlateGray]
// Color/material marking for the raised bone inlays.
skeleton_detail_color = "White"; // [White, Ivory, GhostWhite, LightGray]
// How high the bone inlays protrude above the arm's and foot's surface.
skeleton_detail_height = 0.8; // [0.4:0.1:1.2]
// Minkowski radius that rounds the skeleton arm's edges.
arm_edge_radius = 1; // [0.5:0.1:1.4]
// Enables feet plus foot mounts in the pumpkin's bottom.
print_feet = true;
// Common diameter for detachable arm and foot lugs.
attachment_diameter = 8; // [6:1:12]
// Length of the arm's horizontal lug into the pumpkin body.
attachment_length = 7; // [5:1:10]

/* [View and colors] */
// Assembled shows the figure; Print layout spreads parts; Arms only isolates the arms.
layout = "Print layout"; // [Assembled, Print layout, Arms only]
// Preview color for the pumpkin shell and removable lids.
body_color = "DarkOrange"; // 24
// Preview color for the detachable stem.
stem_color = "OliveDrab"; // 24
// Preview color for the carrying handle.
handle_color = "OliveDrab"; // 24
// Preview color for regular arms and all foot bases.
limb_color = "DarkOrange"; // 24

/* [Resolution] */
// Number of points around each pumpkin cross-section; affects roundness and file size.
profile_points = 96; // [64:16:128]
// Number of cross-sections along the pumpkin's height; affects vertical roundness.
vertical_slices = 40; // [28:4:56]
// Number of slices through the handle's thickness.
handle_cross_section_slices = 32; // [24:8:64]

// Default resolution for circles and cylinders that do not specify their own $fn.
$fn = 64;

// =============================================================================
// Derived Dimensions and Base Profile
// =============================================================================

// Half the width is used as X radius in each cross-section.
half_width = pumpkin_width / 2;
// Half the depth is used as Y radius in each cross-section.
half_depth = pumpkin_depth / 2;
// The largest radius is needed for conservative FDM transitions.
maximum_radius = max(half_width, half_depth);
// Fixed seam height for the top lid, expressed as fraction of body height.
top_seam = pumpkin_height * 0.82;
// Fixed seam height for the detachable bottom plate.
bottom_seam = pumpkin_height * 0.12;
// Tangent converts allowed overhang angle into radial change per Z unit.
overhang_slope = tan(maximum_overhang_angle);

// Returns the arm's selected elevation angle. The same value must be used by both
// silhouette and lug, otherwise the lug would no longer lie at the arm's center.
function arm_raise_angle() = arm_pose == "Reaching up" ? 25 : 0;

// Original round pumpkin silhouette, normalized from bottom (t=0) to top (t=1).
// The ellipse equation yields maximum radius just below geometric center, creating a
// naturally heavy pumpkin shape. max() prevents sqrt() of negative values outside the
// idealized ellipse.
function original_silhouette(t) =
    sqrt(max(0.01, 1 - pow((t - 0.49) / 0.55, 2)));

// Permanently FDM-optimized silhouette. The lowest and highest 18 percent use
// linear transitions whose radial change is limited by overhang_slope. The
// middle 64 percent retains the original elliptical pumpkin profile.
function silhouette(t) =
    t < 0.18
        ? max(
            0.2,
            original_silhouette(0.18)
                - (0.18 - t) * pumpkin_height / maximum_radius * overhang_slope
        )
        : t > 0.82
            ? max(
                0.2,
                original_silhouette(0.82)
                    - (t - 0.82) * pumpkin_height / maximum_radius * overhang_slope
            )
            : original_silhouette(t);

// Radial offset for grooves, spiral, or wave pattern.
// Result lies between -pattern_depth and 0, so the pattern cuts inward instead of
// increasing the pumpkin's stated outer dimensions. OpenSCAD's trigonometric functions use degrees.
// Variable t allows spiral and waves to rotate with height.
function texture(angle, t) =
    surface_pattern == "Ribs"
        ? pattern_depth * (cos(rib_count * angle) - 1) / 2
        : surface_pattern == "Spiral"
            ? pattern_depth * (cos(rib_count * angle - 220 * t) - 1) / 2
            : surface_pattern == "Waves"
                ? pattern_depth * (cos(6 * angle + 720 * t) - 1) / 2
                : 0;

// Reserves material for recessed radial patterns at the locking rings. Without this margin,
// a deep groove could cut through the locking ring's outer wall.
function texture_allowance() =
    surface_pattern == "Ribs"
        || surface_pattern == "Spiral"
        || surface_pattern == "Waves"
            ? pattern_depth
            : 0;

// Builds a complete 3D cross-section at height z.
//
// For each angle, separate X and Y radii are calculated so the body can be wider than it is deep.
// radius_offset adds the chosen surface pattern, and inset moves the entire profile inward for voids
// and fitting surfaces. The final component in each point is the absolute Z height that BOSL2 skin()
// uses when connecting profiles.
function profile(z, inset = 0) = [
    for (index = [0 : profile_points - 1])
        let(
            angle = 360 * index / profile_points,
            radius_offset = texture(angle, z / pumpkin_height)
        )
        [
            (half_width * silhouette(z / pumpkin_height) + radius_offset - inset)
                * cos(angle),
            (half_depth * silhouette(z / pumpkin_height) + radius_offset - inset)
                * sin(angle),
            z
        ]
];

// Creates the closed outer volume by sweeping vertical_slices+1 profiles from Z=0 to Z=pumpkin_height.
// Both end profiles are included to yield closed lid surfaces.
module outer_shell() {
    skin([
        for (index = [0 : vertical_slices])
            profile(pumpkin_height * index / vertical_slices)
    ], slices = 0);
}

// Creates the void that is later subtracted from the outer volume. The first and last profile
// are moved inward by one wall thickness along Z so the pumpkin retains bottom and top.
// Simultaneously, inset=wall_thickness provides nominal radial wall thickness.
module cavity() {
    skin([
        for (index = [0 : vertical_slices])
            profile(
                wall_thickness
                    + (pumpkin_height - 2 * wall_thickness)
                        * index / vertical_slices,
                wall_thickness
            )
    ], slices = 0);
}
// =============================================================================
// Face and Surface Pattern
// =============================================================================

// Creates a triangular eye. side=-1 yields left eye, side=1 right eye.
// Scaling mirrors the left side without duplicating polygon coordinates.
module triangle_eye(side, angry = false) {
    translate([side * 22, 13])
        scale([side < 0 ? -1 : 1, 1])
            polygon(
                angry
                    ? [[-13, -5], [13, -5], [-10, 10]]
                    : [[-11, -6], [11, -6], [0, 12]]
            );
}

// A wide ellipse with its top portion cut off, leaving a smiling arc.
module smile() {
    difference() {
        translate([0, -13]) scale([1, 0.65]) circle(r = 31);
        translate([-40, -12]) square([80, 40]);
    }
}

// Closed polygon for a jagged Jack-o'-lantern smile.
module jagged_mouth() {
    polygon([
        [-33, -10], [-20, -15], [-12, -8], [-3, -15], [7, -8],
        [17, -15], [32, -9], [27, -30], [15, -25], [5, -31],
        [-6, -25], [-17, -31], [-29, -25]
    ]);
}

// Selects a 2D mask for the face. All expressions share the same local coordinates:
// X ranges from left to right cheek, and Y becomes vertical height after the mask is rotated in face_cut().
// The mask is later extruded through the entire front wall.
module face_2d() {
    if (face_expression == "Happy") {
        // Two symmetric eyes and the reusable smile arc.
        triangle_eye(-1);
        triangle_eye(1);
        smile();
    } else if (face_expression == "Laughing") {
        // Each eye is a ring whose lower part is clipped to a happy arc.
        for (side = [-1, 1])
            translate([side * 22, 14])
                difference() {
                    circle(r = 11);
                    translate([0, -5]) circle(r = 10);
                    translate([-15, -20]) square([30, 20]);
                }
        // The wide oval mouth is fully open.
        translate([0, -19]) scale([1.6, 1]) circle(r = 17);
    } else if (face_expression == "Silly") {
        // A round eye combined with an angled rectangular eye.
        translate([-22, 14]) circle(r = 11);
        translate([22, 17]) rotate(20) square([19, 7], center = true);
        // A small rectangle breaks the smile, creating an asymmetric tooth gap.
        difference() {
            smile();
            translate([4, -34]) square([10, 17]);
        }
    } else if (face_expression == "Winking") {
        // The narrow, rotated rectangular eye represents a closed eyelid line.
        translate([-22, 14]) circle(r = 10);
        translate([22, 13]) rotate(-12) square([22, 6], center = true);
        smile();
    } else if (face_expression == "Surprised") {
        // High oval eyes and a vertically elongated open mouth.
        for (side = [-1, 1])
            translate([side * 22, 16]) scale([0.8, 1.3]) circle(r = 9);
        translate([0, -20]) scale([0.8, 1.2]) circle(r = 16);
    } else if (face_expression == "Mischievous") {
        // An angry triangular eye, an angled eye, and a rotated smile.
        triangle_eye(-1, true);
        translate([22, 15]) rotate(-15) square([23, 6], center = true);
        rotate(-8) smile();
    } else if (face_expression == "Angry") {
        // Two angry eyes and a downward-facing arc created by subtraction.
        triangle_eye(-1, true);
        triangle_eye(1, true);
        translate([0, -25])
            difference() {
                scale([1.7, 0.8]) circle(r = 17);
                translate([-40, -35]) square([80, 35]);
            }
    } else if (face_expression == "Scary") {
        // Classic horror pumpkin: angry eyes and jagged mouth polygon.
        triangle_eye(-1, true);
        triangle_eye(1, true);
        jagged_mouth();
    } else if (face_expression == "Vampire") {
        // Two angry eyes and an oval mouth where two triangles form fangs.
        triangle_eye(-1, true);
        triangle_eye(1, true);
        difference() {
            translate([0, -22]) scale([1.8, 0.7]) circle(r = 18);
            for (side = [-1, 1])
                translate([side * 18, -10])
                    polygon([[-5, 0], [5, 0], [0, -20]]);
        }
    } else {
        // Fallback is also used by the "Ghost" option: two oval eyes and
        // an oval mouth. A fallback also makes the model robust against unknown selection.
        for (side = [-1, 1])
            translate([side * 21, 15]) scale([0.75, 1.3]) circle(r = 10);
        translate([0, -20]) scale([1.2, 1.4]) circle(r = 16);
    }
}

// Converts the face's 2D mask into a negative 3D volume:
//   1. scale() adjusts the original design of 150x125 to the pump's current dimensions.
//   2. translate() places the face's local origin around the body's center.
//   3. linear_extrude() makes the mask deeper than half the pump's depth.
//   4. rotate([90,0,0]) orients the extrusion through the negative Y-wall.
module face_cut() {
    rotate([90, 0, 0])
        linear_extrude(height = half_depth + 15)
            translate([0, pumpkin_height * 0.49])
                scale([pumpkin_width / 150, pumpkin_height / 125])
                    face_2d();
}

// Dots and diamonds are cut as separate ornaments; radial patterns are built
// directly into profile(). Four height levels and twelve angles create a regular
// grid. The angular range of 215-325 degrees is left empty so the face remains clean.
module ornaments() {
    if (surface_pattern == "Dots" || surface_pattern == "Diamonds")
        // level is normalized height, not millimeters.
        for (level = [0.25, 0.4, 0.55, 0.7])
            // Twelve positions per level with 30-degree spacing.
            for (angle = [0 : 30 : 330])
                // Leave the face area free of ornaments.
                if (!(angle > 215 && angle < 325))
                    // Place the ornament's local origin on the pump's surface.
                    translate([
                        half_width * silhouette(level) * cos(angle),
                        half_depth * silhouette(level) * sin(angle),
                        level * pumpkin_height
                    ])
                        // Orient the ornament roughly along the surface's radial normal.
                        rotate([0, 90, angle])
                            if (surface_pattern == "Dots")
                                // The sphere cuts a round groove through the outer wall.
                                translate([0, 0, wall_thickness * 0.5])
                                    sphere(r = wall_thickness * 0.95);
                            else
                                // Extruded rhombus cuts a sharp diamond-shaped hole.
                                translate([0, 0, -wall_thickness * 0.55])
                                    linear_extrude(height = wall_thickness + 2)
                                        polygon([[0, 5], [3.5, 0], [0, -5], [-3.5, 0]]);
}

// =============================================================================
// Holes, mounts and body segmentation
// =============================================================================

// The drop profile combines a circle with an upward point. The pointed top
// allows a horizontal cable hole to be written without a long, flat bridge.
module teardrop_2d(diameter) {
    union() {
        circle(d = diameter);
        polygon([
            [-diameter / 2, 0],
            [diameter / 2, 0],
            [0, diameter * 0.72]
        ]);
    }
}

// Negative volume for the arm's horizontal pin. side mirrors both X-position and
// rotation direction so the same definition works on both sides of the body.
// The extrusion length passes with clearance through the rounded body wall.
module arm_socket(side) {
    translate([
        side * (half_width - wall_thickness - attachment_length),
        0,
        pumpkin_height * 0.49
    ])
        rotate([90, 0, side * 90])
            linear_extrude(height = attachment_length + wall_thickness + 14)
                circle(d = attachment_diameter + 2 * attachment_clearance);
}

// Vertical hole from the pump's underside. The hole is made larger than the pin
// by two radial clearances since the diameter affects both sides of the center.
module foot_socket(side) {
    translate([side * half_width * 0.24, 0, -1])
        cylinder(
            d = attachment_diameter + 2 * attachment_clearance,
            h = wall_thickness + 2
        );
}

// Vertical mount hole near the top of the body. Extra height ensures the hole cuts
// through the outer shell even when the surface profile or lid changes slightly.
module stem_socket() {
    translate([0, 0, pumpkin_height - wall_thickness - 2])
        cylinder(
            d = stem_peg_diameter + 2 * attachment_clearance,
            h = wall_thickness + 4
        );
}

// The cable hole is kept above the bottom latch and below the top lid. The inner max()
// calculation picks the smallest allowed bottom height, while the outer min()
// restricts the center so the entire hole fits under the upper seam.
actual_cable_height = min(
    top_seam - cable_hole_diameter - wall_thickness,
    max(
        cable_hole_height,
        (removable_bottom ? bottom_seam + lip_height : wall_thickness)
            + cable_hole_diameter / 2
            + wall_thickness
    )
);

// Extrudes the drop profile through the back wall. A 180-degree Z-rotation orients
// the drop's point correctly after the subsequent 90-degree X-rotation.
module cable_passage() {
    translate([0, 0, actual_cable_height])
        rotate([90, 0, 180])
            linear_extrude(height = half_depth + 15)
                teardrop_2d(cable_hole_diameter);
}

// The handle's derived dimensions are used both by the holes and the loose part. Sharing
// the same values prevents pins and holes from drifting apart when the pump is scaled.
// Absolute Z-height for the center of the handle's mounting hole.
handle_mount_height = pumpkin_height * handle_mount_fraction;
// Approximate X-radius on the pump's surface at the mounting height.
handle_surface_radius = half_width * silhouette(handle_mount_fraction);
// Half the distance between the handle's left and right center lines.
handle_span = half_width * handle_width_percent / 100;
// Vertical arc height from the attachment point to the desired clearance above the stem.
handle_rise = pumpkin_height + stem_height + handle_clearance - handle_mount_height;
// Length that lets each pin pass through the shell and into the handle's arch.
handle_tongue_length = handle_thickness / 2 + wall_thickness + 11;

// Limit the handle's flat height so its remaining round underside does not
// exceed the allowed FDM angle. min() also respects the user's desired plate thickness
// when it is already safe to print.
actual_handle_height = min(
    handle_plate_thickness,
    handle_thickness * sin(maximum_overhang_angle)
);

// Cylindrical hole through each side of the pump. center=true makes the hole cut
// equally inside and outside the calculated wall position.
module handle_bore(side) {
    translate([
        side * (handle_surface_radius - wall_thickness / 2),
        0,
        handle_mount_height
    ])
        rotate([0, side * 90, 0])
            cylinder(
                d = handle_pin_diameter + 2 * handle_fit_clearance,
                h = wall_thickness + 2,
                center = true
            );
}

// All negative volumes that need to be removed from the shell are collected here. The same
// module is reused for main shell, lid and latch rings so holes aren't blocked by a
// later-added component.
module cuts() {
    // The face is always active and forms the model's primary openings.
    face_cut();
    // ornaments() becomes empty if the chosen pattern is already built into profile().
    ornaments();
    // The stem hole is always created since the stem is always part of the layouts.
    stem_socket();

    // Optional openings are only created together with their corresponding part/function.
    if (cable_hole_enabled)
        cable_passage();

    if (print_handle)
        for (side = [-1, 1]) handle_bore(side);

    if (print_arms)
        for (side = [-1, 1]) arm_socket(side);

    if (print_feet)
        for (side = [-1, 1]) foot_socket(side);
}

// Basic CSG for the body: outer volume minus cavities and all openings.
module shell() {
    difference() {
        // Positive base volume.
        outer_shell();
        // First negative volume makes the model hollow.
        cavity();
        // Second negative group opens face, pattern and mounts.
        cuts();
    }
}

// Large rectangular clipping volume between two Z-heights. The X/Y dimensions are intentionally
// larger than the entire pump so only the height interval restricts the result.
module slab(low, high) {
    translate([-pumpkin_width, -pumpkin_depth, low])
        cube([pumpkin_width * 2, pumpkin_depth * 2, high - low]);
}

// Keeps only the part of the pump shell that lies between low and high.
// This is the common mechanism for main body, top lid and bottom lid.
module section(low, high) {
    intersection() {
        shell();
        slab(low, high);
    }
}
// =============================================================================
// Latch rings, lids and removable body parts
// =============================================================================

// Safe outer radius for a circular latch ring at height z. min(width,depth)
// guarantees the ring fits even along the pump's narrowest axis. Then pattern depth,
// wall thickness and desired ring thickness are subtracted.
function lock_radius(z) =
    min(half_width, half_depth) * silhouette(z / pumpkin_height)
        - texture_allowance()
        - wall_thickness
        - locking_ring_thickness;

// Finds the smallest polar radius in a cross-section. This is used by sliding fit,
// where the collar must fit inside all gaps and other profile variations.
function profile_min_radius(z, inset = 0) = min([
    for (point = profile(z, inset))
        sqrt(point[0] * point[0] + point[1] * point[1])
]);

// Vertical position where the bayonet track goes from entry to rotation.
lock_depth = lip_height * 0.62;
// The collar's outer radius depends on the chosen lock type. Bayonet uses a circle,
// while sliding fit follows the cross-section's smallest free radius.
lid_lip_outer_radius = lid_fastening == "Bayonet"
    ? lock_radius(top_seam) - fit_clearance
    : profile_min_radius(top_seam, wall_thickness + fit_clearance);
// Inner radius creates the collar's wall thickness and defines the transition start.
lid_lip_inner_radius = lid_fastening == "Bayonet"
    ? lid_lip_outer_radius - wall_thickness
    : profile_min_radius(top_seam, 2 * wall_thickness + fit_clearance);
// Height needed to grow from the circular lip to the pump's actual inner wall without
// exceeding overhang_slope. It is clamped to lip_height.
lid_transition_height = min(
    lip_height,
    max(
        0,
        (profile_min_radius(top_seam, wall_thickness) - lid_lip_inner_radius)
            / overhang_slope
    )
);

// Blends the lid lip's circle with the pump's actual profile.
// fraction=0 gives a circle at the lip; fraction=1 reaches the target profile. The value -1
// is used as an extra starting disk below the lip to give skin() a closed and
// stable transition. Each point keeps the target profile's angle but interpolates
// its radius linearly.
function lid_transition_section(fraction) =
    let(
        z = top_seam + lid_transition_height * fraction,
        target = profile(z, wall_thickness)
    )
    [
        // Point count and angle index match profile(), so skin() can join
        // the lists without twisted polygons or differing vertex counts.
        for (index = [0 : profile_points - 1])
            let(
                angle = 360 * index / profile_points,
                target_radius = sqrt(
                    target[index][0] * target[index][0]
                        + target[index][1] * target[index][1]
                ),
                radius = lid_lip_inner_radius * (1 - fraction)
                    + target_radius * fraction
            )
            [radius * cos(angle), radius * sin(angle), z]
    ];

// Permanently FDM-optimized top-lid cavity. Transition disks connect the
// circular lid lip to the ordinary upper inner-wall profiles without requiring
// unsupported internal overhangs.
module lid_cavity() {
    skin(
        concat(
            [lid_transition_section(-1)],
            [for (index = [0 : 32]) lid_transition_section(index / 32)],
            [
                for (index = [1 : vertical_slices])
                    profile(
                        top_seam
                            + lid_transition_height
                            + (pumpkin_height
                                - wall_thickness
                                - top_seam
                                - lid_transition_height)
                                * index / vertical_slices,
                        wall_thickness
                    )
            ]
        ),
        slices = 0
    );
}

// Top lid's outer volume minus its custom cavity and all through openings. Double difference()
// levels make the operation order explicit.
module lid_shell() {
    difference() {
        difference() {
            outer_shell();
            lid_cavity();
        }
        cuts();
    }
}

// Z-clipped variant of lid_shell(), corresponding to section() for regular shells.
module lid_section(low, high) {
    intersection() {
        lid_shell();
        slab(low, high);
    }
}

// Runs child geometry at a seam and mirrors it for downward-facing lids. By writing the lock
// geometry in a local coordinate system with the seam at Z=0, the same modules can be reused
// for both top and bottom.
module at_seam(z, down = false) {
    translate([0, 0, z])
        if (down)
            mirror([0, 0, 1]) children();
        else
            children();
}

// A vertical entry hole that transitions into a rotated bayonet track.
// The first cylinder accepts the pin when the lid is pressed straight on. The following
// hull() chain consists of ten overlapping segments and approximates a smooth,
// circular track from start angle to start angle+locking_turn_angle.
module lock_slot(radius, angle) {
    translate([
        (radius + 0.8) * cos(angle),
        (radius + 0.8) * sin(angle),
        -0.5
    ])
        cylinder(
            d = locking_tab_diameter + 2 * locking_clearance,
            h = lock_depth
                + locking_tab_height / 2
                + locking_clearance
                + 0.5
        );

    for (step = [0 : 9])
        hull()
            for (endpoint = [step, step + 1])
                let(turn = angle + locking_turn_angle * endpoint / 10)
                    translate([
                        (radius + 0.8) * cos(turn),
                        (radius + 0.8) * sin(turn),
                        lock_depth - locking_tab_height / 2 - locking_clearance
                    ])
                        cylinder(
                            d = locking_tab_diameter + 2 * locking_clearance,
                            h = locking_tab_height + 2 * locking_clearance
                        );
}

// Builds the latch ring that sits integrated into the pump body.
// z indicates seam height and down indicates whether the ring grows downward from a top seam.
module locking_ring(z, down = false) {
    // A downward-facing ring may need longer transition to reach the pump's narrower
    // wall without overly steep overhang. An upward-facing bottom ring only needs the lip.
    transition_depth = down
        ? lip_height + 1 + (maximum_radius - lock_radius(z) + 3) / overhang_slope
        : lip_height + 1;
    // Limit downward-directed ring so it never collides with the bottom lid's seam.
    actual_depth = down
        ? min(transition_depth, z - bottom_seam - 1)
        : transition_depth;

    difference() {
        // Follow the pump's profiles so the latch ring blends with the wall. The factor
        // 1.018 provides a small radial overlap and avoids zero-thickness surfaces
        // between the ring and shell after boolean operations.
        skin([
            for (index = [0 : 32])
                let(depth = actual_depth * index / 32)
                    [
                        for (point = profile(
                            z + (down ? -depth : depth),
                            wall_thickness
                        ))
                            [point[0] * 1.018, point[1] * 1.018, point[2]]
                    ]
        ], slices = 0);

        if (down) {
            // For the top lid, first a straight cylinder and then a conical,
            // Bottom ring uses a simpler straight cylindrical hole upward.
            translate([0, 0, z - lip_height - 1])
                cylinder(r = lock_radius(z), h = lip_height + 2);
            translate([0, 0, z - actual_depth - 0.1])
                cylinder(
                    r1 = lock_radius(z)
                        + (actual_depth - lip_height - 1 + 0.1) * overhang_slope,
                    r2 = lock_radius(z),
                    h = actual_depth - lip_height - 1 + 0.1,
                    $fn = profile_points
                );
        } else {
            // Three evenly distributed tracks provide balanced locking without over-constraint.
            translate([0, 0, z - 1])
                cylinder(
                    r = lock_radius(z),
                    h = actual_depth + 2,
                    $fn = profile_points
                );
        }

        // Three evenly spaced slots provide balanced locking.
        at_seam(z, down)
            for (angle = [30, 150, 270])
                lock_slot(lock_radius(z), angle);

        // Re-cut global openings that might otherwise be filled by the locking ring.
        cuts();
    }
}

// The collar is mounted on the removable part and enters the body's locking
// ring. The bayonet variant is circular with three lugs, while Slip_fit follows
// the pumpkin's local profile and has no twist-lock tabs.
module collar(z, down = false) {
    if (lid_fastening == "Bayonet")
        at_seam(z, down)
            union() {
                // Hollow cylindrical collar with nominal wall thickness.
                difference() {
                    translate([0, 0, -0.4])
                        cylinder(
                            r = lock_radius(z) - fit_clearance,
                            h = lip_height + 0.4
                        );
                    translate([0, 0, -1])
                        cylinder(
                            r = lock_radius(z) - fit_clearance - wall_thickness,
                            h = lip_height + 2
                        );
                }

                // Each lug's end angle matches the track's locked position.
                for (angle = [30, 150, 270])
                    let(turn = angle + locking_turn_angle)
                        translate([
                            (lock_radius(z) + 0.8) * cos(turn),
                            (lock_radius(z) + 0.8) * sin(turn),
                            lock_depth - locking_tab_height / 2
                        ])
                            cylinder(
                                d = locking_tab_diameter,
                                h = locking_tab_height
                            );

                // A thin shelf joins an upward collar to the profiled lid/body.
                // The downward-facing top collar already has an optimized
                // self-supporting transition, so only upward collars need this shelf.
                if (!down)
                    difference() {
                        translate([0, 0, -1])
                            linear_extrude(height = 1)
                                polygon([
                                    for (point = profile(z, wall_thickness))
                                        [point[0] * 1.018, point[1] * 1.018]
                                ]);
                        translate([0, 0, -1.1])
                            cylinder(
                                r = lock_radius(z) - fit_clearance - wall_thickness,
                                h = 1.2
                            );
                    }
            }
    else
        // Sliding fit: subtract two profiled extrusions to create a collar with
        // uniform wall thickness and fit_clearance around the entire contour.
        at_seam(z, down)
            difference() {
                translate([0, 0, -0.4])
                    linear_extrude(height = lip_height + 0.4)
                        polygon([
                            for (point = profile(
                                z,
                                wall_thickness + fit_clearance
                            ))
                                [point[0], point[1]]
                        ]);
                translate([0, 0, -1])
                    linear_extrude(height = lip_height + 2)
                        polygon([
                            for (point = profile(
                                z,
                                2 * wall_thickness + fit_clearance
                            ))
                                [point[0], point[1]]
                        ]);
            }
}

// Complete removable bottom: clipped base shell plus upward-facing collar.
module top_part() {
    // color() groups the complete part visually but does not change its dimensions.
    color(body_color)
        union() {
            lid_section(top_seam, pumpkin_height + 0.1);
            collar(top_seam, true);
        }
}

// Same color and CSG structure as top lid, but with opposite collar direction.
module bottom_part() {
    // Same color and CSG structure as the top lid, but with the collar reversed.
    color(body_color)
        union() {
            section(0, bottom_seam);
            collar(bottom_seam);
        }
}

// The remaining mid-body. section()-bounds depend on which lids are
// detachable. Bayonet rings are only added when the lock type actually uses them.
module main_body() {
    color(body_color)
        union() {
            section(
                removable_bottom ? bottom_seam : 0,
                removable_top ? top_seam : pumpkin_height + 0.1
            );

            if (lid_fastening == "Bayonet") {
                if (removable_top)
                    locking_ring(top_seam, true);
                if (removable_bottom)
                    locking_ring(bottom_seam);
            }
        }
}

// =============================================================================
// Raw stem geometry in three parts:
//   1. Straight lug below Z=0.

//   2. Conical foot transitioning to the visible stem.
//   3. Twelve skin()-cross-sections that taper and bend quadratically in X.
//   2. Conical base transitioning into the visible stem.
// Trim one Y-side of the stem to a flat face. In print layout this face is
module stem_geometry() {
    union() {
        translate([0, 0, -stem_peg_length])
            cylinder(d = stem_peg_diameter, h = stem_peg_length + 0.2);
        translate([0, 0, -2])
            cylinder(r1 = stem_peg_diameter / 2, r2 = stem_base_radius, h = 2.2);
        skin([
            for (index = [0 : 12])
                let(t = index / 12)
                    [
                        for (angle = [0 : 30 : 330])
                            [
                                (stem_base_radius - 2 * t) * cos(angle)
                                    + stem_curve * t * t,
                                (stem_base_radius - 2 * t) * sin(angle),
                                stem_height * t
                            ]
                    ]
        ], slices = 0);
    }
}

// Flat backside provides stable print surface in print layout.
// this face toward the build plate, preventing the curved stem from rolling.
module detachable_stem() {
    color(stem_color)
        intersection() {
            stem_geometry();
            // The flat rear face provides a stable surface in the print layout.
            translate([-50, -stem_base_radius + 0.6, -stem_peg_length - 1])
                cube([100, 100, stem_height + stem_peg_length + 5]);
        }
}

// Computes a point on the handle's elliptical centerline and offsets it by
// Half-width of a circular cross-section at local height z. Pythagoras gives
// half-chord length after the circle is clipped by two parallel planes.
function grip_point(angle, distance) =
    let(normal = unit([-handle_rise * cos(angle), handle_span * sin(angle)]))
        [
            -handle_span * cos(angle) + distance * normal[0],
            handle_rise * sin(angle) + distance * normal[1]
        ];

// Creates a closed profile around the handle arch at local height z. First list
// follows one side 0->180 degrees; second list returns on opposite side.
function grip_half_width(z) =
    sqrt(pow(handle_thickness / 2, 2) - pow(z - actual_handle_height / 2, 2));

// Sweeps the closed profiles from the handle's flat underside to top side.
// Result corresponds to a round tube clipped by two parallel planes.
// side. concat() gives the correct point order for a closed, non-self-intersecting profile.
function round_grip_profile(z) = concat(
    [
        for (index = [0 : 96])
            let(point = grip_point(180 * index / 96, grip_half_width(z)))
                [point[0], point[1], z]
    ],
    [
        for (index = [96 : -1 : 0])
            let(point = grip_point(180 * index / 96, -grip_half_width(z)))
                [point[0], point[1], z]
    ]
);

// Lugs are round but clipped by the same flat print faces as the handle.
// scale([side,1,1]) mirrors left lug. intersection() between cylinder and
module round_cut_grip() {
    skin([
        for (index = [0 : handle_cross_section_slices])
            round_grip_profile(
                actual_handle_height * index / handle_cross_section_slices
            )
    ], slices = 0);
}

// Colored print part joining arch and both mounting pins.
// scale([side,1,1]) mirrors the left tab. intersection() between the cylinder and
// cube limits each tab to actual_handle_height and creates a flat build surface.
module handle_tongues() {
    for (side = [-1, 1])
        scale([side, 1, 1])
            translate([handle_span - handle_tongue_length, 0, 0])
                intersection() {
                    translate([0, 0, actual_handle_height / 2])
                        rotate([0, 90, 0])
                            cylinder(
                                d = handle_pin_diameter,
                                h = handle_tongue_length + handle_thickness / 2 - 1
                            );
                    translate([-0.01, -handle_pin_diameter, -0.01])
                        cube([
                            handle_tongue_length + handle_thickness / 2 + 1,
                            2 * handle_pin_diameter,
                            actual_handle_height + 0.02
                        ]);
                }
}

// Colored printable part that joins the arch and both mounting pins.
module printable_handle() {
    color(handle_color)
        union() {
            round_cut_grip();
            handle_tongues();
        }
}

// Transforms handle's local XY-arch into mounted XZ-orientation and locates
// its pin centers at body's computed mount height.
module carrying_handle() {
    translate([0, actual_handle_height / 2, handle_mount_height])
        rotate([90, 0, 0])
            printable_handle();
}
// =============================================================================
// Arms, hands and skeletal details
// =============================================================================

// Common 2D profile for all arm types. All shapes start around [0,0], where
// the arm meets its lug, and grow mostly toward positive X. Profile is rotated here
// so both base geometry and skeleton's rounding share the same pose. Final profile
// is later extruded along local Z in printable_arm().
module arm_profile() {
    rotate(arm_raise_angle()) {
        if (arm_type == "Claws") {
            // The claw arm is built from three overlapping, softly joined sections.
            // hull() between circles creates rounded organic segments without sharp corners.
            union() {
                hull() {
                    translate([0, 0]) circle(r = 4.5);
                    translate([14, 8]) circle(r = 6);
                }
                hull() {
                    translate([14, 8]) circle(r = 5);
                    translate([27, 15]) circle(r = 4.5);
                }
                hull() {
                    translate([27, 15]) circle(r = 5);
                    translate([32, 16]) circle(r = 6);
                }

                // Claw arm built as three overlapping, softly joined joints.
                // hull() between circles yields rounded organic segments without sharp corners.
                for (finger = [-1 : 1])
                    let(y = 16 + finger * 4)
                        union() {
                            hull() {
                                translate([31, y]) circle(r = 3.5);
                                translate([38, y + finger * 1.5]) circle(r = 2.5);
                            }
                            translate([37, y + finger * 1.5])
                                rotate(finger * 12)
                                    polygon([[0, -2], [7, 0], [0, 2]]);
                        }
            }
        } else if (arm_type == "Skeleton") {
            // Three pointed claws with slight leaf-spring shape. finger=-1,0,1 controls
            // both vertical placement and small individual rotation angle.
            union() {
                // Black skeleton silhouette must remain contiguous for robust print part.
                hull() {
                    translate([0, 0]) circle(r = 4.5);
                    translate([13.5, 8]) circle(r = 4);
                }
                // Therefore overlap bones, joints and palm.
                translate([13.5, 8]) circle(r = 4.8);
                // Forearm: elbow to wrist.
                hull() {
                    translate([13.5, 8]) circle(r = 3.8);
                    translate([24.5, 13.5]) circle(r = 3.2);
                }
                // Wrist joint circle.
                translate([24.5, 13.5]) circle(r = 4);
                // Short transition from wrist to palm.
                hull() {
                    translate([24.5, 13.5]) circle(r = 3.2);
                    translate([28.5, 16]) circle(r = 4.2);
                }
                // Elliptical palm, wider along X than along Y.
                translate([29, 16]) scale([1.18, 0.86]) circle(r = 5.2);

                // Four segmented fingers. Each finger consists of two hull()
                // segments with decreasing radii toward a tapered fingertip.
                for (finger = [-1 : 2])
                    let(y = 14.1 + finger * 2.35)
                        union() {
                            hull() {
                                translate([29, y]) circle(r = 2);
                                translate([33, y + 0.8]) circle(r = 1.75);
                            }
                            hull() {
                                translate([33, y + 0.8]) circle(r = 1.75);
                                translate([36.6, y + 1.8]) circle(r = 1.35);
                            }
                        }

                // Elliptical palm, wider along X than Y.
                // underside. The coordinates keep it visible between the palm and
                // fingers when the arm is rotated into its assembled orientation.
                hull() {
                    translate([26.5, 13]) circle(r = 2.7);
                    translate([30, 22.5]) circle(r = 2.1);
                }
                hull() {
                    translate([30, 22.5]) circle(r = 2.1);
                    translate([34, 27]) circle(r = 1.45);
                }
            }
        } else if (arm_type == "Holding lantern") {
            // This arm shares the claw arm's organic segment shape but ends in a
            // connected lantern that can be printed as part of the same flat piece.
            union() {
                hull() {
                    translate([0, 0]) circle(r = 4.5);
                    translate([14, 8]) circle(r = 6);
                }
                hull() {
                    translate([14, 8]) circle(r = 5);
                    translate([27, 15]) circle(r = 4.5);
                }
                hull() {
                    translate([27, 15]) circle(r = 5);
                    translate([31, 17]) circle(r = 5);
                }

                // Four segmented fingers. Each finger consists of two hull()-segments
                translate([34, 19])
                    difference() {
                        circle(r = 6);
                        circle(r = 3.2);
                    }
                // Outer lantern house minus a rectangular window.
                difference() {
                    polygon([
                        [29, 12], [40, 12], [43, 8], [42, -8],
                        [40, -11], [29, -11], [27, -8], [26, 8]
                    ]);
                    polygon([[30, 7], [39, 7], [39, -6], [30, -6]]);
                }
                // Lantern roof, central post, light point and base.
                polygon([[26, 11], [43, 11], [40, 14], [29, 14]]);
                translate([34.5, 0]) square([1.5, 15], center = true);
                translate([34.5, 2]) circle(r = 2);
                polygon([[28, -10], [41, -10], [39, -14], [30, -14]]);
            }
        } else {
            // Normal arm is fallback for all other arm types. A single hull()
            // forms the arm and palm; two rounded fingers are then added.
            hull() {
                translate([0, 0]) circle(r = 4.5);
                translate([28, 15]) circle(r = 8);
            }
            for (finger = [-1, 1])
                hull() {
                    translate([28, 15]) circle(r = 4);
                    translate([36, 15 + finger * 7]) circle(r = 3.5);
                }
        }
    }
}

// White, raised bone markings that follow the skeleton arm’s profile. This
// profile is intentionally narrower than the black base so each white detail
// has full support across its surface and does not create floating islands in
module skeleton_detail_profile() {
    union() {
        // Light mid-marking of the upper-arm bone.
        hull() {
            translate([3.5, 2]) circle(r = 0.95);
            translate([11.2, 6.7]) circle(r = 0.95);
        }
        // Light mid-marking of the forearm bone.
        hull() {
            translate([16.2, 9.2]) circle(r = 0.9);
            translate([22.6, 12.7]) circle(r = 0.9);
        }
        // Short bone marking between wrist and palm.
        hull() {
            translate([26.2, 14.5]) circle(r = 0.8);
            translate([28.2, 15.8]) circle(r = 0.8);
        }

        // Joint caps at elbow, wrist, palm, and thumb knuckle.
        for (point = [[13.5, 8], [24.5, 13.5], [29, 16], [30, 22.5]])
            translate(point) circle(r = 1.05);

        // Two bone markings per finger. The short hull() shapes lie entirely
        // within their respective black finger segments but leave dark joints visible.
        for (finger = [-1 : 2])
            let(y = 14.1 + finger * 2.35) {
                hull() {
                    translate([32.1, y + 0.6]) circle(r = 0.7);
                    translate([32.6, y + 0.72]) circle(r = 0.7);
                }
                hull() {
                    translate([35.1, y + 1.4]) circle(r = 0.58);
                    translate([35.5, y + 1.52]) circle(r = 0.58);
                }
            }

        // Thumb’s first light bone marking.
        hull() {
            translate([29, 21.8]) circle(r = 0.7);
            translate([29.5, 22.3]) circle(r = 0.7);
        }
    }
}

// Rounds the extruded skeleton base with a Minkowski-sum against a small sphere.
// The base extrusion is reduced by two radii and lifted one radius, so the
// final total height remains exactly attachment_diameter.
module rounded_skeleton_arm() {
    translate([0, 0, arm_edge_radius])
        minkowski() {
            linear_extrude(height = attachment_diameter - 2 * arm_edge_radius)
                arm_profile();
            sphere(r = arm_edge_radius, $fn = 16);
        }
}

// Arm’s cylindrical stud. The cylinder’s local Z-axis is rotated to global X and
// starts attachment_length behind the arm profile’s origin.
module arm_attachment() {
    translate([-attachment_length, 0, attachment_diameter / 2])
        rotate([0, 90, 0])
            cylinder(d = attachment_diameter, h = attachment_length + 2);
}

// Sets colors, selects export parts, and merges the arm profile with its stud.
// Outer intersection() trims away all Minkowski geometry below Z=0 and gives
// the skeleton arm a perfectly flat underside despite rounded edges.
module printable_arm() {
    // Trim any geometry below the print plane.
    intersection() {
        union() {
            if (arm_type == "Skeleton") {
                // The black base can be hidden for separate export of white details.
                if (arm_part != "White details")
                    color(skeleton_base_color)
                        union() {
                            rounded_skeleton_arm();
                            rotate(arm_raise_angle()) arm_attachment();
                        }

                // White details start 0.02 mm below the base’s top side. This
                // small overlap prevents zero-thickness contact between colors.
                if (skeleton_details && arm_part != "Black base")
                    color(skeleton_detail_color)
                        translate([0, 0, attachment_diameter - 0.02])
                            linear_extrude(height = skeleton_detail_height + 0.02)
                                rotate(arm_raise_angle())
                                    skeleton_detail_profile();
            } else if (arm_part != "White details") {
                // Other arm types are simple extrusions without separate inlays.
                color(limb_color)
                    union() {
                        linear_extrude(height = attachment_diameter) arm_profile();
                        rotate(arm_raise_angle()) arm_attachment();
                    }
            }
        }

        // The clipping cube is larger than all arm profiles but starts exactly at Z=0.
        translate([-50, -50, 0]) cube([150, 150, 50]);
    }
}

// =============================================================================
// Feet and their skeleton details
// =============================================================================

// 2D inlay for the skeleton foot’s top side. Negative Y places the bones in front of
// the central mounting cylinder, keeping them visible even when assembled.
module skeleton_detail_foot_profile() {
    union() {
        // The central bone runs along the foot’s length direction.
        hull() {
            translate([0, -11]) circle(r = 1.4);
            translate([0, -5]) circle(r = 1.55);
        }
        // Three toe bones spread symmetrically around the center. toe=-1,0,1 determines X.
        for (toe = [-1 : 1])
            hull() {
                translate([toe * 3, -5]) circle(r = 0.95);
                translate([toe * 3.4, -8]) circle(r = 0.8);
            }
    }
}

// Complete foot with base, transition cylinder, mounting pin, and optional inlay.
// The foot uses limb_color even in skeleton mode; only the inlay gets separate
// skeleton_detail_color, which simplifies both preview and multi-color printing.
module printable_foot() {
    union() {
        color(limb_color)
            union() {
                // Wide foot plate with rounded toe and heel. hull() between a circle
                // and a Y-scaled circle yields a soft, teardrop-shaped silhouette.
                linear_extrude(height = 6)
                    hull() {
                        translate([0, 7]) circle(r = 8);
                        translate([0, -9]) scale([1, 1.25]) circle(r = 11);
                    }

                // The wider cylinder reinforces the transition from foot plate to
                // stud. The narrower cylinder is the part that inserts into the pump body.
                translate([0, 0, 6])
                    cylinder(d = attachment_diameter + 5, h = 6);
                translate([0, 0, 11])
                    cylinder(d = attachment_diameter, h = wall_thickness + 3);
            }

        // Foot details follow the skeleton arm's visibility choice so "Black base" can
        // be exported without light inlays. The inlay starts 0.02 mm above the base’s
        // top side to avoid z-fighting in OpenSCAD’s preview.
        if (arm_type == "Skeleton"
            && skeleton_details
            && arm_part != "Black base")
            color(skeleton_detail_color)
                translate([0, 0, 6.02])
                    linear_extrude(height = skeleton_detail_height + 0.02)
                        skeleton_detail_foot_profile();
    }
}

// =============================================================================
// Final layout
// =============================================================================

if (layout == "Assembled") {
    // Complete figure with all loose parts placed in their mounts. This pose is
    // intended for visual inspection; parts may overlap in the sockets and should
    // normally not be exported as a single multi-component STL for printing.

    // The mid-body contains any integrated locking rings.
    main_body();

    // Re-attach the lids previously clipped from the mid-body.
    if (removable_top)
        top_part();
    if (removable_bottom)
        bottom_part();

    // The stem’s local Z=0 is placed at the pump body’s nominal top.
    translate([0, 0, pumpkin_height]) detachable_stem();

    // carrying_handle() already includes both rotation and mounting height.
    if (print_handle)
        carrying_handle();

    // Each arm is positioned on the body’s X-side and roughly mid-height.
    // scale([side,1,1]) mirrors the left arm. A 90-degree X-rotation converts
    // the arm’s print orientation into a vertical mounting orientation.
    // The final translation centers the extruded arm around its socket hole.
    if (print_arms)
        for (side = [-1, 1])
            translate([side * half_width, 0, pumpkin_height * 0.49])
                scale([side, 1, 1])
                    rotate([90, 0, 0])
                        translate([0, 0, -attachment_diameter / 2])
                            printable_arm();

    // Feet are placed under their holes. Z=-12 matches the foot’s combined
    // base and transition height, so the mounting pin reaches up to the body’s bottom.
    if (print_feet)
        for (side = [-1, 1])
            translate([side * half_width * 0.24, 0, -12])
                printable_foot();
} else if (layout == "Arms only") {
    // Useful for quick preview, thumb-direction check, or separate arm export.
    // The 90 mm spacing between arm origins accommodates even the longest hand
    // and lantern profiles.
    for (side = [-1, 1])
        translate([side * 45, -25, 0])
            scale([side, 1, 1])
                printable_arm();
} else {
    // All other layout values are treated as print layout. Parts are spread out
    // with flat faces against the build plate and clearance between components.

    // If the bottom is detachable, the mid-body is lowered by seam_height so its new
    // lowest point sits at Z=0. Otherwise, the original bottom already rests on Z=0.
    translate([0, 0, removable_bottom ? -bottom_seam : 0])
        main_body();

    // The top lid is shifted right and flipped upside-down. Its highest original
    // Z-value thus lands on the build plate as a wide, stable print surface.
    if (removable_top)
        translate([pumpkin_width + 25, 0, pumpkin_height])
            rotate([180, 0, 0])
                top_part();

    // The bottom lid is already oriented with its flat side down and only needs to be
    // moved left if activated.
    if (removable_bottom)
        translate([-pumpkin_width - 25, 0, 0])
            bottom_part();

    // The stem is placed next to the top lid and rotated so the cut flat
    // Y-side from detachable_stem() faces the build plate. Z compensation places
    // the plane exactly around Z=0 despite the stem base’s radius.
    translate([
        pumpkin_width + 25,
        -pumpkin_depth * 0.6 - 25,
        stem_base_radius - 0.6
    ])
        rotate([90, 0, 0])
            detachable_stem();

    // printable_handle() is already constructed flat in the XY-plane and only needs to be
    // moved forward of the pump body in positive Y direction.
    if (print_handle)
        translate([0, pumpkin_depth / 2 + 25, 0])
            printable_handle();

    // Arms retain their flat construction orientation. The left arm is mirrored
    // to form a symmetric pair without duplicating geometry code.
    if (print_arms)
        for (side = [-1, 1])
            translate([side * 45, -pumpkin_depth - 25, 0])
                scale([side, 1, 1])
                    printable_arm();

    // Feet stand with their flat underside at Z=0 and are placed farthest back in
    // the layout to avoid collision with the arms’ longer profiles.
    if (print_feet)
        for (side = [-1, 1])
            translate([side * 30, -pumpkin_depth - 75, 0])
                printable_foot();
}
