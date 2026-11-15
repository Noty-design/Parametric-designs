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
