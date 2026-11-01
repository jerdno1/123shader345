/* RENDERTARGETS: 0,1,3 */

#include "/settings.glsl"
#include "/include/hovering.glsl"

uniform float far;
uniform float frameTimeCounter;
uniform int frameCounter;
uniform float sunAngle;
uniform vec3 cameraPosition;
#ifdef LPV_ENABLED
uniform mat4 gbufferModelViewInverse;
#endif
uniform sampler2D depthtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 dhProjectionInverse;
uniform int isEyeInWater;
uniform float biome_swamp;

#ifdef END_SHADER
#ifdef END_EVENT_ENABLED
#include "/include/end_event.glsl"
#endif
#endif

#include "/include/lighting.glsl"
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
#include "/include/shadow.glsl"

#if defined(CLOUDS_2D_ENABLED) && defined(CLOUD_SHADOWS_ENABLED)
#include "/include/cloud_shadow.glsl"
#endif

in vec4 vColor;
in float viewDistance;
in vec3 normal;
in float NdotL;
in vec3 worldPos;
flat in int materialId;
in float skylight;
in float blockLight;
in vec4 shadowPos;

float _4ulefn(vec2 v) {
return fract(52.9829189 * fract(0.06711056 * v.x + 0.00583715 * v.y));
}

#include "/include/noise.glsl"

vec3 _zvazh1(int _57n53d, vec3 _x2q5fe) {
if (_57n53d == DH_BLOCK_LAVA) return vec3(1.0, 0.4, 0.1);
if (_57n53d == DH_BLOCK_ILLUMINATED) {
float _xgal31 = max(max(_x2q5fe.r, _x2q5fe.g), _x2q5fe.b);
if (_xgal31 > 0.01) {
return normalize(_x2q5fe + 0.1) * 1.2;
}
return vec3(1.0, 0.85, 0.6);
}
float _xgal31 = max(max(_x2q5fe.r, _x2q5fe.g), _x2q5fe.b);
if (_xgal31 > 0.01) {
return normalize(_x2q5fe + 0.1) * 1.2;
}
return vec3(1.0, 0.7, 0.4);
}

float _fp23d1(vec3 _1gq9yg, float viewDistance) {
if (_1gq9yg.x < -0.01 || _1gq9yg.x > 1.01 ||
_1gq9yg.y < -0.01 || _1gq9yg.y > 1.01 ||
_1gq9yg.z < -0.01 || _1gq9yg.z > 1.01) {
return 1.0;
}

#if defined(SHARP_SHADOWS) || defined(MAGICAL_TOUCH)
float _vam9d5 = texture(shadowtex1, _1gq9yg.xy).r;
float shadow = step(_1gq9yg.z, _vam9d5);
float _rjtkh7 = 1.0 - _xr26fh(_1gq9yg, viewDistance);
shadow = mix(1.0, shadow, _s4lpf1(_1gq9yg) * _rjtkh7);
return shadow;
#else
float _izh8vx = _h1jpqh(gl_FragCoord.xy, frameCounter);
float r = _55535n(_1gq9yg.xy * 2.0 - 1.0);
float _w02w60 = r + SHADOW_DISTORTION;
return _x245zo(shadowtex1, _1gq9yg, _w02w60, viewDistance, _izh8vx);
#endif
}

void main() {
vec4 _yssmf1 = vColor;
vec3 _6vg746 = vColor.rgb;
#ifdef LPV_ENABLED
_pis44d = _6vg746;
_06143i = dot(_6vg746, vec3(0.299, 0.587, 0.114));
#endif

float _lo76hz = max(max(_6vg746.r, _6vg746.g), _6vg746.b);

bool _7dnqj0 = (materialId == DH_BLOCK_ILLUMINATED) ||
(materialId == DH_BLOCK_LAVA);
float emissive = _7dnqj0 ? 1.0 : 0.0;

float darknessFactor = 1.0;

float _huatah = fract(sunAngle);
float _p6xjdc = getTimeWeightsSimple(sunAngle).day;
float _x6kfbh = max(far - DH_OVERDRAW_DISTANCE - DH_OVERDRAW_FADE_LENGTH, 0.0);
float _ryay9f = max(far - DH_OVERDRAW_DISTANCE, 0.0);
float _a4b06l = smoothstep(_x6kfbh, _ryay9f, viewDistance);

if (_a4b06l > 0.001 && _a4b06l < 0.999) {
ivec2 _04ivny = ivec2(gl_FragCoord.xy);
float dC = texelFetch(depthtex0, _04ivny, 0).r;
if (dC < 0.9999) {
float dR = texelFetch(depthtex0, _04ivny + ivec2(1, 0), 0).r;
float dL = texelFetch(depthtex0, _04ivny + ivec2(-1, 0), 0).r;
float dU = texelFetch(depthtex0, _04ivny + ivec2(0, -1), 0).r;
float dD = texelFetch(depthtex0, _04ivny + ivec2(0, 1), 0).r;

float _0d529s = 0.0;
_0d529s += step(dC, 0.9999);
_0d529s += step(dR, 0.9999);
_0d529s += step(dL, 0.9999);
_0d529s += step(dU, 0.9999);
_0d529s += step(dD, 0.9999);

float _49fghg = max(max(abs(dC - dR), abs(dC - dL)), max(abs(dC - dU), abs(dC - dD)));
bool _r00odd = (_0d529s >= 4.5) && (_49fghg < 0.0030);

if (_r00odd) {
vec2 _9zsy4a = vec2(textureSize(depthtex0, 0));
vec2 uv = (gl_FragCoord.xy + vec2(0.5)) / _9zsy4a;

vec4 _usua05 = vec4(uv * 2.0 - 1.0, dC * 2.0 - 1.0, 1.0);
vec4 _8yhvc8 = gbufferProjectionInverse * _usua05;
float _qkxesy = -_8yhvc8.z / _8yhvc8.w;

vec4 _n80w6r = vec4(uv * 2.0 - 1.0, gl_FragCoord.z * 2.0 - 1.0, 1.0);
vec4 _yyg0xc = dhProjectionInverse * _n80w6r;
float _mwgi1p = -_yyg0xc.z / _yyg0xc.w;

if (_qkxesy + 0.10 < _mwgi1p) {
discard;
}
}
}
}

float shadow = 1.0;
float _621xrq = 0.0;
#ifdef SHADOWS_ENABLED
if (_p6xjdc > 0.1 && skylight > 0.05 && !_7dnqj0) {
float _if90p5 = shadowPos.w;
bool _sn7wi8 = _if90p5 < 0.001;
float _5jah4i = 1.0;

if (_sn7wi8) {
shadow = mix(1.0, 0.6, DH_SHADOW_OPACITY * _5jah4i);
} else {
shadow = _fp23d1(shadowPos.xyz, viewDistance);
}

_621xrq = shadow;

shadow = mix(1.0, shadow, skylight);
shadow = mix(1.0, shadow, DH_SHADOW_OPACITY);
}
#endif

#if defined(CLOUDS_2D_ENABLED) && defined(CLOUD_SHADOWS_ENABLED)
if (_p6xjdc > 0.1 && !_7dnqj0) {
float _80do1j = _ddtj35(worldPos, frameTimeCounter);
shadow *= _80do1j;
}
#endif

shadow = mix(shadow, 1.0, _a4b06l);

TimeWeightsSimple dhTS = getTimeWeightsSimple(sunAngle);
float _ywrw46 = dhTS.twilight;
float _euof5w = mix(1.0, 0.82, _ywrw46);

if (!_7dnqj0) {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _iroce3(_yssmf1.rgb, sunAngle, skylight, blockLight, 0.0, shadow, worldPos.y);
#ifdef HANDHELD_LIGHT_ENABLED
_yssmf1.rgb += _6p2kch(worldPos, _6vg746, _yssmf1.rgb);
#endif

_yssmf1.rgb *= darknessFactor;
_yssmf1.rgb *= _euof5w;
}

if (!_7dnqj0) {
_yssmf1.rgb *= TERRAIN_BRIGHTNESS * DH_BRIGHTNESS;

if (materialId == DH_BLOCK_GRASS) {
_yssmf1.rgb *= DH_GRASS_BRIGHTNESS;
} else if (materialId == DH_BLOCK_LEAVES) {
_yssmf1.rgb *= DH_LEAF_BRIGHTNESS;
}

_yssmf1.rgb = (_yssmf1.rgb - 0.5) * DH_CONTRAST + 0.5;
_yssmf1.rgb = max(_yssmf1.rgb, vec3(0.0));

float _meft1i = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
_yssmf1.rgb = mix(vec3(_meft1i), _yssmf1.rgb, DH_SATURATION);

#ifdef END_SHADER
{

#ifdef END_TERRAIN_PATCHES_ENABLED
{
float _lvo52d = max(normal.y, 0.0);
if (_lvo52d > 0.3) {
vec2 _3yeyai = worldPos.xz * END_TERRAIN_PATCH_SCALE;
float pn = 0.0;
float _9imorn = 0.6;
for (int _hiq5ip = 0; _hiq5ip < 3; _hiq5ip++) {
vec2 ip = floor(_3yeyai);
vec2 fp = fract(_3yeyai);
fp = fp * fp * (3.0 - 2.0 * fp);
float a = fract(sin(dot(ip, vec2(127.1, 311.7))) * 43758.5453);
float b = fract(sin(dot(ip + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
float c = fract(sin(dot(ip + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
float d = fract(sin(dot(ip + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
pn += mix(mix(a, b, fp.x), mix(c, d, fp.x), fp.y) * _9imorn;
_3yeyai *= 2.3;
_9imorn *= 0.45;
}
float _u52tde = smoothstep(0.25, 0.55, pn);
_u52tde = mix(1.0, 1.0 - END_TERRAIN_PATCH_STRENGTH, 1.0 - _u52tde);
_yssmf1.rgb *= mix(1.0, _u52tde, _lvo52d);
}
}
#endif

float _prieqz = 0.55;
float _38u9c7 = 0.15;
float _yg5pwl = 0.55;

float _wodr3w = 0.0;
vec3 _5fkwe3 = vec3(0.0);

#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
float _87650a = _u746aw(frameTimeCounter);
if (_87650a > 0.001) {

float _2pv68z = _171d84(blockLight, skylight);
vec3 _wzl9xk = vec3(END_BLOCKLIGHT_R, END_BLOCKLIGHT_G, END_BLOCKLIGHT_B);
_5fkwe3 = _6vg746 * _wzl9xk * _2pv68z * _2pv68z * END_BLOCKLIGHT_BRIGHTNESS * TERRAIN_BRIGHTNESS * DH_BRIGHTNESS;

#ifdef HANDHELD_LIGHT_ENABLED
_5fkwe3 += _6p2kch(worldPos, _6vg746, vec3(0.0)) * TERRAIN_BRIGHTNESS * DH_BRIGHTNESS;
#endif

_wodr3w = _87650a;
}
_prieqz = mix(_prieqz, 0.02, _87650a);
_38u9c7 = mix(_38u9c7, 0.0, _87650a);
_yg5pwl = mix(_yg5pwl, 0.0, _87650a);
#endif

_yssmf1.rgb *= _prieqz;
vec3 _99621u = vec3(0.08, 0.06, 0.35);
_yssmf1.rgb += _99621u * _38u9c7;
_yssmf1.rgb = mix(_yssmf1.rgb, _yssmf1.rgb * vec3(0.55, 0.58, 1.35), _yg5pwl);

_yssmf1.rgb += _5fkwe3 * _wodr3w;
}
#endif
}

if (_7dnqj0) {
vec3 _fb7q4s = vec3(1.0);
vec3 _0wf95t = _6vg746;
vec3 _m2qcm0 = mix(_fb7q4s, _0wf95t, DH_EMISSIVE_COLOR_STRENGTH);
float _u6cxvz = min(EMISSIVE_BRIGHTNESS * DH_BRIGHTNESS, DH_EMISSIVE_BRIGHTNESS_CAP);
#ifdef END_SHADER
_u6cxvz *= END_EMISSIVE_BOOST;
#endif
_yssmf1.rgb = _m2qcm0 * _u6cxvz;
}

#ifdef DH_EMISSIVE_DEBUG
if (_7dnqj0) {
_yssmf1.rgb = vec3(1.0);
}
#endif

float _izh8vx = _4ulefn(gl_FragCoord.xy + float(frameCounter));

if (_a4b06l < 0.999) {
float _025mu8 = _a4b06l;
float _zekzgg = SEA_LEVEL_OFFSET - 96.0;
float _q73t75 = SEA_LEVEL_OFFSET + 320.0;

float _q4j75g = _cks7vw(worldPos.xz * 0.12);
float _j5jye0 = (_q4j75g - 0.5) * 10.0;
float _go7jgh = mix(_zekzgg, _q73t75, _025mu8) + _j5jye0;
float _fxiwh2 = 1.0 - smoothstep(_go7jgh - 8.0, _go7jgh + 8.0, worldPos.y);
_yssmf1.rgb *= mix(0.60, 1.0, _fxiwh2);
if (_fxiwh2 < 0.02 || (_izh8vx > _a4b06l && _a4b06l < 0.05)) {
discard;
}
}

#ifndef END_SHADER
#ifndef NETHER_SHADER
if (isEyeInWater == 1) {
if (worldPos.y < float(SEA_LEVEL_OFFSET)) {
float _g15x9y = (float(SEA_LEVEL_OFFSET) - worldPos.y) / 24.0;
_g15x9y = clamp(_g15x9y, 0.0, 1.0);
vec3 _bue6b6 = vec3(0.08, 0.22, 0.35);
_yssmf1.rgb = mix(_yssmf1.rgb, _bue6b6, _g15x9y * 0.85);
}
}
#endif
#endif

gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(1.0, emissive * DH_EMISSIVE_INTENSITY, skylight, 0.0);
vec3 _mxcjdz = vec3(0.0);
if (_7dnqj0) {
_mxcjdz = _zvazh1(materialId, vColor.rgb) * DH_EMISSIVE_INTENSITY;
}
gl_FragData[2] = vec4(_mxcjdz, 1.0);
}
