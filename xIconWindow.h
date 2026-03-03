
#pragma once

/**
 * Minimally create and display an x11 window
 * with an Icon from a locally defined PNG file.
 */

// Application.
#include "xPngWrapper.h"

// Module consts.
#define COLOR_RED "\033[0;31m"
#define COLOR_GREEN "\033[1;32m"
#define COLOR_YELLOW "\033[1;33m"
#define COLOR_BLUE "\033[1;34m"
#define COLOR_NORMAL "\033[0m"

void debugPngFile(xPngWrapper* pngWrapper);
