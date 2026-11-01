#include "/settings.glsl"
#define VOXY_PROGRAM
#define VOXY_HAS_SSBO

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
};

#include "/include/voxy_compat.glsl"
#include "/include/noise.glsl"
#include "/include/caztoon_grass_patches.glsl"
#include "/include/lava_crust.glsl"
#include "/include/biome_overrides.glsl"
#ifdef EMISSIVE_MASKING
#include "/include/emissive_mask.glsl"
#endif

vec3 voxy_grass_fallback_tint(int b) {
if (_qn96wa(b))  return vec3(0.41, 0.43, 0.22);
if (_d35992(b))  return vec3(0.36, 0.75, 0.18);
if (_lgo6lt(b)) return vec3(0.71, 0.73, 0.34);
if (_1a4dso(b))  return vec3(0.75, 0.70, 0.33);
if (_kuwebx(b))   return vec3(0.50, 0.65, 0.45);
return vec3(0.49, 0.73, 0.33);
}

layout(location = 0) out vec4 voxyOut0;
layout(location = 1) out vec4 voxyOut1;
layout(location = 2) out vec4 voxyOut2;

void voxy_emitFragment(VoxyFragmentParameters parameters) {
uint _6ud75j = parameters.customId;
uint id = voxy_block_id(_6ud75j);
bool _bxsvfq = _cnabfq(int(_6ud75j)) || (id >= 121u && id <= 128u);
bool _mumhki = (id == 201u);

vec4 _j2crlf;
vec3 _oxj0dp;
if (id == 15u && parameters.face >= 2u) {
_oxj0dp = voxy_grass_fallback_tint(biome);
} else {
_oxj0dp = parameters.tinting.rgb;
}
float _onbgtf = max(max(_oxj0dp.r, _oxj0dp.g), _oxj0dp.b);
vec3 _qxf9fz = (_onbgtf > 0.001) ? _oxj0dp / _onbgtf : _oxj0dp;
_j2crlf = vec4(parameters.sampledColour.rgb * _qxf9fz, parameters.sampledColour.a);
vec3 _yssmf1 = max(_j2crlf.rgb, vec3(0.0));

#ifdef VOXY_DEBUG_BRIGHTNESS_MATCH
vec3 _m74tud = _yssmf1;
#endif

if (_6ud75j == 10060u || _6ud75j == 10061u || _6ud75j == 10062u) discard;

vec2 voxyScreenUV = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
vec3 voxyNdc = vec3(voxyScreenUV, gl_FragCoord.z) * 2.0 - 1.0;
vec4 voxyViewH = vxProjInv * vec4(voxyNdc, 1.0);
vec3 voxyViewPos = voxyViewH.xyz / voxyViewH.w;
vec3 voxyWorldPos = (gbufferModelViewInverse * vec4(voxyViewPos, 1.0)).xyz + cameraPosition;
vec3 _sotb5w = voxy_face_normal(parameters.face);
_yssmf1 = _rsw7nt(_yssmf1, voxyWorldPos, _sotb5w, int(_6ud75j), frameTimeCounter);
float voxyUnderwaterDepthMask = 0.0;
if (isEyeInWater == 1) {
voxyUnderwaterDepthMask = 1.0 - smoothstep(float(SEA_LEVEL_OFFSET) - 2.0, float(SEA_LEVEL_OFFSET) + 1.0, voxyWorldPos.y);
}

float _i178g3 = clamp(parameters.lightMap.y, 0.0, 1.0);
bool _nwi2vw = (_i178g3 < 2.0 / 15.0);

bool _ma07r8 = _bxsvfq || _mumhki || (id == 2u || id == 5u || id == 18u || id == 19u || id == 81u || id == 82u);
float _hg321h = 1.0;
#ifdef SHADOWS_ENABLED
if (!_ma07r8) {
vec3 _2t6j51 = voxy_face_normal(parameters.face);
vec3 _oe9g96 = normalize(mat3(gbufferModelViewInverse) * normalize(shadowLightPosition));
float voxyLightDot = dot(_2t6j51, _oe9g96);

float _6obksq = 1.0 - smoothstep(0.02, 0.30, voxyLightDot);
float _zd5beo = 1.0 - _6obksq;

_zd5beo = mix(1.0, _zd5beo, _i178g3);
_hg321h = mix(1.0, _zd5beo, clamp(SHADOW_OPACITY * VOXY_SHADOW_OPACITY, 0.0, 1.0));
}
#endif

#ifdef MAGICAL_TOUCH
float _6p8x1i = 1.0 - smoothstep(0.0, 2.0 / 15.0, _i178g3);
#else
float _6p8x1i = 1.0;
#endif
if (_bxsvfq || _mumhki) _6p8x1i = 0.0;
float _433mrg = mix(1.0, voxy_face_shade(parameters.face), _6p8x1i * clamp(VOXY_SHADOW_OPACITY, 0.0, 1.0));

float skylight = clamp(parameters.lightMap.y, 0.0, 1.0);

if (isEyeInWater == 1) {
skylight = max(skylight, (1.0 / 15.0) * voxyUnderwaterDepthMask);
}

float blocklight = clamp(parameters.lightMap.x, 0.0, 1.0);

bool _pa9b1t = (_6ud75j == 10039u || id == 39u);

bool _vfk6t9 = (id == 46u || id == 56u || id == 57u);
bool _zq7l8e = (id >= 20u && id <= 59u) && !_vfk6t9;
float _0eryme = 0.0;
#ifdef EMISSIVE_MASKING
if (_zq7l8e) {
_0eryme = clamp(_xojoff(int(id) - 20, _j2crlf.rgb), 0.0, 1.0);
}
#else
_0eryme = _zq7l8e ? 1.0 : 0.0;
#endif
bool _7dnqj0 = _0eryme >= 0.05;
float emissive = _7dnqj0 ? 1.0 : 0.0;
float _a8ttn9 = _7dnqj0 ? _0eryme : 0.0;
vec3 _mxcjdz = vec3(0.0);

#if defined(VOXY_TILE_BLUR_ENABLED) && !defined(END_SHADER)

vec4 _vx4v2b = voxy_tile_blur(parameters.uv, gl_FragCoord.z);
vec3 _2bhl0x = max((_vx4v2b * parameters.tinting).rgb, vec3(0.0));
_2bhl0x = _rsw7nt(_2bhl0x, voxyWorldPos, _sotb5w, int(_6ud75j), frameTimeCounter);
float _tjwtha = voxy_tile_blur_strength(gl_FragCoord.z);
#endif

if (!_7dnqj0) {
_yssmf1 = voxy_apply_chunk_transition_lighting(_yssmf1, sunAngle, skylight, blocklight, voxyWorldPos.y, _hg321h);

#if defined(VOXY_TILE_BLUR_ENABLED) && !defined(END_SHADER)
_2bhl0x = voxy_apply_chunk_transition_lighting(_2bhl0x, sunAngle, skylight, blocklight, voxyWorldPos.y, _hg321h);
#endif

} else {
vec3 _y1qdy4 = voxy_apply_chunk_transition_lighting(_yssmf1, sunAngle, skylight, blocklight, voxyWorldPos.y, _hg321h);
#if defined(VOXY_TILE_BLUR_ENABLED) && !defined(END_SHADER)
_2bhl0x = voxy_apply_chunk_transition_lighting(_2bhl0x, sunAngle, skylight, blocklight, voxyWorldPos.y, _hg321h);
#endif

vec3 _fb7q4s = vec3(1.0);
vec3 _0wf95t = _j2crlf.rgb;
vec3 _m2qcm0 = mix(_fb7q4s, _0wf95t, VOXY_EMISSIVE_COLOR_STRENGTH);
if (_pa9b1t) {

_yssmf1 = _j2crlf.rgb * EMISSIVE_BRIGHTNESS;
} else {
float _u6cxvz = min(EMISSIVE_BRIGHTNESS * VOXY_LOD_BRIGHTNESS, VOXY_EMISSIVE_BRIGHTNESS_CAP);
_yssmf1 = mix(_y1qdy4, _m2qcm0 * _u6cxvz, _a8ttn9);
}

if (_6ud75j == 10022u) {
_mxcjdz = vec3(1.0, 0.4, 0.1);
} else {
float _xgal31 = max(max(_j2crlf.r, _j2crlf.g), _j2crlf.b);
if (_xgal31 > 0.01) {
_mxcjdz = normalize(_j2crlf.rgb + 0.1) * 1.2;
} else {
_mxcjdz = vec3(1.0, 0.85, 0.6);
}
}
_mxcjdz *= VOXY_EMISSIVE_INTENSITY * _a8ttn9;

}

#if defined(VOXY_TILE_BLUR_ENABLED) && !defined(END_SHADER)
if (!_pa9b1t) _yssmf1 = mix(_yssmf1, _2bhl0x, _tjwtha);
#endif

#ifdef LAVA_CRUST_ENABLED
if (_pa9b1t) {
vec3 voxyN = voxy_face_normal(parameters.face);
_yssmf1 = _rmzct0(_yssmf1, voxyWorldPos, voxyN);

#ifdef BIOME_SOUL_SAND_VALLEY
if (biome == BIOME_SOUL_SAND_VALLEY) {
float _gwkmfw = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _zc8eu3 = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _gwkmfw * 2.0;
_yssmf1 = _zc8eu3;
}
#endif
}
#endif

#if defined(END_SHADER) && defined(END_TERRAIN_PATCHES_ENABLED)
if (!_7dnqj0) {
vec3 _irms09 = voxyWorldPos * END_TERRAIN_PATCH_SCALE;
float pn = 0.0;
float _9imorn = 0.6;
for (int _hiq5ip = 0; _hiq5ip < 3; _hiq5ip++) {
vec3 ip = floor(_irms09);
vec3 fp = fract(_irms09);
fp = fp * fp * (3.0 - 2.0 * fp);
float a = fract(sin(dot(ip, vec3(127.1, 311.7, 74.7))) * 43758.5453);
float b = fract(sin(dot(ip + vec3(1,0,0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float c = fract(sin(dot(ip + vec3(0,1,0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float d = fract(sin(dot(ip + vec3(1,1,0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float e = fract(sin(dot(ip + vec3(0,0,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float f = fract(sin(dot(ip + vec3(1,0,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float g = fract(sin(dot(ip + vec3(0,1,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float h = fract(sin(dot(ip + vec3(1,1,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float z0 = mix(mix(a, b, fp.x), mix(c, d, fp.x), fp.y);
float z1 = mix(mix(e, f, fp.x), mix(g, h, fp.x), fp.y);
pn += mix(z0, z1, fp.z) * _9imorn;
_irms09 *= 2.3;
_9imorn *= 0.45;
}
float _u52tde = smoothstep(0.25, 0.55, pn);
_u52tde = mix(1.0, 1.0 - END_TERRAIN_PATCH_STRENGTH, 1.0 - _u52tde);
_yssmf1 *= _u52tde;
}
#endif

if (!_7dnqj0) {
_yssmf1 *= _433mrg;
}

{
bool _716lzj = (_6ud75j == 10040u || id == 40u);

bool _pbkv4z = (smoothNetherFogB > smoothNetherFogR * 1.5);
if ((_pa9b1t || _716lzj) && _pbkv4z) {
float _m6b5e7 = dot(_mxcjdz, vec3(0.299, 0.587, 0.114));
_mxcjdz = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _m6b5e7 * 2.0;

if (_716lzj) {
float _ctu159 = max(_yssmf1.r - _yssmf1.b, 0.0);
float _gp1k8o = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _h8kwmc = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _gp1k8o * 2.0;
_yssmf1 = mix(_yssmf1, _h8kwmc, smoothstep(0.05, 0.2, _ctu159));
}
}
}

#ifdef VOXY_DEBUG_BRIGHTNESS_MATCH
{
float _ieqz48 = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1 = vec3(_ieqz48);
}
#endif

voxyOut0 = vec4(_yssmf1, 1.0);

voxyOut1 = vec4(voxy_pack_shadow_baseline(_hg321h), emissive, skylight, 1.0);
voxyOut2 = vec4(_mxcjdz, 1.0);
}
