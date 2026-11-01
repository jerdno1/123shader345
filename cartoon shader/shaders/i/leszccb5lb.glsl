#ifndef SKY_NIGHT_FEATURES_GLSL
#define SKY_NIGHT_FEATURES_GLSL

#ifndef SKY_HASH_DEFINED
#define SKY_HASH_DEFINED

float _02helh(float p) {
p = fract(p * 0.1031);
p *= p + 33.33;
p *= p + p;
return fract(p);
}

float _e9nx95(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * 0.1031);
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.x + p3.y) * p3.z);
}

vec2 _dok524(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.xx + p3.yz) * p3.zy);
}

float _gwbhay(vec3 p) {
p = fract(p * 0.1031);
p += dot(p, p.zyx + 31.32);
return fract((p.x + p.y) * p.z);
}
#endif

#ifndef SKY_ROTATE_DEFINED
#define SKY_ROTATE_DEFINED

vec3 _h4oidp(vec3 v, float _huatah) {
float c = cos(_huatah); float s = sin(_huatah);
return vec3(v.x, v.y * c - v.z * s, v.y * s + v.z * c);
}

vec3 _1vgoyy(vec3 v, float _huatah) {
float c = cos(_huatah); float s = sin(_huatah);
return vec3(v.x * c - v.y * s, v.x * s + v.y * c, v.z);
}

vec3 _d0i5i9(vec3 _llxraj, float _etzrwc) {
_llxraj = _1vgoyy(_llxraj, radians(_cej4mm));
_llxraj = _h4oidp(_llxraj, _etzrwc * 6.28318);
return _llxraj;
}
#endif

vec2 _t8123h(vec3 _llxraj) {
vec3 a = abs(_llxraj);
vec2 uv;
float face;
if (a.x >= a.y && a.x >= a.z) {
uv = _llxraj.zy / a.x; face = _llxraj.x > 0.0 ? 0.0 : 1.0;
} else if (a.y >= a.z) {
uv = _llxraj.xz / a.y; face = _llxraj.y > 0.0 ? 2.0 : 3.0;
} else {
uv = _llxraj.xy / a.z; face = _llxraj.z > 0.0 ? 4.0 : 5.0;
}
uv += face * 100.0;
return uv;
}

float _f7cv8m(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);
f = f * f * (3.0 - 2.0 * f);

float a = _gwbhay(i);
float b = _gwbhay(i + vec3(1,0,0));
float c = _gwbhay(i + vec3(0,1,0));
float d = _gwbhay(i + vec3(1,1,0));
float e = _gwbhay(i + vec3(0,0,1));
float g = _gwbhay(i + vec3(1,0,1));
float h = _gwbhay(i + vec3(0,1,1));
float k = _gwbhay(i + vec3(1,1,1));

return mix(mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
mix(mix(e, g, f.x), mix(h, k, f.x), f.y), f.z);
}

float _vx166i(vec3 p, int _c5iapm) {
float v = 0.0, _jkk37u = 0.5;
for (int i = 0; i < _c5iapm; i++) {
v += _jkk37u * _f7cv8m(p);
p *= 2.0; _jkk37u *= 0.5;
}
return v;
}

#ifdef STARS_ENABLED
float _yv4dg3(vec3 _llxraj, float _bim3ym, float _etzrwc) {
_llxraj = normalize(_llxraj);
_llxraj = _d0i5i9(_llxraj, _etzrwc);

vec2 _ufcu6o = _t8123h(_llxraj) * STAR_SCALE;
vec2 _h908e6 = floor(_ufcu6o);
vec2 _pjm5wu = fract(_ufcu6o);

float _6hl4a5 = 0.0;
for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 nc = _h908e6 + vec2(x, y);
float _2xxeoy = _e9nx95(nc);
if (_2xxeoy > STAR_DENSITY) continue;

vec2 sp = _dok524(nc) * 0.6 + 0.2;
vec2 d = _pjm5wu - vec2(x, y) - sp;
float _t25r5m = length(d);

float _3j5sp9 = 0.4 + _e9nx95(nc + 500.0) * 0.6;
float _j1b98s = _e9nx95(nc + 700.0) * 6.28318;
float _pcghs4 = 0.5 + _e9nx95(nc + 800.0) * 2.0;
float _gg05ax = 0.7 + 0.3 * sin(_bim3ym * _pcghs4 + _j1b98s);
float _dq2uwi = _e9nx95(nc + 900.0);
_gg05ax = mix(1.0, _gg05ax, _dq2uwi * STAR_TWINKLE);

float _ulytmb = _3j5sp9 * _gg05ax * STAR_BRIGHTNESS;
float _nr5rfo = STAR_SIZE * (0.5 + _e9nx95(nc + 400.0) * 0.5);
float s = 1.0 - smoothstep(0.0, _nr5rfo, _t25r5m);
_6hl4a5 = max(_6hl4a5, s * _ulytmb);
}
}
return _6hl4a5;
}
#endif

#ifdef STAR_SHOOTING_ENABLED
vec3 _1ct5oj(vec3 _llxraj, float _bim3ym, float _etzrwc) {
_llxraj = normalize(_llxraj);
_llxraj = _d0i5i9(_llxraj, _etzrwc);

vec3 _8izj9y = vec3(0.0);
for (int i = 0; i < 3; i++) {
float _xy4mk0 = float(i) * 47.0;
float _3v0h8k = 15.0 + _02helh(_xy4mk0) * 20.0;
float t = mod(_bim3ym + _xy4mk0, _3v0h8k);

float _fkxviz = 0.5 + _02helh(_xy4mk0 + 10.0) * 1.0;
if (t > _fkxviz) continue;

float _tqnl3k = _02helh(_xy4mk0 + 20.0) * 6.28318;
float _37c6ge = 0.2 + _02helh(_xy4mk0 + 30.0) * 0.6;
vec3 _rducww = vec3(cos(_tqnl3k) * cos(_37c6ge), sin(_37c6ge), sin(_tqnl3k) * cos(_37c6ge));

float _tepzih = _02helh(_xy4mk0 + 40.0) * 6.28318;
vec3 _yor7k9 = normalize(vec3(cos(_tepzih), -0.3, sin(_tepzih)));

float _9lasr8 = 0.3 + _02helh(_xy4mk0 + 50.0) * 0.4;
vec3 _cfpe4s = normalize(_rducww + _yor7k9 * t * _9lasr8);

vec3 _2fsb5y = _llxraj - _cfpe4s;
float _9f57y8 = dot(_2fsb5y, _yor7k9);
float _j2p78c = length(_2fsb5y - _yor7k9 * _9f57y8);

float _xzuadt = 0.003;
float _ppxmoo = 0.08 * (1.0 - t / _fkxviz);

if (_j2p78c < _xzuadt && _9f57y8 > -_ppxmoo && _9f57y8 < 0.01) {
float _0v7t0i = (1.0 - _j2p78c / _xzuadt);
_0v7t0i *= smoothstep(-_ppxmoo, 0.0, _9f57y8);
_0v7t0i *= 1.0 - t / _fkxviz;
_0v7t0i *= STAR_SHOOTING_BRIGHTNESS;
_8izj9y += vec3(0.9, 0.95, 1.0) * _0v7t0i;
}
}
return _8izj9y;
}
#endif

#ifdef NIGHT_NEBULA_ENABLED
vec3 _i1wf82(vec3 _llxraj, float _bim3ym) {
vec3 d = normalize(_llxraj);
float _a9z6vr = NIGHT_NEBULA_SCALE * 2.0;
float _pnr1f3 = _bim3ym * NIGHT_NEBULA_SPEED;

vec3 p1 = d * _a9z6vr + vec3(_pnr1f3 * 0.4, _pnr1f3 * 0.15, 0.0);
vec3 p2 = d * _a9z6vr * 1.4 + vec3(31.7, 17.3, 5.1) + vec3(-_pnr1f3 * 0.25, _pnr1f3 * 0.35, 0.0);
vec3 p3 = d * _a9z6vr * 0.3 + vec3(-50.0, 25.0, 12.3) + _pnr1f3 * 0.08;

float _cotr1m    = _vx166i(p1, 4);
float _9lvmzq    = _vx166i(p2, 3);
float _o3riww = _vx166i(p3, 3);

float _q4j75g = smoothstep(0.28, 0.60, _cotr1m);
_q4j75g *= 0.55 + 0.45 * _9lvmzq;
_q4j75g  = max(_q4j75g, smoothstep(0.50, 0.80, _cotr1m) * 0.5);

float _3crd8e = smoothstep(-0.05, 0.18, d.y) * (1.0 - smoothstep(0.88, 1.00, d.y));
_q4j75g *= _3crd8e;

vec3 _2fg1w9 = vec3(NIGHT_NEBULA_R1, NIGHT_NEBULA_G1, NIGHT_NEBULA_B1);
vec3 _a3sws7 = vec3(NIGHT_NEBULA_R2, NIGHT_NEBULA_G2, NIGHT_NEBULA_B2);
vec3 _5lwty5 = mix(_2fg1w9, _a3sws7, smoothstep(0.3, 0.7, _o3riww));
_5lwty5 += vec3(0.5, 0.4, 0.8) * smoothstep(0.65, 0.85, _cotr1m) * 0.35;

return _5lwty5 * _q4j75g * NIGHT_NEBULA_INTENSITY;
}
#endif

#ifdef METEORS_ENABLED
vec3 _jw88u4(vec3 _llxraj, float _bim3ym, float _etzrwc) {
_llxraj = normalize(_llxraj);

vec3 _8izj9y = vec3(0.0);

for (int i = 0; i < 3; i++) {
float _kfem3e = float(i);
float _73va1t = 20.0 + _02helh(_kfem3e * 53.0 + 7.0) * 25.0;
float _w00hjk = floor((_bim3ym + _kfem3e * 137.0) / _73va1t);
float t = mod(_bim3ym + _kfem3e * 137.0, _73va1t);
float _fkxviz = 2.5 + _02helh(_kfem3e * 31.0 + 3.0) * 2.0;

if (t > _fkxviz) continue;
float _lcxm76 = t / _fkxviz;

float _qwg4zv = _kfem3e * 53.0 + _w00hjk * 137.0;

float _lti102 = _02helh(_qwg4zv + 20.0) * 6.28318;
float _ra294w = 0.52 + _02helh(_qwg4zv + 30.0) * 0.79;

float _9lasr8 = METEOR_SPEED * (0.8 + _02helh(_qwg4zv + 50.0) * 0.4);
float _m3flyw = _9lasr8 * 0.15;
float _jbaww9 = t * _m3flyw;
float _217mcn = min(_jbaww9, 0.8 * METEOR_TRAIL_LENGTH);

float _owsk82 = _lti102 + _jbaww9;
float _kseuil = _lti102 + max(_jbaww9 - _217mcn, 0.0);
float _tqim7m = _ra294w - _jbaww9 * 0.08;
float _cq2zr7 = _ra294w - max(_jbaww9 - _217mcn, 0.0) * 0.08;

vec3 _8mhfn2 = normalize(vec3(
cos(_owsk82) * cos(_tqim7m), sin(_tqim7m), sin(_owsk82) * cos(_tqim7m)
));
vec3 _khw5m9 = normalize(vec3(
cos(_kseuil) * cos(_cq2zr7), sin(_cq2zr7), sin(_kseuil) * cos(_cq2zr7)
));

vec3 _oytmcy = _khw5m9 - _8mhfn2;
float _zsqymj = dot(_oytmcy, _oytmcy);
float _d77yen = (_zsqymj > 0.0001) ? clamp(dot(_llxraj - _8mhfn2, _oytmcy) / _zsqymj, 0.0, 1.0) : 0.0;
vec3 _78ub6x = normalize(_8mhfn2 + _oytmcy * _d77yen);
float _xgn90b = acos(clamp(dot(_llxraj, _78ub6x), -1.0, 1.0));

float _11l8d6 = smoothstep(0.0, 0.02, _lcxm76);
float _t02w7g = 1.0 - smoothstep(0.8, 1.0, _lcxm76);
float _57tg2x = _11l8d6 * _t02w7g;

float _mnbc9v = METEOR_SIZE;

float _zl6qyr = acos(clamp(dot(_llxraj, _8mhfn2), -1.0, 1.0));
if (_zl6qyr < 0.06 * _mnbc9v) {
vec3 up = abs(_8mhfn2.y) < 0.99 ? vec3(0.0, 1.0, 0.0) : vec3(1.0, 0.0, 0.0);
vec3 _ktlaov = normalize(cross(_8mhfn2, up));
vec3 _ojhgm9 = cross(_8mhfn2, _ktlaov);

vec3 _ujl8u5 = _llxraj - _8mhfn2;
vec2 _ja8cqx = vec2(dot(_ujl8u5, _ktlaov), dot(_ujl8u5, _ojhgm9));

float _fmb5j5 = exp(-dot(_ja8cqx, _ja8cqx) / (0.000003 * _mnbc9v * _mnbc9v)) * 3.0;

float _jyu4ic = exp(-abs(_ja8cqx.x) / (0.0008 * _mnbc9v)) * exp(-_ja8cqx.y * _ja8cqx.y / (0.000004 * _mnbc9v * _mnbc9v));
float _1ejgbf = exp(-abs(_ja8cqx.y) / (0.0008 * _mnbc9v)) * exp(-_ja8cqx.x * _ja8cqx.x / (0.000004 * _mnbc9v * _mnbc9v));
float _dxeqa1 = (_jyu4ic + _1ejgbf) * 0.5;

_8izj9y += vec3(1.0, 0.98, 0.95) * (_fmb5j5 + _dxeqa1) * _57tg2x * METEOR_BRIGHTNESS;
}

if (_xgn90b < 0.04 * _mnbc9v && _d77yen < 0.5) {
float _qmnfct = 0.025 * _mnbc9v * (1.0 - _d77yen * 2.0);
float _jjyhed = exp(-_xgn90b * _xgn90b / (_qmnfct * _qmnfct * 0.5));
_jjyhed *= (1.0 - _d77yen * 2.0);
vec3 _kwqxts = vec3(METEOR_GLOW_R, METEOR_GLOW_G, METEOR_GLOW_B);
_8izj9y += _kwqxts * _jjyhed * 0.8 * _57tg2x * METEOR_BRIGHTNESS;
}

if (_xgn90b < 0.015 * _mnbc9v && _d77yen < 0.7) {
float _r75cb9 = 0.012 * _mnbc9v * (1.0 - _d77yen * 1.2);
float _cofhbo = exp(-_xgn90b * _xgn90b / (_r75cb9 * _r75cb9 * 0.3));
_cofhbo *= (1.0 - _d77yen * 1.43);

float _e30o2u = _d77yen * 2.0 + _02helh(_qwg4zv + 60.0) * 0.5;
vec3 _wied61;
_wied61.r = 0.5 + 0.5 * cos(6.28318 * (_e30o2u + 0.0));
_wied61.g = 0.5 + 0.5 * cos(6.28318 * (_e30o2u + 0.33));
_wied61.b = 0.5 + 0.5 * cos(6.28318 * (_e30o2u + 0.67));
_wied61 = mix(vec3(1.0), _wied61, 0.7);

_8izj9y += _wied61 * _cofhbo * 0.6 * _57tg2x * METEOR_BRIGHTNESS;
}

{
float _ech9w3 = 0.003 * _mnbc9v;
float _04dvp6 = exp(-_xgn90b * _xgn90b / (_ech9w3 * _ech9w3 * 0.5));
_04dvp6 *= (1.0 - _d77yen);
_8izj9y += vec3(0.7, 0.7, 0.75) * _04dvp6 * 0.4 * _57tg2x * METEOR_BRIGHTNESS;
}
}

return _8izj9y;
}
#endif

vec3 _5gqmwb(vec3 _hlgnmu, vec3 _st4awd, float _etzrwc, float _bim3ym, float _ae8sgm) {
float _huatah = fract(_etzrwc);
float _6tk9k5 = smoothstep(0.55, 0.60, _huatah) * (1.0 - smoothstep(0.94, 0.98, _huatah));
float blueHour = smoothstep(0.50, 0.52, _huatah) * (1.0 - smoothstep(0.55, 0.58, _huatah));
float _7mrf8h = 1.0 - smoothstep(0.15, 0.70, _ae8sgm);

#ifdef STARS_ENABLED
{
float _s06i18 = (_6tk9k5 + blueHour * 0.5) * _7mrf8h;
if (_s06i18 > 0.01 && _st4awd.y > -0.1) {
float _o6gbcn = _yv4dg3(_st4awd, _bim3ym, _etzrwc);
float _eo29pw = smoothstep(-0.1, 0.15, _st4awd.y);
_hlgnmu += vec3(_o6gbcn) * _s06i18 * _eo29pw;

#ifdef STAR_SHOOTING_ENABLED
if (_6tk9k5 > 0.5) {
_hlgnmu += _1ct5oj(_st4awd, _bim3ym, _etzrwc) * _eo29pw * _7mrf8h;
}
#endif
}
}
#endif

#ifdef NIGHT_NEBULA_ENABLED
{
float _k6cd4q = (_6tk9k5 + blueHour * 0.4) * _7mrf8h;
if (_k6cd4q > 0.01) {
_hlgnmu += _i1wf82(_st4awd, _bim3ym) * _k6cd4q;
}
}
#endif

#ifdef METEORS_ENABLED
{
float _qvw15c = (_6tk9k5 + blueHour * 0.3) * _7mrf8h;
if (_qvw15c > 0.01 && _st4awd.y > -0.05) {
vec3 _7xrwoh = _jw88u4(_st4awd, _bim3ym, _etzrwc);
float _ivddgy = smoothstep(-0.05, 0.15, _st4awd.y);
_hlgnmu += _7xrwoh * _qvw15c * _ivddgy;
}
}
#endif

return _hlgnmu;
}

#endif
