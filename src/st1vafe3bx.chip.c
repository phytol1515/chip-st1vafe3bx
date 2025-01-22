// Wokwi ST1VAFE3BX biosensor
//
// SPDX-License-Identifier: MIT
// Copyright 2025 Pekka-Ilmari Nikander <pekka.nikander@iki.fi>

#include "wokwi-api.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  pin_t TA0;
  bool initialized;
} chip_state_t;

void chip_init() {
  chip_state_t chip = {
    .TA0 = pin_init("SDO/TA0", INPUT),
  };

  printf("Hello from ST1VAFE3BX!\n");
}