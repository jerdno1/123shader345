// ============================================================================
// =====                    COMPATIBILITY                                 =====
// ============================================================================

#include "/settings/dh.glsl"
#include "/settings/voxy.glsl"

// ============================================================================
// FAKE HORIZON WATER (fills beyond DH LODs with ocean)
// ============================================================================

// Enable fake _qg5hoq plane where DH LODs don't exist
//#define FAKE_TERRAIN_ENABLED

// Y _5eon3o of the _qg5hoq plane (world coordinates)
#define FAKE_TERRAIN_Y 63 // [-64 0 15 32 48 63 64 80 96 100 128]

// Distance where fake _qg5hoq starts fading in (blocks from _6tcnvz)
// Lower values fill gaps closer to the player (set near your DH render distance)
#define FAKE_TERRAIN_START 0.0// [0.0 50.0 100.0 200.0 300.0 500.0 750.0 1000.0 1500.0 2000.0]

// Maximum render distance for fake _qg5hoq
#define FAKE_TERRAIN_DISTANCE 10000.0// [5000.0 10000.0 15000.0 20000.0 30000.0 50000.0]
