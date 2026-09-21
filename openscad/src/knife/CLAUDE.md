# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

An OpenSCAD parametric model for a dish-rack-style knife stand (칼꽂이), designed to be 3D-printed on an Ender-3. It is one subproject inside the larger `resource3d` repo (`openscad/src/knife`); the repo root also contains an unrelated React/Three.js viewer app — ignore that unless a task explicitly touches it.

Read `README.md` first — it documents the physical requirements (must be well-ventilated, non-plastic-feeling, knives must sit at an angle) and the measured dimensions of every knife/scissor the rack must hold (blade thickness/width, handle thickness). Any change to slot geometry should be checked against those numbers.

## Commands

There is no build system beyond invoking OpenSCAD directly (`C:\apps\openscad-2021.01\openscad.exe` in the existing scripts). There are no automated tests; correctness is checked by opening a `.scad` file in the OpenSCAD GUI (live preview via F5) and visually inspecting the render, then exporting to STL and eyeballing/slicing it.

- **Preview/edit a file interactively**: open it in the OpenSCAD GUI. Every `.scad` file below the top level ends with a call to its own `main()`/`build()`/`samples()` and can be opened and rendered standalone.
- **Batch STL export**: `build-knife.bat` (run from this directory). It clears `stl/*.stl` and re-exports the `top/landscape.scad` and `body/body.scad` variants (front/side/joint halves, prototype vs. final) using `-D` command-line overrides for `thick`, `margin`, `delta`, etc.
- **Export a single variant from the CLI**, mirroring the pattern in `build-knife.bat` / the comment block at the bottom of `body/basis.scad`:
  ```
  openscad.exe --export-format asciistl -o out.stl -D command=<n> knife.scad
  ```
  Check the `usage()` module inside the target file's `main()` for what each `-D command=N` / `-D target=N` value renders (e.g. `knife.scad`'s `command=1..4` render different sub-assemblies of the top/bottom plates).
- Files named like `basis#37.scad`, `under#38.scad`, `foot#28.scad` are numbered snapshots (the `#NN` is the GitHub issue the revision was made for). Only the file currently `use`d from `knife.scad` is live; older-numbered siblings are kept for history/reference, not deleted.

## Architecture

**Data-driven, not hardcoded.** Nearly every module takes a single `data` (or `param`) map instead of individual arguments. The map is built with `object([[key, value], ...])` (defined in `../common/library_function.scad`) and looked up with `data["key"]`. Keys are Korean phrases describing the physical quantity (e.g. `"몸체.회전"` = body rotation, `"기초.두께"` = base thickness, `"벽.위치.1"` = wall position 1) — dotted names loosely group related fields. `knife-data.scad` defines the canonical `DEFAULT` map; `DEFAULT0` holds the hand-authored base values and `DEFAULT` derives a couple of computed fields (e.g. outer body size) from it. When adding a dimension, extend `DEFAULT0`, not `DEFAULT`.

**Composition via position/rotation wrapper modules.** Geometry-producing modules are composed with small modules that only `translate`/`rotate` their `children()` into place — see `under.scad`'s `basis0p`/`basis1p`/`basis2p` ("전체 구조물을 상판위에 비스듬이 돌려서 얹는다" — orient the whole assembly at an angle atop the top plate; "벽 구조물을 세운다" — stand a wall up). `knife.scad`'s `main()` shows the pattern: chain these placement modules and call an actual solid-producing module (`under20`, `basis01_type_4_assemble`, ...) as their child. When adding a new part, prefer writing it in its own local coordinate frame and giving it a placement wrapper rather than baking absolute offsets into the geometry module.

**File layout / dependency direction**:
- `knife-data.scad` — shared parameter map (`DEFAULT0`/`DEFAULT`). `include`d (not `use`d) almost everywhere so its globals are visible.
- `knife.scad` — top-level assembly entry point; `use`s the modules below and drives them from `main(command)`.
- `under.scad`, `knife-before.scad` — placement helpers and legacy/support geometry.
- `body/` — the main structural pieces (`basis*.scad` = the angled body/knife-holder assembly, `wall.scad` = the wall/foot the body rests against, `under#38.scad` = lower cross-supports, `body.scad`/`bodyOnePiece.scad`/`body_assemble.scad` = alternate body constructions, `common.scad` = shared board/window/bulge helper modules for this folder).
- `top/` — the perforated top plate the knives slot into (`landscape.scad`/`portrait.scad` orientations; `common.scad` defines the `punch()` module that cuts the knife/scissor slot pattern, sized from the README's measured blade dimensions).
- `etc/` — small standalone utilities (`utils.scad`, `measure.scad`), largely superseded by `../common/` but kept for files that still reference them.
- `diag/` — one-off diagnostic models (checking printer angle/degree behavior), not part of the assembly.
- `stl/` — build output of `build-knife.bat`; treat as disposable/regeneratable.
- `../common/` (one level above `knife/`, shared across all `openscad/src/*` projects) — `constants.scad` (global constants like `EPSILON`, `FN`, `HR`, nut/bolt radii — `include` this, don't redefine these constants locally), `library_function.scad` (`object`/`get` map helpers, vector rotation math, string helpers — `use` this), `library.scad`, `library_text.scad` (the `note()` annotation-text helper seen throughout), `library_cube.scad`/`library_line.scad`/`library_trimmer.scad`.

**Debug annotations are part of the modeling convention, not incidental.** Modules consistently `echo()` their name and parameters on entry (often via a `parent_module(0)` string), and render dimension labels with `note()`/`%` (background/transparent preview modifier) directly in the model so measurements are readable in the OpenSCAD preview. Follow this convention in new modules — it's how dimensions get sanity-checked without a debugger.

**Units**: all dimensions are millimeters, matching caliper-measured real knives/plates recorded in `README.md`.
