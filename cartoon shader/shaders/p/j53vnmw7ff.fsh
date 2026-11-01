/* RENDERTARGETS: 0,12 */

const bool _6ugx7s = false;

#include "/settings.glsl"

in vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D colortex12;
uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform int frameCounter;

void main() {
vec4 _61efsu = texture(colortex0, texcoord);
gl_FragData[0] = _61efsu;
gl_FragData[1] = vec4(0.0);
}
