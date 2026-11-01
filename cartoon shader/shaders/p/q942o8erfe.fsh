/* RENDERTARGETS: 0,1,3 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/color_utils.glsl"

uniform sampler2D gtexture;
uniform float alphaTestRef;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float fogStart;
uniform float fogEnd;
uniform float sunAngle;
uniform int biome;
uniform int biome_category;
uniform vec3 cameraPosition;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;

in vec2 texcoord;
in vec4 glcolor;
in float viewDistance;
in float emissive;
in vec3 worldPos;

#include "/include/fog_color.glsl"

#include "/include/noise.glsl"

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;

if (_yssmf1.a < alphaTestRef) {
discard;
}

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
if (_yssmf1.a < 0.01) discard;
}
}
#endif

_yssmf1.rgb *= EMISSIVE_BRIGHTNESS;

bool _a7qvpx = false;
#ifdef NETHER_FOG_ENABLED
_a7qvpx = _9cwhip(biome);
#endif
if (!_a7qvpx) {
float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
_yssmf1.rgb = mix(_1jzgf0(), _yssmf1.rgb, _lr3hjh);
}

gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(1.0, emissive, 0.0, 0.5);
gl_FragData[2] = vec4(_yssmf1.rgb, 1.0);
}
