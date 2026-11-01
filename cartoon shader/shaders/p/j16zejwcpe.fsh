/* RENDERTARGETS: 0,1,3,5 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
#include "/include/hovering.glsl"
#include "/include/caztoon_leaf1_pixel_toon.glsl"

uniform sampler2D gtexture;
uniform sampler2D shadowtex0;
uniform float alphaTestRef;
uniform float sunAngle;
uniform vec3 fogColor;
uniform vec3 shadowLightPosition;
uniform int biome_category;
uniform float fogStart;
uniform float fogEnd;
uniform int isEyeInWater;
uniform float frameTimeCounter;
uniform vec3 cameraPosition;
uniform int frameCounter;
uniform mat4 gbufferModelViewInverse;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;

#include "/include/lighting.glsl"

in vec2 texcoord;
in vec4 glcolor;
in vec3 worldPos;
in vec3 normal;
in float isHologram;
in float skylight;
in float blocklight;
in float viewDistance;
in vec4 shadowPos;
flat in int blockIdOut;

#include "/include/fog_color.glsl"

float _w5dqoo(float x) {
return fract(sin(x * 12.9898) * 43758.5453);
}

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;

#ifdef TEXTURE_PALETTE_ENABLED
{
float _1pxkd6 = float(TEXTURE_PALETTE_LEVELS);
_yssmf1.rgb = floor(_yssmf1.rgb * _1pxkd6) / _1pxkd6;
}
#endif

if (_yssmf1.a < alphaTestRef) {
discard;
}

bool _ijp041 = _e4o816(blockIdOut);

#ifndef MAGICAL_TOUCH
vec3 _3v9zqi = normalize(mat3(gbufferModelViewInverse) * normal);
if (!_ijp041) {
_yssmf1.rgb *= _7q50sc(_3v9zqi);
}
#endif

vec3 _dwo81a = _yssmf1.rgb;
float _f4ks2j = skylight;
float emissive = 0.0;
#ifdef LPV_ENABLED

_pis44d = _dwo81a;
_06143i = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
_n7k2vf = 1.0;
#endif

#ifdef SHADOWS_ENABLED
if (shadowPos.w > 0.5 && emissive < 0.5) {
float _id7o0g = dot(normal, normalize(shadowLightPosition));
float _izh8vx = _h1jpqh(gl_FragCoord.xy, frameCounter);

vec3 _p43sug = shadowPos.xyz;
#ifdef PIXELATED_SHADOWS
vec2 _3g5hwx = _qrjbox(gtexture, texcoord);
_p43sug = _yqlisi(_p43sug, _3g5hwx);
#endif
_izh8vx = _e4hc8m(_izh8vx, _p43sug);

float r = _55535n(_p43sug.xy * 2.0 - 1.0);
float _w02w60 = r + SHADOW_DISTORTION;

float _w3e3up = 0.003;
float _kmd3qn = (SHADOW_NORMAL_BIAS * 0.0001) * (1.1 - _id7o0g);
vec3 _qxvw16 = _p43sug;
_qxvw16.z -= _w3e3up + _kmd3qn;

#ifdef MAGICAL_TOUCH
vec3 shadow = _qkmd9b(shadowtex0, shadowcolor0, _qxvw16, 0.0);
#else
vec3 shadow = _nmx2gt(shadowtex0, shadowcolor0, _qxvw16, _w02w60, _izh8vx, 0.0);
#endif

if (_ijp041) {
float _7fkei4 = 0.0;
#if defined(LPV_ENABLED) && defined(LEAF_VOXEL_SHADOW_ENABLED)
vec3 _btl8dm = floor(worldPos) + vec3(0.5);
vec3 _5vmf5k = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
_7fkei4 = _bw1uf9(_btl8dm, _5vmf5k);
#endif
_yssmf1.rgb = _8w1fma(_yssmf1.rgb, blockIdOut, _7fkei4);
shadow = vec3(1.0);
}

float _38pqcl = dot(shadow, vec3(0.299, 0.587, 0.114));

float _t1yd2i = max(skylight, min(_38pqcl * 0.50, 1.0 / 15.0));
_f4ks2j = _t1yd2i;

shadow = mix(vec3(1.0), shadow, SHADOW_OPACITY);

#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _iroce3(_yssmf1.rgb, sunAngle, _t1yd2i, blocklight, emissive, shadow, worldPos.y);
} else {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _rdf2ja(_yssmf1.rgb, sunAngle, skylight, blocklight, emissive, worldPos.y);
}
#else
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
if (_ijp041) {
_yssmf1.rgb = _8w1fma(_yssmf1.rgb, blockIdOut, 0.0);
}
_yssmf1.rgb = _rdf2ja(_yssmf1.rgb, sunAngle, skylight, blocklight, emissive, worldPos.y);
#endif
#ifdef HANDHELD_LIGHT_ENABLED
if (emissive < 0.5) _yssmf1.rgb += _6p2kch(worldPos, _dwo81a, _yssmf1.rgb);
#endif
_yssmf1.rgb *= TERRAIN_BRIGHTNESS;

float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
_yssmf1.rgb = mix(_1jzgf0(), _yssmf1.rgb, _lr3hjh);

gl_FragData[0] = _yssmf1;

gl_FragData[1] = vec4(0.95, emissive, _f4ks2j, 0.0);

vec3 _mxcjdz = vec3(0.0);
if (emissive > 0.5) {
_mxcjdz = _yssmf1.rgb * EMISSIVE_BRIGHTNESS;
}
gl_FragData[2] = vec4(_mxcjdz, 1.0);

gl_FragData[3] = vec4(0.0);
}
