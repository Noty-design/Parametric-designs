# Dovetail OpenSCAD Model

`dovetail.scad` generates a matching male dovetail and female bracket for mounting a printed part to another surface. All dimensions are in millimeters.

## Coordinate System

- `X`: width
- `Y`: depth or wall thickness
- `Z`: height

## Main Parts

- `dovetail_male()` creates the flat backing plate and the projecting dovetail rail.
- `dovetail_female()` creates the receiving bracket, stop, optional ribs, and optional screw holes.
- `female_rail_ribs()` adds side reinforcement ribs to the female bracket when enabled.
- `screw_hole_with_countersink()` cuts through holes and optional countersinks.
- `screw_countersink_at()` cuts one conical countersink or cylindrical counterbore at a chosen surface.

## Important Parameters

- `show_dovetail`: show or hide the male dovetail in preview.
- `show_bracket`: show or hide the female bracket in preview.
- `mirror_backstop`: rotate the preview 180 degrees around the Y axis.
- `color`: preview color used by OpenSCAD's `color()` call.
- `dovetail_width_wide`: outer/wide dovetail width.
- `dovetail_width_narrow`: inner/narrow dovetail width.
- `dovetail_depth`: dovetail projection depth.
- `dovetail_tolerance`: clearance added to the female slot.
- `dovetail_plate_width`: male backing plate width.
- `dovetail_plate_thickness`: male backing plate thickness.
- `dovetail_plate_height`: male part height.
- `female_backstop`: stop height below the female slot.

## Screw Holes

The male and female parts have independent screw-hole settings. Set the matching `show_*_screw_holes` parameter to `false` to produce a solid part without screw holes.

Countersinks support three styles:

- `none`: no countersink.
- `cone`: conical countersink.
- `cylinder`: cylindrical counterbore.

Countersink side values:

- `front`: cuts the front/slot-facing side.
- `back`: cuts the back/plate-facing side.
- `both`: cuts both sides.

## Printing Notes

- Start with `dovetail_tolerance = 0.25` and adjust for your printer and filament.
- Increase tolerance if the male part binds in the bracket.
- Decrease tolerance if the fit is too loose.
- Enable `dovetail_female_rail_rib_depth` when the female bracket needs more strength during flat-back printing.
- Keep `dovetail_female_backstop_bridge_height` above zero if you want the exported female bracket to remain one connected body.

## Export Workflow

1. Open `dovetail.scad` in OpenSCAD.
2. Set `show_dovetail = true` and `show_bracket = false` to export only the male part.
3. Set `show_dovetail = false` and `show_bracket = true` to export only the female bracket.
4. Render with `F6`.
5. Export the rendered part as STL or 3MF.
