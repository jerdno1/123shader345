#ifdef END_VORTEX_ENABLED

float _w8kdjx(float _huatah, float _yn96w6, float vortexTime) {

float _usk87t = _huatah * END_VORTEX_ARMS + _yn96w6 * END_VORTEX_TIGHTNESS * 3.0 - vortexTime * END_VORTEX_SPEED * 3.0;

float _3949kh = sin(_usk87t) * 0.5 + 0.5;
_3949kh = pow(_3949kh, 2.5);

float _xioiwb = sin(_usk87t * 0.7 + 2.0) * 0.5 + 0.5;
_xioiwb = pow(_xioiwb, 3.0);

float _mksj8f = sin(_usk87t * 1.3 - 1.5) * 0.5 + 0.5;
_mksj8f = pow(_mksj8f, 3.5);

return _3949kh * 0.5 + _xioiwb * 0.3 + _mksj8f * 0.2;
}

vec3 _r8l9mr(vec3 _llxraj, float vortexTime, float _bim3ym, float _9xtbto, float eyeOpen) {
if (_llxraj.y < -0.1) return vec3(0.0);

if (_9xtbto < 0.001 && eyeOpen < 0.001) return vec3(0.0);

float _vic1om = _llxraj.y;
float _64ioga = 1.0 - clamp(_vic1om, 0.0, 1.0);
float _eo29pw = smoothstep(-0.1, 0.2, _llxraj.y);

float _35hjn1 = _64ioga / max(_9xtbto, 0.001);

float _64jb57 = atan(_llxraj.z, _llxraj.x);
float _2h9y8v = atan(-_llxraj.z, -_llxraj.x);

float _yn96w6 = log(max(_64ioga, 0.001));

float _h0vinc = _w8kdjx(_64jb57, _yn96w6, vortexTime);
float _3xqdn5 = _w8kdjx(_2h9y8v + 3.14159, _yn96w6, vortexTime);

float _9xe00m = (1.0 - smoothstep(-0.5, 0.5, _llxraj.x)) * (1.0 - smoothstep(0.0, 0.5, abs(_llxraj.z)));
float _g7ejan = mix(_h0vinc, _3xqdn5, _9xe00m);

float _dxd604 = _2kw178(vec3(_llxraj.xz * 4.0, vortexTime * END_VORTEX_SPEED * 0.4));
float _x6z13t = _00ehr5(vec3(_llxraj.xz * 2.0 + vortexTime * 0.05, _35hjn1 * 3.0), 3);
_g7ejan *= 0.5 + 0.5 * _dxd604;
_g7ejan *= 0.6 + 0.4 * _x6z13t;

float _gp4hml = 1.0 - smoothstep(0.1, 1.0, _35hjn1);
_gp4hml = pow(_gp4hml, 0.8);
float _4egdi6 = (1.0 - smoothstep(0.05, 0.5, _35hjn1)) * 1.5;

float _x9g3a3 = 1.0 - smoothstep(0.0, END_VORTEX_CORE_SIZE * 2.0, _35hjn1);
_x9g3a3 = pow(_x9g3a3, 2.0);
float _79c95v = 1.0 - smoothstep(0.0, END_VORTEX_CORE_SIZE * 0.8, _35hjn1);
_79c95v = pow(_79c95v, 3.0);

vec3 _nqi380 = vec3(END_VORTEX_R2, END_VORTEX_G2, END_VORTEX_B2);
vec3 _1pf8h0 = _nqi380 * 0.4;
vec3 _gr5zvc = _nqi380 * 1.2;
vec3 _dugviw = mix(_1pf8h0, _gr5zvc, _gp4hml);

vec3 _8izj9y = vec3(0.0);
_8izj9y += _dugviw * _g7ejan * _gp4hml * 0.8;
_8izj9y += _dugviw * _g7ejan * _4egdi6 * 0.4;
_8izj9y += _nqi380 * _x9g3a3 * 0.6;
_8izj9y += mix(_nqi380, vec3(1.0), 0.6) * _79c95v * 0.8;

#ifdef END_EVENT_EYE_ENABLED
if (eyeOpen > 0.001 && _64ioga < END_VORTEX_CORE_SIZE * 0.5) {
float _r84zno = END_VORTEX_CORE_SIZE * 0.15;
float _868p1v = _64ioga / _r84zno;

float _qm415l = max(sqrt(_llxraj.x * _llxraj.x + _llxraj.z * _llxraj.z), 0.0001);
float _cyps34 = _llxraj.z / _qm415l;
float _2uune0 = _cyps34 * _868p1v;
float _1x7grz = eyeOpen * 1.2;
float _z5dxhw = 1.0 - smoothstep(_1x7grz - 0.06, _1x7grz + 0.06, abs(_2uune0));
_z5dxhw *= 1.0 - smoothstep(0.90, 1.05, _868p1v);
_z5dxhw *= smoothstep(0.0, 0.05, eyeOpen);

if (_z5dxhw > 0.001) {
vec2 _ct6z4r = normalize(_llxraj.xz + 0.001);

vec3 _4w4h6k = vec3(END_EVENT_EYE_IRIS_R, END_EVENT_EYE_IRIS_G, END_EVENT_EYE_IRIS_B);

_8izj9y = mix(_8izj9y, vec3(0.0), _z5dxhw);

float _t8017a = 0.88;
float _c7zyfc = abs(_868p1v - _t8017a);
float _1b6yvc = 1.0 - smoothstep(0.005, 0.05, _c7zyfc);
_8izj9y += _4w4h6k * 0.8 * _1b6yvc * _z5dxhw;

float _c046i1 = 0.18;
float _8w7148 = 0.72;
float _bmn0sh = smoothstep(_c046i1 - 0.03, _c046i1 + 0.06, _868p1v)
* (1.0 - smoothstep(_8w7148 - 0.06, _8w7148 + 0.05, _868p1v));

float _73g9pw = _2kw178(vec3(_ct6z4r * 5.0 + _868p1v * 15.0 - _bim3ym * 0.3, 11.0));
float _2uk7r4 = _2kw178(vec3(_ct6z4r * 3.0 - _868p1v * 10.0 + _bim3ym * 0.18, 57.0));
float _yv2axw = _2kw178(vec3(_ct6z4r * 7.0 + _868p1v * 20.0 + _bim3ym * 0.1, 3.0));

float _0bs17r = _73g9pw * 0.5 + _2uk7r4 * 0.3 + _yv2axw * 0.2;
_0bs17r = smoothstep(0.45, 0.56, _0bs17r);

float _8jw45a = smoothstep(0.35, 0.65, _73g9pw);
vec3 _3m3eze = mix(vec3(0.4, 0.25, 0.6), _4w4h6k, _8jw45a);

_8izj9y += _3m3eze * _0bs17r * _bmn0sh * _z5dxhw * 1.8;

float _kq41ko = _c046i1 + 0.02;
float _2226st = abs(_868p1v - _kq41ko);
float _702avi = 1.0 - smoothstep(0.005, 0.04, _2226st);
_8izj9y += _4w4h6k * 0.5 * _702avi * _z5dxhw;

float _fixst7 = mod(_bim3ym, END_EVENT_CYCLE);
float _zuuflz = END_EVENT_CYCLE - 22.0;
float _ia6akb = _fixst7 - _zuuflz;

float _jqqrr8 = 0.0;

if (_ia6akb > 3.0 && _ia6akb < 3.3) {
_jqqrr8 = smoothstep(3.0, 3.3, _ia6akb);
} else if (_ia6akb >= 3.3 && _ia6akb < 4.5) {
_jqqrr8 = 1.0;
} else if (_ia6akb >= 4.5 && _ia6akb < 5.5) {
_jqqrr8 = 1.0 - smoothstep(4.5, 5.5, _ia6akb);
}

if (_ia6akb > 8.0 && _ia6akb < 8.25) {
_jqqrr8 = smoothstep(8.0, 8.25, _ia6akb);
} else if (_ia6akb >= 8.25 && _ia6akb < 9.2) {
_jqqrr8 = 1.0;
} else if (_ia6akb >= 9.2 && _ia6akb < 10.0) {
_jqqrr8 = 1.0 - smoothstep(9.2, 10.0, _ia6akb);
}
float _pv9uvx = mix(0.14, 0.06, _jqqrr8);
float _jvb9ws = mix(0.05, 0.02, _jqqrr8);

float _szrsc4 = 1.0 - smoothstep(0.0, _pv9uvx, _868p1v);
_szrsc4 = _szrsc4 * _szrsc4;
_8izj9y += vec3(1.0) * _szrsc4 * _z5dxhw * 2.0;

float _6jsz32 = 1.0 - smoothstep(0.0, _jvb9ws, _868p1v);
_8izj9y += vec3(1.0) * _6jsz32 * _z5dxhw * 3.0;
}

vec3 _pq1dl3 = vec3(END_EVENT_EYE_IRIS_R, END_EVENT_EYE_IRIS_G, END_EVENT_EYE_IRIS_B);
float _rgvxhp = smoothstep(0.0, 0.15, eyeOpen);

float _d0eb2t = 1.0 - smoothstep(0.8, 2.5, _868p1v);
_d0eb2t = _d0eb2t * _d0eb2t * 0.3;
_8izj9y += _pq1dl3 * _d0eb2t * _rgvxhp;

float _6niold = 1.0 - smoothstep(0.0, 0.6, _868p1v);
_6niold = _6niold * _6niold * _6niold * 0.5;
_8izj9y += vec3(1.0) * _6niold * _rgvxhp;

float _nwuzdw = (1.0 - smoothstep(0.3, 1.8, _868p1v)) * smoothstep(0.0, 0.15, _868p1v);
_nwuzdw *= 0.15;
_8izj9y += _pq1dl3 * 0.6 * _nwuzdw * _rgvxhp;
}
#endif

_8izj9y *= END_VORTEX_INTENSITY * _eo29pw;

return _8izj9y;
}
#endif
