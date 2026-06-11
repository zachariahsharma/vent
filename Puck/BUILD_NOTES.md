# Puck PCB Build Notes

This note tracks the Puck board state and pending revisions.

## Schematic State

Current capacitor inventory on Puck:

- C3: 10µF (bulk)
- C4: 10µF (bulk)
- C5: 1µF
- C6: 100nF (decoupling)

## Pending Schematic Revisions (Datasheet Review)

The following revisions are recommended from a full datasheet review and must be applied in the KiCad GUI (scripted .kicad_sch edits proved fragile in prior attempts):

1. **C_MCP_VDD: 0.1µF (100nF) X7R 0402 on MCP9808 VDD (pin 1)** — The MCP9808 datasheet (DS25095A) explicitly requires a 0.1µF bypass capacitor on the VDD pin to minimize switching noise on the temperature reading. Verify C6 is connected to U_MCP9808 VDD pin and placed within 1mm of the pin on the PCB. If C6 is allocated elsewhere, add a new 100nF cap.

2. **C_ESP_VDD33_HF: 100nF X7R 0402 within 2mm of ESP32-S3-WROOM-1 VDD33 (pad 3) on PCB** — Espressif's reference design (ESP32-S3-WROOM-1 datasheet rev 1.4) recommends an external high-frequency bypass at the package edge to suppress radio-band noise on the 3.3V rail. Add a 100nF cap symbol from +3V3 to GND in the schematic, then place the footprint within 2mm of pad 3 on the PCB.

## Pending Schematic Re-layout

A full schematic re-layout for readability is pending. Scripted/agent-driven attempts proved unreliable on the sibling Vent project. The proper next step is manual re-layout in KiCad's schematic editor. Target grouping: ESP32-S3-WROOM-1 module with its decoupling caps top-center, MCP9808 with its bypass cap as an isolated cluster, headers/connectors at the bottom.

## Pending PCB Routing

One outstanding unconnected item: **USB_D- A7 ↔ B7 on J1 (USB-C receptacle).**

The USB-C connector exposes D- on both pads A7 and B7 to support cable-orientation independence. They must be electrically tied together. Scripted attempts to route this connection failed against the board's DRC constraints:

- USB-C SMT receptacle pad pitch on A6/A7/B6/B7 row is 0.5mm in Y.
- The board minimum via OD is 0.5mm with a 0.3mm drill (per `Puck.kicad_pro`), and default copper clearance is 0.15mm with 0.25mm hole clearance.
- Any via dropped between A7 and the adjacent A6/B6 pads to reach the B.Cu D- net therefore violates clearance and hole-clearance rules. Routing on a single layer between A7 and B7 directly crosses the A6/B6 pads.

This is a geometric/design-rule incompatibility that needs human judgment to resolve in the KiCad GUI. Possible resolutions (pick whichever fits the layout):

1. Add a DRU exception scoped to J1.A6, J1.A7, J1.B6, J1.B7 lowering clearance/hole_clearance enough to drop a 0.5mm via on or beside A7 — keep this limited to the connector pads only.
2. Route a B.Cu trace from B7 escape eastward, looping outside the connector pad bbox to reach the existing D- net under A7, instead of dropping a via inside the pad row.
3. Use via-in-pad with tented/filled vias (requires fab capability declaration and ECO on stackup).

All other Puck DRC items are clean (0 violations). Latest DRC report: `Puck-drc.rpt`.

## Single-Sided Assembly (2026-06-10)

All 15 components now populate **F.Cu only** (single reflow pass, no bottom-side
assembly). R1, R2, and U2 (previously on B.Cu) were flipped to F.Cu. The board
remains 2-layer copper with vias.

Trade-off: U2 (MCP9808 temperature sensor) no longer faces the enclosure-bottom
grill directly, accepted by design for assembly simplicity.

Post-flip rework in the sensor pocket (right of U2, below J1's body):
- R1 → (148.60, 105.70), R2 → (148.60, 104.80), both rot 0°.
- GND: U2 pads 4–7 linked on F.Cu, one via (141.6, 104.675) to the B.Cu GND pour.
- I2C_SDA / I2C_SCL: F.Cu escapes to vias, routed on B.Cu to the existing trunks.
- +3.3V: R1/R2 link + via (149.1, 105.2) to trunk; U2.pad8 via (142.3, 106.5) +
  B.Cu diagonal to the +3.3V trunk (145.35, 101.45). The bottom F.Cu channel is
  too narrow to route under the SDA via given `min_copper_edge_clearance` 0.5mm,
  so this leg goes on B.Cu.

DRC after conversion: **0 violations**, 1 unconnected (the documented USB_D-
A7↔B7 item below). Backup of pre-conversion board: `Puck.kicad_pcb.bak-pre-singlesided`.

## Applied PCB Fixes

- **B.Cu GND zone stitching (5 vias)** — The B.Cu GND zone was electrically isolated from the F.Cu GND network and from two GND pads (U1.11, U1.52). Five vias were added to bridge: one southern stitching via at (140.05, 92.20), two at U1.11/U1.52 pads (137.35, 84.50) and (137.30, 85.45), and two inside the U1.49 thermal pad row at (141.275, 80.50) and (143.250, 80.50). Resolved 3 unconnected GND items.
