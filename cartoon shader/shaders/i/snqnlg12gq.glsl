#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1.rgb = vec3(0.0, 1.0, 0.0);
_yssmf1.a = 0.35;
#else

float _9v4uku = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
_yssmf1.rgb = _gkt4lb(_yssmf1.rgb, sunAngle, skylight, _d5ovut);

float _ll3pvb = smoothstep(0.08, 0.42, _9v4uku);
_r66fbx = max(_r66fbx, _ll3pvb * 0.75);
float _twb14z = 1.0 - smoothstep(3.0 / 15.0, 10.0 / 15.0, skylight);
float _2anpzr = smoothstep(1.0 / 15.0, 12.0 / 15.0, _d5ovut);
vec3 _b5t3ru = vec3(0.05) * (0.35 + _twb14z * 0.55 + _2anpzr * 0.45);
#ifdef LPV_ENABLED
{
vec3 _xg4mls = _dqt2v3(worldPos, _rp4u74, _2anpzr) * BLOCKLIGHT_BRIGHTNESS;
_b5t3ru += _xg4mls * (1.0 + _twb14z);
}
#endif
_yssmf1.rgb += _b5t3ru * _ll3pvb * (0.30 + _twb14z * 0.55);

float _duirvc = 0.5;
#ifdef WATER_WAVES_ENABLED
{
#define WF_H3(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)
float _lhf626 = frameTimeCounter * 8.0;

vec3 _7aqewt = worldPos * vec3(1.5, 0.4, 1.5);
_7aqewt.y += frameTimeCounter * 4.0;
vec3 _ghi8qm = floor(_7aqewt); vec3 _a8nrps = fract(_7aqewt);
float _o19onw = smoothstep(0.0,1.0,_a8nrps.x), _wy = smoothstep(0.0,1.0,_a8nrps.y), _wz = smoothstep(0.0,1.0,_a8nrps.z);
float wn = mix(mix(mix(WF_H3(_ghi8qm),WF_H3(_ghi8qm+vec3(1,0,0)),_o19onw),mix(WF_H3(_ghi8qm+vec3(0,1,0)),WF_H3(_ghi8qm+vec3(1,1,0)),_o19onw),_wy),
mix(mix(WF_H3(_ghi8qm+vec3(0,0,1)),WF_H3(_ghi8qm+vec3(1,0,1)),_o19onw),mix(WF_H3(_ghi8qm+vec3(0,1,1)),WF_H3(_ghi8qm+vec3(1,1,1)),_o19onw),_wy),_wz);

float _ub42v8 = wn * 0.2;
_yssmf1.rgb *= 1.0 + _ub42v8;
_duirvc = wn;

vec3 L = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 V = normalize(cameraPosition - worldPos);
vec3 _mt7k70 = _rp4u74;
vec3 _l9i1nf = V + L;
float _bttslr = dot(_l9i1nf, _l9i1nf);
float _x102pb = _bttslr > 1e-10
? max(dot(_mt7k70, _l9i1nf * inversesqrt(_bttslr)), 0.0)
: 0.0;
vec4 _jqmu3t = _wrl6e0(sunAngle);
float _xya605 = _jqmu3t.x + _jqmu3t.y * 0.7 + _jqmu3t.z * 0.15;
float _1u4hxd = abs(L.y);
float _jwxv5z = 1.0 - smoothstep(0.5, 0.9, _1u4hxd) * 0.7;
float _embnb1 = 1.0 + _jqmu3t.y * 2.0;
float _fmb5j5 = pow(_x102pb, 128.0) * 0.8;
float _cx42xx = pow(_x102pb, 8.0) * 0.5;
float _xf5rzj = (_fmb5j5 + _cx42xx) * _xya605 * skylight * _jwxv5z * _embnb1;
vec3 _f1qzlp = mix(vec3(1.0, 0.95, 0.85), vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), _jqmu3t.y);
float _7spe3g = min(_xf5rzj * WATER_SPECULAR_INTENSITY, 0.8);
_7spe3g *= shadow;
_yssmf1.rgb = mix(_yssmf1.rgb, _f1qzlp * 1.2, _7spe3g);
_yssmf1.a = max(_yssmf1.a, _xf5rzj * 0.5 * shadow);

#undef WF_H3
}
#endif

_xrdem2 = vec4(_duirvc, _kup5d9(_rp4u74), _rp4u74.x * 0.5 + 0.5, _rp4u74.y * 0.5 + 0.5);
#endif
