# STM1WAFE3BX Wokwi Custom Chip

This is an early attempt to add partial emulation for the STM1VAFE3BX
sensor chip to Wokwi, mainly for WITL testing.

The ultimage goal of this project is to support any I2C / I3C / SPI
based sensor chip emulation for Wokwi in the Loop (WITL) testing,
preferably for any chips, not just STM1VAFE3BX.

The current (January 2025) plan is as follows:

1. Implement rudimentary customisable support for typical STM
   I2C sensor chips, with different register banks.
2. Add ST1VAFE3BX base registers.
3. Implement rudimentary support for WITL testing, allowing
   one to debug RasPi Pico ST1VAFE3BX libraries.

It is most likely that the initial efforts will stop there.
However, the aim is to make write the code in a manner that
allows easy continuation towards more generic approaches.

## Using this Custom Chip from Wokwi

This repository supports using the released versions of this
Wokwi Custom Chip directly from your Wokwi design, running
e.g. at `wokwi.com` or in your Wokwi VSCode Extension.

### Adding this Custom Chip to your `wokwi.com` design

To add this custom chip to your Wokwi design, you need to add
it to your `diagram.json`:
```js
{
  ...
  "parts": [
    ...
    { "type": "chip-st1vafe3bx", … }
  ],
  ...
  "dependencies": { "chip-st1vafe3bx": "github:phytol1515/chip-st1vafe3bx" }
}
```

### Host local simulation, with VSCode

To use a Custom Chip with a host-local Wokwi, such as when using
the Wokwi VSCode extension, you have to have make your Wokwi
Custom Chip WASM and JSON files
available as `dist/chip.wasm` and `dist/chip.json`.

NOTE! For simulating within the Wokwi VSCode extension, you need
a TBD subscription for Wokwi, see XXX.

TBD Using examples



## Tools and platforms for building the Custom Chip.

This repository has been designed to use current best Open Source Software
practices to a large extent.  Consequently, we are using quite a lot of
tools, in order to supports builds on multiple platforms, including
local builds on macOS and Linux (and presumably Windows — not testes),
continous integration and testing builds on Github, as well as
local testing of the Github CIT builds using `act`.

The tools used are
[CMake](cmake.org),
[LLVM](llvm.org),
[WASI SDK](https://github.com/WebAssembly/wasi-sdk),
[Docker](docker.com),
[Wokwi](wokwi.com),
[act](https://github.com/nektos/act),
[Github Actions CIT](https://docs.github.com/en/actions).

This repository contains support for VSCode and VSCodium,
but --- of course --- you can also use some other editor.

## Directory layout

| File or directory      | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| `src/`                 | Source code for the Custom Chip                 |
| `src/<name>.chip.c`    | Chip functionality, in C                        |
| `src/<name>.chip.json` | Pins and other properties, for the Wokwi editor |
| `src/wokwi-api.h`      | Wokwi API, included for ease of compiling       |
|                        |                                                 |
| `cmake/`               | CMake toolchains etc.                           |
| `CMakePresets.json`    | CMake presets, for `--preset` and VSCodium      |
| `CMakeLists.txt`       | Top level CMake script                          |
|                        |                                                 |
| `wokwi.toml`           | Definitions for Wokwi                           |
|                        |                                                 |
| `examples`             | Examples for using the chip (TBD)               |
| `tests`                |  Automated tests (TBD)                          |
| `.github`              | Helpers for Github Actions CI                   |
| `.vscode`              | VSCode / VSCodium settings                      |
|                        |                                                 |
| `build`                | Generated CMake build intemediates (if any)     |
| `dist`                 | Generated products: `chip.wasm` and `chip.json` |
|                        |                                                 |

## Building

This repository uses CMake to build the `chip.wasm` and `chip.json` files
from the source (in `src`).

### Local build

To build locally, you need LLVM (or other C compiler) that produces
WASM32, and suitable WASI sysroot and potentially other compiler-specific
runtime libraries, such as `libclang-rt-dev-wasm32.a`. Depending on your local host,
you may have these available already. If not, you need to figure out how and where to
install them.

The toolchain in `cmake/wasm32-unknown-wasi-toolchain.cmake` assumes by
default that your WASI sysroot is at `/opt/wasi-sysroot` and `clang`
can be invoked via `/usr/bin/clang`.  If these do not work for producing
WASM32 binaries, set your `WASI_SYSROOT` and `CLANG_PATH` environment
variables appropriately.

When your environment is set up correctly, the following builds your binaries:
```bash
  cmake --toolchain cmake/wasm32-unknown-wasi-toolchain.cmake -S . -B build
  cmake --build build
```

### Docker container for builds

To build at Github, or to emulate a Gihub build with `act`, the present
setting in this repository uses Docker. To goal of this is to be able
to test Github builds locally, even when using macOS.  For Dockerised
builds, we currently use a custom Docker image.

To build your own copy of the docker image, with the expected tag:
```bash
  GITHUB_REPO_NAME=`git config --get remote.origin.url | sed 's/.*:\(.*\)\.git$/\1/'`
  DOCKERBASE=./.github/docker/
  docker buildx build --platform linux/amd64,linux/arm64 --tag "ghcr.io/$GITHUB_REPO_NAME/ubuntu-24.04-with-tools:latest" "$DOCKERBASE"
```

If you want to use this Docker image for your Github builds, you need to
[push it to the Github Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

```bash
  export CR_PAT=YOUR_TOKEN
  echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
  docker push "ghcr.io/$GITHUB_REPO_NAME/ubuntu-24.04-with-tools"
```

### Local GitHub Actions based build using `act` and Docker

To build your Wokwi Custom Chip distribution locally with Docker, e.g. for testing
it manually, use the following:
```bash
  act -j build --artifact-server-path /tmp/artifacts
```

If you didn't push your Docker image to the Github Container Registry, add `--pull=false`.

### Github CI build

The Github CI build workflow is defined in `.github/workflows/ci.yaml`.  The current
workflow uses a Docker container built for a specific fork of this repository.
Hence, if you fork this repository, you need to build your own Docker image and
push it to the Github Container Registry; see above.

The main reason for using the Docker container is to allow local testing the Github
workflow using `act` under macOS; see above.

If you don't want to use your own Docker image, in theory you should be able to use
the one from the `phytol1515/chip-st1vafe3bx` or some other repository forked from it.
For that, in `ci.yaml`, replace the string `${{ github.repository }}` with the fixed
repository name that you want to refer to.

(NB. It would be nice to receive a [pull request](https://docs.github.com/en/pull-requests)
that makes it easier to do this.)

## Automated tests

TBD.

## Distribution

To distribute your Wokwi Custom Chip, make a Github Release from the
`dist/chip.wasm` and `dist/chip.json` files.

TBD.
