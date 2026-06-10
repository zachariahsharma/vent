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

## Pending PCB Routing

No outstanding routing issues at this time. Latest DRC clean per `Puck-drc.rpt`.
