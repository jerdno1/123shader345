#ifndef LPV_COMMON_GLSL
#define LPV_COMMON_GLSL

#include "/settings.glsl"

#ifdef LPV_ENABLED

const int _gmhxr8 = LPV_VOLUME_SIZE;
const int _345jid = LPV_VOLUME_HEIGHT;
const ivec3 _s41vj8 = ivec3(LPV_VOLUME_SIZE, LPV_VOLUME_HEIGHT, LPV_VOLUME_SIZE);
const vec3 _fsho2m = vec3(_s41vj8);
const vec3 _isafey = _fsho2m * 0.5;
const float _vfkrnc = LPV_WORLD_SCALE;

float _4fp51a(vec3 _yssmf1) {
return dot(_yssmf1, vec3(0.299, 0.587, 0.114));
}

vec3 _hvneao(vec3 _bfrwd9) {
vec3 _prq5a9 = sqrt(max(_bfrwd9, vec3(0.0)));
float _0pa3k8 = _4fp51a(_prq5a9);
if (_0pa3k8 <= 0.0001) return vec3(0.0);

vec3 _e30o2u = _prq5a9 / _0pa3k8;
float _f2szbd = _0pa3k8 / (1.0 + _0pa3k8 * 0.30);
return _e30o2u * _f2szbd;
}

vec3 _625ydm(vec3 _8ores8, float _5oj62f, float _d6t1cl) {
float _rkfcys = _4fp51a(_8ores8);
if (_rkfcys <= _5oj62f || _d6t1cl <= 0.0) return _8ores8;

float _1ot1g9 = _rkfcys - _5oj62f;
float _9qpn57 = _5oj62f + (_1ot1g9 * _d6t1cl) / (_1ot1g9 + _d6t1cl);
return _8ores8 * (_9qpn57 / max(_rkfcys, 0.0001));
}

uint _yiyljr(uint _ras50y, uint _y73cfw, uint _dvnsi8, uint up, uint _4pjw1f, uint _7qmc14) {
return _ras50y | (_y73cfw << 1) | (_dvnsi8 << 2) | (up << 3) | (_4pjw1f << 4) | (_7qmc14 << 5);
}

vec3 _cs4po4(vec3 _h4gwes, vec3 _zflroq) {
return _h4gwes / _vfkrnc + fract(_zflroq / _vfkrnc) + _isafey;
}

bool _x3urej(vec3 _8ejcsz) {
return all(greaterThanEqual(_8ejcsz, vec3(0.0))) &&
all(lessThan(_8ejcsz, _fsho2m));
}

ivec3 _y5lpmz(vec3 _8ejcsz) {
return clamp(ivec3(_8ejcsz), ivec3(0), _s41vj8 - ivec3(1));
}

#define LPV_FIRE_COLOR        (vec3(2.25, 0.83, 0.27) * 3.7)

#define LPV_LAVA_COLOR        (vec3(2.20, 1.20, 0.30) * 1.4)
#define LPV_NETHER_PORTAL_COL (vec3(1.80, 0.40, 2.20) * 0.8)
#define LPV_REDSTONE_COLOR    (vec3(4.00, 0.10, 0.10))
#define LPV_SOUL_FIRE_COLOR   (vec3(0.30, 2.00, 2.20) * 2.0)
#define LPV_CANDLE_COLOR      (vec3(2.00, 1.30, 0.24))
#define LPV_CANDLE_MULT       (4.5)

#define LPV_TORCH_COLOR       (vec3(1.80, 1.30, 0.50) * 8.4)

vec3 _c1seq7(float _5eon3o) {
float _vve77m = clamp(_5eon3o, 1.0, 15.0);

float _u8qm51 = 0.78;
float _h7gypw = pow(_u8qm51, 15.0 - _vve77m);
return vec3(1.0) * 21.0 * _h7gypw;
}

vec3 _d56v3m(int blockId) {

if (blockId == 6) return LPV_TORCH_COLOR;

if (blockId == 20) return LPV_TORCH_COLOR;

if (blockId == 21) return LPV_SOUL_FIRE_COLOR;

if (blockId == 22) return LPV_FIRE_COLOR;

if (blockId == 23) return vec3(1.8, 1.4, 0.2) * 4.0;

if (blockId == 24) return vec3(1.5, 1.8, 2.2) * 12.0;

if (blockId == 25) return vec3(3.0, 0.9, 0.2) * 3.0;

if (blockId == 26) return vec3(1.9, 1.45, 0.45) * 12.0;

if (blockId == 27) return vec3(1.1, 0.85, 0.35) * 5.0;

if (blockId == 28) return vec3(0.6, 1.3, 0.6) * 4.5;

if (blockId == 29) return vec3(1.1, 0.5, 0.9) * 4.5;

if (blockId == 30) return _c1seq7(15.0);

if (blockId == 31) return vec3(1.0, 1.0, 1.0) * 4.0;

if (blockId >= 101 && blockId <= 114) return _c1seq7(float(blockId - 100));

if (blockId == 32) return vec3(1.5, 1.8, 2.2) * 12.0;
if (blockId == 33) return vec3(1.0, 1.0, 1.0) * 4.0;
if (blockId == 34) return vec3(0.25, 1.2, 0.25) * 1.0;
if (blockId == 35) return vec3(1.9, 1.45, 0.45) * 12.0;
if (blockId == 36) return LPV_TORCH_COLOR;
if (blockId == 37) return vec3(1.6, 1.35, 0.25) * 2.2;
if (blockId == 38) return LPV_REDSTONE_COLOR;
if (blockId == 39) return LPV_LAVA_COLOR;
if (blockId == 40) return vec3(3.0, 0.9, 0.2) * 3.0;
if (blockId == 41) return vec3(2.5, 1.2, 0.4) * 0.1;
if (blockId == 42) return LPV_FIRE_COLOR;
if (blockId == 43) return LPV_SOUL_FIRE_COLOR;
if (blockId == 44) return vec3(0.7, 1.5, 2.0) * 3.0;
if (blockId == 45) return vec3(0.0, 1.4, 1.4) * 4.0;
if (blockId == 46) return vec3(0.1, 0.3, 0.4) * 0.5;
if (blockId == 47) return LPV_NETHER_PORTAL_COL;
if (blockId == 48) return vec3(0.7, 1.5, 1.5) * 1.7;
if (blockId == 49) return vec3(3.0, 0.9, 0.2) * 0.125;
if (blockId == 50) return LPV_CANDLE_COLOR * 0.25 * LPV_CANDLE_MULT;
if (blockId == 51) return vec3(1.1, 0.85, 0.35) * 5.0;
if (blockId == 52) return vec3(0.6, 1.3, 0.6) * 4.5;
if (blockId == 53) return vec3(1.1, 0.5, 0.9) * 4.5;
if (blockId == 54) return vec3(1.4, 1.1, 0.5);
if (blockId == 55) return vec3(0.325, 0.15, 0.425) * 2.0;
if (blockId == 56) return vec3(0.1, 0.3, 0.4) * 0.5;
if (blockId == 57) return vec3(0.1, 0.3, 0.4) * 0.5;
if (blockId == 58) return LPV_REDSTONE_COLOR * 4.0;
if (blockId == 59) return vec3(0.957, 0.957, 0.478) * 24.0;
if (blockId == 83) return vec3(0.957, 0.957, 0.478) * 12.0;
if (blockId == 84) return vec3(0.957, 0.957, 0.478) *  6.0;

if (blockId == 95) return vec3(0.5, 1.4, 1.7) * 2.5;

if (blockId == 96) return vec3(0.4, 1.5, 0.5) * 1.8;

if (blockId == 97) return vec3(2.0, 0.7, 1.2) * 3.5;

if (blockId == 88) return LPV_NETHER_PORTAL_COL * 2.0;
if (blockId == 63) return vec3(0.0, 1.4, 1.4) * 4.0;
if (blockId == 85) return vec3(0.65, 0.35, 0.95) * 0.3;
if (blockId == 86) return LPV_REDSTONE_COLOR * 0.05;
if (blockId == 87) return vec3(0.1, 2.5, 0.1) * 3.6;
if (blockId == 89) return vec3(0.1, 2.5, 0.1) * 3.6;

return vec3(0.0);
}

vec3 _8k15jk(vec3 tint) {
float _5linhz = max(max(tint.r, tint.g), tint.b);
if (_5linhz <= 0.0001) return vec3(1.0);

tint /= _5linhz;

float _3m4k0c = dot(tint, vec3(0.299, 0.587, 0.114));
tint = mix(vec3(_3m4k0c), tint, GLASS_FILTER_SATURATION);
tint = clamp(tint, vec3(0.0), vec3(1.0));

tint = pow(tint, vec3(1.35));

return clamp(tint, vec3(0.0), vec3(1.0));
}

vec3 _gs0fh0(int blockId) {
if (blockId < 64 || blockId > 79) return vec3(1.0);

if (blockId == 64) return _8k15jk(vec3(1.0, 0.1, 0.1));
if (blockId == 65) return _8k15jk(vec3(1.0, 0.3, 0.1));
if (blockId == 66) return _8k15jk(vec3(1.0, 1.0, 0.1));
if (blockId == 67) return _8k15jk(vec3(1.0, 0.75, 0.5));
if (blockId == 68) return _8k15jk(vec3(0.3, 1.0, 0.3));
if (blockId == 69) return _8k15jk(vec3(0.1, 1.0, 0.1));
if (blockId == 70) return _8k15jk(vec3(0.1, 0.15, 1.0));
if (blockId == 71) return _8k15jk(vec3(0.5, 0.65, 1.0));
if (blockId == 72) return _8k15jk(vec3(0.3, 0.8, 1.0));
if (blockId == 73) return _8k15jk(vec3(0.7, 0.3, 1.0));
if (blockId == 74) return _8k15jk(vec3(1.0, 0.1, 1.0));
if (blockId == 75) return _8k15jk(vec3(1.0, 0.4, 1.0));
if (blockId == 76) return vec3(0.05, 0.05, 0.05);
if (blockId == 77) return vec3(1.0);
if (blockId == 78) return vec3(1.0);
if (blockId == 79) return vec3(1.0);
return vec3(1.0);
}

float _2i50b2(int blockId) {
if (blockId < 64 || blockId > 79) return 1.0;
if (blockId == 76) return 0.10;
if (blockId >= 77 && blockId <= 79) return 1.0;

float _oqxjp4 = dot(_gs0fh0(blockId), vec3(0.299, 0.587, 0.114));
return mix(0.28, 0.50, clamp(_oqxjp4, 0.0, 1.0));
}

bool _98tocj(int blockId) {
if (blockId <= 0) return false;
if (blockId == 1) return false;
if (blockId >= 2 && blockId <= 10) return false;
if (blockId == 14) return false;

if (blockId >= 20 && blockId <= 31) return false;

if (blockId >= 32 && blockId <= 60) return false;
if (blockId >= 64 && blockId <= 80) return false;
if (blockId == 82) return false;
if (blockId == 201) return false;
if (blockId == 83) return false;
if (blockId == 84) return false;
if (blockId == 85) return false;
if (blockId == 86) return false;
if (blockId == 87) return false;
if (blockId == 89) return false;
if (blockId >= 90 && blockId <= 93) return false;
if (blockId == 94) return false;
if (blockId >= 95 && blockId <= 97) return false;
if (blockId >= 101 && blockId <= 114) return false;

return true;
}

#endif
#endif
