/* RENDERTARGETS: 7,1 */

#include "/settings.glsl"
#include "/include/entity_particle_depth.glsl"

uniform sampler2D gtexture;
uniform sampler2D depthtex1;

in vec2 texcoord;
in vec4 glcolor;
in vec2 lmcoord;
in float viewDist;

void main() {

float skylight = lmcoord.y;
if (skylight < 0.8) discard;

float _1r3mt9 = texelFetch(depthtex1, ivec2(gl_FragCoord.xy), 0).r;
if (gl_FragCoord.z > _1r3mt9) discard;

vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;
_yssmf1.a *= clamp(RAIN_OPACITY, 0.0, 1.0);
if (_yssmf1.a <= 0.001) discard;
if (_na31gs()) discard;
#if ICE_DEBUG_MODE == 1
_yssmf1.rgb = vec3(0.0, 0.5, 0.0);
#endif
gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(1.0, 0.0, 0.0, 0.0);
}
