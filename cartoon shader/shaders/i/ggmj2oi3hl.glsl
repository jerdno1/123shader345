#ifndef LIGHTING_GLSL
#define LIGHTING_GLSL

#include "/include/color_utils.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/sky_timeline.glsl"

#ifdef LPV_ENABLED
#include "/include/lpv/lpv_sample.glsl"
#endif

uniform float rainStrength;

uniform vec3 skyColor;
float _joda6y = 0.0;

#ifdef LPV_ENABLED
vec3 _osnipo = vec3(0.0);
vec3 _5pkrr5 = vec3(0.0, 1.0, 0.0);

vec3 _pis44d = vec3(0.75);

float _06143i = 0.5;
float _n7k2vf = 1.0;
float _x3j9yv = 1.0;
#endif

uniform int biome;

#ifndef IS_IRIS
#define eyePosition cameraPosition
#else
uniform vec3 eyePosition;
#endif

#ifdef HANDHELD_LIGHT_ENABLED
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;
uniform int heldItemId;
uniform int heldItemId2;
#endif

vec3 _a9dot3(vec3 c);
vec3 _dr1k12(float sunAngle);
vec3 _cixggx();

float _7q50sc(vec3 _tkgg08) {
if (_tkgg08.y > 0.5) return 1.0;
if (_tkgg08.y < -0.5) return 0.85;
if (abs(_tkgg08.z) > 0.5) return 0.92;
return 0.88;
}

#ifdef HANDHELD_LIGHT_ENABLED
vec3 _q9oroj(int _kiyxjg) {
if (_kiyxjg == 10021 || _kiyxjg == 10043) return vec3(0.3, 0.7, 1.0);
if (_kiyxjg == 10087 || _kiyxjg == 10089) return vec3(0.3, 1.0, 0.4);
if (_kiyxjg == 10038 || _kiyxjg == 10058) return vec3(1.0, 0.2, 0.2);
return vec3(1.0, 0.75, 0.4);
}

vec3 _6p2kch(vec3 worldPos, vec3 _x2q5fe, vec3 _hj0fjq) {
float _ouy0o9 = clamp(float(max(heldBlockLightValue,  0)) / 15.0, 0.0, 1.0);
float _hv3ogm  = clamp(float(max(heldBlockLightValue2, 0)) / 15.0, 0.0, 1.0);

float _fxd0rw = max(_ouy0o9, _hv3ogm);
if (_fxd0rw < 0.001) return vec3(0.0);

vec3 _7g9o9b = eyePosition - vec3(0.0, 0.5, 0.0);
vec3 _ic9jj6 = worldPos - _7g9o9b;

float _nr5rfo = max(HANDHELD_LIGHT_RADIUS, 0.01);

float _rpr2uc = sqrt(_ic9jj6.x * _ic9jj6.x + _ic9jj6.z * _ic9jj6.z);
float _vtb30n = max(abs(_ic9jj6.y) - 1.0, 0.0);
float _t25r5m = sqrt(_rpr2uc * _rpr2uc + _vtb30n * _vtb30n);

float t = clamp(_t25r5m / _nr5rfo, 0.0, 1.0);
float _pvqx2j = 1.0 - t * t;
_pvqx2j = _pvqx2j * _pvqx2j * _pvqx2j;

float _0v7t0i = _fxd0rw * _pvqx2j * HANDHELD_LIGHT_STRENGTH;

float _1tsheg = max(_ouy0o9 + _hv3ogm, 0.001);
vec3 tint = (_q9oroj(heldItemId)  * _ouy0o9 +
_q9oroj(heldItemId2) * _hv3ogm) / _1tsheg;

vec3 _mxcjdz = _x2q5fe * tint * _0v7t0i;
vec3 _hu0rvg = _hj0fjq + _mxcjdz - _hj0fjq * _mxcjdz;
return max(_hu0rvg - _hj0fjq, vec3(0.0));
}
#endif

vec3 _ojotku(vec3 c, float _dqsjiy, float _1sf1fx) {
c = max(c, vec3(0.0));

float _zdxp7g = dot(c, vec3(0.299, 0.587, 0.114));
c = mix(vec3(_zdxp7g), c, max(_dqsjiy, 0.0));

vec3 _s0lzby = _j0nlr9(clamp(c, vec3(0.0), vec3(10.0)));
float v = clamp(_1sf1fx, 0.0, 2.0);
_s0lzby.y = clamp(_s0lzby.y + (1.0 - _s0lzby.y) * v * (1.0 - _s0lzby.y), 0.0, 1.0);
return _ks5u3i(_s0lzby);
}

float _hrakns(float sunAngle) {
TimeWeights tw = getTimeWeights(sunAngle);
return smoothstep(0.5, 0.9, tw.day);
}

vec3 _ptm956() {

float _1jqf3t = dot(skyColor, vec3(0.299, 0.587, 0.114));
if (_1jqf3t <= 0.0005) return vec3(1.0);
return _a9dot3(skyColor);
}

vec3 _sw5n74(float sunAngle) {

vec3 _jqmu3t = _dr1k12(sunAngle);
vec3 biome = mix(vec3(1.0), _ptm956(), _hrakns(sunAngle));
return _a9dot3(_jqmu3t * biome);
}

vec3 _m20mte() {

vec3 _1zva4i = vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B);
vec3 _wj125h = _a9dot3(_1zva4i);
float _i6p65k = dot(_wj125h, vec3(0.299, 0.587, 0.114));

return _a9dot3(mix(vec3(_i6p65k), _wj125h, 0.08));
}

vec3 _2ielw1() {
vec3 _wj125h = _m20mte();
float _4knsqu = clamp(SKYLIGHT_TINT_LIGHT_SATURATION, 0.0, 1.0);
float _b7pzhz = mix(1.0, SKYLIGHT_TINT_SATURATION, _4knsqu);
vec3 _e4evbv = _a9dot3(_ojotku(_wj125h, _b7pzhz, 0.0));
float _q6g7qd = dot(_e4evbv, vec3(0.299, 0.587, 0.114));

return _a9dot3(mix(vec3(_q6g7qd), _e4evbv, 0.08));
}

vec4 _utlnv9(float sunAngle) {
vec2 bd = _bxr2n6(sunAngle);

return vec4(bd.x, 0.0, 0.0, bd.y);
}

vec3 _a9dot3(vec3 c) {

float _zdxp7g = dot(c, vec3(0.299, 0.587, 0.114));
vec3 n = c / max(_zdxp7g, 0.35);
return clamp(n, vec3(0.0), vec3(2.0));
}

#ifdef LPV_ENABLED
vec3 _q81bhd(vec3 _a3mynb, float _6u99ju) {
float _rkfcys = clamp(_6u99ju, 0.0, 1.0);
float _6qwad8 = max(max(_a3mynb.r, _a3mynb.g), _a3mynb.b);
float _aslobc = min(min(_a3mynb.r, _a3mynb.g), _a3mynb.b);
float _aitjxw = _6qwad8 - _aslobc;

float _5imjdt = smoothstep(0.18, 0.88, _rkfcys);
float _gch391 = smoothstep(0.72, 0.98, _rkfcys) * (1.0 - smoothstep(0.05, 0.22, _aitjxw));
float _k5las6 = 1.0 - 0.20 * _gch391;
float _a74jn9 = (1.0 + 0.55 * pow(_5imjdt, 0.85)) * _k5las6;
return vec3(_a74jn9);
}

vec3 _9mtd5j(vec3 _w6wkch, vec3 _a3mynb, vec3 _rcgl8l) {
return _w6wkch + _a3mynb * _rcgl8l;
}
#endif

vec3 _dr1k12(float sunAngle) {
TimeWeights tw = getTimeWeights(sunAngle);

vec3 _izx33b     = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);
vec3 _3j6u6t  = vec3(SUNSET_ZENITH_R, SUNSET_ZENITH_G, SUNSET_ZENITH_B);
vec3 _c0to6q    = vec3(BLUEHOUR_ZENITH_R, BLUEHOUR_ZENITH_G, BLUEHOUR_ZENITH_B);
vec3 _1zva4i   = vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B);
vec3 _5voxlc = vec3(SUNRISE_ZENITH_R, SUNRISE_ZENITH_G, SUNRISE_ZENITH_B);
vec3 _qnqdx2    = vec3(DAWN_ZENITH_R, DAWN_ZENITH_G, DAWN_ZENITH_B);

vec3 _od2x3w = _izx33b     * tw.day
+ _3j6u6t  * tw.sunset
+ _c0to6q    * tw.blueHour
+ _1zva4i   * tw.night
+ _5voxlc * tw.sunrise
+ _qnqdx2    * tw.dawn;

float _92388v = min(tw.day, tw.sunset) * 2.0;
_od2x3w = mix(_od2x3w, vec3(0.9, 0.15, 0.85), _92388v * 0.5);
float _4am4t1 = min(tw.sunset, tw.blueHour) * 2.0;
_od2x3w = mix(_od2x3w, vec3(0.4, 0.1, 1.0), _4am4t1 * 0.5);

return _a9dot3(_od2x3w);
}

vec3 _cixggx() {
vec3 _izx33b = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);
return _a9dot3(_izx33b);
}

float _ikvd4g(float skylight) {
float _8ores8 = clamp(skylight, 0.0, 1.0);
return _8ores8 / (4.0 - 3.0 * _8ores8);
}

float _ey5sk0(float _8ores8) {
return floor(clamp(_8ores8, 0.0, 1.0) * 15.0 + 0.001);
}

float _ukv2q2(float skylight) {

return smoothstep(1.0 / 15.0, 2.0 / 15.0, clamp(skylight, 0.0, 1.0));
}

float _ufelhq(float skylight) {
return 1.0 - _ukv2q2(skylight);
}

float _qwoqln(float blocklight) {
return 1.0 - smoothstep(0.0, 4.0 / 15.0, clamp(blocklight, 0.0, 1.0));
}

float _171d84(float blocklight, float skylight) {
float x = clamp(blocklight, 0.0, 1.0);
float _jja8pn = x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
_jja8pn *= smoothstep(0.0, 0.15, blocklight);
return _jja8pn;
}

vec3 _5gdxs5(float _0v7t0i) {
vec3 _2o4l82 = vec3(1.0, 0.9, 0.8);
return _2o4l82 * _0v7t0i * _0v7t0i * BLOCKLIGHT_BRIGHTNESS;
}

float _63yk0w(float _y22te0, float skylight, float blocklight) {
float _h0gyrr = 1.0 - smoothstep(0.0, 0.35, _y22te0);
float _bvx9v2 = _ukv2q2(skylight);
float _fbq83g = 1.0 - smoothstep(0.45, 0.95, blocklight);
return NIGHT_DARKNESS * _h0gyrr * _bvx9v2 * _fbq83g;
}

float _37o4le(float _y22te0, float skylight, float blocklight) {
float _xya605 = smoothstep(0.28, 0.88, _y22te0);
float _bvx9v2 = _ukv2q2(skylight);
float _fbq83g = 1.0 - smoothstep(0.30, 0.95, blocklight);
float _7yk8g4 = float(SKY_RAIN_DARKNESS) / 100.0;
return rainStrength * _xya605 * _bvx9v2 * _fbq83g * _7yk8g4;
}

float _twjs8h(float _y22te0, float skylight, float blocklight) {
float _xya605 = smoothstep(0.28, 0.88, _y22te0);
float _bvx9v2 = _ukv2q2(skylight);
float _fbq83g = 1.0 - smoothstep(0.30, 0.95, blocklight);
return clamp(biome_pale_garden, 0.0, 1.0) * _xya605 * _bvx9v2 * _fbq83g;
}

float _kf14cb(float skylight, float blocklight) {
float _m4wjgb = 1.0 - smoothstep(0.00, 7.0 / 15.0, skylight);
float _o57m7d = _qwoqln(blocklight);
return _m4wjgb * _o57m7d;
}

float _yqgq0q(float skylight, float blocklight) {
if (isEyeInWater == 1) return 0.0;
float _m4wjgb = 1.0 - smoothstep(0.00, 14.0 / 15.0, skylight);
float _o57m7d = _qwoqln(blocklight);
return _m4wjgb * _o57m7d;
}

float _nq9o3m(float skylight, float blocklight) {
if (isEyeInWater == 1) return 0.0;

float _zlrjo9 = _yqgq0q(skylight, blocklight);
return CAVE_DARKNESS * _zlrjo9 * _zlrjo9;
}

float _nz5r9d(float sunAngle) {
float _huatah = fract(sunAngle);
float _e3y9j5 = smoothstep(0.46, 0.5146, _huatah) * (1.0 - smoothstep(0.5146, 0.57, _huatah));
float _wsgqoz = max(
smoothstep(0.93, 0.9854, _huatah),
1.0 - smoothstep(0.0146, 0.07, _huatah)
);
return max(_e3y9j5, _wsgqoz);
}

float _fi710t(float _y22te0, float skylight) {
float _6l75mg = 1.0 - smoothstep(0.0, 0.25, _y22te0);
return 0.15 * clamp(skylight, 0.0, 1.0) * (1.0 - _6l75mg * 0.75);
}

float _bbncmg(float _jvfij5, float _y22te0, float skylight) {
float _lbybrk = _fi710t(_y22te0, skylight);
float _02ivcw = mix(1.0, _lbybrk, SHADOW_OPACITY);
return mix(1.0, _02ivcw, _jvfij5);
}

vec3 _6xm99w(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float _703fao) {
vec4 _0zms91 = _utlnv9(sunAngle);
float _y22te0 = _0zms91.x;
float _q3g0w9 = _0zms91.w;

float _rjdz4e = (1.0 - smoothstep(0.0, 0.15, _y22te0)) * 0.5;
_y22te0 *= mix(1.0, 0.6 - _rjdz4e, biome_swamp);

float _kkkk2t = fract(sunAngle);

bool _69cq82 = _9cwhip(biome);

float _7vcusu = (1.0 - step(0.5, _ey5sk0(skylight))) * (1.0 / 15.0);
float _njsu4x = _69cq82 ? 1.0 : max(skylight, _7vcusu);
float _mv1tmz = _69cq82 ? 1.0 : _ikvd4g(_njsu4x);
float _zpw0c7 = smoothstep(0.38, 0.45, _kkkk2t) * (1.0 - smoothstep(0.48, 0.55, _kkkk2t))
+ smoothstep(0.95, 1.0, _kkkk2t) + (1.0 - smoothstep(0.0, 0.05, _kkkk2t));

float _nf77dj = smoothstep(0.07, 0.15, _kkkk2t) * (1.0 - smoothstep(0.40, 0.46, _kkkk2t));

float _ydmrin = smoothstep(0.58, 0.66, _kkkk2t) * (1.0 - smoothstep(0.92, 0.98, _kkkk2t));
float _grvh4h = SKYLIGHT_COLOR_TINT * (1.0 - _nf77dj * 0.6) * (1.0 - _ydmrin * 0.7);
float _kytein = clamp(_grvh4h + _zpw0c7 * SUNSET_TERRAIN_TINT, 0.0, 1.0);
float _4knsqu = clamp(SKYLIGHT_TINT_LIGHT_SATURATION, 0.0, 1.0);

vec3 _yzmt2s = _m20mte();
float _wyhr9r = blocklight;
#ifdef LPV_ENABLED
float _3pvoir = 0.0;
#if LPV_ISOLATION_STAGE > 0
_3pvoir = _0i2gan(_osnipo, _5pkrr5);
#endif
_wyhr9r = mix(blocklight, 0.0, _3pvoir);
#endif
float _nskg4g = _wyhr9r;
#if !defined(LPV_ENABLED) && !defined(END_SHADER)

_nskg4g = _69cq82 ? _wyhr9r : 0.0;
#endif
float _1dkcm0 = clamp(_joda6y, 0.0, 1.0);
float _p8nls0 = _yqgq0q(skylight, _nskg4g);
vec3 _6dv2e1 = _2ielw1();
float _aixrz9 = _69cq82 ? 0.0 : smoothstep(0.25, 0.85, _y22te0);
float _1h2se4;
float _6kfq83;
vec3 _t3c8wy;
float _41uucb;
#if !defined(LPV_ENABLED) && !defined(END_SHADER)

_1h2se4 = clamp(blocklight, 0.0, 1.0);
float _9pc7u4 = _ikvd4g(_1h2se4);
_6kfq83 = sqrt(_9pc7u4);
_t3c8wy = vec3(1.0, 0.9, 0.8) * _6kfq83 * BLOCKLIGHT_BRIGHTNESS;
_41uucb = 1.0 - smoothstep(5.0 / 15.0, 1.0, _mv1tmz * _aixrz9);
#else
_1h2se4 = clamp(blocklight * (1.0 - BLOCKLIGHT_SKYLIGHT_REDUCTION * _mv1tmz * _aixrz9), 0.0, 1.0);
_6kfq83 = _171d84(_1h2se4, _mv1tmz);
_t3c8wy = _5gdxs5(_6kfq83);
float _mwu1ub = _mv1tmz;
_41uucb = 1.0 - smoothstep(5.0 / 15.0, 1.0, _mwu1ub * _aixrz9);
#endif
float _3z265f = 0.0;
#ifdef LPV_ENABLED
vec3 _1apffw = vec3(0.0);
#if LPV_ISOLATION_STAGE > 0
float _0dhp7g = 1.0 - smoothstep(0.0, 1.0, _y22te0);

float _wq4os9 = smoothstep(7.0 / 15.0, 12.0 / 15.0, skylight);
float _2w4lsu = _0dhp7g * _wq4os9;
float _9wspun = mix(1.0, LPV_NIGHT_STRENGTH, _2w4lsu);
vec3 _fbf0ep = _dqt2v3(_osnipo, _5pkrr5, _6kfq83) * BLOCKLIGHT_BRIGHTNESS * _9wspun * _x3j9yv;
_1apffw = (_3pvoir > 0.001) ? _fbf0ep / _3pvoir : vec3(0.0);
vec3 blockLight = mix(_t3c8wy, _1apffw, _3pvoir);
#else
vec3 blockLight = _t3c8wy;
#endif
#else
vec3 blockLight = _t3c8wy;
#endif
float _z5wbzq = _p8nls0 * (1.0 - _3z265f) * (1.0 - _1dkcm0);
vec3 _xbixhz = mix(_sw5n74(sunAngle), _yzmt2s, _z5wbzq);
float _wimqh1 = dot(_xbixhz, vec3(0.299, 0.587, 0.114));
_xbixhz = mix(_xbixhz, mix(vec3(_wimqh1), _xbixhz, 0.32), _z5wbzq);

{
float _zcookk = dot(_xbixhz, vec3(0.299, 0.587, 0.114));
_xbixhz = mix(_xbixhz, vec3(_zcookk), _ydmrin * 0.85);
}

float _40jp91 = 1.0 + _zpw0c7 * (SUNSET_TERRAIN_TINT * 1.09);
vec3 _fe6xmr = _a9dot3(_ojotku(_xbixhz, SKYLIGHT_TINT_SATURATION * _40jp91, 0.0));
float _b7pzhz = mix(1.0, SKYLIGHT_TINT_SATURATION * _40jp91, _4knsqu);
vec3 _jpx7iz = _a9dot3(_ojotku(_xbixhz, _b7pzhz, 0.0));

float _279ort = clamp(_kytein * 0.68, 0.0, 1.0);
vec3 _djla22 = _a9dot3(mix(vec3(1.0), _fe6xmr, _279ort));
vec3 _c4ysuh = _a9dot3(mix(vec3(1.0), _jpx7iz, _279ort));

#ifdef END_SHADER
float _3cvaso = 0.0;
vec3 _170eou = vec3(1.0);
#else

float _3cvaso = smoothstep(1.0 / 15.0, 1.0, skylight);
vec3 _170eou = mix(vec3(1.0), _fe6xmr, _kytein * _mv1tmz * _3cvaso);
#endif

vec3 _d6or1k = _s36mo2(SHADOW_HUE > 0.0 ? 180.0 + SHADOW_HUE : 360.0 + SHADOW_HUE);
float _tfmiv0 = dot(_d6or1k, vec3(0.299, 0.587, 0.114));
vec3 _2kfxw0 = _d6or1k / max(_tfmiv0, 0.3);
_2kfxw0 = min(_2kfxw0, vec3(2.0));

float _btnjfs = smoothstep(0.0, 0.20, _y22te0);
float _zuazff = smoothstep(0.10, 0.55, _mv1tmz);
float _f1j4zc = mix(LIGHTMAP_SATURATION * 0.10, LIGHTMAP_SATURATION, _btnjfs * _zuazff);
vec3 _p91vw9 = _2kfxw0;

float _cvlxie = clamp(_mv1tmz * _y22te0, 0.0, 1.0);

float _xcnno9 = 0.15 * _mv1tmz;

vec3 _oumalh = _djla22 * _xcnno9;

vec3 _hj0fjq = _c4ysuh;
vec3 _xhaim9 = mix(_oumalh, _hj0fjq, _cvlxie);
if (_69cq82) _xhaim9 *= NETHER_BRIGHTNESS;

float _a9a126 = _nq9o3m(skylight, _wyhr9r) * (1.0 - _3z265f);
vec3 _43thas = _yssmf1 * _xhaim9;
float _77lvd8 = _63yk0w(_y22te0, skylight, _wyhr9r);
float _87lfbp = _37o4le(_y22te0, skylight, _wyhr9r);
float _ttagom = _twjs8h(_y22te0, skylight, _wyhr9r);
_43thas *= mix(vec3(1.0), _6dv2e1, _z5wbzq);
_43thas *= 1.0 - _77lvd8 * 0.45;

_43thas *= 1.0 - _87lfbp * 0.45 * _cvlxie;

_43thas *= 1.0 - _ttagom * 0.40 * _cvlxie;
_43thas *= 1.0 - _a9a126 * 0.45;

vec3 _vswfp0 = vec3(0.0);
vec3 _d8769y = _xbixhz;
#ifdef END_SHADER
vec3 _wzl9xk = vec3(END_BLOCKLIGHT_R, END_BLOCKLIGHT_G, END_BLOCKLIGHT_B);
vec3 _4sbh8j = _wzl9xk * _6kfq83 * _6kfq83 * END_BLOCKLIGHT_BRIGHTNESS;
_d8769y = _a9dot3(_wzl9xk);
_vswfp0 = _yssmf1 * _4sbh8j;
vec3 _8izj9y = _43thas + _vswfp0;
#else
#ifdef LPV_ENABLED

vec3 _fyhmdd = _q81bhd(_pis44d, _06143i);
vec3 _zowjcd = _1apffw * _41uucb;
vec3 _rcgl8l = _fyhmdd * _zowjcd;
vec3 _7mvexp = _yssmf1 * _t3c8wy * _41uucb;
vec3 _sha6up = _43thas + _7mvexp;
vec3 _a9158c = _9mtd5j(_43thas, _pis44d, _rcgl8l);
_d8769y = _a9dot3(max(blockLight, vec3(0.001)));
_vswfp0 = mix(_7mvexp, _pis44d * _rcgl8l, _3pvoir);
vec3 _8izj9y = mix(_sha6up, _a9158c, _3pvoir);

#else
_d8769y = _a9dot3(vec3(1.0, 0.9, 0.8));
_vswfp0 = _yssmf1 * blockLight * _41uucb;
vec3 _8izj9y = _43thas + _vswfp0;
#endif
#endif

float _zievek = float(SEA_LEVEL_OFFSET);
float _sj6nb7 = max(_zievek - _703fao, 0.0);
float _clzyel = 1.0 - smoothstep(0.0, 96.0, _sj6nb7);

float _zsb5co = mix(0.30, 0.18, _clzyel);
float _e9365q = 0.35;
float _kih2d7 = 1.0 - _mv1tmz;
float _e73heu = smoothstep(24.0, 96.0, _sj6nb7);
float _xd2aui = mix(_e9365q, _zsb5co, _e73heu);
float _3e82sa = _ukv2q2(skylight);
float _kdhmp7 = mix(1.0, _kih2d7 + _q3g0w9 * 0.5 * _mv1tmz, _3e82sa);
float _ymqyke = mix(CAVE_AMBIENT_FLOOR, _xd2aui, 1.0 - _a9a126)
* _kdhmp7;
_ymqyke *= 1.0 - _77lvd8 * 0.35;

_ymqyke *= 1.0 - _a9a126 * 0.35;
float _t8kgw6 = _ufelhq(skylight) * _qwoqln(_wyhr9r);
_ymqyke = max(_ymqyke, 0.08 * _t8kgw6);
vec3 _vh7kbz = _yssmf1 * _ymqyke * _xbixhz;
float _nk7hny = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
float _b58j5e = _t8kgw6 * (1.0 - smoothstep(0.04, 0.25, _nk7hny));

_vh7kbz = max(_vh7kbz, _yssmf1 * _xbixhz * _ymqyke * (1.0 + 0.5 * _b58j5e));
_8izj9y = max(_8izj9y, _vh7kbz);
float _2h4zc3 = 1.0 - smoothstep(0.04, 0.22, _nk7hny);
float _wse13y = 1.0 - smoothstep(0.08, 0.45, _mv1tmz);
vec3 _9tlejh = _yssmf1 * _xbixhz * (_ymqyke * 0.35) * _2h4zc3 * _wse13y;
vec3 _re9xq4 = vec3(0.0);
#if defined(LPV_ENABLED) || defined(END_SHADER)
float _gxvn5k = smoothstep(0.04, 0.30, _6kfq83) * _41uucb;
#if defined(LPV_ENABLED) && !defined(END_SHADER)
_gxvn5k *= 1.0 - _3pvoir;
#endif
vec3 _zdpad0 = _a9dot3(mix(_xbixhz, _xbixhz * _d8769y, 0.55));
_re9xq4 = _yssmf1 * _zdpad0 * (0.08 * _6kfq83) * _2h4zc3 * _gxvn5k;
#endif
vec3 _85ekms = _9tlejh + _re9xq4;
_8izj9y = max(_8izj9y, _85ekms);

#ifdef SHADOW_DEBUG_TINT
float _1ghiel = clamp(1.0 - _cvlxie, 0.0, 1.0);
_8izj9y = mix(_8izj9y, vec3(1.0, 0.1, 0.1), _1ghiel * 0.85);
#endif

#ifdef CAVE_LIGHT_DEBUG
float _djtbli = 1.0 - _mv1tmz;
float _gyf400 = clamp(_ymqyke / max(dot(_yssmf1, vec3(0.3333)), 0.001), 0.0, 1.0);
vec3 _5c82tf = vec3(_gyf400, 0.0, _djtbli);
_8izj9y = mix(_8izj9y, _5c82tf, 0.9);
#endif

return _8izj9y;
}

vec3 _iroce3(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float emissive, vec3 shadow, float _703fao) {
if (emissive > 0.5) {
#ifdef END_SHADER

return _yssmf1 * EMISSIVE_BRIGHTNESS * END_EMISSIVE_BOOST;
#else
return _yssmf1 * EMISSIVE_BRIGHTNESS;
#endif
}

vec4 _0zms91 = _utlnv9(sunAngle);
float _y22te0 = _0zms91.x;
float _q3g0w9 = _0zms91.w;

float _rjdz4e = (1.0 - smoothstep(0.0, 0.15, _y22te0)) * 0.5;
_y22te0 *= mix(1.0, 0.6 - _rjdz4e, biome_swamp);

bool _69cq82 = _9cwhip(biome);

float _7vcusu = (1.0 - step(0.5, _ey5sk0(skylight))) * (1.0 / 15.0);
float _njsu4x = _69cq82 ? 1.0 : max(skylight, _7vcusu);
float _mv1tmz = _69cq82 ? 1.0 : _ikvd4g(_njsu4x);

float _lr0ga3 = fract(sunAngle);
float _znvhcf = smoothstep(0.38, 0.45, _lr0ga3) * (1.0 - smoothstep(0.48, 0.55, _lr0ga3))
+ smoothstep(0.95, 1.0, _lr0ga3) + (1.0 - smoothstep(0.0, 0.05, _lr0ga3));

float _2kx7w0 = smoothstep(0.07, 0.15, _lr0ga3) * (1.0 - smoothstep(0.40, 0.46, _lr0ga3));

float _z014zs = smoothstep(0.58, 0.66, _lr0ga3) * (1.0 - smoothstep(0.92, 0.98, _lr0ga3));
float _sxeot9 = SKYLIGHT_COLOR_TINT * (1.0 - _2kx7w0 * 0.6) * (1.0 - _z014zs * 0.7);
float _kytein = clamp(_sxeot9 + _znvhcf * SUNSET_TERRAIN_TINT, 0.0, 1.0);
float _4knsqu = clamp(SKYLIGHT_TINT_LIGHT_SATURATION, 0.0, 1.0);

vec3 _yzmt2s = _m20mte();
float _wyhr9r = blocklight;
#ifdef LPV_ENABLED
float _3pvoir = 0.0;
#if LPV_ISOLATION_STAGE > 0
_3pvoir = _0i2gan(_osnipo, _5pkrr5);
#endif
_wyhr9r = mix(blocklight, 0.0, _3pvoir);
#endif
float _nskg4g = _wyhr9r;
#if !defined(LPV_ENABLED) && !defined(END_SHADER)

_nskg4g = _69cq82 ? _wyhr9r : 0.0;
#endif
float _p8nls0 = _yqgq0q(skylight, _nskg4g);
vec3 _6dv2e1 = _2ielw1();
float _aixrz9 = _69cq82 ? 0.0 : smoothstep(0.25, 0.85, _y22te0);
float _1h2se4;
float _6kfq83;
vec3 _t3c8wy;
float _41uucb;
#if !defined(LPV_ENABLED) && !defined(END_SHADER)

_1h2se4 = clamp(blocklight, 0.0, 1.0);
float _9pc7u4 = _ikvd4g(_1h2se4);
_6kfq83 = sqrt(_9pc7u4);
_t3c8wy = vec3(1.0, 0.9, 0.8) * _6kfq83 * BLOCKLIGHT_BRIGHTNESS;
_41uucb = 1.0 - smoothstep(5.0 / 15.0, 1.0, _mv1tmz * _aixrz9);
#else
_1h2se4 = clamp(blocklight * (1.0 - BLOCKLIGHT_SKYLIGHT_REDUCTION * _mv1tmz * _aixrz9), 0.0, 1.0);
_6kfq83 = _171d84(_1h2se4, _mv1tmz);
_t3c8wy = _5gdxs5(_6kfq83);
float _mwu1ub = _mv1tmz;
_41uucb = 1.0 - smoothstep(5.0 / 15.0, 1.0, _mwu1ub * _aixrz9);
#endif
float _fqstwt = clamp(_6kfq83 * BLOCKLIGHT_SHADOW_OVERRIDE, 0.0, 1.0);
#if !defined(LPV_ENABLED) && !defined(END_SHADER)
_fqstwt *= _41uucb;
#endif
#ifdef LPV_ENABLED
_fqstwt *= 1.0 - _3pvoir;
#endif
float _3z265f = 0.0;
#ifdef LPV_ENABLED
vec3 _1apffw = vec3(0.0);
#if LPV_ISOLATION_STAGE > 0

float _bvx9v2 = smoothstep(7.0 / 15.0, 12.0 / 15.0, skylight);
float _h0gyrr = 1.0 - smoothstep(0.0, 1.0, _y22te0);
float _x970v5 = _h0gyrr * _bvx9v2;
float _9wspun = mix(1.0, LPV_NIGHT_STRENGTH, _x970v5);
vec3 _ptyuzn = _dqt2v3(_osnipo, _5pkrr5, _6kfq83) * BLOCKLIGHT_BRIGHTNESS * _9wspun * _x3j9yv;
_1apffw = (_3pvoir > 0.001) ? (_ptyuzn * 5.0) / _3pvoir : vec3(0.0);
vec3 blockLight = mix(_t3c8wy, _1apffw, _3pvoir);
#else
vec3 blockLight = _t3c8wy;
#endif
#else
vec3 blockLight = _t3c8wy;
#endif
float _1dkcm0 = clamp(_joda6y, 0.0, 1.0);
float _z5wbzq = _p8nls0 * (1.0 - _3z265f) * (1.0 - _1dkcm0);
vec3 _xbixhz = mix(_sw5n74(sunAngle), _yzmt2s, _z5wbzq);
float _wimqh1 = dot(_xbixhz, vec3(0.299, 0.587, 0.114));
_xbixhz = mix(_xbixhz, mix(vec3(_wimqh1), _xbixhz, 0.32), _z5wbzq);

{
float _ouwa9a = dot(_xbixhz, vec3(0.299, 0.587, 0.114));
_xbixhz = mix(_xbixhz, vec3(_ouwa9a), _z014zs * 0.85);
}
float _7ug4bb = 1.0 + _znvhcf * (SUNSET_TERRAIN_TINT * 1.09);
vec3 _fe6xmr = _a9dot3(_ojotku(_xbixhz, SKYLIGHT_TINT_SATURATION * _7ug4bb, 0.0));
float _b7pzhz = mix(1.0, SKYLIGHT_TINT_SATURATION * _7ug4bb, _4knsqu);
vec3 _jpx7iz = _a9dot3(_ojotku(_xbixhz, _b7pzhz, 0.0));
float _279ort = clamp(_kytein * 0.68, 0.0, 1.0);
vec3 _djla22 = _a9dot3(mix(vec3(1.0), _fe6xmr, _279ort));
vec3 _c4ysuh = _a9dot3(mix(vec3(1.0), _jpx7iz, _279ort));

#ifdef END_SHADER
float _3cvaso = 0.0;
vec3 _170eou = vec3(1.0);
#else

float _3cvaso = smoothstep(1.0 / 15.0, 1.0, skylight);
vec3 _170eou = mix(vec3(1.0), _fe6xmr, _kytein * _mv1tmz * _3cvaso);
#endif

vec3 _d6or1k = _s36mo2(SHADOW_HUE > 0.0 ? 180.0 + SHADOW_HUE : 360.0 + SHADOW_HUE);
float _tfmiv0 = dot(_d6or1k, vec3(0.299, 0.587, 0.114));
vec3 _2kfxw0 = _d6or1k / max(_tfmiv0, 0.3);
_2kfxw0 = min(_2kfxw0, vec3(2.0));

float _zb0qp8 = smoothstep(0.0, 0.20, _y22te0);
float _vgbqdr = smoothstep(0.10, 0.55, _mv1tmz);
float _1acrq5 = mix(SHADOW_SATURATION * 0.10, SHADOW_SATURATION, _zb0qp8 * _vgbqdr);
vec3 _p91vw9 = _2kfxw0;

float _hg321h = dot(shadow, vec3(0.299, 0.587, 0.114));

float _7oy835 = mix(_hg321h, 1.0, _fqstwt);

float _er0ext = max(_mv1tmz, _1dkcm0);
float _cvlxie = clamp(_er0ext * _y22te0 * _7oy835, 0.0, 1.0);

float _6l75mg = 1.0 - smoothstep(0.0, 0.25, _y22te0);
float _xcnno9 = 0.15 * _er0ext * (1.0 - _6l75mg * 0.75);
float _d34zx7 = smoothstep(float(SEA_LEVEL_OFFSET) - 4.0, float(SEA_LEVEL_OFFSET) + 2.0, _703fao);
float _chmcgr = _hrakns(sunAngle) * (1.0 - smoothstep(0.08, 0.35, _mv1tmz)) * _d34zx7 * _1dkcm0;
_xcnno9 = max(_xcnno9, 0.08 * _chmcgr);

_cvlxie += _er0ext * _7oy835 * _6l75mg * 0.30;

vec3 _oumalh = _djla22 * _xcnno9;

vec3 _hj0fjq = _c4ysuh;
vec3 _xhaim9 = mix(_oumalh, _hj0fjq, _cvlxie);

if (_69cq82) _xhaim9 *= NETHER_BRIGHTNESS;

float _a9a126 = _nq9o3m(skylight, _wyhr9r) * (1.0 - _3z265f) * (1.0 - _1dkcm0);
vec3 _43thas = _yssmf1 * _xhaim9;
float _77lvd8 = _63yk0w(_y22te0, skylight, _wyhr9r);
float _87lfbp = _37o4le(_y22te0, skylight, _wyhr9r);
float _ttagom = _twjs8h(_y22te0, skylight, _wyhr9r);
_43thas *= mix(vec3(1.0), _6dv2e1, _z5wbzq);
_43thas *= 1.0 - _77lvd8 * 0.45;

_43thas *= 1.0 - _87lfbp * 0.45 * _cvlxie;

_43thas *= 1.0 - _ttagom * 0.40 * _cvlxie;
_43thas *= 1.0 - _a9a126 * 0.45;

float _9x744d = dot(shadow, vec3(0.299, 0.587, 0.114));
if (_9x744d > 0.001) {
vec3 _e53v52 = shadow / _9x744d;
float _pg1f5w = max(_e53v52.r, max(_e53v52.g, _e53v52.b)) - min(_e53v52.r, min(_e53v52.g, _e53v52.b));
if (_pg1f5w > 0.1) {

_43thas *= mix(vec3(1.0), _e53v52, smoothstep(0.1, 0.4, _pg1f5w) * 0.4);
}
}

vec3 _vswfp0 = vec3(0.0);
vec3 _d8769y = _xbixhz;
#ifdef END_SHADER

vec3 _wzl9xk = vec3(END_BLOCKLIGHT_R, END_BLOCKLIGHT_G, END_BLOCKLIGHT_B);
vec3 _4sbh8j = _wzl9xk * _6kfq83 * _6kfq83 * END_BLOCKLIGHT_BRIGHTNESS;
_d8769y = _a9dot3(_wzl9xk);
_vswfp0 = _yssmf1 * _4sbh8j;
vec3 _8izj9y = _43thas + _vswfp0;
#else
#ifdef LPV_ENABLED

vec3 _fyhmdd = _q81bhd(_pis44d, _06143i);
vec3 _zowjcd = _1apffw * _41uucb;
vec3 _rcgl8l = _fyhmdd * _zowjcd;
vec3 _7mvexp = _yssmf1 * _t3c8wy * _41uucb;
vec3 _sha6up = _43thas + _7mvexp;
vec3 _a9158c = _9mtd5j(_43thas, _pis44d, _rcgl8l);
_d8769y = _a9dot3(max(blockLight, vec3(0.001)));
_vswfp0 = mix(_7mvexp, _pis44d * _rcgl8l, _3pvoir);
vec3 _8izj9y = mix(_sha6up, _a9158c, _3pvoir);

#else
_d8769y = _a9dot3(vec3(1.0, 0.9, 0.8));
_vswfp0 = _yssmf1 * blockLight * _41uucb;
vec3 _8izj9y = _43thas + _vswfp0;
#endif
#endif

float _zievek = float(SEA_LEVEL_OFFSET);
float _sj6nb7 = max(_zievek - _703fao, 0.0);
float _clzyel = 1.0 - smoothstep(0.0, 96.0, _sj6nb7);

float _zsb5co = mix(0.30, 0.18, _clzyel);
float _e9365q = 0.35;
float _kih2d7 = 1.0 - _mv1tmz;
float _e73heu = smoothstep(24.0, 96.0, _sj6nb7);
float _xd2aui = mix(_e9365q, _zsb5co, _e73heu);
float _3e82sa = _ukv2q2(skylight);
float _kdhmp7 = mix(1.0, _kih2d7 + _q3g0w9 * 0.5 * _mv1tmz, _3e82sa);
float _ymqyke = mix(CAVE_AMBIENT_FLOOR, _xd2aui, 1.0 - _a9a126)
* _kdhmp7;
_ymqyke *= 1.0 - _77lvd8 * 0.35;

_ymqyke *= 1.0 - _a9a126 * 0.35;
float _t8kgw6 = _ufelhq(skylight) * _qwoqln(_wyhr9r);
_ymqyke = max(_ymqyke, 0.08 * _t8kgw6);
vec3 _vh7kbz = _yssmf1 * _ymqyke * _xbixhz;
float _nk7hny = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
float _b58j5e = _t8kgw6 * (1.0 - smoothstep(0.04, 0.25, _nk7hny));

_vh7kbz = max(_vh7kbz, _yssmf1 * _xbixhz * _ymqyke * (1.0 + 0.5 * _b58j5e));
_8izj9y = max(_8izj9y, _vh7kbz);
float _2h4zc3 = 1.0 - smoothstep(0.04, 0.22, _nk7hny);
float _wse13y = 1.0 - smoothstep(0.08, 0.45, _mv1tmz);
vec3 _9tlejh = _yssmf1 * _xbixhz * (_ymqyke * 0.35) * _2h4zc3 * _wse13y;
vec3 _re9xq4 = vec3(0.0);
#if defined(LPV_ENABLED) || defined(END_SHADER)
float _gxvn5k = smoothstep(0.04, 0.30, _6kfq83) * _41uucb;
#if defined(LPV_ENABLED) && !defined(END_SHADER)
_gxvn5k *= 1.0 - _3pvoir;
#endif
vec3 _zdpad0 = _a9dot3(mix(_xbixhz, _xbixhz * _d8769y, 0.55));
_re9xq4 = _yssmf1 * _zdpad0 * (0.08 * _6kfq83) * _2h4zc3 * _gxvn5k;
#endif
vec3 _85ekms = _9tlejh + _re9xq4;
_8izj9y = max(_8izj9y, _85ekms);

#ifdef SHADOW_DEBUG_TINT
float _1ghiel = clamp(1.0 - _7oy835, 0.0, 1.0);
_8izj9y = mix(_8izj9y, vec3(1.0, 0.1, 0.1), _1ghiel * 0.85);
#endif

#ifdef CAVE_LIGHT_DEBUG
float _djtbli = 1.0 - _mv1tmz;
float _gyf400 = clamp(_ymqyke / max(dot(_yssmf1, vec3(0.3333)), 0.001), 0.0, 1.0);
vec3 _5c82tf = vec3(_gyf400, 0.0, _djtbli);
_8izj9y = mix(_8izj9y, _5c82tf, 0.9);
#endif

#if defined(LPV_ENABLED) && defined(LPV_DEBUG)

{
vec3 _teje4x = _osnipo - cameraPosition;
vec3 _xfadps = _cs4po4(_teje4x, cameraPosition);
if (_x3urej(_xfadps)) {
uint _zbwyil = debugReadLpvVoxel(_osnipo);
vec3 _hrugcx = _dqt2v3(_osnipo, _5pkrr5);
float _om7u0m = max(_hrugcx.r, max(_hrugcx.g, _hrugcx.b));

if (_zbwyil > 0u) {

_8izj9y = vec3(
float(_zbwyil & 3u) / 3.0,
float((_zbwyil >> 2u) & 3u) / 3.0,
float((_zbwyil >> 4u) & 3u) / 3.0
);
} else if (_om7u0m > 0.001) {

_8izj9y = _hrugcx * 5.0;
} else {

_8izj9y = vec3(0.8, 0.0, 0.8);
}
} else {
_8izj9y = vec3(0.0);
}
}
#endif

return _8izj9y;
}

vec3 _iroce3(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float emissive, float shadow, float _703fao) {
return _iroce3(_yssmf1, sunAngle, skylight, blocklight, emissive, vec3(shadow), _703fao);
}

vec3 _rdf2ja(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float emissive, float _703fao) {
if (emissive > 0.5) {
#ifdef END_SHADER
return _yssmf1 * EMISSIVE_BRIGHTNESS * END_EMISSIVE_BOOST;
#else
return _yssmf1 * EMISSIVE_BRIGHTNESS;
#endif
}
return _6xm99w(_yssmf1, sunAngle, skylight, blocklight, _703fao);
}

vec3 _tqukfm(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float emissive, vec3 worldPos) {
return _rdf2ja(_yssmf1, sunAngle, skylight, blocklight, emissive, worldPos.y);
}

vec3 _5x7sht(vec3 _yssmf1, float sunAngle, float skylight, float _703fao) {
return _6xm99w(_yssmf1, sunAngle, skylight, 0.0, _703fao);
}

#endif
