# Vynte Electronics Manufacturing Readiness Ledger

Date: 2026-06-02

Authoritative electronics checkout inspected:
`C:\Users\zacha\Documents\Vynte\electronics`

## Requirement Breakdown

1. Verify and repair all boards until manufacturing-ready.
2. Check current online datasheets and vendor material.
3. Vent must use ESP32-H2-MINI for Matter over Thread.
4. Vent must be battery-conscious, powered from BMS spring leaf contacts, and drive an SG90 servo.
5. Puck must be a temperature sensor.
6. Puck must connect to Wi-Fi and connect to Vent through Matter Thread.

## External Source Checks

- ESP32-H2-MINI-1/MINI-1U supports Bluetooth LE, IEEE 802.15.4, Thread, Zigbee, Matter, 3.0 V to 3.6 V supply, GPIO/PWM, and low-power modes.
  Source: https://documentation.espressif.com/esp32-h2-mini-1_mini-1u_datasheet_en.html
- ESP32-C6-MINI-1 combines 2.4 GHz Wi-Fi, Bluetooth LE, and IEEE 802.15.4/Thread; this remains the cleanest single-module Puck direction for Wi-Fi plus Thread.
  Sources: https://documentation.espressif.com/esp32-c6-mini-1_mini-1u_datasheet_en.html and https://www.espressif.com/en/products/socs/esp32-c6
- Espressif's KiCad library provides current 3D model assets for ESP32-C6 and ESP32-H2 modules. The project-local Puck `ESP32-C6-MINI-1.STEP` was copied from the local Espressif KiCad library cache and validates as ISO-10303 STEP.
  Source: https://github.com/espressif/kicad-libraries
- ESP32-S3-WROOM-1 is Wi-Fi/Bluetooth LE only and has no IEEE 802.15.4 radio.
  Source: https://www.espressif.com/sites/default/files/documentation/esp32-s3-wroom-1_wroom-1u_datasheet_en.pdf
- Espressif Thread Border Router/RCP docs support the alternate Puck direction: keep ESP32-S3 as host and add ESP32-H2 as the 802.15.4 radio co-processor.
  Source: https://docs.espressif.com/projects/esp-thread-br/en/latest/hardware_platforms.html
- MCP9808 remains a valid temperature sensor for the Puck supply range.
  Source: https://www.microchip.com/en-us/product/mcp9808
- BQ25180YBGR remains an 8-pin DSBGA part and CSD16406Q3 remains a SON/VSON-style MOSFET, so Satish's assembly concern is still real.
  Sources: https://www.ti.com/product/BQ25180/part-details/BQ25180YBGR and https://www.ti.com/product/CSD16406Q3
- BQ25180YBGR is active/production material and TI's BQ25180 small-form-factor app note uses the same WCSP/DSBGA charger package. This is acceptable for outsourced stencil/reflow PCBA, not for casual hand soldering.
  Sources: https://www.ti.com/lit/gpn/bq25180 and https://www.ti.com/lit/an/sluaag6/sluaag6.pdf
- TPS63031 is a suitable low-power 3.3 V Li-ion buck-boost regulator for the Vent controller rail: 1.8 V to 5.5 V input, fixed 3.3 V output option, power-save mode, and less than 50 uA device quiescent current.
  Source: https://www.ti.com/product/TPS63031
- JLCPCB's 2026 DFM guidance lists 5 mil / 0.127 mm trace-space for standard 2-layer 1 oz boards; BMS project clearance is now set to 0.15 mm.
  Source: https://jlcpcb.com/blog/dfm-key-role-in-pcb-manufacturing
- SG90 is a 4.8 V class servo; Vent boost power should be designed for startup/stall margin.
  Source: https://towerpro.com.tw/product/sg90-7/
- Pololu U3V70F5 is an active/preferred fixed 5 V boost-regulator module with 2.9 V minimum input, true shutdown, reverse-voltage protection, and high-current operating headroom; it is a suitable external boost-module class for the Vent `J3` interface if wired through the documented adapter/harness.
  Source: https://www.pololu.com/product/2891
- TPD2E2U06DCKR is a TI dual-channel high-speed ESD protection device, suitable for the Autoprogramming USB/UART/control-line TVS protection role.
  Source: https://www.ti.com/product/TPD2E2U06/part-details/TPD2E2U06DCKR
- HRO `TYPE-C-31-M-12` remains available through LCSC as a USB-C 16-position SMD receptacle; the existing Autoprogramming/Puck USB-C footprint is acceptable when sourcing this exact connector.
  Source: https://www.lcsc.com/product-detail/C165948.html

## Board Status

### Vent

Current evidence:
- ERC: 0 violations.
- DRC: 0 violations, 0 unconnected pads, 0 footprint errors.
- The previous `lib_footprint_mismatch` warning on U1 is suppressed in `Vent.kicad_pro` after verification as a KiCad metadata/library-copy comparator false positive: the embedded U1 footprint and `Comps/Footprints/ESP32-H2-MINI-1.kicad_mod` have identical normalized footprint text after board-instance fields are removed, and pad geometry comparison shows 61 board pads, 61 library pads, 0 board-only pad geometries, and 0 library-only pad geometries.
- Schematic uses `ESP32-H2-MINI-1-H4S`.
- Schematic is organized into functional blocks: ESP32-H2 Thread node, servo output, auto-programming, servo 5 V boost, and BMS/power contacts.
- BMS spring contacts are represented as `BMS_SYS_CONTACT` and GND.
- SG90 servo is isolated to `+5V_SERVO` through a switched boost header/module.
- Top and bottom KiCad 3D renders were generated in `electronics/Vent/manufacturing-current/` and show the ESP32-H2, boost header, servo header, BMS contacts, and regulator placement in the current manufacturable output set.

Manufacturing readiness: acceptable to send as a controller/contact PCBA revision when paired with the documented external 5 V boost module/harness. The external boost module is an intentional assembly item for this revision, not an unverified placeholder. A future single-PCBA product can replace `J3` with an onboard boost converter, but that is not required to manufacture this board revision.

### Puck

Current evidence:
- ERC: 0 violations after the ESP32-C6 schematic migration.
- DRC: 0 violations and 0 unconnected items after replacing the PCB module footprint, clearing stale S3-era fanout copper, adding a B.Cu GND pour, stitching the ESP32-C6 ground pad array, routing the MCP9808 I2C, EN/IO0/UART programming paths, USB-C CC/data paths, and ESP32-C6 native USB D+/D-.
- Current controller: `ESP32-C6-MINI-1-H4`.
- Current temperature sensor: `MCP9808T-E/MS`.
- Native USB D+/D- nets are now connected in the schematic to the ESP32-C6 USB pins and the USB-C connector.
- The PCB U1 footprint is now the project-local `Footprints:ESP32-C6-MINI-1`, placed lower than the old S3 footprint to avoid top-edge antenna/outline clipping.
- The old `IO11`/`IO13` I2C names were replaced with `I2C_SCL`/`I2C_SDA`; stale board-track net names were retagged or cleared.
- The project-local `Comps/Models/ESP32-C6-MINI-1.STEP` is present and passes STEP structure validation; the Puck STEP export now adds U1 and all passive/component models without missing-model warnings.
- Top and bottom KiCad 3D renders were generated in `electronics/Puck/manufacturing-current/`. Visual review of the renders shows the ESP32-C6 antenna/outline area is not clipped, the USB-C connector is accessible, and the visible USB/I2C/EN fanout has no obvious mechanical collision.

Manufacturing readiness: electrically/check-clean with current manufacturing outputs regenerated.

Critical requirement repair completed:
- The schematic no longer uses ESP32-S3-WROOM-1; it now uses ESP32-C6, which provides the required Wi-Fi plus IEEE 802.15.4 Thread radio path.

Required schematic/PCB checks:
- MCP9808 has valid I2C pullups, address configuration, decoupling, and temperature-aware placement preserved in the current board state.

### BMS

Current evidence:
- ERC: 0 violations.
- DRC: 0 violations, 0 unconnected pads, 0 footprint errors.
- Obsolete `NCP15XH103F03RC` replaced with `NCU15XH103F60RC`.
- Project-local passive libraries, CSD symbol copy, and USB-C symbol/footprint copy are now resolved.
- Added correct PWR_FLAGs for the battery, charger, SYS, VBUS, and GND rails.
- Normalized battery-negative naming to `CELL-`.
- USB shell pins are intentionally named/tied as GND.
- Fine-pitch project clearance set to 0.15 mm; main GND zone local clearance also set to 0.15 mm.
- CSD16406Q3 solder-mask expansion reduced to 0.038 mm to remove mask-bridge violations.
- GND shield/decoupler pads stitched and the GND zone refilled cleanly.
- Top and bottom KiCad 3D renders were generated in `electronics/BMS/manufacturing-current/`.

Manufacturing readiness: acceptable for outsourced PCB fabrication plus stencil/reflow PCBA assembly. Satish's hand-assembly concern is accepted rather than redesigned for this revision: `BQ25180YBGR` and `CSD16406Q3` are still small no-lead/BGA-style packages, so do not plan to hand-solder this BMS without proper reflow process control and inspection.

### Autoprogramming

Current evidence:
- ERC: 0 violations.
- DRC: 0 violations, 0 unconnected pads, 0 footprint errors.
- Previous single-use global-label warning on `+3V3_SENSE` is resolved. `J2.1` is now explicitly marked as an intentional no-connect target `+3V3_SENSE` annotation rather than a one-off global net.
- TVS protection is present in the schematic:
  - U4 protects USB D+/D-.
  - U5 protects RXD0/TXD0.
  - U6 protects EN/IO0.
- The current PCB has those protected nets assigned/routed and the current DRC report is clean, so the TVS devices are included in the manufacturable board state.
- Project-local PCM/JLCPCB passive/transistor symbol and footprint aliases are now resolved.
- Top and bottom KiCad 3D renders were generated in `electronics/Autoprogramming/manufacturing-current/`.

Manufacturing readiness: acceptable for common-ground programming/debug use with TVS protection. Optoisolators are intentionally not implemented in this revision because Satish's recommendation was optoisolators and/or TVS; the current design chooses TVS protection. If the programming host must be galvanically isolated from target boards, create a separate isolated programmer revision.

## Manufacturing Gate

I would send the complete electronics set to prototype manufacturing under these release assumptions:

- Order PCBs with stencil/reflow PCBA assembly for no-lead/BGA-style parts; do not treat the BMS as a hand-solder board.
- Include the external 5 V boost regulator module/harness for Vent servo power, such as Pololu U3V70F5 or an electrically equivalent enabled/shutdown-capable 5 V boost module.
- Use Autoprogramming as a common-ground TVS-protected programmer. Do not claim galvanic isolation for this revision.
- Source exact-footprint connector parts where the layout assumes them, especially HRO `TYPE-C-31-M-12` for the existing USB-C footprints unless the board footprints are deliberately swapped.

Release checks now satisfied:

- Every board has current ERC with 0 errors.
- Every board has current DRC with 0 errors and no unintentional warnings.
- Puck has a real Wi-Fi plus 802.15.4 Thread path through ESP32-C6.
- Vent has an ESP32-H2 Thread/Matter controller path, spring-contact BMS power input, low-power 3.3 V buck-boost rail, and switched external 5 V SG90 servo rail.
- Manufacturing Gerbers, drill files, position files, BOM, STEP files, and KiCad render images are regenerated from the current boards.

## Current Manufacturing Outputs

Generated on 2026-06-02 from the current board files:

| Board | Output folder | Package |
|---|---|---|
| BMS | `electronics/BMS/manufacturing-current/` | `electronics/BMS/BMS-manufacturing-2026-06-02-current-with-step.zip` |
| Vent | `electronics/Vent/manufacturing-current/` | `electronics/Vent/Vent-manufacturing-2026-06-02-current-with-step.zip` |
| Puck | `electronics/Puck/manufacturing-current/` | `electronics/Puck/Puck-manufacturing-2026-06-02-current-with-step.zip` |
| Autoprogramming | `electronics/Autoprogramming/manufacturing-current/` | `electronics/Autoprogramming/Autoprogramming-manufacturing-2026-06-02-current-with-step.zip` |

Each folder contains Gerbers, Excellon drill file and drill map, position CSV, BOM CSV, a STEP board export, and top/bottom KiCad render images. Puck Gerber/drill filenames still use the legacy `Vent` board-file stem inside the Puck folder.

STEP export caveats:

- Vent and Autoprogramming exported complete board solids with their currently configured project/local models.
- BMS and Puck now export complete board STEP solids without missing-model warnings after replacing stale `${KICAD8_3RD_PARTY}` passive model paths with KiCad 9 standard passive STEP paths and adding the project-local Puck `ESP32-C6-MINI-1.STEP`.
- Vent's project-local `ESP32-H2-MINI-1.STEP` matches the official cached Espressif KiCad library file by SHA-256. That official STEP file internally names shared `ESP32-C3-MINI-1` package geometry, so the strings appear in the board STEP export but are not a missing-model condition.
