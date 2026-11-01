#ifndef LPV_SAMPLE_GLSL
#define LPV_SAMPLE_GLSL

#include "/include/lpv/lpv_common.glsl"

#ifdef LPV_ENABLED

uniform sampler3D lpvLightSamplerA;
uniform sampler3D lpvLightSamplerB;
uniform usampler3D lpvVoxelSampler;

vec3 _xh62qd(ivec3 _z6wz07) {
ivec3 _t2et5t = clamp(_z6wz07, ivec3(0), _s41vj8 - ivec3(1));
if ((frameCounter & 1) == 0) {
return texelFetch(lpvLightSamplerA, _t2et5t, 0).rgb;
} else {
return texelFetch(lpvLightSamplerB, _t2et5t, 0).rgb;
}
}

vec3 _z35qrk(vec3 uv) {

vec3 _8ejcsz = clamp(uv * _fsho2m, vec3(0.0), _fsho2m - vec3(0.0001));
ivec3 _1csmeg = ivec3(_8ejcsz);
vec3 _uckngx = _8ejcsz - vec3(0.5);
ivec3 _3gn08v = ivec3(floor(_uckngx));
vec3 _tqosv9 = fract(_uckngx);

vec3 _iqmxcm = vec3(0.0);
float _qxgsqf = 0.0;

for (int x = 0; x <= 1; x++) {
for (int y = 0; y <= 1; y++) {
for (int z = 0; z <= 1; z++) {
ivec3 _ja8cqx = ivec3(x, y, z);
ivec3 _kbdaov = clamp(_3gn08v + _ja8cqx, ivec3(0), _s41vj8 - ivec3(1));

ivec3 _tir5iu = _kbdaov - _1csmeg;
ivec3 _ynpmf5 = abs(_tir5iu);
int _arge3b = _ynpmf5.x + _ynpmf5.y + _ynpmf5.z;

if (_arge3b == 2) {
bool _e3neu1 = false;
if (_tir5iu.x != 0 && !_98tocj(int(texelFetch(lpvVoxelSampler, clamp(_1csmeg + ivec3(_tir5iu.x, 0, 0), ivec3(0), _s41vj8 - ivec3(1)), 0).r) - 1)) _e3neu1 = true;
if (_tir5iu.y != 0 && !_98tocj(int(texelFetch(lpvVoxelSampler, clamp(_1csmeg + ivec3(0, _tir5iu.y, 0), ivec3(0), _s41vj8 - ivec3(1)), 0).r) - 1)) _e3neu1 = true;
if (_tir5iu.z != 0 && !_98tocj(int(texelFetch(lpvVoxelSampler, clamp(_1csmeg + ivec3(0, 0, _tir5iu.z), ivec3(0), _s41vj8 - ivec3(1)), 0).r) - 1)) _e3neu1 = true;
if (!_e3neu1) continue;
} else if (_arge3b == 3) {
continue;
}

if (_98tocj(int(texelFetch(lpvVoxelSampler, _kbdaov, 0).r) - 1)) continue;

vec3 w3 = mix(vec3(1.0) - _tqosv9, _tqosv9, vec3(_ja8cqx));
float _d8tv7f = w3.x * w3.y * w3.z;

_iqmxcm += _d8tv7f * _xh62qd(_kbdaov);
_qxgsqf += _d8tv7f;
}
}
}

if (_qxgsqf > 0.0) _iqmxcm /= _qxgsqf;
return _iqmxcm;
}

vec3 _t0jtn8(vec3 uv) {
vec3 _ij42j8 = clamp(uv, vec3(0.5) / _fsho2m, vec3(1.0) - vec3(0.5) / _fsho2m);
if ((frameCounter & 1) == 0) {
return texture(lpvLightSamplerA, _ij42j8).rgb;
} else {
return texture(lpvLightSamplerB, _ij42j8).rgb;
}
}

vec3 _iqqe6p(vec3 uv) {
ivec3 _z6wz07 = clamp(ivec3(floor(uv * _fsho2m)), ivec3(0), _s41vj8 - ivec3(1));
return _xh62qd(_z6wz07);
}

int _65lhj7(vec3 uv) {
ivec3 _z6wz07 = clamp(ivec3(floor(uv * _fsho2m)), ivec3(0), _s41vj8 - ivec3(1));
return int(texelFetch(lpvVoxelSampler, _z6wz07, 0).r) - 1;
}

bool _mou01e(vec3 uv) {
int blockId = _65lhj7(uv);
return blockId >= 0 && _98tocj(blockId);
}

vec3 _2xvv0f(vec3 _tthgbs, vec3 _tkgg08) {
vec3 _u6yvju = vec3(1.0) / _fsho2m;
vec3 normal = normalize(_tkgg08);
vec3 _rmq5qs = clamp(
_tthgbs + normal * _u6yvju * 0.55,
_u6yvju * 0.5,
vec3(1.0) - _u6yvju * 0.5
);
#if LPV_EDGE_AWARENESS != 0
return _z35qrk(_rmq5qs);
#else
return _t0jtn8(_rmq5qs);
#endif
}

vec3 _mvwfhb(vec3 worldPos, vec3 _tkgg08) {
vec3 _6ost17 = abs(_tkgg08);
vec3 _stzhga = worldPos;
float _1t05wb = 1.0 / 16.0;

if (_6ost17.x > _6ost17.y && _6ost17.x > _6ost17.z) {
_stzhga.y = (floor(worldPos.y / _1t05wb) + 0.5) * _1t05wb;
_stzhga.z = (floor(worldPos.z / _1t05wb) + 0.5) * _1t05wb;
} else if (_6ost17.y > _6ost17.z) {
_stzhga.x = (floor(worldPos.x / _1t05wb) + 0.5) * _1t05wb;
_stzhga.z = (floor(worldPos.z / _1t05wb) + 0.5) * _1t05wb;
} else {
_stzhga.x = (floor(worldPos.x / _1t05wb) + 0.5) * _1t05wb;
_stzhga.y = (floor(worldPos.y / _1t05wb) + 0.5) * _1t05wb;
}

vec3 _h4gwes = _stzhga - cameraPosition;
vec3 _gqgmzw = _h4gwes + _tkgg08 * 0.5;
return _cs4po4(_gqgmzw, cameraPosition);
}

float _0ja71e(vec3 _8ejcsz) {
if (!_x3urej(_8ejcsz)) return 0.0;

vec3 _36074s = abs(_8ejcsz - _fsho2m * 0.5);
float _5l6znc = max(max(_36074s.x, _36074s.y), _36074s.z);
float _qd6sut = _fsho2m.x * 0.5 * LPV_RENDER_DISTANCE;
float _4hfsjx = max(_qd6sut - LPV_FADE_OUT_DISTANCE, 0.0);
float _3nv1e7 = 1.0 - smoothstep(_4hfsjx, _qd6sut, _5l6znc);
_3nv1e7 = sqrt(max(_3nv1e7, 0.0));

vec3 _eu3q17 = min(_8ejcsz, _fsho2m - _8ejcsz);
float _pbb94i = min(min(_eu3q17.x, _eu3q17.y), _eu3q17.z);
float _a9osj3 = smoothstep(0.0, 8.0, _pbb94i);

return clamp(_a9osj3 * _3nv1e7, 0.0, 1.0);
}

float _0i2gan(vec3 worldPos, vec3 _tkgg08) {
return _0ja71e(_mvwfhb(worldPos, _tkgg08));
}

vec3 _dqt2v3(vec3 worldPos, vec3 _tkgg08, float _2o3odu) {
vec3 _8ejcsz = _mvwfhb(worldPos, _tkgg08);

if (!_x3urej(_8ejcsz)) return vec3(0.0);

vec3 _tthgbs = _8ejcsz / _fsho2m;

#if LPV_ISOLATION_STAGE >= 3
vec3 _hth45v = _2xvv0f(_tthgbs, _tkgg08);
#else
vec3 _hth45v = _iqqe6p(_tthgbs);
#endif
vec3 _gayf6f = _hvneao(_hth45v);
float _f2szbd = _4fp51a(_gayf6f);

#if LPV_ISOLATION_STAGE >= 4

float _yy3uln = mix(0.28, 1.0, pow(clamp(_2o3odu, 0.0, 1.0), 0.72));
float _gs56gy = smoothstep(0.010, 0.090, _f2szbd);
float _aiyya6 = max(_yy3uln, _gs56gy * 0.95);
vec3 _oqmso0 = _gayf6f * 0.145 * _aiyya6;
#else
vec3 _oqmso0 = _gayf6f * 0.145;
#endif

float _mex3v5 = max(dot(_oqmso0, vec3(0.299, 0.587, 0.114)), 0.0);
_oqmso0 = mix(vec3(_mex3v5), _oqmso0, LPV_VIBRANCY);

_oqmso0 *= _0ja71e(_8ejcsz) * LPV_STRENGTH;
_oqmso0 = _625ydm(_oqmso0, 0.09, 0.05);

return _oqmso0;
}

vec3 _dqt2v3(vec3 worldPos, vec3 _tkgg08) {
return _dqt2v3(worldPos, _tkgg08, 1.0);
}

#ifdef LEAF_VOXEL_SHADOW_ENABLED
bool _49x0zs(int _q71p17) {
return _q71p17 == 201;
}

float _3nrzby(vec3 blockCenterWorld, vec3 _2nrisx) {
float _ygdc5d = max(1.0, float(LEAF_VOXEL_SHADOW_DISTANCE) / float(LEAF_VOXEL_SHADOW_STEPS));
vec3 _0nffvj = blockCenterWorld - cameraPosition;

float _0mlnp4 = 0.0;
ivec3 _a7tqux = ivec3(-4096);
for (int i = 1; i <= LEAF_VOXEL_SHADOW_STEPS; i++) {
vec3 _tj3223 = _0nffvj + _2nrisx * (_ygdc5d * float(i));
vec3 _8ejcsz = _cs4po4(_tj3223, cameraPosition);
if (!_x3urej(_8ejcsz)) break;
ivec3 _xibcy1 = _y5lpmz(_8ejcsz);
if (all(equal(_xibcy1, _a7tqux))) continue;
_a7tqux = _xibcy1;

int _q71p17 = int(texelFetch(lpvVoxelSampler, _xibcy1, 0).r) - 1;
if (_49x0zs(_q71p17)) {
_0mlnp4 += float(LEAF_VOXEL_SHADOW_DENSITY);
} else if (_98tocj(_q71p17)) {
_0mlnp4 += float(LEAF_VOXEL_SHADOW_DENSITY) * 1.35;
}
}

return clamp(_0mlnp4, 0.0, 4.0);
}

float _bw1uf9(vec3 blockCenterWorld, vec3 _2nrisx) {
vec3 _xyc8gw = normalize(_2nrisx);
vec3 _tadwzx = (abs(_xyc8gw.y) < 0.92) ? vec3(0.0, 1.0, 0.0) : vec3(1.0, 0.0, 0.0);
vec3 _seahhw = normalize(cross(_xyc8gw, _tadwzx));
vec3 _48txvo = normalize(cross(_xyc8gw, _seahhw));
float _cx42xx = 0.36;

float _y9yy5h = _3nrzby(blockCenterWorld, _xyc8gw);
float _fun298 = _y9yy5h * 2.0;
_fun298 += _3nrzby(blockCenterWorld + _seahhw * _cx42xx, _xyc8gw);
_fun298 += _3nrzby(blockCenterWorld - _seahhw * _cx42xx, _xyc8gw);
_fun298 += _3nrzby(blockCenterWorld + _48txvo * _cx42xx, _xyc8gw);
_fun298 += _3nrzby(blockCenterWorld - _48txvo * _cx42xx, _xyc8gw);
_fun298 /= 6.0;

return clamp(max(_fun298, _y9yy5h * 0.75), 0.0, 4.0);
}
#endif

#endif
#endif
