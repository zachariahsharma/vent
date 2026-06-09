# Vent PCB Build Notes

This note tracks the current Vent board state after the ESP32-H2/Matter Thread conversion.

## Schematic State

The Vent controller is now `U1 = ESP32-H2-MINI-1-H4S` using Espressif's official KiCad symbol, footprint, and STEP model. The intended role is a low-power Matter over Thread vent node powered from the BMS spring contacts.

Key blocks:

- `U1`: ESP32-H2-MINI-1 module.
- `U2`: TPS63031 3.3 V buck-boost from the BMS `SYS` rail.
- `J1`: SG90 servo header, `GND`, `+5V_SERVO`, `SERVO_PWM`.
- `J2`: external auto-programming/debug header.
- `J3`: 4-pin servo 5 V boost module/header.
- `J4`: BMS spring-leaf contact interface, `SYS`, `SYS`, `GND`, `GND`.

ESP32-H2 pin assignments:

- `GPIO22` / module pad `24`: `SERVO_PWM`.
- `GPIO25` / module pad `25`: `SERVO_BOOST_EN`.
- `GPIO23` / module pad `30`: `ESP_RXD`.
- `GPIO24` / module pad `31`: `ESP_TXD`.
- `GPIO9` / module pad `23`: `ESP_BOOT`.
- `EN` / module pad `8`: `ESP_EN`.
- `3V3` and `VBAT`: tied to regulated `+3V3`.

The servo rail is no longer a fake one-pin `+5V_SERVO` net. `J3` now represents the 5 V boost stage: pin 1 `SERVO_BOOST_EN`, pin 2 `GND`, pin 3 `BMS_SYS_CONTACT`, pin 4 `+5V_SERVO`. This keeps the SG90 load off the ESP32 regulator path and lets firmware shut the boost rail down between movements.

Accepted production path for this revision: keep the Vent PCB as a controller/contact board and use an external 5 V boost regulator module wired to `J3`. The module must provide:

- Input operating range that covers the BMS `SYS` rail from a Li-ion pack.
- Fixed 5 V output for the SG90 rail.
- A true enable/shutdown input that can be driven by `SERVO_BOOST_EN`, so the boost output is off between movements.
- Continuous and transient current margin for SG90 startup/stall behavior.
- Common ground with the Vent PCB.

The current recommended module class is Pololu U3V70F5 or an electrically equivalent 5 V boost regulator. Pololu lists U3V70F5 as a fixed 5 V regulator with 2.9 V minimum input, 5 V maximum input, true shutdown, reverse-voltage protection, and high-current operating headroom. Wire it to `J3` through a short harness/adapter as:

| Vent J3 pin | Signal | Boost module connection |
|---:|---|---|
| 1 | `SERVO_BOOST_EN` | Enable/shutdown input |
| 2 | `GND` | Ground |
| 3 | `BMS_SYS_CONTACT` | VIN/input positive |
| 4 | `+5V_SERVO` | VOUT/output positive |

If the product later must become a single-PCBA assembly, replace `J3` with an onboard boost converter in a follow-up board revision. For the current prototype-manufacturing release, `J3` plus the external enabled 5 V boost module/harness is the accepted servo-power architecture.

## BMS Contact Order

- `J4.1`: `BMS_SYS_CONTACT`
- `J4.2`: `BMS_SYS_CONTACT`
- `J4.3`: `GND`
- `J4.4`: `GND`

This matches the BMS underside row order of `SYS`, `SYS`, `GND`, `GND` on 4.00 mm pitch.

## Verification

Current schematic checks:

- KiCad CLI ERC report: `electronics/Vent/Vent-erc.rpt`, `0` violations.

Current PCB checks:

- The PCB has the ESP32-H2 footprint and a `J3` 1x04 boost-header footprint.
- The dangerous stale ESP32-C3 signal traces that shorted into H2 pads were removed.
- The current routed board has no DRC shorts, clearance violations, track crossings, dangling tracks, edge-clearance failures, or unconnected pads.
- KiCad CLI DRC report: `electronics/Vent/Vent-drc.rpt`, `0` violations and `0` unconnected pads.
- The project-level `lib_footprint_mismatch` rule is set to `ignore` for this board after the U1 ESP32-H2 footprint warning was verified as a KiCad library-copy comparator false positive, not a manufacturing geometry issue.
- The `U1` board footprint and `Comps/Footprints/ESP32-H2-MINI-1.kicad_mod` were compared after removing board-instance-only fields (`at`, `path`, sheet fields, net annotations, and generator metadata). The normalized footprint text is identical, and the pad multiset comparison is clean: `61` board pads, `61` library pads, `0` board-only pad geometries, and `0` library-only pad geometries.

## Manufacturing Gate

The Vent PCB is acceptable to send to PCB fabrication and PCBA as this controller/contact board revision, provided the external boost module/harness above is part of the assembly plan.
