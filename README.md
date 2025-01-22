# STM1WAFE3BX Wokwi Custom Chip

This is an early attempt to add partial emulation for the STM1VAFE3BX
sensor chip to Wokwi, mainly for WITL testing.

The ultimage goal of this project is to support any I2C / I3C / SPI
based sensor chip emulation for Wokwi in the Loop (WITL) testing.

The current (January 2025) plan is as follows:

1. Implement rudimentary customisable support for typical STM
   I2C sensor chips, with different register banks.
2. Add ST1VAFE3BX base registers.
3. Implement rudimentary support for WITL testing, allowing
   one to debug RasPi Pico ST1VAFE3BX libraries.

It is most likely that the initial efforts will stop there.
However, the aim is to make write the code in a manner that
allows easy continuation towards more generic approaches.

## Directory and file layout

`src`    Source code for the Custom Chip
`build`  CMake generated build
`dist`   chip.wasm and chip.json, ready for a release

`src/<name>.chip.c`     Functionality in C
`src/<name>.chip.json`  Pins and other properties, for Wokwi editor
`src/wokwi-api.h`       Wokwi API, included for ease of compiling

## Building

To use a Custom Chip with a host-local Wokwi, such as when using
the Wokwi VSCode extension, you have to have the custom chip WASM and JSON
available as `dist/chip.wasm` and `dist/chip.json`.

This repository uses CMake to build those files from the source in `src`

To build locally, you need an LLVM (or other C compiler) that produces
WASM and suitable WASM sysroot and compiler runtime libraries.  Once
you have those installed, configure `cmake/wasm32-unknown-wasi-toolchain.cmake`
appropriately.

When your environment is set up correctly, the following should work:

```
  cmake --toolchain cmake/wasm32-unknown-wasi-toolchain.cmake -S . -B build
  cmake --build build
```

## Testing

TBD.

## Distribution

To distribute your Wokwi Custom Chip, make a Github Release from the
`dist/chip.wasm` and `dist/chip.json` files.
