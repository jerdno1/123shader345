#ifndef HELD_LIGHT_POST_GLSL
#define HELD_LIGHT_POST_GLSL

vec3 _goefua(int _kiyxjg) {
if (_kiyxjg == 10021 || _kiyxjg == 10043) return vec3(0.3, 0.7, 1.0);
if (_kiyxjg == 10087 || _kiyxjg == 10089) return vec3(0.3, 1.0, 0.4);
if (_kiyxjg == 10038 || _kiyxjg == 10058) return vec3(1.0, 0.2, 0.2);
return vec3(1.0, 0.75, 0.4);
}

vec3 _cq86ij(vec3 worldPos, vec3 _x2q5fe, vec3 _hj0fjq) {
float _ouy0o9 = clamp(float(max(heldBlockLightValue,  0)) / 15.0, 0.0, 1.0);
float _hv3ogm  = clamp(float(max(heldBlockLightValue2, 0)) / 15.0, 0.0, 1.0);

float _fxd0rw = max(_ouy0o9, _hv3ogm);
if (_fxd0rw < 0.001) return vec3(0.0);

vec3 _7g9o9b = eyePosition - vec3(0.0, 0.5, 0.0);
vec3 _ic9jj6 = worldPos - _7g9o9b;
float _nr5rfo = max(HANDHELD_LIGHT_RADIUS, 0.01);
float _rpr2uc = length(_ic9jj6.xz);
float _vtb30n = max(abs(_ic9jj6.y) - 1.0, 0.0);
float _t25r5m = sqrt(_rpr2uc * _rpr2uc + _vtb30n * _vtb30n);

float t = clamp(_t25r5m / _nr5rfo, 0.0, 1.0);
float _pvqx2j = 1.0 - t * t;
_pvqx2j = _pvqx2j * _pvqx2j * _pvqx2j;

float _0v7t0i = _fxd0rw * _pvqx2j * HANDHELD_LIGHT_STRENGTH;
float _1tsheg = max(_ouy0o9 + _hv3ogm, 0.001);
vec3 tint = (_goefua(heldItemId)  * _ouy0o9 +
_goefua(heldItemId2) * _hv3ogm) / _1tsheg;
vec3 _mxcjdz = max(_x2q5fe, vec3(0.04)) * tint * _0v7t0i;
vec3 _hu0rvg = _hj0fjq + _mxcjdz - _hj0fjq * _mxcjdz;
return max(_hu0rvg - _hj0fjq, vec3(0.0));
}

#endif
