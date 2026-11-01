/* RENDERTARGETS: 7,1,3,4,5 */

#include "/settings.glsl"
#include "/include/glass_reflection_payload.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/hovering.glsl"

uniform sampler2D gtexture;
#ifdef PBR_ENABLED
uniform sampler2D specular;
#endif
uniform float alphaTestRef;
uniform float sunAngle;
uniform vec3 fogColor;
uniform int biome_category;
uniform float fogStart;
uniform float fogEnd;
uniform float frameTimeCounter;
uniform vec3 cameraPosition;
uniform int frameCounter;
uniform mat4 gbufferModelViewInverse;
uniform int isEyeInWater;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;

#include "/include/lighting.glsl"
#ifdef PBR_ENABLED
#include "/include/pbr.glsl"
#endif

in vec2 texcoord;
in vec4 glcolor;
in vec3 worldPos;
in vec3 normal;
flat in float isHologram;
in vec3 viewPos;
in float skylight;
in float blocklight;
in float viewDistance;
flat in float emissive;
flat in float emissiveType;

#include "/include/fog_color.glsl"

float _w5dqoo(float x) {
return fract(sin(x * 12.9898) * 43758.5453);
}

#include "/include/noise.glsl"

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;
vec3 _kmc7x2 = _yssmf1.rgb;

bool _t8o1u6 = (abs(emissiveType + 20.0) < 0.5);
if (_t8o1u6) {
if (_yssmf1.a < 0.01) discard;
#if ICE_DEBUG_MODE == 1
_yssmf1.rgb = vec3(1.0, 1.0, 1.0);
#endif
gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(0.95, 0.0, skylight, 0.0);
gl_FragData[2] = vec4(0.0);
gl_FragData[3] = vec4(0.0);
gl_FragData[4] = vec4(0.0);
return;
}

int et = int(emissiveType + 0.5);
if (et == 43 && emissive > 0.5) {
float _epnlyn = fract(sin(dot(texcoord * 8.0 + vec2(frameTimeCounter * 0.3), vec2(12.9898, 78.233))) * 43758.5453);
vec3 _90ybhd = vec3(0.1, 0.5, 0.4);
vec3 _ff9b3u = vec3(0.3, 0.9, 0.7);
_yssmf1 = vec4(mix(_90ybhd, _ff9b3u, _epnlyn * 0.5 + 0.3), 1.0);
}

if (_yssmf1.a <= 0.001 || _yssmf1.a < alphaTestRef) {
discard;
}

if (isHologram > 0.5 && !gl_FrontFacing) {
discard;
}

if (!_9cwhip(biome) && !_z0kr59(biome)) {
#ifdef CHUNK_FADE_OUT_ENABLED
#ifndef DISTANT_HORIZONS
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
if (_yssmf1.a < 0.01) {
discard;
}
}
#endif
#endif
}

#ifndef MAGICAL_TOUCH
vec3 _3v9zqi = normalize(mat3(gbufferModelViewInverse) * normal);
_yssmf1.rgb *= _7q50sc(_3v9zqi);
#endif

vec3 _dwo81a = _yssmf1.rgb;
vec3 _pq1dl3 = vec3(0.0);
float _led594 = emissive;
float _9dnv8b = 0.0;
#ifdef PBR_ENABLED
if (_led594 < 0.5) {
_9dnv8b = _k86yw1(texture(specular, texcoord));
}
#endif
#ifdef LPV_ENABLED

_pis44d = _dwo81a;
_06143i = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
_n7k2vf = 1.0;
#endif

if (_led594 > 0.5) {
int t = int(emissiveType + 0.5);
if (t == 68) {

float _f5dj31 = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
float _anidwx = smoothstep(0.10, 0.70, _f5dj31);
float _03qgyw = mix(0.55, 1.95, _anidwx * _anidwx);
_yssmf1.rgb = _dwo81a * EMISSIVE_BRIGHTNESS * 2.5 * _03qgyw;
_pq1dl3 = vec3(0.6, 0.1, 1.0) * 3.0;
} else if (t == 43) {

float _epnlyn = fract(sin(dot(texcoord * 8.0 + vec2(frameTimeCounter * 0.3), vec2(12.9898, 78.233))) * 43758.5453);
vec3 _90ybhd = vec3(0.1, 0.5, 0.4);
vec3 _ff9b3u = vec3(0.3, 0.9, 0.7);
_yssmf1.rgb = mix(_90ybhd, _ff9b3u, _epnlyn * 0.5 + 0.3) * EMISSIVE_BRIGHTNESS;
_pq1dl3 = vec3(0.2, 0.8, 0.6) * 3.0;
} else {
_yssmf1.rgb = _dwo81a * EMISSIVE_BRIGHTNESS * 2.5;
_pq1dl3 = vec3(1.0, 0.7, 0.4);
}
_pq1dl3 *= EMISSIVE_BRIGHTNESS;
} else {

#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _6xm99w(_yssmf1.rgb, sunAngle, skylight, blocklight, worldPos.y);
#ifdef HANDHELD_LIGHT_ENABLED
_yssmf1.rgb += _6p2kch(worldPos, _dwo81a, _yssmf1.rgb);
#endif
}
_yssmf1.rgb *= TERRAIN_BRIGHTNESS;

#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
_led594 = max(_led594, _9dnv8b);
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS);
_pq1dl3 = max(_pq1dl3, _7qz11m(_dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS));
}
#endif

vec4 _ilae1x = vec4(0.0);
vec4 _nv3ina = vec4(0.0);
if (isHologram > 0.5) {
_ilae1x = vec4(max(_dwo81a, vec3(0.0)), 0.6);
#ifdef MATERIAL_REFLECTIONS_ENABLED
vec3 _oi22up = normalize(mat3(gbufferModelViewInverse) * normal);
if (!gl_FrontFacing) _oi22up = -_oi22up;
vec3 _xvgd0e = _oi22up * 0.5 + 0.5;
float _qrchws = dot(max(_kmc7x2, vec3(0.0)), vec3(0.299, 0.587, 0.114));
float _e8usq7 = smoothstep(0.08, 0.72, _qrchws);
float _4u7b0m = pow(1.0 - _e8usq7, 2.0);
float _ks8bl1 = _uaiic5(_oi22up.z);
_nv3ina = vec4(_4u7b0m, _ks8bl1, _xvgd0e.x, _xvgd0e.y);
#endif
}

if (_led594 < 0.5) {
float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
_yssmf1.rgb = mix(_1jzgf0(), _yssmf1.rgb, _lr3hjh);
}

_yssmf1.a = 1.0;
#if ICE_DEBUG_MODE == 1
_yssmf1.rgb = vec3(1.0, 1.0, 1.0);
#endif
gl_FragData[0] = _yssmf1;

gl_FragData[1] = vec4(0.95, _led594, skylight, 0.0);
gl_FragData[2] = vec4(_pq1dl3, 1.0);
gl_FragData[3] = _ilae1x;
gl_FragData[4] = _nv3ina;
}
