/* RENDERTARGETS: 0 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/depth_utils.glsl"
#include "/include/water_color.glsl"
#include "/include/ocean_waves.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex7;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D dhDepthTex;
uniform sampler2D vxDepthTexTrans;

uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D colortex11;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 dhProjectionInverse;
uniform mat4 vxProjInv;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform sampler2D shadowtex0;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform vec3 shadowLightPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform float far;
uniform float near;
uniform float sunAngle;
uniform float dhFarPlane;
uniform float dhNearPlane;

uniform int isEyeInWater;
uniform int biome;
uniform int biome_category;
uniform int worldDay;
uniform int worldTime;
uniform int frameCounter;
uniform int renderVanillaClouds;

#define FRAME_TIME_COUNTER_DECLARED
uniform float frameTimeCounter;
#define RAIN_STRENGTH_DECLARED
uniform float rainStrength;

uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_savanna;
uniform float biome_beach;
uniform float biome_ocean;
uniform vec3 fogColor;
uniform vec3 skyColor;

in vec2 texcoord;

#ifdef CLOUDS_3D_ENABLED
#include "/include/volumetric_clouds.glsl"
#endif
#ifdef CLOUDS_VANILLA_ENABLED
#include "/include/vanilla_clouds.glsl"
#endif
#include "/include/ilv_reflections.glsl"
#include "/include/noise.glsl"

#if (defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)) && defined(WALL_RUNOFF_ENABLED)
float _6l8nya(vec2 p) {
return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float _qcukfb(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * (3.0 - 2.0 * f);
float a = _6l8nya(i);
float b = _6l8nya(i + vec2(1.0, 0.0));
float c = _6l8nya(i + vec2(0.0, 1.0));
float d = _6l8nya(i + vec2(1.0, 1.0));
return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}
#endif

float _kfwxfj(float x) { return (x * x) * (x * x); }
float _6clrr3(vec2 v) { return sqrt(sqrt(_kfwxfj(v.x) + _kfwxfj(v.y))); }
vec3 _2y5umb(vec3 _gpy6je) {
float _4mbz2g = _6clrr3(_gpy6je.xy) + SHADOW_DISTORTION;
return vec3(_gpy6je.xy / _4mbz2g, _gpy6je.z * SHADOW_DEPTH_SCALE);
}

void main() {
ivec2 _2l09tc = ivec2(gl_FragCoord.xy);

vec4 _f7jn6z = texelFetch(colortex0, _2l09tc, 0);
vec3 _ru60ur = _f7jn6z.rgb;
float _xszwck = _f7jn6z.a;

vec4 _8u1o7c = texelFetch(colortex7, _2l09tc, 0);
vec4 _alcc4c = texelFetch(colortex1, _2l09tc, 0);
vec4 _ehp903 = texelFetch(colortex4, _2l09tc, 0);
vec4 _a2jf3a = texelFetch(colortex5, _2l09tc, 0);

float _2zs1mf = texelFetch(depthtex0, _2l09tc, 0).r;
float _b8i8m4 = texelFetch(depthtex1, _2l09tc, 0).r;
float _ips7jr = texelFetch(dhDepthTex, _2l09tc, 0).r;

float _cr41tl = texelFetch(depthtex2, _2l09tc, 0).r;
bool _28w8fp = (_2zs1mf < _cr41tl - 0.000001) && (abs(_2zs1mf - _b8i8m4) < 0.000001);
float _p94ooe = _8u1o7c.a;
vec3 _yssmf1 = _ru60ur;

if (isEyeInWater == 1) {

bool _e7dp2n = (_b8i8m4 >= 0.9999);
if (!_e7dp2n) {

bool _qanvxg = (_alcc4c.a > 0.99);
mat4 _6mif4h = _qanvxg ? dhProjectionInverse : gbufferProjectionInverse;
vec4 _ilz6jf = _6mif4h * vec4(texcoord * 2.0 - 1.0, _b8i8m4 * 2.0 - 1.0, 1.0);
vec3 _k9zk6j = _ilz6jf.xyz / _ilz6jf.w;
vec3 _6zbddm = (gbufferModelViewInverse * vec4(_k9zk6j, 1.0)).xyz + cameraPosition;
_e7dp2n = (_6zbddm.y > float(SEA_LEVEL_OFFSET) + 0.5);
}
if (_e7dp2n) {

vec4 _qylpe9 = vec4(texcoord * 2.0 - 1.0, 0.5, 1.0);
vec4 _beixpi = gbufferProjectionInverse * _qylpe9;
vec3 _ntbz44 = normalize(_beixpi.xyz);
vec3 _3frwov = normalize(mat3(gbufferModelViewInverse) * _ntbz44);
float _lj1z7e = (float(SEA_LEVEL_OFFSET) - cameraPosition.y) / max(_3frwov.y, 0.001);
vec2 _sx37ew = cameraPosition.xz + _3frwov.xz * max(_lj1z7e, 0.0);

vec2 _1ie0vs = _sx37ew * 0.5;
float _23ypj8 = frameTimeCounter * WATER_WAVE_SPEED;
float _a5i6nt = cos(_1ie0vs.x * 2.0 + _1ie0vs.y * 0.7 + _23ypj8 * 1.2) * 0.3
+ cos(_1ie0vs.x * 1.3 - _1ie0vs.y * 1.8 + _23ypj8 * 0.8) * 0.2;
float _4npl6q = cos(_1ie0vs.y * 2.2 + _1ie0vs.x * 0.5 + _23ypj8 * 1.0) * 0.3
+ cos(_1ie0vs.y * 1.5 - _1ie0vs.x * 1.6 + _23ypj8 * 1.1) * 0.2;

float _k4dgp4 = 14.0;
ivec2 _0ja0jq = _2l09tc + ivec2(vec2(_a5i6nt, _4npl6q) * _k4dgp4);
_0ja0jq = clamp(_0ja0jq, ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));

vec3 _hju1lg = texelFetch(colortex0, _0ja0jq, 0).rgb;
vec4 _vxqjfp = texelFetch(colortex7, _0ja0jq, 0);
vec3 _2bhavk = _vxqjfp.a > 0.001
? _hju1lg * (1.0 - _vxqjfp.a) + _vxqjfp.rgb
: _hju1lg;

_yssmf1 = _2bhavk;
_p94ooe = 0.0;
}
}

bool _5lrryy = (_alcc4c.a > 0.3 && _alcc4c.a < 0.7);
bool _t0phtr = _5lrryy && (_2zs1mf >= _b8i8m4 - 0.00005);
if (_p94ooe > 0.001 && !_28w8fp && !_t0phtr) {
_yssmf1 = _yssmf1 * (1.0 - _p94ooe) + _8u1o7c.rgb;
}

vec3 _4c6yes = _yssmf1;

#ifdef GLASS_FILTER_ENABLED
if (_ehp903.a > 0.55 && _ehp903.a < 0.65) {
vec3 tint = _ehp903.rgb;
float _5linhz = max(max(tint.r, tint.g), tint.b);
if (_5linhz > 0.01) {
tint /= _5linhz;
float _pg1f5w = GLASS_FILTER_SATURATION;
float _3m4k0c = dot(tint, vec3(0.299, 0.587, 0.114));
tint = mix(vec3(_3m4k0c), tint, _pg1f5w);
float _15rxyy = GLASS_FILTER_STRENGTH;
float _66buno = GLASS_FILTER_ENFORCEMENT;
_yssmf1 = mix(_yssmf1, _yssmf1 * tint, _15rxyy * _66buno);
}
}
#endif

#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)

bool _dnud18 = (_a2jf3a.z > 0.001 || _a2jf3a.w > 0.001) && !_28w8fp;

float nx = _a2jf3a.z * 2.0 - 1.0;
float ny = _a2jf3a.w * 2.0 - 1.0;
float nz = sqrt(max(1.0 - nx * nx - ny * ny, 0.0));
vec3 _zu00vj = vec3(nx, ny, nz);
bool _vk0ali = (_zu00vj.y > 0.5);

bool _6wm2rg = (_a2jf3a.y > 0.9);

float voxyMarker = _alcc4c.a;
bool _kt17lp = (voxyMarker > 0.01 && voxyMarker < 0.99) || _28w8fp;

bool isWater = _dnud18 && _6wm2rg && !_kt17lp;
bool _1ty8mm = (voxyMarker > 0.999);
bool _wgkw3q = _dnud18 && _6wm2rg && _1ty8mm && !isWater;
if (_wgkw3q) isWater = true;
bool _etzcl6 = _dnud18 && _6wm2rg && !isWater && (_2zs1mf >= 0.9999) && (_ips7jr < 0.9999);
bool _y9l8xx = _dnud18 && !isWater && !_etzcl6;

vec3 _c085da = _yssmf1;

float _iio55e = _a2jf3a.x;
float _bgr2if = _iio55e;
if (isWater || _etzcl6) {
float _dx5phs = texelFetch(colortex5, _2l09tc + ivec2(-1, 0), 0).x;
float _d7xbpd = texelFetch(colortex5, _2l09tc + ivec2( 1, 0), 0).x;
float _m1qidr = texelFetch(colortex5, _2l09tc + ivec2(0, -1), 0).x;
float _18n2h1 = texelFetch(colortex5, _2l09tc + ivec2(0,  1), 0).x;
_bgr2if = (_iio55e + _dx5phs + _d7xbpd + _m1qidr + _18n2h1) * 0.2;
}

#ifdef WATER_REFLECTION_DEBUG
if (isWater) _yssmf1 = vec3(1.0, 0.0, 1.0);
if (_etzcl6) _yssmf1 = vec3(1.0, 1.0, 0.0);
if (_y9l8xx) _yssmf1 = vec3(0.0, 1.0, 1.0);
#else

TimeWeightsSimple wsTS = getTimeWeightsSimple(sunAngle);
float _oz8bl7 = wsTS.day + wsTS.twilight;
float _dfufsf = wsTS.night + wsTS.blueHour;
float _hh8a92 = _dfufsf / max(_oz8bl7 + _dfufsf, 0.001);
float _ask1av = max(_oz8bl7, _dfufsf);
_hh8a92 = mix(0.0, _hh8a92, _ask1av);

if (isWater || _etzcl6) {
float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
float _pg1f5w = mix(WATER_SATURATION, WATER_SATURATION * WATER_NIGHT_SATURATION, _hh8a92);
_yssmf1 = mix(vec3(_zdxp7g), _yssmf1, _pg1f5w);
}

#ifdef UNDERWATER_FOG_ENABLED
if ((isWater || _etzcl6) && isEyeInWater != 1) {
float _2pqkf9 = _2zs1mf;
float _mkla6u = texelFetch(depthtex1, _2l09tc, 0).r;

vec4 _u6hwxw = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2pqkf9 * 2.0 - 1.0, 1.0);
vec3 _ibfp74 = _u6hwxw.xyz / _u6hwxw.w;
vec4 _mqux7i = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _mkla6u * 2.0 - 1.0, 1.0);
vec3 _y6k1ty = _mqux7i.xyz / _mqux7i.w;

float _vsug70 = max(length(_y6k1ty) - length(_ibfp74), 0.0);

if (_vsug70 < 0.5 && (_1ty8mm || _etzcl6)) {
vec3 _qyg78u = (gbufferModelViewInverse * vec4(_ibfp74, 1.0)).xyz + cameraPosition;
_vsug70 = max(float(SEA_LEVEL_OFFSET) - _qyg78u.y + 2.0, 0.0);
}

vec3 _70glmg = vec3(0.009, 0.004, 0.0015);
vec3 _x1c0w8 = exp(-_vsug70 * _70glmg);
vec3 _ksrktm = vec3(0.1, 0.4, 0.8);

#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1 = vec3(voxyMarker);
if (_1ty8mm) _yssmf1 = vec3(1.0, 0.0, 0.0);
if (_etzcl6) _yssmf1 = vec3(0.0, 1.0, 0.0);
if (_wgkw3q) _yssmf1 = vec3(1.0, 1.0, 0.0);
#endif
}
#endif

float _wowu50 = max(biome_beach, biome_ocean);

#ifdef WATER_FOAM_ENABLED
if ((isWater || _etzcl6) && isEyeInWater != 1) {
vec3 _z5wyi5;
if (_etzcl6 || _wgkw3q) {
float _x7gjed = _etzcl6 ? _ips7jr : _2zs1mf;
vec4 _arm6hc = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _x7gjed * 2.0 - 1.0, 1.0);
_z5wyi5 = _arm6hc.xyz / _arm6hc.w;
} else {
vec4 _k1w1wj = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_z5wyi5 = _k1w1wj.xyz / _k1w1wj.w;
}
vec3 _s9t5pq = (gbufferModelViewInverse * vec4(_z5wyi5, 1.0)).xyz + cameraPosition;
float _5pxwpu = frameTimeCounter * WATER_WAVE_SPEED;
float _tzdfvl = 0.15;

#define RF_WAVE_RAW(f) (smoothstep(0.15, 0.25, f) * (1.0 - pow(smoothstep(0.25, 1.15, f), 0.45)))
#define RF_WAVE(px) RF_WAVE_RAW(1.0 - fract(px))
#define RF_OWAVE(px) (pow(0.5 + 0.5 * sin((fract(px) - 0.25) * 6.2832), 1.6))
#define RF_SMAX(a, b, k) (max(a, b) + pow(max(k - abs(a - b), 0.0) / k, 3.0) * k * 0.166667)

vec2 _6exbeo = vec2(0.0);
bool _mxedkp = (_zu00vj.y < 0.5) && _6wm2rg;

if (_mxedkp) {
float _kcvx4r = texelFetch(colortex5, _2l09tc, 0).x;
_6exbeo = vec2((_kcvx4r - 0.5) * 0.8, (_kcvx4r - 0.5) * 1.2);
} else if (biome_beach > 0.01 && biome_beach >= biome_ocean) {

float _tm7pcm = _s9t5pq.x * WATER_WAVE_SCALE;
float _asfihw = _s9t5pq.z * WATER_WAVE_SCALE;
float _s3g5nt = sin(_asfihw * 0.21 + 3.7) * 2.5 + sin(_asfihw * 0.53 + 1.2) * 1.3;
float _qjrb5k = sin(_asfihw * 0.37 + 5.1) * 1.8 + sin(_asfihw * 0.71 + 2.8) * 1.1;
float _ejqt5w = sin(_asfihw * 0.62 + 0.9) * 1.2 + sin(_asfihw * 0.89 + 4.3) * 0.8;
float _rbrsqu = clamp(RF_SMAX(RF_WAVE((_tm7pcm * 0.8 + _s3g5nt - _5pxwpu) / 6.2832), RF_WAVE((_tm7pcm * 1.8 + _qjrb5k - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_rbrsqu += RF_WAVE((_tm7pcm * 4.0 + _ejqt5w - _5pxwpu * 2.2) / 6.2832) * 0.15 * _rbrsqu;
float _3hm2qw = (_s9t5pq.x + _tzdfvl) * WATER_WAVE_SCALE;
float _eh8p8i = clamp(RF_SMAX(RF_WAVE((_3hm2qw * 0.8 + _s3g5nt - _5pxwpu) / 6.2832), RF_WAVE((_3hm2qw * 1.8 + _qjrb5k - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_eh8p8i += RF_WAVE((_3hm2qw * 4.0 + _ejqt5w - _5pxwpu * 2.2) / 6.2832) * 0.15 * _eh8p8i;
float _gbyll2 = (_s9t5pq.z + _tzdfvl) * WATER_WAVE_SCALE;
float _2csvvv = sin(_gbyll2 * 0.21 + 3.7) * 2.5 + sin(_gbyll2 * 0.53 + 1.2) * 1.3;
float _0bo46n = sin(_gbyll2 * 0.37 + 5.1) * 1.8 + sin(_gbyll2 * 0.71 + 2.8) * 1.1;
float _yx3wmu = sin(_gbyll2 * 0.62 + 0.9) * 1.2 + sin(_gbyll2 * 0.89 + 4.3) * 0.8;
float _s6xooi = clamp(RF_SMAX(RF_WAVE((_tm7pcm * 0.8 + _2csvvv - _5pxwpu) / 6.2832), RF_WAVE((_tm7pcm * 1.8 + _0bo46n - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_s6xooi += RF_WAVE((_tm7pcm * 4.0 + _yx3wmu - _5pxwpu * 2.2) / 6.2832) * 0.15 * _s6xooi;
_6exbeo = vec2(_eh8p8i - _rbrsqu, _s6xooi - _rbrsqu) / _tzdfvl;
}
#undef RF_WAVE
#undef RF_WAVE_RAW
#undef RF_OWAVE
#undef RF_SMAX

float _l1wxos = max(_wowu50, 0.5);
float _rrq5rt = max(length(_z5wyi5), 1.0);
float _2pzycx = (biome_beach > 0.01) ? 18.0 : 14.0;
float _5spi1j = _2pzycx * _l1wxos / max(_rrq5rt * 0.02, 0.5);
ivec2 _gtrgdq = _2l09tc + ivec2(_6exbeo * _5spi1j);
_gtrgdq = clamp(_gtrgdq, ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));
float _n2ipkh = texelFetch(depthtex1, _gtrgdq, 0).r;
if (_n2ipkh > _2zs1mf) {

vec3 _27vcup = texelFetch(colortex0, _gtrgdq, 0).rgb;
vec4 _zjpojh = texelFetch(colortex7, _gtrgdq, 0);
vec3 _zst3en = _zjpojh.a > 0.001 ? _27vcup * (1.0 - _zjpojh.a) + _zjpojh.rgb : _27vcup;
_yssmf1 = mix(_yssmf1, _zst3en, 0.95);
}
}
#endif

#ifdef WATER_REFLECTIONS_ENABLED
if (isWater && isEyeInWater != 1) {
if (_2zs1mf < 1.0) {
vec3 viewPos;
if (_wgkw3q) {
vec4 _fx17l9 = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
viewPos = _fx17l9.xyz / _fx17l9.w;
} else {
vec3 _53i0wc = vec3(texcoord, _2zs1mf);
viewPos = _uyoa3r(_53i0wc);
}
vec3 _6kjayw = _zu00vj;
bool _qpuyyk = (_6kjayw.y < 0.5);
if (_qpuyyk) _6kjayw = vec3(0.0, 1.0, 0.0);
_6kjayw = normalize(mix(vec3(0.0, 1.0, 0.0), _6kjayw, 0.05));
vec3 normal = normalize(mat3(gbufferModelView) * _6kjayw);

vec2 _9sc61v = vec2(0.0);
#ifdef WATER_WAVES_ENABLED
{
ivec2 _pft99a = ivec2(viewWidth - 1.0, viewHeight - 1.0);
ivec2 _0h5ikg = clamp(_2l09tc + ivec2(-1, 0), ivec2(0), _pft99a);
ivec2 _jl79xu = clamp(_2l09tc + ivec2( 1, 0), ivec2(0), _pft99a);
ivec2 _begmf9 = clamp(_2l09tc + ivec2(0, -1), ivec2(0), _pft99a);
ivec2 _nedetf = clamp(_2l09tc + ivec2(0,  1), ivec2(0), _pft99a);
float _c812gk = texelFetch(colortex5, _0h5ikg, 0).x;
float _gjidtf = texelFetch(colortex5, _jl79xu, 0).x;
float _j8nqll = texelFetch(colortex5, _begmf9, 0).x;
float _44vlry = texelFetch(colortex5, _nedetf, 0).x;
vec2 _xsqtjz = vec2(_gjidtf - _c812gk, _44vlry - _j8nqll);
float _n36ohd = max(length(viewPos), 1.0);
float _dzlx4h = 1.0 / _n36ohd;
_9sc61v = vec2(0.0);
}
#endif

TimeWeightsSimple reflTS = getTimeWeightsSimple(sunAngle);
float _rqywk2 = reflTS.day + reflTS.twilight;
float _5npzw1 = reflTS.night + reflTS.blueHour;
float _z1eswg = mix(0.15, 1.0, _rqywk2) + _5npzw1 * 0.85;
float _8eveno = mix(WATER_REFLECTION_AMOUNT, max(WATER_REFLECTION_AMOUNT, 0.85), _5npzw1) * _z1eswg * WATER_OPACITY;
float _na1t7h = 1.0;
_8eveno *= _na1t7h;
float _e3jstl = texelFetch(colortex1, _2l09tc, 0).b;
vec2 lmcoord = vec2(0.0, _e3jstl);

vec3 _alj00v = reflect(normalize(viewPos), normal);
vec3 _n59wg6 = mat3(gbufferModelViewInverse) * _alj00v;

float _wykyaf = length(viewPos);
float _zh056v = 1.0 - smoothstep(float(SSR_RENDER_DISTANCE) * 0.8, float(SSR_RENDER_DISTANCE), _wykyaf);

if (_qpuyyk) {

vec3 _q12rgm = _zu00vj;
_q12rgm.y = 0.0;
float _6texqa = length(_q12rgm);
if (_6texqa < 0.001) _q12rgm = vec3(0.0, 0.0, 1.0);
else _q12rgm /= _6texqa;

vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec3 _x90s48 = normalize(worldPos);
vec3 _abzd1t = reflect(_x90s48, _q12rgm);
_abzd1t.y += 0.15;

float _6cto2c = _a2jf3a.x;
_abzd1t.x += (_6cto2c - 0.5) * 0.12;
_abzd1t.y += (_6cto2c - 0.5) * 0.08;
_abzd1t = normalize(_abzd1t);

vec3 _0dpy3q;
if (_abzd1t.y > 0.0) {
vec3 _3n76ds = normalize(mat3(gbufferModelView) * _abzd1t);
_0dpy3q = _b617kd(_3n76ds, worldPos + cameraPosition, false) * 0.8;
} else {
vec3 _jrbx5b = normalize(vec3(_abzd1t.x, 0.001, _abzd1t.z));
vec3 _84x5hh = normalize(mat3(gbufferModelView) * _jrbx5b);
_0dpy3q = _b617kd(_84x5hh, worldPos + cameraPosition, false) * 0.8;
}

float _0k0ylx = smoothstep(13.0 / 15.0, 14.0 / 15.0, _e3jstl);
_8eveno *= _0k0ylx;

vec3 _69ghbv = _q12rgm;
_69ghbv.y += (_6cto2c - 0.5) * 0.1;
_69ghbv.x += (_6cto2c - 0.5) * 0.05;
_69ghbv = normalize(_69ghbv);
vec3 _kejtti = normalize(mat3(gbufferModelView) * _69ghbv);
vec2 _37nx9n = vec2((_6cto2c - 0.5) * 0.008, (_6cto2c - 0.5) * 0.015);
vec3 _uxy67q = _yssmf1;
_8g66fe(_yssmf1, viewPos, _kejtti, lmcoord, _8eveno * max(_zh056v, 0.001), _37nx9n);
vec3 _1rzokf = _yssmf1 - _uxy67q;
_yssmf1 = _uxy67q;
_yssmf1 += _1rzokf * WATER_BRIGHTNESS;
float _9sn5qt = clamp(length(_1rzokf) * 5.0, 0.0, 1.0);
_yssmf1 = mix(mix(_yssmf1, _0dpy3q, _8eveno), _yssmf1, _9sn5qt);

{
vec3 _mt7k70 = normalize(mat3(gbufferModelView) * _q12rgm);
_mt7k70 = normalize(_mt7k70 + vec3((_6cto2c - 0.5) * 0.5, (_6cto2c - 0.5) * 0.5, 0.0));
vec3 _h19uni = normalize(shadowLightPosition);
vec3 _do5q0z = normalize(-viewPos);
vec3 _k94h2a = normalize(_do5q0z + _h19uni);
float _2znn0w = max(dot(_mt7k70, _k94h2a), 0.0);
float _jadth6 = smoothstep(0.985, 0.995, _2znn0w);
TimeWeightsSimple sideSpecTS = getTimeWeightsSimple(sunAngle);
float _c0lo5q = sideSpecTS.day + sideSpecTS.twilight * 0.7;
float _96rjg8 = 1.0 + sideSpecTS.twilight * 2.0;
float _smcc8x = _jadth6 * _c0lo5q * _e3jstl * _96rjg8;
vec3 _ear2q4 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), sideSpecTS.twilight);
vec3 _w3dtzp = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 _96wo5e = shadowProjection * shadowModelView * vec4(_w3dtzp, 1.0);
vec3 _2cnyn8 = _2y5umb(_96wo5e.xyz / _96wo5e.w);
vec3 _xjw7ed = _2cnyn8 * 0.5 + 0.5;
float _inktnv = 0.0;
if (_xjw7ed.x > 0.0 && _xjw7ed.x < 1.0 && _xjw7ed.y > 0.0 && _xjw7ed.y < 1.0) {
float _0ra2st = texture(shadowtex0, _xjw7ed.xy).r;
_inktnv = step(_xjw7ed.z - 0.001, _0ra2st);
}
_c085da = _yssmf1;
_yssmf1 += _ear2q4 * _smcc8x * WATER_SPECULAR_INTENSITY * _inktnv;
}
} else {

vec3 _uxy67q = _yssmf1;
_8g66fe(_yssmf1, viewPos, normal, lmcoord, _8eveno * max(_zh056v, 0.001), _9sc61v);
vec3 _6g0two = _yssmf1 - _uxy67q;
float wb = WATER_BRIGHTNESS;
_yssmf1 = _uxy67q + _6g0two * wb;

vec3 _bfci6m = normalize(shadowLightPosition);
vec3 _pxuxe9 = normalize(-viewPos);
vec3 _72h9xh = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz + cameraPosition;
float _i5po7g = frameTimeCounter * WATER_WAVE_SPEED;

#define SPEC_HASH(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)
vec3 _850ec7 = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 0.4, _i5po7g * 0.5);
vec3 _38o16g = floor(_850ec7); vec3 _lr78db = fract(_850ec7);
_lr78db = _lr78db * _lr78db * (3.0 - 2.0 * _lr78db);
float _j0jh0s = mix(mix(mix(SPEC_HASH(_38o16g), SPEC_HASH(_38o16g+vec3(1,0,0)), _lr78db.x),
mix(SPEC_HASH(_38o16g+vec3(0,1,0)), SPEC_HASH(_38o16g+vec3(1,1,0)), _lr78db.x), _lr78db.y),
mix(mix(SPEC_HASH(_38o16g+vec3(0,0,1)), SPEC_HASH(_38o16g+vec3(1,0,1)), _lr78db.x),
mix(SPEC_HASH(_38o16g+vec3(0,1,1)), SPEC_HASH(_38o16g+vec3(1,1,1)), _lr78db.x), _lr78db.y), _lr78db.z);
vec3 _qteiii = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 0.9, _i5po7g * 1.2) + vec3(17.0);
vec3 _6vuthm = floor(_qteiii); vec3 _z9c5ak = fract(_qteiii);
_z9c5ak = _z9c5ak * _z9c5ak * (3.0 - 2.0 * _z9c5ak);
float _6750t9 = mix(mix(mix(SPEC_HASH(_6vuthm), SPEC_HASH(_6vuthm+vec3(1,0,0)), _z9c5ak.x),
mix(SPEC_HASH(_6vuthm+vec3(0,1,0)), SPEC_HASH(_6vuthm+vec3(1,1,0)), _z9c5ak.x), _z9c5ak.y),
mix(mix(SPEC_HASH(_6vuthm+vec3(0,0,1)), SPEC_HASH(_6vuthm+vec3(1,0,1)), _z9c5ak.x),
mix(SPEC_HASH(_6vuthm+vec3(0,1,1)), SPEC_HASH(_6vuthm+vec3(1,1,1)), _z9c5ak.x), _z9c5ak.y), _z9c5ak.z);
vec3 _mao7v6 = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 1.8, _i5po7g * 2.0) + vec3(31.0);
vec3 _jlilj6 = floor(_mao7v6); vec3 _wypf73 = fract(_mao7v6);
_wypf73 = _wypf73 * _wypf73 * (3.0 - 2.0 * _wypf73);
float _p12qvd = mix(mix(mix(SPEC_HASH(_jlilj6), SPEC_HASH(_jlilj6+vec3(1,0,0)), _wypf73.x),
mix(SPEC_HASH(_jlilj6+vec3(0,1,0)), SPEC_HASH(_jlilj6+vec3(1,1,0)), _wypf73.x), _wypf73.y),
mix(mix(SPEC_HASH(_jlilj6+vec3(0,0,1)), SPEC_HASH(_jlilj6+vec3(1,0,1)), _wypf73.x),
mix(SPEC_HASH(_jlilj6+vec3(0,1,1)), SPEC_HASH(_jlilj6+vec3(1,1,1)), _wypf73.x), _wypf73.y), _wypf73.z);
#undef SPEC_HASH

float wx = (_j0jh0s - 0.5) * 0.5 + (_6750t9 - 0.5) * 0.3 + (_p12qvd - 0.5) * 0.2;
float wz = (_6750t9 - 0.5) * 0.5 + (_p12qvd - 0.5) * 0.3 + (_j0jh0s - 0.5) * 0.2;

vec3 _l1sqth = normalize(normal + mat3(gbufferModelView) * vec3(wx * 0.5, 0.0, wz * 0.5));
vec3 _e5hu3i = normalize(_pxuxe9 + _bfci6m);
float _ujrze4 = max(dot(_l1sqth, _e5hu3i), 0.0);
TimeWeightsSimple topTS = getTimeWeightsSimple(sunAngle);
float _srk3qw = topTS.day + topTS.twilight * 0.7;
float _bbpwrx = 1.0 + topTS.twilight * 2.0;
float _zytka9 = smoothstep(0.985, 0.995, _ujrze4);
float _kpgt2b = _zytka9 * _srk3qw * _e3jstl * _bbpwrx;
vec3 _t3aag0 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), topTS.twilight);

vec3 _uui686 = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 _lil6a4 = shadowProjection * shadowModelView * vec4(_uui686, 1.0);
vec3 _ptzw8f = _2y5umb(_lil6a4.xyz / _lil6a4.w);
vec3 _oq0cry = _ptzw8f * 0.5 + 0.5;
float _2gxq8x = 0.0;
if (_oq0cry.x > 0.0 && _oq0cry.x < 1.0 && _oq0cry.y > 0.0 && _oq0cry.y < 1.0) {
float _6ampvv = texture(shadowtex0, _oq0cry.xy).r;
_2gxq8x = step(_oq0cry.z - 0.001, _6ampvv);
}
float _4carkr = _kpgt2b * WATER_SPECULAR_INTENSITY * _2gxq8x;
_c085da = _yssmf1;
_yssmf1 += _t3aag0 * _4carkr;
}
}
}

if (_etzcl6 && isEyeInWater != 1) {
vec3 _h6gefa = vec3(
_a2jf3a.z * 2.0 - 1.0,
_a2jf3a.w * 2.0 - 1.0,
0.0
);
_h6gefa.z = sqrt(max(1.0 - _h6gefa.x * _h6gefa.x - _h6gefa.y * _h6gefa.y, 0.0));
vec3 _zs71tl = normalize(mat3(gbufferModelView) * _h6gefa);

vec3 _1y3u2e = vec3(texcoord, _ips7jr);
vec3 _r81jg2 = _1y3u2e * 2.0 - 1.0;
vec4 _sa838t = dhProjectionInverse * vec4(_r81jg2, 1.0);
vec3 _u5ch89 = _sa838t.xyz / _sa838t.w;

float _61doab = 1.0 - abs(dot(normalize(-_u5ch89), _zs71tl));
_61doab *= _61doab;
_61doab *= _61doab;
float _3eupdr = mix(0.3, 1.0, _61doab) * WATER_REFLECTION_FADE;
_3eupdr = clamp(_3eupdr, 0.0, 1.0);

TimeWeightsSimple dhReflTS = getTimeWeightsSimple(sunAngle);
float _bobj8h = dhReflTS.day + dhReflTS.twilight;
float _75fu70 = dhReflTS.night + dhReflTS.blueHour;
float _5f2oo5 = mix(0.15, 1.0, _bobj8h) + _75fu70 * 0.85;

vec3 _18e44z = reflect(normalize(_u5ch89), _zs71tl);
vec3 _xlaso6 = (gbufferModelViewInverse * vec4(_u5ch89, 1.0)).xyz + cameraPosition;
{
float _rtijgp = frameTimeCounter * WATER_WAVE_SPEED;
vec2 _nf2v0q = _xlaso6.xz * WATER_WAVE_SCALE * 2.5;
float _53ketq = sin(_nf2v0q.x * 3.0 + _nf2v0q.y * 0.3 + _rtijgp * 1.5) * 0.5
+ sin(_nf2v0q.x * 5.0 + _nf2v0q.y * 0.5 + _rtijgp * 2.2) * 0.3
+ sin(_nf2v0q.x * 8.0 + _nf2v0q.y * 0.2 + _rtijgp * 3.0) * 0.2;
float _xf4jm8 = sin(_nf2v0q.x * 0.3 + _nf2v0q.y * 3.0 + _rtijgp * 1.3) * 0.5
+ sin(_nf2v0q.x * 0.5 + _nf2v0q.y * 5.0 + _rtijgp * 2.0) * 0.3;
_18e44z.x += _53ketq * 0.005;
_18e44z.z += _xf4jm8 * 0.005;
_18e44z = normalize(_18e44z);
}
float _l8qz4r = mix(0.20, 1.0, _75fu70 / max(_bobj8h + _75fu70, 0.001));
float _dvzuik = max(_bobj8h, _75fu70);
_l8qz4r = mix(0.60, _l8qz4r, _dvzuik);
float _m5fm5g = _75fu70 / max(_bobj8h + _75fu70, 0.001);
float _x4uohz = mix(WATER_SKY_BRIGHTNESS_DAY, WATER_SKY_BRIGHTNESS_NIGHT, _m5fm5g);
_x4uohz = mix(mix(WATER_SKY_BRIGHTNESS_DAY, WATER_SKY_BRIGHTNESS_NIGHT, 0.5), _x4uohz, _dvzuik);
vec3 _o6gp8p = _b617kd(_18e44z, _xlaso6, false) * 1.3;

float _avjypc = WATER_REFLECTION_AMOUNT * _5f2oo5 * _3eupdr * WATER_SKY_REFLECTION * WATER_OPACITY;
float _yycsj2 = 1.0;
_avjypc *= _yycsj2;
float _kmcabm = texelFetch(colortex1, _2l09tc, 0).b;
_avjypc *= smoothstep(13.0 / 15.0, 14.0 / 15.0, _kmcabm);
_avjypc = clamp(_avjypc, 0.0, 1.0);
_yssmf1 = mix(_yssmf1, _o6gp8p, _avjypc);
}
#endif

#ifdef WATER_FOAM_ENABLED
if ((isWater || _etzcl6) && _wowu50 > 0.01 && _iio55e > 0.001 && isEyeInWater != 1) {
vec4 _uvi6pi = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
float _zoab65 = max(-_uvi6pi.z / _uvi6pi.w, 1.0);
int _qit7y2 = clamp(int(_zoab65 * 0.15), 2, 20);
float _c812gk = texelFetch(colortex5, _2l09tc + ivec2(-_qit7y2, 0), 0).x;
float _gjidtf = texelFetch(colortex5, _2l09tc + ivec2( _qit7y2, 0), 0).x;
float _rxuxq7 = abs(_gjidtf - _c812gk);
float _dpxz4g = 0.0;
_yssmf1 *= mix(vec3(1.0), vec3(0.75, 0.88, 0.90), _dpxz4g);
}
#endif

#ifdef MATERIAL_REFLECTIONS_ENABLED
bool _xvtoay = _28w8fp;
bool _ux4ees = _kt17lp;
if (_y9l8xx && isEyeInWater != 1 && !_xvtoay && !_ux4ees) {
if (_2zs1mf < 1.0) {
float _7gjbuw = _a2jf3a.z * 2.0 - 1.0;
float _hyvjmy = _a2jf3a.w * 2.0 - 1.0;
float _7hg859 = sqrt(max(1.0 - _7gjbuw * _7gjbuw - _hyvjmy * _hyvjmy, 0.0));
vec3 _tkgg08 = vec3(_7gjbuw, _hyvjmy, _7hg859);
vec3 _pi9d5v = normalize(mat3(gbufferModelView) * _tkgg08);

float _zjrr00 = MATERIAL_REFLECTION_AMOUNT;
vec3 _53i0wc = vec3(texcoord, _2zs1mf);
vec3 _bhn8ab = _uyoa3r(_53i0wc);

vec3 V = normalize(-_bhn8ab);
float _i9o95p = max(dot(_pi9d5v, V), 0.0);
float _ewltmj = pow(1.0 - _i9o95p, 3.0) * MATERIAL_REFLECTION_FRESNEL;
_zjrr00 = mix(_zjrr00 * 0.4, _zjrr00, _ewltmj);

float _g1b400 = length(_bhn8ab);
float _dbuluw = 1.0 - smoothstep(float(SSR_RENDER_DISTANCE) * 0.8, float(SSR_RENDER_DISTANCE), _g1b400);
_zjrr00 *= _dbuluw;
if (_zjrr00 > 0.001)
_s6xcsn(_yssmf1, _bhn8ab, _pi9d5v, _zjrr00);
}
}
#endif

#if defined(PUDDLES_ENABLED)
{
float rs = clamp(rainStrength, 0.0, 1.0);
float _dhvutn = clamp(PUDDLES_STRENGTH, 0.0, 1.0) * rs;

_dhvutn *= (1.0 - clamp(biome_arid, 0.0, 1.0)) * (1.0 - clamp(biome_snowy, 0.0, 1.0));

float _93d7sl = _cr41tl;
bool _k13xwz = _28w8fp;
if (!isWater && !_kt17lp && !_k13xwz && _dhvutn > 0.0001 && isEyeInWater != 1) {
float _jujpg7 = _93d7sl;
float _13rsme = texelFetch(colortex1, _2l09tc, 0).b;
if (_jujpg7 < 0.9999 && _13rsme > 0.95) {
vec2 px = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0));
vec3 _widkrb = _uyoa3r(vec3(texcoord, _jujpg7));
float dR = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(1, 0)), 0).r;
float dL = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(-1, 0)), 0).r;
float dU = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, -1)), 0).r;
float dD = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, 1)), 0).r;
vec3 vR = _uyoa3r(vec3(texcoord + vec2(px.x, 0.0), dR));
vec3 vL = _uyoa3r(vec3(texcoord - vec2(px.x, 0.0), dL));
vec3 vU = _uyoa3r(vec3(texcoord - vec2(0.0, px.y), dU));
vec3 vD = _uyoa3r(vec3(texcoord + vec2(0.0, px.y), dD));
vec3 _omtxs4 = vR - vL;
vec3 _zq8qas = vD - vU;
vec3 _xg1atf = normalize(cross(_omtxs4, _zq8qas));
vec3 _kgvkrd = normalize(gbufferModelView[1].xyz);
float _oy0rvo = clamp(abs(dot(_xg1atf, _kgvkrd)), 0.0, 1.0);
float _m9yqla = smoothstep(0.85, 0.98, _oy0rvo);

vec3 _h4gwes = (gbufferModelViewInverse * vec4(_widkrb, 1.0)).xyz;
vec3 _virvf6 = _h4gwes + cameraPosition;
float n = _cks7vw(_virvf6.xz * 0.12);
float _quhal2 = smoothstep(0.62, 0.86, n);
_quhal2 = pow(_quhal2, 1.35);
float _6yhcvq = smoothstep(0.56, 0.82, n);
float _aac565 = _quhal2;
float _vb59sc = clamp(_6yhcvq - _aac565, 0.0, 1.0);

float _crbmp4 = _dhvutn * _m9yqla * _quhal2;
if (_crbmp4 > 0.0001) {
float _pwjgx8 = mix(1.0, 0.80, _crbmp4);
_pwjgx8 *= mix(1.0, 0.82, _vb59sc * _dhvutn);
_yssmf1 *= _pwjgx8;
_yssmf1 += vec3(0.03) * _vb59sc * _dhvutn;

vec3 _k8hw2a = normalize(mix(_xg1atf, _kgvkrd, 0.75));
float t = float(frameCounter) * 0.016;
float r1 = sin(_virvf6.x * 18.0 + t * 6.0);
float r2 = sin(_virvf6.z * 21.0 - t * 5.2);
float r3 = sin((_virvf6.x + _virvf6.z) * 14.0 + t * 7.4);
float r4 = sin((_virvf6.x - _virvf6.z) * 32.0 - t * 8.1);
float _pw3lcn = (r1 + r2 + 0.65 * r3 + 0.35 * r4) / 3.0;
float _6cxx97 = 0.014 * rs * _dhvutn;
vec3 _ktlaov = normalize(cross(_kgvkrd, vec3(0.0, 0.0, 1.0)));
if (length(_ktlaov) < 0.01) _ktlaov = normalize(cross(_kgvkrd, vec3(1.0, 0.0, 0.0)));
vec3 _ojhgm9 = normalize(cross(_kgvkrd, _ktlaov));
_k8hw2a = normalize(_k8hw2a + _ktlaov * (_pw3lcn * _6cxx97) + _ojhgm9 * (r2 * _6cxx97 * 0.35));
float _i6s1i1 = _crbmp4 * clamp(PUDDLES_REFLECTION_STRENGTH, 0.0, 1.0);
_i6s1i1 *= mix(0.85, 1.20, _quhal2);
_i6s1i1 *= (1.0 - 0.05 * abs(_pw3lcn) * rs);
_8g66fe(_yssmf1, _widkrb, _k8hw2a, vec2(0.0, 1.0), _i6s1i1, vec2(0.0));
}
}
}
}
#endif

#if defined(WALL_RUNOFF_ENABLED)
{
float rs = clamp(rainStrength, 0.0, 1.0);
float _shwujn = clamp(WALL_RUNOFF_STRENGTH, 0.0, 1.0) * rs;
if (!isWater && _shwujn > 0.0001 && isEyeInWater != 1) {
float _13rsme = texelFetch(colortex1, _2l09tc, 0).b;
float _dx68iw = smoothstep(0.15, 0.60, _13rsme);
if (_dx68iw > 0.001) {
float _flyxix = texelFetch(depthtex2, _2l09tc, 0).r;
if (_flyxix < 0.9999) {
vec2 px = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0));
vec3 _zp3pqx = _uyoa3r(vec3(texcoord, _flyxix));
float _44487g = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(1, 0)), 0).r;
float _u639gk = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(-1, 0)), 0).r;
float _7gt8bb = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, -1)), 0).r;
float _5kcs1f = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, 1)), 0).r;
vec3 _tcm15w = _uyoa3r(vec3(texcoord + vec2(px.x, 0.0), _44487g));
vec3 _o5wxx8 = _uyoa3r(vec3(texcoord - vec2(px.x, 0.0), _u639gk));
vec3 _om64ud = _uyoa3r(vec3(texcoord - vec2(0.0, px.y), _7gt8bb));
vec3 _7yd6bw = _uyoa3r(vec3(texcoord + vec2(0.0, px.y), _5kcs1f));
vec3 _0njql1 = _tcm15w - _o5wxx8;
vec3 _sny3q6 = _7yd6bw - _om64ud;
vec3 _3icj0v = normalize(cross(_0njql1, _sny3q6));
vec3 _9ax0mw = normalize(gbufferModelView[1].xyz);
float _odbw4j = clamp(abs(dot(_3icj0v, _9ax0mw)), 0.0, 1.0);
float _iilw4w = 1.0 - smoothstep(0.30, 0.70, _odbw4j);

vec3 _bdl8m5 = (gbufferModelViewInverse * vec4(_zp3pqx, 1.0)).xyz;
vec3 _t9wask = _bdl8m5 + cameraPosition;

float _uurrfu = _qcukfb(_t9wask.xz * 0.90);
float _0b3yy5 = _t9wask.x * 2.2 + _t9wask.z * 1.7 + _uurrfu * 2.0;
float _pa8k6j = fract(_0b3yy5);
float _7dbvbt = 1.0 - abs(_pa8k6j - 0.5) * 2.0;
_7dbvbt = pow(clamp(_7dbvbt, 0.0, 1.0), 6.0);

float t = float(frameCounter) * 0.016 * clamp(WALL_RUNOFF_SPEED, 0.0, 5.0);
float _9qq73p = fract(_t9wask.y * 1.25 - t + _uurrfu);
float _n5wopi = (1.0 - smoothstep(0.00, 0.10, _9qq73p)) + smoothstep(0.90, 1.00, _9qq73p);
_n5wopi = clamp(_n5wopi, 0.0, 1.0);

float _q4j75g = _shwujn * _dx68iw * _iilw4w * _7dbvbt;
_q4j75g *= mix(0.55, 1.0, _n5wopi);
_q4j75g = clamp(_q4j75g, 0.0, 1.0);

if (_q4j75g > 0.0001) {
_yssmf1 *= mix(1.0, 0.86, _q4j75g);
_yssmf1 += vec3(0.05, 0.06, 0.07) * _q4j75g;
}
}
}
}
}
#endif

if ((isWater || _etzcl6) && isEyeInWater != 1) {
float _qahbnu;
if (_etzcl6) {
vec4 _n80w6r = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _ips7jr * 2.0 - 1.0, 1.0);
_qahbnu = -_n80w6r.z / _n80w6r.w;
} else {
vec4 _4ozgo0 = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_qahbnu = -_4ozgo0.z / _4ozgo0.w;
}

float fogDensity = mix(0.025, 2.0, biome_swamp);
float _bs5gl8 = mix(0.95, 1.0, biome_swamp);
float _o7giip = 1.0 - exp(-_qahbnu * fogDensity);
_o7giip = clamp(_o7giip, 0.0, _bs5gl8);

if (_o7giip > 0.001) {
float _7jexot = fract(sunAngle);
float _u2bg4c = smoothstep(0.40, 0.48, _7jexot) * (1.0 - smoothstep(0.48, 0.55, _7jexot))
+ smoothstep(0.94, 1.0, _7jexot) + (1.0 - smoothstep(0.0, 0.06, _7jexot));
if (_u2bg4c > 0.001) {
float _scsgwb = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1 = mix(_yssmf1, vec3(_scsgwb), _u2bg4c * 0.6);
}
vec3 _w95fch = _xwb441(sunAngle, 1.0, 0.0, 0.0, 0.0, 0.0);
vec3 _34qfhm = vec3(0.04, 0.08, 0.02);
vec3 _e3558u = mix(_w95fch, _34qfhm, biome_swamp);
_yssmf1 *= mix(vec3(1.0), _e3558u * 3.0, _o7giip);
_yssmf1 += _e3558u * _o7giip;
}
}

#ifdef SWAMP_SNAKE_LIGHT_ENABLED
if ((isWater || _etzcl6) && isEyeInWater != 1 && biome_swamp > 0.01) {
float _p8u65t = _etzcl6 ? _ips7jr : _2zs1mf;
vec3 _ze09gm = _uyoa3r(vec3(texcoord, _p8u65t));
vec3 _yvi3je = (gbufferModelViewInverse * vec4(_ze09gm, 1.0)).xyz + cameraPosition;

float st = frameTimeCounter;
vec3 _tpreuc = vec3(
floor(cameraPosition.x / 16.0) * 16.0 + 8.0,
_yvi3je.y,
floor(cameraPosition.z / 16.0) * 16.0 + 8.0
);

vec3 viewDir = normalize(_yvi3je - cameraPosition);
float _29e9cj = 0.0;
int _amohs0 = 6;
float _cunixp = 6.0;
float _ygdc5d = _cunixp / float(_amohs0);

for (int s = 0; s < _amohs0; s++) {
float _n092m6 = _ygdc5d * (float(s) + 0.5);
vec3 _tj3223 = _yvi3je + viewDir * _n092m6;
float _9pz08u = exp(-_n092m6 * 1.0);
for (int i = 0; i < 16; i++) {
float tt = float(i) * 0.8;
float sx = sin(tt * 1.2 + st * 0.4) * 3.0 + sin(tt * 0.5 + st * 0.15) * 6.0;
float sz = cos(tt * 0.9 + st * 0.3) * 4.0 + cos(tt * 0.4 + st * 0.2) * 5.0;
float sy = -0.5 - sin(tt * 1.8 + st * 0.5) * 0.5 - abs(sin(tt * 0.3 + st * 0.1)) * 1.0;
vec3 _eokqru = _tpreuc + vec3(sx, sy, sz);
float _t25r5m = length(_tj3223 - _eokqru);
_29e9cj += _9pz08u / (1.0 + _t25r5m * _t25r5m * 2.0);
}
}
_29e9cj = _29e9cj / float(_amohs0);
_29e9cj = clamp(_29e9cj * 0.25, 0.0, 1.0);
vec3 _f1qzlp = vec3(0.2, 0.55, 0.1);
_yssmf1 += _f1qzlp * _29e9cj * biome_swamp;
}
#endif

if ((isWater || _etzcl6) && isEyeInWater != 1) {
vec3 _m52eep = max(_yssmf1 - _c085da, vec3(0.0));
vec3 _bkb2uq = _xwb441(sunAngle, biome_beach, biome_swamp, biome_jungle, biome_snowy, biome_arid);
vec3 _byu7df = vec3(0.0, 66.0, 102.0) / 255.0;
float _zve5ml = max(max(biome_swamp, biome_jungle), max(biome_snowy, biome_arid));
vec3 _axybuj = mix(_byu7df, _bkb2uq, clamp(_zve5ml, 0.0, 1.0));

float _3m4k0c = dot(_axybuj, vec3(0.299, 0.587, 0.114));
_axybuj = mix(vec3(_3m4k0c), _axybuj, 2.0);
_axybuj = max(_axybuj, vec3(0.0));

float _lnsjgz = mix(0.05, 1.0, texelFetch(colortex1, _2l09tc, 0).b);
_axybuj *= _lnsjgz;
vec3 _l43hgk = mix(_c085da, _axybuj, 0.5);

float _wu2c3e = clamp(_a2jf3a.x - 1.0, 0.0, 1.0);
vec3 _64i9yz = vec3(WATER_FOAM_COLOR_R, WATER_FOAM_COLOR_G, WATER_FOAM_COLOR_B) * WATER_FOAM_INTENSITY;
_yssmf1 = mix(_l43hgk, _64i9yz, _wu2c3e) + _m52eep;
}

bool _alq7tn = (_ehp903.a > 0.55 && _ehp903.a < 0.65);
if (_alq7tn && !isWater && isEyeInWater != 1) {

float _pjr7ix = texelFetch(depthtex1, _2l09tc, 0).r;
if (_pjr7ix < 0.9999) {
vec4 _u23w6d = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _pjr7ix * 2.0 - 1.0, 1.0);
vec3 _lxgxz8 = _u23w6d.xyz / _u23w6d.w;
vec3 _56y4vu = (gbufferModelViewInverse * vec4(_lxgxz8, 1.0)).xyz + cameraPosition;
if (_56y4vu.y < float(SEA_LEVEL_OFFSET)) {

vec3 _jhaerz = normalize(_lxgxz8);
vec3 _f5cpm7 = normalize(mat3(gbufferModelView) * vec3(0.0, 1.0, 0.0));
vec3 _t1av1s = reflect(_jhaerz, _f5cpm7);
vec3 _7ba7i5 = mat3(gbufferModelViewInverse) * _t1av1s;
vec3 _mm54g9 = _b617kd(_t1av1s, _56y4vu, false) * WATER_SKY_REFLECTION;
float _tvf7ga = 1.0 - abs(dot(normalize(-_lxgxz8), _f5cpm7));
_tvf7ga = _tvf7ga * _tvf7ga * _tvf7ga;
float _jdxrxc = mix(0.2, 0.8, _tvf7ga) * WATER_OPACITY;
_yssmf1 = mix(_yssmf1, _mm54g9, _jdxrxc);
}
}
}

#endif

#endif

if (isEyeInWater == 1) {
float _8db01s = texture(depthtex0, texcoord).r;
if (_8db01s < 1.0) {
vec4 _fvg5u7 = vec4(texcoord * 2.0 - 1.0, _8db01s * 2.0 - 1.0, 1.0);
vec4 _7oho7s = gbufferProjectionInverse * _fvg5u7;
_7oho7s /= _7oho7s.w;
float _4tgkt5 = length(_7oho7s.xyz);
float _pp1xrs = smoothstep(0.0, 40.0, _4tgkt5) * 0.6;
vec3 _fjnc3n = vec3(UNDERWATER_FOG_R, UNDERWATER_FOG_G, UNDERWATER_FOG_B);
float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _l43hgk = _zdxp7g * _fjnc3n;
_yssmf1 = mix(_yssmf1, _l43hgk, _pp1xrs);
}
}

gl_FragData[0] = vec4(_yssmf1, _xszwck);
}
