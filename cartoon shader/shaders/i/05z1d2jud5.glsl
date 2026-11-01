#ifndef WATER_COLOR_GLSL
#define WATER_COLOR_GLSL

#include "/include/sky_timeline.glsl"

const float MC_WATER_BRIGHTNESS  = 0.4;
const float MC_WATER_EXPOSURE    = 1.0;
const float MC_WATER_CONTRAST    = 1.0;
const float MC_WATER_SATURATION  = 0.6;
const float MC_WATER_VIBRANCE    = 0.0;
const float MC_WATER_GAMMA       = 1.5;
const float MC_WATER_BLACK_POINT = 0.0;
const float MC_WATER_WHITE_POINT = 1.0;
const vec3  MC_WATER_TINT        = vec3(1.0, 1.0, 1.0);

const float DH_WATER_BRIGHTNESS  = MC_WATER_BRIGHTNESS;
const float DH_WATER_EXPOSURE    = MC_WATER_EXPOSURE;
const float DH_WATER_CONTRAST    = MC_WATER_CONTRAST;
const float DH_WATER_SATURATION  = MC_WATER_SATURATION;
const float DH_WATER_VIBRANCE    = MC_WATER_VIBRANCE;
const float DH_WATER_GAMMA       = MC_WATER_GAMMA;
const float DH_WATER_BLACK_POINT = MC_WATER_BLACK_POINT;
const float DH_WATER_WHITE_POINT = MC_WATER_WHITE_POINT;
const vec3  DH_WATER_TINT        = MC_WATER_TINT;

vec4 _wrl6e0(float sunAngle) {
TimeWeightsSimple ts = getTimeWeightsSimple(sunAngle);

float day = ts.day;
float twilight = ts.twilight;
float night = ts.night + ts.blueHour;

float _xgal31 = 1.0 * day + 0.85 * twilight + 0.15 * night;
return vec4(day, twilight, night, _xgal31);
}

vec3 _iebr9p(float day, float sunset, float night) {
vec3 _izx33b = mix(vec3(DAY_MID_R, DAY_MID_G, DAY_MID_B),
vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B), 0.35);
vec3 _3j6u6t = mix(vec3(SUNSET_MID_R, SUNSET_MID_G, SUNSET_MID_B),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), 0.75);
vec3 _1zva4i = mix(vec3(NIGHT_MID_R, NIGHT_MID_G, NIGHT_MID_B),
vec3(NIGHT_HORIZON_R, NIGHT_HORIZON_G, NIGHT_HORIZON_B), 0.55);

float dL = dot(_izx33b, vec3(0.299, 0.587, 0.114));
_izx33b = clamp(_izx33b / max(dL, 0.35), vec3(0.0), vec3(2.0));
float sL = dot(_3j6u6t, vec3(0.299, 0.587, 0.114));
_3j6u6t = clamp(_3j6u6t / max(sL, 0.35), vec3(0.0), vec3(2.0));
float nL = dot(_1zva4i, vec3(0.299, 0.587, 0.114));
_1zva4i = clamp(_1zva4i / max(nL, 0.35), vec3(0.0), vec3(2.0));
vec3 tint = _izx33b * day + _3j6u6t * sunset + _1zva4i * night;
return mix(vec3(1.0), tint, SKYLIGHT_COLOR_TINT);
}

vec3 _xwb441(float sunAngle, float _rkigr4, float _lfojrz, float _2d13on, float _i6r0ml, float _9yfvgh) {

vec3 _xyezyl = _9ruyvd(sunAngle, 0.4);

vec4 _huc912 = _wrl6e0(sunAngle);
float _3noro7 = mix(0.3, 0.5, _huc912.y);
vec3 _x2q5fe = _xyezyl * _3noro7;

vec4 _jqmu3t = _wrl6e0(sunAngle);
float day = _jqmu3t.x;
float night = _jqmu3t.z;

vec3 _8izj9y = _x2q5fe;
if (_lfojrz > 0.001)  _8izj9y = mix(_8izj9y, vec3(0.18, 0.28, 0.08) * day + vec3(0.06, 0.10, 0.04) * night, _lfojrz);
if (_2d13on > 0.001) _8izj9y = mix(_8izj9y, vec3(0.08, 0.32, 0.30) * day + vec3(0.04, 0.12, 0.14) * night, _2d13on);

return _8izj9y;
}

vec3 _gkt4lb(vec3 _x2q5fe, float sunAngle) {

float _qidvgw = dot(_x2q5fe, vec3(0.299, 0.587, 0.114));
if (_qidvgw > 0.01) {
_x2q5fe = _x2q5fe / _qidvgw * 0.35;
}
_x2q5fe = clamp(_x2q5fe, vec3(0.0), vec3(1.0));

vec4 _jqmu3t = _wrl6e0(sunAngle);
vec3 tint = _iebr9p(_jqmu3t.x, _jqmu3t.y, _jqmu3t.z);
return _x2q5fe * _jqmu3t.w * tint;
}

float _d3kg90(float _y22te0, float skylight, float blocklight) {
float _vwmw48 = 1.0 - smoothstep(2.0 / 15.0, 8.0 / 15.0, clamp(skylight, 0.0, 1.0));
float _qiryo8 = smoothstep(1.0 / 15.0, 12.0 / 15.0, clamp(blocklight, 0.0, 1.0));
float _wr71jc = mix(0.55, 0.95, _qiryo8);
return mix(_y22te0, max(_y22te0, _wr71jc), _vwmw48);
}

vec3 _gkt4lb(vec3 _x2q5fe, float sunAngle, float skylight, float blocklight) {

float _qidvgw = dot(_x2q5fe, vec3(0.299, 0.587, 0.114));
if (_qidvgw > 0.01) _x2q5fe = _x2q5fe / _qidvgw * 0.35;
_x2q5fe = clamp(_x2q5fe, vec3(0.0), vec3(1.0));

vec4 _jqmu3t = _wrl6e0(sunAngle);

float _3cvaso = smoothstep(1.0 / 15.0, 2.0 / 15.0, skylight);
vec3 tint = mix(vec3(1.0), _iebr9p(_jqmu3t.x, _jqmu3t.y, _jqmu3t.z), _3cvaso);
float _xgal31 = _d3kg90(_jqmu3t.w, skylight, blocklight);
return _x2q5fe * _xgal31 * tint;
}

vec3 _gkt4lb(vec3 _x2q5fe, float sunAngle, float skylight) {
return _gkt4lb(_x2q5fe, sunAngle, skylight, 0.0);
}

vec3 _ii8hrk(vec3 viewDir, vec3 _9nsyz3, vec3 normal, float sunAngle) {
vec3 _l9i1nf = viewDir + _9nsyz3;
float _bttslr = dot(_l9i1nf, _l9i1nf);
float _x102pb = _bttslr > 1e-10
? max(dot(normal, _l9i1nf * inversesqrt(_bttslr)), 0.0)
: 0.0;

float _pluuxd = pow(_x102pb, 256.0);

float _rhc2vr = pow(_x102pb, 48.0);
float _xyhmor = _pluuxd * 6.0 + _rhc2vr * 1.2;
vec4 _jqmu3t = _wrl6e0(sunAngle);

vec3 _70feow = vec3(1.0, 1.0, 1.0) * _jqmu3t.x
+ vec3(1.0, 0.7, 0.4) * _jqmu3t.y
+ vec3(0.7, 0.8, 1.0) * _jqmu3t.z * 0.5;

#ifdef VOXY_PROGRAM
float _di1mp2 = 1.0;
#else
float _di1mp2 = 1.0 - rainStrength * 0.85;
#endif
return _70feow * _xyhmor * WATER_SPECULAR_INTENSITY * _di1mp2;
}

#endif
