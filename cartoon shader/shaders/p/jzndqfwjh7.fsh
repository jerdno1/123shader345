/* RENDERTARGETS: 7,1 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

uniform sampler2D gtexture;
uniform float alphaTestRef;
uniform vec3 cameraPosition;
uniform float sunAngle;
uniform int isEyeInWater;
uniform float biome_swamp;
uniform int frameCounter;

in vec2 texcoord;
in vec2 lmcoord;
in vec4 glcolor;
in vec3 worldPos;

#include "/include/lighting.glsl"
#include "/include/sky_timeline.glsl"
#include "/include/entity_particle_depth.glsl"

#include "/include/noise.glsl"

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;
vec3 _dwo81a = _yssmf1.rgb;

#ifdef TEXTURE_PALETTE_ENABLED
{
float _1pxkd6 = float(TEXTURE_PALETTE_LEVELS);
_yssmf1.rgb = floor(_yssmf1.rgb * _1pxkd6) / _1pxkd6;
}
#endif

if (_yssmf1.a < alphaTestRef) {
discard;
}
if (_na31gs()) discard;

#ifdef CHUNK_FADE_OUT_ENABLED
if (!_9cwhip(biome) && !_z0kr59(biome)) {
float _o5g13l = length(worldPos.xz - cameraPosition.xz);
float _tt79nt = smoothstep(CHUNK_FADE_OUT_RADIUS, CHUNK_FADE_OUT_RADIUS + 24.0, _o5g13l);
if (_tt79nt > 0.001) {
float _025mu8 = 1.0 - _tt79nt;
float _zekzgg = SEA_LEVEL_OFFSET - 96.0;
float _q73t75 = SEA_LEVEL_OFFSET + 320.0;
float _q4j75g = _cks7vw(worldPos.xz * 0.12);
float _j5jye0 = (_q4j75g - 0.5) * 10.0;
float _go7jgh = mix(_zekzgg, _q73t75, _025mu8) + _j5jye0;
float _fxiwh2 = 1.0 - smoothstep(_go7jgh - 8.0, _go7jgh + 8.0, worldPos.y);
_yssmf1.a *= _fxiwh2;
if (_yssmf1.a < alphaTestRef) discard;
}
}
#endif

{
float skylight = clamp(lmcoord.y, 0.0, 1.0);
float _huatah = fract(sunAngle);
float _zpw0c7 = smoothstep(0.38, 0.45, _huatah) * (1.0 - smoothstep(0.48, 0.55, _huatah))
+ smoothstep(0.95, 1.0, _huatah) + (1.0 - smoothstep(0.0, 0.05, _huatah));
float _nf77dj = smoothstep(0.07, 0.15, _huatah) * (1.0 - smoothstep(0.40, 0.46, _huatah));
float _grvh4h = SKYLIGHT_COLOR_TINT * (1.0 - _nf77dj * 0.6);
float _t7pliq = clamp(_grvh4h + _zpw0c7 * SUNSET_TERRAIN_TINT, 0.0, 1.0);
TimeWeights tw = getTimeWeights(sunAngle);
vec3 _z6rtf0 = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B) * tw.day
+ vec3(SUNSET_ZENITH_R, SUNSET_ZENITH_G, SUNSET_ZENITH_B) * tw.sunset
+ vec3(BLUEHOUR_ZENITH_R, BLUEHOUR_ZENITH_G, BLUEHOUR_ZENITH_B) * tw.blueHour
+ vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B) * tw.night
+ vec3(SUNRISE_ZENITH_R, SUNRISE_ZENITH_G, SUNRISE_ZENITH_B) * tw.sunrise
+ vec3(DAWN_ZENITH_R, DAWN_ZENITH_G, DAWN_ZENITH_B) * tw.dawn;
float _3m4k0c = dot(_z6rtf0, vec3(0.299, 0.587, 0.114));
_z6rtf0 = clamp(_z6rtf0 / max(_3m4k0c, 0.35), vec3(0.0), vec3(2.0));
vec3 _170eou = mix(vec3(1.0), _z6rtf0, _t7pliq * skylight);
_yssmf1.rgb *= _170eou;
}

float _xgal31 = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
float _5r47x0 = _yssmf1.r - _yssmf1.b;

float _6qwad8 = max(max(_yssmf1.r, _yssmf1.g), _yssmf1.b);
float _aslobc = min(min(_yssmf1.r, _yssmf1.g), _yssmf1.b);
float _zj0avb = (_6qwad8 > 0.001) ? (_6qwad8 - _aslobc) / _6qwad8 : 0.0;
bool _eivrp1 = _zj0avb < 0.15 && _xgal31 > 0.3 && _xgal31 < 0.95;

bool _gnmy1t = _xgal31 < 0.85 && _5r47x0 < 0.3 && _zj0avb < 0.7;

float emissive = 0.0;

bool _lld816 = _zj0avb < 0.2 && _xgal31 > 0.5;
if (!_eivrp1 && !_gnmy1t && !_lld816 && (_xgal31 > PARTICLE_BLOOM_THRESHOLD || (_5r47x0 > PARTICLE_BLOOM_WARMTH && _xgal31 > PARTICLE_BLOOM_THRESHOLD * 0.5))) {
emissive = PARTICLE_BLOOM_INTENSITY;
_yssmf1.rgb *= EMISSIVE_BRIGHTNESS;
} else {

float skylight = clamp(lmcoord.y, 0.0, 1.0);
float blocklight = clamp(lmcoord.x, 0.0, 1.0);
#ifdef LPV_ENABLED
_osnipo = worldPos;
_pis44d = _dwo81a;
_06143i = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
#endif
_yssmf1.rgb = _6xm99w(_yssmf1.rgb, sunAngle, skylight, blocklight, worldPos.y);
_yssmf1.rgb *= TERRAIN_BRIGHTNESS;
}

#ifdef BIOME_SOUL_SAND_VALLEY
if (biome == BIOME_SOUL_SAND_VALLEY && _5r47x0 > 0.1) {
float _bbduba = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
vec3 _d4y4gu = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _bbduba * 2.0;
float _4icwo1 = smoothstep(0.1, 0.4, _5r47x0);
_yssmf1.rgb = mix(_yssmf1.rgb, _d4y4gu, _4icwo1);
}
#endif

#if ICE_DEBUG_MODE == 1
_yssmf1.rgb = vec3(0.0, 0.0, 1.0);
#endif
gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(0.0, emissive, 0.0, 0.0);
}
