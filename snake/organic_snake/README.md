# Organic snake — parametric OpenSCAD sculpt

One stable editable OpenSCAD file: \`organic_snake.scad\`.
Track model revisions with Git commits, **not** new numbered SCAD files.

## Geometry and status
- Concept-only organic snake. No functional articulation.
- Source baseline: v25 preserved in Git history. Current best technical candidate: **v28** (2026-11-15). Visual likeness is not approved.
- Original design reference and historical v01-v29 CAD/QA outputs are **preserved unchanged** in:
  \`../link/scad/organic_snake_v1/concept_only/\` relative to the \`models\` directory
  (local workstation archive, not included in this Git repository).
- Test desktop OpenSCAD with \`view_mode="body"\` or \`view_mode="head"\`.
- Keep the body taper, tail and cosmetic seams unless explicitly approved.
- STL, image exports and comparison boards are generated outputs, excluded from Git.
- Current source SHA-256: \`8b888f17839d7d4c82aa63546b5b06f1aa14cda3b6b9c24ff490fcb843b88236\`.
- v28: CAD PASS, watertight body/head STL; Brepia Viewer PASS on desktop/mobile. Eye facets remain visible in native OpenSCAD rendering.
- v26/v27 were too flat; v29 showed more faceting, so v28 was chosen over these trials.
- Full QA is retained in the original local archive: \`validation_sculpt_v28.json\`, \`viewer_import_qa_v28/\` and \`concept_comparison_v28_v29_closeup.jpg\`.

## Git development
Commit changes to the same \`organic_snake.scad\` file with meaningful commit messages.
The last technical baseline, regression results, and visual findings should be kept here.
The surrounding \`models\` repository may have unrelated local edits — do not stage
or commit those files as part of this project.
Local changes in this public repository must not be pushed without owner approval.

## Subsequent head iteration: higher resolution (2026-11-15)

- A higher-resolution experimental candidate was tested in the ignored \`_build/\` directory; the tracked model stayed unchanged.
- The candidate raised mesh resolution to \`ring_faces=96\` and \`section_step=1.20\` while adjusting eye dimensions and muzzle roundness.
- Native OpenSCAD exports passed solid/watertight verification: head 17,818 triangles, whole body 56,730 triangles.
- Production Brepia Viewer full-resolution desktop import **timed out**, so this is not an acceptable default model.
- A reduced-resolution version (\`ring_faces=64\`, \`section_step=1.45\`, 33,706 body triangles) imported on both desktop and mobile, but the sculpted eye remained faceted and was not visually better than v28.
- Preserve v28 as the active Git model. No high-resolution trial was committed to the main source.
- Local visual evidence: \`_build/candidate_comparison.jpg\` and \`_build/balanced_candidate_comparison.jpg\` (ignored by Git).
- Test evidence: Dquark native CAD https://github.com/weaf/local-ai-orchestrator/actions/runs/43752473804
- Viewer https://github.com/weaf/local-ai-orchestrator/actions/runs/43752616048
- Balanced CAD/visual https://github.com/weaf/local-ai-orchestrator/actions/runs/43752799500

Next: improve the eye as a smooth local sculpt at the current proven mesh resolution. Do not globally increase tessellation without a comparable Viewer pass.

## Local eye mesh redistribution checkpoint (2026-11-15)

- Single editable model remains `organic_snake.scad`, now SHA-256: `9c996bd14f240af02ceac469cb4dd870e3748b888e74d62f68b9add8627cb428`.
- Reallocates longitudinal mesh stations around the head and eye (`xv(i)`), while keeping the overall number of sections.
- Reallocates the same 64 angular ring vertices towards the lateral eye through a monotonic 13-degree sine warp that fades by x=61 mm. No functional segments or new solid components.
- Softens the analytic eye relief and lip width. Concept likeness is **still pending owner visual acceptance**.
- Body profile control stations, taper, cosmetic seams, joint-free solid construction and tail parameters are otherwise unchanged.
- Other tested variants (adaptive13, adaptive17, axial-only) remain local ignored development evidence, not separate tracked model versions.
- Native OpenSCAD CAD PASS for both solid, watertight body and head; body 33,748 STL triangles, head 15,058 triangles.
- Compared with v28 STL, body volume change -0.0652%, head volume change -0.2029%.
- Production Viewer PASS at 1280x800 desktop (18.0 seconds) and 390x844 mobile (16.4 seconds), without timeout or page errors, importing the full SCAD source.
- CAD evidence: `_build/eye_adaptive_20261115/selected_cad_qa.json`
- Viewer evidence: `_build/eye_adaptive_20261115/viewer_selected/report.json`
- Visual comparison: `_build/eye_adaptive_20261115/axial_comparison.jpg`
- Dquark candidate CAD review: https://github.com/weaf/local-ai-orchestrator/actions/runs/43753682802
- Dquark CAD and production Viewer acceptance: https://github.com/weaf/local-ai-orchestrator/actions/runs/43753907156

Next: compare head eye relief with original concept at consistent camera scales; consider a truly almond-shaped inner socket profile without increasing global mesh resolution or removing the accepted eye shape. Do not push without owner authorization.

## Model colors and visible almond eyes (2026-11-16)

- Editable model stays at snake/organic_snake/organic_snake.scad and uses Git history instead of numbered variants.
- Warm ivory body color #E4D1B6 and dark slate eye color #292B33 are real OpenSCAD color() definitions with editable parameters.
- Two shallow physical eye inlays follow the head surface, intersect the body and remain embedded in one watertight 3D model.
- Eye inlay defaults to visible; show_eye_inlay disables it. Color is displayed in OpenSCAD F5 preview.
- Production Brepia Viewer desktop and mobile accepted the full-resolution SCAD and reported 2 RGB colors, no preview timeout or page errors.
- Viewer Fast STL preview and ordinary STL export may display no color: STL has no color channel; change to a color-capable preview or export path where supported.
- OpenSCAD desktop 2021.01 3MF exporter was observed to emit no explicit color group or base material; do not claim a colored 3MF from this exporter.
- Native OpenSCAD body/head STL: CAD PASS, watertight, one volumetric geometry, 34352 and 15662 faces respectively.
- Reference source SHA256: 9c996bd14f240af02ceac469cb4dd870e3748b888e74d62f68b9add8627cb428
- New source SHA256: de17433e30d14072f9e9a942d7cbf4c7728d2f43158ff978bd714000026e5c56
- Evidence (ignored local artifacts): _build/colored_eye_20261116/cad_validation.json, viewer_qa/report.json, colored_eye_variants.jpg.
- Dquark CAD + Viewer proof: https://github.com/weaf/local-ai-orchestrator/actions/runs/43805929318
- Concept likeness: still awaiting owner visual acceptance; mechanical joints, body and tail unchanged.

## Snake head: natural muzzle and softer eyes (2026-11-16)

- The active model remains the single Git-tracked organic_snake.scad file.
- Owner screenshots exposed a mouse-like head, circular snout tip and eyes too dark and deep.
- Changed the front head profile stations: small rounded tip with a fuller intermediate wedge instead of a cylindrical nose cap.
- Reduced eye lens dimensions, switched the eye material to taupe #A38D79, and reduced eye socket depth, rim and cheek exaggeration.
- The body material #E4D1B6, all body stations behind the anterior head, taper, tail, cosmetic seams and no-joint design are preserved.
- Native OpenSCAD CAD PASS for body and head as watertight volumetric STL. Body faces: 34678; volume delta from previous colored source: 0.162 percent.
- Additional head CAD PASS with user Customizer parameters: head_width_scale 0.90, head_height_scale 1.05, muzzle_shortening_mm 12, curve_amplitude 12, ring_faces 73, eye length 5.8, height 2.6, brow 0.9.
- Production Brepia Viewer PASS on desktop 1280x800 and mobile 390x844, with 2 RGB colors and no timeout.
- Concept visual likeness remains pending owner review. Do not call the model concept accepted yet.
- Previous source SHA256: de17433e30d14072f9e9a942d7cbf4c7728d2f43158ff978bd714000026e5c56
- New source SHA256: ceeac6bed10e67f10bcdf837c90e90ae4d167c7df81bc6d164217a70d45f2cc1
- Local ignored evidence: _build/muzzle_concept_20261116/blunt_refinement_comparison.jpg, corrected_nose_camera_comparison.jpg, cad_selected.json and viewer_blunt_soft/report.json.
- Dquark CAD and Viewer evidence: https://github.com/weaf/local-ai-orchestrator/actions/runs/43816307574
- No push to the public Git remote.

## Fuller 3D serpent head reconstruction (2026-11-16)

- Owner compared the current OpenSCAD front and side screenshot with the original concept and reported the head still looked flat and mouse-like. Previous changes affected details more than the primary 3D silhouette.
- Several uncommitted CAD trials were compared from three-quarter, side, top and nose-facing perspectives. The best evaluated candidate is soft_nose, which widens the anterior muzzle, builds volume in the forehead/cranium, and rounds the nose tip.
- This is a substantive re-sculpt of head stations before x=68 and local dorsal/nose and lower-cheek features; the established torso/tail profile stations are retained and joint-free concept mode is unchanged.
- Smooth gradual anterior station shortening now replaces the abrupt profile compression that contributed to the cylinder-like muzzle.
- Body retains ivory #E4D1B6, eye inlays retain muted taupe #A38D79. No changes to Brepia Viewer or other model files.
- Two Customizer metadata errors have been corrected: eye_inner_lift default 0.14 is now within its declared slider range and curve_amplitude default 24 within its slider range. Owner screenshot showed two warnings, but their actual error-log messages were not observed; this is the likely reason.
- Verified OpenSCAD native head and body STL are watertight and volumetric; body STL 35428 triangles, and body volume changed by 8.677 percent relative to the previous candidate.
- OpenSCAD head STL with the current Customizer defaults passed CAD geometry checks.
- Production Brepia Viewer passed desktop and mobile import of full .scad, recognized 2 RGB colors, and reported no timeouts, page or console errors.
- Visual similarity with concept is still subject to owner review; this is a technical checkpoint, not final visual acceptance.
- Prior SHA256: ceeac6bed10e67f10bcdf837c90e90ae4d167c7df81bc6d164217a70d45f2cc1
- Current SHA256: 7c98443afe44c4f3ca68004ec2aec2ca58f00dd6986e063645e41a3b728337bf
- Render/QA evidence ignored by Git: _build/head_redesign_20261116/head_shape_comparison.jpg, head_broad_snout_comparison.jpg, cad_qa.json and viewer_soft_nose/report.json.
- Dquark preview evidence: https://github.com/weaf/local-ai-orchestrator/actions/runs/43826543429
- Dquark CAD and production Viewer evidence: https://github.com/weaf/local-ai-orchestrator/actions/runs/43826741217
- Remote remains unpushed. No other models were changed by this commit.
