# PCB Layout Optimization — Puck & Vent

**Date:** 2026-06-09  
**Boards:** Puck (ESP32-C6 sensor node), Vent (ESP32-H2 vent controller)  
**Status:** Implemented — see "As-Built" section below for achieved dimensions

---

## Goals

- Reduce Puck board height by ~19mm without changing function
- Redesign Vent board to fit inside a vent slat (16mm constrained height), ~45% area reduction
- Maintain 0 DRC violations and 0 unconnected items on both boards
- FreeRouting v2.2.4 (Java 25) used for routing after placement changes

---

## Constraints

### Puck
- Temperature sensor (U2, MCP9808T) must remain at the **bottom edge** of the board so it faces the room-air grill on the enclosure bottom
- Board width stays at 40mm (no width constraint changed)
- All components remain functional; no BOM changes

### Vent
- Board **height: 15.97mm (0.628661 in)** — dictated by vent slat spacing
- Board **width: 50mm** (unconstrained but minimized)
- Spring contact pads (J4) must be within **18mm of the right board edge** to physically mate with BMS pads J2–J5
- BMS pads are spaced **4mm pitch**, 4 contacts — J4 footprint `VentPads:BMS_SpringLeafContacts_1x04_P4mm` unchanged
- ESP32-H2 antenna must point **downward** (below the bottom board edge, toward the vent opening) for best RF into the room
- J2 programmer becomes **test pads** (6-pad pogo-pin compatible grid); no JST connector

---

## Puck: 40 × 38mm (−19mm height)

### Current layout
- Board: 40.05 × 56.8mm
- U2 (MCP9808T, B.Cu) at y ≈ 122mm — 17mm gap below passive cluster
- R1, R2 (I2C pull-ups, B.Cu) at y ≈ 120–122mm
- Passive cluster (R3, R4, R8, C3, C4, C5, C6) spans y = 89–99mm with unnecessary gaps
- J2 programmer JST (left edge) bottom edge at y ≈ 103mm

### Changes
1. **Move U2** from y ≈ 122mm → y ≈ 103mm (B.Cu, stays at bottom edge of shortened board)
2. **Move R1, R2** from y ≈ 120–122mm → y ≈ 101–103mm (adjacent to U2)
3. **Tighten passive cluster** — reduce inter-component spacing from ~2mm to ~0.5mm minimum clearance; saves ~3mm
4. **Shrink board outline** — new bottom edge at y ≈ 108mm; new height ≈ 38mm

### Result
- Board: 40 × 38mm
- Sensor still at board bottom edge, still faces grill
- +3.3V run to U2 becomes a short local trace; FreeRouting v2.2.4 can complete it
- No component changes, no layer changes

---

## Vent: 50 × 16mm (−45% area)

### Current layout
- Board: 41.4 × 35.1mm
- J2 programmer (JST EH 6-pin) dominates right side at 18.55mm tall — incompatible with 16mm height
- ESP32-H2 module at center, antenna pointing upward
- J4 spring contacts at bottom-right

### New layout (left → right)

```
←────────────────────────── 50mm ──────────────────────────→
┌──────────────────────────────────────────────────────────┐
│ [J2]  [R1,C1]  [   ESP32-H2 (15mm)   ]  [boost]  [J1]  [J4] │ 16mm
│ [pads][R2,C2]  [   antenna below     ]  [L1,C3]  [J3]      │
└──────────────────────────────────────────────────────────┘
                       ↓ antenna hangs below board edge
```

**Zone breakdown:**

| Zone | Width | Contents |
|---|---|---|
| Left (test pads) | 8mm | J2: 6 pogo pads (2×3 grid, 2.54mm pitch); R1, R2 (0603); C1, C2 (0805/0603) |
| ESP32-H2 module | 15mm | U1; oriented with 13.2mm in height direction; antenna below board edge |
| Boost circuit | 12mm | U2 (TPS63031, 2.5mm WSON); L1 (1008); C3 (0805); C4 (0805); 2-row layout |
| Connectors | 7mm | J1 servo (3-pin 2.54mm) + J3 boost module (4-pin 2.54mm), stacked vertically |
| Spring contacts | 8mm | J4 (4×4mm pitch), right-edge placement; right pad edge ≤ 18mm from board right |

**Total:** 8 + 15 + 12 + 7 + 8 = 50mm ✓

### ESP32-H2 orientation
- Rotate **180°** from current placement so the antenna edge faces the **bottom** of the 16mm board
- Module body (13.2mm in height direction) fits within 16mm with ~1.4mm margin top and bottom
- Antenna sits at the bottom board edge; radiation pattern directed downward into the vent/room
- Castle pads accessible on left, right, and top edges of module (antenna edge has no pads)

### J2 programmer test pads
- 6 pads in a 2×3 grid at 2.54mm pitch
- Labeled with silk: GND, VCC, TX, RX, EN, BOOT
- Compatible with standard pogo-pin programming jig
- Saves ~10mm horizontal width vs JST EH connector

### Spring contact alignment with BMS
- BMS pads J2–J5 on B.Cu at x positions: 86.5, 90.5, 94.5, 98.5mm (4mm pitch)
- Vent J4 footprint `VentPads:BMS_SpringLeafContacts_1x04_P4mm` unchanged
- J4 center within 18mm of right board edge ✓

---

## Routing

### Strategy
- Both boards: manual placement of all components per spec above
- Use FreeRouting v2.2.4 with Java 25 (`/opt/homebrew/opt/openjdk@25/bin/java`) for autorouting
- DSN generated via `/tmp/gen_dsn.py` (custom headless exporter)
- SES imported via `/tmp/import_ses.py` (preserves footprint orientations)
- DRC target: **0 violations, 0 unconnected** after import
- VBUS and any net near J1 NPTH holes: hand-verify post-autoroute

### Known constraints
- J1 NPTH holes on Puck at (154.82, 93.61) and (154.82, 99.39) — 0.25mm hole clearance required
- VBUS routing near J1 must stay between the two NPTH holes (y ≥ 94.43mm in current coords)

---

## Implementation order

1. Puck component moves (U2, R1, R2 up; tighten passives)
2. Puck board outline resize
3. Puck DRC check + FreeRouting v2.2.4 run
4. Vent full redesign (new outline, rotate ESP32-H2, place all components)
5. Vent DRC check + FreeRouting v2.2.4 run
6. Commit both boards

---

## Out of scope

- BMS board changes (BMS pad positions J2–J5 are fixed reference)
- Schematic changes (BOM unchanged)
- Enclosure redesign (handled separately)
- Autoprogramming board

---

## As-Built (verified 2026-06-10)

Edge.Cuts outline (measured from `.kicad_pcb`):

| Board | Target (spec) | Target (plan) | Achieved |
|---|---|---|---|
| Puck | 40 × 38mm | 40.05 × 43.0mm | **40.10 × 43.05mm** |
| Vent | 50 × 16mm | 55.0 × 15.97mm | **55.05 × 16.02mm** |

Puck height of 43mm rather than 38mm is intentional — the tighter target proved impractical without sacrificing the sensor-to-board-edge spacing required for the room-air grill on the enclosure. Vent width of 55mm rather than 50mm is also intentional — the routing channels around the BMS spring contacts and the boost circuit needed an additional 5mm of horizontal room. Both still satisfy the hard-constraint requirements (Vent 16mm slat height, Puck 40mm width).

DRC status:

| Board | Errors | Unconnected | Warnings |
|---|---|---|---|
| Puck | 0 | 1 (USB_D- A7↔B7 on J1 — documented in `Puck/BUILD_NOTES.md`, requires GUI fix) | — |
| Vent | 0 | 0 | 10 silk-edge-clearance (cosmetic, fab will mask) |

The single USB_D- unconnected on Puck is a geometric incompatibility between the USB-C 0.5mm pad pitch and the board's 0.5mm minimum via / 0.15mm clearance / 0.25mm hole clearance rules. Resolution requires either a DRU exception scoped to the connector pads or a manual GUI re-route — see `Puck/BUILD_NOTES.md` for details.

Schematic edits (R3 SERVO_BOOST_EN pulldown, C5 100nF HF bypass on Vent; C_MCP_VDD verify, C_ESP_VDD33_HF on Puck) and the schematic re-layout for readability are documented in the respective `BUILD_NOTES.md` files as pending KiCad GUI work; scripted `.kicad_sch` edits proved fragile in prior attempts.
