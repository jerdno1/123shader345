#include "/settings.glsl"

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

out vec2 texcoord;
out vec4 glcolor;

void main() {

vec3 _hvdnw7 = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _kc9dhs = (gbufferModelViewInverse * vec4(_hvdnw7, 1.0)).xyz;
vec3 _y018ew = _kc9dhs + cameraPosition;

_kc9dhs = _y018ew - cameraPosition;
_hvdnw7 = (gbufferModelView * vec4(_kc9dhs, 1.0)).xyz;
gl_Position = gl_ProjectionMatrix * vec4(_hvdnw7, 1.0);

texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
glcolor = gl_Color;
}
