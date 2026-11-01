#ifndef ILV_REFLECTIONS_GLSL
#define ILV_REFLECTIONS_GLSL

const bool _avus60 = true;

#include "/include/sky_night_features.glsl"
#include "/include/sky_timeline.glsl"

vec4 _bxu35n(vec3 _gpy6je) {
return vec4(_gpy6je.xyz, 1.0);
}

vec3 _bw6ml5(vec4 _gpy6je) {
float _p8s4ll = abs(_gpy6je.w) > 1e-7 ? _gpy6je.w : (_gpy6je.w < 0.0 ? -1e-7 : 1e-7);
return _gpy6je.xyz / _p8s4ll;
}

bool _ksatw5(vec3 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9));
}

vec3 _lhz76c(vec3 _ino0s9, vec3 _8cc9nt) {
float _y1pmzg = dot(_ino0s9, _ino0s9);
if (!_ksatw5(_ino0s9) || isnan(_y1pmzg) || isinf(_y1pmzg) || _y1pmzg <= 1e-12) {
return _8cc9nt;
}
return _ino0s9 * inversesqrt(_y1pmzg);
}

vec4 _4zvj3d(sampler2D fogTexture, vec2 uv) {
vec4 _rk79pn = textureLod(fogTexture, uv, 0.0);
if (any(isnan(_rk79pn)) || any(isinf(_rk79pn)) || _rk79pn.a < 0.0 || _rk79pn.a > 1.0001) return vec4(0.0);
return max(_rk79pn, vec4(0.0));
}

bool _4lfut5(vec3 _i7rmfc, out vec3 _lqd0ca) {
vec4 _7kna82 = gbufferProjection * vec4(_i7rmfc, 1.0);
if (any(isnan(_7kna82)) || any(isinf(_7kna82)) || abs(_7kna82.w) <= 1e-7) {
_lqd0ca = vec3(-1.0);
return false;
}
_lqd0ca = _7kna82.xyz / _7kna82.w * 0.5 + 0.5;
return _ksatw5(_lqd0ca);
}

float _ge1lty  (vec2 a) { a = 0.5 * floor(a); return fract(1.5 * fract(a.y) + a.x); }
float _viy9pm  (vec2 a) { return 0.25 * _ge1lty  (0.5 * a) + _ge1lty(a); }
float _jwhmer  (vec2 a) { return 0.25 * _viy9pm  (0.5 * a) + _ge1lty(a); }
float _6m2g1r (vec2 a) { return 0.25 * _jwhmer  (0.5 * a) + _ge1lty(a); }
float _7yy4cn (vec2 a) { return 0.25 * _6m2g1r (0.5 * a) + _ge1lty(a); }
float _lq6xqu (vec2 a) { return 0.25 * _7yy4cn (0.5 * a) + _ge1lty(a); }

float _z97myi(vec2 v) {
return dot(floor(255.0 * v + 0.5), vec2(1.0 / 65535.0, 256.0 / 65535.0));
}
float _z97myi(float x, float y) { return _z97myi(vec2(x, y)); }

vec2 _62hs1a(float _tkb7cx) {
vec2 xy; xy.x = modf((65535.0 / 256.0) * _tkb7cx, xy.y);
return xy * vec2(256.0 / 255.0, 1.0 / 255.0);
}

vec2 _15nkkf(vec3 v) {
float _j49dk7 = abs(v.x) + abs(v.y) + abs(v.z);
if (_j49dk7 <= 1e-7 || isnan(_j49dk7) || isinf(_j49dk7)) return vec2(0.5);
v /= _j49dk7;
v.xy = (v.z >= 0.0) ? v.xy : (1.0 - abs(v.yx)) * (vec2(v.x >= 0.0, v.y >= 0.0) * 2.0 - 1.0);
return v.xy * 0.5 + 0.5;
}

vec3 _gjtx38(vec2 v) {
vec2 f = v * 2.0 - 1.0;
vec3 n = vec3(f, 1.0 - abs(f.x) - abs(f.y));
float t = max(-n.z, 0.0);
n.xy += vec2(n.x >= 0.0 ? -t : t, n.y >= 0.0 ? -t : t);
return normalize(n);
}

vec3 _uyoa3r(vec3 _gpy6je) {
vec4 _jc5qss = vec4(
gbufferProjectionInverse[0].x,
gbufferProjectionInverse[1].y,
gbufferProjectionInverse[2].zw
);
vec3 p3 = _gpy6je * 2.0 - 1.0;
vec4 viewPos = _jc5qss * p3.xyzz + gbufferProjectionInverse[3];
float _p8s4ll = abs(viewPos.w) > 1e-7 ? viewPos.w : (viewPos.w < 0.0 ? -1e-7 : 1e-7);
vec3 _8izj9y = viewPos.xyz / _p8s4ll;
return _ksatw5(_8izj9y) ? _8izj9y : vec3(0.0, 0.0, -1.0);
}

#ifndef RAIN_STRENGTH_DECLARED
#define RAIN_STRENGTH_DECLARED
uniform float rainStrength;
#endif

#ifndef WETNESS_DECLARED
#define WETNESS_DECLARED
uniform float wetness;
#endif

#ifndef FRAME_TIME_COUNTER_DECLARED
#define FRAME_TIME_COUNTER_DECLARED
uniform float frameTimeCounter;
#endif

vec3 _b617kd(vec3 viewDir, vec3 worldPos, bool _d0ji2p) {
#ifdef END_SHADER
vec3 _st4awd = normalize(mat3(gbufferModelViewInverse) * viewDir);
float height = max(_st4awd.y, 0.0);

vec3 _xyezyl = vec3(END_SKY_HORIZON_R, END_SKY_HORIZON_G, END_SKY_HORIZON_B);
vec3 _gbifj2 = vec3(END_SKY_MID_R, END_SKY_MID_G, END_SKY_MID_B);
vec3 _riel36 = vec3(END_SKY_ZENITH_R, END_SKY_ZENITH_G, END_SKY_ZENITH_B);

float _i9ukw0 = smoothstep(0.25, 0.65, height);
vec3 _od2x3w = mix(mix(_xyezyl, _gbifj2, smoothstep(0.0, 0.25, height)), _riel36, _i9ukw0);

if (_st4awd.y < 0.0) {
float _w35u7s = 1.0 - smoothstep(-0.4, 0.0, _st4awd.y);
#ifdef END_FOG_ENABLED
vec3 _2rme2p = vec3(END_FOG_R, END_FOG_G, END_FOG_B);
#else
vec3 _2rme2p = _xyezyl * 0.3;
#endif
_od2x3w = mix(_xyezyl, _2rme2p, _w35u7s);
}

return _od2x3w * END_SKY_BRIGHTNESS * 0.5;
#else

float _huatah = fract(sunAngle);
TimeWeightsSimple ts = getTimeWeightsSimple(sunAngle);

float _2or95l = dot(viewDir, gbufferModelView[1].xyz);
float _j9cxak = max(-_2or95l, 0.0);
float _us23hd = smoothstep(0.0, 0.15, _j9cxak);
float _2m4u8p = max(_2or95l, 0.0);

float _pwfvop = 1.0 - _2m4u8p;
_pwfvop *= _pwfvop;
_pwfvop *= _pwfvop;
_pwfvop = 1.0 - _pwfvop;
vec3 _f2djza = _9ruyvd(sunAngle, _pwfvop);

{
vec3 _mw99cp = _f2djza;
vec3 _evq3fl = _f2djza;
vec3 _mzcgmx = _f2djza;
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _fgx2j8 = _g4a6za(_i0sr2e(biome_savanna), _lfojrz);
float _ypru3e = _5pe64i(_za404r(biome_arid), _fgx2j8);
bool _pw6j29 = false;
float _rxs39p = _jpbsbi(biome_snowy);
#ifndef OVERWORLD_BIOME_SKY_ENABLED

_lfojrz = 0.0; _2d13on = 0.0; _fgx2j8 = 0.0; _ypru3e = 0.0; _rxs39p = 0.0;
#endif
if (_rxs39p > 0.001) {
_mw99cp = mix(_mw99cp, vec3(0.92, 0.94, 0.96), _rxs39p);
_evq3fl = mix(_evq3fl, vec3(0.88, 0.91, 0.95), _rxs39p);
_mzcgmx = mix(_mzcgmx, vec3(0.75, 0.85, 0.95), _rxs39p);
_pw6j29 = true;
}
if (_d0ji2p && _2d13on > 0.001) {
_mw99cp = mix(_mw99cp, vec3(81.0, 189.0, 92.0) / 255.0, _2d13on);
_evq3fl = mix(_evq3fl, vec3(154.0, 194.0, 110.0) / 255.0, _2d13on);
_mzcgmx = mix(_mzcgmx, vec3(122.0, 211.0, 255.0) / 255.0, _2d13on);
_pw6j29 = true;
}
if (_lfojrz > 0.001) {
_mw99cp = mix(_mw99cp, vec3(66.0, 128.0, 75.0) / 255.0, _lfojrz);
_evq3fl = mix(_evq3fl, vec3(83.0, 77.0, 102.0) / 255.0, _lfojrz);
_mzcgmx = mix(_mzcgmx, vec3(144.0, 199.0, 90.0) / 255.0, _lfojrz);
_pw6j29 = true;
}
if (_ypru3e > 0.001) {
_mw99cp = mix(_mw99cp, vec3(235.0, 213.0, 185.0) / 255.0, _ypru3e);
_evq3fl = mix(_evq3fl, vec3(214.0, 206.0, 224.0) / 255.0, _ypru3e);
_mzcgmx = mix(_mzcgmx, vec3(150.0, 145.0, 207.0) / 255.0, _ypru3e);
_pw6j29 = true;
}
if (_fgx2j8 > 0.001) {
_mw99cp = mix(_mw99cp, _e6gplv(), _fgx2j8);
_evq3fl = mix(_evq3fl, _d36tdk(), _fgx2j8);
_mzcgmx = mix(_mzcgmx, _b8134m(), _fgx2j8);
_pw6j29 = true;
}
float _6kr23z = clamp(biome_pale_garden, 0.0, 1.0);
#ifndef OVERWORLD_BIOME_SKY_ENABLED
_6kr23z = 0.0;
#endif
if (_6kr23z > 0.001) {
_mw99cp = mix(_mw99cp, _1iquw2(), _6kr23z);
_evq3fl = mix(_evq3fl, _ch7orx(), _6kr23z);
_mzcgmx = mix(_mzcgmx, _f9f345(), _6kr23z);
_pw6j29 = true;
}
if (_pw6j29) {
float _me53pv = smoothstep(0.0, 0.3, _2m4u8p);
float _2bdn4z = smoothstep(0.3, 0.7, _2m4u8p);
vec3 _c5be6e = mix(_mw99cp, mix(_evq3fl, _mzcgmx, _2bdn4z), _me53pv);
float _po3i7o = ts.day + ts.twilight * 0.7;

float _8r8zt1 = max(_lfojrz, _6kr23z);
float _eghtto = mix(_po3i7o, 1.0, _8r8zt1);
float _f7yssv = _d0ji2p ? _2d13on : 0.0;
float _zkhgkx = max(max(_f7yssv, _lfojrz), max(_rxs39p, max(_ypru3e, max(_fgx2j8, _6kr23z))));
_f2djza = mix(_f2djza, _c5be6e, _zkhgkx * _eghtto);
}
}

_f2djza *= mix(1.0, 0.7, _2m4u8p);

vec3 _1vlt67 = _9ruyvd(sunAngle, 0.0);
_f2djza = mix(_f2djza, _1vlt67, _us23hd);

float _wnr39r = dot(viewDir, normalize(shadowLightPosition)) * 0.5 + 0.5;
_wnr39r = 1.0 - (1.0 - _wnr39r) * (1.0 - _wnr39r);
_wnr39r *= 1.0 - _2m4u8p;
_wnr39r *= 1.0 - (1.0 - ts.twilight) * (1.0 - ts.twilight);
vec3 _cv9p5e = sunAngle > 0.25 && sunAngle < 0.75
? vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B)
: vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B);

#ifdef OVERWORLD_BIOME_SKY_ENABLED
float _1pikz1 = max(clamp(biome_swamp, 0.0, 1.0), clamp(biome_pale_garden, 0.0, 1.0));
#else
float _1pikz1 = 0.0;
#endif
_f2djza *= 1.0 + _wnr39r * 0.3 * (1.0 - _1pikz1);

#ifdef OVERWORLD_BIOME_SKY_ENABLED

_f2djza *= mix(1.0, 0.6, clamp(biome_swamp, 0.0, 1.0));

_f2djza *= mix(1.0, 0.85, clamp(biome_pale_garden, 0.0, 1.0));
#endif

TimeWeights tw = getTimeWeights(sunAngle);
float _oui5et = smoothstep(0.0, 0.5, max(_2m4u8p, 0.0));

float _92388v = min(tw.day, tw.sunset + tw.sunrise) * 2.0;
vec3 _y2j94g = mix(vec3(1.0, 0.92, 0.4), vec3(0.85, 0.15, 0.55), _oui5et);
_y2j94g *= max(DAY_BRIGHTNESS, SUNSET_BRIGHTNESS);
_f2djza = mix(_f2djza, _y2j94g, _92388v * mix(0.25, 0.35, _oui5et));

float _4am4t1 = min(tw.sunset, tw.blueHour) * 2.0;
vec3 _at014b = mix(vec3(0.9, 0.25, 0.55), vec3(0.4, 0.1, 1.0), _oui5et);
_at014b *= mix(SUNSET_BRIGHTNESS, BLUEHOUR_BRIGHTNESS, 0.5);
_f2djza = mix(_f2djza, _at014b, _4am4t1 * mix(0.2, 0.35, _oui5et));

float _8hrnao = dot(_f2djza, vec3(0.299, 0.587, 0.114));
_f2djza = mix(vec3(_8hrnao), _f2djza, SKY_SATURATION * 0.8);
_f2djza = max(_f2djza, vec3(0.0));

vec3 _a316vw = normalize(mat3(gbufferModelViewInverse) * viewDir);
vec3 _ytwly3 = _5gqmwb(vec3(0.0), _a316vw, sunAngle, frameTimeCounter, rainStrength);

#ifdef NIGHT_NEBULA_ENABLED
{
float _s9z9nh = fract(sunAngle);
float _vd67dg = smoothstep(0.55, 0.60, _s9z9nh) * (1.0 - smoothstep(0.94, 0.98, _s9z9nh));
float _x4069b = smoothstep(0.50, 0.52, _s9z9nh) * (1.0 - smoothstep(0.55, 0.58, _s9z9nh));
float _v56z3v = 1.0 - smoothstep(0.15, 0.70, rainStrength);
float _k6cd4q = (_vd67dg + _x4069b * 0.4) * _v56z3v;
if (_k6cd4q > 0.01) {
_ytwly3 -= _i1wf82(_a316vw, frameTimeCounter) * _k6cd4q;
}
}
#endif

#ifdef OVERWORLD_BIOME_SKY_ENABLED
_ytwly3 *= 1.0 - max(clamp(biome_swamp, 0.0, 1.0), clamp(biome_pale_garden, 0.0, 1.0));
#endif
_f2djza += _ytwly3;

#ifdef OVERWORLD_BIOME_SKY_ENABLED

if (biome_swamp > 0.01) {
float _8b6wl9 = smoothstep(0.0, 0.5, _2m4u8p);
vec3 _ky1ent = mix(vec3(66.0, 128.0, 75.0) / 255.0, vec3(144.0, 199.0, 90.0) / 255.0, _8b6wl9);
_ky1ent *= 0.15;
_f2djza = mix(_f2djza, _ky1ent, biome_swamp);
}

if (biome_pale_garden > 0.01) {
float _8b6wl9 = smoothstep(0.0, 0.5, _2m4u8p);
vec3 _4ndk33 = mix(_1iquw2(), _f9f345(), _8b6wl9);
_4ndk33 *= 0.75;
_f2djza = mix(_f2djza, _4ndk33, clamp(biome_pale_garden, 0.0, 1.0));
}
#endif

vec3 _170eou = _f2djza;

#ifdef OVERWORLD_BIOME_SKY_ENABLED
float _gy8koc = (1.0 - clamp(biome_arid, 0.0, 1.0)) * (1.0 - clamp(biome_swamp, 0.0, 1.0));

_gy8koc *= mix(1.0, 0.2, clamp(biome_pale_garden, 0.0, 1.0));
#else
float _gy8koc = 1.0;
#endif
float _v8e0m6 = (1.0 - max(wetness, rainStrength) * (float(CLOUD_RAIN_OPACITY_REDUCTION) / 100.0)) * _gy8koc;

#ifdef WATER_CLOUD_REFLECTIONS_ENABLED
#ifdef CLOUDS_3D_ENABLED
{

if (_a316vw.y > 0.01) {
float _ci50nx = frameTimeCounter;
vec3 _wwcrp0 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec4 _o764ja = _8qfvgd(_a316vw, _ci50nx, worldPos, sunAngle, _wwcrp0, gl_FragCoord.xy, frameCounter);
_o764ja.a *= _v8e0m6;
_o764ja.a *= 0.4;
if (_o764ja.a > 0.001) {

float _btza0b = dot(_o764ja.rgb, vec3(0.299, 0.587, 0.114));
vec3 _d8h605 = _170eou / max(dot(_170eou, vec3(0.299, 0.587, 0.114)), 0.01);
vec3 _s39bdv = mix(_o764ja.rgb, _btza0b * _d8h605 * 1.4, 0.35);
_s39bdv *= 1.6;
_f2djza = mix(_f2djza, _s39bdv, _o764ja.a);
}
}
}
#endif

#ifdef CLOUDS_VANILLA_ENABLED
{
if (_a316vw.y > 0.01) {
float _ci50nx = (float(worldDay) * 24000.0 + float(worldTime)) / 20.0;
vec3 _wwcrp0 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _2nrne3 = 0.0;
vec4 _bmp86u = _l5e5we(_a316vw, _ci50nx, worldPos, sunAngle, _wwcrp0, 30000.0, gl_FragCoord.xy, frameCounter, _2nrne3, _v8e0m6);
_bmp86u.a *= 0.8;
_f2djza = mix(_f2djza, vec3(1.0), _bmp86u.a);
}
}
#endif
#endif

_f2djza *= 1.0 - rainStrength * (float(SKY_RAIN_DARKNESS) / 100.0);

return _f2djza;
#endif
}

vec3 _b617kd(vec3 viewDir, vec3 worldPos) {
return _b617kd(viewDir, worldPos, true);
}

void _xsrmfs(out vec2 _1m1nso, out float _ieukz3, vec3 viewPos, vec3 _pvq5n7, vec3 normal, float _izh8vx, int _7cu6vi) {

_1m1nso = vec2(-1.0);
_ieukz3 = 0.0;

if (!_ksatw5(viewPos) || !_ksatw5(_pvq5n7) || !_ksatw5(normal)) return;

vec3 _53i0wc;
if (!_4lfut5(viewPos, _53i0wc)) return;
vec3 _695tc1 = viewPos + _pvq5n7;
vec3 _mbscnd;
if (!_4lfut5(_695tc1, _mbscnd)) return;
vec2 _hw9j0e = _mbscnd.xy - _53i0wc.xy;
float _7rc5kd = dot(_hw9j0e, _hw9j0e);
if (isnan(_7rc5kd) || isinf(_7rc5kd) || _7rc5kd <= 1e-12) return;
vec2 _22e25i = _hw9j0e * inversesqrt(_7rc5kd);

vec3 _nyp5wo = viewPos + normal * (length(viewPos) * 0.025 + 0.05);
vec3 step = _pvq5n7 * 0.5;
vec3 _ca2vki = _nyp5wo + step;
vec3 _332su6 = step;

int _3dv5eh = 0;
int _0mnly8 = 10;

for (int i = 0; i < REFLECTION_ITERATIONS; i++) {
if (i >= _7cu6vi) break;

vec3 _f86aug;
if (!_4lfut5(_ca2vki, _f86aug)) break;

if (_f86aug.x < -0.05 || _f86aug.x > 1.05 || _f86aug.y < -0.05 || _f86aug.y > 1.05) break;

float _1r3mt9 = textureLod(depthtex1, _f86aug.xy, 0.0).r;
bool _snnxj3 = false;
if (!_7bqo1l(_1r3mt9)) {
float voxyMarker = textureLod(colortex1, _f86aug.xy, 0.0).a;
float voxyDepth = textureLod(vxDepthTexTrans, _f86aug.xy, 0.0).r;
_snnxj3 = _2fqi4q(vxProjInv) && (voxyMarker > 0.999) && _7bqo1l(voxyDepth);
if (_snnxj3) _1r3mt9 = voxyDepth;
}
vec3 _rln4l3;
if (_snnxj3) {
vec4 _ryn7om = vxProjInv * vec4(_f86aug.xy * 2.0 - 1.0, _1r3mt9 * 2.0 - 1.0, 1.0);
float _mojvfu = (abs(_ryn7om.w) < 0.0001) ? (_ryn7om.w < 0.0 ? -0.0001 : 0.0001) : _ryn7om.w;
_rln4l3 = _ryn7om.xyz / _mojvfu;
} else {
_rln4l3 = _uyoa3r(vec3(_f86aug.xy, _1r3mt9));
}
if (!_ksatw5(_rln4l3)) break;
float _gijmlv = length(_ca2vki - _rln4l3);
if (isnan(_gijmlv) || isinf(_gijmlv)) break;

vec2 _69hec0 = _f86aug.xy - _53i0wc.xy;
bool _uvep5q = dot(_69hec0, _22e25i) > 0.0;

if (_gijmlv < length(step) * 3.0 && _uvep5q) {

_3dv5eh++;
if (_3dv5eh >= _0mnly8) {
_1m1nso = _f86aug.xy;

float _84ih2q = smoothstep(0.0, 0.15, min(_f86aug.x, 1.0 - _f86aug.x));
float _2sx3ze = smoothstep(0.0, 0.15, min(_f86aug.y, 1.0 - _f86aug.y));
_ieukz3 = _84ih2q * _2sx3ze;
return;
}
_332su6 -= step;
step *= 0.1;
}
step *= 2.0;
_332su6 += step * (0.95 + 0.1 * _izh8vx);
_ca2vki = _nyp5wo + _332su6;
}
}

void _bciobk(out vec2 _1m1nso, out float _ieukz3, vec3 viewPos, vec3 _pvq5n7, vec3 normal, float _izh8vx) {
_xsrmfs(_1m1nso, _ieukz3, viewPos, _pvq5n7, normal, _izh8vx, REFLECTION_ITERATIONS);
}

void _bciobk(out vec2 _1m1nso, out int _b2xl86, vec3 viewPos, vec3 _pvq5n7, vec3 normal) {
float _ieukz3;
_bciobk(_1m1nso, _ieukz3, viewPos, _pvq5n7, normal, 0.5);
_b2xl86 = (_ieukz3 > 0.001) ? 0 : 1;
}

void _iwnqcb(out vec2 _1m1nso, out int _b2xl86, vec3 viewPos, vec3 _pvq5n7, vec3 normal) {
float _ieukz3;
_xsrmfs(_1m1nso, _ieukz3, viewPos, _pvq5n7, normal, 0.5, max(12, REFLECTION_ITERATIONS / 2));
_b2xl86 = (_ieukz3 > 0.001) ? 0 : 1;
}

void _iwnqcb(out vec2 _1m1nso, out int _b2xl86, vec3 viewPos, vec3 _pvq5n7, vec3 normal, float _izh8vx) {
float _ieukz3;
_xsrmfs(_1m1nso, _ieukz3, viewPos, _pvq5n7, normal, _izh8vx, max(12, REFLECTION_ITERATIONS / 2));
_b2xl86 = (_ieukz3 > 0.001) ? 0 : 1;
}

void _rynysb(inout vec3 _yssmf1, vec3 viewPos, vec3 normal, vec2 lmcoord, float _8eveno, vec2 _ejrvz6, vec3 _axybuj, float _kytein, float _qukog8, float _ltufhy) {

vec3 _4h0q23 = reflect(
_lhz76c(viewPos, vec3(0.0, 0.0, -1.0)),
_lhz76c(normal, vec3(0.0, 1.0, 0.0)));
vec2 _1m1nso = vec2(0.0);
float _ieukz3 = 0.0;
float _izh8vx = _jwhmer(gl_FragCoord.xy);
float _fg3u4k = length(viewPos);
float _rp6zu1 = 1.0 - smoothstep(float(SSR_RENDER_DISTANCE) * 0.8, float(SSR_RENDER_DISTANCE), _fg3u4k);
if (_rp6zu1 > 0.001) {
_bciobk(_1m1nso, _ieukz3, viewPos, _4h0q23, normal, _izh8vx);
_ieukz3 *= _rp6zu1;
}

float _oun1yh = WATER_REFLECTION_FADE;
_oun1yh = clamp(_oun1yh, 0.0, 1.0);
_8eveno *= _oun1yh;

vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz + cameraPosition;

float wt = frameTimeCounter * WATER_WAVE_SPEED;
vec2 wp = worldPos.xz * WATER_WAVE_SCALE * 2.5;
float _5mtaqu = sin(wp.x * 3.0 + wp.y * 0.3 + wt * 1.5) * 0.5
+ sin(wp.x * 5.0 + wp.y * 0.5 + wt * 2.2) * 0.3
+ sin(wp.x * 8.0 + wp.y * 0.2 + wt * 3.0) * 0.2;
float _tln1mq = sin(wp.x * 0.3 + wp.y * 3.0 + wt * 1.3) * 0.5
+ sin(wp.x * 0.5 + wp.y * 5.0 + wt * 2.0) * 0.3;

_1m1nso.x += _5mtaqu * 0.004;
_1m1nso.y += _tln1mq * 0.003;

vec3 _yaxxkp = _4h0q23;
_yaxxkp.x += _5mtaqu * 0.01;
_yaxxkp.z += _tln1mq * 0.01;
_yaxxkp = normalize(_yaxxkp);
vec3 skyColor = _b617kd(_yaxxkp, worldPos, false);

float _o83x07 = fract(sunAngle);

float _oza5cp = smoothstep(0.46, 0.54, _o83x07);
float _216yx9 = _oza5cp;
float _ccwnxp = mix(1.0, 0.6, _216yx9);

float _kn8e39 = smoothstep(0.54, 0.59, _o83x07) * (1.0 - smoothstep(0.92, 0.96, _o83x07));
_ccwnxp = mix(_ccwnxp, 1.0, _kn8e39);
float _s3nh3t = smoothstep(0.92, 0.96, _o83x07);
_ccwnxp = mix(_ccwnxp, 0.99, _s3nh3t);
skyColor *= _ccwnxp;

if (isEyeInWater == 1) {
skyColor = 0.08 + 0.125 * skyColor;
skyColor += vec3(0.0, 0.03, 0.3);
}

const float _c0rtq2 = 0.2;

vec3 _okt9rq = vec3(0.0);
if (_ieukz3 > 0.001) {
float _al56vw = textureLod(depthtex0, _1m1nso, 0.0).r;
float _fup0jp = textureLod(depthtex1, _1m1nso, 0.0).r;
float _7y3zbt = textureLod(colortex1, _1m1nso, 0.0).a;
bool _6u4bf0 = (_7y3zbt > 0.999);

bool _y5f1cl = (_al56vw < _fup0jp - 0.0001);

if (!_7bqo1l(_al56vw) && !_6u4bf0) {
_ieukz3 = 0.0;
} else {
_okt9rq = textureLod(colortex0, _1m1nso, 0.0).rgb;
}

}

float _yiw2gu = clamp(lmcoord.y, 0.0, 1.0);

vec3 _rgmci6 = skyColor * _qukog8;

float _8hrnao = dot(_rgmci6, vec3(0.299, 0.587, 0.114));
_rgmci6 = mix(vec3(_8hrnao), _rgmci6, _ltufhy);
_rgmci6 *= (1.0 - _c0rtq2) + _yssmf1 * _c0rtq2;
_rgmci6 = mix(_yssmf1, _rgmci6, _yiw2gu);

_okt9rq *= 1.0;

if (_ieukz3 > 0.001) {

vec4 _htidvn = _4zvj3d(colortex9, _1m1nso);
if (_htidvn.a > 0.001) {
_okt9rq = _htidvn.rgb + _okt9rq * (1.0 - _htidvn.a);
}

vec4 _rto6k7 = _4zvj3d(colortex10, _1m1nso);
if (_rto6k7.a > 0.001) {
_okt9rq = _rto6k7.rgb + _okt9rq * (1.0 - _rto6k7.a);
}

vec4 _4910fl = _4zvj3d(colortex11, _1m1nso);
if (_4910fl.a > 0.001) {
_okt9rq = _4910fl.rgb + _okt9rq * (1.0 - _4910fl.a);
}
}

float _eik6px = mix(0.85, 0.35, _yiw2gu);
vec3 _r2cg20 = mix(_rgmci6, _okt9rq, _eik6px);
vec3 _h7o26u = mix(_rgmci6, _r2cg20, _ieukz3);
_yssmf1 = mix(_yssmf1, _h7o26u, _8eveno);

}

void _8g66fe(inout vec3 _yssmf1, vec3 viewPos, vec3 normal, vec2 lmcoord, float _8eveno, vec2 _ejrvz6, vec3 _axybuj, float _kytein) {
_rynysb(_yssmf1, viewPos, normal, lmcoord, _8eveno, _ejrvz6, _axybuj, _kytein, 1.5, WATER_SATURATION);
}

#ifndef MATERIAL_SSR_BRIGHTNESS
#define MATERIAL_SSR_BRIGHTNESS 1.6
#endif

void _s6xcsn(inout vec3 _yssmf1, vec3 viewPos, vec3 normal, float _8eveno, float skylight, float _fofpth) {
vec3 _a3mynb = _yssmf1;
float _uhyaha = dot(_a3mynb, vec3(0.299, 0.587, 0.114));
if (_fofpth < -0.5) {
_fofpth = (_uhyaha < 0.33) ? 1.0 : ((_uhyaha < 0.66) ? 0.45 : 0.0);
}
_fofpth = clamp(_fofpth, 0.0, 1.0);

vec3 _1yp0c6 = _lhz76c(normal, vec3(0.0, 1.0, 0.0));

float _4442v5 = _jwhmer(gl_FragCoord.xy);
vec3 _4h0q23 = reflect(_lhz76c(viewPos, vec3(0.0, 0.0, -1.0)), _1yp0c6);
vec2 _1m1nso;
int _b2xl86;
_iwnqcb(_1m1nso, _b2xl86, viewPos, _4h0q23, _1yp0c6, _4442v5);

float _yiw2gu = step(14.0 / 15.0, skylight);
vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz + cameraPosition;
vec3 skyColor = _b617kd(_4h0q23, worldPos) * 0.8 * _yiw2gu;

const float _r9zrs2 = 0.0;
vec3 _w9iaza = (_uhyaha > 0.01) ? _a3mynb / _uhyaha : vec3(1.0);
_w9iaza = clamp(_w9iaza, vec3(0.0), vec3(3.0));

vec3 _d0t5tf = normalize(mat3(gbufferModelViewInverse) * normal);
float _5l5nx9 = abs(_d0t5tf.y);
_8eveno *= mix(0.1, 1.0, _5l5nx9 * _5l5nx9);

if (_b2xl86 == 2) {
_yssmf1 = mix(_yssmf1, _yssmf1, _8eveno);
} else if (_b2xl86 == 0) {
float _uel2dt = textureLod(colortex1, _1m1nso, 0.0).a;
bool _foalho = (_uel2dt > 0.001 && _uel2dt < 0.999);
float _9sprd9 = min(textureLod(depthtex2, _1m1nso, 0.0).r, textureLod(depthtex1, _1m1nso, 0.0).r);
if (_foalho) {

_yssmf1 = mix(_yssmf1, _yssmf1, _8eveno);
} else if (_7bqo1l(_9sprd9)) {

ivec2 _8a8qlk = clamp(ivec2(_1m1nso * vec2(viewWidth, viewHeight)), ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));
float _fpz5j1 = clamp(_fofpth, 0.0, 1.0);
vec3 _bzfvkg = _uyoa3r(vec3(_1m1nso, _9sprd9));
float _qkxuay = length(_bzfvkg - viewPos);
float _1yqpch = 1.0 - exp(-0.125 * _fpz5j1 * _qkxuay);
float _vbgwry = log2(max(viewHeight / 8.0 * _fpz5j1 * _1yqpch, 1.0)) * 0.45;
_vbgwry = max(_vbgwry - 1.0, 0.0);
vec3 _h7o26u = (_fpz5j1 > 0.001)
? textureLod(colortex0, _1m1nso, _vbgwry).rgb
: texelFetch(colortex0, _8a8qlk, 0).rgb;
float _gmp6zb = texelFetch(colortex1, _8a8qlk, 0).b;

float _zl3odk = smoothstep(4.0 / 15.0, 8.0 / 15.0, _gmp6zb);
vec4 _ilgw2b = _4zvj3d(colortex9, _1m1nso) * _zl3odk;
if (_ilgw2b.a > 0.001) {
_h7o26u = _ilgw2b.rgb + _h7o26u * (1.0 - _ilgw2b.a);
}
vec4 _cgf1z3 = _4zvj3d(colortex10, _1m1nso);
if (_cgf1z3.a > 0.001) {
_h7o26u = _cgf1z3.rgb + _h7o26u * (1.0 - _cgf1z3.a);
}
vec4 _jjnn6r = _4zvj3d(colortex11, _1m1nso);
if (_jjnn6r.a > 0.001) {
_h7o26u = _jjnn6r.rgb + _h7o26u * (1.0 - _jjnn6r.a);
}

float _84ih2q = smoothstep(0.0, 0.15, min(_1m1nso.x, 1.0 - _1m1nso.x));
float _2sx3ze = smoothstep(0.0, 0.15, min(_1m1nso.y, 1.0 - _1m1nso.y));
float _a9osj3 = _84ih2q * _2sx3ze;

vec3 _emypmh = mix(skyColor, _h7o26u, _a9osj3);
_emypmh *= MATERIAL_SSR_BRIGHTNESS;
float _sd117h = dot(_emypmh, vec3(0.299, 0.587, 0.114));
vec3 _u2f4jp = _sd117h * _w9iaza;
_yssmf1 = mix(_yssmf1, mix(_emypmh, _u2f4jp, _r9zrs2), _8eveno);
} else {

vec3 _njg2v4 = skyColor * MATERIAL_SSR_BRIGHTNESS;
float _vz05vc = dot(_njg2v4, vec3(0.299, 0.587, 0.114));
vec3 _beb1g7 = _vz05vc * _w9iaza;
_yssmf1 = mix(_yssmf1, mix(_njg2v4, _beb1g7, _r9zrs2), _8eveno);
}
} else {

vec3 _njg2v4 = skyColor * MATERIAL_SSR_BRIGHTNESS;
float _vz05vc = dot(_njg2v4, vec3(0.299, 0.587, 0.114));
vec3 _beb1g7 = _vz05vc * _w9iaza;
_yssmf1 = mix(_yssmf1, mix(_njg2v4, _beb1g7, _r9zrs2), _8eveno);
}
}

void _s6xcsn(inout vec3 _yssmf1, vec3 viewPos, vec3 normal, float _8eveno) {
_s6xcsn(_yssmf1, viewPos, normal, _8eveno, 0.0, -1.0);
}

void _s6xcsn(inout vec3 _yssmf1, vec3 viewPos, vec3 normal, float _8eveno, float skylight) {
_s6xcsn(_yssmf1, viewPos, normal, _8eveno, skylight, -1.0);
}

#endif
