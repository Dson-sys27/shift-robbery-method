# SHIFT: Methods for Robbery — Game Design Document

| Campo | Valor |
|---|---|
| **Versión** | 0.4 |
| **Fecha** | 2026-11-26 |
| **Equipo** | ✅ Hugo, Daniel, Sam, Samuel, Álvaro y David (6 personas) |
| **Roles** | ❓ P94 |
| **Estado** | Borrador |

> **Leyenda:** ✅ = definido por ti. ❓ **Pn** = hueco pendiente. 💡 = propuesta mía a validar. ⚠️ = asunción mía a partir de tus respuestas: confírmala o corrígela.

---

## 1. Visión general

### 1.1 Logline
Estudia la escena, ejecuta el golpe por turnos e invierte lo robado: un juego casual de sigilo táctico en pixel art isométrico donde cada día robas más, el botín se invierte en objetos y un solo fallo te manda al principio.

### 1.2 Resumen ejecutivo
*SHIFT: Methods for Robbery* es un juego 2D en pixel art con perspectiva isométrica. Cada día se divide en tres fases: **Search** (inspeccionar y planificar), **Heist** (robo por turnos, estilo tactics) e **Invest** (un menú donde gastar el dinero robado en objetos). Una partida dura de **5 a 9 días**, con robos de dificultad creciente en un **Banco, un Museo o un Casino**, y el objetivo es **acumular el mayor dinero posible para el último día**. Si pierdes, empiezas de nuevo.

### 1.3 Ficha técnica rápida

| Aspecto | Detalle |
|---|---|
| **Género** | ✅ Tactics, Roguelike, Estrategia |
| **Plataformas** | ✅ PC |
| **Motor / lenguaje** | ✅ Godot 4.7.2 / GDScript |
| **Perspectiva** | ✅ 2D pixel art isométrico, sprites de 16×16 |
| **Modos** | ❓ P4 (⚠️ un jugador) |
| **Idiomas** | ✅ Inglés y español |
| **Tono** | ✅ Casual |
| **Duración** | Partida de 5–9 días ✅. Duración en tiempo ❓ P5 |
| **Clasificación** | ❓ P6 |
| **Lanzamiento objetivo** | ❓ P7 |

### 1.4 Referencias e inspiraciones
❓ P8

### 1.5 Propuesta de valor única (USP)
- ✅ Tres fases con identidad propia: planificar, ejecutar e invertir.
- ✅ Sigilo por turnos con información totalmente visible: gana quien planifica mejor.
- ✅ Presión creciente: cuanto más te demoras en un nivel, más difícil se pone.
- ❓ P9

---

## 2. Concepto y pilares de diseño

### 2.1 Concepto central
Ser un ladrón metódico: lo tienes todo a la vista y el reto es trazar el mejor plan y ejecutarlo sin errores.

### 2.2 Pilares de diseño
❓ P10. 💡 Propuesta:

| Pilar | Descripción | Cómo se refleja |
|---|---|---|
| 💡 Información total, decisión difícil | Todo es visible; el reto es planificar | Search sin ocultar nada, rutas trazables |
| 💡 Riesgo vs. recompensa | Más tiempo = más botín, pero más peligro | Escalada por turnos |
| 💡 Cada error cuenta | Errores con distinto peso | Sistema de errores (❓ P95) |

### 2.3 Experiencia objetivo
✅ Casual. ❓ P10 (emociones concretas).

### 2.4 Lo que el juego NO es ✅
- Sin combate directo (solo inmovilizar con objetos).
- Sin mejoras permanentes del personaje.
- Sin venta de botín ni de información.
- Sin narrativa profunda ni personajes con personalidad.
- ❓ P11 (más exclusiones de alcance).

---

## 3. Público objetivo y mercado
❓ P12 (perfil), P8 (competencia).

---

## 4. Gameplay

### 4.1 Core loop
```
Día N → SEARCH (inspeccionar y trazar ruta) → HEIST (turnos) → Dinero
      → INVEST (menú: comprar objetos) → Día N+1
      ✖ Captura = pierdes la partida y empiezas de nuevo
```

### 4.2 Loops secundarios
- ✅ Entre días: dinero → Invest → objetos para el siguiente robo.
- ⚠️ Sin mejoras permanentes (✅ P44), cada partida empieza de cero. ❓ P13 (¿algún desbloqueo entre partidas?).

### 4.3 Objetivos del jugador
- **Corto plazo:** robar los objetos que quieras (todos opcionales ✅) y salir.
- **Medio plazo:** acumular dinero y elegir bien qué comprar.
- ✅ **Largo plazo:** acumular el mayor dinero posible para el último día (5–9 días).

### 4.4 Condiciones de victoria y derrota
- ✅ **Derrota:** ser capturado = pierdes la partida y empiezas de nuevo.
- ✅ **Resultado de un robo:** binario; dentro del éxito hay un umbral según el dinero robado. ❓ P82, P83.
- ✅ **Límites de dinero con plazo:** existen metas de dinero con plazos, pero **no son gastos y el dinero no se pierde** al vencer el plazo. ❓ P89 (qué ocurre entonces y cómo se relaciona con el umbral de éxito).
- ✅ **Objetivo final:** mayor dinero posible al llegar al último día. ❓ P85.

### 4.5 Flujo de una partida típica
1. Se presenta el robo del día (❓ P16).
2. **Search:** inspección libre; el jugador decide cuándo avanzar ✅.
3. **Heist:** por turnos hasta salir o ser capturado ✅.
4. **Invest** (menú ✅): se compra entre un número fijo de objetos ✅.
5. Siguiente día; tras el último, fin de partida (❓ P85).

### 4.6 Controles
✅ PC. ⚠️ Teclado y ratón (ideal para tactics por turnos). ❓ P17 (confirmar, ¿mando?).

### 4.7 Cámara
❓ P18 (⚠️ cámara fija o con desplazamiento libre; al ser mapa grande en Search conviene poder moverla).

---

## 5. Mecánicas y sistemas

### 5.1 Mecánicas principales

#### 5.1.1 Fase SEARCH
- ✅ Inspección de cámaras, objetivos, guardias, láseres, objetos de mejora, etc.
- ✅ Sin límite de tiempo, energía ni acciones; el jugador decide cuándo avanzar.
- ✅ Toda la información es visible.
- ✅ No se puede fallar.
- ✅ Sin registro de hallazgos: se apoya en la memoria del jugador.
- ✅ Puede trazar líneas de ruta.
- ❓ P86 (¿qué aporta inspeccionar? ¿las rutas persisten en Heist? ¿son obligatorias o guía?).
- ❓ P75 (¿patrullas y giros de cámara previsualizables?).

#### 5.1.2 Fase HEIST
- ✅ Por turnos, estilo tactics.
- ✅ Sin límite de turnos, pero cuanto más se alarga, más guardias o guardias más poderosos. ❓ P81.
- ✅ Todos los objetivos opcionales.
- ✅ Robar un objeto cuesta entre 0 y varios turnos según su valor.
- ✅ Sin límite de peso ni de cantidad de botín.
- ✅ No se puede abortar: hay que llegar a una **salida**, aunque no hayas robado todo. ❓ P84.
- ✅ Los objetos del equipo son limitados por robo (ver 5.4). 
- ✅ Movimiento y animaciones en **4 ejes** (ver 10). ⚠️ En cuadrícula isométrica, sin diagonales. ❓ P92.
- ❓ P74 (casillas, puntos de acción, costes) · P75 (orden de turnos y patrullas).

**Detección y captura ✅**

| Evento | Efecto |
|---|---|
| Ser **visto** por un guardia | Penaliza **un poco** ❓ P77 |
| Ser **capturado** por un guardia | **Pierdes la partida** ❓ P78 |
| **Dejar pistas/huellas** | Error **grave**, menos que ser visto |
| **Romper el escenario** | Error ❓ P80 |

> ⚠️ Jerarquía interpretada: **Captura > Ser visto > Dejar huellas > Otros**. Tus respuestas P32/P34 se contradicen en el orden de "visto" y "huellas"; ❓ P82 confírmalo.

#### 5.1.3 Errores y resultado del robo
- ✅ La fase Investigate **se ha eliminado** (v0.4). La fase entre robos es **Invest** (ver 5.6).
- ✅ Cada error tiene un valor distinto.
- ✅ Resultado binario; umbral dentro del éxito según el dinero robado.
- ✅ Los errores de Search no cuentan.
- ✅ **Los errores penalizan más a medida que avanzan los días** (ver 5.7).
- ❓ **P95:** sin Investigate, ¿cuándo y cómo se evalúan los errores y se muestra el resultado (al salir del Heist, en tiempo real, al inicio de Invest)?
- ❓ P82 (¿se puede fracasar sin ser capturado?), P83 (¿qué es el umbral?), P35 (presentación), P37 (notoriedad entre días).

### 5.2 Obstáculos y amenazas
| Elemento | Comportamiento | Estado |
|---|---|---|
| ✅ Cámaras | Cono de visión ❓ P76 | Parcial |
| ✅ Guardias | Radio de visión, se mueven por el mapa ❓ P75/P76 | Parcial |
| Láseres | ❓ P38 | Pendiente |
| Otros | ❓ P38 | Pendiente |

### 5.3 Sonido y pistas
- ✅ Cada acción genera una pista de sonido. ❓ P79 (¿mecánica que alerta guardias o feedback?), P80 (huellas y borrado).

### 5.4 Objetos y equipo
- ✅ Objetos de mejora hallables en la escena y comprables en Invest.
- ✅ Objetos que **inmovilizan** guardias (Invest).
- ✅ Los objetos **varían según su tipo** (no todos funcionan igual).
- ✅ **Almacén ilimitado** de objetos comprados, pero **solo se puede llevar un número limitado a cada robo**.
- ✅ **Sin mejoras permanentes** del personaje.
- ❓ P39 (lista de objetos: *a determinar*).
- ❓ P88 (¿cuántos huecos de equipo por robo? ¿fijo o aumenta? ¿qué objetos son consumibles y cuáles reutilizables?).

### 5.5 Economía
| Recurso | Fuente | Sumidero |
|---|---|---|
| Dinero | ✅ Botín robado, con **valor fijo** por objeto | ✅ Solo la fase Invest (no hay otros gastos ni venta) |

- ✅ Existen límites de dinero con plazo que no restan dinero. ❓ P89.
- ⚠️ La tensión central: el dinero es la puntuación final, pero también se gasta. ❓ P85.

### 5.6 Fase INVEST (compra de objetos)
- ✅ Es la tercera fase del día, después del Heist, y es un **menú**.
- ✅ Tiene un **número fijo** de objetos a comprar. ❓ P90 (¿mismos objetos siempre, sorteados por día, se reponen, se puede repetir compra, el precio sube por día?).
- ✅ No se vende nada. ✅ No hay mejoras permanentes.
- ⚠️ Al ser un menú, no hace falta personaje de vendedor.

### 5.7 Estructura de días y dificultad ✅
- **5–9 días** por partida. ❓ P85 (¿aleatorio, fijo o elegible?).
- La dificultad crece por: **tamaño del mapa**, **número de obstáculos** y **mayor penalización de los errores**.
- Dentro de un nivel, además, empeora cuanto más tiempo pasa (✅ 5.1.2).

### 5.8 Inteligencia artificial
- 💡 Guardias con estados: Patrulla / Alerta / Persecución (❓ P77) / Inmovilizado.
- 💡 Navegación sobre cuadrícula con `AStarGrid2D`.

### 5.9 Multijugador
❓ P4

---

## 6. Narrativa y personajes ✅

- **Narrativa mínima:** como mucho una presentación inicial que explique la temática.
- **Personajes:** sin personalidad; son diseños en pixel art 2D.
- **Tono:** casual.
- **Texto:** como mucho una cinemática inicial y diálogos fijos.
- **Idiomas:** inglés y español.
- ⚠️ Sin vendedor con personalidad (Invest es un menú).

---

## 7. Mundo y niveles

### 7.1 Estructura ✅
Cada robo es un nivel formado por **salas creadas a mano que se unen aleatoriamente**. Invest es un menú entre días.

### 7.2 Localizaciones ✅
**Banco, Museo y Casino.**
- ❓ P91: ¿Cómo se reparten por días (aleatorio, en orden, una por partida)? ¿Cada una tiene sus propias salas y tipos de botín?

### 7.3 Generación de niveles
- ✅ Salas a mano + unión aleatoria. ❓ P87 (nº de salas, tamaño, conectores, entrada/salida, presupuesto de seguridad).
- ✅ El **tamaño del mapa crece** con los días (5.7).

---

## 8. Progresión y balance

- ✅ Progresión solo por dinero y objetos de Invest (sin mejoras permanentes ni venta). ⚠️ Sin habilidades ni experiencia (❓ P56 resuelta por P44; confírmalo).
- ✅ Dificultad por días: mapa más grande, más obstáculos, errores que penalizan más.
- ❓ P57 (accesibilidad), P58 (logros), P59 (rejugabilidad).
- Variables clave de balance: valor de cada error y su escalado por día, valor del botín, precio de objetos, escalada de guardias.

---

## 9. Interfaz y experiencia de usuario

### 9.1 Flujo de pantallas
```
Menú → Nueva partida / Continuar (✅ guardado en mitad de una run)
   → [Día N] Search → Heist → Invest (menú) → [Día N+1] … → Fin
```
❓ P35, P85

### 9.2 HUD y feedback
❓ P60 (errores acumulados, botín, equipo, turno, zonas de visión/ruido).

### 9.3 Menús, tutorial, accesibilidad
❓ P61, P62, P57

---

## 10. Arte y dirección visual ✅

- **Estilo:** pixel art 2D isométrico, **sprites de 16×16**.
- ✅ **Producción de arte:** hacen falta más texturas y crearlas o conseguirlas es parte del trabajo del equipo: tilesets y decorado propios para cada mapa (**Banco, Museo, Casino**), **guardias**, cámaras, láseres, objetos de botín, objetos de Invest, UI, etc. ❓ P96 (¿arte propio, packs de terceros o mezcla? Cualquier asset de terceros debe permitir el uso que se le vaya a dar).
- **Animaciones:** solo en **4 ejes** (4 direcciones).
- ❓ P92: tamaño de tile isométrico (con sprites de 16×16), paleta de colores y confirmar si "4 ejes" aplica también al movimiento; ❓ P65 (efectos visuales: ¿también limitados?).
- 💡 Representar conos de cámara y radios de guardias sobre la cuadrícula.
- 💡 En Godot: filtro `Nearest` y escalado entero para mantener el pixel art limpio.
- Tono casual → ⚠️ estética colorida y amigable (❓ P63 confirmar).

---

## 11. Audio y música
✅ Cada acción genera una pista de sonido. ❓ P66, P79

---

## 12. Diseño técnico

### 12.1 Plataforma
✅ PC. Requisitos mínimos ❓ P68.

### 12.2 Tecnología
✅ Godot 4.7.2, GDScript. Control de versiones y build ❓ P67 (💡 Git).

### 12.3 Arquitectura (💡 propuesta)
- **Flujo:** autoload `GameManager` (día, fase, dinero, semilla) con escenas `Search`, `Heist` e `Invest` (menú).
- **Mapa:** `TileMapLayer` isométrico con orden por Y.
- **Turnos:** `TurnManager` con cola de actores; pathfinding con `AStarGrid2D`.
- **Visión:** cálculo por casillas (cono de cámaras, radio de guardias) con bloqueo por muros.
- **Ruido:** bus de eventos `NoiseEvent` (si se confirma ❓ P79).
- **Registro de errores:** recurso `RunLog` que se rellena en el Heist (evaluación ❓ P95).
- **Generación:** salas como `PackedScene` con marcadores de conexión, ensambladas con semilla.
- **Datos:** objetos, errores, Invest y localizaciones como `Resource` (`.tres`).
- **Localización:** textos en tablas de traducción (EN/ES) con `TranslationServer`.

### 12.4 Guardado ✅
- La partida **se puede guardar en mitad de una run**.
- ❓ P93: ¿también en mitad del Heist o solo entre fases/días? ¿Se puede recargar tras perder (permite repetir un fallo) o el guardado se consume al cargarlo?
- 💡 Guardar el estado de la run + la semilla del nivel facilita guardar incluso a mitad de turno.

### 12.5 Rendimiento, telemetría
❓ P68, P70

---

## 13. Monetización
❓ P71

---

## 14. Producción y planificación

### 14.1 Equipo ✅
Hugo, Daniel, Sam, Samuel, Álvaro y David. ❓ P94 (reparto de roles).

### 14.2 Hitos, presupuesto, QA
❓ P7, P72, P73
💡 **Prototipo mínimo:** una sala, turnos en cuadrícula, un guardia con visión, robar un objeto, salir y mostrar un resultado simple.

### 14.3 Alcance
Para 6 personas, ✅ el contenido acotado (3 localizaciones, 4 direcciones, sprites 16×16, narrativa mínima, Invest como menú) es manejable. El mayor coste será el **sistema de turnos/visión/IA**, la **generación de salas** y la **producción de arte** (tres mapas distintos, guardias, etc.).

---

## 15. Riesgos

| Riesgo | Prob. | Impacto | Mitigación |
|---|---|---|---|
| Search aburrido si todo es visible y sin límite | Media | Alto | Definir qué aporta (❓ P86) |
| Resultado del robo poco claro sin fase de veredicto | Media | Alto | Mostrar cada error con su causa (❓ P35, P95) |
| Escalada por turnos mal calibrada | Media | Alto | Prototipo y pruebas tempranas (❓ P81) |
| Salas aleatorias que generen niveles imposibles o triviales | Alta | Alto | Presupuesto de seguridad y validación (❓ P87) |
| Perder todo al fallar frustra, sin mejoras permanentes | Media | Medio | Valorar meta-progresión (❓ P13) |
| Guardar a mitad de run permite repetir fallos (save scumming) | Media | Medio | Definir política de guardado (❓ P93) |
| Poca variedad con solo 3 localizaciones | Media | Medio | Variar salas y objetos (❓ P91) |

---

## 16. Anexos

### 16.1 Glosario
| Término | Definición |
|---|---|
| **Search** | Fase de inspección y planificación |
| **Heist** | Fase de ejecución por turnos |
| **Invest** | Fase de compra de objetos con el dinero robado (menú) |
| **Run** | Partida completa de 5–9 días |

### 16.2 Estado de las preguntas
- **Resueltas ✅:** P1 (equipo), P2, P3, P14, P15, P19–P23, P24–P34, P36, P38 (parcial), P40–P45, P47–P55, P63, P64, P67.
- **Críticas pendientes:** P95, P82, P83, P77, P78, P74, P75, P76, P85, P86, P87, P89.
- **Pendientes:** P4–P13, P16–P18, P35, P37, P38, P39, P56–P62, P65, P66, P68–P73, P79–P81, P84, P88, P90–P94, P96.

### 16.3 Supuestos de diseño de la IA (sin confirmar)
Decisiones que una IA ha tenido que **suponer** para poder avanzar en el código y que **nadie del equipo ha confirmado**. Cualquier IA que asuma algo no definido en este GDD debe añadirlo aquí (no decidirlo en silencio). Cuando el equipo lo valide, se mueve a su sección con ✅ y se borra de esta tabla.

| ID | Supuesto | Relacionado | Dónde se aplica | Autor / fecha |
|---|---|---|---|---|
| S1 | El número de días de la run se sortea al empezar, entre 5 y 9 | P85 | `RunManager.start_run()` | IA de Daniel · 2026-11-26 |
| S2 | Mientras no exista umbral, todo robo del que se escapa cuenta como éxito | P82, P83 | `RunLog.is_success()` | IA de Daniel · 2026-11-26 |
| S3 | El dinero del botín se suma al escapar del Heist, y solo si el robo es un éxito | 5.5, P83, P95 | `RunManager.advance()` | IA de Daniel · 2026-11-26 |
| S4 | La captura termina la run en el acto (pantalla de Game Over), sin pasar por Invest | P78 | `RunManager.fail_run()` | IA de Daniel · 2026-11-26 |
| S5 | Al acabar el último día se pasa a una pantalla de fin de run; luego, vuelta al menú | P85 | `RunManager.advance()` | IA de Daniel · 2026-11-26 |
| S6 | Cada error se registra con un identificador y un peso numérico; el escalado por día aún no se aplica | 5.1.3, 5.7 | `RunLog.add_error()` | IA de Daniel · 2026-11-26 |
| S7 | La partida se puede reproducir con una semilla (misma semilla = misma run) | 12.3, P93 | `RunManager.run_seed` | IA de Daniel · 2026-11-26 |

### 16.4 Historial de cambios
| Versión | Fecha | Cambios |
|---|---|---|
| 0.1 | 2026-11-26 | Primera versión con huecos |
| 0.2 | 2026-11-26 | Integradas P14–P38, P47, P49; añadidas P74–P87 |
| 0.3 | 2026-11-26 | Integradas P1–P3, P39–P45, P48, P50–P55, P63–P67; añadidas P88–P94 |
| 0.3.1 | 2026-11-26 | Añadida la sección 16.3 de supuestos de diseño de la IA (S1–S7) |
| 0.4 | 2026-11-26 | Eliminada la fase Investigate; la tienda pasa a ser la fase **Invest**. Arte como parte del trabajo (10). Añadidas P95, P96 |
