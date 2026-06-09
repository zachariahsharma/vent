# DigiKey Sourcing Audit

Date: 2026-06-02

Scope: Autoprogramming, Puck, and Vent PCB BOM items plus all STEP files in the repo.

## STEP Validation

All 20 project-local component `.step` files under `electronics/` passed ISO-10303 structure checks:

- `ISO-10303-21` header present
- `HEADER`, `DATA`, and `END-ISO-10303-21` sections present
- Nonzero STEP entity count

Detailed machine-readable results: `electronics/step-file-validation.json`

KiCad render-load validation also succeeded for the board-attached models in Autoprogramming, Puck, and Vent.

## DigiKey Sourcing Status

### Exact Or Direct DigiKey Parts

| Design item | Current part/value | DigiKey source part |
|---|---:|---|
| Autoprogramming U3 | CP2102N-A02-GQFN28R | CP2102N-A02-GQFN28R, DigiKey 336-5890-1-ND / 336-5890-2-ND |
| Puck U4 | AP2112K-3.3TRG1 | AP2112K-3.3TRG1, DigiKey AP2112K-3.3TRG1DICT-ND / AP2112K-3.3TRG1DITR-ND |
| Puck U2 | MCP9808T-E/MS | MCP9808T-E/MS, DigiKey MCP9808T-E/MSCT-ND / MCP9808T-E/MSTR-ND |
| Vent U1 | ESP32-H2-MINI-1-H4S | ESP32-H2-MINI-1-H4S, DigiKey 1965-ESP32-H2-MINI-1-H4SCT-ND where available. The older ESP32-H2-MINI-1-N4 is not recommended for new designs. |
| Vent U2 | TPS63031DSK footprint/value | Use TPS63031DSKR, DigiKey 296-39461-1-ND / 296-39461-2-ND |
| Vent J3 | SERVO_5V_BOOST_MODULE | 1x04 2.54 mm header/module interface for a switched 5 V boost rail. Current accepted module class: Pololu `U3V70F5` or electrically equivalent enabled/shutdown-capable fixed 5 V boost regulator. |
| Autoprogramming/Puck J2 | JST EH 1x06 vertical | B6B-EH-A, DigiKey 455-1615-ND |
| Puck U1 | ESP32-C6-MINI-1-H4 | ESP32-C6-MINI-1-H4, DigiKey 1965-ESP32-C6-MINI-1-H4CT-ND / TR / DKR |
| BMS RT1 | NCU15XH103F60RC | NCU15XH103F60RC, DigiKey 490-18149-1-ND / 490-18149-2-ND / 490-18149-6-ND |

### BMS Package Review Note

Satish's BMS package concern is valid: `BQ25180YBGR` and the `CSD16406Q3` MOSFETs are still no-lead/BGA-style packages. I did not swap those automatically because there is not a low-risk drop-in leaded replacement using the same schematic symbol, footprint, and power-path behavior. For this revision, accept them only for outsourced stencil/reflow PCBA assembly with inspection; redesign the BMS around easier packages if hand assembly is required. The obsolete `NCP15XH103F03RC` thermistor was replaced with active schematic/PCB references to `NCU15XH103F60RC`.

### DigiKey Replacements For LCSC/JLCPCB-Style BOM Lines

| Existing refs | Current LCSC/JLCPCB part | DigiKey replacement |
|---|---:|---|
| Autoprogramming R5/R6, Puck R7/R8 | 10k, 0603, 1%, Uniroyal `0603WAF1002T5E` | Yageo `RC0603FR-0710KL`, DigiKey 311-10.0KHRCT-ND / TR / DKR |
| Autoprogramming R3/R4, Puck R3/R4 | 5.1k, 0603, 1%, Uniroyal `0603WAF5101T5E` | Yageo `RC0603FR-075K1L`, DigiKey 311-5.10KHRCT-ND / TR / DKR |
| Puck R1/R2 | 4.7k, 0402, 1%, Uniroyal `0402WGF4701TCE` | Yageo `RC0402FR-074K7L`, DigiKey 311-4.7KLRCT-ND / TR / DKR |
| Autoprogramming Q1/Q2 | S8050 J3Y SOT-23 NPN | UMW `S8050`, DigiKey 4518-S8050CT-ND / TR / DKR, or Comchip `SS8050-G`, DigiKey 641-1790-1-ND / TR / DKR |
| Autoprogramming C2 | 4.7uF 25V 0805 | Samsung `CL21A475KAQNNNE`, DigiKey 1276-1244-1-ND / TR / DKR |
| Autoprogramming C1, Puck C6 | 100nF 100V 0805 | Samsung `CL21B104KCFNNNE`, DigiKey 1276-6840-1-ND / TR / DKR |
| Puck C3/C4 | 10uF 10V 0603 | Samsung `CL10A106KP8NNNC`, DigiKey 1276-1192-1-ND / TR / DKR |
| Puck C5 | 1uF 50V 0603 | Samsung `CL10A105KB8NNNC`, DigiKey 1276-1860-1-ND / TR / DKR |

### Vent Parts Needing Explicit DigiKey MPN Assignment

These are generic schematic values today, but the following DigiKey parts fit the intended footprints/roles:

| Vent refs | Current value | DigiKey assignment |
|---|---:|---|
| R1/R2 | 10k 0603 pullups | Yageo `RC0603FR-0710KL`, DigiKey 311-10.0KHRCT-ND / TR / DKR |
| C1/C3 | 10uF 0805 | Samsung `CL21A106KAYNNNE`, DigiKey 1276-2891-1-ND / TR / DKR |
| C2 | 100nF 0603 | Samsung `CL10B104KB8NNNC`, DigiKey 1276-1000-1-ND / TR / DKR |
| C4 | 22uF 0805 | Samsung `CL21A226MPQNNNE`, DigiKey 1276-2910-1-ND / TR / DKR |
| L1 | 2.2uH, 1008/2520 metric | Bourns `SRN2512-2R2M`, DigiKey SRN2512-2R2MCT-ND / TR / DKR |
| J1 | 1x03 2.54mm servo header | Sullins `PBC03SAAN`, DigiKey S1011E-03-ND |
| J3 | 1x04 2.54mm servo boost header | Sullins `PBC04SAAN`, DigiKey S1011E-04-ND |
| J2 | 1x06 2.54mm programming header | Sullins `PBC06SFAN`, DigiKey S1211E-06-ND |
| J4 | BMS spring contacts | Harwin S70 series. Candidate: `S70-220102045R`, DigiKey 952-3142-1-ND / TR / DKR. Confirm compression height against the mechanical stack before release. |

### DigiKey-Only Substitution Caveat

| Refs | Current part | DigiKey replacement |
|---|---:|---|
| Autoprogramming J1, Puck J1 | HRO `TYPE-C-31-M-12` | Same Sky `UJ20-C-H-G-SMT-2A-P16-TR`, DigiKey 2223-UJ20-C-H-G-SMT-2A-P16-TRCT-ND / TR / DKR |

Notes:

- The existing boards can be ordered as-is when sourcing HRO `TYPE-C-31-M-12` from LCSC/JLCPCB-compatible supply. LCSC currently lists `TYPE-C-31-M-12` as a Korean Hroparts Elec USB-C 16-position SMD receptacle with stock available.
- Use the Same Sky line only if a DigiKey-only USB-C supply chain is required. In that case, update the footprint/model and re-render before fab because it is a substitute, not the exact footprint-qualified connector currently on the board.
- Puck now uses `ESP32-C6-MINI-1-H4`, giving the requested Wi-Fi plus IEEE 802.15.4/Thread path in one module.
- Vent `SG90_SERVO` is an off-board load connected through `J1`; it is not a PCB assembly BOM item unless you want the servo included in the product BOM. The Vent PCB now exposes `J3` so the servo 5 V rail is generated by a switched boost module/header, not by the ESP32 3.3 V regulator.
