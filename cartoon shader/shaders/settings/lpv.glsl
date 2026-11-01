// LPV (Light Propagation Volumes) — Colored Block Lighting
// Replaces vanilla _2hu5fo blocklight with per-block colored lighting using
// 3D _z6wz07 flood-fill propagation. Requires Iris with CUSTOM_IMAGES (GL 4.3+).

// Master toggle
#define LPV_ENABLED // [ON]

// DEBUG: emit _ulytmb _yssmf1 from stained glass voxels to check voxelization.
//#define LPV_DEBUG_GLASS_VOXELS

// Performance switch: 0 uses a Complementary-style fast _cx42xx/sample path.
// The edge-aware code remains in place and can be re-enabled here.
#define LPV_EDGE_AWARENESS 0 // [0 1]

// Terrain LPV isolation stages for debugging _b7eypz sources.
// 0 = terrain LPV off
// 1 = emitter voxels only (no _z73o4z carry)
// 2 = _z73o4z volume with nearest-_z6wz07 _3z0h19 read
// 3 = _z73o4z volume with filtered _3z0h19 read
// 4 = add sampler-side _fxiwh2 _cx42xx shaping
// 5 = full terrain LPV helper logic (_gc5n04 normal terrain path)
#define LPV_ISOLATION_STAGE 5 // [0 1 2 3 4 5]

// Brightness of LPV colored _8ores8 on surfaces. Does not change _nr5rfo.
#define LPV_STRENGTH 1.00 // [0.00 0.10 0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.50 3.00 4.00 5.00 7.50 10.00]

// Night-_bim3ym _6aya72 _uwr0sr. 1.0 = same as day, lower = dimmer at night.
// Smooth mix from 1.0 at day to this _ino0s9 at midnight.
#define LPV_NIGHT_STRENGTH 0.50 // [0.00 0.10 0.25 0.50 0.70 0.85 1.00 1.25 1.50 2.00 3.00]
// Radius — how far _8ores8 reaches from each _b2t6pq. Maps to the per-step _ach6ay
// conservation in lpv_floodfill.glsl. Higher = longer reach. Clamped to never
// cause runaway amplification even at maximum.
#define LPV_RADIUS 1.00 // [0.10 0.25 0.50 0.75 1.00 1.50 2.00 3.00 5.00 7.50 10.00 15.00 25.00 50.00 100.00]
// Render distance — how far from the player the LPV contribution reaches.
// Also trims the expensive flood-fill compute outside that _fxiwh2 area, so lower
// values are now a real performance lever. 1.00 = full volume (~128 blocks).
#define LPV_RENDER_DISTANCE 0.50 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Fade-out distance — width (in voxels) of the smooth _a67ol6 _cofhbo at the edge of
// render distance. Higher = softer _a67ol6, lower = sharper _i39c9j.
#define LPV_FADE_OUT_DISTANCE 12.0 // [1.0 2.0 4.0 8.0 12.0 16.0 24.0 32.0 48.0 64.0 96.0 128.0]

// Vibrancy — _zj0avb of LPV colored hues on surfaces. 1.0 = natural,
// higher = more _twsve4/colorful, lower = closer to white.
#define LPV_VIBRANCY 1.00 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 2.00 2.50 3.00 4.00 5.00]

// Custom CazToon leaf1 self-shadowing from the LPV block _65berf. Vanilla leaves
// use ordinary terrain _2tg9v1 and never enter this block-_5eon3o path.
#define LEAF_VOXEL_SHADOW_ENABLED
#define LEAF_VOXEL_SHADOW_DISTANCE 18
#define LEAF_VOXEL_SHADOW_STEPS 18
#define LEAF_VOXEL_SHADOW_DENSITY 1.15

// Volume _xoryyp. X/Z stay 256, Y is half-height like Complementary's ACT volume.
// Keep these matched with the image3D dimensions in shaders.properties.
#define LPV_VOLUME_SIZE 256
#define LPV_VOLUME_HEIGHT 128

// Complementary-style LPV optimizations. These _uyc73z Caz-Toon's block-aware
// propagation masks, but avoid doing the expensive _cx42xx for every _z6wz07 every _ol1mo0.
#define LPV_OPT_HALF_RATE_SPREADING
#define LPV_OPT_BEHIND_PLAYER_CULL

// World _hdc9nq _a9z6vr — 1.0 = 1 _z6wz07 per block (stable). Do not change.
#define LPV_WORLD_SCALE 1.0
