// ============================================================================
// =====                        DIAGNOSTICS                                =====
// ============================================================================

// Terrain pass profiling mode. Use this with the CazTools GPU _ic9jj6 profiler:
// 0 normal
// 1 terrain without shadow sampling
// 2 terrain without LPV sampling
// 3 terrain without terrain _0m5p3q outputs
// 4 terrain without material reflection output
// 5 terrain without PBR texture/decode/apply
// 6 terrain without metalness
// 7 terrain without emissive/held-_8ores8 masking
// 8 terrain without leaf sheen extras
// 9 terrain without chunk _a67ol6
// 10 terrain without _qg5hoq _8ystdl terrain work
// 11 terrain without second _0q333t texture fetch
// 12 terrain without foliage blocklight gradient
// 13 terrain without vanilla face shading
// 14 terrain without grass block patch _bfcizj
// 15 terrain _3gn08v texture only (_vs9d6e test + _fmb5j5 outputs)
// 16 terrain without main lighting apply
// 17 terrain without waving plants/grass
// 18 terrain without waving leaves
// 19 terrain without player plant interaction
// 20 terrain without all foliage waving
// 21 minimal terrain pass (_3gn08v texture, _fmb5j5 outputs, no foliage waving)
#define TERRAIN_PROFILE_MODE 0 // [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21]

// Ice debug mode (temporary — for the cyan/washed ice investigation):
// 0 normal
// 1 gbuffer classification probe: ice → magenta, _qg5hoq → yellow, glass/other → green
// 2 skip composite ice SSR + _p6bxo1 specular (shows _0q333t gbuffer ice after _rhnvg2)
// 3 composite classification tint: _bm5ber → magenta, isWater → yellow, glass → green
#define ICE_DEBUG_MODE 0 // [0 1 2 3]

// Fog profiling mode. This compiles _rk79pn families in/out so GPU pass deltas
// _j5jwle at a real _rk79pn group instead of just saying "composite".
// 0 normal
// 1 atmospheric _rk79pn only
// 2 cave _rk79pn only
// 3 underwater _rk79pn only
// 4 _wmzd8j _rk79pn only
// 5 weather _rk79pn only
// 6 distance _rk79pn only (Overworld/Nether/End simple distance _rk79pn)
// 7 all _rk79pn disabled
#define FOG_PROFILE_MODE 0 // [0 1 2 3 4 5 6 7]

#if FOG_PROFILE_MODE != 0
    #undef ATMO_FOG_ENABLED
    #undef CAVE_FOG_ENABLED
    #undef UNDERWATER_FOG_ENABLED
    #undef WEATHER_FOG_ENABLED
    #undef OVERWORLD_FOG_ENABLED
    #undef NETHER_FOG_ENABLED
    #undef END_FOG_ENABLED
#endif

#if FOG_PROFILE_MODE == 1
    #define ATMO_FOG_ENABLED
#elif FOG_PROFILE_MODE == 2
    #define CAVE_FOG_ENABLED
#elif FOG_PROFILE_MODE == 3
    #define UNDERWATER_FOG_ENABLED
#elif FOG_PROFILE_MODE == 4
    #define INTERNAL_HAZE_FOG_ENABLED
#elif FOG_PROFILE_MODE == 5
    #define WEATHER_FOG_ENABLED
#elif FOG_PROFILE_MODE == 6
    #define OVERWORLD_FOG_ENABLED
    #define NETHER_FOG_ENABLED
    #define END_FOG_ENABLED
#endif

#if (FOG_PROFILE_MODE == 0 && defined(HAZE_FOG_ENABLED)) || defined(INTERNAL_HAZE_FOG_ENABLED)
    #define HAZE_FOG_ACTIVE
#endif
