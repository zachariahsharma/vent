# Vynte Vent

KiCad hardware design for the Vynte smart vent, a battery-powered register for room-by-room HVAC comfort. The saved project revision is **v0.5.0**.

## Design files

- `Vent.kicad_pro`: open this project in KiCad.
- `Vent.kicad_sch` and `Vent.kicad_pcb`: main schematic and PCB layout.
- `3.3V-Buck-Boost.kicad_sch`, `5V-Boost.kicad_sch`, and `ExternalAutoprogramming.kicad_sch`: supporting schematic sheets.
- `production/`: saved fabrication archive, assembly CSV exports, IPC netlist, and stencil layers.
- `fabrication-toolkit-options.json`: saved fabrication export settings.

## Fabrication status

The production files are existing exports preserved with the project. The fabrication ZIP was generated on September 21, 2026; the PCB source was saved later, on September 22. These exports have not been verified against the latest source. Regenerate and review fabrication files, DRC, and ERC before ordering boards.

Local backups, analysis caches, and per-user KiCad settings are excluded from version control.

## Repository copies

Gitea is the development repository. The public GitHub copy includes the development history with credential files removed from every revision. Commit author and committer identities have been normalized to Zachariah K. Sharma at the repository owner's request; Gitea retains the original history.

No open-source license has been selected.
