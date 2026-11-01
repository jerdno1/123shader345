#ifdef END_VOID_CLOUDS_ENABLED

float _vaiaxl(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);

f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

float a = _l330c7(i);
float b = _l330c7(i + vec3(1,0,0));
float c = _l330c7(i + vec3(0,1,0));
float d = _l330c7(i + vec3(1,1,0));
float e = _l330c7(i + vec3(0,0,1));
float g = _l330c7(i + vec3(1,0,1));
float h = _l330c7(i + vec3(0,1,1));
float k = _l330c7(i + vec3(1,1,1));

return mix(mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
mix(mix(e, g, f.x), mix(h, k, f.x), f.y), f.z);
}

float _1u72fr(vec3 p) {
float _ino0s9 = 0.0;
float _jkk37u = 0.6;
float _oah0e7 = 1.0;

for (int i = 0; i < 3; i++) {
_ino0s9 += _jkk37u * _vaiaxl(p * _oah0e7);
_oah0e7 *= 2.0;
_jkk37u *= 0.4;
}
return _ino0s9;
}

float _v85ss4(vec3 worldPos, float cloudTime, float _gcfmhg, float suctionWarp) {
float y = worldPos.y;

float _l5j6tp = smoothstep(60.0, 150.0, y) * (1.0 - smoothstep(250.0, 400.0, y));
float _6ku8qd = (1.0 - smoothstep(-60.0, 0.0, y)) * smoothstep(-300.0, -180.0, y);
float _5iu9ps = max(_l5j6tp, _6ku8qd);

float _xwszfx = length(worldPos.xz);
float _9sm7ud = smoothstep(END_VOID_CLOUD_CLEARING * 80.0,
END_VOID_CLOUD_CLEARING * 300.0, _xwszfx);

if (_5iu9ps < 0.01 || _9sm7ud < 0.01) return 0.0;

float _hwkyn9 = cloudTime * END_VOID_CLOUD_SWIRL_SPEED * 0.5;
float _5o6j7n = cos(_hwkyn9);
float _kmwj34 = sin(_hwkyn9);
vec3 _pf7fw7 = vec3(
worldPos.x * _5o6j7n - worldPos.z * _kmwj34,
worldPos.y,
worldPos.x * _kmwj34 + worldPos.z * _5o6j7n
);

float _dg44sb = (y * 0.003 + log(max(_xwszfx, 1.0)) * 0.4) * END_VOID_CLOUD_SWIRL
+ cloudTime * END_VOID_CLOUD_SWIRL_SPEED;
float _r56i7r = cos(_dg44sb);
float _cskeyx = sin(_dg44sb);
vec3 _pqctgw = vec3(
_pf7fw7.x * _r56i7r - _pf7fw7.z * _cskeyx,
_pf7fw7.y,
_pf7fw7.x * _cskeyx + _pf7fw7.z * _r56i7r
);

vec3 _0xwx4i = _pqctgw * END_VOID_CLOUD_SCALE * 0.0006
+ vec3(_gcfmhg * END_VOID_CLOUD_SPEED, _gcfmhg * END_VOID_CLOUD_SPEED * 0.3, 0.0);

float n = _1u72fr(_0xwx4i);

float _3tqs27 = smoothstep(END_VOID_CLOUD_COVERAGE, END_VOID_CLOUD_COVERAGE + 0.35, n);
_3tqs27 *= _5iu9ps;
_3tqs27 *= _9sm7ud;

_3tqs27 *= (1.0 - suctionWarp * 0.9);

return _3tqs27;
}

float _o9yrwf(vec3 worldPos, float _bim3ym) {
float _up95g6 = 0.0;

for (int i = 0; i < 4; i++) {
float fi = float(i);

vec3 _utb10r = vec3(
sin(fi * 73.17) * 400.0,
cos(fi * 47.53) * 150.0 + 100.0,
sin(fi * 91.31 + 2.0) * 400.0
);

float _67ioal = length(worldPos - _utb10r);
float _k05ot4 = 1.0 - smoothstep(50.0, 500.0, _67ioal);
if (_k05ot4 < 0.01) continue;

float _f7zx6t = 6.0 + fi * 3.5;
float _tq26wd = fi * 17.3 + 5.0;
float _3v0h8k = mod(_bim3ym + _tq26wd, _f7zx6t);

float _v0ury7 = smoothstep(0.0, 0.03, _3v0h8k) * (1.0 - smoothstep(0.05, 0.12, _3v0h8k));
float _tuxdui = smoothstep(0.18, 0.21, _3v0h8k) * (1.0 - smoothstep(0.24, 0.30, _3v0h8k));
float _akuxml = _v0ury7 + _tuxdui * 0.5;

_up95g6 += _akuxml * _k05ot4;
}

return _up95g6;
}

vec3 _0klwma(vec3 worldPos, vec3 viewDir, float _3tqs27, float _t25r5m, float _bim3ym) {
vec3 _8tqn4j = vec3(END_VOID_CLOUD_R1, END_VOID_CLOUD_G1, END_VOID_CLOUD_B1);
vec3 _ae2wjm = vec3(END_VOID_CLOUD_R2, END_VOID_CLOUD_G2, END_VOID_CLOUD_B2);

float _ijslzp = _vaiaxl(worldPos * 0.0004 + _bim3ym * 0.003);
vec3 _x2q5fe = mix(_8tqn4j, _ae2wjm, smoothstep(0.3, 0.7, _ijslzp));

float _tbs06t = (1.0 - _3tqs27) * END_VOID_CLOUD_EDGE_GLOW;

float _zv6v6g = smoothstep(0.0, 300.0, worldPos.y) * 0.15;
float _uqehp1 = max(-viewDir.y, 0.0) * 0.15;

vec3 _7iyinv = _x2q5fe * (END_VOID_CLOUD_INTENSITY + _tbs06t + _zv6v6g + _uqehp1);

vec3 _8dbnph = vec3(0.44, 0.25, 0.95);
float _a9osj3 = 1.0 - smoothstep(0.0, 0.5, _3tqs27);
_7iyinv = mix(_7iyinv, _8dbnph * 0.6, _a9osj3 * 0.7);

float _akuxml = _o9yrwf(worldPos, _bim3ym);

vec3 _zv1mla = vec3(0.7, 0.5, 1.0);
_7iyinv += _zv1mla * _akuxml * _3tqs27 * 2.5;

return _7iyinv;
}

vec4 _m2f00k(vec3 _st4awd, float cloudTime, float _bim3ym, vec3 _zflroq, float _cunixp, float suctionWarp) {
vec3 _llxraj = normalize(_st4awd);

float _onvfnz = 50.0;
float _v7u3e2 = 2000.0;
float _rn314f = min(_v7u3e2, _cunixp);
if (_rn314f <= _onvfnz) return vec4(0.0);

float _gduy5n = (_v7u3e2 - _onvfnz) / float(END_VOID_CLOUD_STEPS);

float _izh8vx = fract(dot(gl_FragCoord.xy, vec2(0.7548776662, 0.5698402909))) * _gduy5n;

vec3 _kiw4a7 = vec3(0.0);
float _ujjumo = 0.0;

for (int i = 0; i < END_VOID_CLOUD_STEPS; i++) {
float t = _onvfnz + _izh8vx + float(i) * _gduy5n;
if (t > _rn314f) break;

vec3 _tj3223 = _zflroq + _llxraj * t;

float d = _v85ss4(_tj3223, cloudTime, _bim3ym, suctionWarp);

if (d > 0.001) {
float _3sjqef = 1.0 - exp(-d * _gduy5n * END_VOID_CLOUD_DENSITY * 0.02);

vec3 _rjhfmz = _0klwma(_tj3223, _llxraj, d, t, _bim3ym);

_kiw4a7 += _rjhfmz * _3sjqef * (1.0 - _ujjumo);
_ujjumo += _3sjqef * (1.0 - _ujjumo);

if (_ujjumo > 0.95) break;
}
}

return vec4(_kiw4a7, _ujjumo);
}

#endif
