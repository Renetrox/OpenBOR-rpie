# OpenBOR 4 RetroPie Module / Módulo de RetroPie para OpenBOR 4

## Overview (English)
This repository provides a RetroPie-Setup scriptmodule (`openbor4.sh`) that builds OpenBOR 4 using CMake for Linux ARM64 targets and configures a RetroPie-friendly layout. The module wires Paks to the ROM directory, persists saves and screenshots under RetroPie configs, and routes logs to `/dev/shm`.

### Requirements
- RetroPie-Setup on a Linux ARM64 system.
- Build dependencies available in the scriptmodule: `cmake`, `git`, `build-essential`, `pkg-config`, `libsdl2-dev`, `libsdl2-gfx-dev`, `libpng-dev`, `libvorbis-dev`, `libvpx-dev`.
- Network access to clone `https://github.com/DCurrent/openbor.git` during installation.

### Installation
1. Copy `openbor4.sh` into your RetroPie-Setup scriptmodules, e.g. `~/RetroPie-Setup/scriptmodules/ports/openbor4.sh`.
2. Run `sudo ~/RetroPie-Setup/retropie_setup.sh` and install the **OpenBOR 4.0 (CMake Linux ARM64)** module from the experimental section.
3. The build output (`OpenBOR`) will be placed under `build.lin.arm64` inside the module directory and installed alongside a wrapper script `openbor.sh`.

### Usage
- Place your `.pak` files in `~/RetroPie/roms/openbor` (the module symlinks `Paks` to this ROM directory).
- Saves and screenshots are persisted in `/opt/retropie/configs/openbor/openbor4/` via symlinks created during configuration.
- EmulationStation is updated with an `openbor` system entry and an emulator command pointing to the installed wrapper (`openbor.sh`).

### Notes
- The module builds in release mode with `-DBUILD_LINUX=ON` and `-DTARGET_ARCH=ARM64` to match 64-bit Raspberry Pi OS or similar environments.
- Logs are routed to `/dev/shm` to minimize SD card writes.

---

## Descripción general (Español)
Este repositorio ofrece un scriptmodule de RetroPie-Setup (`openbor4.sh`) que compila OpenBOR 4 con CMake para sistemas Linux ARM64 y configura un entorno compatible con RetroPie. El módulo enlaza Paks al directorio de ROMs, mantiene partidas y capturas en las configuraciones de RetroPie y envía los logs a `/dev/shm`.

### Requisitos
- RetroPie-Setup en un sistema Linux ARM64.
- Dependencias de compilación incluidas en el scriptmodule: `cmake`, `git`, `build-essential`, `pkg-config`, `libsdl2-dev`, `libsdl2-gfx-dev`, `libpng-dev`, `libvorbis-dev`, `libvpx-dev`.
- Acceso a internet para clonar `https://github.com/DCurrent/openbor.git` durante la instalación.

### Instalación
1. Copiá `openbor4.sh` en los scriptmodules de RetroPie-Setup, por ejemplo `~/RetroPie-Setup/scriptmodules/ports/openbor4.sh`.
2. Ejecutá `sudo ~/RetroPie-Setup/retropie_setup.sh` e instalá el módulo **OpenBOR 4.0 (CMake Linux ARM64)** desde la sección experimental.
3. El binario (`OpenBOR`) quedará en `build.lin.arm64` dentro del directorio del módulo y se instalará junto con el wrapper `openbor.sh`.

### Uso
- Colocá tus archivos `.pak` en `~/RetroPie/roms/openbor` (el módulo enlaza `Paks` a este directorio de ROMs).
- Las partidas guardadas y capturas se mantienen en `/opt/retropie/configs/openbor/openbor4/` mediante enlaces simbólicos creados durante la configuración.
- EmulationStation se actualiza con una entrada de sistema `openbor` y un comando de emulador que llama al wrapper instalado (`openbor.sh`).

### Notas
- El módulo compila en modo release con `-DBUILD_LINUX=ON` y `-DTARGET_ARCH=ARM64` para equipos de 64 bits como Raspberry Pi.
- Los logs se envían a `/dev/shm` para reducir escrituras en la tarjeta SD.
