cmake_minimum_required(VERSION 3.13)

# ---------------------------------------------------------------------------
# Configurable variables
# ---------------------------------------------------------------------------

# The installation location of your WASI sysroot
set(WASI_SYSROOT /opt/wasi-sysroot CACHE PATH "Location of WASI sysroot.")

# Path to a LLVM installation (comment out or adjust if using host clang).
set(CLANG_PATH /usr/bin CACHE PATH "Path to LLVM installation")

# ---------------------------------------------------------------------------
# Tell CMake we’re cross-compiling for a generic system. Without this,
# CMake in macOS (Darwin) makes silly assumptions that break things.
# ---------------------------------------------------------------------------
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_CROSSCOMPILING TRUE)

# ---------------------------------------------------------------------------
# Use a specific version LLVM, as e.g. macOS clang cannot produce WASM
# ---------------------------------------------------------------------------
find_program(CMAKE_C_COMPILER   NAMES clang   HINTS ${CLANG_PATH})
find_program(CMAKE_CXX_COMPILER NAMES clang++ HINTS ${CLANG_PATH})

# ---------------------------------------------------------------------------
# Compiler and Linker Options for WASM32
# ---------------------------------------------------------------------------
# set(CMAKE_C_COMPILER_TARGET wasm32-unknown-wasi) fails…

set(CMAKE_C_FLAGS_INIT "--target=wasm32-unknown-wasi --sysroot=${WASI_SYSROOT}")
set(CMAKE_CXX_FLAGS_INIT ${CMAKE_C_FLAGS_INIT})
set(CMAKE_EXE_LINKER_FLAGS_INIT "-nostartfiles -Wl,--import-memory -Wl,--export-table -Wl,--no-entry")
