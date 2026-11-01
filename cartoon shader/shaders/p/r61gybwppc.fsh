/* RENDERTARGETS: 7,1,3 */

#include "/settings.glsl"

uniform sampler2D gtexture;
uniform float alphaTestRef;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform float viewWidth;
uniform float viewHeight;
uniform int isEyeInWater;
uniform float biome_swamp;
uniform int frameCounter;
uniform vec3 cameraPosition;

#include "/include/lighting.glsl"
#include "/include/entity_particle_depth.glsl"

in vec2 texcoord;
in vec4 glcolor;
in vec3 worldPos;
in vec3 normal;
in float isHologram;

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
if (_na31gs()) discard;

float _xgal31 = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
float _5r47x0 = _yssmf1.r - _yssmf1.b;

float emissive = 0.0;

if (_xgal31 > 0.7 || (_5r47x0 > 0.2 && _xgal31 > 0.4)) {
emissive = 1.0;
_yssmf1.rgb *= EMISSIVE_BRIGHTNESS;
}

#if ICE_DEBUG_MODE == 1
_yssmf1.rgb = vec3(1.0, 0.5, 0.0);
#endif
gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(0.0, emissive, 0.0, 0.0);
gl_FragData[2] = vec4(0.0);
}
