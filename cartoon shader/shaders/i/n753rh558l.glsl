#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

#ifdef LPV_ENABLED
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
const ivec3 workGroups = ivec3(2, 2, 1);
#else
layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
const ivec3 workGroups = ivec3(1, 1, 1);
#endif

layout(std430, binding = 0) coherent buffer persistentBuffer {
float storedExposure;
float smoothBeach;
float smoothSwamp;
float smoothJungle;
float smoothSnowy;
float smoothArid;
float storedScreenSkylight;
float smoothOcean;
float smoothNetherFogR;
float smoothNetherFogG;
float smoothNetherFogB;
float smoothCaveFogR;
float smoothCaveFogG;
float smoothCaveFogB;
float storedAtmoSceneFactor;
float storedCaveFogTakeover;
float smoothBiomeFogR;
float smoothBiomeFogG;
float smoothBiomeFogB;
float smoothBiomeSkyR;
float smoothBiomeSkyG;
float smoothBiomeSkyB;
float smoothPaleGarden;
float nextStoredExposure;
float nextStoredScreenSkylight;
float nextStoredAtmoSceneFactor;
float nextSmoothCaveFogR;
float nextSmoothCaveFogG;
float nextSmoothCaveFogB;
float nextStoredCaveFogTakeover;
float persistentStateMagic;
};

uniform float biome_beach;
uniform float biome_swamp;
uniform float biome_jungle;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_ocean;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform int frameCounter;
uniform int biome;

vec3 _b6ndha(vec3 _be7slh, vec3 _6mfahm) {
vec3 _c5f3k3 = _be7slh;
vec3 _epi87u = clamp(_6mfahm, vec3(0.0), vec3(1.0));
if (any(isnan(_c5f3k3)) || any(isinf(_c5f3k3)) || dot(abs(_c5f3k3), vec3(1.0)) < 0.001) {
return _epi87u;
}
float _ic9jj6 = length(_c5f3k3 - _epi87u);
float _iujhzo = mix(0.025, 0.12, smoothstep(0.15, 0.60, _ic9jj6));
return mix(_c5f3k3, _epi87u, _iujhzo);
}

void _wqwtdy() {
smoothBeach  = biome_beach;
smoothSwamp  = biome_swamp;
smoothJungle = biome_jungle;
smoothSnowy  = biome_snowy;
smoothArid   = biome_arid;
smoothOcean  = biome_ocean;
smoothPaleGarden = biome_pale_garden;

vec3 _pfwkb9 = _ktauxr(
biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B));
vec3 _07126w = vec3(smoothNetherFogR, smoothNetherFogG, smoothNetherFogB);
if (any(isnan(_07126w)) || any(isinf(_07126w)) ||
dot(abs(_07126w), vec3(1.0)) < 0.001) {
_07126w = _pfwkb9;
}
vec3 _fn4lfa = mix(_07126w, _pfwkb9, 0.03);
smoothNetherFogR = _fn4lfa.r;
smoothNetherFogG = _fn4lfa.g;
smoothNetherFogB = _fn4lfa.b;

vec3 _h12htu = _b6ndha(
vec3(smoothBiomeFogR, smoothBiomeFogG, smoothBiomeFogB), fogColor);
vec3 _r2fd59 = _b6ndha(
vec3(smoothBiomeSkyR, smoothBiomeSkyG, smoothBiomeSkyB), skyColor);

smoothBiomeFogR = _h12htu.r;
smoothBiomeFogG = _h12htu.g;
smoothBiomeFogB = _h12htu.b;
smoothBiomeSkyR = _r2fd59.r;
smoothBiomeSkyG = _r2fd59.g;
smoothBiomeSkyB = _r2fd59.b;
}

#ifdef LPV_ENABLED
#include "/include/lpv/lpv_common.glsl"
#include "/include/lpv/lpv_blocks.glsl"

uint _s7xo9t(int blockId) {
if (blockId < 0) return 0u;
if (_98tocj(blockId)) return 0u;

uint _q4j75g = _yiyljr(1u, 1u, 1u, 1u, 1u, 1u);

if (blockId == 5 || blockId == 82) {
_q4j75g = _yiyljr(1u, 1u, 0u, 0u, 1u, 1u);
}

return _q4j75g;
}
#endif

void main() {
if (all(equal(gl_GlobalInvocationID, uvec3(0u)))) {
bool _qchsam = frameCounter <= 1 ||
isnan(persistentStateMagic) || isinf(persistentStateMagic) ||
abs(persistentStateMagic - 1729.25) > 0.001;

if (_qchsam) {
storedExposure = 0.0;
storedScreenSkylight = 1.0;
storedAtmoSceneFactor = 0.0;
storedCaveFogTakeover = 0.0;
smoothNetherFogR = fogColor.r;
smoothNetherFogG = fogColor.g;
smoothNetherFogB = fogColor.b;
smoothCaveFogR = fogColor.r;
smoothCaveFogG = fogColor.g;
smoothCaveFogB = fogColor.b;
smoothBiomeFogR = fogColor.r;
smoothBiomeFogG = fogColor.g;
smoothBiomeFogB = fogColor.b;
smoothBiomeSkyR = skyColor.r;
smoothBiomeSkyG = skyColor.g;
smoothBiomeSkyB = skyColor.b;
smoothPaleGarden = 0.0;
nextStoredExposure = storedExposure;
nextStoredScreenSkylight = storedScreenSkylight;
nextStoredAtmoSceneFactor = storedAtmoSceneFactor;
nextSmoothCaveFogR = smoothCaveFogR;
nextSmoothCaveFogG = smoothCaveFogG;
nextSmoothCaveFogB = smoothCaveFogB;
nextStoredCaveFogTakeover = storedCaveFogTakeover;
persistentStateMagic = 1729.25;
} else {
if (!isnan(nextStoredExposure) && !isinf(nextStoredExposure) &&
nextStoredExposure >= 0.0 && nextStoredExposure <= 1.5) {
storedExposure = nextStoredExposure;
}
if (!isnan(nextStoredScreenSkylight) && !isinf(nextStoredScreenSkylight) &&
nextStoredScreenSkylight >= 0.0 && nextStoredScreenSkylight <= 1.0) {
storedScreenSkylight = nextStoredScreenSkylight;
}
if (!isnan(nextStoredAtmoSceneFactor) && !isinf(nextStoredAtmoSceneFactor) &&
nextStoredAtmoSceneFactor >= 0.0 && nextStoredAtmoSceneFactor <= 1.0) {
storedAtmoSceneFactor = nextStoredAtmoSceneFactor;
}

vec3 _3ogqd0 = vec3(nextSmoothCaveFogR, nextSmoothCaveFogG, nextSmoothCaveFogB);
if (!any(isnan(_3ogqd0)) && !any(isinf(_3ogqd0)) &&
dot(abs(_3ogqd0), vec3(1.0)) > 0.001) {
smoothCaveFogR = _3ogqd0.r;
smoothCaveFogG = _3ogqd0.g;
smoothCaveFogB = _3ogqd0.b;
}
if (!isnan(nextStoredCaveFogTakeover) && !isinf(nextStoredCaveFogTakeover) &&
nextStoredCaveFogTakeover >= 0.0 && nextStoredCaveFogTakeover <= 1.0) {
storedCaveFogTakeover = nextStoredCaveFogTakeover;
}
}

if (isnan(storedExposure) || isinf(storedExposure) || storedExposure < 0.0 || storedExposure > 1.5) {
storedExposure = 0.0;
}
if (isnan(storedScreenSkylight) || isinf(storedScreenSkylight) || storedScreenSkylight < 0.0 || storedScreenSkylight > 1.0) {
storedScreenSkylight = 1.0;
}
if (isnan(storedAtmoSceneFactor) || isinf(storedAtmoSceneFactor) || storedAtmoSceneFactor < 0.0 || storedAtmoSceneFactor > 1.0) {
storedAtmoSceneFactor = 0.0;
}

nextStoredExposure = storedExposure;
nextStoredScreenSkylight = storedScreenSkylight;
nextStoredAtmoSceneFactor = storedAtmoSceneFactor;
nextSmoothCaveFogR = smoothCaveFogR;
nextSmoothCaveFogG = smoothCaveFogG;
nextSmoothCaveFogB = smoothCaveFogB;
nextStoredCaveFogTakeover = storedCaveFogTakeover;
persistentStateMagic = 1729.25;

_wqwtdy();
memoryBarrierBuffer();
}

#ifdef LPV_ENABLED
int blockId = int(gl_GlobalInvocationID.x + gl_GlobalInvocationID.y * 16u);
if (blockId < 256) {
imageStore(lpvBlockMaskImg, blockId, uvec4(_s7xo9t(blockId), 0u, 0u, 0u));
}
#endif
}
