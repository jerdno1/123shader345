#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1.rgb = vec3(1.0, 0.0, 0.0);
_yssmf1.a = 0.35;
#else

{
float t = frameTimeCounter * 0.4;
vec3 np = vec3(worldPos.xz * 0.6, t);

float n1 = _lpglwu(np * 1.0 + vec3(t * 0.3, 0.0, 0.0));
float n2 = _lpglwu(np * 2.0 - vec3(0.0, t * 0.2, 0.0));
float n = n1 * 0.6 + n2 * 0.4;

vec3 _lfsa79 = vec3(0.01, 0.03, 0.08);
vec3 _owce0s = vec3(0.06, 0.14, 0.22);
_yssmf1.rgb = mix(_lfsa79, _owce0s, n);

float _w1nf6p = mix(0.15, 1.0, skylight);
_yssmf1.rgb *= _w1nf6p;
}
_yssmf1.a = WATER_OPACITY;

{
vec2 _83lrkd = floor(worldPos.xz * 16.0) / 16.0;
float _wkmled = frameTimeCounter * WATER_WAVE_SPEED * 0.15;
vec3 _9ycpop = vec3(_83lrkd.x, 0.0, _83lrkd.y) * 0.35;

float _9ynd2l = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _9ycpop;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
_9ynd2l += abs(_lpglwu(p * _oah0e7 + _wkmled * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
_9ynd2l = 1.0 - _9ynd2l / _56jsby;
}
float _kcg2l1 = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _9ycpop + 5.0;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
_kcg2l1 += abs(_lpglwu(p * _oah0e7 + _wkmled * 1.15 * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
_kcg2l1 = 1.0 - _kcg2l1 / _56jsby;
}
float _ukyebm = min(_9ynd2l, _kcg2l1);
_ukyebm = pow(_ukyebm, 2.0) * 2.5;
_ukyebm = max(_ukyebm - 0.15, 0.0) * (1.0 / 0.85);

float _k7tj4g = _lpglwu(vec3(_83lrkd * 6.0, _wkmled * 0.5)) * 0.6;
_ukyebm += _k7tj4g;
_ukyebm = floor(_ukyebm * 5.0 + 0.5) / 5.0;
_ukyebm = max(_ukyebm, 0.0);

vec3 _teoy8a = _9ruyvd(sunAngle, 0.2) * 0.05;
float _v9x46n = smoothstep(0.5, 0.8, skylight);
_yssmf1.rgb += _teoy8a * _ukyebm * _v9x46n;
}

{
float _c30z1h = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
vec2 _x8owt1 = floor(worldPos.xz * 16.0) / 16.0;
float _22qs7j = _cks7vw(_x8owt1 * 0.3 + vec2(7.1, -3.4));
float _jun392 = _cks7vw(_x8owt1 * 0.25 + vec2(-5.8, 11.2));
vec2 _o8lcqo = _x8owt1 * 0.5 + vec2(_22qs7j - 0.5, _jun392 - 0.5) * 2.0;
float _8z7sxm = _cks7vw(_o8lcqo + vec2(frameTimeCounter * 0.02, -frameTimeCounter * 0.015));
_8z7sxm *= _cks7vw(_o8lcqo * 1.7 + vec2(-frameTimeCounter * 0.03, frameTimeCounter * 0.01) + vec2(13.0, -8.0));
_8z7sxm = smoothstep(0.08, 0.45, _8z7sxm);
float _vqlc0a = smoothstep(0.10, 0.50, _c30z1h) * _8z7sxm * 0.15;
float _bwasjb = length(worldPos.xz - cameraPosition.xz);
float _4ve6v5 = 1.0 - smoothstep(24.0, 60.0, _bwasjb);
_56k3j0 = _vqlc0a * _4ve6v5;
}

#ifdef WATER_FOAM_ENABLED
{
float _5l0slr = frameTimeCounter;
vec2 _3n7ltm = floor(worldPos.xz * 16.0) / 16.0;
float _0up5id = _5l0slr * WATER_WAVE_SPEED * 0.2;
vec3 _xfl3xg = vec3(_3n7ltm.x, 0.0, _3n7ltm.y) * 0.35;

float _frkje0 = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _xfl3xg;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
_frkje0 += abs(_lpglwu(p * _oah0e7 + _0up5id * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
_frkje0 = 1.0 - _frkje0 / _56jsby;
}
float _kwjlrw = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _xfl3xg + 5.0;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
_kwjlrw += abs(_lpglwu(p * _oah0e7 + _0up5id * 1.15 * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
_kwjlrw = 1.0 - _kwjlrw / _56jsby;
}
float _nm4m00 = min(_frkje0, _kwjlrw);
_nm4m00 = pow(_nm4m00, 2.0) * 2.5;
_nm4m00 = max(_nm4m00 - 0.15, 0.0) * (1.0 / 0.85);

float _vezrjs = 12.0;
float _2fgibi = 0.07;
vec2 _idjfvo = worldPos.xz * _2fgibi;
vec2 _ltfpnk = floor(_idjfvo);
float _2ik4e5 = 0.0;
for (int gx = -1; gx <= 1; gx++) {
for (int gy = -1; gy <= 1; gy++) {
vec2 _h908e6 = _ltfpnk + vec2(float(gx), float(gy));
float h1 = fract(sin(dot(_h908e6, vec2(127.1, 311.7))) * 43758.5453);
float h2 = fract(sin(dot(_h908e6, vec2(269.5, 183.3))) * 43758.5453);
float h3 = fract(sin(dot(_h908e6, vec2(419.2, 371.9))) * 43758.5453);
float _31394t = floor((_5l0slr + h1 * _vezrjs) / _vezrjs);
float h4 = fract(sin(dot(vec2(_31394t, h1 * 100.0), vec2(127.1, 311.7))) * 43758.5453);
float h5 = fract(sin(dot(vec2(_31394t, h2 * 100.0), vec2(269.5, 183.3))) * 43758.5453);
float _c1cy1c = mod(_5l0slr + h1 * _vezrjs, _vezrjs) / _vezrjs;
vec2 _pnr1f3 = vec2(h3 - 0.5, h1 - 0.5) * _c1cy1c * 0.5;
vec2 _o8zme9 = _h908e6 + vec2(0.2 + h4 * 0.6, 0.2 + h5 * 0.6) + _pnr1f3;
vec2 _ic9jj6 = _idjfvo - _o8zme9;
float _huatah = atan(_ic9jj6.y, _ic9jj6.x);
float _31trnd = 1.0 + 0.2 * sin(_huatah * 3.0 + h3 * 6.28) + 0.1 * sin(_huatah * 5.0 + h1 * 6.28);
float _t25r5m = length(_ic9jj6) * _31trnd;
float _c4eczi = mod(_5l0slr + h1 * _vezrjs, _vezrjs) / _vezrjs;
float _td7lfx = 0.45;
float _9zitwm = smoothstep(0.0, 0.4, _c4eczi) * _td7lfx;
float _wn2hnz = smoothstep(0.3, 0.95, _c4eczi) * _td7lfx * 1.3;
float _8ahrec = _9zitwm > 0.0001
? 1.0 - smoothstep(_9zitwm * 0.4, _9zitwm, _t25r5m)
: 0.0;
float _18rqbh = _wn2hnz > 0.0001
? smoothstep(_wn2hnz * 0.3, _wn2hnz, _t25r5m)
: 1.0;
float _md07hl = _8ahrec * _18rqbh;
float _795b2k = step(0.4, h2);
_2ik4e5 = max(_2ik4e5, _nm4m00 * _md07hl * _795b2k);
}
}
_2ik4e5 *= 0.10;
float _klfvr0 = length(worldPos.xz - cameraPosition.xz);
float _zruut0 = 1.0 - smoothstep(24.0, 60.0, _klfvr0);
_56k3j0 += _2ik4e5 * _zruut0;
}
#endif

_xrdem2.x = 0.5 + _56k3j0;
_xrdem2.y = 1.0;
_xrdem2.z = 0.5;
_xrdem2.w = 1.0;
#endif
