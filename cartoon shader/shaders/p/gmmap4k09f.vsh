#include "/settings.glsl"

#include "/include/shadow.glsl"

uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform int entityId;
uniform float frameTimeCounter;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

out vec2 texcoord;
out vec4 glcolor;
out vec3 worldPos;
out float skylight;
out float blocklight;
out float emissiveLayer;
out float viewDistance;
out float nametagHolo;
out vec4 shadowPos;
out vec3 normal;

void main() {
gl_Position = ftransform();

texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

emissiveLayer = (gl_MultiTexCoord1.x > 240.5 && gl_MultiTexCoord1.y > 239.5) ? 1.0 : 0.0;
skylight = clamp(gl_MultiTexCoord1.y / 240.0, 0.0, 1.0);
blocklight = clamp(gl_MultiTexCoord1.x / 240.0, 0.0, 1.0);

glcolor = gl_Color;

vec3 viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
viewDistance = length(viewPos);
vec3 _h4gwes = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
worldPos = _h4gwes + cameraPosition;

shadowPos = vec4(0.0);
#ifdef SHADOWS_ENABLED

normal = normalize(gl_NormalMatrix * gl_Normal);

vec4 _hh4bkg = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _85c9ns = _hh4bkg.xyz;
float _c4cke4 = _ckk90a(_85c9ns);
vec3 _g9b9g4 = _2y5umb(_85c9ns);
shadowPos.xyz = _g9b9g4 * 0.5 + 0.5;
vec4 _93y178 = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
shadowPos.xyz += _93y178.xyz / _93y178.w * _c4cke4;
shadowPos.w = 1.0;
#endif
nametagHolo = 0.0;
}
