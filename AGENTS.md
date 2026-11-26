# AGENTS.md — Coordination guide for AI assistants

This file is for the AI assistants (Claude, Copilot, Cursor, ChatGPT…) used by each team member.
**Read it fully before changing anything**, together with the GDD.

Team (6): Hugo, Daniel, Sam, Samuel, Álvaro, David. Each person works with their own AI; you are
one of several agents committing to the same repository.

## 1. Sources of truth

| What | Where | Language |
|---|---|---|
| Game design (GDD) | [`docs/GDD_SHIFT_Methods_for_Robbery.md`](docs/GDD_SHIFT_Methods_for_Robbery.md) | Spanish |
| Coordination rules (this file) | `AGENTS.md` | English |
| Work split (owners, folders, contracts) | [`docs/WORK_SPLIT.md`](docs/WORK_SPLIT.md) | Spanish |
| Code, comments, node names, file names, commit messages | the repo | **English** |
| Conversation with your human | — | Spanish |

The GDD marks items as ✅ defined, ❓ **Pn** open question, 💡 proposal, ⚠️ assumption.
**Never treat ❓ or 💡 items as decided.**

## 2. Design assumptions rule

If you need a design decision that the GDD does not define (anything ❓, or not mentioned at all):

1. Ask your human first if the decision is significant.
2. If you must assume something to keep working, implement the **simplest reversible** option, and
3. **Add a row to GDD section 16.3 "Supuestos de diseño de la IA (sin confirmar)"** (in Spanish):
   next free ID (`S8`, `S9`…), the assumption, related GDD question, where it is applied in code, and
   `IA de <name> · <date>`. Also leave a `# TODO: ... (Pn / Sn)` comment at that spot in the code.

Never silently decide game design. Never edit the confirmed (✅) parts of the GDD unless your human
asks for it explicitly.

## 3. Project facts

- **Engine:** Godot 4.7 (GDD targets 4.7.2; 4.7.1 also works). All members must use the same minor version.
- **Language:** GDScript with static typing (`var x: int`, `-> void`).
- **Run it:** F5 starts the run-flow menu. F6 runs the scene currently open (use it for prototypes).
- **Pixel art:** 16×16, texture filter `Nearest` (project-wide), snap 2D transforms to pixel.
- **Input actions:** `move_left/right/up/down` (WASD, arrows, gamepad), `e_interact` (E), `shift_interact` (Shift).

### Known gap between prototype and GDD

The current prototype (casino map, slot machine, refill table, stalker NPC, real-time player movement)
is **top-down and real-time**. The GDD describes **isometric, turn-based, grid movement in 4 directions**.
The team has not yet decided how to migrate. Do not rewrite the prototype to match the GDD on your own;
raise it with your human.

## 4. Repository layout

```
docs/                    GDD and WORK_SPLIT.md (work split), both in Spanish
Scripts/core/            Run flow: RunManager (autoload), RunLog
Scripts/phases/          Phase screens (currently one placeholder)
Scripts/singleton/       Prototype autoloads: GameManager, TerrainGenerator
Scripts/interactive/     Interactive props (InteractivePref base class)
Scripts/player.gd        Player controller
Scenes/phases/           Phase scenes
Scenes/main.tscn         Casino prototype (open it and press F6)
Scenes/scenario|prefabs|npcs|player/
Resources/               TileSets, SpriteFrames
Textures/                Art assets (see licenses below)
```

Conventions: `snake_case` for files, folders, functions and variables; `PascalCase` for node names and
`class_name`; `UPPER_CASE` for constants and enum values. One script per scene, same base name.
Comments are short, in English, using `##` doc comments for classes, exports and public functions.

## 5. Run-flow base (how to plug in your work)

`RunManager` (autoload, `Scripts/core/run_manager.gd`) owns the run state and the loop from GDD 4.1:

```
MENU → SEARCH → HEIST → INVEST → (next day) SEARCH … → RUN_END → MENU
                  └── fail_run() (captured) → GAME_OVER → MENU
```

- **SEARCH:** inspect the level and plan. **HEIST:** turn-based robbery; escaping adds the loot to `money`.
  **INVEST:** a menu where the money is spent on items for the next heist.
- There is **no Investigate phase** (removed in GDD v0.4). When and how errors are evaluated is still open (GDD P95).

- State: `day`, `total_days`, `money`, `run_seed`, `phase`, `run_log`.
- Signals: `phase_changed(phase)`, `money_changed(money)`.
- API for phase scenes: `advance()`, `fail_run()`, `spend(amount) -> bool`, `start_run(seed)`.
- `RunLog` (`Scripts/core/run_log.gd`) records the current heist: `add_loot(value)`,
  `add_error(id, weight)`. The HEIST phase writes to it; it is evaluated when the player escapes.
- Phase scenes **never call `change_scene_*` themselves**; they call `RunManager` and it loads the next scene.

**To build a phase:** create its scene under `Scenes/phases/` (e.g. `heist.tscn`), then replace that
entry in `RunManager.PHASE_SCENES`. Until then every phase uses `phase_placeholder.tscn`, which has
buttons to simulate the flow.

The prototype `GameManager` (`bounty`, `map_size`) overlaps with `RunManager` (`money`). Do not add new
run-level state to `GameManager`; the team will decide how to merge them.

## 6. Git workflow (everyone pushes to `main`, no branches)

Because six people push to the same branch, follow these rules strictly:

1. **Before starting:** `git pull --rebase`.
2. **Small commits, push often** (at least at the end of every work session). Never sit on local work for days.
3. **Before pushing:** `git pull --rebase`, open the project in Godot, run it (F5) and check there are no
   errors in the Output panel. Never push something that does not start.
4. **Scenes (`.tscn`) and `project.godot` merge badly.** Do not edit a scene someone else is working on
   (see section 8). When adding autoloads, input actions or project settings, pull right before and push
   right after.
5. If a rebase hits a conflict in a `.tscn`/`.tres`, do not hand-merge blindly: keep the other person's
   version, then redo your change in the editor.
6. Never commit `.godot/` (already ignored). Do commit `.import` and `.uid` files.
7. **Never** `git push --force`, rewrite history, or delete files you did not create without asking your human.
8. Commit message format: `<type>: <short description>` in English, e.g. `feat: guard vision cone`,
   `fix: player stuck on door caps`, `docs: update GDD assumptions`, `refactor: …`, `art: …`.

## 7. Before you finish a task

- The project opens and runs without new errors.
- New assumptions are listed in GDD 16.3.
- Section 8 and `docs/WORK_SPLIT.md` are updated (task status, requests).
- Tell your human what you changed and what is left.

## 8. Work in progress

The project is split into 6 workstreams, one per person: see **[`docs/WORK_SPLIT.md`](docs/WORK_SPLIT.md)**
for owners, owned folders, contracts between workstreams and the first milestone.
**Only edit the folders of your own workstream**; ask for anything else in its section 5 ("Peticiones entre bloques").

Update this table when you start and finish a task, so other agents avoid the same files.

| WS | Task | Owner | Files / scenes being touched | Status |
|---|---|---|---|---|
| 1 | Run flow base (`RunManager`, placeholder phases) | Daniel | `Scripts/core/`, `Scripts/phases/`, `Scenes/phases/` | Done |
| — | Casino prototype (map generator, props, stalker NPC) | David | `Scripts/singleton/`, `Scripts/interactive/`, `Scenes/main.tscn`, `Scenes/npcs/` | In progress |

## 9. Art and assets

Art is **part of the team's work**, not something already solved. The current textures only cover a
casino prototype. Still needed (GDD 10):

- A distinct tileset and props for each location: **Bank, Museum, Casino**.
- **Guards** (4-direction animations), the player, cameras, lasers, exits.
- Loot objects, Invest items and their icons, UI (HUD, menus).

Rules:

- 16×16 pixel art, 4 directions; keep a consistent palette and scale across locations.
  The GDD targets an **isometric** view: confirm the tile size with the team before producing tilesets (GDD P92).
- Folder layout: `Textures/<location>/` (`bank`, `museum`, `casino`), `Textures/characters/`,
  `Textures/items/`, `Textures/ui/`. Keep third-party packs in their own subfolder with their license file.
- **Every third-party asset must have a license that allows our use.** Add it to the list below
  (name, author, source URL, license) in the same commit that adds the files.
- Prefer one shared `TileSet` per location so rooms built by different people match.

### Asset licenses

| Asset | Folder | License |
|---|---|---|
| Modern Interiors (free version) | `Textures/Interiors`, `Textures/Characters` | **Non-commercial use only** (`Textures/Interiors/LICENSE.txt`) |
| 2D Top Down Pixel Art Tileset Casino | `Textures/casino_assets` | See its `ReadMe.txt` |
