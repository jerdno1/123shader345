#ifdef END_SKY_ENABLED

#ifdef END_EVENT_ENABLED
#include "/include/end_event.glsl"
#endif

float _blupwu(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * 0.1031);
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.x + p3.y) * p3.z);
}

vec2 _rjc8fr(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.xx + p3.yz) * p3.zy);
}

float _l330c7(vec3 p) {
p = fract(p * 0.1031);
p += dot(p, p.zyx + 31.32);
return fract((p.x + p.y) * p.z);
}

float _2kw178(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);
f = f * f * (3.0 - 2.0 * f);

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

float _00ehr5(vec3 p, int _c5iapm) {
float _ino0s9 = 0.0;
float _2qekwd = 0.5;
float _a4mjmv = 1.0;
for (int i = 0; i < _c5iapm; i++) {
_ino0s9 += _2qekwd * _2kw178(p * _a4mjmv);
_a4mjmv *= 2.0;
_2qekwd *= 0.5;
}
return _ino0s9;
}

float _f4sbat(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);
float _tm2ehs = 1.0;
for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
for (int z = -1; z <= 1; z++) {
vec3 _kthqft = vec3(float(x), float(y), float(z));
vec3 _j5jwle = vec3(_l330c7(i + _kthqft + vec3(0.0)),
_l330c7(i + _kthqft + vec3(100.0)),
_l330c7(i + _kthqft + vec3(200.0)));
float _t25r5m = length(_kthqft + _j5jwle - f);
_tm2ehs = min(_tm2ehs, _t25r5m);
}
}
}
return _tm2ehs;
}

vec2 _szu92b(vec3 d) {
vec3 a = abs(d);
if (a.x >= a.y && a.x >= a.z) return d.yz / a.x + vec2(0.0, 2.0) * sign(d.x);
else if (a.y >= a.z) return d.xz / a.y + vec2(4.0, 0.0) * sign(d.y);
else return d.xy / a.z + vec2(0.0, 6.0) * sign(d.z);
}

vec3 _yj2f1e(vec3 _h8ie4b, vec3 _3p73xa, vec3 _61es6w, float height, float _nklv5c, float _s04wi4) {
float _pczne8 = clamp((height - 0.0) / _nklv5c, 0.0, 1.0);
_pczne8 = _pczne8 * _pczne8 * _pczne8 * (_pczne8 * (_pczne8 * 6.0 - 15.0) + 10.0);
float _hkkw78 = clamp((height - _nklv5c) / (_s04wi4 - _nklv5c), 0.0, 1.0);
_hkkw78 = _hkkw78 * _hkkw78 * _hkkw78 * (_hkkw78 * (_hkkw78 * 6.0 - 15.0) + 10.0);
vec3 _8izj9y = mix(_h8ie4b, _3p73xa, _pczne8);
_8izj9y = mix(_8izj9y, _61es6w, _hkkw78);
return _8izj9y;
}

#ifdef END_STARS_ENABLED
vec3 _6ux19b(vec3 _llxraj, float _bim3ym, float suctionWarp) {
_llxraj = normalize(_llxraj);

if (suctionWarp > 0.001) {
float _p6ecu2 = suctionWarp * suctionWarp * 0.85;
vec3 _jrbx5b = normalize(vec3(_llxraj.x, 0.0, _llxraj.z));
float _aauoc1 = clamp(_llxraj.y, 0.0, 1.0);
float _sjj9bz = _p6ecu2 * _aauoc1;
_llxraj = normalize(mix(_llxraj, _jrbx5b, _sjj9bz));
}
vec2 _ufcu6o = _szu92b(_llxraj) * STAR_SCALE;
vec2 _h908e6 = floor(_ufcu6o);
vec2 _pjm5wu = fract(_ufcu6o);
vec3 _8izj9y = vec3(0.0);

for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 nc = _h908e6 + vec2(float(x), float(y));
float _2xxeoy = _blupwu(nc);
if (_2xxeoy > END_STAR_DENSITY) continue;

vec2 sp = _rjc8fr(nc) * 0.6 + 0.2;
vec2 d = _pjm5wu - vec2(float(x), float(y)) - sp;
float _t25r5m = length(d);
float _3j5sp9 = 0.4 + _blupwu(nc + 500.0) * 0.6;
float _j1b98s = _blupwu(nc + 700.0) * 6.28318;
float _pcghs4 = 0.5 + _blupwu(nc + 800.0) * 2.0;
float _gg05ax = 0.7 + 0.3 * sin(_bim3ym * _pcghs4 + _j1b98s);
float _ulytmb = _3j5sp9 * _gg05ax * END_STAR_BRIGHTNESS;
float _nr5rfo = STAR_SIZE * (0.5 + _blupwu(nc + 400.0) * 0.5);
float s = 1.0 - smoothstep(0.0, _nr5rfo, _t25r5m);

vec3 _w1xm0p = vec3(1.0);
if (END_STAR_COLOR_SHIFT > 0.0) {
float _49znj4 = _blupwu(nc + 1000.0);
vec3 tint;
if (_49znj4 < 0.3) tint = vec3(0.7, 0.5, 1.0);
else if (_49znj4 < 0.55) tint = vec3(0.4, 0.7, 1.0);
else if (_49znj4 < 0.75) tint = vec3(0.3, 0.9, 0.8);
else tint = vec3(1.0, 0.95, 0.9);
_w1xm0p = mix(vec3(1.0), tint, END_STAR_COLOR_SHIFT);
}
_8izj9y = max(_8izj9y, _w1xm0p * s * _ulytmb);
}
}
return _8izj9y;
}
#endif

#ifdef END_NEBULA_ENABLED
vec3 _fbevfo(vec3 _llxraj, float _bim3ym) {

vec3 p = normalize(_llxraj) * END_NEBULA_SCALE;
float _pnr1f3 = _bim3ym * END_NEBULA_SPEED;
vec3 p1 = p + vec3(_pnr1f3, _pnr1f3 * 0.3, _pnr1f3 * 0.1);
vec3 p2 = p + vec3(-_pnr1f3 * 0.7, _pnr1f3 * 0.5, -_pnr1f3 * 0.2);

float _wxhfvt = _00ehr5(p1 * 0.6, 5);
float _u26ghr = _00ehr5(p2 * 0.8 + vec3(50.0, 25.0, 10.0), 4);
float _0nf46u = _00ehr5(p1 * 1.2 + vec3(100.0, 50.0, 30.0), 4);
float _o3riww = _00ehr5(p * 0.4 + vec3(-30.0, 80.0, 40.0) + _pnr1f3 * 0.3, 3);
float v = _f4sbat(p1 * 2.0);

float _s0a22j = smoothstep(0.20, 0.55, _wxhfvt);
_s0a22j *= 0.5 + 0.5 * smoothstep(0.15, 0.50, _u26ghr);
_s0a22j *= 0.6 + 0.4 * smoothstep(0.25, 0.60, _0nf46u);
_s0a22j *= 0.6 + 0.4 * (1.0 - smoothstep(0.0, 0.5, v));
float _x9g3a3 = smoothstep(0.50, 0.80, _wxhfvt) * 0.5;
_s0a22j += _x9g3a3;

vec3 _8tqn4j = vec3(END_NEBULA_R1, END_NEBULA_G1, END_NEBULA_B1);
vec3 _ae2wjm = vec3(END_NEBULA_R2, END_NEBULA_G2, END_NEBULA_B2);
float _0dw0rl = smoothstep(0.3, 0.7, _o3riww);
vec3 _5lwty5 = mix(_8tqn4j, _ae2wjm, _0dw0rl);
vec3 _fyiobc = vec3(0.7, 0.6, 0.9) * smoothstep(0.70, 0.95, _wxhfvt) * 0.3;

return (_5lwty5 * _s0a22j + _fyiobc) * END_NEBULA_INTENSITY;
}
#endif

#ifdef END_AURORA_ENABLED
vec3 _zuvn42(vec3 _llxraj, float _bim3ym) {
float _ra294w = _llxraj.y;
if (_ra294w < 0.02) return vec3(0.0);

float _lejoh7 = smoothstep(0.02, max(END_AURORA_HEIGHT * 0.3, 0.0201), _ra294w)
* (1.0 - smoothstep(END_AURORA_HEIGHT * 0.5, END_AURORA_HEIGHT + 0.3, _ra294w));
float _huatah = atan(_llxraj.z, _llxraj.x);

float _fi57z9 = sin(_huatah * 3.0 + _bim3ym * END_AURORA_SPEED * 0.7) * 0.5 + 0.5;
float _0it7cy = sin(_huatah * 5.0 - _bim3ym * END_AURORA_SPEED * 1.1 + 2.0) * 0.5 + 0.5;
float _2xuuow = sin(_huatah * 7.0 + _bim3ym * END_AURORA_SPEED * 0.4 + 4.5) * 0.5 + 0.5;
float _nj8hqt = sin(_huatah * 2.0 + _bim3ym * END_AURORA_SPEED * 0.9 + 1.0) * 0.5 + 0.5;

float _akoorp = _2kw178(vec3(_llxraj.xz * 2.0, _bim3ym * END_AURORA_SPEED * 0.3));
float _8ystdl = sin(_ra294w * 12.0 + _akoorp * 4.0 + _bim3ym * END_AURORA_SPEED) * 0.5 + 0.5;
float _yyc6b6 = _2kw178(vec3(_llxraj.xz * 4.0 + _bim3ym * 0.05, _ra294w * 8.0));
_yyc6b6 = smoothstep(0.1, 0.6, _yyc6b6);

float _hygsf5 = _fi57z9 * _0it7cy * 0.5 + _2xuuow * 0.3 + _nj8hqt * 0.2;
_hygsf5 *= _8ystdl;
_hygsf5 *= 0.6 + 0.4 * _yyc6b6;
_hygsf5 = pow(_hygsf5, 1.5);

vec3 _8tqn4j = vec3(END_AURORA_R1, END_AURORA_G1, END_AURORA_B1);
vec3 _ae2wjm = vec3(END_AURORA_R2, END_AURORA_G2, END_AURORA_B2);
float _d9tmy2 = sin(_huatah * 2.0 + _bim3ym * END_AURORA_SPEED * 0.2) * 0.5 + 0.5;
vec3 _l1mtos = mix(_8tqn4j, _ae2wjm, _d9tmy2);

return _l1mtos * _hygsf5 * _lejoh7 * END_AURORA_INTENSITY;
}
#endif

#ifdef END_VOID_PARTICLES_ENABLED
vec3 _i7ycxr(vec3 _llxraj, float _bim3ym, float suctionWarp) {
_llxraj = normalize(_llxraj);

if (suctionWarp > 0.001) {
float _p6ecu2 = suctionWarp * suctionWarp * 0.85;
vec3 _jrbx5b = normalize(vec3(_llxraj.x, 0.0, _llxraj.z));
float _aauoc1 = clamp(_llxraj.y, 0.0, 1.0);
float _sjj9bz = _p6ecu2 * _aauoc1;
_llxraj = normalize(mix(_llxraj, _jrbx5b, _sjj9bz));
}
vec2 _7szgzz = _szu92b(_llxraj) * 30.0;
vec2 _h908e6 = floor(_7szgzz);
vec2 _pjm5wu = fract(_7szgzz);
vec3 _8izj9y = vec3(0.0);

for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 nc = _h908e6 + vec2(float(x), float(y));
float _2xxeoy = _blupwu(nc + vec2(200.0, 300.0));
if (_2xxeoy > END_VOID_PARTICLE_DENSITY) continue;

vec2 sp = _rjc8fr(nc + vec2(200.0, 300.0)) * 0.6 + 0.2;
float _vx5wz6 = _blupwu(nc + vec2(500.0, 600.0)) * 6.28318;
float _9e8wbp = 0.3 + _blupwu(nc + vec2(700.0, 800.0)) * 1.5;
float _zyuid3 = 0.5 + 0.5 * sin(_bim3ym * _9e8wbp + _vx5wz6);
float _31786g = sin(_bim3ym * 0.1 + _vx5wz6) * 0.02;
float _whh2fa = cos(_bim3ym * 0.08 + _vx5wz6 * 1.3) * 0.02;

vec2 d = _pjm5wu - vec2(float(x), float(y)) - sp + vec2(_31786g, _whh2fa);
float _t25r5m = length(d);
float _ogil6l = 1.0 - smoothstep(0.0, 0.04, _t25r5m);
_ogil6l *= _zyuid3;

float _lotpgi = _blupwu(nc + vec2(900.0, 100.0));
vec3 _in6bp0 = mix(vec3(0.6, 0.2, 1.0), vec3(0.2, 0.8, 0.9), _lotpgi);
_8izj9y += _in6bp0 * _ogil6l * END_VOID_PARTICLE_BRIGHTNESS * 0.3;
}
}
return _8izj9y;
}
#endif

#ifdef END_ASTEROIDS_ENABLED

vec3 _8oxdzm(vec3 _llxraj, float _bim3ym) {
_llxraj = normalize(_llxraj);
vec3 _8izj9y = vec3(0.0);

int _sp081m = 12;
for (int _kfem3e = 0; _kfem3e < _sp081m; _kfem3e++) {
float _rddjnw = float(_kfem3e);

float _xtved4 = 8.0 + _blupwu(vec2(_rddjnw, 0.0) + vec2(7000.0)) * 12.0;
float _kdhuii = 0.6 + _blupwu(vec2(_rddjnw, 1.0) + vec2(7100.0)) * 0.8;
float _tq26wd = _blupwu(vec2(_rddjnw, 2.0) + vec2(7200.0)) * 200.0;

float _3v0h8k = mod(_bim3ym * END_ASTEROID_SPEED + _tq26wd, _xtved4);

if (_3v0h8k > _kdhuii) continue;

float _payivd = _3v0h8k / _kdhuii;

float _j1yqts = smoothstep(0.0, 0.1, _payivd) * (1.0 - smoothstep(0.85, 1.0, _payivd));
if (_j1yqts < 0.001) continue;

float _ovvtju = _blupwu(vec2(_rddjnw, 3.0) + vec2(7300.0)) * 6.28318;
float _kybwom = _blupwu(vec2(_rddjnw, 4.0) + vec2(7400.0)) * 2.8 - 0.4;
vec3 _bhb4le = normalize(vec3(cos(_ovvtju) * cos(_kybwom), sin(_kybwom), sin(_ovvtju) * cos(_kybwom)));

float _tepzih = _blupwu(vec2(_rddjnw, 5.0) + vec2(7500.0)) * 6.28318;
float _v7clfk = (_blupwu(vec2(_rddjnw, 6.0) + vec2(7600.0)) - 0.5) * 1.0;
vec3 _yor7k9 = normalize(vec3(cos(_tepzih), _v7clfk, sin(_tepzih)));

float _9lasr8 = 0.3 + _blupwu(vec2(_rddjnw, 7.0) + vec2(7700.0)) * 0.4;
vec3 _cfpe4s = _bhb4le + _yor7k9 * (_payivd - 0.5) * _9lasr8;

float _k622bg = dot(_llxraj, normalize(_cfpe4s));
float _xgn90b = acos(clamp(_k622bg, -1.0, 1.0));

if (_xgn90b > END_ASTEROID_LENGTH * 1.5) continue;

vec3 _g1zqhs = normalize(_yor7k9 - _llxraj * dot(_yor7k9, _llxraj));
float _9f57y8 = dot(_llxraj - normalize(_cfpe4s), _g1zqhs);
float _4mrskj = length(_llxraj - normalize(_cfpe4s) - _g1zqhs * _9f57y8);

float _aqgl8g = END_ASTEROID_LENGTH * (0.4 + _blupwu(vec2(_rddjnw, 8.0) + vec2(7800.0)) * 0.6);
float _vc3ydm = END_ASTEROID_THICKNESS;

float _gx3em2 = 1.0 - smoothstep(_aqgl8g * 0.3, _aqgl8g, abs(_9f57y8));
float _uwmz7f = 1.0 - smoothstep(_vc3ydm * 0.15, _vc3ydm, _4mrskj);
float _5prqct = _gx3em2 * _uwmz7f;

float _b2vj2a = smoothstep(-_aqgl8g, _aqgl8g * 0.2, _9f57y8);
_5prqct *= _b2vj2a * _j1yqts;

float _49znj4 = _blupwu(vec2(_rddjnw, 9.0) + vec2(7900.0));
vec3 _dugviw;
if (_49znj4 < 0.3) _dugviw = vec3(0.6, 0.3, 1.0);
else if (_49znj4 < 0.55) _dugviw = vec3(0.3, 0.7, 1.0);
else if (_49znj4 < 0.8) _dugviw = vec3(0.8, 0.75, 1.0);
else _dugviw = vec3(1.0, 0.95, 1.0);

_8izj9y += _dugviw * _5prqct * END_ASTEROID_BRIGHTNESS;
}

return _8izj9y;
}
#endif

#include "/include/end_void_clouds.glsl"

#ifdef END_ENDER_PARTICLES_ENABLED

vec3 _djokld(vec3 viewDir, float _bim3ym, vec3 _zflroq, float _0nlczg) {
vec3 _8izj9y = vec3(0.0);
float _cunixp = min(_0nlczg, END_ENDER_PARTICLE_RANGE);

float _45957t = END_ENDER_PARTICLE_SPACING;
float _iaxcyf = 1.0 / _45957t;
float _gduy5n = _45957t * 0.7;
float _xoryyp = END_ENDER_PARTICLE_SIZE;
float _jmqxvc = _xoryyp * 4.5;

vec3 _bc6cud = normalize(cross(viewDir, vec3(0.0, 1.0, 0.0)));
vec3 up = cross(_bc6cud, viewDir);

float _izh8vx = fract(dot(gl_FragCoord.xy, vec2(0.7548776662, 0.5698402909))) * _gduy5n;

vec3 _grfrs9 = vec3(-999.0);

for (int i = 0; i < 16; i++) {
float t = 6.0 + _izh8vx + float(i) * _gduy5n;
if (t > _cunixp) break;

vec3 _wb02o7 = _zflroq + viewDir * t;
vec3 _xvt7i1 = floor(_wb02o7 * _iaxcyf);

if (_xvt7i1 == _grfrs9) continue;
_grfrs9 = _xvt7i1;

float _2xxeoy = _l330c7(_xvt7i1 + vec3(5000.0));
if (_2xxeoy > END_ENDER_PARTICLE_DENSITY) continue;

vec3 _qr6flz = (_xvt7i1 + vec3(
_l330c7(_xvt7i1 + vec3(100.0)),
_l330c7(_xvt7i1 + vec3(200.0)),
_l330c7(_xvt7i1 + vec3(300.0))
)) * _45957t;

float _tq26wd = _l330c7(_xvt7i1 + vec3(400.0)) * 6.28318;
float _msfm3y = 0.3 + _l330c7(_xvt7i1 + vec3(500.0)) * 0.5;
_qr6flz.x += sin(_bim3ym * _msfm3y * 0.4 + _tq26wd) * 0.8;
_qr6flz.y += sin(_bim3ym * _msfm3y * 0.3 + _tq26wd * 1.3) * 1.2
+ sin(_bim3ym * 0.05 + _tq26wd * 2.7) * _45957t * 0.4;
_qr6flz.z += cos(_bim3ym * _msfm3y * 0.35 + _tq26wd * 0.7) * 0.8;

vec3 _w9wiim = _qr6flz - _zflroq;
float _c3klvl = dot(_w9wiim, viewDir);
if (_c3klvl < 6.0 || _c3klvl > _cunixp) continue;

vec3 _5b899k = _zflroq + viewDir * _c3klvl;
vec3 _ja8cqx = _qr6flz - _5b899k;

float ox = abs(dot(_ja8cqx, _bc6cud));
float oy = abs(dot(_ja8cqx, up));
float _y24hgx = max(ox, oy);
if (_y24hgx > _jmqxvc) continue;

float _x4r05s = _l330c7(_xvt7i1 + vec3(800.0));
float _cfucov = _x4r05s < 0.2 ? (2.0 + _x4r05s * 5.0) : (0.5 + _x4r05s * 0.875);

float _fmb5j5 = step(_y24hgx, _xoryyp);
float _agbnn2 = _xoryyp * (3.0 + _cfucov * 1.5);
float _gu3jb6 = 1.0 - smoothstep(_xoryyp * 0.5, _agbnn2, _y24hgx);
_gu3jb6 *= _gu3jb6;
float _qg7v6t = _fmb5j5 + _gu3jb6 * 0.4 * _cfucov;
if (_qg7v6t < 0.001) continue;

float _zyuid3 = 0.5 + 0.5 * sin(_bim3ym * (1.0 + _l330c7(_xvt7i1 + vec3(600.0))) + _tq26wd);

float _36zwff = (1.0 - smoothstep(_cunixp * 0.3, _cunixp, _c3klvl))
* smoothstep(6.0, 12.0, _c3klvl);

float _lotpgi = _l330c7(_xvt7i1 + vec3(700.0));
vec3 _in6bp0;
if (_lotpgi < 0.4) _in6bp0 = vec3(0.6, 0.15, 1.0);
else if (_lotpgi < 0.7) _in6bp0 = vec3(0.9, 0.2, 0.8);
else if (_lotpgi < 0.85) _in6bp0 = vec3(0.3, 0.5, 1.0);
else _in6bp0 = vec3(0.5, 0.8, 1.0);

_8izj9y += _in6bp0 * (_zyuid3 * _36zwff * END_ENDER_PARTICLE_BRIGHTNESS * _cfucov * _qg7v6t);
}

return _8izj9y;
}
#endif

#ifdef END_RINGS_ENABLED

vec3 _gj1nsb(vec3 _llxraj, float _bim3ym, vec3 _zflroq, float _cunixp) {
_llxraj = normalize(_llxraj);
vec3 _x2q5fe = vec3(END_RINGS_R, END_RINGS_G, END_RINGS_B);
vec3 _8izj9y = vec3(0.0);

vec3 _w75obr = vec3(0.0, 64.0, 0.0);
float _vzlrlg = END_RINGS_DEPTH * 0.5;

for (int i = 0; i < END_RINGS_COUNT; i++) {
float fi = float(i);

float _p4zsjl = END_RINGS_INNER + END_RINGS_WIDTH * 0.5 + fi * (END_RINGS_WIDTH + 20.0);

float _p0j08c = _bim3ym * END_RINGS_SPEED * (0.8 + fi * 0.2) + fi * 2.094;

float _9hx9pl = 0.3927 + fi * 0.10;
float _445ceo = _9hx9pl * cos(_p0j08c);

vec3 _b5hwgt = normalize(vec3(sin(_445ceo), cos(_445ceo), 0.0));
float cO = cos(_p0j08c);
float sO = sin(_p0j08c);
vec3 _b4bg8y = vec3(
_b5hwgt.x * cO,
_b5hwgt.y,
_b5hwgt.x * sO
);

float _sfl87p = _p4zsjl + _vzlrlg * 2.0;
vec3 _qn04ly = _zflroq - _w75obr;
float b = dot(_qn04ly, _llxraj);
float c = dot(_qn04ly, _qn04ly) - _sfl87p * _sfl87p;
float _re7w67 = b * b - c;
if (_re7w67 < 0.0) continue;
float _xzu4ps = sqrt(_re7w67);
float _pxvs4x = max(-b - _xzu4ps, 0.0);
float _l16jxm = min(-b + _xzu4ps, _cunixp);
if (_pxvs4x >= _l16jxm) continue;

float _ua039w = 0.0;
float _gduy5n = (_l16jxm - _pxvs4x) / 32.0;
float _izh8vx = fract(dot(gl_FragCoord.xy, vec2(0.7548776662, 0.5698402909))) * _gduy5n;

for (int s = 0; s < 32; s++) {
float t = _pxvs4x + _izh8vx + float(s) * _gduy5n;
if (t > _l16jxm) break;

vec3 p = _zflroq + _llxraj * t - _w75obr;

float _ii5k91 = dot(p, _b4bg8y);
vec3 _45sia6 = p - _b4bg8y * _ii5k91;
float _rcnur5 = length(_45sia6);
float _qwlmrb = _rcnur5 - _p4zsjl;
float d = length(vec2(_qwlmrb, _ii5k91));

float _3tqs27 = 1.0 - smoothstep(0.0, _vzlrlg * 2.0, d);
_3tqs27 *= _3tqs27;

_ua039w += _3tqs27 * _gduy5n;
}

if (_ua039w < 0.001) continue;

float _l2ddu3 = 1.0 - exp(-_ua039w * 0.25);

float _36zwff = 1.0 - smoothstep(500.0, 3000.0, (_pxvs4x + _l16jxm) * 0.5);

vec3 _y2w96t = _x2q5fe;
if (i == 1) _y2w96t = mix(_x2q5fe, vec3(0.3, 0.5, 1.0), 0.25);
if (i == 2) _y2w96t = mix(_x2q5fe, vec3(0.6, 0.2, 0.9), 0.25);

_8izj9y += _y2w96t * _l2ddu3 * _36zwff * END_RINGS_BRIGHTNESS;
}

return _8izj9y;
}
#endif

#include "/include/end_vortex.glsl"

#ifdef END_EVENT_ENABLED
vec3 _s9f8xh(vec3 _llxraj, float bangProgress, float bangFlash) {
if (bangFlash < 0.001 && bangProgress <= 0.0) return vec3(0.0);

vec3 _8izj9y = vec3(0.0);

float _vic1om = max(_llxraj.y, 0.0);
float _m9o54d = smoothstep(0.0, 0.8, _vic1om) * bangFlash;
_8izj9y += vec3(0.9, 0.7, 1.0) * _m9o54d * 4.0;

if (bangProgress > 0.0 && bangProgress < 1.0) {
float _snrjzm = acos(clamp(_llxraj.y, -1.0, 1.0));
for (int i = 0; i < 3; i++) {
float fi = float(i);
float _gccdbu = fi * 0.08;
float _9rq3ql = clamp((bangProgress - _gccdbu) / max(1.0 - _gccdbu, 0.01), 0.0, 1.0);

float _rai7x2 = pow(_9rq3ql, 0.4);
float _bdc3u0 = _rai7x2 * 3.14159;

float _24r1oq = abs(_snrjzm - _bdc3u0);
float _mt2t95 = 0.04 + fi * 0.01;
float _y89xub = 1.0 - smoothstep(_mt2t95 * 0.15, _mt2t95, _24r1oq);
float _kq26w8 = (1.0 - _9rq3ql) * (1.0 - fi * 0.2);

vec3 _tha7k5 = mix(vec3(1.0, 0.9, 1.0), vec3(0.5, 0.3, 1.0), fi * 0.3);
_8izj9y += _tha7k5 * _y89xub * _kq26w8 * 2.5;
}
}

return _8izj9y;
}
#endif

vec3 _hijiov(vec3 _st4awd, float _bim3ym, vec3 _zflroq) {
float height = max(_st4awd.y, 0.0);

#ifdef END_EVENT_ENABLED
EndEvent event = getEndEvent(_bim3ym);

vec3 _i93oyq = _st4awd;
if (event.suctionWarp > 0.001) {
float _p6ecu2 = event.suctionWarp * event.suctionWarp * 0.85;

vec3 _7np7q4 = normalize(vec3(_st4awd.x, 0.0, _st4awd.z));

float _aauoc1 = clamp(_st4awd.y, 0.0, 1.0);
float _sjj9bz = _p6ecu2 * _aauoc1;
_i93oyq = normalize(mix(_st4awd, _7np7q4, _sjj9bz));
}
#else
vec3 _i93oyq = _st4awd;
#endif

vec3 _xyezyl = vec3(END_SKY_HORIZON_R, END_SKY_HORIZON_G, END_SKY_HORIZON_B);
vec3 _gbifj2 = vec3(END_SKY_MID_R, END_SKY_MID_G, END_SKY_MID_B);
vec3 _riel36 = vec3(END_SKY_ZENITH_R, END_SKY_ZENITH_G, END_SKY_ZENITH_B);

vec3 _od2x3w = _yj2f1e(_xyezyl, _gbifj2, _riel36, height, 0.25, 0.65);

if (_st4awd.y < 0.0) {
float _w35u7s = 1.0 - smoothstep(-0.4, 0.0, _st4awd.y);
#ifdef END_FOG_ENABLED
vec3 _2rme2p = vec3(END_FOG_R, END_FOG_G, END_FOG_B);
#else
vec3 _2rme2p = _xyezyl * 0.3;
#endif
_od2x3w = mix(_xyezyl, _2rme2p, _w35u7s);
}

_od2x3w *= END_SKY_BRIGHTNESS;

#ifdef END_EVENT_ENABLED
_od2x3w *= (1.0 - event.skyDarkness);
#endif

#ifdef END_STARS_ENABLED
{
#ifdef END_EVENT_ENABLED
vec3 _o6gbcn = _6ux19b(_i93oyq, _bim3ym, event.suctionWarp);
_od2x3w += _o6gbcn * event.effectsFade;
#else
_od2x3w += _6ux19b(_st4awd, _bim3ym, 0.0);
#endif
}
#endif
#ifdef END_NEBULA_ENABLED
{
#ifdef END_EVENT_ENABLED
_od2x3w += _fbevfo(_i93oyq, _bim3ym) * event.effectsFade;
#else
_od2x3w += _fbevfo(_st4awd, _bim3ym);
#endif
}
#endif
#ifdef END_AURORA_ENABLED
{
#ifdef END_EVENT_ENABLED
_od2x3w += _zuvn42(_i93oyq, _bim3ym) * event.effectsFade;
#else
_od2x3w += _zuvn42(_st4awd, _bim3ym);
#endif
}
#endif
#ifdef END_VOID_PARTICLES_ENABLED
{
#ifdef END_EVENT_ENABLED
_od2x3w += _i7ycxr(_i93oyq, _bim3ym, event.suctionWarp) * event.effectsFade;
#else
_od2x3w += _i7ycxr(_st4awd, _bim3ym, 0.0);
#endif
}
#endif
#ifdef END_VOID_CLOUDS_ENABLED
{
#ifdef END_EVENT_ENABLED
vec4 _u9na24 = _m2f00k(_st4awd, event.cloudTime, _bim3ym, _zflroq, 10000.0, event.suctionWarp);
#else
vec4 _u9na24 = _m2f00k(_st4awd, _bim3ym, _bim3ym, _zflroq, 10000.0, 0.0);
#endif
if (_u9na24.a > 0.001) {
vec3 _8b6kmv = _u9na24.rgb / _u9na24.a;
#ifdef END_EVENT_ENABLED
float _xszwck = _u9na24.a * event.effectsFade;
#else
float _xszwck = _u9na24.a;
#endif
_od2x3w = mix(_od2x3w, _8b6kmv, _xszwck);
}
}
#endif
#ifdef END_ASTEROIDS_ENABLED
{
#ifdef END_EVENT_ENABLED
_od2x3w += _8oxdzm(_i93oyq, _bim3ym) * event.effectsFade;
#else
_od2x3w += _8oxdzm(_st4awd, _bim3ym);
#endif
}
#endif
#ifdef END_VORTEX_ENABLED
{
#ifdef END_EVENT_ENABLED
_od2x3w += _r8l9mr(_st4awd, event.vortexTime, _bim3ym, event.vortexSizeMult, event.eyeOpen);
#else
_od2x3w += _r8l9mr(_st4awd, _bim3ym, _bim3ym, 1.0, 0.0);
#endif
}
#endif

#ifdef END_EVENT_ENABLED
_od2x3w += _s9f8xh(_st4awd, event.bangProgress, event.bangFlash);
#endif

return _od2x3w;
}

#endif
