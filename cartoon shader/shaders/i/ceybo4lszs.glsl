#ifndef VOLUMETRIC_CLOUDS_GLSL
#define VOLUMETRIC_CLOUDS_GLSL

float _2bzqlc(vec3 p) {
p = fract(p * vec3(0.1031, 0.1030, 0.0973));
p += dot(p, p.yzx + 33.33);
return fract((p.x + p.y) * p.z);
}

float _85pztj(vec2 p) {
p = fract(p * vec2(0.1031, 0.1030));
p += dot(p, p.yx + 33.33);
return fract((p.x + p.y) * p.x);
}

float _if78ny(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);
f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

float a = _2bzqlc(i);
float b = _2bzqlc(i + vec3(1,0,0));
float c = _2bzqlc(i + vec3(0,1,0));
float d = _2bzqlc(i + vec3(1,1,0));
float e = _2bzqlc(i + vec3(0,0,1));
float g = _2bzqlc(i + vec3(1,0,1));
float h = _2bzqlc(i + vec3(0,1,1));
float k = _2bzqlc(i + vec3(1,1,1));

return mix(mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
mix(mix(e, g, f.x), mix(h, k, f.x), f.y), f.z);
}

float _er80gq(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

float a = _85pztj(i);
float b = _85pztj(i + vec2(1,0));
float c = _85pztj(i + vec2(0,1));
float d = _85pztj(i + vec2(1,1));

return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float _0qwzrf(vec3 worldPos, float _bim3ym, float _q2lnx4) {
float y = worldPos.y;
float _mx3o56 = CLOUD_3D_HEIGHT + SEA_LEVEL_OFFSET;
float _hc0782 = CLOUD_3D_THICKNESS;
float _45957t = max(CLOUD_3D_CELL_SIZE, 1.0);
float _qjwlto = 25.0 / _45957t;

float _rxyf26 = _mx3o56 - _hc0782 * 0.8;
float _qf053q = _mx3o56 + _hc0782 * 2.0;
if (y < _rxyf26 || y > _qf053q) return 0.0;

float _3vuwxo = 1.2;
vec2 _5e4dwu = vec2(cos(_3vuwxo), sin(_3vuwxo));
vec2 _wh5yhd = CLOUD_3D_SPEED * _5e4dwu;
float _cz8z4z = clamp((y - _mx3o56) / _hc0782, 0.0, 1.0);
vec2 _jfq4wz = _wh5yhd * (_bim3ym + 30.0 * _cz8z4z * _cz8z4z);

vec2 _2cxico = (worldPos.xz + _wh5yhd * _bim3ym) * CLOUD_3D_SCALE * 0.001 * _qjwlto;
float _c1up7u = _er80gq(_2cxico) * _hc0782 * 1.0
+ _er80gq(_2cxico * 3.3) * _hc0782 * 0.4
- _hc0782 * 0.5;

float _o37ioh = _mx3o56 + _c1up7u;
float _50gplf = _o37ioh + _hc0782;
if (y < _o37ioh || y > _50gplf) return 0.0;

float _vb4lf1 = (y - _o37ioh) / _hc0782;

float _hwgted = CLOUD_3D_SCALE * 0.001 * _qjwlto;
vec3 _xub4w4 = vec3(
(worldPos.x + _jfq4wz.x) * _hwgted,
worldPos.y * _hwgted * 0.8,
(worldPos.z + _jfq4wz.y) * _hwgted
);

float _f88ajm = 1.0 - smoothstep(4000.0, 7000.0, _q2lnx4);
float _bfcizj = _if78ny(_xub4w4) * (0.65 + 0.35 * (1.0 - _f88ajm))
+ _if78ny(_xub4w4 * 2.7) * 0.35 * _f88ajm;

float _w8dbmu = 1.0 - CLOUD_3D_COVERAGE;
float t = clamp((_bfcizj - _w8dbmu) / 0.3, 0.0, 1.0);
float _3tqs27 = t * t;

if (_3tqs27 < 0.001) return 0.0;

float _3m84by = smoothstep(0.0, 0.12, _vb4lf1);
float _x7hq92 = 1.0 - smoothstep(0.6, 1.0, _vb4lf1);
_3tqs27 *= _3m84by * _x7hq92;

if (_3tqs27 < 0.001) return 0.0;

float _n16j7l  = 1.0 - smoothstep(1500.0, 3000.0, _q2lnx4);
float _3xca26 = 1.0 - smoothstep(3000.0, 5000.0, _q2lnx4);
float _zwfe9j  = 1.0 - smoothstep(5000.0, 8000.0, _q2lnx4);

vec3 _oeyq9d = vec3(_wh5yhd * _bim3ym, 0.0).xzy;

float _wbz0iu = 0.0;

if (_zwfe9j > 0.01) {
float _h9qnv2 = _if78ny((worldPos + _oeyq9d * 0.2) * 0.005);
_wbz0iu += 0.7 * _h9qnv2 * _h9qnv2 * _zwfe9j;
}

if (_3xca26 > 0.01) {
float _jrzzlu = _if78ny((worldPos + _oeyq9d * 0.15) * 0.012);
_wbz0iu += 0.5 * _jrzzlu * _jrzzlu * _3xca26;
}

if (_n16j7l > 0.01) {
float _2ck2l6 = _if78ny((worldPos + _oeyq9d * 0.1) * 0.028);
_wbz0iu += 0.3 * _2ck2l6 * _2ck2l6 * _n16j7l;
}
_3tqs27 -= CLOUD_3D_DETAIL * _wbz0iu;
_3tqs27 = max(_3tqs27, 0.0);

return _3tqs27;
}

float _tjtbxc(vec3 _zr9u0r, vec3 _xyc8gw, float _bim3ym, float _q2lnx4) {
const int LIGHT_STEPS = 5;
float _ygdc5d = 10.0;
float _5tqg2g = 0.0;
vec3 _gpy6je = _zr9u0r;

for (int i = 0; i < LIGHT_STEPS; i++) {
_gpy6je += _xyc8gw * _ygdc5d;
_5tqg2g += _0qwzrf(_gpy6je, _bim3ym, _q2lnx4) * _ygdc5d;
_ygdc5d *= 2.0;
}

return _5tqg2g;
}

vec3 _m52kre(float _fuf8vz, float _vb4lf1, float _dxz7fy) {
float _huatah = fract(_dxz7fy);

float _z92ecz = smoothstep(0.04, 0.10, _huatah) * (1.0 - smoothstep(0.46, 0.50, _huatah));
float _etsiop = smoothstep(0.46, 0.49, _huatah) * (1.0 - smoothstep(0.51, 0.54, _huatah))
+ smoothstep(0.97, 1.0, _huatah) + (1.0 - smoothstep(0.0, 0.05, _huatah));
float _uvzta7 = smoothstep(0.52, 0.58, _huatah) * (1.0 - smoothstep(0.94, 0.98, _huatah));

float _56jsby = max(_z92ecz + _etsiop + _uvzta7, 0.001);
_z92ecz /= _56jsby;
_etsiop /= _56jsby;
_uvzta7 /= _56jsby;

vec3 _y1erap = vec3(CLOUD_3D_R, CLOUD_3D_G, CLOUD_3D_B) * CLOUD_3D_BRIGHTNESS;
vec3 _txrszf = vec3(0.45, 0.50, 0.70) * CLOUD_3D_BRIGHTNESS;

vec3 _n08byh = vec3(1.0, 0.85, 0.65) * CLOUD_3D_BRIGHTNESS;
vec3 _lxgabc = vec3(0.50, 0.38, 0.48) * CLOUD_3D_BRIGHTNESS;

vec3 _ilbafi = vec3(0.20, 0.24, 0.38) * CLOUD_3D_BRIGHTNESS;
vec3 _mdepsv = vec3(0.08, 0.09, 0.18) * CLOUD_3D_BRIGHTNESS;

vec3 _hj0fjq = _y1erap * _z92ecz + _n08byh * _etsiop + _ilbafi * _uvzta7;
vec3 _eu5mwn = _txrszf * _z92ecz + _lxgabc * _etsiop + _mdepsv * _uvzta7;

float _q11z8u = exp(-_fuf8vz * 0.04);

_q11z8u = max(_q11z8u, 0.15);

float _rcmsay = mix(0.5, 1.0, _vb4lf1);

float _c5xr5h = _q11z8u * _rcmsay;

return mix(_eu5mwn, _hj0fjq, _c5xr5h);
}

vec4 _z8z00o(vec3 _st4awd, float _bim3ym, vec3 _zflroq, float sunAngle, vec3 _wwcrp0, float _cunixp, vec2 _rrv196, int _ol1mo0, out float _r6rnp2) {
_r6rnp2 = 0.0;
vec3 _llxraj = normalize(_st4awd);

float _mx3o56 = CLOUD_3D_HEIGHT + SEA_LEVEL_OFFSET;
float _rxyf26 = _mx3o56 - CLOUD_3D_THICKNESS * 0.8;
float _qf053q = _mx3o56 + CLOUD_3D_THICKNESS * 2.0;

float _623tqy, tMax;
if (abs(_llxraj.y) < 0.0005) {
if (_zflroq.y >= _rxyf26 && _zflroq.y <= _qf053q) {
_623tqy = 0.0; tMax = 8000.0;
} else {
return vec4(0.0);
}
} else {
float t0 = (_rxyf26 - _zflroq.y) / _llxraj.y;
float t1 = (_qf053q - _zflroq.y) / _llxraj.y;
_623tqy = min(t0, t1);
tMax = max(t0, t1);
}

_623tqy = max(_623tqy, 0.0);
if (_623tqy >= tMax) return vec4(0.0);
tMax = min(tMax, _cunixp);
if (_623tqy >= tMax) return vec4(0.0);

float _qeto6t = float(CLOUD_3D_DISTANCE);
float _4hfsjx = _qeto6t * 0.4;

if (_623tqy > _qeto6t * 1.2) return vec4(0.0);

float _n092m6 = min(tMax - _623tqy, 12000.0);
float _ygdc5d = _n092m6 / float(CLOUD_3D_STEPS);

float _izh8vx = fract(sin(dot(_rrv196 + float(_ol1mo0) * 0.7183, vec2(12.9898, 78.233))) * 43758.5453);
float _0phyy4 = _623tqy + _ygdc5d * _izh8vx;

float _usngeg = CLOUD_3D_DENSITY * 0.015;
vec3 _kiw4a7 = vec3(0.0);
float _8gkfsz = 1.0;

for (int i = 0; i < CLOUD_3D_STEPS; i++) {
if (_8gkfsz < 0.05) break;

float t = _0phyy4 + _ygdc5d * float(i);
if (t > tMax) break;

vec3 _tj3223 = _zflroq + _llxraj * t;
float _3tqs27 = _0qwzrf(_tj3223, _bim3ym, t);

if (_3tqs27 < 0.001) continue;

float _xwszfx = length(_tj3223.xz - _zflroq.xz);
float _36zwff = 1.0 - smoothstep(_4hfsjx, _qeto6t * 0.95, _xwszfx);
_36zwff *= _36zwff;
_3tqs27 *= _36zwff;

if (_3tqs27 < 0.001) continue;

if (_r6rnp2 <= 0.0) _r6rnp2 = t;

float _7rovub = _3tqs27 * _usngeg * _ygdc5d;
float _xmu2lh = exp(-_7rovub);

float _1y9mcb = _tjtbxc(_tj3223, _wwcrp0, _bim3ym, t);
float _vb4lf1 = clamp((_tj3223.y - _mx3o56) / max(CLOUD_3D_THICKNESS, 1.0), 0.0, 1.0);
vec3 _99t9pb = _m52kre(_1y9mcb, _vb4lf1, sunAngle);
float _wyfawa = (1.0 - smoothstep(0.18, 0.82, _3tqs27)) * CLOUD_3D_EDGE_GLOW;
_99t9pb += _99t9pb * _wyfawa * 0.35;

float _d8tv7f = (1.0 - _xmu2lh) * _8gkfsz;
_kiw4a7 += _99t9pb * _d8tv7f;

_8gkfsz *= _xmu2lh;
}

float _vs9d6e = 1.0 - _8gkfsz;
return vec4(_kiw4a7, _vs9d6e);
}

vec4 _8qfvgd(vec3 _st4awd, float _bim3ym, vec3 _zflroq, float _dxz7fy, vec3 _wwcrp0, vec2 _rrv196, int _ol1mo0) {
vec3 _llxraj = normalize(_st4awd);

float _mx3o56 = CLOUD_3D_HEIGHT + SEA_LEVEL_OFFSET;
float _rxyf26 = _mx3o56 - CLOUD_3D_THICKNESS * 0.8;
float _qf053q = _mx3o56 + CLOUD_3D_THICKNESS * 2.0;

float _623tqy, tMax;
if (abs(_llxraj.y) < 0.0005) {
return vec4(0.0);
} else {
float t0 = (_rxyf26 - _zflroq.y) / _llxraj.y;
float t1 = (_qf053q - _zflroq.y) / _llxraj.y;
_623tqy = min(t0, t1);
tMax = max(t0, t1);
}

_623tqy = max(_623tqy, 0.0);
if (_623tqy >= tMax) return vec4(0.0);
tMax = min(tMax, 30000.0);
if (_623tqy >= tMax) return vec4(0.0);

float _qeto6t = float(CLOUD_3D_DISTANCE);
if (_623tqy > _qeto6t * 1.2) return vec4(0.0);
float _4hfsjx = _qeto6t * 0.4;

const int REFL_STEPS = 16;
float _n092m6 = min(tMax - _623tqy, 12000.0);
float _ygdc5d = _n092m6 / float(REFL_STEPS);

float _izh8vx = fract(sin(dot(_rrv196 + float(_ol1mo0) * 0.7183, vec2(12.9898, 78.233))) * 43758.5453);
float _0phyy4 = _623tqy + _ygdc5d * _izh8vx;

float _usngeg = CLOUD_3D_DENSITY * 0.015;
vec3 _kiw4a7 = vec3(0.0);
float _8gkfsz = 1.0;

for (int i = 0; i < REFL_STEPS; i++) {
if (_8gkfsz < 0.1) break;

float t = _0phyy4 + _ygdc5d * float(i);
if (t > tMax) break;

vec3 _tj3223 = _zflroq + _llxraj * t;
float _3tqs27 = _0qwzrf(_tj3223, _bim3ym, t);
if (_3tqs27 < 0.001) continue;

float _xwszfx = length(_tj3223.xz - _zflroq.xz);
float _36zwff = 1.0 - smoothstep(_4hfsjx, _qeto6t * 0.95, _xwszfx);
_36zwff *= _36zwff;
_3tqs27 *= _36zwff;
if (_3tqs27 < 0.001) continue;

float _7rovub = _3tqs27 * _usngeg * _ygdc5d;
float _xmu2lh = exp(-_7rovub);

float _vb4lf1 = clamp((_tj3223.y - _mx3o56) / max(CLOUD_3D_THICKNESS, 1.0), 0.0, 1.0);
float _u0zaky = (1.0 - _vb4lf1) * 8.0;
vec3 _99t9pb = _m52kre(_u0zaky, _vb4lf1, _dxz7fy);

float _d8tv7f = (1.0 - _xmu2lh) * _8gkfsz;
_kiw4a7 += _99t9pb * _d8tv7f;
_8gkfsz *= _xmu2lh;
}

float _vs9d6e = 1.0 - _8gkfsz;
return vec4(_kiw4a7, _vs9d6e);
}

#endif
