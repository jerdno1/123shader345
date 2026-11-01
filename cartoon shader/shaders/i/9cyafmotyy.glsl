vec3 _1jzgf0() {
if (_9cwhip(biome)) {
return _yfroai(biome, biome_category, fogColor);
}

TimeWeights tw = getTimeWeights(sunAngle);

float _gy6n9g = smoothstep(0.18, 0.78, tw.day + (tw.sunset + tw.sunrise) * 0.30);
float _rxs39p = _dfzmvk(biome_snowy, biome, biome_category);
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _9yfvgh = _j4acyp(biome_arid, biome, biome_category);
float _fgx2j8 = _g4a6za(_huw7hc(biome_savanna, biome, biome_category), _lfojrz);
bool _tckg8p = max(max(max(max(_rxs39p, _2d13on), max(_lfojrz, _9yfvgh)), _fgx2j8), clamp(biome_pale_garden, 0.0, 1.0)) > 0.001;
float _15ht8g = _tckg8p ? 1.0 : (SKY_BIOME_BLEND * _gy6n9g);
float _4mmo09 = _15ht8g;
float _tl3yen = _15ht8g * 0.55;
float _bvwmag = _15ht8g * 0.40;
float _q4dvcm = _15ht8g * 0.20;
vec3 _6soi7f = _af4aog(vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B), _rxs39p, _2d13on, _lfojrz, _9yfvgh, _fgx2j8);

vec3 _dsfiw5     = mix(vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B), _6soi7f, _4mmo09) * DAY_BRIGHTNESS;
vec3 _xcnbk2  = mix(vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), _6soi7f, _tl3yen) * SUNSET_BRIGHTNESS;
vec3 _oi87mp    = mix(vec3(BLUEHOUR_HORIZON_R, BLUEHOUR_HORIZON_G, BLUEHOUR_HORIZON_B), _6soi7f, _bvwmag) * BLUEHOUR_BRIGHTNESS;
vec3 _ydl9w0   = mix(vec3(NIGHT_HORIZON_R, NIGHT_HORIZON_G, NIGHT_HORIZON_B), _6soi7f, _q4dvcm) * NIGHT_BRIGHTNESS;
vec3 _rmnrih = mix(vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B), _6soi7f, _tl3yen) * SUNRISE_BRIGHTNESS;
vec3 _hgczsu    = mix(vec3(DAWN_HORIZON_R, DAWN_HORIZON_G, DAWN_HORIZON_B), _6soi7f, _bvwmag) * DAWN_BRIGHTNESS;

vec3 _yssmf1 = _dsfiw5     * tw.day
+ _xcnbk2  * tw.sunset
+ _oi87mp    * tw.blueHour
+ _ydl9w0   * tw.night
+ _rmnrih * tw.sunrise
+ _hgczsu    * tw.dawn;

float _92388v = min(tw.day, tw.sunset) * 2.0;
_yssmf1 = mix(_yssmf1, vec3(0.9, 0.15, 0.85) * mix(DAY_BRIGHTNESS, SUNSET_BRIGHTNESS, 0.5), _92388v * 0.5);
float _4am4t1 = min(tw.sunset, tw.blueHour) * 2.0;
_yssmf1 = mix(_yssmf1, vec3(0.4, 0.1, 1.0) * mix(SUNSET_BRIGHTNESS, BLUEHOUR_BRIGHTNESS, 0.5), _4am4t1 * 0.5);

return _yssmf1;
}
