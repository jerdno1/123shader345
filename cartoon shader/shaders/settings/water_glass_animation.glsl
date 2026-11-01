// ============================================================================
// =====                          WATER                                   =====
// ============================================================================

// Sea _5eon3o _ja8cqx (moves shader world up/_dvnsi8)
#define SEA_LEVEL_OFFSET 63// [-254 -253 -252 -251 -250 -249 -248 -247 -246 -245 -244 -243 -242 -241 -240 -239 -238 -237 -236 -235 -234 -233 -232 -231 -230 -229 -228 -227 -226 -225 -224 -223 -222 -221 -220 -219 -218 -217 -216 -215 -214 -213 -212 -211 -210 -209 -208 -207 -206 -205 -204 -203 -202 -201 -200 -199 -198 -197 -196 -195 -194 -193 -192 -191 -190 -189 -188 -187 -186 -185 -184 -183 -182 -181 -180 -179 -178 -177 -176 -175 -174 -173 -172 -171 -170 -169 -168 -167 -166 -165 -164 -163 -162 -161 -160 -159 -158 -157 -156 -155 -154 -153 -152 -151 -150 -149 -148 -147 -146 -145 -144 -143 -142 -141 -140 -139 -138 -137 -136 -135 -134 -133 -132 -131 -130 -129 -128 -127 -126 -125 -124 -123 -122 -121 -120 -119 -118 -117 -116 -115 -114 -113 -112 -111 -110 -109 -108 -107 -106 -105 -104 -103 -102 -101 -100 -99 -98 -97 -96 -95 -94 -93 -92 -91 -90 -89 -88 -87 -86 -85 -84 -83 -82 -81 -80 -79 -78 -77 -76 -75 -74 -73 -72 -71 -70 -69 -68 -67 -66 -65 -64 -63 -62 -61 -60 -59 -58 -57 -56 -55 -54 -53 -52 -51 -50 -49 -48 -47 -46 -45 -44 -43 -42 -41 -40 -39 -38 -37 -36 -35 -34 -33 -32 -31 -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254]

// ============================================================================
// =====                         GLASS FILTER                              =====
// ============================================================================

// Enforce stained-glass style _yssmf1 filtering on everything seen through glass.
// This uses the per-_04ivny glass tint buffer (colortex4) written by the translucent pass.
#define GLASS_FILTER_ENABLED

// Overall _6aya72 _uwr0sr (0 = off, 1 = default, >1 = stronger)
#define GLASS_FILTER_STRENGTH 1.00 // [0.00 0.10 0.25 0.50 0.75 1.00 1.25 1.35 1.50 1.75 2.00]
// 0 = mostly multiply (subtle), 1 = stronger luminance-based _yssmf1 enforcement
#define GLASS_FILTER_ENFORCEMENT 0.50 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
// Saturation _hu0rvg for the glass tint _yssmf1 itself
#define GLASS_FILTER_SATURATION 1.25 // [0.50 0.75 1.00 1.25 1.50 1.80 2.00 2.50 3.00]
// ----------------------------------------------------------------------------
//   Water Surface (Above Water View)
// ----------------------------------------------------------------------------

// Water _3z0h19 _yssmf1 (RGB)
#define WATER_COLOR_R 0.15 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40]
#define WATER_COLOR_G 0.35 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50]
#define WATER_COLOR_B 0.55 // [0.20 0.30 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.80]
// Water _zj0avb - increases vibrancy of _qg5hoq _yssmf1 in all biomes
#define WATER_SATURATION 1.75 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00 4.00 5.00 7.50 10.00 15.00 20.00]

// DH/Voxy _qg5hoq _zj0avb
#define WATER_DH_SATURATION 3.00 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00 4.00 5.00 7.50 10.00 15.00 20.00]

// Night-_bim3ym _zj0avb _uwr0sr for _qg5hoq _3z0h19. Applied on top of _3gn08v _zj0avb at night.
// <1.0 = desaturate at night, 1.0 = no change, >1.0 = _hu0rvg _yssmf1 at night.
#define WATER_NIGHT_SATURATION 0.60 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 2.00 2.50 3.00]

// Water _xgal31 _uwr0sr for chunk _qg5hoq
#define WATER_BRIGHTNESS 1.75 // [0.10 0.25 0.50 0.75 1.00 1.05 1.25 1.35 1.50 1.75 2.00 2.50 3.00 4.00 5.00]

// Water _xgal31 _uwr0sr for DH/Voxy LOD _qg5hoq
#define WATER_DH_BRIGHTNESS 1.40 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.05 1.10 1.20 1.30 1.35 1.40 1.50 1.60 1.70 1.80 1.90 2.00 2.10 2.20 2.30 2.40 2.50 2.60 2.70 2.80 2.90 3.00 3.50 4.00 5.00]

// Water shadow _l2ddu3 - controls shadow _q3g0w9 on _qg5hoq (separate from terrain)
#define WATER_SHADOW_OPACITY 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Water reflection _a67ol6 _xgal31 - controls the _ewltmj _a67ol6 edge _xgal31
#define WATER_REFLECTION_FADE 1.0 // [0.3 0.5 0.7 1.0 1.3 1.5 2.0 2.5 3.0]

// Water specular (_p6bxo1/moon reflection _0v7t0i)
#define WATER_SPECULAR_INTENSITY 0.75// [0.00 0.25 0.50 0.75 1.00 1.50 2.00 3.00 4.00 5.00 10.00 20.00]
// --- Water Foam/Edge Effect ---
// Adds a lighter _7vhcjd-like effect where _qg5hoq meets blocks
#define WATER_FOAM_ENABLED
//#define BEACH_WAVES_EVERYWHERE
#define WATER_FOAM_INTENSITY 1.0 // [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOAM_WIDTH 2.0 //  Depth in blocks[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6.0 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 7.0 7.1 7.2 7.3 7.4 7.5 7.6 7.7 7.8 7.9 8.0 8.1 8.2 8.3 8.4 8.5 8.6 8.7 8.8 8.9 9.0 9.1 9.2 9.3 9.4 9.5 9.6 9.7 9.8 9.9 10.0 10.1 10.2 10.3 10.4 10.5 10.6 10.7 10.8 10.9 11.0 11.1 11.2 11.3 11.4 11.5 11.6 11.7 11.8 11.9 12.0 12.1 12.2 12.3 12.4 12.5 12.6 12.7 12.8 12.9 13.0 13.1 13.2 13.3 13.4 13.5 13.6 13.7 13.8 13.9 14.0 14.1 14.2 14.3 14.4 14.5 14.6 14.7 14.8 14.9 15.0 15.1 15.2 15.3 15.4 15.5 15.6 15.7 15.8 15.9 16.0 16.1 16.2 16.3 16.4 16.5 16.6 16.7 16.8 16.9 17.0 17.1 17.2 17.3 17.4 17.5 17.6 17.7 17.8 17.9 18.0 18.1 18.2 18.3 18.4 18.5 18.6 18.7 18.8 18.9 19.0 19.1 19.2 19.3 19.4 19.5 19.6 19.7 19.8 19.9 20.0 20.1 20.2 20.3 20.4 20.5 20.6 20.7 20.8 20.9 21.0 21.1 21.2 21.3 21.4 21.5 21.6 21.7 21.8 21.9 22.0 22.1 22.2 22.3 22.4 22.5 22.6 22.7 22.8 22.9 23.0 23.1 23.2 23.3 23.4 23.5 23.6 23.7 23.8 23.9 24.0 24.1 24.2 24.3 24.4 24.5 24.6 24.7 24.8 24.9 25.0 25.1 25.2 25.3 25.4 25.5 25.6 25.7 25.8 25.9 26.0 26.1 26.2 26.3 26.4 26.5 26.6 26.7 26.8 26.9 27.0 27.1 27.2 27.3 27.4 27.5 27.6 27.7 27.8 27.9 28.0 28.1 28.2 28.3 28.4 28.5 28.6 28.7 28.8 28.9 29.0 29.1 29.2 29.3 29.4 29.5 29.6 29.7 29.8 29.9 30.0]
#define WATER_FOAM_COLOR_R 1.0 // [0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOAM_COLOR_G 1.0 // [0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_FOAM_COLOR_B 1.0 // [0.5 0.6 0.7 0.8 0.9 1.0]

// --- Player Water Foam ---
// Churning _7vhcjd splash around the player when in/near _qg5hoq
#define WATER_PLAYER_FOAM_ENABLED
#define WATER_PLAYER_FOAM_RADIUS 2.5 // [0.5 0.75 1.0 1.5 2.0 2.5 3.0]
#define WATER_PLAYER_FOAM_INTENSITY 0.6 // [0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// --- Water Opacity ---
// Water _l2ddu3 for all chunks (0 = transparent, 1 = solid)
#define WATER_OPACITY 0.35 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// --- Swamp Snake Light ---
// Bioluminescent snake-like _8ores8 swimming under swamp _qg5hoq
#define SWAMP_SNAKE_LIGHT_ENABLED // [On] [Off]

// --- Water Blur ---
// Distance (blocks) where chunk _qg5hoq starts blurring into LOD _qg5hoq
#define WATER_BLUR_START 50.0 // [16.0 24.0 32.0 40.0 50.0 64.0 80.0 96.0 112.0 128.0 160.0 192.0 256.0]

// Distance (blocks) where chunk _qg5hoq _zp9nfz reaches full _6aya72
#define WATER_BLUR_END 160.0 // [48.0 64.0 80.0 96.0 112.0 128.0 160.0 192.0 256.0 320.0 384.0 512.0]


// ----------------------------------------------------------------------------
//   Water Reflections (ILV-style)
// ----------------------------------------------------------------------------

// Enable _qg5hoq reflections (screen-space reflections)
#define WATER_REFLECTIONS_ENABLED

// Cloud reflections on _qg5hoq _3z0h19
//#define WATER_CLOUD_REFLECTIONS_ENABLED

// Debug mode - makes _qg5hoq pink to verify detection
//#define WATER_REFLECTION_DEBUG

// Debug mode - shows _qg5hoq type as solid colors
//#define WATER_DEBUG_COLORS_ENABLED

// ILV Reflection Settings
// SSR ray march _amohs0 — more = reflects farther objects, costs more GPU. If distant terrain
// only reflects when near screen edges, increase this.
#define REFLECTION_ITERATIONS 60 // [20 30 40 50 60 80 100 150 200 300 400 500]
#define REFLECTION_DITHER_AMOUNT 1.0 // [0.0 0.25 0.5 0.75 1.0]
#define REFLECTION_FRESNEL 0.5 // [0.0 0.25 0.5 0.75 1.0]

// Water reflection _6aya72 (how reflective _qg5hoq is)
#define WATER_REFLECTION_AMOUNT 0.70 // [0.10 0.20 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

#define WATER_SKY_REFLECTION 1.0 // [0.00 0.20 0.40 0.60 0.70 0.80 0.90 1.00]

// Sky reflection _xgal31 during the day
// Reduced from 7.50 to compensate for the CG exposure _hu0rvg (+0.16) that was
// _1ot1g9-brightening the reflected _od2x3w on _qg5hoq surfaces.
#define WATER_SKY_BRIGHTNESS_DAY 5.50 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00 4.00 5.00 5.50 7.50 10.00]

// Sky reflection _xgal31 during the night
#define WATER_SKY_BRIGHTNESS_NIGHT 5.50 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00 4.00 5.00 5.50 7.50 10.00]

// SSR (terrain) reflection _xgal31 during the day
#define WATER_REFLECTION_BRIGHTNESS_DAY 3.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00 4.00 5.00 7.50 10.00]

// SSR (terrain) reflection _xgal31 during the night
#define WATER_REFLECTION_BRIGHTNESS_NIGHT 7.50 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00 4.00 5.00 7.50 10.00]

// Max distance (blocks) for screen-space reflections. Beyond this, _qg5hoq uses _od2x3w reflection only.
#define SSR_RENDER_DISTANCE 1024 // [32 48 64 96 128 192 256 384 512 768 1024 1536 2048 3072 4096 6144 8192 12288 16384 20480]
// Wave distortion on _qg5hoq reflections
#define WATER_WAVES_ENABLED
#define WATER_WAVE_SCALE 0.20 // [0.10 0.20 0.30 0.40 0.50 0.60 0.80 1.00 1.50 2.00 3.00 4.00 5.00]
#define WATER_WAVE_SPEED 0.8 // [0.4 0.6 0.8 1.0 1.2 1.5 2.0 3.0 4.0]
#define WATER_WAVE_STRENGTH 0.60 // [0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.80 1.00]

// Ocean _8ystdl parameters (exp-sin _hiq5ip system, ocean biome only)
#define OCEAN_WAVE_DRAG 0.38 // [0.0 0.1 0.2 0.3 0.38 0.5 0.7 1.0]
#define OCEAN_WAVE_ITERS 8 // [4 6 8 10 12]
#define OCEAN_WAVE_ITERS_FAST 5 // [3 4 5 6 8]
#define OCEAN_WAVE_ITERS_NORMAL 36 // [12 18 24 30 36 48]

// How much to _zp9nfz _qg5hoq SSR reflections (_04ivny _nr5rfo). 0 = sharp.
#define WATER_REFLECTION_BLUR 3.0 // [0.0 1.0 2.0 3.0 4.0 5.0 6.0 8.0 10.0 12.0 16.0]

// ----------------------------------------------------------------------------
//   Material Reflections (SSR on polished/smooth/glazed blocks)
// ----------------------------------------------------------------------------
#define MATERIAL_REFLECTIONS_ENABLED
#define MATERIAL_REFLECTION_AMOUNT 0.80// [0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80]

// Fresnel _6aya72 (edge reflection _hu0rvg)
#define MATERIAL_REFLECTION_FRESNEL 0.6// [0.0 0.2 0.4 0.6 0.8 1.0]

// ============================================================================
// =====                    ANIMATION                                     =====
// ============================================================================

// ----------------------------------------------------------------------------
//   Waving Foliage
// ----------------------------------------------------------------------------

// Master toggle for the shader's lively/cartoonish touch.
// When OFF, foliage behaves more like normal blocks: waving is disabled, leaf
// sheen/_8gkfsz are suppressed, and entity self shading returns.
#define MAGICAL_TOUCH

// Enable waving plants
#define WAVING_PLANTS

// Enable waving leaves
#define WAVING_LEAVES

// Waving style: 0 = Photon-style, 1 = Custom
#define WAVING_STYLE 1 // [0 1]

// Enable player plant interaction
#define PLAYER_PLANT_INTERACTION

// Enable swaying lanterns
#define SWAYING_LANTERNS

// --- General Waving ---
// Global waving _9lasr8
#define WAVING_SPEED 0.50// [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.75 2.00 2.50 3.00]

// Global waving _0v7t0i
#define WAVING_INTENSITY 1.30// [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.75 2.00 2.50 3.00]

// --- Grass Specific ---
// Grass waving _9lasr8 _uwr0sr
#define GRASS_WAVING_SPEED 1.0// [0.25 0.50 0.75 1.00 1.25 1.35 1.50 1.75 2.00 2.25 2.50 3.00]

// Grass waving _0v7t0i _uwr0sr
#define GRASS_WAVING_INTENSITY 1.8// [0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 3.00]

// --- Lantern Sway ---
// Lantern sway _9lasr8
#define LANTERN_SWAY_SPEED 1.5// [0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00]

// Lantern sway _0v7t0i
#define LANTERN_SWAY_INTENSITY 1.8// [0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00]

// --- Distance Boost ---
// Maximum distance _hu0rvg _uwr0sr
#define WAVING_DISTANCE_BOOST_MAX 4.0// [1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.50 4.00]

// Distance _hu0rvg _nyp5wo (blocks)
#define WAVING_DISTANCE_BOOST_START 24 // [0.0 8.0 16.0 24.0 32.0 48.0 64.0 80.0 96.0]

// Distance _hu0rvg end (blocks)
#define WAVING_DISTANCE_BOOST_END 320// [64.0 80.0 96.0 112.0 128.0 160.0 192.0 224.0 256.0 320.0]

// --- Player Interaction ---
// General interaction _0v7t0i
#define PLAYER_INTERACTION_INTENSITY 1.5// [0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00]

// Grass interaction _0v7t0i
#define GRASS_INTERACTION_INTENSITY 2.2// [0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 3.00]

// Grass interaction _nr5rfo (blocks)
#define GRASS_INTERACTION_RADIUS 4.0// [1.00 1.50 2.00 2.50 2.75 3.00 3.50 4.00 5.00]
