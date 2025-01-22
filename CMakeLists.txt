cmake_minimum_required(VERSION 3.13)

# ---------------------------------------------------------------------------
# Configurable variables
# ---------------------------------------------------------------------------

# Change this to match with the name of your Wokwi Custom Chip, all lowercase
set(CHIP st1vafe3bx CACHE STRING "Name of the chip")

# ---------------------------------------------------------------------------
# Project Definition
# ---------------------------------------------------------------------------
project(${CHIP} C)

# ---------------------------------------------------------------------------
# Paths and Sources, following Wokwi conventions
# ---------------------------------------------------------------------------
set(SOURCES    ${CMAKE_CURRENT_SOURCE_DIR}/src/${CHIP}.chip.c)
set(CHIP_JSON  ${CMAKE_CURRENT_SOURCE_DIR}/src/${CHIP}.chip.json)

set(DIST       ${CMAKE_SOURCE_DIR}/dist)
set(TARGET     ${DIST}/chip.wasm)

file(MAKE_DIRECTORY ${DIST})

# ---------------------------------------------------------------------------
# Copy chip JSON description for host-local Wokwi usage and Github releases
# ---------------------------------------------------------------------------
add_custom_target(copy_chip_json
    COMMAND ${CMAKE_COMMAND} -E copy ${CHIP_JSON} ${DIST}/chip.json
    DEPENDS ${CHIP_JSON}
)

# ---------------------------------------------------------------------------
# Build the WASM binary for host-local Wokwi usage and Github releases
# ---------------------------------------------------------------------------
# Put final artifact in ${TARGET}
get_filename_component(TARGET_DIR    "${TARGET}" DIRECTORY) # -> "dist"
get_filename_component(TARGET_NAME   "${TARGET}" NAME_WLE)  # -> "chip"
get_filename_component(TARGET_SUFFIX "${TARGET}" LAST_EXT)  # -> ".wasm"

add_executable(${CHIP}_wasm ${SOURCES})

set_target_properties(${CHIP}_wasm PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${TARGET_DIR}"
    OUTPUT_NAME              "${TARGET_NAME}"
    SUFFIX                   "${TARGET_SUFFIX}"
)

add_dependencies(${CHIP}_wasm copy_chip_json)