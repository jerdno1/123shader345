// ============================================================================
// =====                          SKY                                     =====
// ============================================================================

// ----------------------------------------------------------------------------
//   Sky Gradient
// ----------------------------------------------------------------------------

// Gradient _i0turt (higher = sharper _h8ie4b transition)
#define SKY_GRADIENT_CURVE 1.50// [0.10 0.20 0.30 0.40 0.50 0.60 0.65 0.70 0.80 0.90 1.00 1.25 1.50 2.00 3.00 5.00 7.00 10.00 15.00 20.00]

// Global _od2x3w _zj0avb
#define SKY_SATURATION 2.00// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.75 2.00]

// Biome _yssmf1 _rhnvg2 (0 = custom colors only, 1 = full biome colors)
#define SKY_BIOME_BLEND 0.50// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Master toggle for hard-coded overworld biome _od2x3w colors (snow/swamp/jungle/_alha5v/desert/pale_garden).
// When disabled, the _od2x3w stays at the configured default colors (DAY/SUNSET/etc.) regardless of biome.
// Also disables biome tint on the _qg5hoq _od2x3w reflection. Does not affect nether/end skies.
#define OVERWORLD_BIOME_SKY_ENABLED // [ON]

// Sky _q3g0w9 during _ae8sgm (% reduction at full _ae8sgm). Only affects _od2x3w, not terrain or LODs.
#define SKY_RAIN_DARKNESS 50 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

// NOTE: Biome _od2x3w tint in lighting is now folded into the unified skylight tint controls:
// - Strength: SKYLIGHT_COLOR_TINT
// - Saturation: SKYLIGHT_TINT_SATURATION (+ SKYLIGHT_TINT_LIGHT_SATURATION)

// ----------------------------------------------------------------------------
//   Sun & Moon
// ----------------------------------------------------------------------------

// Sun path rotation _huatah (_6vltqs)
const float _cej4mm = -10.0; // [-60.0 -55.0 -50.0 -45.0 -40.0 -35.0 -30.0 -25.0 -20.0 -15.0 -10.0 -5.0 0.0 5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 55.0 60.0]

// Enable _p6bxo1/moon _xoryyp control
#define SUN_MOON_SIZE_ENABLED

// Sun/moon _a9z6vr (1.0 = vanilla)
#define SUN_MOON_SCALE 1.00// [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Sun/moon _0m5p3q _0v7t0i
#define SUN_MOON_BLOOM 1.0 // [0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 4.0 5.0]
// Sun atmospheric _jjyhed — wide _nbz5uy, strong at sunrise/sunset, subtle at _ytn9sx
#define SUN_GLOW_RADIUS 1.0      // [0.2 0.3 0.4 0.5 0.6 0.7 0.8 1.0 1.2 1.5 2.0]
#define SUN_GLOW_INTENSITY 1.0   // [0.0 0.1 0.2 0.3 0.5 0.7 1.0 1.5 2.0 3.0]

// Sun-look _xgal31 — subtle screen _xgal31 increase when looking toward the _p6bxo1
#define SUN_BRIGHTNESS_BOOST 0.5  // [0.0 0.1 0.2 0.3 0.4 0.5 0.7 1.0 1.5 2.0]

// ----------------------------------------------------------------------------
//   Stars
// ----------------------------------------------------------------------------

// Enable procedural _o6gbcn
#define STARS_ENABLED

// Star _65berf _a9z6vr (lower = bigger cells = larger _o6gbcn, higher = more _o6gbcn)
#define STAR_SCALE 40.0// [10.0 15.0 20.0 25.0 30.0 40.0 50.0]

// Star _xoryyp (_nr5rfo of each _6hl4a5)
#define STAR_SIZE 0.18// [0.04 0.06 0.08 0.10 0.12 0.15 0.18 0.20 0.25]

// Star _xgal31
#define STAR_BRIGHTNESS 0.5// [0.5 0.75 1.0 1.5 2.0 2.5 3.0 4.0 5.0]

// Star _3tqs27 (chance per _h908e6, higher = more _o6gbcn)
#define STAR_DENSITY 0.20// [0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40]

// Star twinkling _0v7t0i (0 = no _gg05ax, 1 = full _gg05ax)
#define STAR_TWINKLE 0.6// [0.0 0.2 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// --- Shooting Stars ---
// Enable shooting _o6gbcn / _7xrwoh
#define STAR_SHOOTING_ENABLED

// Shooting _6hl4a5 _xgal31
#define STAR_SHOOTING_BRIGHTNESS 5.0// [1.0 1.5 2.0 2.5 3.0 4.0 5.0]

// --- Night Sky Nebula ---
// Colored cloud _quhal2 _fxiwh2 at night (like the End _od2x3w texture feel)
#define NIGHT_NEBULA_ENABLED

// Overall _0v7t0i of the _o3zovc _jjyhed
#define NIGHT_NEBULA_INTENSITY 0.40// [0.05 0.08 0.10 0.12 0.15 0.18 0.20 0.25 0.30 0.40 0.50 0.60 0.80 1.00]

// Scale of the _o3zovc _quhal2 (lower = bigger, higher = more detailed)
#define NIGHT_NEBULA_SCALE 0.8// [0.3 0.4 0.5 0.6 0.8 1.0 1.2 1.5 2.0]

// Drift _9lasr8 of the _o3zovc _u9na24
#define NIGHT_NEBULA_SPEED 0.015// [0.001 0.002 0.003 0.005 0.008 0.010 0.015]

// Primary _o3zovc _yssmf1
#define NIGHT_NEBULA_R1 0.2// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NIGHT_NEBULA_G1 0.10// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NIGHT_NEBULA_B1 0.80// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Secondary _o3zovc _yssmf1
#define NIGHT_NEBULA_R2 0.0// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NIGHT_NEBULA_G2 0.8// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define NIGHT_NEBULA_B2 0.90// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// --- Fantasy Meteors ---
// Colorful fantasy _7xrwoh streaking _mybu6k the night _od2x3w
#define METEORS_ENABLED

// Overall _xgal31 of meteor effects
#define METEOR_BRIGHTNESS 2.0// [0.2 0.4 0.6 0.8 1.0 1.5 2.0 3.0 5.0]

// How fast _7xrwoh _lw4r3f _mybu6k the _od2x3w
#define METEOR_SPEED 1.5// [0.2 0.3 0.5 0.7 1.0 1.5 2.0 3.0]

// Scale of meteor head and trail width
#define METEOR_SIZE 1.0// [0.5 0.7 1.0 1.3 1.5 2.0]

// How long the colorful trail extends behind the head
#define METEOR_TRAIL_LENGTH 1.0// [0.5 0.7 1.0 1.3 1.5 2.0]

// Glow _yssmf1 (purple/magenta by default)
#define METEOR_GLOW_R 0.6// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define METEOR_GLOW_G 0.1// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define METEOR_GLOW_B 0.8// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// --- Ringed Planet ---
// Enable ringed planet in the _od2x3w (inspired by IterationT End _od2x3w)
// #define RINGED_PLANET_ENABLED  // Disabled - not working properly

// Planet _xgal31
#define PLANET_BRIGHTNESS 1.0 // [0.5 1.0 1.5 2.0 3.0 4.0 5.0 7.0 10.0 15.0 20.0]

// Planet _xoryyp (apparent angular _xoryyp in _od2x3w)
#define PLANET_SIZE 1.0 // [0.3 0.5 0.7 1.0 1.5 2.0 3.0 4.0 5.0]

// Planet _d8i1xw - _lti102 _huatah (0-360 _6vltqs, 0 = _4pjw1f)
#define PLANET_AZIMUTH 165.0 // [0.0 15.0 30.0 45.0 60.0 75.0 90.0 105.0 120.0 135.0 150.0 165.0 172.0 180.0 195.0 210.0 225.0 240.0 255.0 270.0 285.0 300.0 315.0 330.0 345.0]

// Planet _d8i1xw - _ra294w _huatah (_6vltqs above _h8ie4b)
#define PLANET_ELEVATION 10.0// [5.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0 50.0 60.0 70.0 80.0]

// Planet _3z0h19 _yssmf1
#define PLANET_COLOR_R 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define PLANET_COLOR_G 0.87 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define PLANET_COLOR_B 0.55 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Ring _yssmf1 tint
#define RING_COLOR_R 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define RING_COLOR_G 0.85 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define RING_COLOR_B 0.60 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Ring _445ceo _huatah (0 = edge-on, higher = more _fxiwh2)
#define RING_TILT 8.0 // [0.0 2.0 4.0 6.0 8.0 10.0 15.0 20.0 25.0 30.0 35.0 40.0 45.0]


// ----------------------------------------------------------------------------
//   2D Clouds
// ----------------------------------------------------------------------------

// Enable stylized 2D _u9na24
//#define CLOUDS_2D_ENABLED

// Enable cloud _2tg9v1 on terrain
#define CLOUD_SHADOWS_ENABLED

#ifdef CLOUD_SHADOWS_ENABLED
const bool CLOUD_SHADOWS_ENABLED_ANCHOR = true;
#else
const bool CLOUD_SHADOWS_ENABLED_ANCHOR = false;
#endif

// Cloud layer height (blocks above sea _5eon3o)
#define CLOUD_HEIGHT 2000.0// [80.0 100.0 120.0 150.0 180.0 200.0 250.0 300.0 400.0 500.0 1000.0 2000.0 4000.0]

// Cloud _hdc9nq (0 = clear, 1 = overcast)
#define CLOUD_COVERAGE 0.6// [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Cloud _a9z6vr (smaller = bigger _u9na24)
#define CLOUD_SCALE 0.0007// [0.0001 0.0002 0.0003 0.0004 0.0005 0.0007 0.001 0.0015 0.002]

// Cloud movement _9lasr8
#define CLOUD_SPEED 15.0// [0.0 2.0 5.0 10.0 15.0 20.0 30.0 50.0]

// Cloud shadow _6aya72 (0 = no _2tg9v1)
#define CLOUD_SHADOW_STRENGTH 0.0// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Cloud edge style (0 = soft/realistic, 1 = hard/toon)
#define CLOUD_TOON_EDGES 1// [0 1]

// Cloud _xgal31 _uwr0sr
#define CLOUD_BRIGHTNESS 3.0// [0.5 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.5 2.0 2.5 3.0]

// Cloud _vc3ydm (affects 3D look from parallax)
#define CLOUD_THICKNESS 200.0// [10.0 20.0 30.0 50.0 75.0 100.0 150.0 200.0]

// Cloud shadow _yssmf1 setup (customizable)
#define CLOUD_SHADOW_R 0.9 // [0.5 0.6 0.7 0.8 0.9 1.0]
#define CLOUD_SHADOW_G 0.9 // [0.5 0.6 0.7 0.8 0.9 1.0]
#define CLOUD_SHADOW_B 0.95 // [0.5 0.6 0.7 0.8 0.9 1.0]

// ----------------------------------------------------------------------------
//   Vanilla-Style Clouds
// ----------------------------------------------------------------------------

// Enable vanilla-style blocky _u9na24 (_65berf-_qsheo9, pixelated, 3D extruded)
#define CLOUDS_VANILLA_ENABLED

// Height of vanilla cloud layer (blocks above sea _5eon3o)
#define VANILLA_CLOUD_HEIGHT 128.0 // [80.0 100.0 128.0 150.0 192.0 200.0 250.0 300.0 400.0 500.0]

// Cloud _vc3ydm (_iilw4w _xoryyp in blocks ? vanilla is 4)
#define VANILLA_CLOUD_THICKNESS 4.0 // [2.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0]

// Grid _h908e6 _xoryyp (blocks per cloud _04ivny)
#define VANILLA_CLOUD_CELL_SIZE 24.0 // [6.0 8.0 12.0 16.0 24.0]

// Cloud _hdc9nq (0 = clear, 1 = overcast)
#define VANILLA_CLOUD_COVERAGE 0.45 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.70 0.80]

// Cloud movement _9lasr8
#define VANILLA_CLOUD_SPEED 2.0 // [0.0 2.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0]

// Cloud _xgal31
#define VANILLA_CLOUD_BRIGHTNESS 2.0 // [0.5 0.7 0.8 0.9 1.0 1.1 1.2 1.4 1.6 1.8 2.0]

// Cloud render distance (blocks)
#define VANILLA_CLOUD_DISTANCE 3000 // [2000 3000 4000 5000 6000 8000 10000 16000 30000]
// Global cloud _l2ddu3 reduction at night (% at full night)
#define VANILLA_CLOUD_NIGHT_OPACITY_REDUCTION 95 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]
// Global cloud _l2ddu3 reduction during _ae8sgm (% at full _ae8sgm). Clouds _a67ol6 smoothly instead of vanishing.
#define CLOUD_RAIN_OPACITY_REDUCTION 100 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]
// Extra _q3g0w9 on cloud side-face shading (%)
#define VANILLA_CLOUD_SIDE_DARKNESS 20 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]
// Extra _q3g0w9 on cloud underside _3z0h19 shading (%)
#define VANILLA_CLOUD_BOTTOM_DARKNESS 5 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

// Cloud _yssmf1
#define VANILLA_CLOUD_R 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define VANILLA_CLOUD_G 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define VANILLA_CLOUD_B 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Raymarch quality (samples per ray ? higher = sharper but slower)
#define VANILLA_CLOUD_STEPS 64 // [16 24 32 48 64 96 128 192 256 384 512]

// Layer spacing ? _iilw4w distance between cloud layers (blocks)
#define VANILLA_CLOUD_LAYER_SPACING 32.0 // [2.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0 48.0 64.0 96.0 128.0 192.0 256.0]

// Layer 1 (bottom) ? _hdc9nq, _h908e6 _xoryyp, and _l2ddu3
#define VANILLA_CLOUD_L1_COVERAGE 0.80 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.70 0.80]
#define VANILLA_CLOUD_L1_PIXEL_SIZE 6.0 // [4.0 6.0 8.0 10.0 12.0 16.0 20.0 24.0 32.0]
#define VANILLA_CLOUD_L1_OPACITY 100 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

// Layer 2 (middle/main) ? _hdc9nq, _h908e6 _xoryyp, and _l2ddu3
#define VANILLA_CLOUD_L2_COVERAGE 0.50 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.70 0.80]
#define VANILLA_CLOUD_L2_PIXEL_SIZE 4.0 // [4.0 6.0 8.0 10.0 12.0 16.0 20.0 24.0 32.0]
#define VANILLA_CLOUD_L2_OPACITY 25 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

// Layer 3 (top) ? _hdc9nq, _h908e6 _xoryyp, and _l2ddu3
#define VANILLA_CLOUD_L3_COVERAGE 0.65 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.80]
#define VANILLA_CLOUD_L3_PIXEL_SIZE 4.0 // [4.0 6.0 8.0 10.0 12.0 16.0 20.0 24.0 32.0]
#define VANILLA_CLOUD_L3_OPACITY 5 // [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

// Corner rounding _nr5rfo ? fraction of _h908e6 _xoryyp [0 = sharp, 0.3 = very round]
#define VANILLA_CLOUD_CORNER_RADIUS 0.18 // [0.0 0.05 0.10 0.15 0.18 0.20 0.25 0.30]

// ----------------------------------------------------------------------------
//   3D Volumetric Clouds
// ----------------------------------------------------------------------------

// Enable 3D volumetric raymarched _u9na24
//#define CLOUDS_3D_ENABLED

// Raymarch quality (_amohs0). Higher = better but slower
#define CLOUD_3D_STEPS 48 // [8 12 16 20 24 32 48 64 96 128]

// Cloud _hdc9nq (0 = clear, 1 = overcast)
#define CLOUD_3D_COVERAGE 0.65 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90]

// Cloud _3tqs27 (optical _vc3ydm)
#define CLOUD_3D_DENSITY 2.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00 4.00]

// Cloud layer height (blocks above sea _5eon3o)
#define CLOUD_3D_HEIGHT 300.0 // [100.0 150.0 200.0 250.0 300.0 400.0 500.0 600.0 800.0 1000.0 2000.0]

// Cloud layer _vc3ydm (_iilw4w _xoryyp in blocks)
#define CLOUD_3D_THICKNESS 150.0 // [40.0 60.0 80.0 100.0 120.0 150.0 200.0 300.0]

// Cloud _q9uf1c _a9z6vr (lower = bigger _u9na24)
#define CLOUD_3D_SCALE 1.0 // [0.3 0.5 0.7 0.8 1.0 1.2 1.5 2.0 3.0]

// Grid _h908e6 _xoryyp in blocks (controls cloud "pixel" _xoryyp ? vanilla-style blockiness)
#define CLOUD_3D_CELL_SIZE 60.0 // [8.0 12.0 16.0 20.0 25.0 30.0 40.0 50.0 60.0 80.0 100.0 120.0]

// Detail _wbz0iu _6aya72 (puffy cauliflower bumps)
#define CLOUD_3D_DETAIL 1.0 // [0.0 0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.25 3.50 3.75 4.00 4.25 4.50 4.75 5.00 5.25 5.50 5.75 6.00]

// Cloud movement _9lasr8
#define CLOUD_3D_SPEED 6.0 // [0.0 2.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0]

// Cloud _xgal31
#define CLOUD_3D_BRIGHTNESS 1.2 // [0.3 0.5 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.6 1.8 2.0 2.5 3.0]

// Render distance for 3D _u9na24 (blocks from player). Clouds _a67ol6 out near the edge.
#define CLOUD_3D_DISTANCE 8000 // [1000 2000 3000 4000 5000 6000 8000 10000 12000 16000 20000 30000]

// Edge _jjyhed _0v7t0i (silver lining on thin edges)
#define CLOUD_3D_EDGE_GLOW 0.1 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.8 1.0]

// Cloud _yssmf1 (white by default ? stylized cartoon _u9na24)
#define CLOUD_3D_R 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define CLOUD_3D_G 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define CLOUD_3D_B 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// ----------------------------------------------------------------------------
//   Sky Colors - Day
// ----------------------------------------------------------------------------

#define DAY_BRIGHTNESS 1.00// [0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.50 1.75 2.00]

// Day _h8ie4b _yssmf1 (_8ores8 _ibo5av)
#define DAY_HORIZON_R 0.65// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define DAY_HORIZON_G 0.95// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define DAY_HORIZON_B 1.00// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Day _3p73xa _yssmf1 (medium _ibo5av)
#define DAY_MID_R 0.70// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define DAY_MID_G 0.87// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define DAY_MID_B 1.00// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Day _61es6w _yssmf1 (deep _ibo5av)
#define DAY_ZENITH_R 0.60// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define DAY_ZENITH_G 0.69// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define DAY_ZENITH_B 0.98// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Layer _rhnvg2 heights
#define DAY_MID_HEIGHT 0.52// [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60]
#define DAY_ZENITH_HEIGHT 0.85// [0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95]

// ----------------------------------------------------------------------------
//   Sky Colors - Sunset
// ----------------------------------------------------------------------------

#define SUNSET_BRIGHTNESS 0.85// [0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.50 1.75 2.00]

// Sunset _h8ie4b _yssmf1 (orange)
#define SUNSET_HORIZON_R 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SUNSET_HORIZON_G 0.85 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SUNSET_HORIZON_B 0.24 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Sunset _3p73xa _yssmf1 (orange x yellow)
#define SUNSET_MID_R 1.00// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SUNSET_MID_G 0.72// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SUNSET_MID_B 0.20// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Sunset _61es6w _yssmf1 (orange)
#define SUNSET_ZENITH_R 1.00// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SUNSET_ZENITH_G 0.58// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define SUNSET_ZENITH_B 0.17// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Layer _rhnvg2 heights
#define SUNSET_MID_HEIGHT 0.32// [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60]
#define SUNSET_ZENITH_HEIGHT 0.67// [0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95]

// ----------------------------------------------------------------------------
//   Sky Colors - Blue Hour
// ----------------------------------------------------------------------------

#define BLUEHOUR_BRIGHTNESS 0.60// [0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.50 1.75 2.00]

// Blue hour _h8ie4b _yssmf1 (deep purple-_ibo5av)
#define BLUEHOUR_HORIZON_R 0.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define BLUEHOUR_HORIZON_G 0.70 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define BLUEHOUR_HORIZON_B 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Blue hour _3p73xa _yssmf1 (deep _ibo5av)
#define BLUEHOUR_MID_R 0.35 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define BLUEHOUR_MID_G 0.36 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define BLUEHOUR_MID_B 0.62 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Blue hour _61es6w _yssmf1 (deep _ibo5av)
#define BLUEHOUR_ZENITH_R 0.15 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define BLUEHOUR_ZENITH_G 0.22 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define BLUEHOUR_ZENITH_B 0.50 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Layer _rhnvg2 heights
#define BLUEHOUR_MID_HEIGHT 0.30 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60]
#define BLUEHOUR_ZENITH_HEIGHT 0.65 // [0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95]

// ----------------------------------------------------------------------------
//   Sky Colors - Night
// ----------------------------------------------------------------------------

#define NIGHT_BRIGHTNESS 0.75// [0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.25 1.50 1.75 2.00 2.50 3.00 4.00 5.00 6.00 7.00 8.00 10.00 15.00 20.00]
#define NIGHT_BIOME_STRENGTH 0.00// [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Night _h8ie4b _yssmf1 (dark _5pcsb1-_ibo5av)
#define NIGHT_HORIZON_R 0.39// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]
#define NIGHT_HORIZON_G 0.40// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]
#define NIGHT_HORIZON_B 0.62// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]

// Night _3p73xa _yssmf1 (darker _ibo5av)
#define NIGHT_MID_R 0.18// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]
#define NIGHT_MID_G 0.10// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]
#define NIGHT_MID_B 0.39// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]

// Night _61es6w _yssmf1 (deep _ibo5av)
#define NIGHT_ZENITH_R 0.00// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]
#define NIGHT_ZENITH_G 0.08// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]
#define NIGHT_ZENITH_B 0.27// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.35 0.40 0.50]

// Layer _rhnvg2 heights
#define NIGHT_MID_HEIGHT 0.47// [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60]
#define NIGHT_ZENITH_HEIGHT 0.68// [0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95]
