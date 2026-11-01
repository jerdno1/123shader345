#include "/settings.glsl"

out vec2 uv;
out vec3 viewPos;
out vec4 tint;

void main() {
uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
tint = gl_Color;

viewPos = mat3(gl_ModelViewMatrix) * gl_Vertex.xyz;

vec4 _gpy6je = gl_Vertex;

#ifdef SUN_MOON_SIZE_ENABLED
_gpy6je.xyz *= SUN_MOON_SCALE;
#endif

gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * _gpy6je;

}
