#ifndef VOXY_COMPAT_GLSL
#define VOXY_COMPAT_GLSL

#include "/include/sky_timeline.glsl"

float voxy_luma(vec3 c) {
return dot(c, vec3(0.299, 0.587, 0.114));
}

vec3 voxy_normalize_light_color(vec3 c) {
float _zdxp7g = voxy_luma(c);
vec3 n = c / max(_zdxp7g, 0.35);
return clamp(n, vec3(0.0), vec3(2.0));
}

vec3 voxy_apply_color_adjust(vec3 _yssmf1) {

float _ini8tm = mix(VOXY_CONTRAST, 1.0, 0.5);
float _66r7n6 = mix(VOXY_SATURATION, 1.0, 0.3);
_yssmf1 = (_yssmf1 - 0.5) * _ini8tm + 0.5;
_yssmf1 = max(_yssmf1, vec3(0.0));
float l = voxy_luma(_yssmf1);
_yssmf1 = mix(vec3(l), _yssmf1, _66r7n6);

if (VOXY_HIGHLIGHT_COMPRESS > 0.001) {
_yssmf1 = _yssmf1 / (_yssmf1 + vec3(VOXY_HIGHLIGHT_COMPRESS));
_yssmf1 *= (1.0 + VOXY_HIGHLIGHT_COMPRESS);
}

return _yssmf1;
}

uint voxy_block_id(uint _6ud75j) {
return (_6ud75j >= 10000u) ? (_6ud75j - 10000u) : _6ud75j;
}

vec3 voxy_face_normal(uint face) {
vec3 _b4bg8y = vec3(
float((face >> 1u) == 2u),
float((face >> 1u) == 0u),
float((face >> 1u) == 1u)
);
float sign = float((int(face) & 1) * 2 - 1);
return _b4bg8y * sign;
}

vec4 voxy_time_of_day_lighting(float sunAngle) {
vec2 bd = _bxr2n6(sunAngle);
TimeWeightsSimple ts = getTimeWeightsSimple(sunAngle);
return vec4(bd.x, bd.y, ts.day, ts.twilight);
}

vec3 voxy_tod_skylight_tint(float sunAngle) {
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

return voxy_normalize_light_color(_od2x3w);
}

float voxy_blocklight_falloff(float blocklight) {
float x = clamp(blocklight, 0.0, 1.0);
float _jja8pn = x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
_jja8pn *= smoothstep(0.0, 0.15, x);
return _jja8pn;
}

float voxy_face_shade(uint face) {
float shadeValues[6] = float[6](
0.85,
1.0,
0.92,
0.92,
0.88,
0.88
);
return shadeValues[min(face, 5u)];
}

vec3 voxy_hueToRGB(float _e30o2u) {
float h = mod(_e30o2u, 360.0) / 60.0;
float x = 1.0 - abs(mod(h, 2.0) - 1.0);
vec3 rgb;
if (h < 1.0) rgb = vec3(1.0, x, 0.0);
else if (h < 2.0) rgb = vec3(x, 1.0, 0.0);
else if (h < 3.0) rgb = vec3(0.0, 1.0, x);
else if (h < 4.0) rgb = vec3(0.0, x, 1.0);
else if (h < 5.0) rgb = vec3(x, 0.0, 1.0);
else rgb = vec3(1.0, 0.0, x);
return rgb;
}

vec3 voxy_applySaturation(vec3 c, float _a8645a) {
float _zdxp7g = voxy_luma(c);
return mix(vec3(_zdxp7g), c, max(_a8645a, 0.0));
}

vec3 voxy_static_night_tint() {
vec3 _1zva4i = vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B);
return voxy_normalize_light_color(_1zva4i);
}

vec3 voxy_static_night_tint_lit() {
vec3 _wj125h = voxy_static_night_tint();
float _4knsqu = clamp(SKYLIGHT_TINT_LIGHT_SATURATION, 0.0, 1.0);
float _b7pzhz = mix(1.0, SKYLIGHT_TINT_SATURATION, _4knsqu);
return voxy_normalize_light_color(voxy_applySaturation(_wj125h, _b7pzhz));
}

float voxy_quantized_light_level(float _8ores8) {
return floor(clamp(_8ores8, 0.0, 1.0) * 15.0 + 0.001);
}

float voxy_vanilla_skylight_brightness(float skylight) {
float _8ores8 = clamp(skylight, 0.0, 1.0);
return _8ores8 / (4.0 - 3.0 * _8ores8);
}

float voxy_has_skylight_mask(float skylight) {

return smoothstep(1.0 / 15.0, 2.0 / 15.0, clamp(skylight, 0.0, 1.0));
}

float voxy_zero_skylight_mask(float skylight) {
return 1.0 - voxy_has_skylight_mask(skylight);
}

float voxy_zero_blocklight_mask(float blocklight) {
return 1.0 - smoothstep(0.0, 4.0 / 15.0, clamp(blocklight, 0.0, 1.0));
}

float voxy_night_darken_amount(float _y22te0, float skylight, float blocklight) {
float _h0gyrr = 1.0 - smoothstep(0.0, 0.35, _y22te0);
float _bvx9v2 = voxy_has_skylight_mask(skylight);
float _fbq83g = 1.0 - smoothstep(0.45, 0.95, blocklight);
return NIGHT_DARKNESS * _h0gyrr * _bvx9v2 * _fbq83g;
}

float voxy_weather_darken_amount(float _y22te0, float skylight, float blocklight) {
float _xya605 = smoothstep(0.28, 0.88, _y22te0);
float _bvx9v2 = voxy_has_skylight_mask(skylight);
float _fbq83g = 1.0 - smoothstep(0.30, 0.95, blocklight);
float _7yk8g4 = float(SKY_RAIN_DARKNESS) / 100.0;
return rainStrength * _xya605 * _bvx9v2 * _fbq83g * _7yk8g4;
}

float voxy_pale_garden_darken_amount(float _y22te0, float skylight, float blocklight) {
#ifdef VOXY_HAS_SSBO
float _d8tv7f = clamp(smoothPaleGarden, 0.0, 1.0);
#else
float _d8tv7f = 0.0;
#endif
if (_d8tv7f < 0.001) return 0.0;
float _xya605 = smoothstep(0.28, 0.88, _y22te0);
float _bvx9v2 = voxy_has_skylight_mask(skylight);
float _fbq83g = 1.0 - smoothstep(0.30, 0.95, blocklight);
return _d8tv7f * _xya605 * _bvx9v2 * _fbq83g;
}

float voxy_cave_look_amount(float skylight, float blocklight) {
float _m4wjgb = 1.0 - smoothstep(0.00, 7.0 / 15.0, skylight);
float _o57m7d = voxy_zero_blocklight_mask(blocklight);
return _m4wjgb * _o57m7d;
}

float voxy_cave_tint_amount(float skylight, float blocklight) {
if (isEyeInWater == 1) return 0.0;
float _m4wjgb = 1.0 - smoothstep(0.00, 14.0 / 15.0, skylight);
float _o57m7d = voxy_zero_blocklight_mask(blocklight);
return _m4wjgb * _o57m7d;
}

float voxy_cave_darken_amount(float skylight, float blocklight) {
if (isEyeInWater == 1) return 0.0;
float _zlrjo9 = voxy_cave_tint_amount(skylight, blocklight);
return CAVE_DARKNESS * _zlrjo9 * _zlrjo9;
}

float voxy_shadow_transition_dip(float sunAngle) {
float _huatah = fract(sunAngle);
float _e3y9j5 = smoothstep(0.46, 0.5146, _huatah) * (1.0 - smoothstep(0.5146, 0.57, _huatah));
float _wsgqoz = max(
smoothstep(0.93, 0.9854, _huatah),
1.0 - smoothstep(0.0146, 0.07, _huatah)
);
return max(_e3y9j5, _wsgqoz);
}

float voxy_shadow_transition_shadow_floor(float _y22te0, float skylight) {
float _6l75mg = 1.0 - smoothstep(0.0, 0.25, _y22te0);
return 0.15 * clamp(skylight, 0.0, 1.0) * (1.0 - _6l75mg * 0.75);
}

float voxy_shadow_transition_darken(float _jvfij5, float _y22te0, float skylight) {
float _lbybrk = voxy_shadow_transition_shadow_floor(_y22te0, skylight);
float _02ivcw = mix(1.0, _lbybrk, SHADOW_OPACITY);
return mix(1.0, _02ivcw, _jvfij5);
}

float voxy_pack_shadow_baseline(float _hg321h) {
return 0.5 + 0.5 * clamp(_hg321h, 0.0, 1.0);
}

float voxy_unpack_shadow_baseline(float _x3uqxw) {
return clamp((_x3uqxw - 0.5) * 2.0, 0.0, 1.0);
}

vec3 voxy_apply_chunk_like_lighting(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float _703fao, float _hg321h) {
vec4 _jqmu3t = voxy_time_of_day_lighting(sunAngle);
float _y22te0 = _jqmu3t.x;
float _q3g0w9 = _jqmu3t.y;
float _z92ecz = _jqmu3t.z;
float _ywrw46 = _jqmu3t.w;

float voxyAngle = fract(sunAngle);

float _7vcusu = (1.0 - step(0.5, voxy_quantized_light_level(skylight))) * (1.0 / 15.0);
float _mv1tmz = voxy_vanilla_skylight_brightness(max(skylight, _7vcusu));

float _aixrz9 = smoothstep(0.25, 0.85, _y22te0);
float _54juxd;
float _2pv68z;
vec3 blockLight;
float _41uucb;
#if !defined(LPV_ENABLED) && !defined(END_SHADER)

_54juxd = clamp(blocklight, 0.0, 1.0);
float _9pc7u4 = voxy_vanilla_skylight_brightness(_54juxd);
_2pv68z = sqrt(_9pc7u4);
blockLight = vec3(1.0, 0.9, 0.8) * _2pv68z * BLOCKLIGHT_BRIGHTNESS;
_41uucb = 1.0 - smoothstep(5.0 / 15.0, 1.0, _mv1tmz * _aixrz9);
#else
_54juxd = clamp(blocklight * (1.0 - BLOCKLIGHT_SKYLIGHT_REDUCTION * _mv1tmz * _aixrz9), 0.0, 1.0);
_2pv68z = voxy_blocklight_falloff(_54juxd);
blockLight = vec3(1.0, 0.9, 0.8) * _2pv68z * _2pv68z * BLOCKLIGHT_BRIGHTNESS;
_41uucb = 1.0 - smoothstep(0.6, 1.0, _mv1tmz * _aixrz9);
#endif

float _zpw0c7 = smoothstep(0.38, 0.45, voxyAngle) * (1.0 - smoothstep(0.48, 0.55, voxyAngle))
+ smoothstep(0.95, 1.0, voxyAngle) + (1.0 - smoothstep(0.0, 0.05, voxyAngle));

float _nf77dj = smoothstep(0.07, 0.15, voxyAngle) * (1.0 - smoothstep(0.40, 0.46, voxyAngle));
float _ydmrin = smoothstep(0.58, 0.66, voxyAngle) * (1.0 - smoothstep(0.92, 0.98, voxyAngle));
float _grvh4h = SKYLIGHT_COLOR_TINT
* (1.0 - _nf77dj * 0.6)
* (1.0 - _ydmrin * 0.7);
float _kytein = clamp(_grvh4h + _zpw0c7 * SUNSET_TERRAIN_TINT, 0.0, 1.0);
float _4knsqu = clamp(SKYLIGHT_TINT_LIGHT_SATURATION, 0.0, 1.0);

vec3 _8bjer1 = voxy_tod_skylight_tint(sunAngle);
vec3 _b75czz = voxy_normalize_light_color(skyColor);
float _zkhgkx = smoothstep(0.5, 0.9, _z92ecz);
vec3 _yzmt2s = voxy_static_night_tint();
vec3 _6dv2e1 = voxy_static_night_tint_lit();
float _wyhr9r = blocklight;
#ifdef LPV_ENABLED
_wyhr9r = 0.0;
#endif
float _nskg4g = _wyhr9r;
#if !defined(LPV_ENABLED) && !defined(END_SHADER) && !defined(NETHER_SHADER)

_nskg4g = 0.0;
#endif
float _z5wbzq = voxy_cave_tint_amount(skylight, _nskg4g);
vec3 _xbixhz = voxy_normalize_light_color(_8bjer1 * mix(vec3(1.0), _b75czz, _zkhgkx));
_xbixhz = voxy_normalize_light_color(mix(_xbixhz, _yzmt2s, _z5wbzq));
float _wimqh1 = voxy_luma(_xbixhz);
_xbixhz = mix(_xbixhz, mix(vec3(_wimqh1), _xbixhz, 0.32), _z5wbzq);
float _9b7299 = voxy_luma(_xbixhz);
_xbixhz = mix(_xbixhz, vec3(_9b7299), _ydmrin * 0.85);

float _40jp91 = 1.0 + _zpw0c7 * (SUNSET_TERRAIN_TINT * 1.09);
vec3 _fe6xmr = voxy_normalize_light_color(voxy_applySaturation(_xbixhz, SKYLIGHT_TINT_SATURATION * _40jp91));
float _b7pzhz = mix(1.0, SKYLIGHT_TINT_SATURATION * _40jp91, _4knsqu);
vec3 _jpx7iz = voxy_normalize_light_color(voxy_applySaturation(_xbixhz, _b7pzhz));
float _279ort = clamp(_kytein * 0.68, 0.0, 1.0);
vec3 _djla22 = voxy_normalize_light_color(mix(vec3(1.0), _fe6xmr, _279ort));
vec3 _c4ysuh = voxy_normalize_light_color(mix(vec3(1.0), _jpx7iz, _279ort));

float _3cvaso = smoothstep(1.0 / 15.0, 1.0, skylight);
#ifdef END_SHADER
vec3 _tiyzma = vec3(1.0);
#else
vec3 _tiyzma = mix(vec3(1.0), _fe6xmr, _kytein * _mv1tmz * _3cvaso);
#endif

vec3 _d6or1k = voxy_hueToRGB(SHADOW_HUE > 0.0 ? 180.0 + SHADOW_HUE : 360.0 + SHADOW_HUE);
float _tfmiv0 = voxy_luma(_d6or1k);
vec3 _2kfxw0 = _d6or1k / max(_tfmiv0, 0.3);
_2kfxw0 = min(_2kfxw0, vec3(2.0));

float _btnjfs = smoothstep(0.0, 0.20, _y22te0);
float _zuazff = smoothstep(0.10, 0.55, _mv1tmz);
float _f1j4zc = mix(LIGHTMAP_SATURATION * 0.10, LIGHTMAP_SATURATION, _btnjfs * _zuazff);
vec3 _p91vw9 = _2kfxw0;

float _6l75mg = 1.0 - smoothstep(0.0, 0.25, _y22te0);
float _cvlxie = clamp(_mv1tmz * _y22te0 * _hg321h, 0.0, 1.0);

float _xcnno9 = 0.15 * _mv1tmz * (1.0 - _6l75mg * 0.75);
_cvlxie += _mv1tmz * _hg321h * _6l75mg * 0.30;

vec3 _oumalh = _djla22 * _xcnno9;

vec3 _hj0fjq = _c4ysuh;
vec3 _xhaim9 = mix(_oumalh, _hj0fjq, _cvlxie);

float _zievek = float(SEA_LEVEL_OFFSET);
float _sj6nb7 = max(_zievek - _703fao, 0.0);
float _clzyel = 1.0 - smoothstep(0.0, 96.0, _sj6nb7);
float _zsb5co = mix(0.30, 0.18, _clzyel);
float _e9365q = 0.35;
float _kih2d7 = 1.0 - _mv1tmz;
float _e73heu = smoothstep(24.0, 96.0, _sj6nb7);
float _xd2aui = mix(_e9365q, _zsb5co, _e73heu);
float _a9a126 = voxy_cave_darken_amount(skylight, _wyhr9r);
float _3e82sa = voxy_has_skylight_mask(skylight);
float _kdhmp7 = mix(1.0, _kih2d7 + _q3g0w9 * 0.5 * _mv1tmz, _3e82sa);
float _ymqyke = mix(CAVE_AMBIENT_FLOOR, _xd2aui, 1.0 - _a9a126)
* _kdhmp7;
float _77lvd8 = voxy_night_darken_amount(_y22te0, skylight, _wyhr9r);
float _87lfbp = voxy_weather_darken_amount(_y22te0, skylight, _wyhr9r);
float _ttagom = voxy_pale_garden_darken_amount(_y22te0, skylight, _wyhr9r);
vec3 _43thas = _yssmf1 * _xhaim9 * mix(vec3(1.0), _6dv2e1, _z5wbzq)
* (1.0 - _77lvd8 * 0.45) * (1.0 - _a9a126 * 0.45);

_43thas *= 1.0 - _87lfbp * 0.45 * _cvlxie;
_43thas *= 1.0 - _ttagom * 0.40 * _cvlxie;
vec3 _vswfp0 = _yssmf1 * blockLight * _41uucb;
vec3 _8izj9y = _43thas + _vswfp0;
_ymqyke *= 1.0 - _77lvd8 * 0.35;
_ymqyke *= 1.0 - _a9a126 * 0.35;
float _t8kgw6 = voxy_zero_skylight_mask(skylight) * voxy_zero_blocklight_mask(_wyhr9r);
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
float _gxvn5k = smoothstep(0.04, 0.30, _2pv68z) * _41uucb;
vec3 _d8769y = voxy_normalize_light_color(max(blockLight, vec3(0.001)));
vec3 _zdpad0 = voxy_normalize_light_color(mix(_xbixhz, _xbixhz * _d8769y, 0.55));
_re9xq4 = _yssmf1 * _zdpad0 * (0.08 * _2pv68z) * _2h4zc3 * _gxvn5k;
#endif
vec3 _85ekms = _9tlejh + _re9xq4;
_8izj9y = max(_8izj9y, _85ekms);

#ifdef END_SHADER
_8izj9y *= mix(1.0, TERRAIN_BRIGHTNESS * VOXY_LOD_BRIGHTNESS, 0.3);
#else
_8izj9y *= TERRAIN_BRIGHTNESS * VOXY_LOD_BRIGHTNESS;
#endif

return _8izj9y;
}

vec3 voxy_apply_chunk_transition_lighting(
vec3 _yssmf1,
float sunAngle,
float skylight,
float blocklight,
float _703fao,
float _hg321h
) {
float _jvfij5 = voxy_shadow_transition_dip(sunAngle) * voxy_has_skylight_mask(skylight);
vec3 _8izj9y = voxy_apply_chunk_like_lighting(_yssmf1, sunAngle, skylight, blocklight, _703fao, _hg321h);
if (_jvfij5 > 0.001) {
vec3 _mk16zt = voxy_apply_chunk_like_lighting(_yssmf1, sunAngle, skylight, blocklight, _703fao, 1.0);
_8izj9y = mix(_8izj9y, _mk16zt, _jvfij5);
}
return _8izj9y * voxy_shadow_transition_darken(
_jvfij5,
voxy_time_of_day_lighting(sunAngle).x,
skylight
);
}

vec3 voxy_apply_chunk_like_lighting(vec3 _yssmf1, float sunAngle, float skylight, float blocklight, float _703fao) {
return voxy_apply_chunk_like_lighting(_yssmf1, sunAngle, skylight, blocklight, _703fao, 1.0);
}

#ifdef VOXY_TILE_BLUR_ENABLED

vec4 voxy_tile_blur(vec2 uv, float _swfcra) {
const vec2 _pt6pk1 = vec2(1.0 / (3.0 * 256.0), 1.0 / (2.0 * 256.0));
vec2 _02srkr = floor(uv / _pt6pk1) * _pt6pk1;
vec2 _mqktpk = _02srkr + _pt6pk1 * 0.5;
return textureLod(blockModelAtlas, _mqktpk, 0);
}

float voxy_tile_blur_strength(float _swfcra) {
return smoothstep(VOXY_TILE_BLUR_START, min(VOXY_TILE_BLUR_START + 0.1, 0.999), _swfcra);
}
#endif

#endif
