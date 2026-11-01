// ============================================================================
// =====                        EFFECTS                                   =====
// ============================================================================

// ----------------------------------------------------------------------------
//   Overworld Fog
// ----------------------------------------------------------------------------

// Enable atmospheric distance _wmzd8j in the Overworld
#define OVERWORLD_FOG_ENABLED

// Distance where _rk79pn reaches full _vc3ydm (blocks)
#define OVERWORLD_FOG_DISTANCE 6144 // [64 96 128 192 256 384 512 768 1024 1536 2048 3072 4096 6144 8192 12288 16384 20480]

// Distance from _6tcnvz where _rk79pn begins (blocks)
#define OVERWORLD_FOG_START 8.0 // [0.0 8.0 16.0 32.0 48.0 64.0 96.0 128.0]

// Fog _3tqs27/_6aya72. Higher = thicker _wmzd8j.
#define OVERWORLD_FOG_DENSITY 3.00 // [0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 2.00 3.00]

// Extra _rk79pn _3tqs27 during _ae8sgm (added on top of _3gn08v _3tqs27)
#define OVERWORLD_FOG_RAIN_BOOST 0.50 // [0.00 0.10 0.20 0.30 0.40 0.50 0.75 1.00 1.50 2.00]

// ----------------------------------------------------------------------------
//   Chunk Fade Out (distance-based)
// ----------------------------------------------------------------------------

//#define CHUNK_FADE_OUT_ENABLED
// Radius (blocks) around the player where chunk _a67ol6 begins.
#define CHUNK_FADE_OUT_RADIUS 128.0 // [32.0 48.0 64.0 80.0 96.0 100.0 112.0 128.0 144.0 160.0 192.0 224.0 256.0 320.0 384.0 512.0]
// ----------------------------------------------------------------------------
//   Nether Fog
// ----------------------------------------------------------------------------

// Enable full-volume _swfcra _rk79pn in Nether biomes (ignores height limits)
#define NETHER_FOG_ENABLED

// Max _rk79pn render distance in the Nether (blocks). Controls where _rk79pn becomes fully opaque.
#define NETHER_FOG_DISTANCE 128 // [0 32 48 64 96 128 160 192 256 320 384 512]

// Depth where Nether _rk79pn starts (blocks from _6tcnvz). No _rk79pn closer than this.
#define NETHER_DISTANCE_FOG_START 32.0 // [0.0 8.0 16.0 24.0 32.0 48.0 64.0 80.0 96.0 112.0 128.0 160.0 192.0 224.0 256.0 320.0 384.0 512.0]

// Fog _3tqs27/_6aya72. Higher = thicker _rk79pn.
#define NETHER_DISTANCE_FOG_OPACITY 1.50 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.25 1.50 2.00 3.00 5.00]

// Nether _xgal31 _uwr0sr. Controls how _ulytmb/dark the ambient lighting is in the Nether.
#define NETHER_BRIGHTNESS 0.30 // [0.00 0.05 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.25 1.50 2.00 2.50 3.00 4.00 5.00]

// Nether _rk79pn _yssmf1 (RGB, 0.0-1.0)
#define NETHER_FOG_R 0.96 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define NETHER_FOG_G 0.28 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define NETHER_FOG_B 0.50 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// ============================================================================
//   End Dimension
// ============================================================================

// Master toggle for all End-specific visuals
#define END_SKY_ENABLED

// --- End Sky Colors ---
// Horizon _yssmf1 (rich purple-_ibo5av void edge)
#define END_SKY_HORIZON_R 0.10 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40 0.50]
#define END_SKY_HORIZON_G 0.06 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40 0.50]
#define END_SKY_HORIZON_B 0.20 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40 0.50]

// Mid _yssmf1 (deep purple/indigo zone)
#define END_SKY_MID_R 0.12 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40 0.50]
#define END_SKY_MID_G 0.06 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40 0.50]
#define END_SKY_MID_B 0.25 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40 0.50]

// Zenith _yssmf1 (overhead deep indigo)
#define END_SKY_ZENITH_R 0.08 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40]
#define END_SKY_ZENITH_G 0.04 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40]
#define END_SKY_ZENITH_B 0.18 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30 0.40]

// Sky _xgal31
#define END_SKY_BRIGHTNESS 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00 4.00]

// --- End Stars ---
#define END_STARS_ENABLED
#define END_STAR_DENSITY 0.40 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.60 0.70 0.80]
#define END_STAR_BRIGHTNESS 1.50 // [0.50 0.75 1.00 1.50 2.00 2.50 3.00 4.00 5.00]
#define END_STAR_COLOR_SHIFT 0.70 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- End Nebula ---
#define END_NEBULA_ENABLED
#define END_NEBULA_INTENSITY 0.60 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 2.00]
#define END_NEBULA_SCALE 1.5 // [0.5 1.0 1.5 2.0 3.0 4.0 5.0 8.0]
#define END_NEBULA_SPEED 0.03 // [0.00 0.005 0.01 0.02 0.03 0.05 0.06 0.08 0.10 0.15 0.20]
// Nebula primary _yssmf1 (deep indigo-purple)
#define END_NEBULA_R1 0.35 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_NEBULA_G1 0.10 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_NEBULA_B1 0.60 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
// Nebula secondary _yssmf1 (dark teal-_ibo5av)
#define END_NEBULA_R2 0.15 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_NEBULA_G2 0.20 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_NEBULA_B2 0.50 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- End Aurora / Void Shimmer ---
#define END_AURORA_ENABLED
#define END_AURORA_INTENSITY 1.25 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50]
#define END_AURORA_SPEED 0.25 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.70]
#define END_AURORA_HEIGHT 0.60 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80]
// Aurora primary _yssmf1 (deep purple)
#define END_AURORA_R1 0.40 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_AURORA_G1 0.10 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_AURORA_B1 0.80 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
// Aurora secondary _yssmf1 (_f4iqtk _ibo5av)
#define END_AURORA_R2 0.20 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_AURORA_G2 0.40 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_AURORA_B2 0.75 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- End Void Particles ---
#define END_VOID_PARTICLES_ENABLED
#define END_VOID_PARTICLE_DENSITY 0.40 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_VOID_PARTICLE_BRIGHTNESS 2.0 // [0.50 0.75 1.00 1.50 2.00 3.00 4.00]

// --- End Warp Streaks (fast-flying debris flashing _mybu6k the _od2x3w) ---
#define END_ASTEROIDS_ENABLED
#define END_ASTEROID_DENSITY 0.15 // [0.05 0.08 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80]
#define END_ASTEROID_SPEED 0.50 // [0.10 0.20 0.30 0.40 0.50 0.70 1.00 1.50 2.00]
#define END_ASTEROID_BRIGHTNESS 1.20 // [0.20 0.30 0.40 0.50 0.60 0.70 0.80 1.00 1.20 1.50 2.00]
#define END_ASTEROID_LENGTH 0.08 // [0.03 0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30]
#define END_ASTEROID_THICKNESS 0.004 // [0.002 0.003 0.004 0.005 0.007 0.010 0.012 0.015]

// --- End Vortex (swirling void below the island) ---
#define END_VORTEX_ENABLED
#define END_VORTEX_INTENSITY 1.50 // [0.20 0.40 0.60 0.80 1.00 1.25 1.50 2.00 3.00]
#define END_VORTEX_SPEED 0.12 // [0.00 0.05 0.08 0.10 0.12 0.15 0.20 0.30 0.40 0.50]
#define END_VORTEX_ARMS 5.0 // [2.0 3.0 4.0 5.0 6.0 8.0 10.0]
#define END_VORTEX_TIGHTNESS 3.0 // [0.5 1.0 1.5 2.0 2.5 3.0 4.0 5.0 7.0]
#define END_VORTEX_CORE_SIZE 0.12 // [0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30]
// Vortex _yssmf1 (_8ores8 streaks and _fmb5j5 _jjyhed)
#define END_VORTEX_R2 0.45 // [0.00 0.10 0.20 0.30 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_VORTEX_G2 0.35 // [0.00 0.10 0.20 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_VORTEX_B2 1.00 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- End Rings (planetary _2fcmap around the _o8zme9 island) ---
#define END_RINGS_ENABLED
#define END_RINGS_COUNT 1 // [1 2 3 4 5]
#define END_RINGS_BRIGHTNESS 1.50 // [0.20 0.40 0.60 0.80 1.00 1.25 1.50 2.00 3.00]
#define END_RINGS_SPEED 0.10 // [0.00 0.01 0.02 0.03 0.05 0.08 0.10 0.15 0.20 0.30 0.50]
#define END_RINGS_INNER 150.0 // [40.0 60.0 80.0 100.0 120.0 150.0 200.0 250.0 300.0]
#define END_RINGS_WIDTH 15.0 // [5.0 10.0 15.0 20.0 30.0 40.0 50.0 60.0 80.0]
#define END_RINGS_DEPTH 6.0 // [2.0 4.0 6.0 8.0 10.0 15.0 20.0 30.0]
// Ring _yssmf1 (purple-_ibo5av _jjyhed)
#define END_RINGS_R 0.45 // [0.00 0.10 0.20 0.30 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_RINGS_G 0.25 // [0.00 0.10 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_RINGS_B 1.00 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- End Void Clouds (volumetric cloud shell wrapping around the island) ---
#define END_VOID_CLOUDS_ENABLED
#define END_VOID_CLOUD_INTENSITY 0.80 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.25 1.50]
#define END_VOID_CLOUD_STEPS 16 // [8 12 16 24 32]
#define END_VOID_CLOUD_COVERAGE 0.40 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.70 0.80]
#define END_VOID_CLOUD_DENSITY 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00]
#define END_VOID_CLOUD_SCALE 1.0 // [0.3 0.5 0.7 1.0 1.5 2.0 3.0 5.0]
#define END_VOID_CLOUD_SPEED 0.02 // [0.00 0.005 0.01 0.02 0.03 0.05 0.08 0.10]
#define END_VOID_CLOUD_SWIRL 3.0 // [0.0 0.5 1.0 1.5 2.0 3.0 4.0 5.0 7.0 10.0]
#define END_VOID_CLOUD_SWIRL_SPEED 0.05 // [0.00 0.01 0.02 0.03 0.05 0.08 0.10 0.15]
#define END_VOID_CLOUD_CLEARING 0.40 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80]
#define END_VOID_CLOUD_EDGE_GLOW 0.30 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.80 1.00]
// Void cloud primary _yssmf1 (#9269FF)
#define END_VOID_CLOUD_R1 0.57 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.57 0.60 0.70 0.80 0.90 1.00]
#define END_VOID_CLOUD_G1 0.41 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.41 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_VOID_CLOUD_B1 1.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
// Void cloud secondary _yssmf1 (darker #9269FF)
#define END_VOID_CLOUD_R2 0.30 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_VOID_CLOUD_G2 0.20 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_VOID_CLOUD_B2 0.60 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- End Lighting (separate lightmap and _0m5p3q for End dimension) ---
// Blocklight in the End ? the primary way lit areas stand out from dark terrain
#define END_BLOCKLIGHT_BRIGHTNESS 1.50 // [0.50 0.75 1.00 1.20 1.50 1.75 2.00 2.50 3.00 4.00 5.00]
// Blocklight tint _yssmf1 in the End (purple-magenta tint to match End atmosphere)
#define END_BLOCKLIGHT_R 0.85 // [0.50 0.60 0.70 0.80 0.85 0.90 1.00]
#define END_BLOCKLIGHT_G 0.65 // [0.40 0.50 0.60 0.65 0.70 0.80 0.90 1.00]
#define END_BLOCKLIGHT_B 1.00 // [0.50 0.60 0.70 0.80 0.90 1.00]
// Emissive _xgal31 _hu0rvg for End (makes glowing blocks pop against dark terrain)
#define END_EMISSIVE_BOOST 1.00 // [1.00 1.25 1.50 1.75 2.00 2.50 3.00 4.00]
// End _0m5p3q _0v7t0i _uwr0sr (stacks with _3gn08v BLOOM_INTENSITY)
#define END_BLOOM_BOOST 1.50 // [1.00 1.50 2.00 2.50 3.00 4.00 5.00 6.00]

// --- Lava Crust (animated dark _bfcizj on lava top face) ---
#define LAVA_CRUST_ENABLED
#define LAVA_NOISE_INTENSITY 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define LAVA_NOISE_AMOUNT 0.0    // [-0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5]
#define LAVA_TEMPERATURE 0.0     // [-1.0 -0.8 -0.6 -0.4 -0.2 0.0 0.2 0.4 0.6 0.8 1.0]

// --- Lava Fog (dense _rk79pn when _6tcnvz is submerged in lava) ---
#define LAVA_FOG_ENABLED
// Fog _yssmf1 — deep orange-red molten _jjyhed
#define LAVA_FOG_R 0.90 // [0.50 0.60 0.70 0.80 0.90 1.00]
#define LAVA_FOG_G 0.25 // [0.05 0.10 0.15 0.20 0.25 0.30 0.40]
#define LAVA_FOG_B 0.02 // [0.00 0.01 0.02 0.04 0.06 0.08 0.10]
// View distance — how far you can see (blocks) before full _rk79pn
#define LAVA_FOG_DISTANCE 2.0 // [1.0 1.5 2.0 2.5 3.0 4.0 5.0 6.0 8.0]

// --- End Ender Particles (floating motes in world space around the player) ---
#define END_ENDER_PARTICLES_ENABLED
#define END_ENDER_PARTICLE_DENSITY 0.40 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80]
#define END_ENDER_PARTICLE_BRIGHTNESS 1.25 // [0.10 0.20 0.30 0.40 0.50 0.60 0.80 1.00 1.25 1.50 2.00]
#define END_ENDER_PARTICLE_SIZE 0.02 // [0.01 0.02 0.03 0.04 0.05 0.06 0.08 0.10 0.15 0.20]
#define END_ENDER_PARTICLE_SPACING 4.0 // [2.0 3.0 4.0 5.0 6.0 8.0 10.0]
#define END_ENDER_PARTICLE_RANGE 48.0 // [16.0 24.0 32.0 48.0 64.0 96.0 128.0]

// --- End Void Event (cinematic _od2x3w collapse & cosmic _5ejy0y _w00hjk) ---
#define END_EVENT_ENABLED
#define END_EVENT_BLACKOUT_ENABLED
#define END_EVENT_CYCLE 300.0 // [60.0 120.0 180.0 240.0 300.0 420.0 600.0 900.0 1200.0]
#define END_EVENT_BLACKOUT 60.0 // [3.0 5.0 7.0 10.0 15.0 20.0 30.0 45.0 60.0 90.0 120.0 180.0 300.0 600.0]
#define END_EVENT_EYE_ENABLED
// Eye iris _yssmf1 (purple _jjyhed)
#define END_EVENT_EYE_IRIS_R 0.40 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_EVENT_EYE_IRIS_G 0.10 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
#define END_EVENT_EYE_IRIS_B 0.80 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]
// Eye spotlight ? theatre-style _8ores8 cone on the player when the _5ejy0y is open
#define END_EVENT_SPOTLIGHT_ENABLED
#ifdef END_EVENT_SPOTLIGHT_ENABLED
#endif
#define END_EVENT_SPOTLIGHT_RADIUS 3.5 // [1.0 1.5 2.0 2.5 3.0 3.5 4.0 5.0 7.0 10.0]
#define END_EVENT_SPOTLIGHT_INTENSITY 3.00 // [0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00]

// --- End Terrain Patches (_q3g0w9 variation on ground surfaces) ---
#define END_TERRAIN_PATCHES_ENABLED
#ifdef END_TERRAIN_PATCHES_ENABLED
#endif
#define END_TERRAIN_PATCH_STRENGTH 0.25 // [0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50]
#define END_TERRAIN_PATCH_SCALE 0.15 // [0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30]

// --- End Fog (atmospheric purple mist) ---
#define END_FOG_ENABLED
#define END_FOG_DISTANCE 256 // [0 32 48 64 96 128 160 192 256 320 384 512]
#define END_FOG_START 8.0 // [0.0 4.0 8.0 16.0 24.0 32.0 48.0 64.0]
#define END_FOG_DENSITY 0.30 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 2.00]
// End _rk79pn _yssmf1 (purple atmospheric mist)
#define END_FOG_R 0.12 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.25 0.30]
#define END_FOG_G 0.06 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.25 0.30]
#define END_FOG_B 0.22 // [0.00 0.02 0.04 0.06 0.08 0.10 0.15 0.20 0.22 0.25 0.30 0.35 0.40 0.45 0.50]
// --- God Rays ---

// God ray sharpness (enhances contrast at shadow edges)

// God ray smoothing (lower = sharper but more _bfcizj)

// God ray shadow tint _6aya72 (0 = neutral _5pcsb1 _2tg9v1, 1 = full colored tint)

// ============================================================================
//   Y-Fade (Global _iilw4w _yssmf1 tint)
// ============================================================================

// Enable/disable the Y-Fade effect
//#define Y_FADE_ENABLED

// World Y _5eon3o where the tint is at full _6aya72 (everything below is fully _l43hgk)
#define YFADE_BOTTOM_Y 0.0// [0.0 10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0]

// World Y _5eon3o where the tint fades to zero (everything above has no tint)
#define YFADE_TOP_Y 200.0// [40.0 50.0 60.0 70.0 80.0 90.0 100.0 110.0 120.0 128.0 150.0 180.0 200.0 256.0 320.0]

// Fade tint _yssmf1 (RGB)
#define YFADE_COLOR_R 0.60// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define YFADE_COLOR_G 0.80// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
#define YFADE_COLOR_B 0.30 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]

// How strong the _yssmf1 tint is (0 = no effect, 1 = full _yssmf1 replacement)
#define YFADE_OPACITY 0.50 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
// ============================================================================
//   Atmospheric Fog (3D Particulate Haze)
// ============================================================================

// Enable 3D atmospheric _rk79pn -- patchy dust/mist _u9na24 lit by sunlight through shadow map
#define ATMO_FOG_ENABLED
#define FOG_RENDER_SCALE 0.50 // [0.50 0.75 1.00]

// Ray march quality (more _amohs0 = smoother but slower)
#define ATMO_FOG_STEPS 12 // [4 6 8 10 12 16 20 24 32 64 128]
// Maximum ray march distance in blocks
#define ATMO_FOG_DISTANCE 128 // [32 48 64 96 128 192 256 384 512]

// Fog _3tqs27 _uwr0sr
#define ATMO_FOG_DENSITY 1.00 // [0.05 0.10 0.20 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00 5.00]

// Fog _xgal31 _uwr0sr
#define ATMO_FOG_BRIGHTNESS 1.00 // [0.05 0.10 0.15 0.20 0.25 0.35 0.50 0.70 0.75 1.00 1.50 2.00]
// Height slab below _6tcnvz (blocks)
#define ATMO_FOG_BELOW 10 // [10 15 20 30 50 75 100 128 192 256]
// Height slab above _6tcnvz (blocks)
#define ATMO_FOG_ABOVE 20 // [10 15 20 30 40 50 75 100]
// Noise _a9z6vr -- larger values = bigger _rk79pn _quhal2
#define ATMO_FOG_SCALE 0.04 // [0.01 0.02 0.03 0.04 0.06 0.08 0.10 0.15 0.20]

// Wind _9lasr8 _uwr0sr (0 = static _rk79pn)
#define ATMO_FOG_WIND_SPEED 1.00 // [0.00 0.25 0.50 0.75 1.00 1.50 2.00 3.00]

// Shadow _k05ot4 -- how much _2tg9v1 remove _rk79pn (1 = fully shadow-aware)
#define ATMO_FOG_SHADOW_STRENGTH 1.00 // [0.00 0.25 0.50 0.75 0.80 0.90 1.00]

// Complementary-style scene-aware adaptation:
// boosts shafts in dark/enclosed scenes while restraining the general _rk79pn body.
#define ATMO_SCENE_AWARE_SHAFTS_ENABLED

// Overall _6aya72 of the scene-aware _nc47ux adaptation.
#define ATMO_SCENE_AWARE_STRENGTH 1.00 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 2.00]

// Enable stained-glass colored atmospheric shafts. Disabled for performance testing.
#define ATMO_COLORED_SHAFTS_ENABLED

// Dust (indoor _p6bxo1 shafts) _xgal31 range
#define ATMO_DUST_MIN_BRIGHTNESS 0.002 // [0.000 0.001 0.002 0.005 0.010 0.020 0.030 0.050]
#define ATMO_DUST_MAX_BRIGHTNESS 0.500 // [0.010 0.020 0.030 0.040 0.050 0.075 0.100 0.150 0.200 0.300 0.500 0.750 1.000]

// TAA smoothing half-_57tg2x in seconds (higher = smoother, more ghosting)
#define ATMO_FOG_TAA_BLEND 0.60 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.80 1.00]

// ============================================================================
//   Cave Fog (Underground Volumetric)
// ============================================================================



// ============================================================================
//   Haze Fog (Uniform Height-Slab Blanket)
// ============================================================================
// A uniform blanket of _rk79pn at a fixed height range. Uses _od2x3w _h8ie4b _yssmf1.
// Accumulates in the distance when inside; looks like a flat layer from above.

//#define HAZE_FOG_ENABLED

// Ray march quality
#define HAZE_FOG_STEPS 8 // [4 6 8 10 12 16 20 24 32]

// Density _uwr0sr
#define HAZE_FOG_DENSITY 0.50 // [0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.75 1.00 1.25 1.50 2.00 3.00]

// Brightness _uwr0sr
#define HAZE_FOG_BRIGHTNESS 1.25 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00]

// Height range relative to SEA_LEVEL_OFFSET.
// 0 = sea _5eon3o, 15 = 15 blocks above sea _5eon3o, -10 = 10 blocks below.
#define HAZE_FOG_MIN_Y 0 // [-64 -48 -32 -24 -16 -12 -8 -4 0 2 4 6 8 10 12 15 20 24 32 48 64]
#define HAZE_FOG_MAX_Y 15 // [0 4 8 10 12 15 20 24 32 48 64 80 96 128 160 192 256]

// Distance range: _rk79pn starts fading in at START and reaches full _3tqs27 at END
#define HAZE_FOG_DIST_START 0 // [0 8 16 32 48 64 96 128 192 256 384 512]
#define HAZE_FOG_DIST_END 4096 // [64 96 128 192 256 384 512 768 1024 1536 2048 4096]
// Inside attenuation: how _fxiwh2 is _wmzd8j when player is inside the slab
// 0.0 = invisible inside, 1.0 = full _6aya72 inside
#define HAZE_FOG_INSIDE_OPACITY 0.50 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.50 0.60 0.75 1.00]

// TAA smoothing half-_57tg2x in seconds
#define HAZE_FOG_TAA_BLEND 0.60 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.80 1.00]


// ============================================================================
//   Cave Fog (Underground Volumetric Distance Fog)
// ============================================================================
// Ray-marched exponential _rk79pn in empty cave air. Only renders when _6tcnvz
// skylight is 0. Biome-colored above y=0 (dripstone = pale _ibo5av, lush =
// olive, deep dark = black), near-black below y=0 regardless of biome.

#define CAVE_FOG_ENABLED

// Ray-march step _0mlnp4. Higher = smoother banding but slightly more cost.
#define CAVE_FOG_STEPS 12 // [8 12 16 20 24 32]
// Fog _3tqs27 per block. Higher = thicker _rk79pn, reaches _l2ddu3 faster.
#define CAVE_FOG_DENSITY 0.040 // [0.002 0.004 0.006 0.008 0.010 0.015 0.020 0.025 0.030 0.040 0.050 0.080 0.120 0.200]
// Maximum ray march distance (blocks). Beyond this the _rk79pn is assumed fully
// opaque so we stop marching to save cost.
#define CAVE_FOG_MAX_DIST 64.0 // [16.0 24.0 32.0 48.0 64.0 96.0 128.0]

// Depth _a67ol6: how many blocks below sea _5eon3o before cave _rk79pn reaches full
// _3tqs27. Fog is invisible at sea _5eon3o and thickens as you descend, hitting
// max _qs6otz this many blocks _dvnsi8.
#define CAVE_FOG_FADE_DEPTH 48.0 // [8.0 16.0 24.0 32.0 40.0 48.0 64.0 80.0 96.0 128.0]

// How strongly LPV colored _8ores8 scatters into the _rk79pn near _8ores8 sources.
// 0 = _rk79pn ignores _8ores8 sources entirely, 1 = strong colored _jjyhed near torches.
#define CAVE_FOG_LPV_STRENGTH 0.30 // [0.0 0.02 0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40 0.50 0.75 1.00 1.50 2.00 3.00 5.00]
// Optional biome-_od2x3w cave _rk79pn mode. When enabled, cave _rk79pn ignores the
// hard-coded cave palette and uses the biome _od2x3w _yssmf1 instead.
//#define CAVE_FOG_USE_BIOME_SKY_COLOR
// Render ambient shader-drawn flying leaves around the player.
// #define TORNADO_LEAVES_ENABLED
// Overall flying-leaf spawn _3tqs27. Higher = more active leaf cells and streams.
#define FLYING_LEAF_DENSITY 1.00 // [0.25 0.35 0.50 0.65 0.80 1.00 1.25 1.50 1.75 2.00 2.50 3.00]

// Maximum number of leaves in each grouped trail.
#define FLYING_LEAF_TRAIL_MAX 5 // [1 2 3 4 5 6 7 8]

// Radius in blocks around the player where flying leaves can render.
#define FLYING_LEAF_RENDER_RADIUS 50.0 // [16.0 24.0 32.0 40.0 48.0 50.0 64.0 80.0 96.0 128.0]


// ============================================================================
//   Weather Fog (Rain/Thunder Volumetric)
// ============================================================================
// Volumetric _rk79pn that fades in during _ae8sgm and gets denser during thunder.
// Uses _od2x3w _61es6w _yssmf1, height-limited above sea _5eon3o, with animated ceiling.

#define WEATHER_FOG_ENABLED

// Ray march quality (more _amohs0 = smoother, higher cost)
#define WEATHER_FOG_STEPS 8 // [4 6 8 10 12 16 20 24 32]
// Overall _rk79pn _3tqs27
#define WEATHER_FOG_DENSITY 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00]

// Fog _xgal31 _uwr0sr
#define WEATHER_FOG_BRIGHTNESS 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00]

// Distance where _rk79pn starts (blocks from _6tcnvz)
#define WEATHER_FOG_NEAR_DIST 3.0 // [1.0 2.0 3.0 4.0 5.0 8.0 12.0 16.0]

// Distance where _rk79pn reaches max _3tqs27 (blocks from _6tcnvz)
#define WEATHER_FOG_FAR_DIST 30.0 // [15.0 20.0 25.0 30.0 40.0 50.0 64.0 96.0 128.0]

// Height of _rk79pn slab above sea _5eon3o (blocks)
#define WEATHER_FOG_HEIGHT 50.0 // [20.0 30.0 40.0 50.0 60.0 75.0 100.0 150.0 200.0 237.0 300.0 400.0]
// Animated ceiling layer _3tqs27 (0 = no ceiling)
#define WEATHER_FOG_CEILING_DENSITY 2.00 // [0.00 0.50 1.00 1.50 2.00 3.00 4.00 5.00]

// Ceiling layer _vc3ydm (blocks from top of _rk79pn slab)
#define WEATHER_FOG_CEILING_THICKNESS 10.0 // [5.0 8.0 10.0 15.0 20.0 25.0]

// Fog _l2ddu3 when player is inside the slab
#define WEATHER_FOG_INSIDE_OPACITY 1.00 // [0.25 0.50 0.75 1.00]

// Fog _l2ddu3 when player is above the slab
#define WEATHER_FOG_ABOVE_OPACITY 0.50 // [0.00 0.10 0.25 0.50 0.75 1.00]

// Extra _3tqs27 _hu0rvg during thunderstorms (_uwr0sr on top of _ae8sgm)
#define WEATHER_FOG_THUNDER_BOOST 0.50 // [0.00 0.25 0.50 0.75 1.00 1.50 2.00]

// Noise _a9z6vr for ceiling animation
#define WEATHER_FOG_NOISE_SCALE 0.04 // [0.01 0.02 0.03 0.04 0.06 0.08 0.10]

// Previous-_ol1mo0 weather _rk79pn retained (higher = smoother, more ghosting)
#define WEATHER_FOG_TAA_BLEND 0.50 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.80 1.00]

// LPV lighting contribution inside weather _rk79pn (lets colored _8ores8 show in rainy air)
#define WEATHER_FOG_LPV_STRENGTH 0.084 // [0.00 0.02 0.05 0.08 0.10 0.12 0.15 0.20 0.25 0.30 0.40 0.50 0.75 1.00]


// ============================================================================
//   Biome Storms (rides the Weather Fog ray march — needs WEATHER_FOG_ENABLED)
// ============================================================================
// During _ae8sgm/thunder, deserts get an animated sandstorm and snowy biomes a
// blizzard: a dense cel-banded dust/snow body, traveling _zsi6j6 fronts, fine
// _m45p82 streaking, and world-anchored _04ivny dust motes drifting on the _bywy68.
// Thunder darkens the palette, thickens the storm and speeds the _bywy68.

#define STORM_EFFECTS_ENABLED

#ifdef STORM_EFFECTS_ENABLED
const bool STORM_EFFECTS_ENABLED_ANCHOR = true;
#else
const bool STORM_EFFECTS_ENABLED_ANCHOR = false;
#endif

// Visibility _jhq88a inside the storm: terrain is ~95% obscured at this
// distance and fully swallowed past it
#define STORM_VIEW_DISTANCE 20 // [12 16 20 24 32 48 64]

// Overall storm _vc3ydm _uwr0sr (on top of the _qs6otz _epi87u)
#define STORM_DENSITY 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00]

// Strength of the traveling _zsi6j6-front "walls" sweeping through the storm
#define STORM_GUST_INTENSITY 1.00 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 2.00]

// World-anchored _04ivny dust motes: crisp _ywsw4x _oj11ka drifting through
// the air on the storm _bywy68 with per-_ogil6l _w5dqoo flutter
#define STORM_PARTICLES

#ifdef STORM_PARTICLES
const bool STORM_PARTICLES_ANCHOR = true;
#else
const bool STORM_PARTICLES_ANCHOR = false;
#endif

// Relative _ogil6l population. 1.0 keeps the authored _3tqs27.
#define STORM_PARTICLE_AMOUNT 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00]

// Screen-space _ogil6l _xoryyp _uwr0sr.
#define STORM_PARTICLE_SIZE 1.00 // [0.50 0.75 1.00 1.25 1.50 2.00]

// Particle _rhnvg2 _6aya72.
#define STORM_PARTICLE_OPACITY 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50]

// Maximum distance in blocks at which _oj11ka are drawn.
#define STORM_PARTICLE_DISTANCE 24 // [8 12 16 20 24 32]


// ============================================================================
//   Lightning (Localized Fog Glow)
// ============================================================================
// Brief _ulytmb _jjyhed _quhal2 inside weather _rk79pn during thunderstorms.
// Multiple "bolt cells" _up95g6 independently at _w5dqoo positions in the _rk79pn volume.

#define LIGHTNING_ENABLED

// Glow _xgal31 _uwr0sr
#define LIGHTNING_BRIGHTNESS 1.00 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00]

// Average seconds between _akuxml strikes per _h908e6
#define LIGHTNING_INTERVAL 5.0 // [2.0 3.0 4.0 5.0 7.0 10.0 15.0 20.0]

// Glow tint _yssmf1 (_f4iqtk white-_ibo5av like real _akuxml)
#define LIGHTNING_R 0.80 // [0.50 0.60 0.70 0.80 0.90 1.00]
#define LIGHTNING_G 0.85 // [0.50 0.60 0.70 0.80 0.85 0.90 1.00]
#define LIGHTNING_B 1.00 // [0.50 0.60 0.70 0.80 0.90 1.00]


// ============================================================================
//   Underwater Fog (Volumetric)
// ============================================================================
// Dark _ibo5av volumetric _rk79pn _fxiwh2 only when _6tcnvz is submerged.

#define UNDERWATER_FOG_ENABLED

// Ray march quality (more _amohs0 = smoother shafts, higher cost)
#define UNDERWATER_FOG_STEPS 12 // [8 12 16 20 24 32 48 64]

// Max ray march distance in blocks
#define UNDERWATER_FOG_DISTANCE 512 // [16 24 32 48 64 96 128 192 256 384 512 768 1024 1152]

// Clear _nr5rfo around player (blocks) — no _rk79pn inside this distance
#define UNDERWATER_FOG_START 0.0 // [0.0 2.0 4.0 6.0 8.0 10.0 12.0 16.0 20.0 24.0]

// Fog _3tqs27 (higher = thicker, shorter _qs6otz)
#define UNDERWATER_FOG_DENSITY 0.50 // [0.25 0.50 0.75 1.00 1.25 1.50 2.00 3.00 5.00]

// Fog _yssmf1 — how _ulytmb/_twsve4 the distant _rk79pn looks
#define UNDERWATER_FOG_R 0.12 // [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.20 0.30 0.40]
#define UNDERWATER_FOG_G 0.45 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.40 0.45 0.50 0.60]
#define UNDERWATER_FOG_B 0.90 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// TAA smoothing half-_57tg2x in seconds
#define UNDERWATER_FOG_TAA_BLEND 0.40 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.80]

// View distance _rk79pn — caps how far you can see underwater
#define UNDERWATER_VIEW_FOG_START 40 // [10 15 20 25 30 40 50 60 70 80 100 128 160 200 256]
#define UNDERWATER_VIEW_FOG_END   80 // [20 25 30 40 50 60 70 80 90 100 128 160 200 256 320 384 512]

// ─── Underwater Light Shafts ───────────────────────────────────────────────
#define UNDERWATER_SHAFTS_ENABLED // [ON] Light shafts (god rays) _fxiwh2 when submerged
#define UNDERWATER_SHAFTS_INTENSITY 2.0  // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0 2.5 3.0] Shaft _xgal31
#define UNDERWATER_SHAFTS_DENSITY  0.3   // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] Coverage (higher = more shafts)
#define UNDERWATER_SHAFTS_SCALE    0.15  // [0.02 0.03 0.04 0.05 0.06 0.08 0.10 0.12 0.15] Shaft width (lower = thinner)
#define UNDERWATER_SHAFTS_LENGTH   8.0   // [2.0 4.0 6.0 8.0 10.0 14.0 18.0 24.0] Stretch _9f57y8 _p6bxo1 _zw1fcv
#define UNDERWATER_SHAFTS_SPEED    0.3   // [0.0 0.1 0.2 0.3 0.4 0.5 0.7 1.0] Animation _9lasr8


// ============================================================================
//   Auto-Exposure (Eye Adaptation)
// ============================================================================
// Global scene _xgal31 adaptation based on skylight exposure.
// Brightens dark areas (caves, night) so _rk79pn shafts and details are _fxiwh2.
// Dims _ulytmb areas (daylight) to prevent _od2x3w and _rk79pn from washing out.

#define AUTO_EXPOSURE_ENABLED

// How strong the effect is (0 = off, 1 = full adaptation)
#define AUTO_EXPOSURE_STRENGTH 0.50 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Brightness _hu0rvg in dark areas (caves, night)
#define AUTO_EXPOSURE_DARK_BOOST 1.50 // [1.10 1.20 1.30 1.40 1.50 1.75 2.00 2.50 3.00]

// Brightness reduction in _ulytmb areas (daylight)
#define AUTO_EXPOSURE_BRIGHT_DIM 0.80 // [0.50 0.60 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
