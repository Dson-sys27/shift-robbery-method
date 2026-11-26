# Reparto del trabajo — 6 bloques

El proyecto se divide en **6 bloques de trabajo, uno por persona**. Todos trabajamos con un asistente de IA,
así que el reparto se basa en una regla: **cada bloque es dueño de sus carpetas, y una IA solo edita las
carpetas de su propio bloque.** Los bloques se comunican mediante los contratos de la sección 3, no
editando el código de otros.

Lee antes [`AGENTS.md`](../AGENTS.md). Las dudas de diseño se resuelven en el [GDD](GDD_SHIFT_Methods_for_Robbery.md).

## 1. Bloques

Los responsables aún no están asignados; el equipo los rellenará.

| # | Bloque | Responsable | Carpetas propias |
|---|---|---|---|
| 1 | **Flujo de partida, Invest y objetos** | — | `Scripts/core/`, `Scripts/items/`, `Resources/items/`, `Scenes/phases/invest*` |
| 2 | **Cuadrícula, turnos y jugador** | — | `Scripts/grid/`, `Scripts/turns/`, `Scripts/player/`, `Scenes/player/`, `Scenes/phases/heist*` |
| 3 | **Guardias y seguridad** | — | `Scripts/security/`, `Scenes/security/` (guardias, cámaras, láseres) |
| 4 | **Generación de niveles y salas** | — | `Scripts/level/`, `Scenes/rooms/<localización>/`, `Resources/tilesets/` |
| 5 | **Fase Search, HUD y menús** | — | `Scripts/ui/`, `Scenes/ui/`, `Scenes/phases/search*`, `Scenes/phases/menu*`, `Localization/` |
| 6 | **Arte y audio** | — | `Textures/`, `Audio/`, tabla de licencias de `AGENTS.md` |

### 1 · Flujo de partida, Invest y objetos
- Ciclo de `RunManager`: días, dinero, semilla (GDD 4.1, 5.7).
- Fase **Invest**: menú con un número fijo de objetos, compra y huecos limitados por robo (GDD 5.4, 5.6).
- Datos de objetos como `Resource` (`ItemData`): precio, tipo, consumible o reutilizable (GDD P39, P88, P90).
- Guardado y carga a mitad de run (GDD 12.4, P93).
- Integración: sustituye las fases provisionales a medida que los demás bloques entregan sus escenas.

### 2 · Cuadrícula, turnos y jugador
- Cuadrícula isométrica, conversión casilla ↔ mundo, casillas transitables; pathfinding con `AStarGrid2D` (GDD 5.8, P92).
- `TurnManager`: orden de turnos, puntos de acción, cola de actores (GDD P74, P75).
- Jugador en cuadrícula en 4 direcciones: moverse, robar (0..N turnos por objeto), usar objetos y llegar a una salida (GDD 5.1.2).
- Es dueño del esqueleto de la escena del **Heist**, donde se juntan salas, guardias y HUD.
- Decide cómo se migra el prototipo actual en tiempo real (`Scripts/player.gd`, `Scenes/main.tscn`).

### 3 · Guardias y seguridad
- Guardias con estados: patrulla, alerta, persecución e inmovilizado; la captura llama a `RunManager.fail_run()` (GDD 5.1.2, 5.8, P77, P78).
- Visión: radio de los guardias y conos de las cámaras por casillas, bloqueados por muros; láseres (GDD 5.2, P38, P76).
- Escalada cuanto más dura el robo (GDD P81).
- Registra los errores (ser visto, huellas, ruido…) en `RunManager.run_log` y define cómo se evalúan (GDD 5.1.3, 5.3, P79, P80, P95).
- Puede reutilizar las ideas de A* y deambular del NPC perseguidor actual.

### 4 · Generación de niveles y salas
- Salas hechas a mano como `PackedScene` con marcadores de conexión, unidas al azar con la semilla de la run (GDD 7.1, 7.3, P87).
- Puntos de aparición de guardias, cámaras, botín, entrada y salidas dentro de cada sala.
- El tamaño del mapa y el número de obstáculos crecen con los días (GDD 5.7).
- Tres localizaciones: Banco, Museo y Casino, cada una con sus salas (GDD 7.2, P91).
- Puede partir del trabajo actual de `TerrainGenerator`.

### 5 · Fase Search, HUD y menús
- **Search**: inspección libre del nivel, todo visible, trazado de rutas (GDD 5.1.1, P86, P75).
- HUD del Heist: turno, botín, objetos equipados, capas de visión y ruido (GDD 9.2, P60).
- Pantallas de resultado del robo, game over, fin de run, menú principal y opciones (GDD 9.1, P35, P61).
- Traducción ES/EN con tablas de traducción; todo texto visible pasa por `tr()` (GDD 1.3).

### 6 · Arte y audio
- Tileset y decorado para **Banco, Museo y Casino**; jugador y **guardias** en 4 direcciones; cámaras, láseres,
  botín, iconos de los objetos de Invest e interfaz (GDD 10, P92, P96).
- Sonido para cada acción (GDD 11, 5.3) y música.
- Mantiene al día la tabla de licencias de assets.
- Entrega pronto versiones provisionales (aunque sean tiles de colores) para que el arte nunca bloquee a los demás.

## 2. Archivos compartidos (con cuidado)

Estos archivos son de todos. Haz pull justo antes, cambia lo mínimo, haz push justo después y dilo en el
mensaje del commit.

| Archivo | Quién lo cambia |
|---|---|
| `project.godot` (autoloads, acciones de input, ajustes) | Cualquiera, un cambio cada vez |
| `Scripts/core/run_manager.gd`, `run_log.gd` | Bloque 1; los demás piden los cambios de API |
| `AGENTS.md`, `docs/WORK_SPLIT.md` | Cualquiera, solo para actualizar estado o normas acordadas por el equipo |
| `docs/GDD_*.md` | Solo la sección 16.3 (supuestos), salvo que el equipo decida otra cosa |

## 3. Contratos entre bloques

Hay que acordar estas interfaces pronto. El dueño las escribe primero (aunque sea vacías) para que los demás
puedan programar contra ellas.

| Contrato | Dueño | Lo usan | Forma (primer borrador) |
|---|---|---|---|
| API de cuadrícula | 2 | 3, 4, 5 | `LevelGrid`: `cell_to_world()`, `world_to_cell()`, `is_walkable(cell)`, `blocks_vision(cell)` |
| Actores por turnos | 2 | 3 | Los actores implementan `take_turn() -> void` (con `await`); `TurnManager` emite `turn_started(actor)` y `round_finished(round)` |
| Formato de sala | 4 | 2, 3, 5 | Escena de sala con `TileMapLayer`s + grupos de `Marker2D`: `connector`, `spawn_guard`, `spawn_camera`, `loot`, `exit`, `entrance` |
| Detección → errores | 3 | 1, 5 | `RunManager.run_log.add_error(id, weight)`; la captura llama a `RunManager.fail_run()` |
| Botín | 2 | 1, 5 | `RunManager.run_log.add_loot(value)` al robar un objeto |
| Objetos | 1 | 2, 5 | Recursos `ItemData`; los objetos equipados los expone `RunManager` |
| Escenas de fase | 1 | todos | Se registran en `RunManager.PHASE_SCENES`; las escenas nunca llaman a `change_scene_*` |
| Especificaciones de arte | 6 | 2, 3, 4, 5 | Tamaño de tile, tamaño de sprite y nombres de animación, acordados en la sección 9 de `AGENTS.md` |

Para cambiar un contrato que no es tuyo: pídeselo a su dueño (a través de tu persona) o añade una fila en la sección 5.

## 4. Primer hito — prototipo mínimo (GDD 14.2)

Una sala, turnos en cuadrícula, un guardia con visión, robar un objeto, escapar y mostrar un resultado simple.

| # | Aportación |
|---|---|
| 1 | El flujo va Search → Heist → Invest con escenas reales donde las haya; Invest con 2–3 objetos fijos |
| 2 | Cuadrícula + `TurnManager` + jugador moviéndose en 4 direcciones, robando un objeto y saliendo |
| 3 | Un guardia que patrulla con radio de visión; ser visto registra un error y ser capturado acaba la run |
| 4 | Una sala hecha a mano en el formato acordado, cargada en la escena del Heist |
| 5 | Pantalla de Search que muestra la sala, HUD mínimo del Heist y pantalla de resultado |
| 6 | Tiles provisionales y un sprite de guardia en 4 direcciones al tamaño acordado |

## 5. Peticiones entre bloques

Cuando tu trabajo necesite un cambio en otro bloque, añade una fila aquí en vez de editar su código.

| De | Para | Petición | Estado |
|---|---|---|---|
| | | | |
