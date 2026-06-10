#!/usr/bin/env bash
# RetroPie-Setup module for OpenBOR 4 (CMake, Linux ARM64)
# Instala OpenBOR y configura rutas "RetroPie-like" (Paks->romdir, Saves->configs, Logs->/dev/shm)

rp_module_id="openbor4"
rp_module_desc="OpenBOR 4.0 (CMake Linux ARM64)"
rp_module_help="Colocá tus .pak en $romdir/openbor"
rp_module_section="exp"
rp_module_flags=""
rp_module_licence="BSD https://raw.githubusercontent.com/DCurrent/openbor/master/LICENSE"

function depends_openbor4() {
    getDepends \
        cmake \
        git \
        build-essential \
        pkg-config \
        libsdl2-dev \
        libsdl2-gfx-dev \
        libpng-dev \
        libvorbis-dev \
        libvpx-dev
}

function sources_openbor4() {
    gitPullOrClone "$md_build" https://github.com/DCurrent/openbor.git
}

function build_openbor4() {
    cd "$md_build" || return 1

    rm -rf build.lin.arm64

    # GCC 12/Bookworm puede cortar la compilación por warnings tratados como error.
    # OpenBOR 4 actualmente puede disparar:
    #   -Werror=use-after-free
    # Por eso quitamos -Werror del proyecto antes de configurar CMake.
    find . -type f \( \
        -name "CMakeLists.txt" -o \
        -name "*.cmake" -o \
        -name "Makefile" -o \
        -name "*.mk" \
    \) -print0 | xargs -0 sed -i \
        -e 's/-Werror=use-after-free//g' \
        -e 's/-Werror//g'

    cmake -S . -B build.lin.arm64 \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_LINUX=ON \
        -DTARGET_ARCH=ARM64 \
        -DCMAKE_C_FLAGS="-Wno-error=use-after-free -Wno-use-after-free" \
        -DCMAKE_CXX_FLAGS="-Wno-error=use-after-free -Wno-use-after-free" || return 1

    cmake --build build.lin.arm64 -- -j"$(nproc)" || return 1

    md_ret_require="$md_build/build.lin.arm64/OpenBOR"
}

function install_openbor4() {
    md_ret_files=(
        "build.lin.arm64/OpenBOR"
    )
}

function configure_openbor4() {
    # 1) ROMDIR
    mkRomDir "openbor"

    # 2) Wrapper mínimo: NO escribe nada, solo asegura cwd
    cat >"$md_inst/openbor.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

INST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$INST_DIR"

exec "$INST_DIR/OpenBOR"
EOF
    chmod +x "$md_inst/openbor.sh"

    # 3) Asegurar config de runcommand
    mkdir -p "$md_conf_root/openbor"
    cat >"$md_conf_root/openbor/emulators.cfg" <<EOF
openbor4="$md_inst/openbor.sh %ROM%"
default="openbor4"
EOF

    # 4) Registrar emulador + sistema en ES
    addEmulator 1 "$md_id" "openbor" "$md_inst/openbor.sh %ROM%"
    addSystem "openbor" "OpenBOR" ".pak .PAK"

    # 5) Config persistente
    for dir in Saves ScreenShots; do
        mkUserDir "$md_conf_root/openbor/$md_id/$dir"
    done

    # 6) Rutas "RetroPie-like" dentro de $md_inst
    # Paks -> romdir
    rm -rf "$md_inst/Paks"
    ln -snf "$romdir/openbor" "$md_inst/Paks"

    # Saves/ScreenShots -> configs
    rm -rf "$md_inst/Saves" "$md_inst/ScreenShots"
    ln -snf "$md_conf_root/openbor/$md_id/Saves" "$md_inst/Saves"
    ln -snf "$md_conf_root/openbor/$md_id/ScreenShots" "$md_inst/ScreenShots"

    # Logs -> RAM
    rm -rf "$md_inst/Logs"
    ln -snf "/dev/shm" "$md_inst/Logs"
}
