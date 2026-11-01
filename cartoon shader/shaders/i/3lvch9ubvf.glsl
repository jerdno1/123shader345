float _1emt33(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * 0.1031);
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.x + p3.y) * p3.z);
}

float _fb5wef(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * (3.0 - 2.0 * f);

float a = _1emt33(i);
float b = _1emt33(i + vec2(1.0, 0.0));
float c = _1emt33(i + vec2(0.0, 1.0));
float d = _1emt33(i + vec2(1.0, 1.0));

return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float _tfy2nk(vec2 p) {
float _ino0s9 = 0.0;
float _2qekwd = 0.5;
float _a4mjmv = 1.0;

for (int i = 0; i < 5; i++) {
_ino0s9 += _2qekwd * _fb5wef(p * _a4mjmv);
_2qekwd *= 0.5;
_a4mjmv *= 2.0;
}

return _ino0s9;
}

float _ddtj35(vec3 _7aqewt, float _bim3ym) {

float r = 2500.0;
float _9lasr8 = CLOUD_SPEED * 3.0;
float _huatah = _bim3ym * _9lasr8 / r;
vec2 _ja8cqx = vec2(cos(_huatah), sin(_huatah)) * r;

vec2 _x41mmn = (_7aqewt.xz + _ja8cqx) * CLOUD_SCALE;

float _bfcizj = _tfy2nk(_x41mmn);
float _3tqs27 = smoothstep(1.0 - CLOUD_COVERAGE, 1.0 - CLOUD_COVERAGE + 0.3, _bfcizj);

#if CLOUD_TOON_EDGES == 1
_3tqs27 = step(0.3, _3tqs27);
#endif

return 1.0 - _3tqs27 * CLOUD_SHADOW_STRENGTH;
}
