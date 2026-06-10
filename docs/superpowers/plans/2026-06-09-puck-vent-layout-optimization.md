# Puck & Vent PCB Layout Optimization — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Shrink Puck from 40×56.8mm → 40×43mm by closing the sensor dead zone; redesign Vent from 41.4×35.1mm → 55×15.97mm to fit inside a vent slat.

**Architecture:** Each board is modified in-place using KiCAD MCP tools. Components are repositioned, board outlines resized, all traces cleared, then FreeRouting v2.2.4 re-routes from scratch. DRC must reach 0 violations and 0 unconnected before committing.

**Tech Stack:** KiCAD MCP tools (move_component, rotate_component, replace_component, set_board_size, delete_trace, autoroute, run_drc), FreeRouting v2.2.4 at `~/.kicad-mcp/freerouting.jar` with Java 25 at `/opt/homebrew/opt/openjdk@25/bin/java`, kicad-cli for renders.

---

## Reference: Current Board State

### Puck — `Puck/Puck.kicad_pcb`
Board extents: left=124.475 top=66.975 right=164.525 bottom=123.775 (40.05×56.8mm)

| Ref | Value | X | Y | Layer | Rot | Notes |
|---|---|---|---|---|---|---|
| U2 | MCP9808T (temp sensor) | 144.5 | 122.0 | B.Cu | 180 | **Move up** |
| R1 | 4.7kΩ I2C pull-up | 149.5 | 120.75 | B.Cu | 0 | **Move up** |
| R2 | 4.7kΩ I2C pull-up | 149.5 | 121.75 | B.Cu | 0 | **Move up** |
| C4 | 10uF | 143.33 | 96.0 | F.Cu | 0 | **Tighten** |
| C5 | 1uF | 143.33 | 98.25 | F.Cu | 0 | **Tighten** |
| R7 | 10kΩ | 147.08 | 98.25 | F.Cu | 0 | **Tighten** |
| J2 | JST EH 6-pin prog | 127.4 | 100.4 | F.Cu | 90 | Stay put |
| J1 | USB-C | 158.5 | 96.5 | F.Cu | 90 | Stay put |

### Vent — `Vent/Vent.kicad_pcb`
Board extents: left=11.45 top=11.95 right=52.85 bottom=47.05 (41.4×35.1mm)

| Ref | Value | X | Y | Layer | Rot | Action |
|---|---|---|---|---|---|---|
| U1 | ESP32-H2-MINI-1 | 27.0 | 24.0 | F.Cu | 0 | **Reposition + rotate 180°** |
| J2 | JST EH 6-pin prog | 45.0 | 15.0 | F.Cu | -90 | **Replace footprint → 2×3 test pads** |
| J4 | BMS spring contacts | 38.0 | 43.0 | F.Cu | 0 | **Reposition to right end** |
| U2 | TPS63031 boost | 24.0 | 39.0 | F.Cu | 0 | **Reposition** |
| L1 | 2.2uH inductor | 24.0 | 44.0 | F.Cu | 0 | **Reposition** |
| C3 | 10uF VIN | 17.0 | 42.0 | F.Cu | 90 | **Reposition** |
| C4 | 22uF VOUT | 17.0 | 38.0 | F.Cu | 90 | **Reposition** |
| J1 | SG90 servo | 47.0 | 32.0 | F.Cu | 0 | **Reposition** |
| J3 | Boost module header | 36.0 | 37.0 | F.Cu | 90 | **Reposition** |
| R1 | 10k EN pullup | 13.5 | 22.2 | F.Cu | 90 | **Reposition** |
| R2 | 10k BOOT pullup | 41.5 | 20.5 | F.Cu | 90 | **Reposition** |
| C1 | 10uF | 14.0 | 29.0 | F.Cu | 90 | **Reposition** |
| C2 | 100nF | 14.0 | 33.0 | F.Cu | 90 | **Reposition** |

---

## Task 1: Puck — Move Sensor Components Up

**Files:** `Puck/Puck.kicad_pcb`

- [ ] **Step 1.1: Open Puck board**

```
mcp__kicad__open_project: { "filename": "Puck/Puck.kicad_pcb" }
```

- [ ] **Step 1.2: Move U2 (temp sensor) up 17mm — stays on B.Cu**

```
mcp__kicad__move_component: {
  "reference": "U2",
  "position": { "x": 144.5, "y": 105.0, "unit": "mm" },
  "layer": "B.Cu",
  "rotation": 180
}
```

- [ ] **Step 1.3: Move R1 (I2C pull-up) up**

```
mcp__kicad__move_component: {
  "reference": "R1",
  "position": { "x": 149.5, "y": 102.25, "unit": "mm" },
  "layer": "B.Cu",
  "rotation": 0
}
```

- [ ] **Step 1.4: Move R2 (I2C pull-up) up**

```
mcp__kicad__move_component: {
  "reference": "R2",
  "position": { "x": 149.5, "y": 103.25, "unit": "mm" },
  "layer": "B.Cu",
  "rotation": 0
}
```

- [ ] **Step 1.5: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 2: Puck — Tighten Passive Cluster

**Files:** `Puck/Puck.kicad_pcb` (already open)

These moves close the ~2.25mm gaps between C4/C5 and R7.

- [ ] **Step 2.1: Move C4 up 1mm**

```
mcp__kicad__move_component: {
  "reference": "C4",
  "position": { "x": 143.33, "y": 95.0, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 2.2: Move C5 up 1.25mm**

```
mcp__kicad__move_component: {
  "reference": "C5",
  "position": { "x": 143.33, "y": 97.0, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 2.3: Move R7 to match C5 row**

```
mcp__kicad__move_component: {
  "reference": "R7",
  "position": { "x": 147.08, "y": 97.0, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 2.4: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 3: Puck — Resize Board Outline

**Files:** `Puck/Puck.kicad_pcb` (already open)

Current height 56.8mm → new height 43mm. Width stays at 40.05mm.
New bottom edge will be at y ≈ 110mm (board top at 66.975mm + 43mm = 109.975mm).

- [ ] **Step 3.1: Resize board**

```
mcp__kicad__set_board_size: {
  "width": 40.05,
  "height": 43.0,
  "unit": "mm"
}
```

- [ ] **Step 3.2: Render to verify components are within bounds**

```bash
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb render \
  --output /tmp/puck-after-resize.png --width 1600 --height 1200 \
  Puck/Puck.kicad_pcb
```

Visually confirm U2, R1, R2 are inside the new outline and no components are clipped.

- [ ] **Step 3.3: If any component is outside the new outline, move it inside**

Check: if U2 bottom (y ≈ 107.6mm) is below the new board bottom (y ≈ 110mm), it's fine. If the resize tool anchored the board differently, adjust component positions to match. Run DRC to confirm no "off-board" violations.

- [ ] **Step 3.4: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 4: Puck — Clear All Traces and Autoroute

**Files:** `Puck/Puck.kicad_pcb` (already open)

All nets must be cleared so FreeRouting routes clean from the new component positions. FreeRouting v2.2.4 (Java 25 auto-detected via `/opt/homebrew/opt/openjdk@25/bin/java`) should complete +3.3V to U2 now that U2 is close to the main circuit.

- [ ] **Step 4.1: Delete all traces on every net**

Run for each net that has copper: GND, +3.3V, VBUS, USB_D+, USB_D-, I2C_SDA, I2C_SCL, and any remaining. The simplest way — use a Python script:

```bash
DYLD_FRAMEWORK_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
DYLD_LIBRARY_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/bin/python3.9 - <<'EOF'
import sys
sys.path.insert(0, '/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages')
import pcbnew
_w = pcbnew.BOARD(); del _w
board = pcbnew.LoadBoard('Puck/Puck.kicad_pcb')
tracks = list(board.GetTracks())
for t in tracks:
    board.Remove(t)
print(f"Deleted {len(tracks)} tracks/vias")
board.Save('Puck/Puck.kicad_pcb')
print("Saved")
EOF
```

Expected output: `Deleted N tracks/vias` then `Saved`.

- [ ] **Step 4.2: Run FreeRouting v2.2.4 with best-of-3**

```
mcp__kicad__autoroute: {
  "boardPath": "Puck/Puck.kicad_pcb",
  "attempts": 3,
  "targetNets": ["+3.3V", "GND", "VBUS"],
  "passSchedule": [20, 25, 30]
}
```

Expected: all 3 attempts complete with 0 unrouted items. The +3.3V→U2 connection is now a short local trace and should route cleanly.

- [ ] **Step 4.3: Run DRC**

```
mcp__kicad__run_drc: { "reportPath": "/tmp/puck-post-route-drc.rpt" }
```

Expected: `** Found 0 DRC violations **` and `** Found 0 unconnected pads **`

- [ ] **Step 4.4: If DRC shows VBUS hole-clearance violations near J1 NPTH holes**

The two NPTH holes in J1 are at (154.82, 93.61) and (154.82, 99.39) with 0.25mm required clearance. If VBUS traces violate these:

```bash
# Check which VBUS tracks are near the holes
DYLD_FRAMEWORK_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
DYLD_LIBRARY_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/bin/python3.9 - <<'EOF'
import sys, math
sys.path.insert(0, '/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages')
import pcbnew
_w = pcbnew.BOARD(); del _w
board = pcbnew.LoadBoard('Puck/Puck.kicad_pcb')
IU = 1e6
holes = [(154.82, 93.61), (154.82, 99.39)]
for t in board.GetTracks():
    if t.GetClass() != 'PCB_TRACK': continue
    if t.GetNet().GetNetname() != 'VBUS': continue
    sx, sy = t.GetStart().x/IU, t.GetStart().y/IU
    ex, ey = t.GetEnd().x/IU, t.GetEnd().y/IU
    for hx, hy in holes:
        d = min(math.sqrt((sx-hx)**2+(sy-hy)**2), math.sqrt((ex-hx)**2+(ey-hy)**2))
        if d < 0.6:
            print(f"VBUS track ({sx:.3f},{sy:.3f})->({ex:.3f},{ey:.3f}) dist={d:.3f}mm to hole ({hx},{hy})")
EOF
```

If violations found, delete the offending VBUS segments and add back the original HEAD routing for VBUS:

```bash
# Restore original VBUS routing from git HEAD
git show HEAD:Puck/Puck.kicad_pcb > /tmp/puck_orig.kicad_pcb

DYLD_FRAMEWORK_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
DYLD_LIBRARY_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/bin/python3.9 - <<'EOF'
import sys
sys.path.insert(0, '/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages')
import pcbnew
_w = pcbnew.BOARD(); del _w
IU = 1e6
def mm2iu(v): return int(round(v * IU))

orig = pcbnew.LoadBoard('/tmp/puck_orig.kicad_pcb')
board = pcbnew.LoadBoard('Puck/Puck.kicad_pcb')
vbus_net = board.FindNet('VBUS')

# Delete FreeRouting VBUS tracks
for t in list(board.GetTracks()):
    if t.GetClass()=='PCB_TRACK' and t.GetNet().GetNetname()=='VBUS' and t.GetLayer()==pcbnew.F_Cu:
        board.Remove(t)

# Restore original VBUS tracks
for t in orig.GetTracks():
    if t.GetClass()=='PCB_TRACK' and t.GetNet().GetNetname()=='VBUS' and t.GetLayer()==pcbnew.F_Cu:
        nt = pcbnew.PCB_TRACK(board)
        nt.SetNet(vbus_net)
        nt.SetLayer(pcbnew.F_Cu)
        nt.SetStart(pcbnew.VECTOR2I(t.GetStart().x, t.GetStart().y))
        nt.SetEnd(pcbnew.VECTOR2I(t.GetEnd().x, t.GetEnd().y))
        nt.SetWidth(t.GetWidth())
        board.Add(nt)

board.Save('Puck/Puck.kicad_pcb')
print("VBUS restored from HEAD")
EOF
```

Re-run DRC to confirm 0 violations.

- [ ] **Step 4.5: Refill zones**

```
mcp__kicad__refill_zones: {}
```

- [ ] **Step 4.6: Final DRC confirmation**

```
mcp__kicad__run_drc: {}
```

Must show 0 violations, 0 unconnected, 0 footprint errors.

- [ ] **Step 4.7: Snapshot and commit**

```
mcp__kicad__snapshot_project: { "step": "1", "label": "puck_layout_optimized" }
```

```bash
git add Puck/Puck.kicad_pcb
git commit -m "$(cat <<'EOF'
Puck: shrink board 56.8mm→43mm, close sensor dead zone

Move MCP9808T temp sensor (U2) and I2C pull-ups (R1, R2) up 17mm.
Tighten C4/C5/R7 passive cluster. Resize board outline.
FreeRouting v2.2.4 re-routes from scratch; DRC: 0 violations.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: Vent — New Board Outline

**Files:** `Vent/Vent.kicad_pcb`

New board: 55mm wide × 15.97mm tall. Keeps the same top-left anchor (11.45, 11.95).
New extents: left=11.45 top=11.95 right=66.45 bottom=27.92

- [ ] **Step 5.1: Open Vent board**

```
mcp__kicad__open_project: { "filename": "Vent/Vent.kicad_pcb" }
```

- [ ] **Step 5.2: Resize board**

```
mcp__kicad__set_board_size: {
  "width": 55.0,
  "height": 15.97,
  "unit": "mm"
}
```

- [ ] **Step 5.3: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 6: Vent — Replace J2 with Test Pads

**Files:** `Vent/Vent.kicad_pcb` (already open)

Replace the JST EH 6-pin connector (18.55mm footprint) with a 2×3 pin header footprint that acts as pogo-pin test pads. Same 6 signals, much smaller footprint.

- [ ] **Step 6.1: Replace J2 footprint**

```
mcp__kicad__replace_component: {
  "reference": "J2",
  "newComponentId": "J2",
  "newFootprint": "Connector_PinHeader_2.54mm:PinHeader_2x03_P2.54mm_Vertical",
  "newValue": "AUTO_PROG_TESTPADS"
}
```

- [ ] **Step 6.2: Move J2 test pads to left zone**

```
mcp__kicad__move_component: {
  "reference": "J2",
  "position": { "x": 15.45, "y": 19.935, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 6.3: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 7: Vent — Reposition ESP32-H2

**Files:** `Vent/Vent.kicad_pcb` (already open)

The ESP32-H2-MINI-1 module is 15mm wide × 13.2mm tall. Rotated 180°, antenna faces the bottom board edge (into the vent/room). Center at x=26.95 (8mm left zone + 7.5mm = 15.5mm from left board edge + left=11.45 → x=26.95).

- [ ] **Step 7.1: Move and rotate ESP32-H2**

```
mcp__kicad__move_component: {
  "reference": "U1",
  "position": { "x": 26.95, "y": 19.935, "unit": "mm" },
  "rotation": 180
}
```

- [ ] **Step 7.2: Render to verify antenna is at the bottom edge**

```bash
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb render \
  --output /tmp/vent-esp32-check.png --width 1600 --height 600 \
  Vent/Vent.kicad_pcb
```

Confirm visually: the ESP32-H2 comb antenna pattern should be at the bottom of the board (y≈27mm side), the module body mostly inside the board.

- [ ] **Step 7.3: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 8: Vent — Reposition All Remaining Components

**Files:** `Vent/Vent.kicad_pcb` (already open)

Board center Y = 19.935mm. All coordinates in mm.

**Target layout (left → right):**
```
x=11.45          x=19.45      x=34.45       x=46.45    x=57.065
  [J2 pads]      [ESP32-H2]   [boost circ]  [J1][J3]   [  J4  ]
  [R1][R2]       [ant↓]       [U2,L1,C3,C4]            [spring]
  [C1][C2]
```

- [ ] **Step 8.1: Move boost IC (U2 TPS63031)**

```
mcp__kicad__move_component: {
  "reference": "U2",
  "position": { "x": 37.45, "y": 16.5, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.2: Move boost inductor (L1)**

```
mcp__kicad__move_component: {
  "reference": "L1",
  "position": { "x": 41.5, "y": 16.5, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.3: Move C3 (10uF VIN)**

```
mcp__kicad__move_component: {
  "reference": "C3",
  "position": { "x": 37.45, "y": 23.5, "unit": "mm" },
  "rotation": 90
}
```

- [ ] **Step 8.4: Move C4 (22uF VOUT)**

```
mcp__kicad__move_component: {
  "reference": "C4",
  "position": { "x": 41.5, "y": 23.5, "unit": "mm" },
  "rotation": 90
}
```

- [ ] **Step 8.5: Move J1 (servo connector, 3-pin)**

```
mcp__kicad__move_component: {
  "reference": "J1",
  "position": { "x": 48.5, "y": 15.5, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.6: Move J3 (boost module header, 4-pin)**

```
mcp__kicad__move_component: {
  "reference": "J3",
  "position": { "x": 48.5, "y": 24.5, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.7: Move J4 (BMS spring contacts) — right end, within 18mm of right edge**

J4 footprint is 17.77mm wide. Center at x=57.065 puts right edge at 65.95mm (0.5mm clearance from board right at 66.45mm).
Leftmost pad center = 57.065 − 6.0 = 51.065mm → distance from right board edge = 15.38mm < 18mm ✓

```
mcp__kicad__move_component: {
  "reference": "J4",
  "position": { "x": 57.065, "y": 19.935, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.8: Move R1 (EN pullup)**

```
mcp__kicad__move_component: {
  "reference": "R1",
  "position": { "x": 13.0, "y": 14.5, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.9: Move R2 (BOOT pullup)**

```
mcp__kicad__move_component: {
  "reference": "R2",
  "position": { "x": 17.5, "y": 14.5, "unit": "mm" },
  "rotation": 0
}
```

- [ ] **Step 8.10: Move C1 (10uF decoupling)**

```
mcp__kicad__move_component: {
  "reference": "C1",
  "position": { "x": 13.0, "y": 25.0, "unit": "mm" },
  "rotation": 90
}
```

- [ ] **Step 8.11: Move C2 (100nF decoupling)**

```
mcp__kicad__move_component: {
  "reference": "C2",
  "position": { "x": 17.5, "y": 25.0, "unit": "mm" },
  "rotation": 90
}
```

- [ ] **Step 8.12: Render to verify full layout**

```bash
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb render \
  --output /tmp/vent-layout-check.png --width 2000 --height 800 \
  Vent/Vent.kicad_pcb
```

Verify:
- Board is wide and thin (55mm × 16mm)
- ESP32-H2 antenna at the bottom edge
- J4 spring contacts at right end
- No components outside the board outline

- [ ] **Step 8.13: Fix any courtyard violations by adjusting offending component positions**

Run DRC to see courtyard conflicts:

```
mcp__kicad__run_drc: {}
```

For any `[courtyard_overlap]` violations, move the smaller of the two conflicting components by 1–2mm in the clearer direction and re-run DRC. Common adjustments needed:
- J1/J3 near J4 left edge: move J1/J3 left by 2mm each
- Boost components near ESP32 right edge: move boost components right by 1–2mm

- [ ] **Step 8.14: Save**

```
mcp__kicad__save_project: {}
```

---

## Task 9: Vent — Clear Traces and Autoroute

**Files:** `Vent/Vent.kicad_pcb` (already open)

All previous routing is invalid since every component moved. Clear everything, then autoroute.

- [ ] **Step 9.1: Delete all traces**

```bash
DYLD_FRAMEWORK_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
DYLD_LIBRARY_PATH=/Applications/KiCad/KiCad.app/Contents/Frameworks \
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/bin/python3.9 - <<'EOF'
import sys
sys.path.insert(0, '/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/3.9/lib/python3.9/site-packages')
import pcbnew
_w = pcbnew.BOARD(); del _w
board = pcbnew.LoadBoard('Vent/Vent.kicad_pcb')
tracks = list(board.GetTracks())
for t in tracks:
    board.Remove(t)
print(f"Deleted {len(tracks)} tracks/vias")
board.Save('Vent/Vent.kicad_pcb')
print("Saved")
EOF
```

- [ ] **Step 9.2: Run FreeRouting v2.2.4 with best-of-3**

```
mcp__kicad__autoroute: {
  "boardPath": "Vent/Vent.kicad_pcb",
  "attempts": 3,
  "targetNets": ["+3.3V", "GND", "VIN", "VOUT"],
  "passSchedule": [20, 25, 30]
}
```

Expected: 0 unrouted items across all 3 attempts.

- [ ] **Step 9.3: Run DRC**

```
mcp__kicad__run_drc: { "reportPath": "/tmp/vent-post-route-drc.rpt" }
```

Expected: 0 violations, 0 unconnected, 0 footprint errors.

- [ ] **Step 9.4: If unrouted items remain — diagnose**

Check the FreeRouting log at `/var/folders/q1/xm626pld23s6krh18wxz_c_00000gn/T/freerouting/freerouting.log` for which net is stuck:

```bash
grep -E "unrouted|incomplete|Net '" /var/folders/q1/xm626pld23s6krh18wxz_c_00000gn/T/freerouting/freerouting.log | tail -20
```

If a net is stuck, check if its two endpoints have line-of-sight on F.Cu or B.Cu. The most likely culprits:
- ESP32 pads under the module body (may need a via to B.Cu)
- Boost circuit GND return (short trace, adjust position slightly)

Move the stuck component 1–2mm to open a route, re-run autoroute.

- [ ] **Step 9.5: Refill zones**

```
mcp__kicad__refill_zones: {}
```

- [ ] **Step 9.6: Final DRC**

```
mcp__kicad__run_drc: {}
```

Must show 0 violations, 0 unconnected, 0 footprint errors.

- [ ] **Step 9.7: Snapshot and commit**

```
mcp__kicad__snapshot_project: { "step": "2", "label": "vent_layout_redesigned" }
```

```bash
git add Vent/Vent.kicad_pcb
git commit -m "$(cat <<'EOF'
Vent: redesign board 41.4x35.1mm → 55x15.97mm for vent slat fit

Rotate ESP32-H2 180° (antenna points into vent for best RF).
Spring contacts J4 within 18mm of right edge, 4mm pitch matches BMS.
J2 programmer → 2x3 test pad array (pogo-pin compatible).
FreeRouting v2.2.4 re-routes from scratch; DRC: 0 violations.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 10: Final Render and Verification

- [ ] **Step 10.1: Render both boards side by side for review**

```bash
export PATH="/Applications/KiCad/KiCad.app/Contents/MacOS:$PATH"
kicad-cli pcb render --output /tmp/puck-final.png --width 1600 --height 1600 \
  Puck/Puck.kicad_pcb
kicad-cli pcb render --output /tmp/vent-final.png --width 2200 --height 800 \
  Vent/Vent.kicad_pcb
```

- [ ] **Step 10.2: Confirm Puck specs**

- Board height ≤ 44mm (was 56.8mm)
- U2 temp sensor at bottom edge (high Y value), within 5mm of board bottom
- 0 DRC violations

- [ ] **Step 10.3: Confirm Vent specs**

- Board height = 15.97mm (0.628661in ±0.1mm)
- Board width ≈ 55mm
- ESP32-H2 antenna at bottom edge
- J4 spring contacts: all 4 pads within 18mm of right board edge
- 0 DRC violations, 0 unconnected

- [ ] **Step 10.4: Commit spec doc update with final dimensions**

```bash
# Update the spec with actual achieved dimensions
git add docs/superpowers/specs/2026-06-09-puck-vent-layout-optimization.md
git commit -m "docs: update spec with actual achieved board dimensions

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

---

## Known Issues / Watch Points

| Issue | Where | What to do |
|---|---|---|
| VBUS traces near J1 NPTH holes | Puck, Task 4.4 | Restore VBUS from HEAD if FreeRouting violates 0.25mm hole clearance |
| `PCB_VIA::GetWidth called without layer` | Puck trace delete script | Harmless warning, ignore |
| `SwigPyObject has no attribute` if LoadBoard called twice in one process | Both boards | Use separate Python processes for each script |
| Courtyard overlaps at initial placement | Vent, Task 8.13 | Adjust component positions 1–2mm and re-check DRC |
| FreeRouting stuck net | Vent, Task 9.4 | Check log, move component slightly, retry |
