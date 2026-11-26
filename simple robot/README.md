# Simple Robot

The primary parametric model is `simple_robot.scad`. Choose PLA, PETG or Manual and Loose, Medium or Tight in the Customizer. The print layout, assembled view and joint calibration layout remain available. The other joint styles are retained.

Digital validation at the default dimensions: the PLA and PETG ball-joint versions both export as 11 closed, separate bodies in print and assembled layouts; the calibration layouts each export as six closed bodies. Physical snap-fit and durability testing are still pending. Print the calibration pairs before the full robot. Inspect the slicer preview, use local support under the horizontal balls if required, and keep support out of sockets and relief slots.

`stl/simple_robot.stl` is the updated PLA Medium export. The pre-existing `stl/simple_robot_1.stl` and `3mf/simple_robot_U1.3mf` are legacy exports from before the joint update; regenerate them from the current model before using them to evaluate the new design. Local calibration STLs, PETG export, comparison images and archived baseline are kept in the ignored `fit_test/` folder when present.
