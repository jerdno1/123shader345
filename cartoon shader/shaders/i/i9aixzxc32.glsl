#ifdef NIGHT_NEBULA_ENABLED

float _yuyzge(vec3 p) {
p = fract(p * 0.1031);
p += dot(p, p.zyx + 31.32);
return fract((p.x + p.y) * p.z);
}

float _lpglwu(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);
f = f * f * (3.0 - 2.0 * f);

float a = _yuyzge(i);
float b = _yuyzge(i + vec3(1,0,0));
float c = _yuyzge(i + vec3(0,1,0));
float d = _yuyzge(i + vec3(1,1,0));
float e = _yuyzge(i + vec3(0,0,1));
float g = _yuyzge(i + vec3(1,0,1));
float h = _yuyzge(i + vec3(0,1,1));
float k = _yuyzge(i + vec3(1,1,1));

return mix(mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
mix(mix(e, g, f.x), mix(h, k, f.x), f.y), f.z);
}

float _e6nddu(vec3 p, int _c5iapm) {
float v = 0.0, a = 0.5;
for (int i = 0; i < _c5iapm; i++) {
v += a * _lpglwu(p);
p *= 2.0; a *= 0.5;
}
return v;
}

vec3 _xy5uo8(vec3 _llxraj, float _bim3ym) {
vec3 d = normalize(_llxraj);
float _a9z6vr = NIGHT_NEBULA_SCALE * 2.0;
float _pnr1f3 = _bim3ym * NIGHT_NEBULA_SPEED;

vec3 p1 = d * _a9z6vr + vec3(_pnr1f3 * 0.4, _pnr1f3 * 0.15, 0.0);
vec3 p2 = d * _a9z6vr * 1.4 + vec3(31.7, 17.3, 5.1) + vec3(-_pnr1f3 * 0.25, _pnr1f3 * 0.35, 0.0);
vec3 p3 = d * _a9z6vr * 0.3 + vec3(-50.0, 25.0, 12.3) + _pnr1f3 * 0.08;

float _cotr1m    = _e6nddu(p1, 4);
float _9lvmzq    = _e6nddu(p2, 3);
float _o3riww = _e6nddu(p3, 3);

float _q4j75g = smoothstep(0.28, 0.60, _cotr1m);
_q4j75g *= 0.55 + 0.45 * _9lvmzq;
_q4j75g  = max(_q4j75g, smoothstep(0.50, 0.80, _cotr1m) * 0.5);

float _3crd8e = smoothstep(-0.05, 0.18, d.y)
* (1.0 - smoothstep(0.88, 1.00, d.y));
_q4j75g *= _3crd8e;

vec3 _2fg1w9 = vec3(NIGHT_NEBULA_R1, NIGHT_NEBULA_G1, NIGHT_NEBULA_B1);
vec3 _a3sws7 = vec3(NIGHT_NEBULA_R2, NIGHT_NEBULA_G2, NIGHT_NEBULA_B2);
vec3 _5lwty5 = mix(_2fg1w9, _a3sws7, smoothstep(0.3, 0.7, _o3riww));
_5lwty5 += vec3(0.5, 0.4, 0.8) * smoothstep(0.65, 0.85, _cotr1m) * 0.35;

return _5lwty5 * _q4j75g * NIGHT_NEBULA_INTENSITY;
}
#endif

#ifdef METEORS_ENABLED
vec3 _7qubiq(vec3 _llxraj, float _bim3ym) {
_llxraj = normalize(_llxraj);

vec3 _8izj9y = vec3(0.0);

for (int i = 0; i < 3; i++) {
float _kfem3e = float(i);
float _73va1t = 20.0 + _ewpw6c(_kfem3e * 53.0 + 7.0) * 25.0;
float _w00hjk = floor((_bim3ym + _kfem3e * 137.0) / _73va1t);
float t = mod(_bim3ym + _kfem3e * 137.0, _73va1t);
float _fkxviz = 2.5 + _ewpw6c(_kfem3e * 31.0 + 3.0) * 2.0;

if (t > _fkxviz) continue;
float _lcxm76 = t / _fkxviz;

float _qwg4zv = _kfem3e * 53.0 + _w00hjk * 137.0;

float _lti102 = _ewpw6c(_qwg4zv + 20.0) * 6.28318;
float _ra294w = 0.52 + _ewpw6c(_qwg4zv + 30.0) * 0.79;

float _9lasr8 = METEOR_SPEED * (0.8 + _ewpw6c(_qwg4zv + 50.0) * 0.4);
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
vec3 up = abs(_8mhfn2.y) < 0.99 ? vec3(0,1,0) : vec3(1,0,0);
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

float _e30o2u = _d77yen * 2.0 + _ewpw6c(_qwg4zv + 60.0) * 0.5;
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
