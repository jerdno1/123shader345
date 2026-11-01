#include "/settings.glsl"
#define VOXY_PROGRAM
#include "/include/water_color.glsl"
#include "/include/glass_reflection_payload.glsl"
#include "/include/voxy_compat.glsl"
#include "/include/ocean_waves.glsl"
#ifdef EMISSIVE_MASKING
#include "/include/emissive_mask.glsl"
#endif

layout(location = 0) out vec4 voxyOut0;
layout(location = 1) out vec4 voxyOut1;
layout(location = 2) out vec4 voxyOut2;
layout(location = 3) out vec4 voxyOut3;
layout(location = 4) out vec4 voxyOut4;

#include "/include/noise.glsl"

vec3 voxy_glass_filter_tint(uint id, vec3 _enloex) {
if (id == 64u) return vec3(1.0, 0.1, 0.1);
if (id == 65u) return vec3(1.0, 0.3, 0.1);
if (id == 66u) return vec3(1.0, 1.0, 0.1);
if (id == 67u) return vec3(1.0, 0.75, 0.5);
if (id == 68u) return vec3(0.3, 1.0, 0.3);
if (id == 69u) return vec3(0.1, 1.0, 0.1);
if (id == 70u) return vec3(0.1, 0.15, 1.0);
if (id == 71u) return vec3(0.5, 0.65, 1.0);
if (id == 72u) return vec3(0.3, 0.8, 1.0);
if (id == 73u) return vec3(0.7, 0.3, 1.0);
if (id == 74u) return vec3(1.0, 0.1, 1.0);
if (id == 75u) return vec3(1.0, 0.4, 1.0);
if (id == 76u) return vec3(0.05);
if (id >= 77u && id <= 79u) return vec3(1.0);
return _enloex;
}

void voxy_emitFragment(VoxyFragmentParameters parameters) {
vec4 _j2crlf = parameters.sampledColour * parameters.tinting;
vec3 _yssmf1 = max(_j2crlf.rgb, vec3(0.0));

float _433mrg = mix(1.0, voxy_face_shade(parameters.face), VOXY_SHADOW_OPACITY);
_yssmf1 *= _433mrg;

float skylight = clamp(parameters.lightMap.y, 0.0, 1.0);
float blocklight = clamp(parameters.lightMap.x, 0.0, 1.0);

uint _6ud75j = parameters.customId;
uint id = voxy_block_id(_6ud75j);
bool isWater = (_6ud75j == 10001u || id == 1u);
bool isIce = (_6ud75j == 10008u || id == 8u);
vec3 _tkgg08 = normalize(voxy_face_normal(parameters.face));

float postMask = isWater ? 0.0 : 1.0;
bool _zq7l8e = (_6ud75j >= 10020u && _6ud75j <= 10031u);
float _0eryme = 0.0;
#ifdef EMISSIVE_MASKING
if (_zq7l8e) {
_0eryme = clamp(_xojoff(int(_6ud75j) - 10020, _j2crlf.rgb), 0.0, 1.0);
}
#else
_0eryme = _zq7l8e ? 1.0 : 0.0;
#endif
bool _7dnqj0 = _0eryme >= 0.05;
float emissive = _7dnqj0 ? 1.0 : 0.0;
float _a8ttn9 = _7dnqj0 ? _0eryme : 0.0;
vec3 _mxcjdz = vec3(0.0);
vec4 _ehp903 = vec4(0.0);
vec4 _a2jf3a = vec4(0.0);

#if defined(VOXY_TILE_BLUR_ENABLED) && !defined(END_SHADER)
vec4 _vx4v2b = voxy_tile_blur(parameters.uv, gl_FragCoord.z);
vec3 _2bhl0x = max((_vx4v2b * parameters.tinting).rgb, vec3(0.0));
float _tjwtha = voxy_tile_blur_strength(gl_FragCoord.z);
#endif

if (isWater) {
vec3 _q3hh7c = _xwb441(sunAngle, 0.0, 0.0, 0.0, 0.0, 0.0);
_ehp903 = vec4(_q3hh7c, 0.3);
_yssmf1 = _gkt4lb(_yssmf1, sunAngle, skylight, blocklight);
_j2crlf.a = clamp(WATER_OPACITY, 0.0, 1.0);

float _gq4u9n = _kup5d9(_tkgg08);
_a2jf3a = vec4(0.5, _gq4u9n, _tkgg08.x * 0.5 + 0.5, _tkgg08.y * 0.5 + 0.5);
} else if (_7dnqj0) {
vec3 _y1qdy4 = voxy_apply_chunk_like_lighting(_yssmf1, sunAngle, skylight, blocklight, float(SEA_LEVEL_OFFSET) + 1.0);
_y1qdy4 = voxy_apply_color_adjust(_y1qdy4);

vec3 _fb7q4s = vec3(1.0);
vec3 _0wf95t = _j2crlf.rgb;
vec3 _m2qcm0 = mix(_fb7q4s, _0wf95t, VOXY_EMISSIVE_COLOR_STRENGTH);
float _u6cxvz = min(EMISSIVE_BRIGHTNESS * VOXY_LOD_BRIGHTNESS, VOXY_EMISSIVE_BRIGHTNESS_CAP);
_yssmf1 = mix(_y1qdy4, _m2qcm0 * _u6cxvz, _a8ttn9);

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

_j2crlf.a = clamp(_j2crlf.a, 0.0, 1.0);
_ehp903 = vec4(voxy_glass_filter_tint(id, clamp(_j2crlf.rgb, vec3(0.0), vec3(1.0))), 0.6);
} else {
_yssmf1 = voxy_apply_chunk_like_lighting(_yssmf1, sunAngle, skylight, blocklight, float(SEA_LEVEL_OFFSET) + 1.0);
_yssmf1 = voxy_apply_color_adjust(_yssmf1);

#if defined(VOXY_TILE_BLUR_ENABLED) && !defined(END_SHADER)
_2bhl0x = voxy_apply_chunk_like_lighting(_2bhl0x, sunAngle, skylight, blocklight, float(SEA_LEVEL_OFFSET) + 1.0);
_2bhl0x = voxy_apply_color_adjust(_2bhl0x);
_yssmf1 = mix(_yssmf1, _2bhl0x, _tjwtha);
#endif

_j2crlf.a = clamp(_j2crlf.a, 0.0, 1.0);
if (isIce) {
_ehp903 = vec4(clamp(_j2crlf.rgb, vec3(0.0), vec3(1.0)), 0.8);
_a2jf3a = vec4(0.0, 0.0, _tkgg08.x * 0.5 + 0.5, _tkgg08.y * 0.5 + 0.5);
} else {
_ehp903 = vec4(voxy_glass_filter_tint(id, clamp(_j2crlf.rgb, vec3(0.0), vec3(1.0))), 0.6);
}
}

voxyOut0 = vec4(_yssmf1, _j2crlf.a);

voxyOut1 = vec4(postMask, _a8ttn9 * VOXY_EMISSIVE_INTENSITY, skylight, 1.0);
voxyOut2 = vec4(_mxcjdz, 1.0);
voxyOut3 = _ehp903;
voxyOut4 = _a2jf3a;
}
