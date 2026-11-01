/* RENDERTARGETS: 7,1,3,4,5 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/hovering.glsl"
#include "/include/water_color.glsl"
#include "/include/ocean_waves.glsl"
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform mat4 gbufferProjectionInverse;
uniform mat4 dhProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;
uniform float far;
uniform float frameTimeCounter;
uniform int frameCounter;
uniform float sunAngle;
uniform int isEyeInWater;
uniform float biome_swamp;
uniform int biome_category;
uniform vec3 fogColor;
uniform vec3 cameraPosition;

#include "/include/lighting.glsl"

in vec4 vColor;
in float viewDistance;
in vec3 viewPos;
in vec3 worldPos;
in vec3 normal;
in float skylight;
in float blocklight;
in float waveHeight;
in vec3 waveNormal;
flat in int materialId;

vec3 _r9f3ot(vec3 _ko2kdp) {
return _ko2kdp;
}

vec3 _ddui6s() {
return vec3(0.0, 1.0, 0.0);
}

float _4ulefn(vec2 v) {
return fract(52.9829189 * fract(0.06711056 * v.x + 0.00583715 * v.y));
}

#include "/include/noise.glsl"

void main() {
vec4 _yssmf1 = vColor;

bool isWater = (materialId == DH_BLOCK_WATER);

float _lfojrz = clamp(biome_swamp, 0.0, 1.0);

if (isWater && isEyeInWater == 1) {
discard;
}
if (isWater) {
_yssmf1.rgb = _gkt4lb(_yssmf1.rgb, sunAngle, skylight, blocklight);

_yssmf1.rgb *= WATER_DH_BRIGHTNESS;
float _1rt1nb = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
_yssmf1.rgb = mix(vec3(_1rt1nb), _yssmf1.rgb, WATER_DH_SATURATION);
_yssmf1.rgb = max(_yssmf1.rgb, vec3(0.0));
} else {

_yssmf1.rgb *= DH_BRIGHTNESS;
}

ivec2 _04ivny = ivec2(gl_FragCoord.xy);
float _0j88mv = texelFetch(depthtex0, _04ivny, 0).r;
float _sy7c6j = texelFetch(depthtex1, _04ivny, 0).r;
if (isWater) {

if (_0j88mv < 1.0) {
discard;
}
} else {

if (_sy7c6j < 1.0) {
vec2 _9zsy4a = vec2(textureSize(depthtex1, 0));
vec2 uv = (gl_FragCoord.xy + vec2(0.5)) / _9zsy4a;

vec4 _usua05 = vec4(uv * 2.0 - 1.0, _sy7c6j * 2.0 - 1.0, 1.0);
vec4 _8yhvc8 = gbufferProjectionInverse * _usua05;
float _qkxesy = -_8yhvc8.z / _8yhvc8.w;

vec4 _n80w6r = vec4(uv * 2.0 - 1.0, gl_FragCoord.z * 2.0 - 1.0, 1.0);
vec4 _yyg0xc = dhProjectionInverse * _n80w6r;
float _mwgi1p = -_yyg0xc.z / _yyg0xc.w;

if (_qkxesy + 1e-4 < _mwgi1p) {
discard;
}
}
}

if (!isWater) {
float _x6kfbh = max(far - DH_OVERDRAW_DISTANCE - DH_OVERDRAW_FADE_LENGTH, 0.0);
float _ryay9f = max(far - DH_OVERDRAW_DISTANCE, 0.0);
float _a67ol6 = smoothstep(_x6kfbh, _ryay9f, viewDistance);
float _izh8vx = _4ulefn(gl_FragCoord.xy + float(frameCounter));
if (_izh8vx > _a67ol6) {
discard;
}
}

float emissive = 0.0;
vec3 _mxcjdz = vec3(0.0);

vec3 _2mnfz1 = vColor.rgb;
float _6qwad8 = max(max(_2mnfz1.r, _2mnfz1.g), _2mnfz1.b);
float _aslobc = min(min(_2mnfz1.r, _2mnfz1.g), _2mnfz1.b);
float _zj0avb = (_6qwad8 > 0.01) ? (_6qwad8 - _aslobc) / _6qwad8 : 0.0;
bool _xrk8sx = (_2mnfz1.b > _2mnfz1.r * 1.2) && (_2mnfz1.b > _2mnfz1.g * 1.1) && (_6qwad8 > 0.4) && (_zj0avb < 0.45);

bool _t9u3ji = false;
bool _n5tvnf = !isWater && !_xrk8sx;

if (_xrk8sx) {
_yssmf1.rgb = _gkt4lb(_yssmf1.rgb, sunAngle);
}

if (_n5tvnf) {

vec3 _ehcpnr = vColor.rgb;
float _xgal31 = dot(_ehcpnr, vec3(0.299, 0.587, 0.114));
vec3 _tivi05 = mix(vec3(_xgal31), _ehcpnr, 3.0);
_tivi05 = max(_tivi05, vec3(0.0));
float _pcpnki = max(max(_tivi05.r, _tivi05.g), _tivi05.b);
if (_pcpnki > 0.01) {
_tivi05 = _tivi05 / _pcpnki * max(_xgal31 * 2.0, 0.4);
} else {
_tivi05 = vec3(0.4, 0.6, 0.8);
}
_yssmf1.rgb = _gkt4lb(_tivi05, sunAngle);
_yssmf1.a = max(_yssmf1.a, 0.5);
}

if (isWater) {

_yssmf1.a = clamp(WATER_OPACITY * 0.85, 0.0, 1.0);
}

if (isWater && _lfojrz > 0.01 && isEyeInWater != 1) {
float st = frameTimeCounter;

float _wksarx = _cks7vw(worldPos.xz * 0.15 + vec2(st * 0.08, -st * 0.06));
float _pxe7rs = _cks7vw(worldPos.xz * 0.15 + vec2(-st * 0.07, st * 0.09) + vec2(13.5, -8.2));
vec2 _zt1tk0 = (vec2(_wksarx, _pxe7rs) - 0.5) * 1.8;
vec2 _9z4r2s = worldPos.xz + _zt1tk0;
float _6mj3b7 = _cks7vw(_9z4r2s * 0.35 + vec2(st * 0.10, -st * 0.08));
float _6hf4pm = _cks7vw(_9z4r2s * 0.7 + vec2(-st * 0.12, st * 0.11) + vec2(7.3, -4.1));
float _8536of = _cks7vw(_9z4r2s * 1.4 + vec2(st * 0.06, st * 0.14) + vec2(-3.5, 9.2));
float _qp0qrf = _6mj3b7 * 0.5 + _6hf4pm * 0.35 + _8536of * 0.15;
float _1ullzn = smoothstep(0.55, 0.70, _qp0qrf);
vec3 _4bremb = vec3(0.03, 0.02, 0.01);
_yssmf1.rgb = mix(_yssmf1.rgb, _4bremb, _1ullzn * 0.8 * _lfojrz);
_yssmf1.a = mix(_yssmf1.a, 1.0, _1ullzn * 0.8 * _lfojrz);

}

float postMask = isWater ? 0.0 : 1.0;
gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(postMask, emissive, skylight, 0.0);
gl_FragData[2] = vec4(_mxcjdz, 1.0);

if (isWater) {
vec3 _0uom9c = _xwb441(sunAngle, 1.0, _lfojrz, 0.0, 0.0, 0.0);
gl_FragData[3] = vec4(_0uom9c, 0.3);
} else if (_n5tvnf) {
float _kytein = 0.6;
gl_FragData[3] = vec4(vColor.rgb, _kytein);
} else {
gl_FragData[3] = vec4(0.0);
}

if (isWater) {
gl_FragData[4] = vec4(0.5, 1.0, 0.5, 1.0);
} else {
gl_FragData[4] = vec4(0.0);
}
}
