#ifdef RINGED_PLANET_ENABLED

#ifndef PI
#define PI 3.14159265359
#endif

float _vtjf5f(float x) { return x * x * (3.0 - 2.0 * x); }
float _ptuo44(float x) { return clamp(x, 0.0, 1.0); }

vec2 _8p6wgw(vec3 p, vec3 _llxraj, float r) {
float b = dot(p, _llxraj);
float c = -r * r + dot(p, p);
float d = b * b - c;
if (d < 0.0) return vec2(-1e10, 1e10);
d = sqrt(d);
return vec2(-b + d, -b - d);
}

vec3 _5bcffx(vec3 _168tpr, vec3 _llxraj, vec3 normal) {
float _rsvbqz = dot(_llxraj, normal);
float _gcwy7d = 1e8;
vec3 _4ljwwf = _llxraj * _gcwy7d;
if (_rsvbqz > 0.0001 || _rsvbqz < -0.0001) {
_gcwy7d = dot(-_168tpr, normal) / _rsvbqz;
_4ljwwf = _168tpr + _llxraj * _gcwy7d;
}
return _4ljwwf;
}

vec3 _37fbgn(vec3 _frd21n, float a) {
a = max(a, 0.001);
vec3 R = sqrt(vec3(1.0) - clamp(_frd21n, 0.001, 0.999));
vec3 r = (1.0 - R) / (1.0 + R);
vec3 H = r + (0.5 - r * a) * log((1.0 + a) / a);
H *= _frd21n * a;
return 1.0 / (1.0 - clamp(H, 0.0, 0.99));
}

vec3 _k5ip2f(vec3 _frd21n, vec3 normal, vec3 _ct6z4r, vec3 _xyc8gw, float s) {
float NdotL = dot(normal, _xyc8gw);
float _i9o95p = dot(normal, _ct6z4r);
_frd21n *= _vtjf5f(_ptuo44(NdotL));
NdotL = max(NdotL, 0.001);
_i9o95p = max(_i9o95p, 0.001);
vec3 _yssmf1 = _frd21n * _37fbgn(_frd21n, NdotL) * _37fbgn(_frd21n, _i9o95p) / (4.0 * PI * (NdotL + _i9o95p));
return clamp(_yssmf1, 0.0, 1.0);
}

float _acd9wd(float a, float s, float h) {
float _re7w67 = _vtjf5f(_ptuo44((a - (1.0 - s)) * h));
return _re7w67 * _re7w67;
}

float _v8f27s(float g, float _75gmpr) {
float g2 = g * g;
return (1.0 - g2) / (4.0 * PI * pow(1.0 + g2 - 2.0 * g * _75gmpr, 1.5));
}

void _mipgsl(inout vec3 _yssmf1, in vec3 _f9k2wd, in vec3 _q62x7r, in vec3 _xyc8gw) {
float _inhf88 = 20e6;
vec3 _5ejy0y = vec3(0.0);
_5ejy0y.y += _inhf88;
_5ejy0y.y += 15e6;

float _zp66rw = dot(_xyc8gw, _q62x7r);

float _ij29cz = -1.8;
float _cshtyr = 3.0;

mat3 _8lranq = mat3(1, 0, 0, 0, cos(_ij29cz), -sin(_ij29cz), 0, sin(_ij29cz), cos(_ij29cz));
mat3 _wrq5zc = mat3(cos(_cshtyr), 0, sin(_cshtyr), 0, 1, 0, -sin(_cshtyr), 0, cos(_cshtyr));
mat3 _jjfoin = _8lranq * _wrq5zc;

float _bdc3u0 = 0.008;

mat3 _teon6a = mat3(1.0, 0.0, 0.0,
0.0, cos(_bdc3u0), sin(_bdc3u0),
0.0, -sin(_bdc3u0), cos(_bdc3u0));
mat3 _m4xvxt = transpose(_teon6a);

_q62x7r = _jjfoin * _q62x7r;
_xyc8gw = _jjfoin * _xyc8gw;

vec3 _qp1s13 = _teon6a * _q62x7r;
vec3 _l9uyee = _teon6a * _xyc8gw;

vec3 _9vpz2m = vec3(0.0, cos(_bdc3u0), sin(_bdc3u0)) * (_5ejy0y.y / _inhf88);
vec2 _yapspm = vec2(1.6, 2.6);

vec3 _3z0h19 = vec3(0.0);

vec2 _djlpxl = _8p6wgw(_5ejy0y, _q62x7r, _inhf88);
if (_djlpxl.x > 0.0) {
_yssmf1 *= 0.0;
vec3 _8zhiy3 = _q62x7r * _djlpxl.y;
vec3 _s0ptut = normalize(_8zhiy3 - vec3(0.0, -_5ejy0y.y, 0.0));
vec3 _a7jbyz = vec3(1.0, 0.87, 0.55);

float NdotL = max(dot(_s0ptut, _xyc8gw), 0.0);
_3z0h19 = _a7jbyz * (NdotL * 0.7 + 0.3);

vec3 _zr9u0r = _9vpz2m + _8zhiy3 / _inhf88;
vec3 _9l0v9n = _5bcffx(_zr9u0r, _l9uyee, vec3(0.0, 0.0, 1.0));
float _0gots5 = length(_9l0v9n);

if (_0gots5 > _yapspm.x && _0gots5 < _yapspm.y && dot(_9l0v9n - _zr9u0r, _l9uyee) > 0.0) {
float _ua039w = 0.0;
float _vs9d6e = 0.5;
float _d8i1xw = _0gots5 * 0.5 + 0.69;
for (int i = 0; i < 5; i++) {
_ua039w += _vs9d6e * texture(noisetex, vec2(_d8i1xw, 0.0)).z;
_d8i1xw = _d8i1xw * 4.0;
_vs9d6e *= 0.5;
}
float _0676bv = 0.025;
_3z0h19 *= exp(-pow(_ptuo44(_ua039w + _0676bv - 0.1) * 1.5, 3.0) * smoothstep(_yapspm.x, _yapspm.x * 1.1, _0gots5));
}

float _oc2zk8 = _ptuo44(dot(_m4xvxt[2], _s0ptut));
float _7jkk21 = _ptuo44(dot(-_m4xvxt[2], _s0ptut));
float _dp5ja0 = _ptuo44(dot(_m4xvxt * normalize(vec3(-_xyc8gw.xy, 0.0)), _s0ptut));

float _f8tywy = _acd9wd(_oc2zk8, 1.2, 1.5) * (1.0 - _acd9wd(_oc2zk8, 3.4, 0.3));
_f8tywy += _acd9wd(_7jkk21, 1.2, 1.5) * (1.0 - _acd9wd(_7jkk21, 3.4, 0.3));
_f8tywy *= 1.0 - _acd9wd(_dp5ja0, 0.7, 1.3);

_3z0h19 += _a7jbyz * (0.01 + _f8tywy * 0.7);
}

_yssmf1 += _3z0h19 * 0.5;

vec3 _y89xub = vec3(0.0);

{
vec3 _zr9u0r = vec3(0.0, cos(_bdc3u0), sin(_bdc3u0)) * (_5ejy0y.y / _inhf88);
vec3 _3eoluz = _5bcffx(_zr9u0r, _qp1s13, vec3(0.0, 0.0, 1.0));
float _i5ajeb = length(_3eoluz);

if (_i5ajeb > _yapspm.x && _i5ajeb < _yapspm.y) {

float _2zd7va = (_i5ajeb - _yapspm.x) / (_yapspm.y - _yapspm.x);
float _q9uf1c = sin(_i5ajeb * 15.0) * 0.2 + 0.7;
_q9uf1c *= smoothstep(0.0, 0.1, _2zd7va);
_q9uf1c *= 1.0 - smoothstep(0.9, 1.0, _2zd7va);

_y89xub = vec3(_q9uf1c);

if (_3eoluz.y < 0.0 && _djlpxl.x > 0.0) {
_y89xub *= 0.0;
} else {
_yssmf1 *= exp(-_y89xub * 1.5);
}

float d = length(cross(_l9uyee, _3eoluz));
if (d < 1.0 && dot(_l9uyee, _3eoluz) < 0.0) _y89xub *= 0.1;
}
}
_y89xub *= vec3(1.0, 0.85, 0.60) * (1.0 + _v8f27s(0.8, _zp66rw) * 10.0);

_yssmf1 += _y89xub * 0.3;
}
#endif
