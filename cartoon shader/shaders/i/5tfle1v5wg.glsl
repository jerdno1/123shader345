#ifndef CAZTOON_GRASS_PATCHES_GLSL
#define CAZTOON_GRASS_PATCHES_GLSL

bool _cnabfq(int _w99178) {
return _w99178 >= 10121 && _w99178 <= 10128;
}

float _03wihs(vec3 _yssmf1) {
float _m5kcpz = _yssmf1.g - max(_yssmf1.r, _yssmf1.b);
float _xgal31 = max(max(_yssmf1.r, _yssmf1.g), _yssmf1.b);
return smoothstep(0.015, 0.075, _m5kcpz) * smoothstep(0.035, 0.12, _xgal31);
}

float _zullef(vec3 _yssmf1, vec3 _ceb7bk) {
float _l33025 = _03wihs(_yssmf1);
float _3umsko = _ceb7bk.g - max(_ceb7bk.r, _ceb7bk.b);
float _4mvx5c = max(max(_ceb7bk.r, _ceb7bk.g), _ceb7bk.b);
float _o1pu5g = smoothstep(0.018, 0.070, _3umsko) * smoothstep(0.060, 0.160, _4mvx5c);
return max(_l33025, _o1pu5g);
}

vec3 _k0bae0(vec3 worldPos, vec3 _tkgg08) {
float _65berf = 16.0;
vec3 n = abs(_tkgg08);
vec3 _qsheo9 = worldPos;

if (n.y >= n.x && n.y >= n.z) {
_qsheo9.x = (floor(worldPos.x * _65berf) + 0.5) / _65berf;
_qsheo9.z = (floor(worldPos.z * _65berf) + 0.5) / _65berf;
} else if (n.x >= n.z) {
_qsheo9.y = (floor(worldPos.y * _65berf) + 0.5) / _65berf;
_qsheo9.z = (floor(worldPos.z * _65berf) + 0.5) / _65berf;
} else {
_qsheo9.x = (floor(worldPos.x * _65berf) + 0.5) / _65berf;
_qsheo9.y = (floor(worldPos.y * _65berf) + 0.5) / _65berf;
}

return _qsheo9;
}

float _8enoov(vec3 worldPos, vec3 _tkgg08, float _syetc3) {
vec3 _dz7v5x = _k0bae0(worldPos, _tkgg08);
worldPos = _dz7v5x;

float x = worldPos.x;
float y = worldPos.y;
float z = worldPos.z;
float t = _syetc3 * 0.5;

float _v7du1i = x * 0.86 + z * 0.51;
float _yxc3x6 = z * 0.86 - x * 0.51;
float _wksarx = _lpglwu(vec3(_v7du1i * 0.090 + t * 0.050, y * 0.014, _yxc3x6 * 0.070 - t * 0.085)) - 0.5;
float _zqoe52 = _yxc3x6 + _wksarx * 16.0;
vec3 pA = vec3(_v7du1i * 0.155 + t * 0.018, y * 0.020, _zqoe52 * 0.430 - t * 0.055);

float nA = 0.0;
nA += _lpglwu(pA) * 0.58;
nA += _lpglwu(pA * vec3(2.20, 1.0, 1.32) + vec3(19.7 + t * 0.035, 3.1, 42.4 - t * 0.020)) * 0.28;
nA += _lpglwu(pA * vec3(5.00, 1.0, 2.90) + vec3(-11.0 - t * 0.020, 27.0, 6.0 + t * 0.040)) * 0.14;

float _hr73s8 = x * 0.26 - z * 0.97;
float _qgkaz9 = z * 0.26 + x * 0.97;
float _pxe7rs = _lpglwu(vec3(_hr73s8 * 0.090 + 11.0 - t * 0.045, y * 0.014 + 7.0, _qgkaz9 * 0.070 - 5.0 + t * 0.075)) - 0.5;
float _2l82mk = _qgkaz9 + _pxe7rs * 14.0;
vec3 pB = vec3(_hr73s8 * 0.138 - t * 0.016, y * 0.020, _2l82mk * 0.390 + t * 0.048);

float nB = 0.0;
nB += _lpglwu(pB + vec3(37.0 + t * 0.020, 0.0, -13.0 - t * 0.035)) * 0.58;
nB += _lpglwu(pB * vec3(2.05, 1.0, 1.38) + vec3(3.0 - t * 0.025, 17.0, 29.0 + t * 0.030)) * 0.28;
nB += _lpglwu(pB * vec3(4.60, 1.0, 2.70) + vec3(-31.0 + t * 0.040, 9.0, 12.0 - t * 0.020)) * 0.14;

float _nj4nb2 = smoothstep(0.28, 0.72, _lpglwu(vec3(x * 0.020 + t * 0.010, y * 0.006, z * 0.020 - t * 0.008) + vec3(71.0, 4.0, 23.0)));
float _klibuy = _lpglwu(vec3(x * 0.360 + t * 0.060, y * 0.024, z * 0.360 - t * 0.050) + vec3(5.0, 41.0, 83.0)) - 0.5;
float n = mix(nA, nB, _nj4nb2) + _klibuy * 0.065;
n = clamp(n, 0.0, 0.999);

float _dvklli = 7.0;
float _cofhbo = floor(n * _dvklli) / (_dvklli - 1.0);
return mix(0.83, 1.10, _cofhbo);
}

vec3 _r2y1qe(vec3 _yssmf1, float _uwr0sr, float _q4j75g) {
float _mpw07u = clamp((1.0 - _uwr0sr) / 0.17, 0.0, 1.0) * _q4j75g;
vec3 _bwedbs = vec3(0.78, 0.90, 1.22);
return _yssmf1 * mix(vec3(1.0), _bwedbs, _mpw07u * 0.55);
}

vec3 _5w9i4q(vec3 _yssmf1, vec3 worldPos, vec3 _tkgg08, int _w99178, float _syetc3, vec3 _ceb7bk) {
if (!_cnabfq(_w99178)) {
return _yssmf1;
}

float _q4j75g = _zullef(_yssmf1, _ceb7bk);
float _uwr0sr = _8enoov(worldPos, _tkgg08, _syetc3);
vec3 _v2ipeh = _yssmf1 * mix(1.0, _uwr0sr, _q4j75g);
return _r2y1qe(_v2ipeh, _uwr0sr, _q4j75g);
}

vec3 _rsw7nt(vec3 _yssmf1, vec3 worldPos, vec3 _tkgg08, int _w99178, float _syetc3) {
return _5w9i4q(_yssmf1, worldPos, _tkgg08, _w99178, _syetc3, vec3(0.0));
}

#endif
