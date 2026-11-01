#include "/settings.glsl"

#include "/include/hovering.glsl"
#include "/include/shadow.glsl"

const float _b0rv5t = float(DH_AO_INTENSITY) / 100.0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

out vec4 vColor;
out float viewDistance;
out vec3 viewDir;
out vec3 normal;
out float NdotL;
out vec3 worldPos;
flat out int materialId;
out float skylight;
out float blockLight;
out vec4 shadowPos;

void main() {
vColor = gl_Color;

vec3 viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _h4gwes = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec3 _y018ew = _h4gwes + cameraPosition;

float _n47zda = _2kkryz(_y018ew);
_y018ew.y += _n47zda;
_h4gwes = _y018ew - cameraPosition;
viewPos = (gbufferModelView * vec4(_h4gwes, 1.0)).xyz;
gl_Position = gl_ProjectionMatrix * vec4(viewPos, 1.0);

viewDistance = length(viewPos);
viewDir = normalize(_h4gwes);
worldPos = _y018ew;

normal = normalize(gl_NormalMatrix * gl_Normal);

vec3 _xyc8gw = normalize(shadowLightPosition);
NdotL = dot(normal, _xyc8gw);

materialId = dhMaterialId;

vec2 _33xr0a = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
vec2 _sgak2o = clamp((_33xr0a - 0.03125) * 1.06667, 0.0, 1.0);
skylight = _sgak2o.y;
blockLight = _sgak2o.x;

#ifdef SHADOWS_ENABLED

vec4 _hh4bkg = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _85c9ns = _hh4bkg.xyz;

float _c4cke4 = _ckk90a(_85c9ns);

vec3 _g9b9g4 = _2y5umb(_85c9ns);

shadowPos.xyz = _g9b9g4 * 0.5 + 0.5;

vec4 _6094iq = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
shadowPos.xyz += _6094iq.xyz / _6094iq.w * _c4cke4;

shadowPos.w = NdotL;
#else
shadowPos = vec4(0.0);
#endif
}
