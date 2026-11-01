// ============================================================================
// =====                        LIGHTING                                  =====
// ============================================================================

// ----------------------------------------------------------------------------
//   Shadows
// ----------------------------------------------------------------------------

// Enable directional _2tg9v1 (_p6bxo1/moon _2tg9v1)
#define SHADOWS_ENABLED

// Allow name tags, text displays, and server holograms to cast _p6bxo1/moon _2tg9v1.
#define FLOATING_TEXT_SHADOWS

#ifdef FLOATING_TEXT_SHADOWS
const bool FLOATING_TEXT_SHADOWS_ANCHOR = true;
#else
const bool FLOATING_TEXT_SHADOWS_ANCHOR = false;
#endif


// Shadow map resolution (lower is faster, Quartic Distortion keeps _za3y2e high)
const int _qezbw4 = 3072; // [512 1024 2048 3072 4096 6144 8192 12288 16384]

// Shadow render distance (chunks). Internal SHADOW_DISTANCE in blocks = chunks * 16.
#define SHADOW_DISTANCE_CHUNKS 12 // [2 3 4 6 8 10 12 14 16 20 24 28 32 40 48 64 80 96 128 160 192 256 320 384 512 625]
#define SHADOW_DISTANCE (float(SHADOW_DISTANCE_CHUNKS) * 16.0)

// Shadow distortion _4mbz2g (_pi2d9l between resolution and edge quality)
// Lower values = more uniform _hdc9nq (better for long distance), higher = more _za3y2e at _o8zme9
#define SHADOW_DISTORTION 0.10// [0.02 0.03 0.04 0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.85]

// Photon-style shadow _swfcra _a9z6vr (internal)
#define SHADOW_DEPTH_SCALE 0.2

// Normal _c4cke4 _a9z6vr (reduces shadow acne)
#define SHADOW_NORMAL_BIAS 2.0 // [0.00 0.50 1.00 1.50 2.00 2.50 3.00 4.00 5.00]

// Shadow _l2ddu3 (0 = no _2tg9v1, 1 = full dark _2tg9v1)
#define SHADOW_OPACITY 0.50// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Shadow _yssmf1 tint (0 = no tint, positive = _f4iqtk/_ibo5av, negative = _2hu5fo/orange)
#define SHADOW_HUE 45.0// [-180.0 -165.0 -150.0 -135.0 -120.0 -105.0 -90.0 -75.0 -60.0 -45.0 -30.0 -15.0 0.0 15.0 30.0 45.0 60.0 75.0 90.0 105.0 120.0 135.0 150.0 165.0 180.0]

// Shadow _yssmf1 _zj0avb (0 = subtle/washed out, 1 = vivid/_twsve4, higher = oversaturated)
#define SHADOW_SATURATION 1.75// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 1.75 2.00 2.50 3.00 4.00 5.00]

// How much blocklight can override/cancel directional _2tg9v1 around _8ores8 sources.
// 0 = no override, 1 = full override near strong blocklight.
#define BLOCKLIGHT_SHADOW_OVERRIDE 1.00// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Lightmap shadow settings (for areas beyond shadow map distance)
// These control the _q3g0w9/_yssmf1 of areas with low skylight
#define LIGHTMAP_SATURATION 0.30// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Skylight _q3g0w9 _1pxkd6. Subtracts fixed _1pxkd6 from skylight 14..1 (15 untouched).
// 0 = no change, 13 = strongest darkening.
#define SKYLIGHT_DARKNESS_LEVELS 0 // [0 1 2 3 4 5 6 7 8 9 10 11 12 13]

// Skylight _q3g0w9 increment _i0turt (Z):
// 0.0 = gentle progression (x1, x1.1, x1.2...), 1.0 = steep progression (x1, x2, x3...).
#define SKYLIGHT_DARKNESS_Z 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Shadow filter style: Sharp uses hardware-bilinear, Soft uses Blue Noise PCF
//#define SHARP_SHADOWS // Sharp _2tg9v1 use less GPU and look crisper. Leave off for soft _2tg9v1.

#ifdef SHARP_SHADOWS
const bool SHARP_SHADOWS_ANCHOR = true;
#else
const bool SHARP_SHADOWS_ANCHOR = false;
#endif

// Pixelated receiver-side shadow lookup, inspired by Complementary Reimagined's
// pixelated lighting snap. Grid _xoryyp is per block face on terrain/_qg5hoq.
//#define PIXELATED_SHADOWS

#ifdef PIXELATED_SHADOWS
const bool PIXELATED_SHADOWS_ANCHOR = true;
#else
const bool PIXELATED_SHADOWS_ANCHOR = false;
#endif

#define PIXELATED_SHADOW_GRID 16 // [16 32 64]
#define PIXELATED_SHADOW_STRENGTH 1.00 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define PIXELATED_SHADOW_BLUR 0.50 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.75 1.00 1.25 1.50 2.00 3.00 4.00]

// PCF filter _nr5rfo for soft _2tg9v1 (only used when SHARP_SHADOWS is disabled).
// Higher values _zp9nfz shadow edges more.
#define SHADOW_PCF_RADIUS 2.5 // [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0]
// Tints direct shadowed areas _ulytmb red for debugging.
//#define SHADOW_DEBUG_TINT

// Visualizes cave/interior lighting terms after all shadowing.
//#define CAVE_LIGHT_DEBUG

// ----------------------------------------------------------------------------
//   Ambient & World Lighting
// ----------------------------------------------------------------------------

// Terrain _xgal31 _uwr0sr
#define TERRAIN_BRIGHTNESS 1.00// [0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20]

// Extra night darkening for non-emissive, non-blocklit lighting (0 = off)
#define NIGHT_DARKNESS 0.35// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Fixed cave/interior ambient floor used by the cave _q3g0w9 control.
const float CAVE_AMBIENT_FLOOR = 0.04;

// Extra cave/interior darkening for non-emissive, non-blocklit lighting (0 = off)
#define CAVE_DARKNESS 0.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Blocklight _xgal31 (torches, lanterns, etc.)
#define BLOCKLIGHT_BRIGHTNESS 0.90// [0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.10 1.20 1.30 1.40 1.50]
// Reduce blocklight when skylight is present.
// 0 = no reduction, 1 = full reduction at full skylight.
#define BLOCKLIGHT_SKYLIGHT_REDUCTION 0.50// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Entity _xgal31 _hu0rvg (0 = normal, 1 = fully _ulytmb)
#define ENTITY_BRIGHTNESS_BOOST 0.00// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// Ambient tint (negative = _2hu5fo, 0 = neutral, positive = _f4iqtk/_ibo5av)
#define AMBIENT_TINT 0.3 // [-1.00 -0.90 -0.80 -0.70 -0.60 -0.50 -0.40 -0.30 -0.20 -0.10 0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// How strongly the _od2x3w colors tint world skylight (0 = neutral white skylight, 1 = fully _od2x3w-colored)
// This is what makes the world pick up the _2hu5fo _h8ie4b _jjyhed at sunset.
#define SKYLIGHT_COLOR_TINT 0.25// [0.00 0.25 0.50 0.65 0.75 0.85 1.00 1.25 1.50 2.00]

// Skylight tint _zj0avb (applies to the _od2x3w-_l43hgk lighting on blocks; 1.0 = unchanged)
#define SKYLIGHT_TINT_SATURATION 1.10// [0.00 0.25 0.50 0.75 1.00 1.10 1.25 1.50 1.75 2.00 2.50 3.00 4.00 5.00]

// Extra _zj0avb applied mostly in _ulytmb/lit areas.
// 0 = _uyc73z lit areas closer to neutral, 1 = lit areas use full SKYLIGHT_TINT_SATURATION.
#define SKYLIGHT_TINT_LIGHT_SATURATION 0.50// [0.00 0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00]

// Extra tint/_zj0avb _hu0rvg at sunset and sunrise on terrain.
// 0 = no extra _5r47x0 beyond SKYLIGHT_COLOR_TINT, higher = stronger golden-hour _jjyhed on blocks.
#define SUNSET_TERRAIN_TINT 0.30// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 1.00 1.10 1.20 1.30 1.40 1.50]

// ----------------------------------------------------------------------------
//   Weather (Rain)
// ----------------------------------------------------------------------------

// Rain transparency _uwr0sr (0 = invisible _ae8sgm, 1 = vanilla texture _vs9d6e)
#define RAIN_OPACITY 0.50// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.75 0.80 0.90 1.00]

// Rain puddles on surfaces (requires _qg5hoq reflections to be enabled)
#define PUDDLES_ENABLED

#ifdef PUDDLES_ENABLED
const bool PUDDLES_ENABLED_ANCHOR = true;
#else
const bool PUDDLES_ENABLED_ANCHOR = false;
#endif
// Overall puddle _hdc9nq/_6aya72
#define PUDDLES_STRENGTH 1.00// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 2.00]
// How reflective puddles are
#define PUDDLES_REFLECTION_STRENGTH 0.30// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Water runoff streaks on _iilw4w surfaces during _ae8sgm
// Disabled by default: the high-contrast _0b3yy5 read as animated line artifacts on block faces.
//#define WALL_RUNOFF_ENABLED

#ifdef WALL_RUNOFF_ENABLED
const bool WALL_RUNOFF_ENABLED_ANCHOR = true;
#else
const bool WALL_RUNOFF_ENABLED_ANCHOR = false;
#endif
// Overall _qs6otz/_6aya72 of runoff streaks
#define WALL_RUNOFF_STRENGTH 0.55 // [0.00 0.10 0.20 0.30 0.40 0.50 0.55 0.60 0.70 0.80 0.90 1.00]
// Speed of the downward _9qq73p
#define WALL_RUNOFF_SPEED 1.00 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00]

// ----------------------------------------------------------------------------
//   Emissive Blocks
// ----------------------------------------------------------------------------

// Per-_04ivny emissive masking — only glowing parts of blocks emit (torch flame glows, stick doesn't)
#define EMISSIVE_MASKING

// Emissive block _xgal31 _uwr0sr
#define EMISSIVE_BRIGHTNESS 1.30 // [0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.40 1.50 1.75 2.00]
#define ENTITY_EMISSIVE_BRIGHTNESS 2.00 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.60 1.70 1.80 1.90 2.00 2.20 2.40 2.60 2.80 3.00 3.50 4.00 5.00 6.00]
#define ENTITY_EMISSIVE_BLOOM 5.00 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.60 1.70 1.80 1.90 2.00 2.20 2.40 2.60 2.80 3.00 3.50 4.00 5.00 6.00 8.00]

// Dynamic handheld _8ores8 (held torches/lanterns/etc. _8ores8 nearby world around player)
#define HANDHELD_LIGHT_ENABLED
#define HANDHELD_LIGHT_STRENGTH 0.50 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.20 1.40 1.60 1.80 2.00 2.50 3.00]
#define HANDHELD_LIGHT_RADIUS 12.0 // [4.0 6.0 8.0 10.0 12.0 14.0 16.0 18.0 20.0 24.0 28.0 32.0 40.0]

// Handheld 3D block _0m5p3q (for mods that render held items as terrain)
// Emission: _xgal31 of the glowing texture on the held item
#define HELD_BLOOM_EMISSION 1.25 // [0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.5 3.0 4.0 5.0 6.0 8.0 10.0 15.0 20.0]
// Bloom _6aya72: _0v7t0i of the _0m5p3q _jjyhed around the held item
#define HELD_BLOOM_STRENGTH 0.5 // [0.5 1.0 1.5 2.0 2.5 3.0 4.0 5.0 6.0 8.0 10.0 15.0 20.0 30.0 50.0]
// Detection _nr5rfo: how close to the player (in blocks) items are detected
#define HELD_BLOOM_RADIUS 0.8 // [0.5 0.8 1.0 1.2 1.5 2.0 2.5 3.0]
// Luma _w8dbmu: minimum texture _xgal31 to trigger _0m5p3q
#define HELD_BLOOM_THRESHOLD 0.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8]
