# Organic snake — parametric OpenSCAD sculpt

One stable editable OpenSCAD file: \`organic_snake.scad\`.
Track model revisions with Git commits, **not** new numbered SCAD files.

## Geometry and status
- Concept-only organic snake. No functional articulation.
- Source baseline: v25 (2026-11-15). Eye/nose morphology was not visually approved.
- Original design reference and historical v01-v29 CAD/QA outputs are **preserved unchanged** in:
  \`../link/scad/organic_snake_v1/concept_only/\` relative to the \`models\` directory
  (local workstation archive, not included in this Git repository).
- Test desktop OpenSCAD with \`view_mode="body"\` or \`view_mode="head"\`.
- Keep the body taper, tail and cosmetic seams unless explicitly approved.
- STL, image exports and comparison boards are generated outputs, excluded from Git.
- Source file SHA-256 for this baseline: \`1864c3fd18a33ef9790deaf134e61c0f0c685cb05506c1e6f5593656525a5b54\`.

## Git development
Commit changes to the same \`organic_snake.scad\` file with meaningful commit messages.
The last technical baseline, regression results, and visual findings should be kept here.
The surrounding \`models\` repository may have unrelated local edits — do not stage
or commit those files as part of this project.
Local changes in this public repository must not be pushed without owner approval.
