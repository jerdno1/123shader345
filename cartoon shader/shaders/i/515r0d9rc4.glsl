#ifdef COLOR_GRADING_ENABLED

vec3 _9cnz8p(vec3 c) {
vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
float d = q.x - min(q.w, q.y);
float e = 1.0e-10;
return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 _21cs2o(vec3 c) {
vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float _1w1myc(vec3 c) { return dot(c, vec3(0.299, 0.587, 0.114)); }
float _he1b6k(vec3 c) { return max(max(c.r, c.g), c.b); }

float _bh3y78(vec3 c) {
float _zdxp7g = _1w1myc(c);
float _ino0s9 = _he1b6k(c);
return max(_zdxp7g, _ino0s9 * 0.70);
}

vec3 _h9ckwl(vec3 _yssmf1, float _f6zemr) {
float _zdxp7g = _1w1myc(_yssmf1);
vec3 _32lral = vec3(1.0, 0.85, 0.65);
vec3 _bux25m = vec3(0.65, 0.85, 1.0);
vec3 _epi87u = mix(_bux25m, _32lral, _f6zemr * 0.5 + 0.5);
return clamp(mix(_yssmf1, _yssmf1 * _epi87u, abs(_f6zemr) * 0.4 * smoothstep(0.0, 0.1, _zdxp7g)), 0.0, 1.0);
}

vec3 _mzcj8s(vec3 _yssmf1, float tint) {
float _zdxp7g = _1w1myc(_yssmf1);
vec3 _0dveoj = vec3(1.0, 0.85, 1.0);
vec3 _5x3ise   = vec3(0.85, 1.0, 0.85);
vec3 _epi87u = mix(_5x3ise, _0dveoj, tint * 0.5 + 0.5);
return clamp(mix(_yssmf1, _yssmf1 * _epi87u, abs(tint) * 0.4 * smoothstep(0.0, 0.1, _zdxp7g)), 0.0, 1.0);
}

vec3 _i1uf2w(vec3 _yssmf1, float ev) {
vec3 _ggo5j0 = pow(_yssmf1, vec3(2.2));
_ggo5j0 *= pow(2.0, ev);
return clamp(pow(clamp(_ggo5j0, 0.0, 4.0), vec3(1.0/2.2)), 0.0, 1.0);
}

vec3 _nkdo3r(vec3 _yssmf1, float b) {
return clamp(_yssmf1 * (1.0 + b * 0.5), 0.0, 1.0);
}

vec3 _v53kkt(vec3 _yssmf1, float c) {
return clamp((_yssmf1 - 0.5) * (1.0 + c) + 0.5, 0.0, 1.0);
}

vec3 _hocvm1(vec3 _yssmf1, float _6kdurg) {
float _2r2lm5 = _bh3y78(_yssmf1);
float _q4j75g = 1.0 - smoothstep(0.0, 0.35, _2r2lm5);
return max(_yssmf1 + _6kdurg * 0.10 * _q4j75g, vec3(0.0));
}

vec3 _keojdv(vec3 _yssmf1, float _tb7ydm) {
float _2r2lm5 = _bh3y78(_yssmf1);
float _q4j75g = smoothstep(0.65, 1.0, _2r2lm5);
return clamp(_yssmf1 + _tb7ydm * 0.10 * _q4j75g, 0.0, 1.0);
}

vec3 _a6fo40(vec3 _yssmf1, float _2tg9v1, float _evjnqk) {
float _2r2lm5 = _bh3y78(_yssmf1);
float _ksor44 = 1.0 - smoothstep(0.0, 0.5, _2r2lm5);
float _7t89bk = smoothstep(0.5, 1.0, _2r2lm5);
return clamp(_yssmf1 + vec3(_2tg9v1 * 0.20 * _ksor44 + _evjnqk * 0.20 * _7t89bk), 0.0, 1.0);
}

vec3 _avepl7(vec3 _yssmf1, vec3 _wx4pj6, vec3 _h03c27, float _0v7t0i, float _pi2d9l) {
float _2r2lm5 = _bh3y78(_yssmf1);

float _5khogv = 0.5 + _pi2d9l * 0.3;

float _llhzau = 1.0 - smoothstep(0.0, _5khogv, _2r2lm5);

float _gw5wh3 = smoothstep(_5khogv, 1.0, _2r2lm5);

vec3 tint = mix(_wx4pj6 * _llhzau, _h03c27 * _gw5wh3, 0.5);

return clamp(mix(_yssmf1, _yssmf1 + (tint - 0.5) * _yssmf1, _0v7t0i), 0.0, 1.0);
}

vec3 _hfrfwv(vec3 _yssmf1, vec3 _iyxdao, vec3 _j83xr3, vec3 _wpt99m) {
vec3 _8izj9y = _yssmf1;

_8izj9y *= _wpt99m;

vec3 _8zpzip = (_iyxdao - 1.0) * (1.0 - _8izj9y);
_8izj9y += _8zpzip * 0.5;

_8izj9y = pow(max(_8izj9y, vec3(0.001)), 1.0 / _j83xr3);

return clamp(_8izj9y, 0.0, 1.0);
}

vec3 _ljclf3(vec3 _yssmf1, vec2 uv, float _0v7t0i, float _nr5rfo, float _m4fzbe, float _2qfni5) {
vec2 _o8zme9 = uv - 0.5;
_o8zme9.x *= _2qfni5;

float _t25r5m = length(_o8zme9) * 2.0;
float _r4dpq4 = 1.0 - smoothstep(_nr5rfo - max(_m4fzbe, 0.0001), _nr5rfo, _t25r5m);

return mix(_yssmf1 * (1.0 - _0v7t0i), _yssmf1, _r4dpq4);
}

vec3 _gz32rq(vec3 _yssmf1, vec2 uv, float _0v7t0i, float _xoryyp, bool _b9rkrr, float _bim3ym, int _tybbyx) {

vec2 _kia2vw = uv * _xoryyp * 200.0;
float t = _bim3ym * 10.0 + float(_tybbyx);

float _bfcizj = fract(sin(dot(_kia2vw + t, vec2(12.9898, 78.233))) * 43758.5453);
_bfcizj += fract(sin(dot(_kia2vw.yx - t * 0.7, vec2(93.9898, 67.345))) * 28462.1253);
_bfcizj = _bfcizj * 0.5 - 0.5;

if (_b9rkrr) {
_yssmf1 += vec3(_bfcizj * _0v7t0i);
} else {
vec3 _4caq2k;
_4caq2k.r = _bfcizj;
_4caq2k.g = fract(sin(dot(_kia2vw + t * 1.1, vec2(45.233, 97.113))) * 32145.6789) - 0.5;
_4caq2k.b = fract(sin(dot(_kia2vw - t * 0.9, vec2(78.345, 23.897))) * 54321.9876) - 0.5;
_yssmf1 += _4caq2k * _0v7t0i;
}

return clamp(_yssmf1, 0.0, 1.0);
}

vec3 _g25yfy(vec3 _yssmf1, float _6vltqs) {
vec3 _s0lzby = _9cnz8p(_yssmf1);
_s0lzby.x = fract(_s0lzby.x + _6vltqs / 360.0);
return _21cs2o(_s0lzby);
}

vec3 _65tb42(vec3 _yssmf1, float _1sf1fx) {
float _6qwad8 = max(max(_yssmf1.r, _yssmf1.g), _yssmf1.b);
float _aslobc = min(min(_yssmf1.r, _yssmf1.g), _yssmf1.b);
float _vfrzpg = _6qwad8 > 0.001 ? (_6qwad8 - _aslobc) / _6qwad8 : 0.0;
float _y1nwee = pow(1.0 - _vfrzpg, 1.5);
float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _tivi05 = mix(vec3(_zdxp7g), _yssmf1, max(1.0 + _1sf1fx * _y1nwee, 0.0));

return clamp(_tivi05, 0.0, 1.0);
}

vec3 _p77sxe(vec3 _yssmf1, int _flfaze, float _0v7t0i) {
if (_flfaze == 0) return _yssmf1;

vec3 _nzi1si = _yssmf1;

if (_flfaze == 1) {

float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _wx4pj6 = vec3(0.08, 0.1, 0.18);
vec3 _h03c27 = vec3(0.22, 0.18, 0.12);
_nzi1si = _avepl7(_yssmf1, _wx4pj6, _h03c27, 0.35, 0.1);
_nzi1si = _65tb42(_nzi1si, -0.15);
_nzi1si = _hfrfwv(_nzi1si, vec3(0.98, 0.98, 1.02), vec3(1.0), vec3(1.05, 1.02, 0.98));
}
else if (_flfaze == 2) {

_nzi1si = _h9ckwl(_yssmf1, 0.4);
_nzi1si = _65tb42(_nzi1si, -0.3);
_nzi1si = _hfrfwv(_nzi1si, vec3(1.05, 1.02, 0.95), vec3(0.95), vec3(0.95, 0.93, 0.88));

float _zdxp7g = dot(_nzi1si, vec3(0.299, 0.587, 0.114));
vec3 _tvrinb = vec3(_zdxp7g * 1.1, _zdxp7g * 0.95, _zdxp7g * 0.75);
_nzi1si = mix(_nzi1si, _tvrinb, 0.2);
}
else if (_flfaze == 3) {

vec3 _wx4pj6 = vec3(0.0, 0.25, 0.35);
vec3 _h03c27 = vec3(0.35, 0.2, 0.05);
_nzi1si = _avepl7(_yssmf1, _wx4pj6, _h03c27, 0.5, 0.0);
_nzi1si = _65tb42(_nzi1si, 0.4);
_nzi1si = (_nzi1si - 0.5) * 1.15 + 0.5;
_nzi1si = _hfrfwv(_nzi1si, vec3(0.95, 1.0, 1.08), vec3(1.0), vec3(1.08, 1.0, 0.92));
}
else if (_flfaze == 4) {

_nzi1si = _65tb42(_yssmf1, -0.5);
_nzi1si = _mzcj8s(_nzi1si, -0.3);
_nzi1si = _hfrfwv(_nzi1si, vec3(0.9, 0.95, 0.9), vec3(1.1), vec3(0.9, 0.92, 0.88));

_nzi1si = max(_nzi1si - 0.05, vec3(0.0));
}
else if (_flfaze == 5) {

vec3 _wx4pj6 = vec3(0.18, 0.08, 0.28);
vec3 _h03c27 = vec3(0.28, 0.22, 0.1);
_nzi1si = _avepl7(_yssmf1, _wx4pj6, _h03c27, 0.4, 0.15);
_nzi1si = _65tb42(_nzi1si, 0.35);
_nzi1si = _hfrfwv(_nzi1si, vec3(1.0, 0.95, 1.1), vec3(0.95), vec3(1.1, 1.05, 0.95));
}
else if (_flfaze == 6) {

_nzi1si = _h9ckwl(_yssmf1, -0.35);
_nzi1si = _65tb42(_nzi1si, -0.25);
vec3 _wx4pj6 = vec3(0.1, 0.12, 0.22);
vec3 _h03c27 = vec3(0.18, 0.18, 0.2);
_nzi1si = _avepl7(_nzi1si, _wx4pj6, _h03c27, 0.3, -0.2);
_nzi1si = _hfrfwv(_nzi1si, vec3(0.95, 0.97, 1.05), vec3(1.05), vec3(0.98, 1.0, 1.05));
}
else if (_flfaze == 7) {

_nzi1si = _h9ckwl(_yssmf1, 0.2);
_nzi1si = _65tb42(_nzi1si, 0.4);

_nzi1si.g = pow(_nzi1si.g, 0.9);
_nzi1si.b = pow(_nzi1si.b, 0.95);
_nzi1si = _hfrfwv(_nzi1si, vec3(1.0, 1.03, 1.02), vec3(0.95), vec3(1.02, 1.05, 1.08));
}
else if (_flfaze == 8) {

_nzi1si = _65tb42(_yssmf1, -0.7);
_nzi1si = _h9ckwl(_nzi1si, -0.15);
_nzi1si = (_nzi1si - 0.5) * 1.25 + 0.5;
_nzi1si = _hfrfwv(_nzi1si, vec3(0.9, 0.9, 0.95), vec3(1.1), vec3(1.1, 1.08, 1.05));
}

return mix(_yssmf1, clamp(_nzi1si, 0.0, 1.0), _0v7t0i);
}

vec3 _8ppq8e(vec3 _yssmf1, vec2 uv, float _bim3ym, int _tybbyx) {
vec3 _8izj9y = clamp(_yssmf1, 0.0, 1.0);

#if CG_STYLE_PRESET > 0
_8izj9y = _p77sxe(_8izj9y, CG_STYLE_PRESET, CG_STYLE_INTENSITY);
#endif

#if CG_TEMPERATURE != 0.0
_8izj9y = _h9ckwl(_8izj9y, CG_TEMPERATURE);
#endif

#if CG_TINT != 0.0
_8izj9y = _mzcj8s(_8izj9y, CG_TINT);
#endif

#if CG_EXPOSURE != 0.0
_8izj9y = _i1uf2w(_8izj9y, CG_EXPOSURE);
#endif

#if CG_BRIGHTNESS != 0.0
_8izj9y = _nkdo3r(_8izj9y, CG_BRIGHTNESS);
#endif

#if CG_CONTRAST != 0.0
_8izj9y = _v53kkt(_8izj9y, CG_CONTRAST);
#endif

#if CG_BLACKS != 0.0
_8izj9y = _hocvm1(_8izj9y, CG_BLACKS);
#endif

#if CG_WHITES != 0.0
_8izj9y = _keojdv(_8izj9y, CG_WHITES);
#endif

#if CG_SHADOWS != 0.0 || CG_HIGHLIGHTS != 0.0
_8izj9y = _a6fo40(_8izj9y, CG_SHADOWS, CG_HIGHLIGHTS);
#endif

#if CG_HUE_SHIFT != 0.0
_8izj9y = _g25yfy(_8izj9y, CG_HUE_SHIFT);
#endif

#if CG_SATURATION != 0.0
{
float _zdxp7g = dot(_8izj9y, vec3(0.299, 0.587, 0.114));
_8izj9y = mix(vec3(_zdxp7g), _8izj9y, max(1.0 + CG_SATURATION, 0.0));
}
#endif

#if CG_VIBRANCE != 0.0
_8izj9y = _65tb42(_8izj9y, CG_VIBRANCE);
#endif

#ifdef CG_SPLIT_TONING_ENABLED
{
vec3 _wx4pj6 = vec3(CG_SHADOW_TINT_R, CG_SHADOW_TINT_G, CG_SHADOW_TINT_B);
vec3 _h03c27 = vec3(CG_HIGHLIGHT_TINT_R, CG_HIGHLIGHT_TINT_G, CG_HIGHLIGHT_TINT_B);
_8izj9y = _avepl7(_8izj9y, _wx4pj6, _h03c27, CG_SPLIT_TONING_INTENSITY, CG_SPLIT_TONING_BALANCE);
}
#endif

{
vec3 _iyxdao = vec3(CG_LIFT_R, CG_LIFT_G, CG_LIFT_B);
vec3 _j83xr3 = vec3(CG_GAMMA_R, CG_GAMMA_G, CG_GAMMA_B);
vec3 _wpt99m = vec3(CG_GAIN_R, CG_GAIN_G, CG_GAIN_B);

if (_iyxdao != vec3(1.0) || _j83xr3 != vec3(1.0) || _wpt99m != vec3(1.0)) {
_8izj9y = _hfrfwv(_8izj9y, _iyxdao, _j83xr3, _wpt99m);
}
}

#ifdef CG_VIGNETTE_ENABLED
_8izj9y = _ljclf3(_8izj9y, uv, CG_VIGNETTE_INTENSITY, CG_VIGNETTE_RADIUS, CG_VIGNETTE_SOFTNESS, CG_VIGNETTE_ROUNDNESS);
#endif

#ifdef CG_FILM_GRAIN_ENABLED
#ifdef CG_FILM_GRAIN_LUMINANCE
_8izj9y = _gz32rq(_8izj9y, uv, CG_FILM_GRAIN_INTENSITY, CG_FILM_GRAIN_SIZE, true, _bim3ym, _tybbyx);
#else
_8izj9y = _gz32rq(_8izj9y, uv, CG_FILM_GRAIN_INTENSITY, CG_FILM_GRAIN_SIZE, false, _bim3ym, _tybbyx);
#endif
#endif

return _8izj9y;
}
#endif
