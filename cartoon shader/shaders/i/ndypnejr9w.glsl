#ifdef CLOUDS_2D_ENABLED

float _id51e4(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * (3.0 - 2.0 * f);

float a = _v11u7s(i);
float b = _v11u7s(i + vec2(1.0, 0.0));
float c = _v11u7s(i + vec2(0.0, 1.0));
float d = _v11u7s(i + vec2(1.0, 1.0));

return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float _ve2xjy(vec2 p) {
float _ino0s9 = 0.0;
float _2qekwd = 0.5;
float _a4mjmv = 1.0;

for (int i = 0; i < 5; i++) {
_ino0s9 += _2qekwd * _id51e4(p * _a4mjmv);
_2qekwd *= 0.5;
_a4mjmv *= 2.0;
}

return _ino0s9;
}

float _hkd1zn(vec2 _ev094z, float _bim3ym) {

float r = 2500.0;
float _9lasr8 = CLOUD_SPEED * 3.0;
float _huatah = _bim3ym * _9lasr8 / r;
vec2 _ja8cqx = vec2(cos(_huatah), sin(_huatah)) * r;

vec2 _x41mmn = (_ev094z + _ja8cqx) * CLOUD_SCALE;

float _bfcizj = _ve2xjy(_x41mmn);

float _3tqs27 = smoothstep(1.0 - CLOUD_COVERAGE, 1.0 - CLOUD_COVERAGE + 0.3, _bfcizj);

#if CLOUD_TOON_EDGES == 1

_3tqs27 = step(0.3, _3tqs27);
#endif

return _3tqs27;
}

vec4 _uowus3(vec3 _st4awd, vec3 _zflroq, float _bim3ym, float sunAngle) {

if (_st4awd.y < 0.01) return vec4(0.0);

float t = ((CLOUD_HEIGHT + SEA_LEVEL_OFFSET) - _zflroq.y) / _st4awd.y;

if (t < 0.0) return vec4(0.0);

if (t > 50000.0) return vec4(0.0);

vec2 _ut80nk = _zflroq.xz + _st4awd.xz * t;

float _3tqs27 = _hkd1zn(_ut80nk, _bim3ym);

if (_3tqs27 < 0.01) return vec4(0.0);

vec2 _gqgmzw = _ut80nk + _st4awd.xz * CLOUD_THICKNESS * 0.5 / max(_st4awd.y, 0.1);
float _vzwol6 = _hkd1zn(_gqgmzw, _bim3ym);

float _9u1hbq = max(_3tqs27, _vzwol6 * 0.7);

float _ewdbg4 = fract(sunAngle);
float _1u4hxd = sin(_ewdbg4 * 6.28318);

vec3 _g9w3xi, _80do1j;

float _v7ipie = smoothstep(0.0, 0.15, abs(_1u4hxd)) * (1.0 - smoothstep(0.15, 0.3, abs(_1u4hxd)));
float _h0gyrr = 1.0 - smoothstep(-0.10, 0.05, _1u4hxd);

_g9w3xi = vec3(1.0, 1.0, 1.0) * CLOUD_BRIGHTNESS;
_80do1j = vec3(CLOUD_SHADOW_R, CLOUD_SHADOW_G, CLOUD_SHADOW_B);

vec3 _n08byh = vec3(1.0, 0.7, 0.5) * CLOUD_BRIGHTNESS;
vec3 _lxgabc = vec3(0.8, 0.4, 0.5);
_g9w3xi = mix(_g9w3xi, _n08byh, _v7ipie);
_80do1j = mix(_80do1j, _lxgabc, _v7ipie);

vec3 _ilbafi = vec3(0.15, 0.18, 0.25);
vec3 _mdepsv = vec3(0.05, 0.08, 0.12);
_g9w3xi = mix(_g9w3xi, _ilbafi, _h0gyrr);
_80do1j = mix(_80do1j, _mdepsv, _h0gyrr);

float r = 2500.0;
float _9lasr8 = CLOUD_SPEED * 3.0;
float _huatah = _bim3ym * _9lasr8 / r;
vec2 _ja8cqx = vec2(cos(_huatah), sin(_huatah)) * r;

float _oy5m19 = _id51e4((_ut80nk + _ja8cqx) * CLOUD_SCALE * 0.5);

vec3 _d6lhxh = max(_80do1j, _g9w3xi * 0.28);
vec3 _7iyinv = mix(_d6lhxh, _g9w3xi, _oy5m19);

float _mshjba = smoothstep(0.0, 0.5, _9u1hbq) * (1.0 - smoothstep(0.5, 1.0, _9u1hbq));
_7iyinv += vec3(1.0, 0.5, 0.2) * _mshjba * _v7ipie * 0.5;

float _eo29pw = smoothstep(-0.02, 0.16, _st4awd.y);
_9u1hbq *= _eo29pw;

vec3 _2q6syd = _un92z1(skyColor);
float _rxs39p = _jpbsbi(biome_snowy);
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _9yfvgh = _za404r(biome_arid);
float _fgx2j8 = _g4a6za(_i0sr2e(biome_savanna), _lfojrz);
vec3 _35zbuz = _8i3fbp(_2q6syd, _rxs39p, _2d13on, _lfojrz, _9yfvgh, _fgx2j8);
float _3c84br = max(dot(_35zbuz, vec3(0.299, 0.587, 0.114)), 0.001);
float _5ez11w = max(dot(_7iyinv, vec3(0.299, 0.587, 0.114)), 0.001);
vec3 _bosjrq = clamp(_35zbuz * (_5ez11w / _3c84br), vec3(0.0), vec3(2.0));
float _xi2bec = smoothstep(0.0, 0.07, fract(sunAngle)) * (1.0 - smoothstep(0.48, 0.57, fract(sunAngle))) * 0.75;
_7iyinv = mix(_7iyinv, _bosjrq, _xi2bec);
_9u1hbq *= (1.0 - _9yfvgh) * (1.0 - _lfojrz);

return vec4(_7iyinv, _9u1hbq);
}
#endif
