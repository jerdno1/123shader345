#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1.rgb = vec3(0.0, 0.0, 1.0);
_yssmf1.a = 0.35;
#else

float _mhpgf5 = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));

vec2 _a0tv11 = floor(worldPos.xz * 16.0) / 16.0;

float _362h77 = _cks7vw(_a0tv11 * 0.3 + vec2(7.1, -3.4));
float _3x5b5o = _cks7vw(_a0tv11 * 0.25 + vec2(-5.8, 11.2));
vec2 _bwh4p0 = _a0tv11 * 0.5 + vec2(_362h77 - 0.5, _3x5b5o - 0.5) * 2.0;
float _c7n5w5 = _cks7vw(_bwh4p0 + vec2(frameTimeCounter * 0.02, -frameTimeCounter * 0.015));
_c7n5w5 *= _cks7vw(_bwh4p0 * 1.7 + vec2(-frameTimeCounter * 0.03, frameTimeCounter * 0.01) + vec2(13.0, -8.0));
_c7n5w5 = smoothstep(0.08, 0.45, _c7n5w5);

float _0jejg8 = length(worldPos.xz - cameraPosition.xz);
float _ho2wb6 = 1.0 - smoothstep(24.0, 60.0, _0jejg8);
_56k3j0 = smoothstep(0.10, 0.50, _mhpgf5) * _c7n5w5 * 0.2 * _ho2wb6;

_56k3j0 = mix(_56k3j0, smoothstep(0.15, 0.45, _mhpgf5) * 0.45, biome_swamp);
_yssmf1.rgb = _gkt4lb(_yssmf1.rgb, sunAngle, skylight, _d5ovut);

_r66fbx = smoothstep(0.08, 0.42, _mhpgf5) * mix(0.55, 1.0, _c7n5w5);
float _ga3fn7 = 1.0 - smoothstep(3.0 / 15.0, 10.0 / 15.0, skylight);
float _upgc6i = smoothstep(1.0 / 15.0, 12.0 / 15.0, _d5ovut);
vec3 _z5rdg0 = vec3(0.055) * (0.35 + _ga3fn7 * 0.55 + _upgc6i * 0.45);
#ifdef LPV_ENABLED
{
vec3 _wib2fc = _dqt2v3(worldPos, _rp4u74, _upgc6i) * BLOCKLIGHT_BRIGHTNESS;
_z5rdg0 += _wib2fc * (1.2 + _ga3fn7 * 1.1);
}
#endif
_yssmf1.rgb += _z5rdg0 * _r66fbx * (0.35 + _ga3fn7 * 0.65);
#endif

{
float _seectz = smoothstep(0.0, 0.8, waterBlockFracY);

if (false && _seectz > 0.01) {
#define WF_TH3(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)

float _gnxi3e = frameTimeCounter * 1.2;
float _pnr1f3 = frameTimeCounter * 3.0;

vec3 _4g83ky = worldPos * vec3(2.5, 0.15, 2.5) + vec3(_pnr1f3 * 0.3, 0.0, -_pnr1f3 * 0.25);
_4g83ky.y += floor(_gnxi3e);
vec3 _guir8k = floor(_4g83ky); vec3 _kelw3p = fract(_4g83ky);
float _eisrbr = smoothstep(0.0,1.0,_kelw3p.x), _y1 = smoothstep(0.0,1.0,_kelw3p.y), _z1 = smoothstep(0.0,1.0,_kelw3p.z);
float _9dpgjt = mix(mix(mix(WF_TH3(_guir8k),WF_TH3(_guir8k+vec3(1,0,0)),_eisrbr),mix(WF_TH3(_guir8k+vec3(0,1,0)),WF_TH3(_guir8k+vec3(1,1,0)),_eisrbr),_y1),
mix(mix(WF_TH3(_guir8k+vec3(0,0,1)),WF_TH3(_guir8k+vec3(1,0,1)),_eisrbr),mix(WF_TH3(_guir8k+vec3(0,1,1)),WF_TH3(_guir8k+vec3(1,1,1)),_eisrbr),_y1),_z1);
_4g83ky.y += 1.0;
_guir8k = floor(_4g83ky); _kelw3p = fract(_4g83ky);
_eisrbr = smoothstep(0.0,1.0,_kelw3p.x); _y1 = smoothstep(0.0,1.0,_kelw3p.y); _z1 = smoothstep(0.0,1.0,_kelw3p.z);
float _3du6oc = mix(mix(mix(WF_TH3(_guir8k),WF_TH3(_guir8k+vec3(1,0,0)),_eisrbr),mix(WF_TH3(_guir8k+vec3(0,1,0)),WF_TH3(_guir8k+vec3(1,1,0)),_eisrbr),_y1),
mix(mix(WF_TH3(_guir8k+vec3(0,0,1)),WF_TH3(_guir8k+vec3(1,0,1)),_eisrbr),mix(WF_TH3(_guir8k+vec3(0,1,1)),WF_TH3(_guir8k+vec3(1,1,1)),_eisrbr),_y1),_z1);
float n1 = mix(_9dpgjt, _3du6oc, smoothstep(0.0, 1.0, fract(_gnxi3e)));

vec3 _a0ky14 = worldPos * vec3(4.0, 0.2, 4.0) + vec3(-_pnr1f3 * 0.2, 0.0, _pnr1f3 * 0.3) + vec3(17.0);
_a0ky14.y += floor(_gnxi3e * 1.4);
vec3 _n7ie28 = floor(_a0ky14); vec3 _ic34xk = fract(_a0ky14);
float _43zaec = smoothstep(0.0,1.0,_ic34xk.x), _y2 = smoothstep(0.0,1.0,_ic34xk.y), _z2 = smoothstep(0.0,1.0,_ic34xk.z);
float _tl2r9z = mix(mix(mix(WF_TH3(_n7ie28),WF_TH3(_n7ie28+vec3(1,0,0)),_43zaec),mix(WF_TH3(_n7ie28+vec3(0,1,0)),WF_TH3(_n7ie28+vec3(1,1,0)),_43zaec),_y2),
mix(mix(WF_TH3(_n7ie28+vec3(0,0,1)),WF_TH3(_n7ie28+vec3(1,0,1)),_43zaec),mix(WF_TH3(_n7ie28+vec3(0,1,1)),WF_TH3(_n7ie28+vec3(1,1,1)),_43zaec),_y2),_z2);
_a0ky14.y += 1.0;
_n7ie28 = floor(_a0ky14); _ic34xk = fract(_a0ky14);
_43zaec = smoothstep(0.0,1.0,_ic34xk.x); _y2 = smoothstep(0.0,1.0,_ic34xk.y); _z2 = smoothstep(0.0,1.0,_ic34xk.z);
float _ysoqff = mix(mix(mix(WF_TH3(_n7ie28),WF_TH3(_n7ie28+vec3(1,0,0)),_43zaec),mix(WF_TH3(_n7ie28+vec3(0,1,0)),WF_TH3(_n7ie28+vec3(1,1,0)),_43zaec),_y2),
mix(mix(WF_TH3(_n7ie28+vec3(0,0,1)),WF_TH3(_n7ie28+vec3(1,0,1)),_43zaec),mix(WF_TH3(_n7ie28+vec3(0,1,1)),WF_TH3(_n7ie28+vec3(1,1,1)),_43zaec),_y2),_z2);
float n2 = mix(_tl2r9z, _ysoqff, smoothstep(0.0, 1.0, fract(_gnxi3e * 1.4)));

vec3 _8b3rb1 = worldPos * vec3(7.0, 0.3, 7.0) + vec3(_pnr1f3 * 0.15, 0.0, _pnr1f3 * 0.15) + vec3(31.0);
_8b3rb1.y += floor(_gnxi3e * 1.8);
vec3 _dwg6r1 = floor(_8b3rb1); vec3 _wmklgx = fract(_8b3rb1);
float _c8lar1 = smoothstep(0.0,1.0,_wmklgx.x), _y3 = smoothstep(0.0,1.0,_wmklgx.y), _z3 = smoothstep(0.0,1.0,_wmklgx.z);
float _7mhj2m = mix(mix(mix(WF_TH3(_dwg6r1),WF_TH3(_dwg6r1+vec3(1,0,0)),_c8lar1),mix(WF_TH3(_dwg6r1+vec3(0,1,0)),WF_TH3(_dwg6r1+vec3(1,1,0)),_c8lar1),_y3),
mix(mix(WF_TH3(_dwg6r1+vec3(0,0,1)),WF_TH3(_dwg6r1+vec3(1,0,1)),_c8lar1),mix(WF_TH3(_dwg6r1+vec3(0,1,1)),WF_TH3(_dwg6r1+vec3(1,1,1)),_c8lar1),_y3),_z3);
_8b3rb1.y += 1.0;
_dwg6r1 = floor(_8b3rb1); _wmklgx = fract(_8b3rb1);
_c8lar1 = smoothstep(0.0,1.0,_wmklgx.x); _y3 = smoothstep(0.0,1.0,_wmklgx.y); _z3 = smoothstep(0.0,1.0,_wmklgx.z);
float _qbsopn = mix(mix(mix(WF_TH3(_dwg6r1),WF_TH3(_dwg6r1+vec3(1,0,0)),_c8lar1),mix(WF_TH3(_dwg6r1+vec3(0,1,0)),WF_TH3(_dwg6r1+vec3(1,1,0)),_c8lar1),_y3),
mix(mix(WF_TH3(_dwg6r1+vec3(0,0,1)),WF_TH3(_dwg6r1+vec3(1,0,1)),_c8lar1),mix(WF_TH3(_dwg6r1+vec3(0,1,1)),WF_TH3(_dwg6r1+vec3(1,1,1)),_c8lar1),_y3),_z3);
float n3 = mix(_7mhj2m, _qbsopn, smoothstep(0.0, 1.0, fract(_gnxi3e * 1.8)));

float _7vhcjd = smoothstep(0.20, 0.50, n1) * 0.4
+ smoothstep(0.25, 0.55, n2) * 0.35
+ smoothstep(0.30, 0.60, n3) * 0.25;

vec3 _v7yxlq = vec3(mix(0.55, 0.75, _7vhcjd));
_yssmf1.rgb = mix(_yssmf1.rgb, _v7yxlq, _seectz);
_yssmf1.a = mix(_yssmf1.a, 1.0, _seectz);

#undef WF_TH3
}
}

_xrdem2 = vec4(waveHeight + _56k3j0, 1.0, _rp4u74.x * 0.5 + 0.5, _rp4u74.y * 0.5 + 0.5);
