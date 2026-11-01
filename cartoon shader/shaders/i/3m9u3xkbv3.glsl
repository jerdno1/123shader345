#ifndef SKY_TIMELINE_GLSL
#define SKY_TIMELINE_GLSL

struct TimeWeights {
float day;
float sunset;
float blueHour;
float night;
float sunrise;
float dawn;
};

TimeWeights getTimeWeights(float sunAngle) {
float _huatah = fract(sunAngle);
TimeWeights w;

w.day = smoothstep(0.02, 0.07, _huatah) * (1.0 - smoothstep(0.44, 0.48, _huatah));

w.sunset = smoothstep(0.46, 0.49, _huatah) * (1.0 - smoothstep(0.50, 0.52, _huatah));

w.sunrise = smoothstep(0.96, 0.99, _huatah) + (1.0 - smoothstep(0.0, 0.03, _huatah));

w.blueHour = smoothstep(0.50, 0.52, _huatah) * (1.0 - smoothstep(0.55, 0.58, _huatah));

w.dawn = 0.0;

w.night = smoothstep(0.55, 0.60, _huatah) * (1.0 - smoothstep(0.94, 0.98, _huatah));

float _56jsby = w.day + w.sunset + w.blueHour + w.night + w.sunrise + w.dawn;
if (_56jsby > 0.001) {
float _itxn5v = 1.0 / _56jsby;
w.day *= _itxn5v;
w.sunset *= _itxn5v;
w.blueHour *= _itxn5v;
w.night *= _itxn5v;
w.sunrise *= _itxn5v;
w.dawn *= _itxn5v;
} else {
w.day = 1.0;
}

return w;
}

struct TimeWeightsSimple {
float day;
float twilight;
float blueHour;
float night;
};

TimeWeightsSimple getTimeWeightsSimple(float sunAngle) {
TimeWeights w = getTimeWeights(sunAngle);
TimeWeightsSimple s;
s.day = w.day;
s.twilight = w.sunset + w.sunrise;
s.blueHour = w.blueHour + w.dawn;
s.night = w.night;
return s;
}

#define SUNRISE_HORIZON_R 1.00
#define SUNRISE_HORIZON_G 0.70
#define SUNRISE_HORIZON_B 0.45

#define SUNRISE_MID_R 0.90
#define SUNRISE_MID_G 0.55
#define SUNRISE_MID_B 0.55

#define SUNRISE_ZENITH_R 0.65
#define SUNRISE_ZENITH_G 0.45
#define SUNRISE_ZENITH_B 0.65

#define SUNRISE_BRIGHTNESS 0.85

#define DAWN_HORIZON_R 0.15
#define DAWN_HORIZON_G 0.50
#define DAWN_HORIZON_B 0.85

#define DAWN_MID_R 0.30
#define DAWN_MID_G 0.30
#define DAWN_MID_B 0.60

#define DAWN_ZENITH_R 0.12
#define DAWN_ZENITH_G 0.18
#define DAWN_ZENITH_B 0.45

#define DAWN_BRIGHTNESS 0.55

vec3 _9ruyvd(float sunAngle, float _pwfvop) {
TimeWeights w = getTimeWeights(sunAngle);

vec3 _truje5 = vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B);
vec3 _hi3ah6 = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);
vec3 _j0ukir = mix(_truje5, _hi3ah6, _pwfvop) * DAY_BRIGHTNESS;

vec3 _tb11ue = vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B);
vec3 _bi1bnz = vec3(SUNSET_ZENITH_R, SUNSET_ZENITH_G, SUNSET_ZENITH_B);
vec3 _idmemv = mix(_tb11ue, _bi1bnz, _pwfvop) * SUNSET_BRIGHTNESS;

vec3 _yzt0oy = vec3(BLUEHOUR_HORIZON_R, BLUEHOUR_HORIZON_G, BLUEHOUR_HORIZON_B);
vec3 _7xgtyg = vec3(BLUEHOUR_ZENITH_R, BLUEHOUR_ZENITH_G, BLUEHOUR_ZENITH_B);
vec3 _h799yy = mix(_yzt0oy, _7xgtyg, _pwfvop) * BLUEHOUR_BRIGHTNESS;

vec3 _t4ykkb = vec3(NIGHT_HORIZON_R, NIGHT_HORIZON_G, NIGHT_HORIZON_B);
vec3 _x1bkcq = vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B);
vec3 _8x0rxj = mix(_t4ykkb, _x1bkcq, _pwfvop) * NIGHT_BRIGHTNESS;

vec3 _dygaym = vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B);
vec3 _n1exna = vec3(SUNRISE_ZENITH_R, SUNRISE_ZENITH_G, SUNRISE_ZENITH_B);
vec3 _avg2dr = mix(_dygaym, _n1exna, _pwfvop) * SUNRISE_BRIGHTNESS;

vec3 _74ump4 = vec3(DAWN_HORIZON_R, DAWN_HORIZON_G, DAWN_HORIZON_B);
vec3 _b0h6jt = vec3(DAWN_ZENITH_R, DAWN_ZENITH_G, DAWN_ZENITH_B);
vec3 _367p8n = mix(_74ump4, _b0h6jt, _pwfvop) * DAWN_BRIGHTNESS;

vec3 _yssmf1 = _j0ukir    * w.day
+ _idmemv * w.sunset
+ _h799yy   * w.blueHour
+ _8x0rxj  * w.night
+ _avg2dr * w.sunrise
+ _367p8n   * w.dawn;

float _p141w5 = min(w.day, w.sunset + w.sunrise) * 2.5;
float _698129 = min(w.day, w.sunset + w.sunrise) * 2.0;
float _92388v = mix(_p141w5, _698129, _pwfvop);
vec3 _y2j94g = mix(vec3(1.0, 0.92, 0.4), vec3(0.85, 0.15, 0.55), _pwfvop);
_y2j94g *= max(DAY_BRIGHTNESS, SUNSET_BRIGHTNESS);
_yssmf1 = mix(_yssmf1, _y2j94g, _92388v * mix(0.45, 0.55, _pwfvop));
float _4am4t1 = min(w.sunset, w.blueHour) * 2.0;
vec3 _at014b = mix(vec3(0.9, 0.25, 0.55), vec3(0.4, 0.1, 1.0), _pwfvop);
_at014b *= mix(SUNSET_BRIGHTNESS, BLUEHOUR_BRIGHTNESS, 0.5);
_yssmf1 = mix(_yssmf1, _at014b, _4am4t1 * mix(0.4, 0.55, _pwfvop));

return _yssmf1;
}

vec3 _9ruyvd(float sunAngle) {
return _9ruyvd(sunAngle, 0.0);
}

vec2 _bxr2n6(float sunAngle) {
TimeWeights w = getTimeWeights(sunAngle);

float _xgal31 = w.day * 1.0
+ w.sunset * 0.85
+ w.sunrise * 0.80
+ w.blueHour * 0.45
+ w.dawn * 0.45
+ w.night * 0.04;

float _q3g0w9 = w.night
+ (w.sunset + w.sunrise) * 0.4
+ (w.blueHour + w.dawn) * 0.6;

return vec2(_xgal31, _q3g0w9);
}

#endif
