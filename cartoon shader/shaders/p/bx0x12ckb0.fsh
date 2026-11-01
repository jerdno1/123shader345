/* RENDERTARGETS: 11 */

#include "/settings.glsl"

#ifdef WEATHER_FOG_ENABLED

#include "/include/shadow.glsl"
#include "/include/biome_overrides.glsl"

#ifdef LPV_ENABLED
#include "/include/lpv/lpv_common.glsl"
#endif

in vec2 texcoord;

uniform sampler2D colortex1;
uniform sampler2D colortex5;
uniform sampler2D colortex11;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D dhDepthTex;
uniform sampler2D shadowtex0;
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 dhProjectionInverse;
uniform mat4 vxProjInv;
uniform sampler2D vxDepthTexTrans;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform float sunAngle;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float dhNearPlane;
uniform float dhFarPlane;
uniform float rainStrength;
uniform float thunderStrength;
uniform float frameTimeCounter;
uniform int frameCounter;
uniform int biome;
uniform int biome_category;
uniform int isEyeInWater;
uniform ivec2 eyeBrightnessSmooth;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;

#ifdef LPV_ENABLED
uniform sampler3D lpvLightSamplerA;
uniform sampler3D lpvLightSamplerB;

vec3 _1ug1pu(vec3 uv) {
return (frameCounter & 1) == 0 ? textureLod(lpvLightSamplerA, uv, 0.0).rgb : textureLod(lpvLightSamplerB, uv, 0.0).rgb;
}

vec3 _nbuceq(vec3 worldPos) {
vec3 _h4gwes = worldPos - cameraPosition;
vec3 _8ejcsz = _cs4po4(_h4gwes, cameraPosition);
if (!_x3urej(_8ejcsz)) return vec3(0.0);

vec3 uv = _8ejcsz / _fsho2m;
vec3 _uq5wib = _hvneao(_1ug1pu(uv)) * WEATHER_FOG_LPV_STRENGTH;
return _625ydm(_uq5wib, 0.018, 0.006);
}
#endif

#include "/include/noise.glsl"
#include "/include/sky_timeline.glsl"
#include "/include/depth_utils.glsl"

#ifdef LIGHTNING_ENABLED
#include "/include/lightning.glsl"
#endif

vec3 _3cp1j2(float _hrymrq) {
TimeWeights tw = getTimeWeights(sunAngle);

vec3 _9fpt1m      = vec3(DAY_ZENITH_R,      DAY_ZENITH_G,      DAY_ZENITH_B);
vec3 _vqy7od   = vec3(SUNSET_ZENITH_R,   SUNSET_ZENITH_G,   SUNSET_ZENITH_B);
vec3 _rb85u3 = vec3(BLUEHOUR_ZENITH_R,  BLUEHOUR_ZENITH_G,  BLUEHOUR_ZENITH_B);
vec3 _jl63ac    = vec3(NIGHT_ZENITH_R,     NIGHT_ZENITH_G,     NIGHT_ZENITH_B);
vec3 _d56bsq  = vec3(SUNRISE_ZENITH_R,   SUNRISE_ZENITH_G,   SUNRISE_ZENITH_B);

vec3 _riel36 = _9fpt1m      * tw.day
+ _vqy7od   * tw.sunset
+ _rb85u3 * tw.blueHour
+ _jl63ac    * tw.night
+ _d56bsq  * tw.sunrise;

float _rkfcys = dot(_riel36, vec3(0.299, 0.587, 0.114));
_riel36 = mix(vec3(_rkfcys), _riel36, 0.5);
_riel36 *= vec3(0.7, 0.75, 1.0);

float _4hoxs4 = clamp(tw.night + tw.blueHour * 0.35, 0.0, 1.0);
float _45isel = mix(0.7, 0.9, _4hoxs4);
return _riel36 * WEATHER_FOG_BRIGHTNESS * _hrymrq * _45isel;
}

void main() {

vec2 _duy16z = (floor(gl_FragCoord.xy) / FOG_RENDER_SCALE + 0.5) / vec2(viewWidth, viewHeight);
#define texcoord _duy16z

float _gj2dau = _2vpc5n(biome_swamp, biome, biome_category);
if (rainStrength < 0.01 && _gj2dau < 0.01) {
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

if (isEyeInWater == 1) {
gl_FragData[0] = vec4(0.0);
return;
}

float _2zs1mf = texture(depthtex0, texcoord).r;
float _b8i8m4 = texture(depthtex1, texcoord).r;
float vxDepth = texture(vxDepthTexTrans, texcoord).r;
bool _pgh3p7 = _2fqi4q(vxProjInv) && _7bqo1l(vxDepth);
vec4 _alcc4c = texture(colortex1, texcoord);

bool _rv9f3n = (_alcc4c.a > 0.999 && !_7bqo1l(_2zs1mf));
bool _d293zd = (_2zs1mf < _b8i8m4 - 0.00001);
bool _ux4ees = (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);
bool _0t1n6k = _d293zd && (texture(colortex5, texcoord).y > 0.9);

float _1r3mt9;
bool _nwgn5g = false;
if (_ux4ees) {
_1r3mt9 = _2zs1mf;
} else if (_0t1n6k && _7bqo1l(_2zs1mf)) {

_1r3mt9 = _2zs1mf;
} else if (_pgh3p7 && (_d293zd || _rv9f3n)) {
_1r3mt9 = vxDepth;
_nwgn5g = true;
} else if (_d293zd) {

_1r3mt9 = _7bqo1l(_b8i8m4) ? _b8i8m4 : _2zs1mf;
} else {
_1r3mt9 = _2zs1mf;
}
float _ips7jr = texture(dhDepthTex, texcoord).r;
vec3 _003it1;
bool _rac6bf = _7bqo1l(_1r3mt9) && _cwcjr4(
_nwgn5g ? vxProjInv : gbufferProjectionInverse,
gbufferModelViewInverse,
cameraPosition,
texcoord,
_1r3mt9,
_003it1);
vec3 _0x5uwo;
bool _aa77op = _yfr6tv(_ips7jr) && _cwcjr4(
dhProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _ips7jr, _0x5uwo);
bool _yjolhc = !_rac6bf && !_aa77op;

vec3 _q62x7r;
float _cunixp;

if (_rac6bf) {
vec3 _ys8kd8 = _003it1 - cameraPosition;
_q62x7r = _lcgfcm(_ys8kd8, vec3(0.0, 0.0, -1.0));
_cunixp = length(_ys8kd8);
} else if (_aa77op) {
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
_cunixp = 256.0;
}

_cunixp = min(_cunixp, 256.0);

float _xx5ojq = WEATHER_FOG_NEAR_DIST;
float _q92vvk  = _cunixp;

if (_xx5ojq >= _q92vvk) {
gl_FragData[0] = vec4(0.0);
return;
}

vec3 _jfq4wz = vec3(-1.0, -0.3, 0.0) * frameTimeCounter * 12.0;

float _qa3kxp = texelFetch(noisetex, ivec2(gl_FragCoord.xy) & 255, 0).b;
float _izh8vx = fract(_qa3kxp + float(frameCounter) * 0.6180339887);

float _huatah = fract(sunAngle);
float _xya605 = smoothstep(0.02, 0.08, _huatah) * (1.0 - smoothstep(0.44, 0.52, _huatah));
float _h0gyrr = smoothstep(0.55, 0.62, _huatah) * (1.0 - smoothstep(0.90, 0.96, _huatah));
float _hrymrq = max(_xya605, _h0gyrr * 0.30);
TimeWeights twWeather = getTimeWeights(sunAngle);
float _1vsx0o = clamp(twWeather.night + twWeather.blueHour * 0.35, 0.0, 1.0);

vec3 fogColor = _3cp1j2(_hrymrq);

float _obst5k = _dfzmvk(biome_snowy, biome, biome_category);
float _qjyghv = _avnajg(biome_jungle, biome, biome_category, _gj2dau);
float _x5lo9i = _j4acyp(biome_arid, biome, biome_category);
float _diiukt = _g4a6za(_huw7hc(biome_savanna, biome, biome_category), _gj2dau);
float _gd0a4v = max(max(max(_obst5k, _qjyghv), max(_gj2dau, _x5lo9i)), _diiukt);
if (_gd0a4v > 0.001) {
vec3 _u1dd2i = _af4aog(vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B), _obst5k, _qjyghv, _gj2dau, _x5lo9i, _diiukt);
float _czc6ae = dot(_u1dd2i, vec3(0.299, 0.587, 0.114));
_u1dd2i = mix(vec3(_czc6ae), _u1dd2i, 0.6);
_u1dd2i *= _hrymrq * WEATHER_FOG_BRIGHTNESS * 0.7;
fogColor = mix(fogColor, _u1dd2i, 0.6 * _gd0a4v);
}

TimeWeights twFog = getTimeWeights(sunAngle);
float _b65phk = twFog.sunset + twFog.sunrise;
vec3 _9cn7gb = vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B) * SUNSET_BRIGHTNESS;
vec3 _ttpo7r = vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B) * SUNRISE_BRIGHTNESS;
vec3 _r8ov9p = (_9cn7gb * twFog.sunset + _ttpo7r * twFog.sunrise) / max(_b65phk, 0.001);

if (_b65phk > 0.01) {
fogColor = mix(fogColor, _r8ov9p * 0.5, _b65phk * 0.4);
}

vec3 _plv7zr = vec3(0.0);
float _iohhbc = 0.0;
if (_gj2dau > 0.01) {
_plv7zr = vec3(30.0, 55.0, 25.0) / 255.0;
_plv7zr *= _hrymrq * 3.0;

if (_b65phk > 0.01) {
_plv7zr = mix(_plv7zr, _r8ov9p * 0.4, _b65phk * 0.5);
}
fogColor = mix(fogColor, _plv7zr, _gj2dau);
_iohhbc = 1.5 * _gj2dau;
}

float _b236qi = 0.0;
float _luj2br = 0.0;
float _y0hmij = 0.0;
float _cxne57 = clamp(thunderStrength, 0.0, 1.0);
vec2 _rcelga = vec2(1.0, 0.0);
vec3 _horbfl = vec3(0.0);
vec3 _0rch43 = vec3(0.0);
float _vpy0ue = 0.0;
float _n5d40t = 1.0;
float _7rz8sv = 1.0;
#ifdef STORM_EFFECTS_ENABLED

_b236qi = clamp(biome_arid, 0.0, 1.0) * rainStrength;
_luj2br = max(clamp(biome_snowy, 0.0, 1.0) - _gj2dau * 0.5, 0.0) * rainStrength;
_y0hmij = max(_b236qi, _luj2br);
if (_y0hmij > 0.005) {

float _47oojb = 0.7 + frameTimeCounter * 0.00035 + 0.35 * sin(frameTimeCounter * 0.0011);
_rcelga = vec2(cos(_47oojb), sin(_47oojb));

_vpy0ue = frameTimeCounter * 30.0;

float _7m7xw9 = clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0);
float _8wr19l = smoothstep(0.55, 0.85, _7m7xw9);
_n5d40t = _8wr19l;
float _9jj8fe = texture(depthtex0, texcoord).r;
bool _bjswrg = (_9jj8fe > 0.00001 && _9jj8fe < 0.999999);
float _a7c882 = _bjswrg ? texture(colortex1, texcoord).b : 1.0;
float _y5im7o = smoothstep(0.80, 0.95, _a7c882);
_7rz8sv = mix(_y5im7o, 1.0, _8wr19l);

_horbfl = vec3(0.69411765, 0.61176471, 0.43921569);
_horbfl *= max(_hrymrq, 0.18) * WEATHER_FOG_BRIGHTNESS;

_0rch43 = mix(vec3(0.86, 0.92, 1.04), vec3(0.52, 0.60, 0.76), _cxne57 * 0.55);
_0rch43 *= max(_hrymrq, 0.30) * WEATHER_FOG_BRIGHTNESS;

if (_b65phk > 0.01) {
vec3 _m3i92k = vec3(1.00, 0.46, 0.16) * max(_hrymrq, 0.18) * WEATHER_FOG_BRIGHTNESS;
float _3fa7k5 = clamp(twFog.sunset / max(_b65phk, 0.001), 0.0, 1.0);
vec3 _gntwx1 = mix(_r8ov9p * 0.55, _m3i92k, _3fa7k5);
_horbfl = mix(_horbfl, _gntwx1, _b65phk * 0.35);
_0rch43 = mix(_0rch43, _r8ov9p * 0.45, _b65phk * 0.35);
}
}
#endif

float _6kg161 = 1.0 + rainStrength * WEATHER_FOG_THUNDER_BOOST;
float _3tqs27 = WEATHER_FOG_DENSITY * rainStrength * _6kg161 * mix(1.0, 2.0, _1vsx0o);

float _30qw16 = _q92vvk - _xx5ojq;
const float _8v1l5h = 11.0;
float _oye91j = float(WEATHER_FOG_STEPS);
float _6xx26u = 8.0 / max(_oye91j, 1.0);
float _djp31v = 0.08 * _6xx26u;
float _bx6134 = 0.50 * _6xx26u;

vec3  _mq5jbs = vec3(0.0);
float _8gkfsz = 1.0;

for (int i = 0; i < WEATHER_FOG_STEPS; i++) {
float _mkwf4n = (float(i) + _izh8vx) / _oye91j;
float _h47e53 = pow(_8v1l5h, _mkwf4n);
float _f9690x = (_h47e53 - 1.0) / (_8v1l5h - 1.0);
float _0mekoi = _h47e53 * log(_8v1l5h) / _oye91j / (_8v1l5h - 1.0) * _30qw16;
float t = _xx5ojq + _f9690x * _30qw16;
vec3 _tj3223 = cameraPosition + _q62x7r * t;
float _juih12 = smoothstep(float(SEA_LEVEL_OFFSET), float(SEA_LEVEL_OFFSET) + 2.0, _tj3223.y);

vec3 _kia2vw = (_tj3223 + _jfq4wz) * WEATHER_FOG_NOISE_SCALE;
float _b81968 = _lpglwu(_kia2vw);

float _zt598w = smoothstep(0.2, 0.65, _b81968);

float _36zwff = smoothstep(WEATHER_FOG_NEAR_DIST, max(WEATHER_FOG_FAR_DIST, WEATHER_FOG_NEAR_DIST + 0.001), t);

float _6zh0ul = _zt598w * _36zwff * _3tqs27 * 0.002;

_6zh0ul *= 1.0 - 0.6 * _y0hmij * _juih12;

if (_gj2dau > 0.01) {
vec3 _vjygmv = (_tj3223 + _jfq4wz * 0.3) * 0.04;
float _i00tfc = _lpglwu(_vjygmv);
float _jiehhn = smoothstep(0.25, 0.6, _i00tfc);
float _s7x3pz = smoothstep(8.0, 80.0, t);
float _200b2u = _jiehhn * _s7x3pz * _iohhbc * 0.01;
if (_200b2u * _0mekoi > 0.0001) {
float _q4ry2v = min(_200b2u * _0mekoi, _djp31v);
float _bh1m6f = _8gkfsz * (1.0 - exp(-_q4ry2v));
_mq5jbs += _plv7zr * _bh1m6f;
_8gkfsz *= exp(-_q4ry2v);
}
}

#ifdef STORM_EFFECTS_ENABLED
if (_y0hmij > 0.005) {
float _9f57y8  = dot(_tj3223.xz, _rcelga);
float _mybu6k = dot(_tj3223.xz, vec2(-_rcelga.y, _rcelga.x));

const vec2 _7lx1zk = vec2(0.7682, 0.6402);
vec2 _2wxt1u = (_tj3223.xz - _7lx1zk * frameTimeCounter * 6.0) / 380.0;
float _o0bq61 = _lpglwu(vec3(_2wxt1u.x, _2wxt1u.y, frameTimeCounter * 0.004));
float _ztz5om = smoothstep(0.30, 0.62, _o0bq61);

vec3 _i81nd3 = vec3((_9f57y8 - _vpy0ue) * 0.014, _tj3223.y * 0.05, _mybu6k * 0.05);
float _ooobbl = smoothstep(0.25, 0.80, _lpglwu(_i81nd3));

vec3 _ob7usi = vec3((_9f57y8 - _vpy0ue * 2.2) * 0.009, _tj3223.y * 0.012, _mybu6k * 0.016);
float _zsi6j6 = smoothstep(0.56, 0.82, _lpglwu(_ob7usi)) * STORM_GUST_INTENSITY;
_zsi6j6 *= 0.35 + 0.65 * _ztz5om;

vec3 _wh865z = vec3((_9f57y8 - _vpy0ue * 1.6) * 0.05, _tj3223.y * 0.17, _mybu6k * 0.20);
float _m45p82 = _lpglwu(_wh865z);

float _apagox = _tj3223.y - cameraPosition.y;
float _8azvbo = exp(-max(_apagox + 6.0, 0.0) / 16.0);
float _41wh6c = mix(0.35, 1.0, _8azvbo);
float _vopozz = sin(_tj3223.y * 0.30 + _vpy0ue * 0.22 + _mybu6k * 0.07) * 0.5 + 0.5;
float _h905es = mix(0.70, 1.0, _vopozz);

float _bzguwn = 0.50 + 0.50 * (_ooobbl * (0.55 + 0.45 * _m45p82));
_bzguwn += _zsi6j6 * 0.45;
_bzguwn = mix(_bzguwn, floor(_bzguwn * 4.0 + 0.5) * 0.25, 0.55);

float _nfzti5 = smoothstep(2.0, 18.0, t);

float _c0vk7j = clamp(t / max(_q92vvk, 1.0), 0.0, 1.0);
float _oy7p4r = mix(_n5d40t, _7rz8sv, _c0vk7j);

float _am55ef = _b236qi * _bzguwn * _41wh6c * _juih12;
float _gtkqq7 = _luj2br * _bzguwn * _h905es * _juih12;

float _g8ce28 = 3.0 / max(float(STORM_VIEW_DISTANCE), 8.0);
float _em3sdi = mix(0.10, 1.45, _ztz5om);
float _txnnem = (_am55ef + _gtkqq7) * _nfzti5 * _em3sdi * _oy7p4r
* (1.0 + 0.8 * _cxne57) * _g8ce28 * STORM_DENSITY;

if (_txnnem * _0mekoi > 0.0001) {

float _1suahp = min(_txnnem * _0mekoi, _bx6134);
float _s7gts3 = _8gkfsz * (1.0 - exp(-_1suahp));
vec3 _ohpz1a = (_am55ef * _horbfl + _gtkqq7 * _0rch43) / max(_am55ef + _gtkqq7, 0.0001);

_ohpz1a *= 1.0 + _zsi6j6 * 0.30;
#ifdef LIGHTNING_ENABLED

_ohpz1a += vec3(LIGHTNING_R, LIGHTNING_G, LIGHTNING_B) * _w8638d(_tj3223, frameTimeCounter, thunderStrength);
#endif
_mq5jbs += _ohpz1a * _s7gts3;
_8gkfsz *= exp(-_1suahp);
}
}
#endif

if (_6zh0ul * _0mekoi > 0.000001) {

float shadow = 1.0;
#ifdef SHADOWS_ENABLED
{
vec3 _h4gwes = _tj3223 - cameraPosition;
vec4 _cxdyc5 = shadowModelView * vec4(_h4gwes, 1.0);
vec4 _kffjyx = shadowProjection * _cxdyc5;
vec3 _785h0z = _2y5umb(_kffjyx.xyz);
vec3 _i1hwjb = _785h0z * 0.5 + 0.5;
_i1hwjb.z -= 0.0005;

if (_i1hwjb.x > 0.0 && _i1hwjb.x < 1.0 &&
_i1hwjb.y > 0.0 && _i1hwjb.y < 1.0 &&
_i1hwjb.z > 0.0 && _i1hwjb.z < 1.0) {
shadow = step(_i1hwjb.z, textureLod(shadowtex0, _i1hwjb.xy, 0.0).r);
}
}
#endif

#ifdef STORM_EFFECTS_ENABLED

shadow = mix(shadow, 1.0, clamp(_y0hmij * 1.25, 0.0, 1.0));
#endif

float _f7hei2 = min(_6zh0ul * _0mekoi, _djp31v);
float _2w7t73 = min(_6zh0ul * shadow * _0mekoi, _djp31v);
float _xmu2lh = exp(-_f7hei2);
float _xr0xap = _8gkfsz * (1.0 - _xmu2lh);
float _ugmnua = _8gkfsz * (1.0 - exp(-_2w7t73));

#ifdef LIGHTNING_ENABLED
{
float _tdvc8u = _w8638d(_tj3223, frameTimeCounter, thunderStrength);
_mq5jbs += vec3(LIGHTNING_R, LIGHTNING_G, LIGHTNING_B) * _ugmnua * _tdvc8u;
}
#endif

#ifdef LPV_ENABLED
vec3 _aurzx6 = _nbuceq(_tj3223);
_mq5jbs += _aurzx6 * _xr0xap;
#endif

_mq5jbs += fogColor * _ugmnua;
_8gkfsz *= _xmu2lh;
}

if (_8gkfsz < 0.01) break;
}

float _9gel4l = 1.0 - _8gkfsz;

gl_FragData[0] = vec4(_mq5jbs, _9gel4l);
#undef texcoord
}

#else

in vec2 texcoord;

void main() {
gl_FragData[0] = vec4(0.0);
}

#endif
