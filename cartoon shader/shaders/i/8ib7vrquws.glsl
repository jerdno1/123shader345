#include "/include/biome_color_smoothing.glsl"

vec3 _46ejjv(vec3 _yssmf1, float _a8645a) {
vec3 _s0lzby = _j0nlr9(_yssmf1);
_s0lzby.y = clamp(_s0lzby.y * _a8645a, 0.0, 1.0);
return _ks5u3i(_s0lzby);
}

vec3 _hbv38n() {
if (_0rit85()) {
return max(fogColor, skyColor * 0.8);
}

if (_9cwhip(biome)) {
return _ktauxr(biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B));
}
#ifdef END_FOG_ENABLED
if (_h6zv90()) {
return (vec3(END_FOG_R, END_FOG_G, END_FOG_B) * 3.0 + vec3(0.02, 0.01, 0.04)) * END_SKY_BRIGHTNESS;
}
#endif

TimeWeights tw = getTimeWeights(sunAngle);

vec3 _h4of6g = vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B);
vec3 _gmfo88 = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);
vec3 _x70tse = _tvhml8(fogColor);
vec3 _bonu7f = _un92z1(skyColor);
float _rxs39p = _jpbsbi(biome_snowy);
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _9yfvgh = _za404r(biome_arid);
float _fgx2j8 = _g4a6za(_i0sr2e(biome_savanna), _lfojrz);
float _xmiuzq = _90d23l(biome_ocean);

float _xnhnuy = max(max(max(max(_rxs39p, _2d13on), max(_lfojrz, _9yfvgh)), _fgx2j8), clamp(biome_pale_garden, 0.0, 1.0));
bool _bd3ss9 = _xnhnuy > 0.001;

float _4odmh4 = max(length(_bonu7f - _gmfo88), length(_x70tse - _h4of6g));
float _7e4wx1 = max(smoothstep(0.03, 0.18, _4odmh4), _xmiuzq);
float _15ht8g = _bd3ss9 ? 1.0 : (SKY_BIOME_BLEND * _7e4wx1);
float _4mmo09 = _15ht8g;

vec3 _6soi7f = _af4aog(_h4of6g, _rxs39p, _2d13on, _lfojrz, _9yfvgh, _fgx2j8);
float _hmmwvh = tw.sunset + tw.sunrise;
if (!_bd3ss9 && _7e4wx1 > 0.001) {
float _qj2t5d = clamp(_hmmwvh, 0.0, 1.0);
float _b75lc4 = mix(1.0, 0.35, _qj2t5d);
float _m6i4ih = dot(_x70tse, vec3(0.299, 0.587, 0.114));
vec3 _8ol529 = mix(vec3(_m6i4ih), _x70tse, _b75lc4);
_6soi7f = mix(_6soi7f, _8ol529, _7e4wx1);
}

vec3 _mlvzfk = mix(_h4of6g, _6soi7f, _4mmo09);
vec3 _9cn7gb = vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B);
vec3 _9z0hmw = vec3(BLUEHOUR_HORIZON_R, BLUEHOUR_HORIZON_G, BLUEHOUR_HORIZON_B);
vec3 _zu1sj9 = vec3(NIGHT_HORIZON_R, NIGHT_HORIZON_G, NIGHT_HORIZON_B);
vec3 _ttpo7r = vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B);
vec3 _px26is = vec3(DAWN_HORIZON_R, DAWN_HORIZON_G, DAWN_HORIZON_B);

_mlvzfk = _46ejjv(_mlvzfk, SKY_SATURATION);
_9cn7gb = _46ejjv(_9cn7gb, SKY_SATURATION);
_9z0hmw = _46ejjv(_9z0hmw, SKY_SATURATION);
_zu1sj9 = _46ejjv(_zu1sj9, SKY_SATURATION);
_ttpo7r = _46ejjv(_ttpo7r, SKY_SATURATION);
_px26is = _46ejjv(_px26is, SKY_SATURATION);

if (_fgx2j8 > 0.001) {
float _purj7z = clamp(_fgx2j8 * _4mmo09, 0.0, 1.0);
_mlvzfk = mix(_mlvzfk, _e6gplv(), _purj7z);
}

vec3 _yssmf1 = _mlvzfk     * DAY_BRIGHTNESS      * tw.day
+ _9cn7gb  * SUNSET_BRIGHTNESS    * tw.sunset
+ _9z0hmw    * BLUEHOUR_BRIGHTNESS  * tw.blueHour
+ _zu1sj9   * NIGHT_BRIGHTNESS     * tw.night
+ _ttpo7r * SUNRISE_BRIGHTNESS   * tw.sunrise
+ _px26is    * DAWN_BRIGHTNESS      * tw.dawn;

float _92388v = min(tw.day, tw.sunset) * 2.0;
_yssmf1 = mix(_yssmf1, vec3(0.9, 0.15, 0.85) * mix(DAY_BRIGHTNESS, SUNSET_BRIGHTNESS, 0.5), _92388v * 0.5);
float _4am4t1 = min(tw.sunset, tw.blueHour) * 2.0;
_yssmf1 = mix(_yssmf1, vec3(0.4, 0.1, 1.0) * mix(SUNSET_BRIGHTNESS, BLUEHOUR_BRIGHTNESS, 0.5), _4am4t1 * 0.5);

return _yssmf1;
}

vec3 _asihvs() {
if (_0rit85()) {
return max(fogColor, skyColor * 0.8);
}

if (_9cwhip(biome)) {
return _ktauxr(biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B));
}

#ifdef END_FOG_ENABLED
if (_h6zv90()) {
return (vec3(END_FOG_R, END_FOG_G, END_FOG_B) * 3.0 + vec3(0.02, 0.01, 0.04)) * END_SKY_BRIGHTNESS;
}
#endif

TimeWeights tw = getTimeWeights(sunAngle);

vec3 _h4of6g = vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B);
vec3 _gmfo88 = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);
vec3 _x70tse = _tvhml8(fogColor);
vec3 _bonu7f = _un92z1(skyColor);
float _rxs39p = _jpbsbi(biome_snowy);
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _9yfvgh = _za404r(biome_arid);
float _fgx2j8 = _g4a6za(_i0sr2e(biome_savanna), _lfojrz);
float _xmiuzq = _90d23l(biome_ocean);

float _xnhnuy = max(max(max(max(_rxs39p, _2d13on), max(_lfojrz, _9yfvgh)), _fgx2j8), clamp(biome_pale_garden, 0.0, 1.0));
bool _bd3ss9 = _xnhnuy > 0.001;

float _4odmh4 = max(length(_bonu7f - _gmfo88), length(_x70tse - _h4of6g));
float _7e4wx1 = max(smoothstep(0.03, 0.18, _4odmh4), _xmiuzq);

float _15ht8g = _bd3ss9 ? 1.0 : (SKY_BIOME_BLEND * _7e4wx1);
float _4mmo09 = _15ht8g;

float _xw0lfi = 0.15;

vec3 _6soi7f = _af4aog(_h4of6g, _rxs39p, _2d13on, _lfojrz, _9yfvgh, _fgx2j8);
float _hmmwvh = tw.sunset + tw.sunrise;
if (!_bd3ss9 && _7e4wx1 > 0.001) {
float _qj2t5d = clamp(_hmmwvh, 0.0, 1.0);
float _b75lc4 = mix(1.0, 0.35, _qj2t5d);
float _m6i4ih = dot(_x70tse, vec3(0.299, 0.587, 0.114));
vec3 _8ol529 = mix(vec3(_m6i4ih), _x70tse, _b75lc4);
_6soi7f = mix(_6soi7f, _8ol529, _7e4wx1);
}

vec3 _n6yb0b = mix(vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B),
vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B),
smoothstep(0.0, max(DAY_ZENITH_HEIGHT, 0.001), _xw0lfi));
_n6yb0b = mix(_n6yb0b, _6soi7f, _4mmo09);
if (_fgx2j8 > 0.001) {
float _purj7z = clamp(_fgx2j8 * _4mmo09, 0.0, 1.0);
_n6yb0b = mix(_n6yb0b, _e6gplv(), _purj7z);
}

vec3 _u1f3pc = mix(vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B),
vec3(SUNSET_ZENITH_R, SUNSET_ZENITH_G, SUNSET_ZENITH_B),
smoothstep(0.0, max(SUNSET_ZENITH_HEIGHT, 0.001), _xw0lfi));

vec3 _mfnwiu = mix(vec3(BLUEHOUR_HORIZON_R, BLUEHOUR_HORIZON_G, BLUEHOUR_HORIZON_B),
vec3(BLUEHOUR_ZENITH_R, BLUEHOUR_ZENITH_G, BLUEHOUR_ZENITH_B),
smoothstep(0.0, max(BLUEHOUR_ZENITH_HEIGHT, 0.001), _xw0lfi));

vec3 _kfo8lp = mix(vec3(NIGHT_HORIZON_R, NIGHT_HORIZON_G, NIGHT_HORIZON_B),
vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B),
smoothstep(0.0, max(NIGHT_ZENITH_HEIGHT, 0.001), _xw0lfi));

vec3 _v84gll = mix(vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B),
vec3(SUNRISE_ZENITH_R, SUNRISE_ZENITH_G, SUNRISE_ZENITH_B),
smoothstep(0.0, max(SUNSET_ZENITH_HEIGHT, 0.001), _xw0lfi));

vec3 _hu0453 = mix(vec3(DAWN_HORIZON_R, DAWN_HORIZON_G, DAWN_HORIZON_B),
vec3(DAWN_ZENITH_R, DAWN_ZENITH_G, DAWN_ZENITH_B),
smoothstep(0.0, max(BLUEHOUR_ZENITH_HEIGHT, 0.001), _xw0lfi));

vec3 _yssmf1 = _n6yb0b     * DAY_BRIGHTNESS     * tw.day
+ _u1f3pc  * SUNSET_BRIGHTNESS   * tw.sunset
+ _mfnwiu    * BLUEHOUR_BRIGHTNESS * tw.blueHour
+ _kfo8lp   * NIGHT_BRIGHTNESS    * tw.night
+ _v84gll * SUNRISE_BRIGHTNESS  * tw.sunrise
+ _hu0453    * DAWN_BRIGHTNESS     * tw.dawn;

float _92388v = min(tw.day, tw.sunset) * 2.0;
_yssmf1 = mix(_yssmf1, vec3(0.9, 0.15, 0.85) * mix(DAY_BRIGHTNESS, SUNSET_BRIGHTNESS, 0.5), _92388v * 0.5);
float _4am4t1 = min(tw.sunset, tw.blueHour) * 2.0;
_yssmf1 = mix(_yssmf1, vec3(0.4, 0.1, 1.0) * mix(SUNSET_BRIGHTNESS, BLUEHOUR_BRIGHTNESS, 0.5), _4am4t1 * 0.5);

return _yssmf1;
}

#if defined(NETHER_FOG_ENABLED) || defined(END_FOG_ENABLED) || defined(OVERWORLD_FOG_ENABLED)

vec4 _ycfkak(vec2 uv, float _1r3mt9, vec3 _bu16tm, bool _yjolhc, bool _o6he16) {
vec3 _zflroq = cameraPosition;
float _0nlczg = length(_bu16tm - _zflroq);

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome)) {
float fogStart = max(NETHER_DISTANCE_FOG_START, 0.0);
float fogEnd = max(float(NETHER_FOG_DISTANCE), fogStart + 1.0);
float _7xutmf = clamp((_0nlczg - fogStart) / max(fogEnd - fogStart, 1.0), 0.0, 1.0);
float _3tqs27 = max(NETHER_DISTANCE_FOG_OPACITY, 0.01);
float _jv741z = 1.0 - exp(-_7xutmf * _7xutmf * _3tqs27 * 2.2);
_jv741z = clamp(_jv741z, 0.0, 0.98);
if (_o6he16) _jv741z = clamp(_jv741z * 1.1, 0.0, 0.98);

vec3 _mm59u8 = _ktauxr(biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B)) * NETHER_BRIGHTNESS;
return vec4(_mm59u8 * _jv741z, 1.0 - _jv741z);
}
#endif

#ifdef END_FOG_ENABLED
if (_h6zv90()) {
if (_yjolhc) return vec4(0.0, 0.0, 0.0, 1.0);
float _cfps05 = max(float(END_FOG_DISTANCE) - END_FOG_START, 1.0);
float _7xutmf = clamp((_0nlczg - END_FOG_START) / _cfps05, 0.0, 1.0);
float _3tqs27 = max(END_FOG_DENSITY, 0.01);

float _jv741z = 1.0 - exp(-_7xutmf * _7xutmf * _7xutmf * _3tqs27 * 4.0);
_jv741z = clamp(_jv741z, 0.0, 0.95);

vec3 _cw24yu = vec3(END_FOG_R, END_FOG_G, END_FOG_B);
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
float _1ynvp2 = getEndEvent(frameTimeCounter).fogDarkness;
_cw24yu *= (1.0 - _1ynvp2);
_jv741z *= (1.0 - _1ynvp2);
#endif
return vec4(_cw24yu * _jv741z, 1.0 - _jv741z);
}
#endif

#ifdef OVERWORLD_FOG_ENABLED
if (!_9cwhip(biome) && !_h6zv90() && !_0rit85()) {
if (_yjolhc) return vec4(0.0, 0.0, 0.0, 1.0);

float _pgwpjq = rainStrength * 0.6;
float fogStart = OVERWORLD_FOG_START * (1.0 - _pgwpjq);
float _db7zd8 = float(OVERWORLD_FOG_DISTANCE) * (1.0 - _pgwpjq);

float _0ayy90 = max(_0nlczg - fogStart, 0.0);

float _3tqs27 = max(OVERWORLD_FOG_DENSITY + rainStrength * OVERWORLD_FOG_RAIN_BOOST, 0.01);

float _zr9s8f = (_3tqs27 * 3.0) / max(_db7zd8, 1.0);
float _jv741z = 1.0 - exp(-_0ayy90 * _0ayy90 * _zr9s8f * _zr9s8f);

if (_o6he16) _jv741z = clamp(_jv741z * 1.15, 0.0, 0.98);
_jv741z = clamp(_jv741z, 0.0, 1.0);

vec3 _4u9hwj = _hbv38n();

float _gj2dau = _2vpc5n(biome_swamp, biome, biome_category);
if (_gj2dau > 0.001) {
vec3 _q0458a = vec3(66.0, 128.0, 75.0) / 255.0;

float _jj00jp = dot(_4u9hwj, vec3(0.299, 0.587, 0.114));
float _r72vo3 = dot(_q0458a, vec3(0.299, 0.587, 0.114));
vec3 _plv7zr = (_r72vo3 > 0.001) ? _q0458a * (_jj00jp / _r72vo3) : _q0458a;
_4u9hwj = mix(_4u9hwj, _plv7zr, _gj2dau);
}

_4u9hwj *= 1.0 - rainStrength * (float(SKY_RAIN_DARKNESS) / 100.0);

return vec4(_4u9hwj * _jv741z, 1.0 - _jv741z);
}
#endif

return vec4(0.0, 0.0, 0.0, 1.0);
}
#endif
