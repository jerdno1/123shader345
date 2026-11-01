#ifndef INCLUDE_TORNADO_PARTICLES_GLSL
#define INCLUDE_TORNADO_PARTICLES_GLSL

#include "/settings.glsl"

#ifdef TORNADO_LEAVES_ENABLED

#ifndef TP_TAU_DEFINED
#define TP_TAU_DEFINED
const float _d464bm = 6.28318530718;
#endif

const int LEAF_VARIANT_COUNT = 3;

const uint LEAF_ROWS_V0[32] = uint[](
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x10000000u, 0x00011111u,
0x10000000u, 0x00011111u,
0x10000000u, 0x00011111u,
0x22220000u, 0x00011122u,
0x22220000u, 0x00011122u,
0x22220000u, 0x00011122u,
0x22220000u, 0x00000022u,
0x22220000u, 0x00000022u,
0x22220000u, 0x00000022u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u
);

const uint LEAF_ROWS_V1[32] = uint[](
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x10000000u, 0x00011111u,
0x10000000u, 0x00011111u,
0x22200000u, 0x00011222u,
0x22200000u, 0x00011222u,
0x33330000u, 0x00011223u,
0x33330000u, 0x00011223u,
0x33330000u, 0x00000223u,
0x33000000u, 0x00000223u,
0x33000000u, 0x00000003u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u
);

const uint LEAF_ROWS_V2[32] = uint[](
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x00000000u, 0x00000000u,
0x11000000u, 0x00111111u,
0x11000000u, 0x00111111u,
0x11000000u, 0x00111111u,
0x20000000u, 0x00111222u,
0x22222200u, 0x00111222u,
0x22222200u, 0x00111222u,
0x22222200u, 0x00111222u,
0x22220000u, 0x00111022u,
0x22220000u, 0x00000022u,
0x22220000u, 0x00000022u,
0x20000000u, 0x00000022u,
0x20000000u, 0x00000022u,
0x00000000u, 0x00000000u
);

vec3 _eo88qv() {
float _rxs39p   = max(clamp(biome_snowy, 0.0, 1.0), (_kuwebx(biome) || _xtge3w(biome_category)) ? 1.0 : 0.0);
float _2d13on = max(clamp(biome_jungle, 0.0, 1.0), (_d35992(biome) || _bomyhb(biome_category)) ? 1.0 : 0.0);
float _lfojrz  = max(clamp(biome_swamp, 0.0, 1.0), (_qn96wa(biome) || _bkzj48(biome_category)) ? 1.0 : 0.0);
float _9yfvgh   = max(clamp(biome_arid, 0.0, 1.0), (_1a4dso(biome) || _l7czx3(biome_category) || _lgo6lt(biome) || _63jo5l(biome_category)) ? 1.0 : 0.0);

vec3 tint = vec3(1.0);
tint = mix(tint, vec3(0.86, 0.98, 0.90), _rxs39p * 0.70);
tint = mix(tint, vec3(0.88, 1.12, 0.82), _2d13on * 0.55);
tint = mix(tint, vec3(0.66, 0.82, 0.50), _lfojrz * 0.85);
tint = mix(tint, vec3(0.95, 0.98, 0.72), _9yfvgh * 0.40);
return tint;
}

vec3 _qwhhkp(int _dpapp1, int _wluche) {
if (_dpapp1 == 1) {
if (_wluche == 1) return vec3(0.2902, 0.5373, 0.1961);
if (_wluche == 2) return vec3(0.2275, 0.4196, 0.1490);
return vec3(0.1765, 0.3137, 0.0941);
}
if (_dpapp1 == 2) {
if (_wluche == 1) return vec3(0.2275, 0.4196, 0.1490);
return vec3(0.1882, 0.3569, 0.1255);
}
if (_wluche == 1) return vec3(0.2745, 0.4745, 0.1647);
return vec3(0.2275, 0.4196, 0.1490);
}

int _szjzbm(float _qwg4zv) {
return clamp(int(floor(fract(_qwg4zv) * float(LEAF_VARIANT_COUNT))), 0, LEAF_VARIANT_COUNT - 1);
}

bool _zo0i21() {
if (_9cwhip(biome) || _z0kr59(biome)) return false;

bool _l3my0g =
biome_beach > 0.5 ||
biome_ocean > 0.5 ||
_1a4dso(biome) ||
_l7czx3(biome_category);

return !_l3my0g;
}

vec4 _4dn6qw(vec2 uv, int _dpapp1) {
if (uv.x < 0.0 || uv.x >= 1.0 || uv.y < 0.0 || uv.y >= 1.0) return vec4(0.0);
int x = int(uv.x * 16.0);
int y = int(uv.y * 16.0);
int _qh7pgq = y * 2;
uint _ysk1l7 = LEAF_ROWS_V0[_qh7pgq];
uint _lbikli = LEAF_ROWS_V0[_qh7pgq + 1];
if (_dpapp1 == 1) {
_ysk1l7 = LEAF_ROWS_V1[_qh7pgq];
_lbikli = LEAF_ROWS_V1[_qh7pgq + 1];
} else if (_dpapp1 == 2) {
_ysk1l7 = LEAF_ROWS_V2[_qh7pgq];
_lbikli = LEAF_ROWS_V2[_qh7pgq + 1];
}
uint _w20sje = (x < 8) ? _ysk1l7 : _lbikli;
int _59bql9 = (x < 8) ? x : (x - 8);
int _wluche = int((_w20sje >> (uint(_59bql9) * 4u)) & 0xFu);
if (_wluche == 0) return vec4(0.0);
return vec4(_qwhhkp(_dpapp1, _wluche) * _eo88qv(), 1.0);
}

const float TP_CYCLE_LEN  = 100.0;
const float TP_ACTIVE_LEN = 70.0;
const float TP_RADIUS     = 2.5;
const float TP_REGION     = 40.0;
const float TP_WORLD_Y_MIN = 60.0;
const float TP_WORLD_Y_MAX = 200.0;
const float TP_RENDER_RADIUS = FLYING_LEAF_RENDER_RADIUS;
const int   TP_PER_TORNADO = 2;
const float TP_PIX_SIZE   = 0.27;

vec3 _529a2n(vec3 _au1poq, vec3 _t4un6k, vec3 viewDir) {
vec3 _wwcrp0 = normalize(mat3(gbufferModelViewInverse) * sunPosition);
float _t9278t = step(0.0, _wwcrp0.y);
vec3 _eqict5 = dot(_t4un6k, -viewDir) >= 0.0 ? _t4un6k : -_t4un6k;
float _vac4hq = max(dot(_eqict5, _wwcrp0), 0.0);
float _jjyhed = _t9278t * _vac4hq * _vac4hq * 0.85;
return _au1poq * (1.0 + _jjyhed) + vec3(0.10, 0.08, 0.03) * _jjyhed;
}

bool _umyfz4(vec3 _zflroq, vec3 viewDir, vec3 _idxc47, float _0nlczg, float _cmzf3p, float _rohqwf, out float _36074s) {
vec3 _wr6xvx = _idxc47 - _zflroq;
_36074s = length(_wr6xvx);
if (_36074s > TP_RENDER_RADIUS || _36074s >= _cmzf3p) return false;

float _c3klvl = dot(_wr6xvx, viewDir);
if (_c3klvl < 0.5 || _c3klvl > _0nlczg) return false;

float _pepmjf = max(dot(_wr6xvx, _wr6xvx) - _c3klvl * _c3klvl, 0.0);
float _y9ms16 = _rohqwf * 1.45 + 0.05;
return _pepmjf <= _y9ms16 * _y9ms16;
}

void _c3idcr(float _hookzr, float _qmwnnx, out vec3 n, out vec3 _ee8pe1, out vec3 _osfc6a) {
float ct = cos(_hookzr);
float st = sin(_hookzr);
float cr = cos(_qmwnnx);
float sr = sin(_qmwnnx);
n = vec3(ct * cr, st, ct * sr);
_osfc6a = vec3(-st * cr, ct, -st * sr);
_ee8pe1 = cross(_osfc6a, n);
}

float _qghd2x(vec2 p) {
return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

bool _2atsak(vec2 _3vy1p6, float tY, out vec2 _o8zme9, out float _quxzlw, out float eU, out float _nsi2tg) {
float _k5r1ny = _qghd2x(_3vy1p6 + vec2(211.3, 47.8)) * TP_CYCLE_LEN;
float _aazizw = mod(tY + _k5r1ny, TP_CYCLE_LEN);
if (_aazizw >= TP_ACTIVE_LEN) return false;
_nsi2tg = floor((tY + _k5r1ny) / TP_CYCLE_LEN);
_o8zme9 = _3vy1p6 * TP_REGION + vec2(
TP_RADIUS + 1.0 + _qghd2x(_3vy1p6 + vec2(_nsi2tg * 7.1, 11.9)) * (TP_REGION - 2.0 * (TP_RADIUS + 1.0)),
TP_RADIUS + 1.0 + _qghd2x(_3vy1p6 + vec2(_nsi2tg * 19.3, 83.5)) * (TP_REGION - 2.0 * (TP_RADIUS + 1.0))
);
eU = _aazizw / TP_ACTIVE_LEN;
_quxzlw = smoothstep(0.0, 0.2, eU) * (1.0 - smoothstep(0.8, 1.0, eU));
return true;
}

vec4 _m6v1zx(vec3 _zflroq, vec3 viewDir, float _0nlczg, float tY) {
if (!_zo0i21()) return vec4(0.0);
vec4 _8izj9y = vec4(0.0);
float _cmzf3p = 1e9;

vec3 _rsx45t = vec3(0.0);
vec3 _05v6mj = vec3(0.0);
vec3 _yhvmjh = vec3(0.0);
vec3 _f7mofu = vec3(0.0);
int _5639ev = 0;
bool _e122kw = false;

vec2 _egnje9 = floor(_zflroq.xz / TP_REGION);

for (int ox = -1; ox <= 1; ox++) {
for (int oz = -1; oz <= 1; oz++) {
vec2 _3vy1p6 = _egnje9 + vec2(float(ox), float(oz));
vec2 _o8zme9;
float _quxzlw, eU, _nsi2tg;
if (!_2atsak(_3vy1p6, tY, _o8zme9, _quxzlw, eU, _nsi2tg)) continue;
if (_quxzlw < 0.01) continue;

for (int i = 0; i < TP_PER_TORNADO; i++) {
float fi = float(i);

float _tq26wd = _qghd2x(_3vy1p6 + vec2(_nsi2tg * 11.0 + fi, 17.0));
float _p07kij  = _qghd2x(_3vy1p6 + vec2(_nsi2tg * 5.3 + fi, 29.0));
int _aexehr = _szjzbm(_qghd2x(_3vy1p6 + vec2(_nsi2tg * 13.7 + fi * 5.1, 61.3)));
float _nr5rfo = mix(TP_RADIUS * 0.3, TP_RADIUS * 0.95, _p07kij);

float _a0ciqo = 6.0 + _tq26wd * 3.0;
float _huatah = eU * TP_ACTIVE_LEN * _a0ciqo + _tq26wd * _d464bm;

float _vtb30n = _tq26wd * 20.0;
float y = mix(TP_WORLD_Y_MIN, TP_WORLD_Y_MAX, eU) + _vtb30n;
vec3 _idxc47 = vec3(
_o8zme9.x + cos(_huatah) * _nr5rfo,
y,
_o8zme9.y + sin(_huatah) * _nr5rfo
);

float _rohqwf = TP_PIX_SIZE;
float _36074s = 0.0;
if (!_umyfz4(_zflroq, viewDir, _idxc47, _0nlczg, _cmzf3p, _rohqwf, _36074s)) continue;

float _5zen91 = 2.0 + _tq26wd * 1.5;
float _5khpu2   = 3.0 + _p07kij  * 2.0;
float _hookzr = eU * TP_ACTIVE_LEN * _5zen91 + _tq26wd * _d464bm;
float _qmwnnx   = eU * TP_ACTIVE_LEN * _5khpu2   + _p07kij  * _d464bm;
vec3 n, _ee8pe1, _osfc6a;
_c3idcr(_hookzr, _qmwnnx, n, _ee8pe1, _osfc6a);

float _ogwka4 = dot(viewDir, n);
if (abs(_ogwka4) < 1e-4) continue;
float _h0w45i = dot(_idxc47 - _zflroq, n) / _ogwka4;
if (_h0w45i < 0.5 || _h0w45i > _0nlczg) continue;

vec3 _mng7d1 = _zflroq + viewDir * _h0w45i;
vec3 _22pn7r = _mng7d1 - _idxc47;
float u = dot(_22pn7r, _ee8pe1);
float v = dot(_22pn7r, _osfc6a);
float _mw6xat = TP_PIX_SIZE;
if (abs(u) > _mw6xat || abs(v) > _mw6xat) continue;

_cmzf3p = _36074s;
_rsx45t = _idxc47;
_05v6mj = n;
_yhvmjh = _ee8pe1;
_f7mofu = _osfc6a;
_5639ev = _aexehr;
_e122kw = true;
}
}
}

if (_e122kw) {
float _ogwka4 = dot(viewDir, _05v6mj);
float _h0w45i = dot(_rsx45t - _zflroq, _05v6mj) / _ogwka4;
vec3 _mng7d1 = _zflroq + viewDir * _h0w45i;
vec3 _22pn7r = _mng7d1 - _rsx45t;
float u = dot(_22pn7r, _yhvmjh);
float v = dot(_22pn7r, _f7mofu);
vec2 _oa95cj = vec2(u, v) / (2.0 * TP_PIX_SIZE) + 0.5;
_8izj9y = _4dn6qw(_oa95cj, _5639ev);
if (_8izj9y.a > 0.0) _8izj9y.rgb = _529a2n(_8izj9y.rgb, _05v6mj, viewDir);
}

return _8izj9y;
}

const float FL_PATCH_SIZE = 6.0;
const float FL_CELL_XZ    = 60.0;
const float FL_CELL_Y     = 10.0;
const float FL_SPEED      = 3.0;
const int   FL_RANGE_XZ   = 2;
const int   FL_RANGE_Y    = 4;
const int   FL_STREAMS    = 3;
const int   FL_SOLO_STREAMS = 2;
const int   FL_SOLO_PATHS = 5;
const int   FL_TRAIL_MAX  = FLYING_LEAF_TRAIL_MAX;
const float FL_DENSITY    = FLYING_LEAF_DENSITY;
const float FL_SOLO_TRAVEL_SPAN  = 96.0;
const float FL_GROUP_TRAVEL_SPAN = 96.0;

float _amx53r(vec3 _xvt7i1, vec3 _utb10r) {
vec2 _pct5ks = floor(_utb10r.xz / 192.0);
float _2o23fx = _qghd2x(_pct5ks + vec2(17.3, 81.9));
float _xtirl9 = _qghd2x(_pct5ks + vec2(31.7, 9.3)) * _d464bm;
vec2 _cayvua = vec2(cos(_xtirl9), sin(_xtirl9));

float _wbeqs8 = 42.0 + _2o23fx * 18.0;
float _mqiyvv = _qghd2x(_pct5ks + vec2(53.1, 27.4)) * 6.0;
float _4tv878 = dot(_utb10r.xz, _cayvua) / _wbeqs8 + _mqiyvv;
float _7dbvbt = 1.0 - abs(fract(_4tv878) - 0.5) * 2.0;
_7dbvbt = smoothstep(0.18, 0.82, _7dbvbt);

float _qrsdyx = _qghd2x(_pct5ks + vec2(71.1, 44.7));
float _ygxpm0 = smoothstep(0.28, 0.78, _qrsdyx);

float _hiusji = _qghd2x(_xvt7i1.xz + vec2(_xvt7i1.y * 0.37, 91.7));
float _t425ej = smoothstep(0.25, 0.80, _hiusji);

float _zievek = float(SEA_LEVEL_OFFSET);
float _if4m57 = 1.0 - smoothstep(48.0, 160.0, abs(_utb10r.y - (_zievek + 24.0)));
_if4m57 = mix(0.75, 1.0, _if4m57);

return clamp((_7dbvbt * 0.65 + _ygxpm0 * 0.20 + _t425ej * 0.15) * _if4m57, 0.0, 1.0);
}

vec2 _syiimv(vec2 _ev094z, float t) {
vec2 _w8nlmy = floor(_ev094z / FL_PATCH_SIZE);
float _5lo3lu = _qghd2x(_w8nlmy + vec2(67.3, 29.1));
float _7kqy1o = 0.2;
if      (_5lo3lu > 0.75) _7kqy1o = 1.0;
else if (_5lo3lu > 0.50) _7kqy1o = 0.7;
else if (_5lo3lu > 0.25) _7kqy1o = 0.5;
t *= _7kqy1o;

float _c4eczi = _qghd2x(_w8nlmy + vec2(41.3, 11.9)) * _d464bm;
float _u1pso8 = t + _c4eczi;

float _sl6g41 = _qghd2x(_w8nlmy + vec2(77.0, 13.0)) * _d464bm;
float _z6sxc9 = _qghd2x(_w8nlmy + vec2(19.0, 57.0)) * _d464bm;
float _1e4ghp = _qghd2x(_w8nlmy + vec2(91.0, 31.0)) * _d464bm;
float _vymsoz = _qghd2x(_w8nlmy + vec2(43.0, 71.0)) * _d464bm;
float _pgnpqo = _qghd2x(_w8nlmy + vec2(11.0, 97.0)) * _d464bm;
float _qkfyhn = _qghd2x(_w8nlmy + vec2(59.0, 23.0)) * _d464bm;

vec2 _v2cogc = vec2(
sin(_u1pso8 * 0.37 + _sl6g41) + 0.55 * sin(_u1pso8 * 0.91 + _z6sxc9) + 0.25 * sin(_u1pso8 * 1.63 + _1e4ghp),
cos(_u1pso8 * 0.33 + _vymsoz) + 0.50 * cos(_u1pso8 * 0.79 + _pgnpqo) + 0.22 * cos(_u1pso8 * 1.47 + _qkfyhn)
);
float _dho8ez = max(length(_v2cogc), 1e-4);
return _v2cogc / _dho8ez;
}

vec3 _thk73o(vec3 _33q5xi, vec3 _xvt7i1, float sf, float tY) {
float _hnmqxa = _qghd2x(_xvt7i1.xy + vec2(17.0 + sf * 7.3, _xvt7i1.z + sf * 11.1));
float _tq26wd = _hnmqxa * _d464bm;
vec2 _5e4dwu = _syiimv(_33q5xi.xz + vec2(sf * 4.3, sf * 6.1), tY + sf * 0.9);
vec2 _76jp1p = vec2(-_5e4dwu.y, _5e4dwu.x);
int _6h45v1 = clamp(int(floor(_qghd2x(_xvt7i1.xz + vec2(73.7 + sf * 13.0, _xvt7i1.y + sf * 5.7)) * float(FL_SOLO_PATHS))), 0, FL_SOLO_PATHS - 1);

float _th6r0x = FL_SOLO_TRAVEL_SPAN;
float _dy2a5a = _qghd2x(_xvt7i1.yz + vec2(9.7 + sf * 11.0, _xvt7i1.x + sf * 4.1)) * _th6r0x;
float _j0xy74 = mod(tY * FL_SPEED + _dy2a5a, _th6r0x) - _th6r0x * 0.5;
float _6tr095 = mod(tY * (FL_SPEED * 1.8) + _dy2a5a, _th6r0x) - _th6r0x * 0.5;
float _3h4oa2 = mod(tY * (FL_SPEED * 0.55) + _dy2a5a, _th6r0x) - _th6r0x * 0.5;

vec3 _idxc47 = _33q5xi;

if (_6h45v1 == 0) {
float _lse9dt = tY * 1.8 + _tq26wd;
float _nr5rfo = 1.4 + _qghd2x(_xvt7i1.xy + vec2(5.1 + sf * 3.0, _xvt7i1.z)) * 1.6;
vec2 _y09jap = _5e4dwu * _j0xy74 + _76jp1p * sin(_lse9dt) * _nr5rfo + _5e4dwu * cos(_lse9dt * 0.7) * 0.9;
_idxc47 += vec3(_y09jap.x, sin(_lse9dt * 1.1) * 1.2 + cos(_lse9dt * 0.6) * 0.5, _y09jap.y);
} else if (_6h45v1 == 1) {
float _66vgbh = tY * 3.8 + _tq26wd;
float _nr5rfo = 0.8 + _qghd2x(_xvt7i1.yz + vec2(2.7 + sf * 4.0, _xvt7i1.x)) * 1.1;
vec2 _mlggni = _5e4dwu * _6tr095 + _76jp1p * cos(_66vgbh) * _nr5rfo + _5e4dwu * sin(_66vgbh) * 0.6;
_idxc47 += vec3(_mlggni.x, sin(_66vgbh * 0.8) * 1.5 + cos(_66vgbh * 1.4) * 0.8, _mlggni.y);
} else if (_6h45v1 == 2) {
float _5stxyn = tY * 1.4 + _tq26wd;
float _kpkjmn = mod(tY * 0.85 + _qghd2x(_xvt7i1.xy + vec2(14.3 + sf * 5.0, _xvt7i1.z)) * 9.0, 9.0) - 4.5;
vec2 _pnr1f3 = _5e4dwu * _3h4oa2 + _76jp1p * sin(_5stxyn * 1.7) * 2.2;
_idxc47 += vec3(_pnr1f3.x, -_kpkjmn + sin(_5stxyn * 0.9) * 0.7, _pnr1f3.y);
} else if (_6h45v1 == 3) {
float _uf80kz = tY * 2.6 + _tq26wd;
vec2 _fwi4gb = _5e4dwu * (_6tr095 * 1.25) + _76jp1p * sin(_uf80kz * 2.2) * 0.6;
_idxc47 += vec3(_fwi4gb.x, sin(_uf80kz * 1.4) * 0.45 + cos(_uf80kz * 2.5) * 0.2, _fwi4gb.y);
} else {
float _6nq4s7 = tY * 1.15 + _tq26wd;
vec2 _dhoi0y = _5e4dwu * (_j0xy74 * 0.8) + _76jp1p * (sin(_6nq4s7) * 1.7 + cos(_6nq4s7 * 0.45) * 0.9);
_idxc47 += vec3(_dhoi0y.x, sin(_6nq4s7 * 0.8) * 0.9 + cos(_6nq4s7 * 1.6) * 0.35, _dhoi0y.y);
}

return _idxc47;
}

bool _31via2(
vec3 _zflroq, vec3 viewDir, float _0nlczg, float tY, vec3 _xvt7i1, float sf, float ti, int _aexehr, vec3 _idxc47,
inout float _cmzf3p, inout vec3 _rsx45t, inout vec3 _05v6mj, inout vec3 _yhvmjh, inout vec3 _f7mofu, inout int _5639ev, inout bool _e122kw
) {
float _rohqwf = TP_PIX_SIZE;
float _36074s = 0.0;
if (!_umyfz4(_zflroq, viewDir, _idxc47, _0nlczg, _cmzf3p, _rohqwf, _36074s)) return false;

float _hookzr = tY * 5.0 + _qghd2x(_xvt7i1.xz + vec2(1.1 + ti * 2.3 + sf * 7.0, _xvt7i1.y + sf * 2.0)) * _d464bm;
float _qmwnnx   = tY * 7.0 + _qghd2x(_xvt7i1.xy + vec2(2.3 + ti * 1.7 + sf * 5.0, _xvt7i1.z + sf * 3.0)) * _d464bm;
vec3 n, _ee8pe1, _osfc6a;
_c3idcr(_hookzr, _qmwnnx, n, _ee8pe1, _osfc6a);

float _ogwka4 = dot(viewDir, n);
if (abs(_ogwka4) < 1e-4) return false;
float _h0w45i = dot(_idxc47 - _zflroq, n) / _ogwka4;
if (_h0w45i < 0.5 || _h0w45i > _0nlczg) return false;

vec3 _mng7d1 = _zflroq + viewDir * _h0w45i;
vec3 _22pn7r = _mng7d1 - _idxc47;
float u = dot(_22pn7r, _ee8pe1);
float v = dot(_22pn7r, _osfc6a);
float _mw6xat = TP_PIX_SIZE;
if (abs(u) > _mw6xat || abs(v) > _mw6xat) return false;

_cmzf3p = _36074s;
_rsx45t = _idxc47;
_05v6mj = n;
_yhvmjh = _ee8pe1;
_f7mofu = _osfc6a;
_5639ev = _aexehr;
_e122kw = true;
return true;
}

vec4 _g3wuwv(vec3 _zflroq, vec3 viewDir, float _0nlczg, float tY) {
if (!_zo0i21()) return vec4(0.0);
vec4 _8izj9y = vec4(0.0);
float _cmzf3p = 1e9;

vec3 _rsx45t = vec3(0.0);
vec3 _05v6mj = vec3(0.0);
vec3 _yhvmjh = vec3(0.0);
vec3 _f7mofu = vec3(0.0);
int _5639ev = 0;
bool _e122kw = false;

vec3 _wfjohk = floor(_zflroq / vec3(FL_CELL_XZ, FL_CELL_Y, FL_CELL_XZ));

for (int ox = -FL_RANGE_XZ; ox <= FL_RANGE_XZ; ox++) {
for (int oy = -FL_RANGE_Y;  oy <= FL_RANGE_Y;  oy++) {
for (int oz = -FL_RANGE_XZ; oz <= FL_RANGE_XZ; oz++) {
vec3 _xvt7i1 = _wfjohk + vec3(float(ox), float(oy), float(oz));

vec3 _utb10r = (_xvt7i1 + 0.5) * vec3(FL_CELL_XZ, FL_CELL_Y, FL_CELL_XZ);
vec3 _xs8ex1 = _utb10r - _zflroq;
if (length(_xs8ex1) > TP_RENDER_RADIUS + length(vec3(FL_CELL_XZ, FL_CELL_Y, FL_CELL_XZ)) * 0.5) continue;
if (dot(_xs8ex1, viewDir) < -FL_CELL_XZ) continue;
float _c9zw0t = _utb10r.y - _zflroq.y;
float _jik9lp = 1.0 - smoothstep(12.0, 34.0, _c9zw0t);
if (_jik9lp <= 0.0001) continue;
float _ol0eis = _amx53r(_xvt7i1, _utb10r) * FL_DENSITY;
_ol0eis *= mix(0.55, 1.0, _jik9lp);
if (_ol0eis < 0.40) continue;
int _ro9jck = 1 + int(floor(clamp((_ol0eis - 0.40) / 0.60, 0.0, 0.999) * float(FL_STREAMS)));
_ro9jck = clamp(_ro9jck, 1, FL_STREAMS);
for (int _71qop9 = 0; _71qop9 < _ro9jck; _71qop9++) {
float sf = float(_71qop9);

float _cf4u3v = _qghd2x(_xvt7i1.xy + vec2(7.3 + sf * 13.1, _xvt7i1.z + sf * 3.1));
_cf4u3v = pow(_cf4u3v, 1.9) * 0.58 + 0.05;
vec3 _33q5xi = (_xvt7i1 + vec3(
_qghd2x(_xvt7i1.xz + vec2(3.1 + sf * 11.7, _xvt7i1.y + sf * 2.3)),
_cf4u3v,
_qghd2x(_xvt7i1.yz + vec2(2.9 + sf * 9.7,  _xvt7i1.x + sf * 4.7))
)) * vec3(FL_CELL_XZ, FL_CELL_Y, FL_CELL_XZ);

float _g9d5px = _qghd2x(_xvt7i1.xz + vec2(53.1 + sf * 19.3, _xvt7i1.y + sf * 7.1));
bool _7k91le = _71qop9 < FL_SOLO_STREAMS;
int _zdm7hw = _7k91le ? 1 : (int(floor(_g9d5px * float(FL_TRAIL_MAX))) + 1);
const float TRAIL_SPACING = 0.8;

if (_7k91le) {
float ti = 0.0;
int _aexehr = _szjzbm(_qghd2x(_xvt7i1.xz + vec2(_xvt7i1.y * 13.0 + sf * 23.0, 91.7 + sf * 11.0)));
vec3 _idxc47 = _thk73o(_33q5xi, _xvt7i1, sf, tY);
_31via2(_zflroq, viewDir, _0nlczg, tY, _xvt7i1, sf, ti, _aexehr, _idxc47,
_cmzf3p, _rsx45t, _05v6mj, _yhvmjh, _f7mofu, _5639ev, _e122kw);
continue;
}

for (int _971xpy = 0; _971xpy < FL_TRAIL_MAX; _971xpy++) {
if (_971xpy >= _zdm7hw) break;
float ti = float(_971xpy);
int _aexehr = _szjzbm(_qghd2x(_xvt7i1.xz + vec2(_xvt7i1.y * 13.0 + ti * 5.7 + sf * 23.0, 91.7 + sf * 11.0)));

float _huatah = _qghd2x(_xvt7i1.xz + vec2(31.7 + sf * 17.0, _xvt7i1.y + sf * 5.0)) * _d464bm;
vec2 _5e4dwu = vec2(cos(_huatah), sin(_huatah));
float _5cmplj = _qghd2x(_xvt7i1.xy + vec2(11.0 + ti * 3.7 + sf * 13.0, _xvt7i1.z + sf * 5.3)) * _d464bm;
float _bs8lxo = sin(tY * 0.7 + _5cmplj) * 2.0;

float _mnoqbp = ti * TRAIL_SPACING;
float _auryyt = _qghd2x(_xvt7i1.xz + vec2(7.3 + sf * 29.1, _xvt7i1.y + sf * 3.0)) * FL_GROUP_TRAVEL_SPAN;
float _lw4r3f = mod(tY * FL_SPEED + _auryyt - _mnoqbp, FL_GROUP_TRAVEL_SPAN) - FL_GROUP_TRAVEL_SPAN * 0.5;

vec3 _idxc47 = vec3(
_33q5xi.x + _5e4dwu.x * _lw4r3f,
_33q5xi.y + _bs8lxo + ti * 0.1 + sf * 0.35,
_33q5xi.z + _5e4dwu.y * _lw4r3f
);

_31via2(_zflroq, viewDir, _0nlczg, tY, _xvt7i1, sf, ti, _aexehr, _idxc47,
_cmzf3p, _rsx45t, _05v6mj, _yhvmjh, _f7mofu, _5639ev, _e122kw);
}
}
}
}
}

if (_e122kw) {
float _ogwka4 = dot(viewDir, _05v6mj);
float _h0w45i = dot(_rsx45t - _zflroq, _05v6mj) / _ogwka4;
vec3 _mng7d1 = _zflroq + viewDir * _h0w45i;
vec3 _22pn7r = _mng7d1 - _rsx45t;
float u = dot(_22pn7r, _yhvmjh);
float v = dot(_22pn7r, _f7mofu);
vec2 _oa95cj = vec2(u, v) / (2.0 * TP_PIX_SIZE) + 0.5;
_8izj9y = _4dn6qw(_oa95cj, _5639ev);
if (_8izj9y.a > 0.0) _8izj9y.rgb = _529a2n(_8izj9y.rgb, _05v6mj, viewDir);
}

return _8izj9y;
}

#endif

#endif
