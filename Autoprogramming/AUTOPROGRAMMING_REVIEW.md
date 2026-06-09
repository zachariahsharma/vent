# Autoprogramming Electrical/Compatibility Review

Date: 2026-06-02

Scope: `Autoprogramming.kicad_sch`, `Autoprogramming.kicad_pcb`, Puck `J2`, and Vent `J2`.

## Validation Commands

- `kicad-cli pcb drc --severity-all --schematic-parity --output electronics/Autoprogramming/Autoprogramming-review-drc.rpt electronics/Autoprogramming/Autoprogramming.kicad_pcb`

Result:

- `0` unconnected pads
- `0` schematic parity issues
- `0` footprint errors
- Remaining DRC items are library lookup warnings for locally overridden/imported footprints.

## Trace Width Review

Autoprogramming copper is currently routed entirely at `0.15 mm` track width.

| Net group | Width | Assessment |
|---|---:|---|
| USB_D+/USB_D- | 0.15 mm | Fabrication-safe for typical 6 mil capable PCB vendors. Not impedance controlled or length matched. Fine for short USB full-speed routing only if topology is fixed. |
| CP2102 UART/control lines | 0.15 mm | Good. Low current logic. |
| EN / BOOT pull-down transistor paths | 0.15 mm | Good. Low current. |
| VBUS | 0.15 mm | Electrically OK for CP2102-only current. Marginal if intended to power an ESP32 target board during Wi-Fi-current bursts. Use at least 0.25-0.30 mm for any target-power path. |
| GND traces | 0.15 mm | Functional, but a ground pour or wider ground spine would be better for USB return and connector shield robustness. |

## Autoprogramming J2 Pinout

Current Autoprogramming target connector:

| J2 pin | Net |
|---:|---|
| 1 | EN |
| 2 | IO0 |
| 3 | USB_D+ |
| 4 | USB_D- |
| 5 | VBUS |
| 6 | GND |

Puck `J2` currently has the same physical JST EH 1x06 pinout:

| Puck J2 pin | Net |
|---:|---|
| 1 | EN |
| 2 | IO0 |
| 3 | USB_D+ |
| 4 | USB_D- |
| 5 | VBUS |
| 6 | GND |

Vent `J2` is different mechanically and electrically:

| Vent J2 pin | Net |
|---:|---|
| 1 | +3V3 |
| 2 | GND |
| 3 | ESP_RXD |
| 4 | ESP_TXD |
| 5 | ESP_EN |
| 6 | ESP_BOOT |

## Functional Findings

### Blocker: CP2102 UART Is Not Exported

CP2102N UART pads are routed/named on the Autoprogramming board:

- U3 pin 25 RXD -> `TXD0`
- U3 pin 26 TXD -> `RXD0`

But `TXD0` and `RXD0` do not go to target connector `J2`. ERC correctly leaves these as dangling global-label warnings. This means the CP2102 cannot currently program a target over UART.

### Blocker: USB_D+/USB_D- Are Shared Between CP2102 And Target

Autoprogramming `J2.3/J2.4` export the same `USB_D+/USB_D-` nets used by:

- USB-C connector `J1`
- CP2102N USB pins
- Puck ESP32-S3 native USB pins when connected

That would put the CP2102 USB device and the ESP32-S3 USB device in parallel on the same host USB D+/D- pair. This is not a valid USB topology and can cause enumeration failure or bus contention. The Puck connector matches physically, but it is not functionally safe as an auto-programming interface in this topology.

### Blocker: Vent Header Is Not Compatible

Vent uses a 2.54 mm pin header and a UART/programming pinout. Autoprogramming uses a JST EH 2.50 mm connector and the current Puck/native-USB pinout.

A direct cable between current Autoprogramming `J2` and Vent `J2` would miswire:

- Autoprogramming `VBUS` into Vent `ESP_EN`
- Autoprogramming `GND` into Vent `ESP_BOOT`
- Autoprogramming `EN` into Vent `+3V3`
- Autoprogramming `IO0` into Vent `GND`

This must not be used.

### Blocker: DTR/RTS Control Mapping Is Reversed

Autoprogramming currently routes:

- CP2102 `RTS` -> Q2 -> `IO0`
- CP2102 `DTR` -> Q1 -> `EN`

Espressif documents the standard automatic bootloader mapping as:

- `EN` / `CHIP_PU` -> `RTS`
- `GPIO0` / boot strap -> `DTR`

The current mapping is reversed relative to the standard `esptool` expectation. It may only work with custom control-line handling.

### Concern: Reset Circuit Robustness

Autoprogramming uses two NPN low-side pull-downs, one for `EN` and one for `IO0`. This can work, but it does not include the full Espressif two-transistor interlock that prevents both asserted control lines from holding the chip in reset. The target boards should also have an EN-to-GND capacitor in the 1 uF to 10 uF range for reliable auto-reset behavior.

## Compatibility Verdict

Current Autoprogramming board:

- Not compatible with Vent.
- Mechanically compatible with Puck, but not electrically safe for USB programming.
- Not currently usable as a CP2102 UART programmer because UART TX/RX are not exported.

## Recommended Fix

Use one shared 6-pin UART auto-programming header across Autoprogramming, Puck, and Vent:

| Pin | Signal | Notes |
|---:|---|---|
| 1 | NC or target +3V3 sense | Do not drive target 3V3 from CP2102 VDD. |
| 2 | GND | Common ground. |
| 3 | Programmer TXD -> target RXD | CP2102 TXD. |
| 4 | Programmer RXD <- target TXD | CP2102 RXD. |
| 5 | EN / CHIP_PU | Driven by RTS through reset circuit. |
| 6 | BOOT strap | ESP32-S3 GPIO0 or ESP32-C3 GPIO9, driven by DTR through boot circuit. |

For Puck, replace `J2.3/J2.4` native USB nets with ESP32-S3 UART0 TXD/RXD nets, and keep native USB off this programming header.

For Vent, either change `J2` to the same JST EH 1x06 footprint or add a matching JST EH programming connector with the same pinout.

For Autoprogramming, reroute `J2` to CP2102 UART/control nets:

- `J2.2` -> GND
- `J2.3` -> CP2102 TXD (`RXD0` target-side name)
- `J2.4` -> CP2102 RXD (`TXD0` target-side name)
- `J2.5` -> EN, driven by RTS
- `J2.6` -> BOOT, driven by DTR
- Leave `J2.1` NC or target 3V3 sense only.

Also widen any target-power trace if a future design intentionally powers the target from the programmer.

## Implemented UART Header Update

The boards have now been updated to this shared target-side programming order:

| Pin | Autoprogramming | Puck target | Vent target |
|---:|---|---|---|
| 1 | +3V3_SENSE | +3.3V | +3V3 |
| 2 | GND | GND | GND |
| 3 | CP2102 TXD / target RX | RXD0 | ESP_RXD |
| 4 | CP2102 RXD / target TX | TXD0 | ESP_TXD |
| 5 | EN | EN | ESP_EN |
| 6 | IO0 / BOOT | IO0 | ESP_BOOT |

Validation artifacts:

- `Autoprogramming-uart-clean-drc.rpt`: 0 unconnected pads, 0 schematic parity issues.
- `Autoprogramming-erc-current.rpt`: 0 ERC violations.
- `Autoprogramming-drc-current.rpt`: 0 DRC violations, 0 unconnected pads, 0 footprint errors.
- `Puck-uart-clean-drc.rpt`: 0 unconnected pads, 0 schematic parity issues.
- `Vent-uart-final2-drc.rpt`: 0 unconnected pads; remaining parity entries are existing net-name warning normalization between board nets and schematic slash-prefixed nets.
- PNG renders generated in each board's `renders` directory.

## Implemented ESD/TVS Update

Added three `TPD2E2U06DCKR` dual-line TVS arrays to the Autoprogramming schematic:

| Ref | Protected nets |
|---|---|
| U4 | `USB_D+`, `USB_D-` |
| U5 | `RXD0`, `TXD0` |
| U6 | `EN`, `IO0` |

KiCad netlist verification confirms each TVS device is connected to its intended signal pair plus `GND`. The schematic/library assets and PCB are updated; current ERC and DRC reports are clean.

## Current Manufacturing-Readiness Status

The Autoprogramming schematic now marks `J2.1` as an intentional no-connect target `+3V3_SENSE` annotation rather than a one-off global net. This removes the previous single-use global-label ERC warning while preserving the connector pin's documented purpose.

Current gate status:

- ERC: `0` violations.
- DRC: `0` violations, `0` unconnected pads, `0` footprint errors.
- Optoisolators are intentionally not implemented in this revision. The board is acceptable as a common-ground programmer with TVS protection for ESD/surge robustness, but it does not provide galvanic isolation.
