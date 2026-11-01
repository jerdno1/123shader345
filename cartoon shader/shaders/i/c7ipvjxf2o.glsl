#ifndef VANILLA_CLOUDS_GLSL
#define VANILLA_CLOUDS_GLSL

uniform sampler2D cloudTex;

vec2 _2bypus(vec2 _gpy6je, float _2qfni5) {
vec2 _5zlm8i = _gpy6je + 0.5;
vec2 _6f6j39 = sign(_5zlm8i);
_5zlm8i = abs(_5zlm8i) + 1.0;
vec2 i, f = modf(_5zlm8i, i);
f = smoothstep(0.5 - _2qfni5, 0.5 + _2qfni5, f);
_5zlm8i = i + f;
return (_5zlm8i - 0.5) * _6f6j39 / 256.0;
}

vec2 _zynhvg(float _bim3ym) {
return vec2(1.0, 0.0) * float(VANILLA_CLOUD_SPEED) * _bim3ym;
}

vec2 _yxa6g0(vec2 _586wrp, float _45957t) {
vec2 _ak9min = vec2(
_586wrp.x > 0.0 ? 1.0 : (_586wrp.x < 0.0 ? -1.0 : 0.0),
_586wrp.y > 0.0 ? 1.0 : (_586wrp.y < 0.0 ? -1.0 : 0.0)
);

vec2 _w4dkbo = mix(vec2(-1.0), _ak9min, step(vec2(0.5), abs(_ak9min)));
return _w4dkbo * (_45957t * 0.0005);
}

float _b4g3zp(vec2 _ev094z, float _bim3ym, float _hdc9nq, float _05ol9y, int _m8h8hu) {
vec2 _coo86k = _ev094z + _zynhvg(_bim3ym);

vec2 _jq5av8 = _coo86k;
if (_m8h8hu == 2) {
_jq5av8 = vec2(_coo86k.y, -_coo86k.x);
} else if (_m8h8hu == 3) {
_jq5av8 = vec2(-_coo86k.x, -_coo86k.y);
}

vec2 _uckngx = _jq5av8 * _05ol9y;
vec2 uv = _2bypus(_uckngx, 0.125);

vec2 _w6wnn8 = fract(uv);
vec4 _xibcy1 = textureLod(cloudTex, _w6wnn8, 0.0);

float _gioshs = _xibcy1.b * 0.72 + _xibcy1.r * 0.28;

float _i39c9j = mix(0.78, 0.16, clamp(_hdc9nq, 0.0, 1.0));
return smoothstep(_i39c9j - 0.08, _i39c9j + 0.08, _gioshs);
}

void _c9xcnj(float sunAngle, out float _gkgbii, out float _fqsewx, out float _pzmwi9) {
float _jn7ap1 = fract(sunAngle);
_gkgbii = smoothstep(0.04, 0.10, _jn7ap1) * (1.0 - smoothstep(0.46, 0.50, _jn7ap1));
_fqsewx = smoothstep(0.46, 0.49, _jn7ap1) * (1.0 - smoothstep(0.51, 0.54, _jn7ap1))
+ smoothstep(0.97, 1.0, _jn7ap1) + (1.0 - smoothstep(0.0, 0.05, _jn7ap1));
_pzmwi9 = smoothstep(0.52, 0.58, _jn7ap1) * (1.0 - smoothstep(0.94, 0.98, _jn7ap1));
float _8uao3q = max(_gkgbii + _fqsewx + _pzmwi9, 0.001);
_gkgbii /= _8uao3q; _fqsewx /= _8uao3q; _pzmwi9 /= _8uao3q;
}

vec3 _nszg9n(float _gkgbii, float _fqsewx, float _pzmwi9, float _au5b3f, float _1vca6n) {

vec3 _pt6jgk = vec3(float(VANILLA_CLOUD_R), float(VANILLA_CLOUD_G), float(VANILLA_CLOUD_B)) * float(VANILLA_CLOUD_BRIGHTNESS) * _1vca6n;

vec3 _y1erap    = _pt6jgk;
vec3 _txrszf = _pt6jgk * vec3(0.60, 0.65, 0.90);
float _fgx2j8 = _g4a6za(biome_savanna, biome_swamp);
if (_fgx2j8 > 0.001) {
vec3 _kkyze5 = _pt6jgk * mix(vec3(1.0), _e6gplv(), 0.35);
vec3 _z2n8gv = _pt6jgk * mix(_b8134m(), _e6gplv(), 0.35) * 0.70;
_y1erap = mix(_y1erap, _kkyze5, _fgx2j8);
_txrszf = mix(_txrszf, _z2n8gv, _fgx2j8);
}
float _6kr23z = clamp(biome_pale_garden, 0.0, 1.0);
if (_6kr23z > 0.001) {

vec3 _67y3oh = _pt6jgk * mix(vec3(1.0), _f9f345(), 0.55);
vec3 _hr49ek = _pt6jgk * _1iquw2() * 0.65;
_y1erap = mix(_y1erap, _67y3oh, _6kr23z);
_txrszf = mix(_txrszf, _hr49ek, _6kr23z);
}

vec3 _n08byh    = _pt6jgk * vec3(1.0, 0.85, 0.65);
vec3 _lxgabc = _pt6jgk * vec3(0.80, 0.60, 0.70);

vec3 _ilbafi    = _pt6jgk * vec3(0.50, 0.60, 0.90);
vec3 _mdepsv = _pt6jgk * vec3(0.20, 0.25, 0.45);

vec3 _hj0fjq   = _y1erap * _gkgbii + _n08byh * _fqsewx + _ilbafi * _pzmwi9;
vec3 _eu5mwn = _txrszf * _gkgbii + _lxgabc * _fqsewx + _mdepsv * _pzmwi9;

return mix(_eu5mwn, _hj0fjq, _au5b3f);
}

float _m41c19(float sunAngle) {
float _jn7ap1 = fract(sunAngle);

float _a6ueaz = smoothstep(0.46, 0.505, _jn7ap1);
float _8un5qh = 1.0 - smoothstep(0.00, 0.10, _jn7ap1);
return clamp(max(_a6ueaz, _8un5qh), 0.0, 1.0);
}

bool _rdvmsn(vec3 _zr9u0r, vec3 _llxraj, float _c2qau5, float _31dz6b, out float _pxvs4x, out float _l16jxm) {
if (abs(_llxraj.y) < 0.0005) {
if (_zr9u0r.y >= _c2qau5 && _zr9u0r.y <= _31dz6b) {
_pxvs4x = 0.0; _l16jxm = 1e6;
return true;
}
return false;
}
float t0 = (_c2qau5 - _zr9u0r.y) / _llxraj.y;
float t1 = (_31dz6b    - _zr9u0r.y) / _llxraj.y;
_pxvs4x = min(t0, t1);
_l16jxm  = max(t0, t1);
if (_l16jxm < 0.0) return false;
_pxvs4x = max(_pxvs4x, 0.0);
return _pxvs4x < _l16jxm;
}

bool _5a3o04(vec3 _zr9u0r, vec3 _llxraj, vec3 _1t8pkr, vec3 _ob0muh, out float _h0w45i, out vec3 _n9xslo) {
vec3 _phxka5 = vec3(
abs(_llxraj.x) > 0.00001 ? _llxraj.x : (_llxraj.x >= 0.0 ? 0.00001 : -0.00001),
abs(_llxraj.y) > 0.00001 ? _llxraj.y : (_llxraj.y >= 0.0 ? 0.00001 : -0.00001),
abs(_llxraj.z) > 0.00001 ? _llxraj.z : (_llxraj.z >= 0.0 ? 0.00001 : -0.00001)
);

vec3 _1x0yd7 = 1.0 / _phxka5;
vec3 t0 = (_1t8pkr - _zr9u0r) * _1x0yd7;
vec3 t1 = (_ob0muh - _zr9u0r) * _1x0yd7;
vec3 _skd0fj = min(t0, t1);
vec3 _6fsszx = max(t0, t1);

float _pxvs4x = max(max(_skd0fj.x, _skd0fj.y), _skd0fj.z);
float _l16jxm = min(min(_6fsszx.x, _6fsszx.y), _6fsszx.z);
if (_l16jxm < max(_pxvs4x, 0.0)) return false;

_h0w45i = max(_pxvs4x, 0.0);

float _fb17fe = 0.0005;
if (abs(_pxvs4x - _skd0fj.y) <= _fb17fe) {
_n9xslo = vec3(0.0, _llxraj.y > 0.0 ? -1.0 : 1.0, 0.0);
} else if (abs(_pxvs4x - _skd0fj.x) <= _fb17fe) {
_n9xslo = vec3(_llxraj.x > 0.0 ? -1.0 : 1.0, 0.0, 0.0);
} else {
_n9xslo = vec3(0.0, 0.0, _llxraj.z > 0.0 ? -1.0 : 1.0);
}

return true;
}

vec4 _bp4988(
vec3 _zflroq, vec3 _llxraj, float _pxvs4x, float _l16jxm, float _rxyf26, float _qf053q,
float _hdc9nq, float _45957t, float _05ol9y, float _bim3ym,
float _qeto6t, float _cunixp, float _gkgbii, float _fqsewx, float _pzmwi9,
float _1vca6n, int _m8h8hu, out float _p61yv8
) {
_p61yv8 = 1e6;

int _u01hql = int(_qeto6t / (_45957t * 0.7071)) + 2;

int _jvilw7 = min(_u01hql, 1536);

float _5ermgq = float(_jvilw7) * _45957t * 0.7071;
float _kwngg1 = min(_qeto6t, _5ermgq);

if (_pxvs4x >= _l16jxm || _pxvs4x >= _cunixp || _pxvs4x >= _kwngg1) return vec4(0.0);

vec2 _2fpj1q = _zynhvg(_bim3ym);
vec3 _ud1752 = _zflroq + _llxraj * _pxvs4x;
vec2 _d79m77 = _ud1752.xz + _2fpj1q;
vec2 _586wrp = _llxraj.xz;
vec2 _rvhmgi = _d79m77 + _yxa6g0(_586wrp, _45957t);

vec2 _3fo41q = floor(_rvhmgi / _45957t);

if (length(_586wrp) < 0.0005) {
vec2 _lqx4mh = (_3fo41q + 0.5) * _45957t - _2fpj1q;
float _l28y2g = _b4g3zp(_lqx4mh, _bim3ym, _hdc9nq, _05ol9y, _m8h8hu);
if (_l28y2g > 0.5) {
vec3 _k415e3 = vec3(_3fo41q.x * _45957t - _2fpj1q.x, _rxyf26, _3fo41q.y * _45957t - _2fpj1q.y);
vec3 _v1nx14 = _k415e3 + vec3(_45957t, _qf053q - _rxyf26, _45957t);
float _kqbh9n;
vec3 _n9xslo;
if (_5a3o04(_zflroq, _llxraj, _k415e3, _v1nx14, _kqbh9n, _n9xslo)) {
float _lzgagx = length((_zflroq + _llxraj * _kqbh9n).xz - _zflroq.xz);
float _36zwff = 1.0 - smoothstep(_kwngg1 * 0.6, _kwngg1, _lzgagx);
if (_36zwff > 0.001) {
float _au5b3f;
bool _3g3tna = false;
bool _0mjp3o = false;
if (_n9xslo.y < -0.5) {
_au5b3f = 0.0;
_3g3tna = true;
} else if (_n9xslo.y > 0.5) {
_au5b3f = 1.0;
} else {
float _swap1x = clamp(((_zflroq + _llxraj * _kqbh9n).y - _rxyf26) / (_qf053q - _rxyf26), 0.0, 1.0);
_au5b3f = mix(0.1, 0.95, _swap1x);
_0mjp3o = true;
}

vec3 _59bql9 = _nszg9n(_gkgbii, _fqsewx, _pzmwi9, _au5b3f, _1vca6n);
if (_3g3tna) {
_59bql9 *= mix(1.0, 0.35, clamp(float(VANILLA_CLOUD_BOTTOM_DARKNESS) / 100.0, 0.0, 1.0));
} else if (_0mjp3o) {
_59bql9 *= mix(1.0, 0.50, clamp(float(VANILLA_CLOUD_SIDE_DARKNESS) / 100.0, 0.0, 1.0));
}

_p61yv8 = _kqbh9n;
return vec4(_59bql9, _36zwff * _l28y2g);
}
}
}
return vec4(0.0);
}

vec2 _846krs = vec2(
_586wrp.x > 0.0 ? 1.0 : (_586wrp.x < 0.0 ? -1.0 : 0.0),
_586wrp.y > 0.0 ? 1.0 : (_586wrp.y < 0.0 ? -1.0 : 0.0)
);

vec2 _1x0yd7 = vec2(1e20);
vec2 _1ogm9a = vec2(1e20);
vec2 _x77yp8 = vec2(1e20);

if (abs(_586wrp.x) > 0.0001) {
_1x0yd7.x = 1.0 / _586wrp.x;
_x77yp8.x = abs(_45957t * _1x0yd7.x);
float _03z516 = (_3fo41q.x + (_846krs.x > 0.0 ? 1.0 : 0.0)) * _45957t;
_1ogm9a.x = (_03z516 - _rvhmgi.x) * _1x0yd7.x;
}
if (abs(_586wrp.y) > 0.0001) {
_1x0yd7.y = 1.0 / _586wrp.y;
_x77yp8.y = abs(_45957t * _1x0yd7.y);
float _b1f0yl = (_3fo41q.y + (_846krs.y > 0.0 ? 1.0 : 0.0)) * _45957t;
_1ogm9a.y = (_b1f0yl - _rvhmgi.y) * _1x0yd7.y;
}

float _tmdvvt = min(_l16jxm, min(_cunixp, _kwngg1));

for (int i = 0; i < _jvilw7; i++) {
vec2 _lqx4mh = (_3fo41q + 0.5) * _45957t - _2fpj1q;

float _l28y2g = _b4g3zp(_lqx4mh, _bim3ym, _hdc9nq, _05ol9y, _m8h8hu);
if (_l28y2g > 0.5) {
vec3 _k415e3 = vec3(_3fo41q.x * _45957t - _2fpj1q.x, _rxyf26, _3fo41q.y * _45957t - _2fpj1q.y);
vec3 _v1nx14 = _k415e3 + vec3(_45957t, _qf053q - _rxyf26, _45957t);
float _kqbh9n;
vec3 _n9xslo;

if (_5a3o04(_zflroq, _llxraj, _k415e3, _v1nx14, _kqbh9n, _n9xslo)) {
if (_kqbh9n > _tmdvvt) break;

vec3 _r0gipz = _zflroq + _llxraj * _kqbh9n;
float _lzgagx = length(_r0gipz.xz - _zflroq.xz);
float _36zwff = 1.0 - smoothstep(_kwngg1 * 0.6, _kwngg1, _lzgagx);
if (_36zwff < 0.001) break;

_p61yv8 = _kqbh9n;

float _au5b3f;
bool _3g3tna = false;
bool _0mjp3o = false;
if (_n9xslo.y < -0.5) {
_au5b3f = 0.0;
_3g3tna = true;
} else if (_n9xslo.y > 0.5) {
_au5b3f = 1.0;
} else {
float _swap1x = clamp((_r0gipz.y - _rxyf26) / (_qf053q - _rxyf26), 0.0, 1.0);
_au5b3f = mix(0.1, 0.95, _swap1x);
_0mjp3o = true;
}

vec3 _59bql9 = _nszg9n(_gkgbii, _fqsewx, _pzmwi9, _au5b3f, _1vca6n);
if (_3g3tna) {
_59bql9 *= mix(1.0, 0.35, clamp(float(VANILLA_CLOUD_BOTTOM_DARKNESS) / 100.0, 0.0, 1.0));
} else if (_0mjp3o) {
_59bql9 *= mix(1.0, 0.50, clamp(float(VANILLA_CLOUD_SIDE_DARKNESS) / 100.0, 0.0, 1.0));
}
return vec4(_59bql9, _36zwff * _l28y2g);
}
}

float _mnrul8 = min(_1ogm9a.x, _1ogm9a.y);
if (abs(_1ogm9a.x - _1ogm9a.y) <= 0.0005) {
_3fo41q += _846krs;
if (_pxvs4x + _mnrul8 > _tmdvvt) break;
_1ogm9a += _x77yp8;
} else if (_1ogm9a.x < _1ogm9a.y) {
_3fo41q.x += _846krs.x;
if (_pxvs4x + _1ogm9a.x > _tmdvvt) break;
_1ogm9a.x += _x77yp8.x;
} else {
_3fo41q.y += _846krs.y;
if (_pxvs4x + _1ogm9a.y > _tmdvvt) break;
_1ogm9a.y += _x77yp8.y;
}
}

return vec4(0.0);
}

vec4 _l5e5we(vec3 _st4awd, float _bim3ym, vec3 _zflroq, float sunAngle, vec3 _wwcrp0, float _cunixp, vec2 _rrv196, int _ol1mo0, out float _r6rnp2, float _bpi90y) {
_r6rnp2 = 0.0;
vec3 _llxraj = normalize(_st4awd);
float _qeto6t = float(VANILLA_CLOUD_DISTANCE);

float _gkgbii, _fqsewx, _pzmwi9;
_c9xcnj(sunAngle, _gkgbii, _fqsewx, _pzmwi9);

float _rb3fbm = _m41c19(sunAngle);

float _fjbafb = smoothstep(0.60, 0.95, _rb3fbm);
float _nmdyyy = _gkgbii;
float _v5qde3 = _fqsewx + _pzmwi9 * (1.0 - _fjbafb);
float _5ziit7 = _pzmwi9 * _fjbafb;
float _bgaj71 = max(_nmdyyy + _v5qde3 + _5ziit7, 0.001);
_nmdyyy /= _bgaj71;
_v5qde3 /= _bgaj71;
_5ziit7 /= _bgaj71;
float _1ut2lt = 1.0 - _rb3fbm * (float(VANILLA_CLOUD_NIGHT_OPACITY_REDUCTION) / 100.0);
_1ut2lt = clamp(_1ut2lt, 0.0, 1.0);

float _2ih62h = float(VANILLA_CLOUD_HEIGHT) + float(SEA_LEVEL_OFFSET);
float _hc0782 = float(VANILLA_CLOUD_THICKNESS);
float _cx42xx = float(VANILLA_CLOUD_LAYER_SPACING);

float _458qpu = _2ih62h;
float _7hebyf    = _458qpu + _hc0782;

float _t9do8h = _7hebyf + _cx42xx;
float _jskgla    = _t9do8h + _hc0782;

float _csfs10 = _jskgla + _cx42xx;
float _9heo4m    = _csfs10 + _hc0782;

float _05ol9y = 0.07;

vec4 _ufrexv = vec4(0.0);
float _ux1osi = 1e6;
vec4 _8izj9y;
float _clh1ts;

vec4 _ttnnsk = vec4(0.0); float _471pyw = 1e6;
if (float(VANILLA_CLOUD_L1_OPACITY) > 0.0) {
float _vu5b68, l1TF; float _clh1ts;
if (_rdvmsn(_zflroq, _llxraj, _458qpu, _7hebyf, _vu5b68, l1TF)) {
vec4 _f6zemr = _bp4988(
_zflroq, _llxraj, _vu5b68, l1TF, _458qpu, _7hebyf,
float(VANILLA_CLOUD_L1_COVERAGE), float(VANILLA_CLOUD_L1_PIXEL_SIZE), _05ol9y, _bim3ym,
_qeto6t, _cunixp, _nmdyyy, _v5qde3, _5ziit7, 0.60, 1, _clh1ts
);
if (_f6zemr.a > 0.0) {
_471pyw = _clh1ts;
_ttnnsk = _f6zemr * vec4(1.0, 1.0, 1.0, (float(VANILLA_CLOUD_L1_OPACITY) / 100.0) * _1ut2lt * _bpi90y);

_ttnnsk.rgb *= _ttnnsk.a;
}
}
}

vec4 _xqbaks = vec4(0.0); float _zsxtd8 = 1e6;
if (float(VANILLA_CLOUD_L2_OPACITY) > 0.0) {
float _2njimm, l2TF; float _clh1ts;
if (_rdvmsn(_zflroq, _llxraj, _t9do8h, _jskgla, _2njimm, l2TF)) {

vec4 _f6zemr = _bp4988(
_zflroq, _llxraj, _2njimm, l2TF, _t9do8h, _jskgla,
float(VANILLA_CLOUD_L2_COVERAGE), float(VANILLA_CLOUD_L2_PIXEL_SIZE), _05ol9y, _bim3ym,
_qeto6t, _cunixp, _nmdyyy, _v5qde3, _5ziit7, 0.85, 2, _clh1ts
);
if (_f6zemr.a > 0.0) {
_zsxtd8 = _clh1ts;
_xqbaks = _f6zemr * vec4(1.0, 1.0, 1.0, (float(VANILLA_CLOUD_L2_OPACITY) / 100.0) * _1ut2lt * _bpi90y);

_xqbaks.rgb *= _xqbaks.a;
}
}
}

vec4 _m58tk0 = vec4(0.0); float _iu1hx0 = 1e6;
if (float(VANILLA_CLOUD_L3_OPACITY) > 0.0) {
float _xtev26, l3TF; float _clh1ts;
if (_rdvmsn(_zflroq, _llxraj, _csfs10, _9heo4m, _xtev26, l3TF)) {

vec4 _f6zemr = _bp4988(
_zflroq, _llxraj, _xtev26, l3TF, _csfs10, _9heo4m,
float(VANILLA_CLOUD_L3_COVERAGE), float(VANILLA_CLOUD_L3_PIXEL_SIZE), _05ol9y, _bim3ym,
_qeto6t, _cunixp, _nmdyyy, _v5qde3, _5ziit7, 1.15, 3, _clh1ts
);
if (_f6zemr.a > 0.0) {
_iu1hx0 = _clh1ts;
_m58tk0 = _f6zemr * vec4(1.0, 1.0, 1.0, (float(VANILLA_CLOUD_L3_OPACITY) / 100.0) * _1ut2lt * _bpi90y);

_m58tk0.rgb *= _m58tk0.a;
}
}
}

vec4 layers[3] = vec4[3](vec4(0), vec4(0), vec4(0));
float dists[3] = float[3](1e6, 1e6, 1e6);
int _0mlnp4 = 0;

if (_ttnnsk.a > 0.0) { layers[_0mlnp4] = _ttnnsk; dists[_0mlnp4] = _471pyw; _0mlnp4++; }
if (_xqbaks.a > 0.0) { layers[_0mlnp4] = _xqbaks; dists[_0mlnp4] = _zsxtd8; _0mlnp4++; }
if (_m58tk0.a > 0.0) { layers[_0mlnp4] = _m58tk0; dists[_0mlnp4] = _iu1hx0; _0mlnp4++; }

for (int i = 0; i < _0mlnp4 - 1; i++) {
for (int j = 0; j < _0mlnp4 - i - 1; j++) {
if (dists[j] < dists[j+1]) {
float _b1jbw0 = dists[j]; dists[j] = dists[j+1]; dists[j+1] = _b1jbw0;
vec4 _gjqtmb = layers[j]; layers[j] = layers[j+1]; layers[j+1] = _gjqtmb;
}
}
}

vec4 _0ocrjj = vec4(0.0);
for (int i = 0; i < _0mlnp4; i++) {
_0ocrjj.rgb = _0ocrjj.rgb * (1.0 - layers[i].a) + layers[i].rgb;
_0ocrjj.a   = _0ocrjj.a   * (1.0 - layers[i].a) + layers[i].a;
}

if (_0mlnp4 > 0) {
_r6rnp2 = dists[_0mlnp4 - 1];
}

return _0ocrjj;
}

#endif
