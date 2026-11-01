#ifndef INCLUDE_WAVING_GLSL
#define INCLUDE_WAVING_GLSL

const float pi           = 3.14159265359;
const float _cf9r0r          = 6.28318530718;
const float _8ias1c       = pi / 180.0;
const float _m3ogbx = 2.39996322973;

float _7wgddl(float x) { return x * x; }
float _ed5a57(float x) { return clamp(x, 0.0, 1.0); }

#ifndef WAVING_STYLE
#define WAVING_STYLE 1
#endif

uniform vec3 cameraPosition;
#ifdef IS_IRIS
uniform vec3 relativeEyePosition;
#endif

vec3 _wylox3() {
#ifdef IS_IRIS

return cameraPosition - relativeEyePosition;
#else
return cameraPosition;
#endif
}

#ifndef FRAME_TIME_COUNTER_DECLARED
#define FRAME_TIME_COUNTER_DECLARED
uniform float frameTimeCounter;
#endif

float _ms0hw5(vec3 _y018ew) {
float d = length(_y018ew - _wylox3());
float t = smoothstep(WAVING_DISTANCE_BOOST_START, WAVING_DISTANCE_BOOST_END, d);
return mix(1.0, WAVING_DISTANCE_BOOST_MAX, t);
}

uniform float rainStrength;
uniform sampler2D noisetex;
uniform int isEyeInWater;

const int BLOCK_SMALL_PLANTS      = 2;
const int BLOCK_TALL_PLANTS_LOWER = 3;
const int BLOCK_TALL_PLANTS_UPPER = 4;
const int BLOCK_LEAVES            = 5;
const int BLOCK_HANGING_LANTERN   = 6;
const int BLOCK_HANGING_COPPER_LANTERN = 89;
const int BLOCK_GRASS_BLOCK       = 15;
const int BLOCK_GRASS             = 60;
const int BLOCK_TALL_GRASS_LOWER  = 61;
const int BLOCK_TALL_GRASS_UPPER  = 62;
const int BLOCK_OAK_LEAVES        = 82;
const int BLOCK_CAZ_LEAF1         = 201;
const int BLOCK_CAZ_GRASS_LAYER_MIN = 121;
const int BLOCK_CAZ_GRASS_LAYER_MAX = 128;

bool _l8jcrt(int _hwevwv) {
return _hwevwv == BLOCK_LEAVES || _hwevwv == BLOCK_OAK_LEAVES || _hwevwv == BLOCK_CAZ_LEAF1;
}

bool _w4fwrl(int _hwevwv) {
return _hwevwv >= BLOCK_CAZ_GRASS_LAYER_MIN && _hwevwv <= BLOCK_CAZ_GRASS_LAYER_MAX;
}

float _impdqh(int _hwevwv) {
return float(_hwevwv - BLOCK_CAZ_GRASS_LAYER_MIN + 1) * 0.125;
}

vec3 _k5cxl8(vec3 _oy86nk, vec3 _u89i9o) {
vec3 _loo149 = _oy86nk + _u89i9o / 64.0;
return _oy86nk - _loo149 + vec3(0.5);
}

bool _8kqyj4(int _hwevwv, vec3 _oy86nk, vec3 _u89i9o, vec3 normal, bool _ziieqn) {
if (!_w4fwrl(_hwevwv)) return false;

vec3 _w378yf = _k5cxl8(_oy86nk, _u89i9o);
float _pdvas5 = _impdqh(_hwevwv);

float _d0moak = step(_pdvas5 + 0.285, _w378yf.y);
float _1clfc0 = 1.0 - step(_pdvas5 + 0.58, _w378yf.y);
float _p3twob = step(0.365, max(abs(_w378yf.x - 0.5), abs(_w378yf.z - 0.5)));
return _d0moak * _1clfc0 * _p3twob > 0.5;
}

bool _ink644(int _hwevwv, vec3 _oy86nk, vec3 _u89i9o, vec3 normal) {
if (!_w4fwrl(_hwevwv)) return false;

vec3 _w378yf = _k5cxl8(_oy86nk, _u89i9o);
float _pdvas5 = _impdqh(_hwevwv);

vec3 n = normalize(normal);
float _6elxj6 = 1.0 - step(0.2, abs(n.y));
float _8xjjic = step(_pdvas5 + 0.285, _w378yf.y) * (1.0 - step(_pdvas5 + 0.58, _w378yf.y));
float _p3twob = step(0.365, max(abs(_w378yf.x - 0.5), abs(_w378yf.z - 0.5)));
return _6elxj6 * _8xjjic * _p3twob > 0.5;
}

float _91d297(vec3 _u89i9o) {

return 0.5 - _u89i9o.y / 64.0;
}

float _makhet(float _ino0s9, float _jhq88a) {
float _8ld2sn = max(_jhq88a, 1e-4);
float _ut3edl = abs(_ino0s9) / _8ld2sn;
return _ino0s9 / pow(1.0 + pow(_ut3edl, 4.0), 0.25);
}

vec3 _ju5gvs(vec3 _33gbao, float _3qc66k, float _cg34vo, float _u08e1i) {
_3qc66k = clamp(_3qc66k, 0.10, 2.0);
float _wblqzz = max(0.04, min(_u08e1i, _3qc66k * _cg34vo));
float _jczzw0 = length(_33gbao.xz);

if (_jczzw0 > 1e-5) {
float _eqhauh = _makhet(_jczzw0, _wblqzz);
_33gbao.xz *= _eqhauh / _jczzw0;
}

float _mwo021 = max(0.025, min(0.16, _3qc66k * 0.16));
_33gbao.y = _makhet(_33gbao.y, _mwo021);
return _33gbao;
}

vec3 _x9n1l8(vec3 p, float a) {
float s = sin(a);
float c = cos(a);
return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

vec3 _ohwp3b(vec3 p, float a) {
float s = sin(a);
float c = cos(a);
return vec3(c * p.x - s * p.y, s * p.x + c * p.y, p.z);
}

void _eai3wf(inout vec3 _y018ew, vec3 _u89i9o, float _4u8bey) {
vec3 _o8zme9 = _y018ew + _u89i9o / 64.0;
vec3 _fgxd3y = _o8zme9;
_fgxd3y.y = floor(_fgxd3y.y + 1.0);

vec2 _h908e6 = floor(_o8zme9.xz);
float n1 = texture(noisetex, (_h908e6 + vec2(0.5, 0.5)) / 256.0).r;
float n2 = texture(noisetex, (_h908e6 + vec2(1.5, 2.5)) / 256.0).r;

float _8565kq = mix(1.0, 1.45, rainStrength);
float _6aya72 = 0.08 * _8565kq * LANTERN_SWAY_INTENSITY;
_6aya72 *= _ms0hw5(_o8zme9) * _4u8bey;

float t = frameTimeCounter * LANTERN_SWAY_SPEED;
float _taoyuh = sin(t * 1.2 + n1 * _cf9r0r) * _6aya72;
float _vvm13c = sin(t * 1.6 + n2 * _cf9r0r) * _6aya72 * 0.8;

vec3 _lccxdl = _y018ew - _fgxd3y;
_lccxdl = _x9n1l8(_lccxdl, _taoyuh);
_lccxdl = _ohwp3b(_lccxdl, _vvm13c);
_y018ew = _fgxd3y + _lccxdl;
}

float _puuuq6(float x) {
return fract(sin(x * 12.9898) * 43758.5453);
}
vec2 _fzg23n(float x) {
return fract(sin(vec2(x, x + 1.0) * vec2(12.9898, 78.233)) * 43758.5453);
}
float _5lzgp0(vec2 p) {
return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 _9sxz35(vec3 _loo149) {
vec3 _h908e6 = floor(_loo149);
float hx = _5lzgp0(_h908e6.xz + vec2(_h908e6.y * 17.13, 19.71));
float hz = _5lzgp0(_h908e6.zx + vec2(_h908e6.y * 23.41, 47.53));
float hy = _5lzgp0(_h908e6.xy + vec2(_h908e6.z * 11.17, 5.31));
return vec3(hx - 0.5, hy - 0.5, hz - 0.5) * vec3(0.04, 0.012, 0.04);
}

vec2 _hzhn13(vec2 _w8nlmy, float t) {

float _5lo3lu = _5lzgp0(_w8nlmy + vec2(67.3, 29.1));
float _7kqy1o = 0.2;
if      (_5lo3lu > 0.75) _7kqy1o = 1.0;
else if (_5lo3lu > 0.50) _7kqy1o = 0.7;
else if (_5lo3lu > 0.25) _7kqy1o = 0.5;
t *= _7kqy1o;

float _fnyxms = 0.8 + 0.2 * _5lzgp0(_w8nlmy + vec2(5.1, 2.3));
float _c4eczi = _5lzgp0(_w8nlmy + vec2(41.3, 11.9)) * _cf9r0r;
float _u1pso8 = t + _c4eczi;

float _sl6g41 = _5lzgp0(_w8nlmy + vec2(77.0, 13.0)) * _cf9r0r;
float _z6sxc9 = _5lzgp0(_w8nlmy + vec2(19.0, 57.0)) * _cf9r0r;
float _1e4ghp = _5lzgp0(_w8nlmy + vec2(91.0, 31.0)) * _cf9r0r;
float _vymsoz = _5lzgp0(_w8nlmy + vec2(43.0, 71.0)) * _cf9r0r;
float _pgnpqo = _5lzgp0(_w8nlmy + vec2(11.0, 97.0)) * _cf9r0r;
float _qkfyhn = _5lzgp0(_w8nlmy + vec2(59.0, 23.0)) * _cf9r0r;

vec2 _v2cogc = vec2(
sin(_u1pso8 * 0.37 + _sl6g41) + 0.55 * sin(_u1pso8 * 0.91 + _z6sxc9) + 0.25 * sin(_u1pso8 * 1.63 + _1e4ghp),
cos(_u1pso8 * 0.33 + _vymsoz) + 0.50 * cos(_u1pso8 * 0.79 + _pgnpqo) + 0.22 * cos(_u1pso8 * 1.47 + _qkfyhn)
);
float _dho8ez = max(length(_v2cogc), 1e-4);
vec2 _llxraj = _v2cogc / _dho8ez;

float _g5z7ce = 0.88
+ 0.10 * sin(_u1pso8 * 0.41 + _z6sxc9)
+ 0.06 * sin(_u1pso8 * 1.07 + _pgnpqo);
float _sngck1 = _fnyxms * clamp(_g5z7ce, 0.72, 1.08);
return _llxraj * _sngck1;
}

vec2 _4pu2uz(vec2 _xvt7i1, float t) {
float _huatah = _5lzgp0(_xvt7i1) * _cf9r0r + t * 1.5;
vec2 _llxraj = vec2(cos(_huatah), sin(_huatah));
float _tq26wd = _5lzgp0(_xvt7i1 + vec2(11.3, 47.9)) * _cf9r0r;
float _8ystdl = sin(30.0 * t + _tq26wd);
return _llxraj * _8ystdl;
}

vec2 _h3o9qp(vec2 _ev094z, float _45957t, float t) {
vec2 fp = _ev094z / _45957t;
vec2 _3gn08v = floor(fp);
vec2 f = smoothstep(0.0, 1.0, fp - _3gn08v);
vec2 _cvye20 = _4pu2uz(_3gn08v + vec2(0.0, 0.0), t);
vec2 _w9q33o = _4pu2uz(_3gn08v + vec2(1.0, 0.0), t);
vec2 _ps0s19 = _4pu2uz(_3gn08v + vec2(0.0, 1.0), t);
vec2 _78gx8w = _4pu2uz(_3gn08v + vec2(1.0, 1.0), t);
vec2 a = mix(_cvye20, _w9q33o, f.x);
vec2 b = mix(_ps0s19, _78gx8w, f.x);
return mix(a, b, f.y);
}

vec3 _s4rzt7(vec3 _y018ew, float _52306d, float _5cleog, bool _xwq3eb) {
const float PATCH_SIZE = 8.0;
const float Y_DELAY    = 0.05;
const float AMPLITUDE  = 1.10;

float t = frameTimeCounter * _52306d * 3.9;

float _hoestl = max(_y018ew.y, 0.0) * Y_DELAY;
float tY = t - _hoestl;

vec2 fp = _y018ew.xz / PATCH_SIZE;
vec2 _3gn08v = floor(fp);
vec2 f = smoothstep(0.0, 1.0, fp - _3gn08v);

vec2 _wqzdj3 = _hzhn13(_3gn08v + vec2(0.0, 0.0), tY);
vec2 _oxescf = _hzhn13(_3gn08v + vec2(1.0, 0.0), tY);
vec2 _al5cdv = _hzhn13(_3gn08v + vec2(0.0, 1.0), tY);
vec2 _23zxun = _hzhn13(_3gn08v + vec2(1.0, 1.0), tY);

vec2 w0 = mix(_wqzdj3, _oxescf, f.x);
vec2 w1 = mix(_al5cdv, _23zxun, f.x);
vec2 _56jsby = mix(w0, w1, f.y) * AMPLITUDE;

{
vec2 _av6ke3 = (length(_56jsby) > 1e-5) ? normalize(_56jsby) : vec2(0.0);

vec2 _ut499w = floor(_y018ew.xz) + 0.5;
vec2 _xvt7i1 = floor(_ut499w * 8.0);
float _8fbvvj = _5lzgp0(_xvt7i1 + vec2(11.3, 47.9)) * _cf9r0r;
float _2jx3b6 = _5lzgp0(_xvt7i1 + vec2(73.1,  5.7)) * _cf9r0r;
float _imgrie  = 18.0 + _5lzgp0(_xvt7i1 + vec2(1.0,  2.0)) * 12.0;
float _ol3igm  = 11.0 + _5lzgp0(_xvt7i1 + vec2(3.0,  4.0)) *  8.0;
float _kjibo7   = 0.6 * sin(_imgrie * tY + _8fbvvj)
+ 0.4 * sin(_ol3igm * tY + _2jx3b6);
_56jsby += _av6ke3 * _kjibo7 * AMPLITUDE * 0.15;
}

{
const float CYCLE_LEN  = 6.0;
const float ACTIVE_LEN = 3.0;
const float GUST_SIZE  = 3.5;
vec2 _3vy1p6 = floor(_y018ew.xz / 10.0);

vec2 _jheqig = vec2(
_5lzgp0(_3vy1p6 + vec2(21.7,  3.1)),
_5lzgp0(_3vy1p6 + vec2( 8.9, 55.4))
) * (10.0 - GUST_SIZE);
vec2 _4z08vu = _3vy1p6 * 10.0 + _jheqig;

vec2 _fa8iuy = floor(_y018ew.xz) + 0.5;
vec2 _pjm5wu = _fa8iuy - _4z08vu;
if (all(greaterThanEqual(_pjm5wu, vec2(0.0))) && all(lessThan(_pjm5wu, vec2(GUST_SIZE)))) {

float _mz73mi = _5lzgp0(_3vy1p6 + vec2(2.3, 61.7)) * CYCLE_LEN;
float _v2h1ge = mod(tY + _mz73mi, CYCLE_LEN);
if (_v2h1ge < ACTIVE_LEN) {

float u = _v2h1ge / ACTIVE_LEN;
float _b8w39p = sin(u * pi);
float _tw9zum   = sin(u * _cf9r0r);

float _id4cg2 = floor((tY + _mz73mi) / CYCLE_LEN);
float _huatah = _5lzgp0(_3vy1p6 + vec2(_id4cg2 * 17.0, 91.0)) * _cf9r0r;
vec2 _fie1rp = vec2(cos(_huatah), sin(_huatah));
_56jsby += _fie1rp * _b8w39p * _tw9zum * AMPLITUDE * 1.25;
}
}
}

{
const float RCYCLE_LEN  = 20.0;
const float RACTIVE_LEN = 1.5;
const float RWIDTH      = 0.9;

vec2 _zo7s0h = floor(_y018ew.xz / 30.0);
float _p1w8ns = _5lzgp0(_zo7s0h + vec2(133.7, 91.4)) * RCYCLE_LEN;
float _9t5akj = mod(tY + _p1w8ns, RCYCLE_LEN);
if (_9t5akj < RACTIVE_LEN) {
float _gfygxh = floor((tY + _p1w8ns) / RCYCLE_LEN);

vec2 _zr9u0r = _zo7s0h * 30.0 + vec2(
5.0 + _5lzgp0(_zo7s0h + vec2(_gfygxh * 13.1, 7.3)) * 20.0,
5.0 + _5lzgp0(_zo7s0h + vec2(_gfygxh * 23.7, 3.9)) * 20.0
);

float _b03976 = _5lzgp0(_zo7s0h + vec2(_gfygxh * 5.1, 77.2)) * _cf9r0r;
vec2 _judggj = vec2(cos(_b03976), sin(_b03976));

float _cv95t8 = 3.0 + _5lzgp0(_zo7s0h + vec2(_gfygxh * 9.3, 41.0)) * 2.0;

vec2 _fa8iuy = floor(_y018ew.xz) + 0.5;
vec2 _22pn7r = _fa8iuy - _zr9u0r;
float _7bxou7 = dot(_22pn7r, _judggj);
float _4mrskj   = length(_22pn7r - _judggj * _7bxou7);

if (_7bxou7 >= 0.0 && _7bxou7 <= _cv95t8 && _4mrskj <= RWIDTH) {

float eU = _9t5akj / RACTIVE_LEN;
float _lwrgwj = eU * _cv95t8;
float dt = abs(_7bxou7 - _lwrgwj);
float _8ystdl = exp(-dt * 4.0);

_56jsby = _judggj * _8ystdl * AMPLITUDE * 1.6;
}
}
}

{
const float TCYCLE_LEN  = 25.0;
const float TACTIVE_LEN = 4.0;
const float TRADIUS     = 3.5;

vec2 _9vn0mv = floor(_y018ew.xz / 40.0);
float _k5r1ny = _5lzgp0(_9vn0mv + vec2(211.3, 47.8)) * TCYCLE_LEN;
float _aazizw = mod(tY + _k5r1ny, TCYCLE_LEN);
if (_aazizw < TACTIVE_LEN) {
float _nsi2tg = floor((tY + _k5r1ny) / TCYCLE_LEN);

vec2 _o8zme9 = _9vn0mv * 40.0 + vec2(
TRADIUS + 1.0 + _5lzgp0(_9vn0mv + vec2(_nsi2tg * 7.1, 11.9)) * (40.0 - 2.0 * (TRADIUS + 1.0)),
TRADIUS + 1.0 + _5lzgp0(_9vn0mv + vec2(_nsi2tg * 19.3, 83.5)) * (40.0 - 2.0 * (TRADIUS + 1.0))
);
vec2 _fa8iuy = floor(_y018ew.xz) + 0.5;
vec2 _22pn7r = _fa8iuy - _o8zme9;
float _t25r5m = length(_22pn7r);
if (_t25r5m < TRADIUS && _t25r5m > 0.01) {
vec2 _ka278a = _22pn7r / _t25r5m;

vec2 _ktlaov = vec2(-_ka278a.y, _ka278a.x);

float _ohwkuk = (_5lzgp0(_9vn0mv + vec2(_nsi2tg * 31.0, 5.0)) > 0.5) ? 1.0 : -1.0;
_ktlaov *= _ohwkuk;

float eU = _aazizw / TACTIVE_LEN;
float _quxzlw = smoothstep(0.0, 0.22, eU) * (1.0 - smoothstep(0.72, 1.0, eU));
float _2a33ka = _t25r5m / TRADIUS;
float _13yejw = smoothstep(0.08, 0.32, _2a33ka) * (1.0 - smoothstep(0.82, 1.0, _2a33ka));

float _f8zs0h = tY * 10.0 - _t25r5m * 7.0 + float(_nsi2tg) * 1.7;
float _y09jap = sin(_f8zs0h);
float _lv1wjn = cos(_f8zs0h * 1.7 + 0.6);
float _ggocio = 0.80 + 0.35 * _y09jap;
float _urdfzo = 0.28 + 0.22 * _lv1wjn;
vec2 _qvitjx = _ktlaov * _ggocio - _ka278a * _urdfzo;
_qvitjx = (length(_qvitjx) > 1e-5) ? normalize(_qvitjx) : _ktlaov;

float _hsrvax = 0.65 + 0.35 * sin(_f8zs0h * 1.3 + _2a33ka * 8.0);
float _1nosdq = _13yejw * _hsrvax;
vec2 _a39b1b = _qvitjx * _1nosdq * AMPLITUDE * 1.7;

float _p9nz7g = _quxzlw * _13yejw * 0.9;
_56jsby = mix(_56jsby, _a39b1b, _p9nz7g);
}
}
}

float _uj9dt0 = length(_56jsby);
float _d0qyx5 = sin(tY * 2.3 + _y018ew.x * 0.2 + _y018ew.z * 0.2) * 0.25 * _uj9dt0;
float _27vex6 = sin(tY * 7.0 + _y018ew.x * 0.3 + _y018ew.z * 0.3) * 0.06 * _uj9dt0;
vec3 _8izj9y = vec3(_56jsby.x, _d0qyx5 + _27vex6 - 0.04 * _uj9dt0, _56jsby.y);

if (_xwq3eb) _8izj9y *= 1.5;

return _5cleog * _8izj9y;
}

vec3 _sfyhk6(vec2 _w8nlmy, float t) {
float _mfrd2e = _5lzgp0(_w8nlmy + vec2(17.3, 91.4)) * _cf9r0r;
float _xtuhef = 0.08 + _5lzgp0(_w8nlmy + vec2(5.7, 23.1)) * 0.06;
float _huatah = _mfrd2e + t * _xtuhef;
vec2 _llxraj = vec2(cos(_huatah), sin(_huatah));

float _tq26wd = _5lzgp0(_w8nlmy + vec2(3.7, 67.9)) * _cf9r0r;
float _8ystdl = sin(9.0 * t + _tq26wd);
float _we32bj = 0.7 + 0.3 * sin(t * 0.8 + _5lzgp0(_w8nlmy + vec2(5.1, 2.3)) * _cf9r0r);

float pa = _5lzgp0(_w8nlmy + vec2(41.0, 17.0)) * _cf9r0r;
vec2 _s83wf3 = vec2(cos(pa), sin(pa));
float _qojfyf = 15.0 + _5lzgp0(_w8nlmy + vec2(73.1, 5.7)) * 10.0;
float _se2mzc = _5lzgp0(_w8nlmy + vec2(3.3, 91.0)) * _cf9r0r;
float _853c2v = sin(_qojfyf * t + _se2mzc);

float _b50yua = 2.0 + _5lzgp0(_w8nlmy + vec2(29.7, 13.3)) * 2.5;
float _5cmplj = _5lzgp0(_w8nlmy + vec2(55.1, 8.9)) * _cf9r0r;
float _lvyx6b = sin(_b50yua * t + _5cmplj);

vec2 xz = _llxraj * _8ystdl * _we32bj + _s83wf3 * _853c2v * 0.35;
return vec3(xz.x, _lvyx6b * 0.30, xz.y);
}

vec3 _lr610h(vec3 _y018ew, float _52306d, float _5cleog, vec3 _u89i9o) {
const float PATCH_SIZE = 5.0;
const float Y_DELAY    = 0.015;
const float AMPLITUDE  = 0.44;

const float HORIZ_SCALE = 0.18;

vec3 _loo149 = _y018ew + _u89i9o / 64.0;

float t = frameTimeCounter * _52306d * 2.5;
float _hoestl = max(_loo149.y, 0.0) * Y_DELAY;
float tY = t - _hoestl;

vec2 fp = _loo149.xz / PATCH_SIZE;
vec2 _3gn08v = floor(fp);
vec2 f = smoothstep(0.0, 1.0, fp - _3gn08v);

vec3 _wqzdj3 = _sfyhk6(_3gn08v + vec2(0.0, 0.0), tY);
vec3 _oxescf = _sfyhk6(_3gn08v + vec2(1.0, 0.0), tY);
vec3 _al5cdv = _sfyhk6(_3gn08v + vec2(0.0, 1.0), tY);
vec3 _23zxun = _sfyhk6(_3gn08v + vec2(1.0, 1.0), tY);

vec3 w0 = mix(_wqzdj3, _oxescf, f.x);
vec3 w1 = mix(_al5cdv, _23zxun, f.x);
vec3 _bnwa75 = mix(w0, w1, f.y) * AMPLITUDE;
_bnwa75.xz *= HORIZ_SCALE;

float _5c1lwq = length(_bnwa75.xz);
float _27vex6 = sin(tY * 7.0 + _loo149.x * 0.3 + _loo149.z * 0.3) * 0.08 * _5c1lwq;
vec3 _8izj9y = vec3(_bnwa75.x, _bnwa75.y + _27vex6 - 0.04 * _5c1lwq, _bnwa75.z);
vec3 _33gbao = _5cleog * _8izj9y;

float _jczzw0 = length(_33gbao.xz);
if (_jczzw0 > 1e-5) {
float _eqhauh = _makhet(_jczzw0, 0.06);
_33gbao.xz *= _eqhauh / _jczzw0;
}
_33gbao.y = _makhet(_33gbao.y, 0.10);
return _33gbao;
}

vec3 _3a6sdx(vec3 _y018ew) {
vec3 _42vwa8 = _wylox3() - _y018ew;
return vec3(
-6.0 * _42vwa8.xz * exp2(-length(_42vwa8 * vec3(6.0, 2.0, 6.0))),
0.0
).xzy;
}

vec3 _qspgb3(vec3 _y018ew) {

vec3 _az8c9y = _wylox3();
vec2 _aq41m9 = (_az8c9y - _y018ew).xz;
float d = length(_aq41m9);
float t = 1.0 - smoothstep(0.0, GRASS_INTERACTION_RADIUS, d);

float _euyzan = abs(_az8c9y.y - _y018ew.y);
float _ra6fay = 1.0 - smoothstep(1.0, 2.5, _euyzan);

vec2 _llxraj = (d > 1e-4) ? (_aq41m9 / d) : vec2(0.0);

float _6aya72 = t * t * _ra6fay;
return vec3(-_llxraj * (0.35 * _6aya72), 0.0).xzy;
}

vec3 _88bpsk(vec3 _y018ew, bool _ziieqn, float skylight, int _hwevwv, vec3 _u89i9o) {
bool _2c71qy =
isEyeInWater == 1 &&
(_hwevwv == BLOCK_SMALL_PLANTS ||
_hwevwv == BLOCK_TALL_PLANTS_LOWER ||
_hwevwv == BLOCK_TALL_PLANTS_UPPER ||
_hwevwv == BLOCK_GRASS ||
_hwevwv == BLOCK_TALL_GRASS_LOWER ||
_hwevwv == BLOCK_TALL_GRASS_UPPER);
bool _9xs9j4 =
(_hwevwv == BLOCK_SMALL_PLANTS ||
_hwevwv == BLOCK_TALL_PLANTS_LOWER ||
_hwevwv == BLOCK_TALL_PLANTS_UPPER ||
_hwevwv == BLOCK_GRASS ||
_hwevwv == BLOCK_TALL_GRASS_LOWER ||
_hwevwv == BLOCK_TALL_GRASS_UPPER ||
_l8jcrt(_hwevwv));

if (_2c71qy) return _y018ew;

float _52306d    = 0.3 * WAVING_SPEED;

float _njsu4x = max(skylight, 0.5);

float _5oh4j4 = mix(1.55, 1.85, rainStrength);
float _5cleog = _7wgddl(_njsu4x) * 0.25 * _5oh4j4 * WAVING_INTENSITY;
vec3 _loo149 = _y018ew + _u89i9o / 64.0;
float _q3krki = _9xs9j4 ? smoothstep(0.0, 14.0 / 15.0, skylight) : 1.0;

float _0k1ro1 = 1.0;
_52306d *= _q3krki;
_5cleog *= _q3krki;

#if WAVING_STYLE == 0

vec3 _kqrbej = vec3(0.0);
#ifdef PLAYER_PLANT_INTERACTION
_kqrbej = _3a6sdx(_loo149) * PLAYER_INTERACTION_INTENSITY;
#endif

#ifdef WAVING_PLANTS
if (_hwevwv == BLOCK_SMALL_PLANTS || _hwevwv == BLOCK_GRASS) {
vec3 _n1q51v = _s4rzt7(_loo149, _52306d, _5cleog, false);
float _3qc66k = clamp(_91d297(_u89i9o), 0.125, 1.0);
float _cg34vo = (_hwevwv == BLOCK_GRASS) ? 0.48 : 0.42;
float _u08e1i = (_hwevwv == BLOCK_GRASS) ? 0.38 : 0.42;
_n1q51v = _ju5gvs(_n1q51v, _3qc66k, _cg34vo, _u08e1i);
return _y018ew + (_n1q51v + _kqrbej) * float(_ziieqn);
}
if (_hwevwv == BLOCK_TALL_PLANTS_LOWER || _hwevwv == BLOCK_TALL_GRASS_LOWER) {
vec3 _n1q51v = _s4rzt7(_loo149, _52306d, _5cleog, false);
_n1q51v = _ju5gvs(_n1q51v, 1.0, 0.38, 0.38);
return _y018ew + (_n1q51v + _kqrbej) * float(_ziieqn);
}
if (_hwevwv == BLOCK_TALL_PLANTS_UPPER || _hwevwv == BLOCK_TALL_GRASS_UPPER) {
vec3 _tkkpf2 = _loo149 - vec3(0.0, 1.0, 0.0);
vec3 _tvqy2g = _kqrbej;
#ifdef PLAYER_PLANT_INTERACTION
_tvqy2g = _3a6sdx(_tkkpf2) * PLAYER_INTERACTION_INTENSITY;
#endif
vec3 _g4hr94 = _s4rzt7(_tkkpf2, _52306d, _5cleog, false);
vec3 _q6ok74 = _s4rzt7(_loo149, _52306d, _5cleog, true);
_g4hr94 = _ju5gvs(_g4hr94, 1.0, 0.38, 0.38);
_q6ok74 = _ju5gvs(_q6ok74, 2.0, 0.32, 0.64);
return _y018ew + mix(_g4hr94, _q6ok74, float(_ziieqn)) + _tvqy2g;
}
if (_hwevwv == BLOCK_GRASS_BLOCK || _w4fwrl(_hwevwv)) {
float _i4f2cc = (_hwevwv == BLOCK_GRASS_BLOCK) ? 1.0 : _impdqh(_hwevwv);
float _8xjjic = clamp(_91d297(_u89i9o) - _i4f2cc, 0.18, 0.60);
vec3 _u7rlfs = _s4rzt7(_loo149, _52306d, _5cleog, false);
_u7rlfs = _ju5gvs(_u7rlfs, _8xjjic, 0.55, 0.28);
return _y018ew + (_u7rlfs + _kqrbej) * float(_ziieqn);
}
#endif

#ifdef WAVING_LEAVES
if (_l8jcrt(_hwevwv)) {
float _zi6kg3 = mix(1.0, 1.25, rainStrength);
float _z5yytb = _ms0hw5(_loo149);
return _y018ew + _lr610h(_y018ew, _52306d, _5cleog * 0.45 * _zi6kg3 * _z5yytb, _u89i9o);
}
#endif

return _y018ew;
#else

_5cleog *= _ms0hw5(_loo149);

vec3 _kqrbej = vec3(0.0);
vec3 _t12aaz = vec3(0.0);
#ifdef PLAYER_PLANT_INTERACTION
_kqrbej = _3a6sdx(_loo149) * PLAYER_INTERACTION_INTENSITY;
_t12aaz = _qspgb3(_loo149) * GRASS_INTERACTION_INTENSITY;
#endif

#ifdef WAVING_PLANTS
if (_hwevwv == BLOCK_SMALL_PLANTS || _hwevwv == BLOCK_GRASS) {
vec3 _n1q51v = _s4rzt7(_loo149, _52306d, _5cleog, false);
float _3qc66k = clamp(_91d297(_u89i9o), 0.125, 1.0);
float _cg34vo = (_hwevwv == BLOCK_GRASS) ? 0.48 : 0.42;
float _u08e1i = (_hwevwv == BLOCK_GRASS) ? 0.38 : 0.42;
_n1q51v = _ju5gvs(_n1q51v, _3qc66k, _cg34vo, _u08e1i);
return _y018ew + (_n1q51v + _kqrbej) * float(_ziieqn);
}
if (_hwevwv == BLOCK_TALL_PLANTS_LOWER || _hwevwv == BLOCK_TALL_GRASS_LOWER) {
vec3 _n1q51v = _s4rzt7(_loo149, _52306d, _5cleog, false);
_n1q51v = _ju5gvs(_n1q51v, 1.0, 0.38, 0.38);
return _y018ew + (_n1q51v + _kqrbej) * float(_ziieqn);
}
if (_hwevwv == BLOCK_TALL_PLANTS_UPPER || _hwevwv == BLOCK_TALL_GRASS_UPPER) {
vec3 _tkkpf2 = _loo149 - vec3(0.0, 1.0, 0.0);
vec3 _tvqy2g = _kqrbej;
#ifdef PLAYER_PLANT_INTERACTION
_tvqy2g = _3a6sdx(_tkkpf2) * PLAYER_INTERACTION_INTENSITY;
#endif
vec3 _g4hr94 = _s4rzt7(_tkkpf2, _52306d, _5cleog, false);
vec3 _q6ok74 = _s4rzt7(_loo149, _52306d, _5cleog, true);
_g4hr94 = _ju5gvs(_g4hr94, 1.0, 0.38, 0.38);
_q6ok74 = _ju5gvs(_q6ok74, 2.0, 0.32, 0.64);
return _y018ew + mix(_g4hr94, _q6ok74, float(_ziieqn)) + _tvqy2g;
}
if (_hwevwv == BLOCK_GRASS_BLOCK || _w4fwrl(_hwevwv)) {

float _nwr69b = _52306d * GRASS_WAVING_SPEED;
float _54kcrm = _5cleog * GRASS_WAVING_INTENSITY;
float _i4f2cc = (_hwevwv == BLOCK_GRASS_BLOCK) ? 1.0 : _impdqh(_hwevwv);
float _8xjjic = clamp(_91d297(_u89i9o) - _i4f2cc, 0.18, 0.60);
vec3 _u7rlfs = _s4rzt7(_loo149, _nwr69b, _54kcrm, false);
_u7rlfs = _ju5gvs(_u7rlfs, _8xjjic, 0.55, 0.28);
return _y018ew + (_u7rlfs + _t12aaz) * float(_ziieqn);
}
#endif

#ifdef WAVING_LEAVES
if (_l8jcrt(_hwevwv)) {
float _zi6kg3 = mix(1.0, 1.25, rainStrength);
return _y018ew + _lr610h(_y018ew, _52306d, _5cleog * 0.9 * _zi6kg3, _u89i9o);
}
#endif

#ifdef SWAYING_LANTERNS
if (_hwevwv == BLOCK_HANGING_LANTERN || _hwevwv == BLOCK_HANGING_COPPER_LANTERN) {
_eai3wf(_y018ew, _u89i9o, _0k1ro1);
return _y018ew;
}
#endif

return _y018ew;
#endif
}

#endif
