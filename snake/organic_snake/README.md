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
