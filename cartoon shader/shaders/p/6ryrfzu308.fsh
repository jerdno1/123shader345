#include "/settings.glsl"

/* RENDERTARGETS: 9 */

#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED) || defined(CAVE_FOG_ENABLED)

#include "/include/shadow.glsl"
#include "/include/biome_overrides.glsl"

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

#define BIOME_COLOR_SMOOTHING_HAS_SSBO
#include "/include/biome_color_smoothing.glsl"

in vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex5;
uniform sampler2D colortex9;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor1;
uniform sampler2D dhDepthTex;
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 dhProjectionInverse;
uniform mat4 vxProjInv;
uniform sampler2D vxDepthTexTrans;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform vec3 shadowLightPosition;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float sunAngle;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float dhNearPlane;
uniform float dhFarPlane;
uniform float rainStrength;
uniform float frameTimeCounter;
uniform int frameCounter;
uniform int biome;
uniform int biome_category;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_savanna;
uniform float biome_beach;
uniform float biome_ocean;
uniform int isEyeInWater;

#ifdef LPV_ENABLED
#include "/include/lpv/lpv_common.glsl"
uniform sampler3D lpvLightSamplerA;
uniform sampler3D lpvLightSamplerB;
uniform usampler3D lpvVoxelSampler;

vec3 _6l00a6(vec3 uv) {
return (frameCounter & 1) == 0 ? textureLod(lpvLightSamplerA, uv, 0.0).rgb : textureLod(lpvLightSamplerB, uv, 0.0).rgb;
}
vec3 _be02gn(vec3 uv) {
vec3 _xibcy1 = 1.0 / _fsho2m;
vec3 _idhca6 = _6l00a6(uv) * 2.0;
_idhca6 += _6l00a6(clamp(uv + vec3(_xibcy1.x, 0.0, 0.0), vec3(0.0), vec3(1.0)));
_idhca6 += _6l00a6(clamp(uv - vec3(_xibcy1.x, 0.0, 0.0), vec3(0.0), vec3(1.0)));
_idhca6 += _6l00a6(clamp(uv + vec3(0.0, _xibcy1.y, 0.0), vec3(0.0), vec3(1.0)));
_idhca6 += _6l00a6(clamp(uv - vec3(0.0, _xibcy1.y, 0.0), vec3(0.0), vec3(1.0)));
return _idhca6 / 6.0;
}

float _9zsl11(vec3 _aurzx6) {
return 1.0 - smoothstep(0.0040, 0.0140, _4fp51a(_aurzx6));
}

float _b7swkf(vec3 _m66wgm) {
ivec3 _767rm9 = _y5lpmz(_m66wgm);
float _lqzrs2 = 0.0;

for (int z = -1; z <= 1; z++) {
for (int y = -1; y <= 1; y++) {
for (int x = -1; x <= 1; x++) {
ivec3 _xibcy1 = clamp(_767rm9 + ivec3(x, y, z), ivec3(0), _s41vj8 - ivec3(1));
int blockId = int(texelFetch(lpvVoxelSampler, _xibcy1, 0).r) - 1;
float _7hk8wy = _4fp51a(_d56v3m(blockId));
if (_7hk8wy > 0.001) {
float _t25r5m = length((vec3(_xibcy1) + vec3(0.5)) - _m66wgm);
float _nuzj0s = 1.0 - smoothstep(0.30, 1.45, _t25r5m);
_nuzj0s = pow(_nuzj0s, 0.45);
float _9q1spd = smoothstep(0.02, 0.20, _7hk8wy);
_lqzrs2 = max(_lqzrs2, _nuzj0s * _9q1spd);
}
}
}
}

return _lqzrs2;
}
#endif
uniform ivec2 eyeBrightnessSmooth;

#include "/include/noise.glsl"
#include "/include/sky_timeline.glsl"

float _m65fhj(vec3 _gpy6je) {
float n = _lpglwu(_gpy6je);
n += 0.50 * _lpglwu(_gpy6je * 1.97);
n /= 1.50;
return n;
}

float _sitw5c(vec3 _gpy6je) {
float _uck2jh = _lpglwu(_gpy6je * 0.55);
float _za3y2e = _lpglwu(_gpy6je * 1.10);
float n = mix(_uck2jh, _za3y2e, 0.18);
return smoothstep(0.08, 0.92, n);
}

float _mu5zr1(vec3 worldPos) {
vec3 p = worldPos * 0.050;
float n = _m65fhj(p);
float _w9iaxp = smoothstep(0.20, 0.78, n);
return mix(0.35, 1.15, _w9iaxp);
}

#ifdef SHADOWS_ENABLED
float _uz23jg(vec3 worldPos, float _dme3tq) {
if (_dme3tq <= 0.001) return 0.0;

vec3 _h4gwes = worldPos - cameraPosition;
vec4 _kffjyx = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _w1ppkd = _2y5umb(_kffjyx.xyz);
vec3 _i1hwjb = _w1ppkd * 0.5 + 0.5;
_i1hwjb.z -= 0.001;

vec2 _eu3q17 = min(_i1hwjb.xy, 1.0 - _i1hwjb.xy);
float _a9osj3 = smoothstep(0.0, 0.05, min(_eu3q17.x, _eu3q17.y));

if (_i1hwjb.x <= 0.0 || _i1hwjb.x >= 1.0 ||
_i1hwjb.y <= 0.0 || _i1hwjb.y >= 1.0 ||
_i1hwjb.z <= 0.0 || _i1hwjb.z >= 1.0 ||
_a9osj3 <= 0.001) {
return 0.0;
}

float _rvunrw = step(_i1hwjb.z, textureLod(shadowtex1, _i1hwjb.xy, 0.0).r);
return _rvunrw * _a9osj3 * _dme3tq;
}
#endif

#include "/include/depth_utils.glsl"

void main() {

vec2 _duy16z = (floor(gl_FragCoord.xy) / FOG_RENDER_SCALE + 0.5) / vec2(viewWidth, viewHeight);
#define texcoord _duy16z

vec4 _my8b76 = vec4(0.0);

if (isEyeInWater == 2) {
gl_FragData[0] = vec4(0.0);
return;
}

if (_9cwhip(biome)) {
gl_FragData[0] = vec4(0.0);
return;
}
#ifdef END_SHADER
gl_FragData[0] = vec4(0.0);
return;
#else
#ifdef CAT_THE_END
if (biome_category == CAT_THE_END) {
gl_FragData[0] = vec4(0.0);
return;
}
#endif
#endif

#ifdef UNDERWATER_FOG_ENABLED
if (isEyeInWater == 1) {

float _f9ellg = min(texture(depthtex0, texcoord).r, texture(depthtex1, texcoord).r);
float _iflag7;
vec3 _yrhjqj;
bool _myh47e = false;

vec3 _u7wtla;
bool _gm3g15 = _7bqo1l(_f9ellg) && _cwcjr4(
gbufferProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _f9ellg, _u7wtla);

if (_gm3g15) {
_yrhjqj = _lcgfcm(_u7wtla - cameraPosition, vec3(0.0, 0.0, -1.0));
_iflag7 = length(_u7wtla - cameraPosition);

float _sxalry = float(SEA_LEVEL_OFFSET) - 0.125;
if (_u7wtla.y > _sxalry - 0.5) {
_myh47e = true;

float _4up3ns = max(_sxalry - cameraPosition.y, 0.1);
float _ow2qx3 = max(_yrhjqj.y, 0.01);
_iflag7 = min(_iflag7, _4up3ns / _ow2qx3);
}
} else {
vec4 _qlcrvu = texture(colortex1, texcoord);
float _d776y5 = texture(vxDepthTexTrans, texcoord).r;
bool _did8bj = (_qlcrvu.a > 0.999) && _2fqi4q(vxProjInv) && _7bqo1l(_d776y5);

if (_did8bj) {
vec3 _pziwuj;
_did8bj = _cwcjr4(
vxProjInv, gbufferModelViewInverse, cameraPosition, texcoord, _d776y5, _pziwuj);
if (_did8bj) {
vec3 _bl25za = _pziwuj - cameraPosition;
_yrhjqj = _lcgfcm(_bl25za, vec3(0.0, 0.0, -1.0));
_iflag7 = length(_bl25za);
float _sxalry = float(SEA_LEVEL_OFFSET) - 0.125;
if (_pziwuj.y > _sxalry - 0.5) {
_myh47e = true;
float _4up3ns = max(_sxalry - cameraPosition.y, 0.1);
float _ow2qx3 = max(_yrhjqj.y, 0.01);
_iflag7 = min(_iflag7, _4up3ns / _ow2qx3);
}
}
}

if (!_did8bj) {
float _kndsnz = texture(dhDepthTex, texcoord).r;
if (_yfr6tv(_kndsnz)) {
vec3 _i7u4cy;
if (_cwcjr4(
dhProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _kndsnz, _i7u4cy)) {
vec3 _8ufn6p = _i7u4cy - cameraPosition;
_yrhjqj = _lcgfcm(_8ufn6p, vec3(0.0, 0.0, -1.0));
_iflag7 = length(_8ufn6p);
_myh47e = (_i7u4cy.y > float(SEA_LEVEL_OFFSET) - 0.625);
} else {
_kndsnz = 1.0;
}
}

if (!_yfr6tv(_kndsnz)) {

_myh47e = true;
vec3 _vbi472;
if (!_c0ckez(gbufferProjectionInverse, texcoord, 1.0, _vbi472)) {
_vbi472 = vec3(texcoord * 2.0 - 1.0, -1.0);
}
_yrhjqj = _lcgfcm(
mat3(gbufferModelViewInverse) * _vbi472,
_lcgfcm(mat3(gbufferModelViewInverse) * vec3(0.0, 0.0, -1.0), vec3(0.0, 0.0, -1.0)));

float _4up3ns = max(float(SEA_LEVEL_OFFSET) - 0.125 - cameraPosition.y, 0.1);

float _ow2qx3 = max(_yrhjqj.y, 0.01);
_iflag7 = _4up3ns / _ow2qx3;
}
}
}

float _18yfpq = mix(1.0, 0.3, biome_swamp);
float _yzz35p = mix(UNDERWATER_FOG_START, 0.0, biome_swamp);
float _0c83xf = mix(float(UNDERWATER_FOG_DISTANCE), 5.0, biome_swamp);
_iflag7 = min(_iflag7, _0c83xf);

float _tbrr54 = mix(UNDERWATER_FOG_DENSITY * 0.008, 0.6, biome_swamp);
float _yhm9hg = max(_iflag7 - _yzz35p, 0.0);
float _1rgjl5 = exp(-_yhm9hg * _tbrr54);
float _nzwfxt = 1.0 - _1rgjl5;

vec3 _6salby = _lcgfcm(
mat3(gbufferModelViewInverse) * sunPosition, vec3(0.0, 1.0, 0.0));
vec3 _116kn7 = _lcgfcm(
mat3(gbufferModelViewInverse) * moonPosition, vec3(0.0, -1.0, 0.0));
float _ud8rxs = dot(_yrhjqj, _6salby);
float _p5bb11 = _ud8rxs * 0.5 + 0.5;
_p5bb11 = pow(_p5bb11, 2.0);

float _rb3fbm = 1.0 - smoothstep(-0.05, 0.3, _6salby.y);

float _oizsss = _6salby.y;
float _rp4sah = smoothstep(0.0, 0.15, _oizsss) * (1.0 - smoothstep(0.15, 0.35, _oizsss));
_rp4sah = pow(_rp4sah, 0.7);

vec3 _e61p9c  = vec3(0.12, 0.22, 0.50);
vec3 _xnj26c = vec3(0.25, 0.94, 1.0);

vec3 _50ch13  = vec3(0.60, 0.22, 0.05);
vec3 _42u8xs = vec3(1.0, 0.80, 0.15);

vec3 _xoc41t  = vec3(0.10, 0.18, 0.42);
vec3 _mwld5x = vec3(0.10, 0.22, 0.45);

vec3 _jt95tj  = mix(mix(_e61p9c, _50ch13, _rp4sah), _xoc41t, _rb3fbm);
vec3 _wtbfqc = mix(mix(_xnj26c, _42u8xs, _rp4sah), _mwld5x, _rb3fbm);
vec3 _hjlln0 = mix(_jt95tj, _wtbfqc, _p5bb11);

if (biome_swamp > 0.001) {
vec3 _puxjxz  = vec3(0.04, 0.10, 0.02);
vec3 _utk4xx = vec3(0.10, 0.22, 0.05);
vec3 _scemhb = mix(_puxjxz, _utk4xx, _p5bb11);
_hjlln0 = mix(_hjlln0, _scemhb, biome_swamp);
}

float _5bu1a6 = dot(_yrhjqj, _116kn7) * 0.5 + 0.5;
_5bu1a6 = pow(_5bu1a6, 2.0);
vec3 _0v4nez = vec3(0.18, 0.32, 0.75);
_hjlln0 = mix(_hjlln0, _0v4nez, _5bu1a6 * _rb3fbm * 0.7);

float _xvenun = float(SEA_LEVEL_OFFSET) - 0.125;

vec3  _mwx7ml = _hjlln0 * _nzwfxt;

{
float _bpad7t = float(UNDERWATER_VIEW_FOG_START) * _18yfpq;
float _6zqshi   = float(UNDERWATER_VIEW_FOG_END) * _18yfpq;
float _jtl47e = smoothstep(_bpad7t, max(_6zqshi, _bpad7t + 0.001), _iflag7);
if (_jtl47e > 0.001) {
float _r640vg = 1.0 - _jtl47e;
_mwx7ml = _mwx7ml * _r640vg + _hjlln0 * _jtl47e;
_nzwfxt = min(1.0 - (1.0 - _nzwfxt) * _r640vg, 0.99);
}
}

float _mymqma = cameraPosition.y;
float _sj6nb7 = _xvenun - _mymqma;
float _8ixgi6 = smoothstep(0.0, 6.0, _sj6nb7);
if (_8ixgi6 > 0.001 && _myh47e) {
float _78jesv = _xvenun;
float _z9dws7 = _xvenun - 0.5;

float _55bldj = 0.0;
float _q92vvk = 0.0;
bool _l07iox = false;

if (_mymqma >= _z9dws7 && _mymqma <= _78jesv) {

_55bldj = 0.0;
if (_yrhjqj.y > 0.001) {
_q92vvk = (_78jesv - _mymqma) / _yrhjqj.y;
} else if (_yrhjqj.y < -0.001) {
_q92vvk = (_z9dws7 - _mymqma) / _yrhjqj.y;
} else {
_q92vvk = 3.0;
}
_l07iox = true;
} else if (_mymqma < _z9dws7 && _yrhjqj.y > 0.001) {

_55bldj = (_z9dws7 - _mymqma) / _yrhjqj.y;
_q92vvk = (_78jesv - _mymqma) / _yrhjqj.y;
_l07iox = _55bldj < 200.0;
}

if (_l07iox) {
float _q2xstw = mix(0.50, 1.0, _8ixgi6);
float _cpk05g = 1.0 - _q2xstw;

float _2leksf = mix(
dot(_yrhjqj, _6salby) * 0.5 + 0.5,
dot(_yrhjqj, _116kn7) * 0.5 + 0.5,
_rb3fbm
);
_2leksf = pow(_2leksf, 3.0);

vec3 _aehv3z = vec3(0.30, 0.95, 1.0);
vec3 _l2f4nu = vec3(1.0, 0.65, 0.10);
vec3 _nbik84 = vec3(0.16, 0.30, 0.70);
vec3 _nma4kq = mix(mix(_aehv3z, _l2f4nu, _rp4sah), _nbik84, _rb3fbm);

if (biome_swamp > 0.001) {
_nma4kq = mix(_nma4kq, vec3(0.08, 0.18, 0.04), biome_swamp);
}
vec3 _46aaj2 = mix(_hjlln0, _nma4kq, _2leksf * 0.25);

{

float _nn47vd = max((_xvenun - _mymqma) / max(_yrhjqj.y, 0.001), 0.0);
vec3 _x26gow = cameraPosition + _yrhjqj * _nn47vd;
vec2 _32geq9 = floor(_x26gow.xz * 16.0) / 16.0;

float _0f6s9v = frameTimeCounter * WATER_WAVE_SPEED * 0.15;
vec3 _n0p9ey = vec3(_32geq9.x, 0.0, _32geq9.y) * 0.35;
float _c3mtzg = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _n0p9ey;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
_c3mtzg += abs(_lpglwu(p * _oah0e7 + _0f6s9v * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
_c3mtzg = 1.0 - _c3mtzg / _56jsby;
}
float _6nj3es = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _n0p9ey + 5.0;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
_6nj3es += abs(_lpglwu(p * _oah0e7 + _0f6s9v * 1.15 * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
_6nj3es = 1.0 - _6nj3es / _56jsby;
}
float _ukyebm = min(_c3mtzg, _6nj3es);
_ukyebm = pow(_ukyebm, 2.0) * 2.5;
_ukyebm = max(_ukyebm - 0.15, 0.0) * (1.0 / 0.85);

float _ue6jrn = _lpglwu(vec3(_32geq9 * 6.0, _0f6s9v * 0.5)) * 0.6;
_ukyebm += _ue6jrn;
_ukyebm = floor(_ukyebm * 5.0 + 0.5) / 5.0;
_ukyebm = max(_ukyebm, 0.0);

float _r80g6b = dot(_yrhjqj, _6salby);
float _ilsyqy = smoothstep(0.3, 0.8, _r80g6b);

float _efoq5s = dot(_yrhjqj, _116kn7);
float _pumpsp = smoothstep(0.3, 0.8, _efoq5s) * _rb3fbm * 0.3;
float _6vf7k9 = max(_ilsyqy, _pumpsp);

_46aaj2 += _nma4kq * _ukyebm * 0.05 * _6vf7k9;
}

_mwx7ml = _mwx7ml * _cpk05g + _46aaj2 * (1.0 - _cpk05g);
_nzwfxt = min(1.0 - (1.0 - _nzwfxt) * _cpk05g, 1.0);
}
}

#ifdef UNDERWATER_SHAFTS_ENABLED
{
float _cbvdcz = max(_6salby.y + _rp4sah * 0.15, 0.0);
if (_cbvdcz > 0.01) {

vec3 _ka6wiu = _lcgfcm(
mat3(gbufferModelViewInverse) * vec3(0.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0));
vec3 _iux6wf = _lcgfcm(
cross(_6salby, _ka6wiu),
_lcgfcm(cross(_6salby, vec3(1.0, 0.0, 0.0)), vec3(0.0, 0.0, 1.0)));
vec3 _dme3tq = cross(_iux6wf, _6salby);

float _wnr39r = dot(_yrhjqj, _6salby);
float _hl0eel = 0.0;
if (_wnr39r > 0.0) {

vec3 _ic9jj6 = _yrhjqj - _6salby * _wnr39r;
float dx = abs(dot(_ic9jj6, _iux6wf));
float dy = abs(dot(_ic9jj6, _dme3tq));

float _tvmwdj = pow(pow(dx, 4.0) + pow(dy, 4.0), 0.25);
_hl0eel = 0.35 / (1.0 + _tvmwdj * _tvmwdj * 100.0);
}

float _ikqq88 = 1.0;
#ifdef SHADOWS_ENABLED
{

float _khqtzf = max((_xvenun - cameraPosition.y) / max(_yrhjqj.y, 0.001), 0.0);
vec3 _xzv0xu = _yrhjqj * min(_khqtzf, _iflag7);
vec4 _54yp96 = shadowProjection * shadowModelView * vec4(_xzv0xu, 1.0);
vec3 _l2iix7 = _2y5umb(_54yp96.xyz);
vec3 _bbshfw = _l2iix7 * 0.5 + 0.5;
_bbshfw.z -= 0.001;
if (_bbshfw.x > 0.0 && _bbshfw.x < 1.0 &&
_bbshfw.y > 0.0 && _bbshfw.y < 1.0) {
_ikqq88 = step(_bbshfw.z, textureLod(shadowtex0, _bbshfw.xy, 0.0).r);
}
}
#endif
_hl0eel *= _cbvdcz * UNDERWATER_SHAFTS_INTENSITY * _ikqq88;

vec3 _f1qzlp = mix(vec3(0.75, 0.95, 1.0), vec3(1.0, 0.70, 0.15), _rp4sah);
_mwx7ml += _f1qzlp * _hl0eel;
}

float _px9hm7 = max(_116kn7.y, 0.0);
if (_px9hm7 > 0.01) {
vec3 _yc9400 = _lcgfcm(
mat3(gbufferModelViewInverse) * vec3(0.0, 1.0, 0.0), vec3(0.0, 1.0, 0.0));
vec3 _f0kqeu = _lcgfcm(
cross(_116kn7, _yc9400),
_lcgfcm(cross(_116kn7, vec3(1.0, 0.0, 0.0)), vec3(0.0, 0.0, 1.0)));
vec3 _c3nxri = cross(_f0kqeu, _116kn7);

float _rb63ys = dot(_yrhjqj, _116kn7);
float _krasn9 = 0.0;
if (_rb63ys > 0.0) {
vec3 _ic9jj6 = _yrhjqj - _116kn7 * _rb63ys;
float dx = abs(dot(_ic9jj6, _f0kqeu));
float dy = abs(dot(_ic9jj6, _c3nxri));
float _tvmwdj = pow(pow(dx, 4.0) + pow(dy, 4.0), 0.25);
_krasn9 = 0.35 / (1.0 + _tvmwdj * _tvmwdj * 100.0);
}
float _xgx0yc = 1.0;
#ifdef SHADOWS_ENABLED
{
float _khqtzf = max((_xvenun - cameraPosition.y) / max(_yrhjqj.y, 0.001), 0.0);
vec3 _xzv0xu = _yrhjqj * min(_khqtzf, _iflag7);
vec4 _54yp96 = shadowProjection * shadowModelView * vec4(_xzv0xu, 1.0);
vec3 _l2iix7 = _2y5umb(_54yp96.xyz);
vec3 _bbshfw = _l2iix7 * 0.5 + 0.5;
_bbshfw.z -= 0.001;
if (_bbshfw.x > 0.0 && _bbshfw.x < 1.0 &&
_bbshfw.y > 0.0 && _bbshfw.y < 1.0) {
_xgx0yc = step(_bbshfw.z, textureLod(shadowtex0, _bbshfw.xy, 0.0).r);
}
}
#endif
_krasn9 *= _px9hm7 * UNDERWATER_SHAFTS_INTENSITY * 0.7 * _xgx0yc;
_mwx7ml += vec3(0.6, 0.7, 0.9) * _krasn9;
}
}
#endif

float _izh8vx = fract(52.9829189 * fract(0.06711056 * gl_FragCoord.x + 0.00583715 * gl_FragCoord.y)
+ 5.588238 * float(frameCounter & 63));
vec3 _xvak3e = vec3(0.0);
float _booa4e = 0.0;
int _2mbsku = 32;
float _tlij0x = min(_iflag7, float(UNDERWATER_FOG_DISTANCE)) / float(_2mbsku);

vec3 _imm5vb = vec3(1.0, 0.502, 0.682);
vec3 _jx2p4l = vec3(0.071, 0.922, 1.0);
vec3 _16hwu3 = vec3(0.722, 0.612, 1.0);

if (biome_swamp > 0.001) {
_imm5vb = mix(_imm5vb, vec3(0.15, 0.25, 0.05), biome_swamp);
_jx2p4l = mix(_jx2p4l, vec3(0.08, 0.18, 0.03), biome_swamp);
_16hwu3 = mix(_16hwu3, vec3(0.12, 0.10, 0.04), biome_swamp);
}

for (int i = 0; i < _2mbsku; i++) {
float t = (float(i) + _izh8vx) * _tlij0x;
vec3 _tj3223 = cameraPosition + _yrhjqj * t;

float _1ysojj = frameTimeCounter * 0.6;
vec3 _9z4r2s = _tj3223;
_9z4r2s.x += sin(_tj3223.z * 0.04 + _1ysojj * 1.3) * 15.0 + cos(_tj3223.y * 0.06 + _1ysojj * 0.7) * 10.0;
_9z4r2s.y += sin(_tj3223.x * 0.05 + _1ysojj * 0.9) * 12.0 + cos(_tj3223.z * 0.03 + _1ysojj * 1.1) * 8.0;
_9z4r2s.z += cos(_tj3223.x * 0.04 + _1ysojj * 1.5) * 14.0 + sin(_tj3223.y * 0.05 + _1ysojj * 0.6) * 10.0;

float n = _lpglwu(vec3(_9z4r2s.x * 0.035, _9z4r2s.y * 0.03, _9z4r2s.z * 0.035));

if (n > 0.58) {
float _o7giip = smoothstep(0.58, 0.8, n) * 0.005;

float _689suw = _lpglwu(vec3(_9z4r2s.x * 0.025, _9z4r2s.y * 0.02, _9z4r2s.z * 0.025) + vec3(100.0, 0.0, 50.0));
vec3 fogColor;
if (_689suw < 0.33) fogColor = _imm5vb;
else if (_689suw < 0.66) fogColor = _jx2p4l;
else fogColor = _16hwu3;

_xvak3e += fogColor * _o7giip;
_booa4e += _o7giip;
}
}

_mwx7ml += _xvak3e;
_nzwfxt = min(_nzwfxt + _booa4e, 1.0);

#ifdef UNDERWATER_SHAFTS_ENABLED
{
vec3 _9nsyz3 = _6salby;
float _6e8oy2 = max(_9nsyz3.y, 0.0);

if (_6e8oy2 > 0.01) {
vec3 _q5wjlt = vec3(0.0);
int _ckiclr = 24;

float _qctllw = _xvenun - 2.0;
float _kk8teq = 0.0;
if (_yrhjqj.y > 0.001 && cameraPosition.y < _qctllw) {

_kk8teq = 0.0;
} else if (_yrhjqj.y > 0.001) {

_kk8teq = (_qctllw - cameraPosition.y) / _yrhjqj.y;
}
float _ii7r6l = min(_iflag7, 48.0);
float _kzkg8k = max(_ii7r6l - _kk8teq, 0.0);
float _ox5t4w = _kzkg8k / float(_ckiclr);

vec3 _7ts2gp = vec3(0.75, 0.95, 1.0);
vec3 _vxro64   = vec3(0.3, 0.55, 0.9);

for (int i = 0; i < _ckiclr; i++) {
float t = _kk8teq + (float(i) + _izh8vx) * _ox5t4w;
vec3 _56owf7 = cameraPosition + _yrhjqj * t;

float _0z4fmk = (_xvenun - _56owf7.y) / max(_9nsyz3.y, 0.001);
vec3 _ygqavo = _56owf7 + _9nsyz3 * _0z4fmk;
vec3 _6i991a = vec3(_ygqavo.xz * (UNDERWATER_SHAFTS_SCALE * 5.0), 0.0)
+ vec3(0.0, frameTimeCounter * UNDERWATER_SHAFTS_SPEED, 0.0);

float _nc47ux = _lpglwu(_6i991a);

float _24tehy = smoothstep(min(1.0 - UNDERWATER_SHAFTS_DENSITY * 0.6, 0.9999), 1.0, _nc47ux);

float _slnatl = max(_xvenun - _56owf7.y, 0.0);
if (_slnatl < 2.0) continue;

#ifdef SHADOWS_ENABLED
{
vec3 _h4gwes = _56owf7 - cameraPosition;
vec4 _zuvlot = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _fm2pww = _2y5umb(_zuvlot.xyz);
vec3 _xzn49v = _fm2pww * 0.5 + 0.5;
_xzn49v.z -= 0.001;
if (_xzn49v.x > 0.0 && _xzn49v.x < 1.0 &&
_xzn49v.y > 0.0 && _xzn49v.y < 1.0) {
if (step(_xzn49v.z, textureLod(shadowtex0, _xzn49v.xy, 0.0).r) < 0.5) continue;
}
}
#endif

float _5lmxyy = smoothstep(2.0, 6.0, _slnatl);

float _uzq6bk = exp(-_slnatl * 0.025) * _5lmxyy;

float _cwo1ye = 1.0 - smoothstep(5.0, 16.0, _slnatl);
vec3 _orp46c = mix(_vxro64, _7ts2gp, _cwo1ye);

float _6zh0ul = _24tehy * _uzq6bk * UNDERWATER_SHAFTS_INTENSITY * 0.15;
float _qxgark = _6zh0ul * _ox5t4w * 0.2;

_q5wjlt += _orp46c * _qxgark;
}

_mwx7ml += _q5wjlt * _6e8oy2;
}

float _9phvge = max(_116kn7.y, 0.0);
if (_9phvge > 0.01) {
vec3 _2msopn = vec3(0.0);
int _k3afdp = 24;

float _agmioh = _xvenun - 2.0;
float _jjjfnr = 0.0;
if (_yrhjqj.y > 0.001 && cameraPosition.y < _agmioh) {
_jjjfnr = 0.0;
} else if (_yrhjqj.y > 0.001) {
_jjjfnr = (_agmioh - cameraPosition.y) / _yrhjqj.y;
}
float _n59lfb = min(_iflag7, 48.0);
float _gf3m9h = max(_n59lfb - _jjjfnr, 0.0);
float _0lgs1q = _gf3m9h / float(_k3afdp);

vec3 _jq01nm = vec3(0.5, 0.6, 0.8);
vec3 _1kqsfn   = vec3(0.2, 0.3, 0.6);

for (int i = 0; i < _k3afdp; i++) {
float t = _jjjfnr + (float(i) + _izh8vx) * _0lgs1q;
vec3 _56owf7 = cameraPosition + _yrhjqj * t;

float _0z4fmk = (_xvenun - _56owf7.y) / max(_116kn7.y, 0.001);
vec3 _ygqavo = _56owf7 + _116kn7 * _0z4fmk;

vec3 _88ksy6 = vec3(_ygqavo.xz * (UNDERWATER_SHAFTS_SCALE * 5.0) + 100.0, 0.0)
+ vec3(0.0, frameTimeCounter * UNDERWATER_SHAFTS_SPEED * 0.7, 0.0);
float _48h40k = _lpglwu(_88ksy6);
float _bhvywr = smoothstep(min(1.0 - UNDERWATER_SHAFTS_DENSITY * 0.6, 0.9999), 1.0, _48h40k);

float _slnatl = max(_xvenun - _56owf7.y, 0.0);
if (_slnatl < 2.0) continue;

#ifdef SHADOWS_ENABLED
{
vec3 _h4gwes = _56owf7 - cameraPosition;
vec4 _zuvlot = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _fm2pww = _2y5umb(_zuvlot.xyz);
vec3 _xzn49v = _fm2pww * 0.5 + 0.5;
_xzn49v.z -= 0.001;
if (_xzn49v.x > 0.0 && _xzn49v.x < 1.0 &&
_xzn49v.y > 0.0 && _xzn49v.y < 1.0) {
if (step(_xzn49v.z, textureLod(shadowtex0, _xzn49v.xy, 0.0).r) < 0.5) continue;
}
}
#endif

float _5lmxyy = smoothstep(2.0, 6.0, _slnatl);
float _uzq6bk = exp(-_slnatl * 0.025) * _5lmxyy;
float _cwo1ye = 1.0 - smoothstep(5.0, 16.0, _slnatl);
vec3 _6c2hp3 = mix(_1kqsfn, _jq01nm, _cwo1ye);

float _qxgark = _bhvywr * _uzq6bk * UNDERWATER_SHAFTS_INTENSITY * 0.15 * _0lgs1q * 0.2;
_2msopn += _6c2hp3 * _qxgark;
}

_mwx7ml += _2msopn * _9phvge * 0.25;
}
}
#endif

gl_FragData[0] = vec4(_mwx7ml, _nzwfxt);
return;
}
#else

if (isEyeInWater == 1) {
gl_FragData[0] = vec4(0.0);
return;
}
#endif

#ifdef CAVE_FOG_ENABLED
if (gl_FragCoord.x < 1.0 && gl_FragCoord.y < 1.0) {

nextStoredCaveFogTakeover = 1.0;
}
vec4 _r0opp7 = texture(colortex1, texcoord);
float _nbywl0 = 1.0 - smoothstep(1.0 / 15.0, 3.0 / 15.0, _r0opp7.b);
float _t3xw2s = clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0);
float _4nl6xt = 1.0 - smoothstep(2.0 / 15.0, 6.0 / 15.0, _t3xw2s);
float _bm5rh1 = max(_nbywl0, _4nl6xt);
if (isEyeInWater == 0 && !_9cwhip(biome) && _bm5rh1 > 0.001) {

vec3 _xzpqjt = _3vbi0y(biome, biome_category);
vec3 _ck3piv = vec3(smoothCaveFogR, smoothCaveFogG, smoothCaveFogB);
if (any(isnan(_ck3piv)) || any(isinf(_ck3piv)) || length(_ck3piv) < 0.001) {
_ck3piv = _xzpqjt;
}
if (gl_FragCoord.x < 1.0 && gl_FragCoord.y < 1.0) {
vec3 _779mo0 = mix(_ck3piv, _xzpqjt, 0.02);
nextSmoothCaveFogR = _779mo0.r;
nextSmoothCaveFogG = _779mo0.g;
nextSmoothCaveFogB = _779mo0.b;
}

float _vv88l5 = texture(depthtex0, texcoord).r;
float _c0fn4l = texture(depthtex1, texcoord).r;
float _rp5tyf = texture(vxDepthTexTrans, texcoord).r;
bool _k1y4w8 = (_r0opp7.a > 0.999 && _r0opp7.g < 0.01 && _vv88l5 >= 0.9999);
bool _dk6ab5 = _2fqi4q(vxProjInv) && _7bqo1l(_rp5tyf);
bool _wh7x4u = (_vv88l5 < _c0fn4l - 0.00001);
bool _30q2ox = (_r0opp7.a > 0.01 && _r0opp7.a < 0.99);
bool _gdhu3z = (_r0opp7.a > 0.999 && _vv88l5 < 0.9999);
float _7kjb4p;
bool _lxesb6 = false;

if (_30q2ox) {
_7kjb4p = _vv88l5;
} else if (_gdhu3z && _wh7x4u) {

_7kjb4p = _vv88l5;
} else if (_dk6ab5 && (_wh7x4u || _k1y4w8)) {
_7kjb4p = _rp5tyf;
_lxesb6 = true;
} else if (_wh7x4u) {
_7kjb4p = (_c0fn4l < 0.9999) ? _c0fn4l : _vv88l5;
} else {
_7kjb4p = _vv88l5;
}

bool _r966oh = _7bqo1l(_7kjb4p);
if (_r966oh || _4nl6xt > 0.001) {
vec3 _xi845h;
float _6oa3kf;
if (_r966oh) {
mat4 _bjmaiq = _lxesb6 ? vxProjInv : gbufferProjectionInverse;
_r966oh = _c0ckez(_bjmaiq, texcoord, _7kjb4p, _xi845h);
}
if (_r966oh) {
_6oa3kf = min(length(_xi845h), CAVE_FOG_MAX_DIST);
} else {
if (!_c0ckez(gbufferProjectionInverse, texcoord, 1.0, _xi845h)) {
_xi845h = vec3(texcoord * 2.0 - 1.0, -1.0);
}
_6oa3kf = CAVE_FOG_MAX_DIST;
}

vec3 _965z7x = _lcgfcm(
mat3(gbufferModelViewInverse) * _xi845h,
_lcgfcm(mat3(gbufferModelViewInverse) * vec3(0.0, 0.0, -1.0), vec3(0.0, 0.0, -1.0)));
float _f8tbja = min(_6oa3kf, CAVE_FOG_MAX_DIST);
float _281g75 = 0.0;
float _cof0ap = texelFetch(noisetex, ivec2(gl_FragCoord.xy) & 255, 0).b;
float _6n93tr = fract(_cof0ap + float(frameCounter) * 0.6180339887);
float _30zq07 = 1.0;
vec3 _y2j5ei = vec3(0.0);
vec3 _5vgwrs  = vec3(0.0);
float _lp8avz = max(_f8tbja - _281g75, 0.0);
const float _trw9bh = 11.0;
float _fw82zq = float(CAVE_FOG_STEPS);
float _rrfu7w = 12.0 / max(_fw82zq, 1.0);
float _nj2bdn = 0.08 * _rrfu7w;
float _xgxlgi = 0.20 * _rrfu7w;
float _7jwb9t = 0.0;
#ifdef SHADOWS_ENABLED
_7jwb9t = smoothstep(0.02, 0.10, _lcgfcm(
mat3(gbufferModelViewInverse) * sunPosition, vec3(0.0, 1.0, 0.0)).y);
#endif
for (int i = 0; i < CAVE_FOG_STEPS; i++) {
float _952c4r = (float(i) + _6n93tr) / _fw82zq;
float _6h3w1g = pow(_trw9bh, _952c4r);
float _fjsrkz = (_6h3w1g - 1.0) / (_trw9bh - 1.0);
float _e6dd5f = _6h3w1g * log(_trw9bh) / _fw82zq / (_trw9bh - 1.0) * _lp8avz;
float t = _281g75 + _fjsrkz * _lp8avz;
vec3 sp = cameraPosition + _965z7x * t;
vec3 _pt6jgk = _gabxsk(_ck3piv, sp.y);

float _49boxn = smoothstep(0.0, max(float(CAVE_FOG_FADE_DEPTH), 1.0), float(SEA_LEVEL_OFFSET) - sp.y);
if (_49boxn <= 0.001) continue;
float _ddk111 = step(float(SEA_LEVEL_OFFSET), sp.y);
float _lww4mz = smoothstep(0.5, 3.0, t);

vec3 _hhrvxa = vec3(0.0);
float _6m4sao = 1.0;
#ifdef LPV_ENABLED
if (_bm5rh1 > 0.001 && _49boxn > 0.001) {
vec3 _gdm3gi = sp - cameraPosition;
vec3 _m66wgm = _cs4po4(_gdm3gi, cameraPosition);
if (_x3urej(_m66wgm)) {
vec3 _ktjs5n = _m66wgm / _fsho2m;
vec3 _tj8de8 = _hvneao(_be02gn(_ktjs5n));
vec3 _wkj2aa  = _hvneao(_6l00a6(_ktjs5n));
vec3 _2snota = _625ydm(_tj8de8 * CAVE_FOG_LPV_STRENGTH, 0.09, 0.05) * _bm5rh1;
vec3 _15noec = _625ydm(_wkj2aa * CAVE_FOG_LPV_STRENGTH, 0.022, 0.008) * _bm5rh1;

float _aglxrc = _b7swkf(_m66wgm);
float _vcn38t = smoothstep(0.38, 1.20, _4fp51a(_wkj2aa)) * 0.55;
_aglxrc = clamp(max(_aglxrc, _vcn38t), 0.0, 1.0);
float _1gsdm1 = _9zsl11(_15noec);

_6m4sao = mix(1.0, _1gsdm1, _ddk111 * _aglxrc);
_hhrvxa = _2snota * _aglxrc * 1.10;
}
}
#endif

float _wpctd1 = 1.0;
#ifdef SHADOWS_ENABLED
if (_7jwb9t > 0.001) {
float _i2e4b3 = _uz23jg(sp, _7jwb9t);
_wpctd1 = 1.0 - smoothstep(0.02, 0.20, _i2e4b3);
_wpctd1 = max(_wpctd1, _4nl6xt * 0.28);
}
#endif

float _dkq1et = CAVE_FOG_DENSITY * _mu5zr1(sp) * _bm5rh1 * _wpctd1 * _lww4mz * _49boxn;
float _6zh0ul = _dkq1et * _6m4sao;
float _1oiq2w = min(_6zh0ul * _e6dd5f * 1.15, _nj2bdn);
float _1gnyk3 = min(_dkq1et * _e6dd5f * 1.15, _nj2bdn);
float sT = exp(-_1oiq2w);
float _xr0xap = _30zq07 * (1.0 - sT);
float _yz1uip = _30zq07 * (1.0 - exp(-_1gnyk3));
float _ril90u = _30zq07 * min(_e6dd5f * 0.12 * _bm5rh1 * _wpctd1 * _49boxn * smoothstep(0.25, 1.5, t), _xgxlgi);
_y2j5ei += _xr0xap * _pt6jgk;
_5vgwrs  += max(_yz1uip, _ril90u) * _hhrvxa;
_30zq07 *= sT;
}

float _8obs06 = (1.0 - _30zq07);
vec3 _yxasgp = _y2j5ei;
#ifdef LPV_ENABLED
_yxasgp += _5vgwrs;
#endif
_my8b76 = vec4(_yxasgp, 1.0 + _8obs06);
}
}
#endif

#if !defined(ATMO_FOG_ENABLED)
{
vec4 _3t3haq = vec4(0.0);
if (_my8b76.a > 1.0) {
vec4 _xzrud0 = vec4(_my8b76.rgb, _my8b76.a - 1.0);
_3t3haq = _xzrud0;
}
gl_FragData[0] = _3t3haq;
return;
}
#endif

vec4 _alcc4c = texture(colortex1, texcoord);
float _2zs1mf = texture(depthtex0, texcoord).r;
float _b8i8m4 = texture(depthtex1, texcoord).r;
float _ips7jr = texture(dhDepthTex, texcoord).r;
float vxDepth = texture(vxDepthTexTrans, texcoord).r;
vec3 _0x5uwo;
bool _7zeca0 = _yfr6tv(_ips7jr) && _cwcjr4(
dhProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _ips7jr, _0x5uwo);
bool _rv9f3n = (_alcc4c.a > 0.999 && !_7bqo1l(_2zs1mf));
bool _pgh3p7 = _2fqi4q(vxProjInv) && _7bqo1l(vxDepth);

bool _d293zd = (_2zs1mf < _b8i8m4 - 0.00001);
bool _ux4ees = (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);
bool _0t1n6k = (texture(colortex5, texcoord).y > 0.9) && _d293zd;
float _1r3mt9;
bool _nwgn5g = false;
if (_ux4ees) {

_1r3mt9 = _2zs1mf;
} else if (_pgh3p7 && (_d293zd || _rv9f3n)) {

_1r3mt9 = vxDepth;
_nwgn5g = true;
} else if (_0t1n6k && _7bqo1l(_2zs1mf)) {
_1r3mt9 = _2zs1mf;
} else if (_d293zd) {

_1r3mt9 = _7bqo1l(_b8i8m4) ? _b8i8m4 : _2zs1mf;
} else {
_1r3mt9 = _2zs1mf;
}
vec3 _003it1;
bool _w4h543 = _7bqo1l(_1r3mt9) && _cwcjr4(
_nwgn5g ? vxProjInv : gbufferProjectionInverse,
gbufferModelViewInverse,
cameraPosition,
texcoord,
_1r3mt9,
_003it1);
bool _yjolhc = !_w4h543 && !_7zeca0;
float _13rsme = _yjolhc ? 1.0 : _alcc4c.b;
float _pbfs9z = _yjolhc ? 1.0 : smoothstep(0.5 / 15.0, 1.0 / 15.0, _13rsme);
float _da3yip = 1.0;
float _6eyd1f = 1.0 - smoothstep(2.0 / 15.0, 6.0 / 15.0, _13rsme);
float _8cn0an = clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0);
float _b3g6pf = 1.0 - smoothstep(2.0 / 15.0, 6.0 / 15.0, _8cn0an);

vec3 _q62x7r;
float _cunixp;
float _v0iv1x = 0.0;

if (_w4h543) {
vec3 worldPos = _003it1;
vec3 _ys8kd8 = worldPos - cameraPosition;
_q62x7r = _lcgfcm(_ys8kd8, vec3(0.0, 0.0, -1.0));
_cunixp = length(_ys8kd8);

#ifdef SHADOWS_ENABLED
vec3 _h4gwes = worldPos - cameraPosition;
vec4 _yjgfu3 = shadowModelView * vec4(_h4gwes, 1.0);
vec4 _871eyv = shadowProjection * _yjgfu3;
vec3 _olwzr4 = _2y5umb(_871eyv.xyz);
vec3 _5yr4y2 = _olwzr4 * 0.5 + 0.5;
_5yr4y2.z -= 0.001;

vec2 _jofcc4 = min(_5yr4y2.xy, 1.0 - _5yr4y2.xy);
float _ihsr10 = smoothstep(0.0, 0.05, min(_jofcc4.x, _jofcc4.y));
if (_5yr4y2.x > 0.0 && _5yr4y2.x < 1.0 &&
_5yr4y2.y > 0.0 && _5yr4y2.y < 1.0 &&
_5yr4y2.z > 0.0 && _5yr4y2.z < 1.0 &&
_ihsr10 > 0.001) {
_v0iv1x = step(_5yr4y2.z, textureLod(shadowtex1, _5yr4y2.xy, 0.0).r) * _ihsr10;
}
#endif
} else {

if (_7zeca0) {
vec3 _bv8q46 = _0x5uwo - cameraPosition;
_cunixp = length(_bv8q46);
_q62x7r = _lcgfcm(_bv8q46, vec3(0.0, 0.0, -1.0));
} else {

vec3 _enbfdh;
if (!_c0ckez(gbufferProjectionInverse, texcoord, 1.0, _enbfdh)) {
_enbfdh = vec3(texcoord * 2.0 - 1.0, -1.0);
}
_q62x7r = _lcgfcm(
mat3(gbufferModelViewInverse) * _enbfdh,
_lcgfcm(mat3(gbufferModelViewInverse) * vec3(0.0, 0.0, -1.0), vec3(0.0, 0.0, -1.0)));
_cunixp = 0.0;
#ifdef ATMO_FOG_ENABLED
_cunixp = max(_cunixp, float(ATMO_FOG_DISTANCE));
#endif
}
}

float _3ndk95 = 0.0;
#ifdef ATMO_FOG_ENABLED
_3ndk95 = max(_3ndk95, float(ATMO_FOG_DISTANCE));
#endif

if (_yjolhc || (_d293zd && !_7bqo1l(_1r3mt9))) {
_cunixp = _3ndk95;
} else {
_cunixp = min(_cunixp, _3ndk95);
}

float _isil8r = 0.0;
float _wzks95    = 0.0;
float _xx5ojq = 0.0;
float _q92vvk  = 0.0;
bool _mjq3f1 = false;

#ifdef ATMO_FOG_ENABLED

_isil8r = float(SEA_LEVEL_OFFSET);
_wzks95    = cameraPosition.y + float(ATMO_FOG_ABOVE);
_xx5ojq = 0.0;
_q92vvk  = _cunixp;

if (abs(_q62x7r.y) > 0.0001) {
float _wb6fcs = (_isil8r - cameraPosition.y) / _q62x7r.y;
float _1fgwzu    = (_wzks95    - cameraPosition.y) / _q62x7r.y;
float _pxvs4x = min(_wb6fcs, _1fgwzu);
float _l16jxm  = max(_wb6fcs, _1fgwzu);
_xx5ojq = max(_pxvs4x, 0.0);
_q92vvk  = min(_l16jxm, _cunixp);
_mjq3f1 = _xx5ojq < _q92vvk;
} else {
_mjq3f1 = !(cameraPosition.y < _isil8r || cameraPosition.y > _wzks95);
if (_mjq3f1) _q92vvk = _cunixp;
}

#endif

if (!_mjq3f1) {
vec4 _3t3haq = vec4(0.0);
if (_my8b76.a > 1.0) {
vec4 _xzrud0 = vec4(_my8b76.rgb, _my8b76.a - 1.0);
_3t3haq = _xzrud0;
}
gl_FragData[0] = _3t3haq;
return;
}

float _3vuwxo = 1.2;
vec2 _1a36a8 = vec2(cos(_3vuwxo), sin(_3vuwxo));
vec3 _jfq4wz = vec3(_1a36a8.x, 0.0, _1a36a8.y) * frameTimeCounter * ATMO_FOG_WIND_SPEED * 2.0;

float _qa3kxp = texelFetch(noisetex, ivec2(gl_FragCoord.xy) & 255, 0).b;
float _izh8vx = fract(_qa3kxp + float(frameCounter) * 0.6180339887);

vec3 _160bf8 = _tvhml8(fogColor);
float _qjyp4e = _jpbsbi(biome_snowy);
float _d6pcx5 = _2vpc5n(biome_swamp, biome, biome_category);
float _ejh6vj = _avnajg(biome_jungle, biome, biome_category, _d6pcx5);
float _vpw6gy = _za404r(biome_arid);
float _7nlfw5 = _g4a6za(_i0sr2e(biome_savanna), _d6pcx5);
vec3 _domo5x = _af4aog(_160bf8, _qjyp4e, _ejh6vj, _d6pcx5, _vpw6gy, _7nlfw5);
float _9svraf = dot(_domo5x, vec3(0.299, 0.587, 0.114));
TimeWeightsSimple ts = getTimeWeightsSimple(sunAngle);
float _xya605 = ts.day;
float _h0gyrr = ts.night;
_da3yip = mix(1.0, _pbfs9z, _h0gyrr);

vec3 _ismy9f = vec3(0.55, 0.65, 1.0);
_domo5x = mix(_domo5x, _ismy9f, _h0gyrr);

_9svraf = dot(_domo5x, vec3(0.299, 0.587, 0.114));
_domo5x = max(mix(vec3(_9svraf), _domo5x, 1.3), vec3(0.0));
if (_7nlfw5 > 0.001) {
_domo5x = mix(_domo5x, _e6gplv(), _7nlfw5 * _xya605);
}

float _hrymrq = max(_xya605, _h0gyrr * 0.45);

float _c8l7v6 = fract(sunAngle);
float _ga91ri = smoothstep(0.42, 0.5146, _c8l7v6) * (1.0 - smoothstep(0.5146, 0.5604, _c8l7v6));
_hrymrq *= 1.0 - _ga91ri;

float _pco8sk = storedExposure;
if (gl_FragCoord.x < 1.0 && gl_FragCoord.y < 1.0) {
int _n6j44p = 0;
int _3ae7ss = 0;
for (int sy = 0; sy < 8; sy++) {
for (int sx = 0; sx < 8; sx++) {
vec2 _rbbd13 = (vec2(float(sx), float(sy)) + 0.5) / 8.0;

float d = texture(depthtex0, _rbbd13).r;
bool _y3cenf = false;
if (d < 1.0) {
vec3 viewPos;
if (_c0ckez(gbufferProjectionInverse, _rbbd13, d, viewPos)) {
vec3 _h4gwes = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 sv = shadowModelView * vec4(_h4gwes, 1.0);
vec4 sc = shadowProjection * sv;
vec3 sn = _2y5umb(sc.xyz);
vec3 ss = sn * 0.5 + 0.5;
if (_ln18s1(ss) && ss.x > 0.0 && ss.x < 1.0 && ss.y > 0.0 && ss.y < 1.0) {
float _sm87zg = textureLod(shadowtex0, ss.xy, 0.0).r;
_y3cenf = _ln18s1(_sm87zg) && (ss.z - 0.003) > _sm87zg;
}
}
}

if (_y3cenf) {
_n6j44p++;
} else {
_3ae7ss++;
}
}
}

float _jiz9j2 = (_n6j44p + _3ae7ss > 0) ? float(_n6j44p) / float(_n6j44p + _3ae7ss) : 0.0;
float _ksor44 = smoothstep(0.4, 0.75, _jiz9j2);
float _wcjsj4 = _ksor44;

float _9vwz7e = storedExposure;
if (_9vwz7e >= 0.0 && _9vwz7e <= 1.5) {
_pco8sk = mix(_9vwz7e, _wcjsj4, 0.01);
} else {
_pco8sk = _wcjsj4;
}
nextStoredExposure = _pco8sk;

}

float _2ch84a = mix(0.0, 2.0, _pco8sk);

if (_d6pcx5 > 0.001) {

_domo5x = mix(_domo5x, vec3(144.0, 199.0, 90.0) / 255.0, _d6pcx5);

float _w95vdu = mix(1.20, 1.90, _pco8sk);
float _cvkmk8 = mix(0.60, 1.00, _pco8sk);
float _md7vl9 = mix(_w95vdu, _cvkmk8, _h0gyrr);
_2ch84a = mix(_2ch84a, _md7vl9, _d6pcx5);
}

float _k45ioa = storedScreenSkylight;
if (gl_FragCoord.x < 1.0 && gl_FragCoord.y < 1.0) {
float _ek1e53 = 0.0;
for (int sy = 0; sy < 4; sy++) {
for (int sx = 0; sx < 4; sx++) {
vec2 _rbbd13 = (vec2(float(sx), float(sy)) + 0.5) / 4.0;
float sd = texture(depthtex0, _rbbd13).r;
float sl = (sd >= 1.0) ? 1.0 : texture(colortex1, _rbbd13).b;
_ek1e53 += sl;
}
}
_ek1e53 /= 16.0;
float _c5f3k3 = storedScreenSkylight;
if (_c5f3k3 >= 0.0 && _c5f3k3 <= 1.0) {

float _fe9mvr = (_ek1e53 < _c5f3k3) ? 0.08 : 0.05;
_k45ioa = mix(_c5f3k3, _ek1e53, _fe9mvr);
} else {
_k45ioa = _ek1e53;
}
nextStoredScreenSkylight = _k45ioa;
}

float _o71qm7 = clamp(storedAtmoSceneFactor, 0.0, 1.0);
float _r047in = 1.0;
float _fyiykd = 0.0;
float _pt85ii = 0.0;
float _md8fjc = 1.0;
float _081rj7 = 1.0;
#ifdef ATMO_SCENE_AWARE_SHAFTS_ENABLED
{
if (gl_FragCoord.x < 1.0 && gl_FragCoord.y < 1.0) {
float _65i0tk = clamp(storedAtmoSceneFactor, 0.0, 1.0);

if ((frameCounter & 3) == 0) {
vec2 _2dd87w = vec2(textureSize(shadowtex0, 0));
vec2 _gbnjmm = vec2(1.0 / 5.0);
float _tiunwu = 0.0;
int _5faad8 = 0;

for (float i = 0.25; i < 5.0; i++) {
for (float h = 0.45; h < 5.0; h++) {
vec2 _5zlm8i = 0.3 + 0.4 * _gbnjmm * vec2(i, h);
ivec2 _gf01fj = ivec2(_5zlm8i * _2dd87w);
float _zjzdkl = texelFetch(shadowtex0, _gf01fj, 0).x;
if (_zjzdkl < 0.55) {
float _j5kh0o = texture(shadowcolor1, _5zlm8i).a;
if (_j5kh0o > 0.0) {
_j5kh0o = max(_j5kh0o - 0.25, 0.0) / 0.05;
_tiunwu += _j5kh0o;
_5faad8++;
}
}
}
}

float _38xdon = (_5faad8 > 0) ? (_tiunwu / float(_5faad8)) : 0.0;
int _ykjdfk = 2;

ivec2 _po4y8p = textureSize(depthtex0, 0);
int _nicpyx = 0;
for (int k = 0; k < 5; k++) {
float x = 0.1 + 0.2 * float(k);
ivec2 _kqrmda = ivec2(vec2(float(_po4y8p.x) * x, float(_po4y8p.y) * 0.9));
_kqrmda = clamp(_kqrmda, ivec2(0), _po4y8p - 1);
_nicpyx += int(texelFetch(depthtex0, _kqrmda, 0).x == 1.0);
}

if (_nicpyx >= 4) {
_38xdon = 0.0;
_ykjdfk = 3;
}

if (_38xdon > 6.0) {
_65i0tk = min(_65i0tk + (1.0 / 255.0), 1.0);
} else {
_65i0tk = max(_65i0tk - (1.0 / 255.0) * float(_ykjdfk), 0.0);
}

nextStoredAtmoSceneFactor = _65i0tk;
}
}

_o71qm7 = clamp(storedAtmoSceneFactor, 0.0, 1.0);
_o71qm7 = clamp(_o71qm7 * ATMO_SCENE_AWARE_STRENGTH, 0.0, 1.0);

_r047in = mix(1.0, 1.85, _o71qm7);
_fyiykd = mix(0.0, 0.12, _o71qm7);
_pt85ii = mix(0.0, 0.90, _o71qm7);
_md8fjc = mix(1.0, 1.35, _o71qm7);
_081rj7 = mix(1.0, 1.20, _o71qm7);
}
#endif

float _x0q39g = _2ch84a;
vec3 _tdaer8 = _domo5x * ATMO_FOG_BRIGHTNESS * _hrymrq * _x0q39g;

vec3 _fdvtps = mix(
_domo5x * ATMO_FOG_BRIGHTNESS * _hrymrq * max(_2ch84a, 1.0) * _md8fjc,
_tdaer8,
_h0gyrr
);

vec3 _oe9g96 = _lcgfcm(
mat3(gbufferModelViewInverse) * shadowLightPosition, vec3(0.0, 1.0, 0.0));
vec3 _tb66k1 = (abs(_oe9g96.y) > 0.95) ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 1.0, 0.0);
vec3 _x591jz = _lcgfcm(cross(_oe9g96, _tb66k1), vec3(1.0, 0.0, 0.0));
vec3 _1ppy3z = _lcgfcm(cross(_oe9g96, _x591jz), vec3(0.0, 0.0, 1.0));

float _4g40dz = _cunixp;
#ifdef ATMO_FOG_ENABLED
if (_mjq3f1) _4g40dz = min(_4g40dz, _xx5ojq);
#endif

float _rn314f = 0.0;
#ifdef ATMO_FOG_ENABLED
if (_mjq3f1) _rn314f = max(_rn314f, _q92vvk);
#endif

if (_rn314f <= _4g40dz + 0.0001) {
gl_FragData[0] = vec4(0.0);
return;
}

float _30qw16 = _rn314f - _4g40dz;

int _eivfyr = ATMO_FOG_STEPS;
float _gduy5n = _30qw16 / float(_eivfyr);
float _gg59dx = 12.0 / max(float(_eivfyr), 1.0);
float _0xl49d = 0.03 * _gg59dx;
float _xbq7nu = 0.06 * _gg59dx;
float _3tqs27 = max(ATMO_FOG_DENSITY + rainStrength * 0.5, 0.01);

vec3  _mq5jbs = vec3(0.0);
float _8gkfsz = 1.0;

float _8b5mj2 = mix(0.25, 0.10, _d6pcx5);

for (int i = 0; i < ATMO_FOG_STEPS; i++) {
if (i >= _eivfyr) break;
float t = _4g40dz + (float(i) + _izh8vx) * _gduy5n;
vec3 _tj3223 = cameraPosition + _q62x7r * t;

float _f7hei2 = 0.0;

float shadow = 0.0;
vec3 _wx4pj6 = vec3(1.0);
#ifdef SHADOWS_ENABLED
{
vec3 _h4gwes = _tj3223 - cameraPosition;
vec4 _cxdyc5 = shadowModelView * vec4(_h4gwes, 1.0);
vec4 _kffjyx = shadowProjection * _cxdyc5;
vec3 _785h0z = _2y5umb(_kffjyx.xyz);
vec3 _i1hwjb = _785h0z * 0.5 + 0.5;
_i1hwjb.z -= 0.0005;

vec2 _hhkvsa = min(_i1hwjb.xy, 1.0 - _i1hwjb.xy);
float _a9osj3 = smoothstep(0.0, 0.05, min(_hhkvsa.x, _hhkvsa.y));

if (_i1hwjb.x > 0.0 && _i1hwjb.x < 1.0 &&
_i1hwjb.y > 0.0 && _i1hwjb.y < 1.0 &&
_i1hwjb.z > 0.0 && _i1hwjb.z < 1.0 &&
_a9osj3 > 0.001) {

float _uwb7pp = step(_i1hwjb.z, textureLod(shadowtex0, _i1hwjb.xy, 0.0).r);
shadow = step(_i1hwjb.z, textureLod(shadowtex1, _i1hwjb.xy, 0.0).r);

_uwb7pp *= _a9osj3;
shadow  *= _a9osj3;

#ifdef ATMO_COLORED_SHAFTS_ENABLED
if (_uwb7pp < 1.0 && shadow > 0.0) {
vec2 _x8ap7a = 1.0 / vec2(textureSize(shadowcolor0, 0));
vec3 _2ojubc  = texture(shadowcolor0, _i1hwjb.xy).rgb * 4.0;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2( 1.0,  0.0) * _x8ap7a).rgb * 2.0;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2(-1.0,  0.0) * _x8ap7a).rgb * 2.0;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2( 0.0,  1.0) * _x8ap7a).rgb * 2.0;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2( 0.0, -1.0) * _x8ap7a).rgb * 2.0;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2( 1.0,  1.0) * _x8ap7a).rgb;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2(-1.0,  1.0) * _x8ap7a).rgb;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2( 1.0, -1.0) * _x8ap7a).rgb;
_2ojubc += texture(shadowcolor0, _i1hwjb.xy + vec2(-1.0, -1.0) * _x8ap7a).rgb;
_2ojubc *= (1.0 / 16.0);
_2ojubc *= _2ojubc;
_wx4pj6 = _2ojubc * shadow + _uwb7pp;
shadow = max(max(_wx4pj6.r, _wx4pj6.g), _wx4pj6.b);
_wx4pj6 = (shadow > 0.001) ? _wx4pj6 / shadow : vec3(1.0);
}
#endif
}
}
#endif

float _0do1gh = smoothstep(0.35, 0.85, shadow);
float _t4ibn3 = smoothstep(0.20, 0.60, _v0iv1x);
float _wh2qxe = _6eyd1f * max(_0do1gh, _t4ibn3) * (1.0 - _h0gyrr);
float _hrffrm = min(_wx4pj6.r, min(_wx4pj6.g, _wx4pj6.b));
float _onbgtf = max(_wx4pj6.r, max(_wx4pj6.g, _wx4pj6.b));
float _q49rci = smoothstep(0.10, 0.35, _onbgtf - _hrffrm);

float _zt598w = 0.0;
float _3crd8e = 0.0;
float _36zwff = 0.0;
#ifdef ATMO_FOG_ENABLED
if (_mjq3f1 && _da3yip > 0.001 && t >= _xx5ojq && t <= _q92vvk) {
vec3 _kia2vw = (_tj3223 + _jfq4wz) * ATMO_FOG_SCALE;
float _b81968 = _sitw5c(_kia2vw);
float _44sp8z = (_tj3223.y - _isil8r) / max(_wzks95 - _isil8r, 1.0);
_3crd8e = 1.0 - smoothstep(0.7, 1.0, _44sp8z);
_36zwff = 1.0 - smoothstep(float(ATMO_FOG_DISTANCE) * 0.5, float(ATMO_FOG_DISTANCE), t);

float _8td8lh = mix(0.65, 0.85, _d6pcx5);
float _p9yfgy = max(_8b5mj2 - _fyiykd, 0.0);
_zt598w = smoothstep(_p9yfgy, _p9yfgy + max(_8td8lh, 0.0001), _b81968);
_zt598w = mix(_zt598w, 0.65, 0.35);
}
#endif

float _ci26f7 = _zt598w * _3crd8e * _36zwff * _q49rci;

#ifdef ATMO_COLORED_SHAFTS_ENABLED
if (_q49rci > 0.001 && _ci26f7 > 0.001) {
float _xcpnsr = _gduy5n * 0.012 * _081rj7 * _ci26f7;
float _z2mhdk = min(_xcpnsr, _0xl49d);
float _1aybkn = exp(-_z2mhdk);
float _hhszbn = (_z2mhdk > 0.0001)
? (1.0 - _1aybkn) / _z2mhdk
: 1.0;
_mq5jbs += _fdvtps * _wx4pj6 * _xcpnsr * _hhszbn * _8gkfsz;
_f7hei2 += _z2mhdk;
}
#endif

#ifdef ATMO_FOG_ENABLED
if (_zt598w > 0.001) {

float _dz0daj = 1.0 - smoothstep(1.0 / 15.0, 3.0 / 15.0, _k45ioa);
float _pqjudn = max(_pco8sk, _o71qm7) * (1.0 - _dz0daj);
float _5karu1 = smoothstep(2.0, 10.0, t);
float _hajvm5 = 1.0 + _5karu1 * (1.0 - _5karu1) * _pqjudn * 19.0;
float _s8uz67 = _q49rci * smoothstep(0.001, 0.02, _ci26f7);
float _6zh0ul = _3tqs27 * _zt598w * _3crd8e * _36zwff * _gduy5n * 0.006 * _hajvm5 * _r047in * _da3yip * (1.0 - _s8uz67);
float _eyhybf = max(_2ch84a, _pt85ii);
float _rnok3s = shadow;
float _4cleta = min(_6zh0ul * _eyhybf * _rnok3s, _xbq7nu);

float _bb4zqk = _yjolhc
? _4cleta
: min(_6zh0ul * _eyhybf, _xbq7nu);

float _xmu2lh = exp(-_bb4zqk);
float _bo0toz = (_bb4zqk > 0.0001)
? (1.0 - _xmu2lh) / _bb4zqk
: 1.0;
_mq5jbs += _tdaer8 * _4cleta * _bo0toz * _8gkfsz;
_f7hei2 += _bb4zqk;
}
#endif

_8gkfsz *= exp(-_f7hei2);

if (_8gkfsz < 0.01) break;
}

float _9gel4l = 1.0 - _8gkfsz;

vec4 _3t3haq = vec4(_mq5jbs, _9gel4l);
if (_my8b76.a > 1.0) {
vec4 _xzrud0 = vec4(_my8b76.rgb, _my8b76.a - 1.0);
_3t3haq.rgb = _xzrud0.rgb + _3t3haq.rgb * (1.0 - _xzrud0.a);
_3t3haq.a = _xzrud0.a + _3t3haq.a * (1.0 - _xzrud0.a);
}
gl_FragData[0] = _3t3haq;
#undef texcoord
}

#else

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

uniform float biome_beach;
uniform float biome_swamp;
uniform float biome_jungle;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_savanna;
uniform float biome_ocean;

in vec2 texcoord;

void main() {
gl_FragData[0] = vec4(0.0);
}

#endif
