/* RENDERTARGETS: 7 */

#include "/settings.glsl"
#include "/include/entity_particle_depth.glsl"

uniform sampler2D gtexture;

in vec2 texcoord;
in vec4 glcolor;

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;
if (_yssmf1.a <= 0.001) discard;
if (_na31gs()) discard;

gl_FragData[0] = _yssmf1;
}
