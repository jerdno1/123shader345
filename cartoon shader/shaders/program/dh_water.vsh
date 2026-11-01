#include "/settings.glsl"

#include "/include/hovering.glsl"
#include "/include/ocean_waves.glsl"

const float _b0rv5t = 0.0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

out vec4 vColor;
out float viewDistance;
out vec3 viewDir;
out vec3 viewPos;
out vec3 worldPos;
out vec3 normal;
out float skylight;
out float blocklight;
out float waveHeight;
out vec3 waveNormal;
flat out int materialId;

void main() {
vColor = gl_Color;

vec3 _fs2b60 = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _h4gwes = (gbufferModelViewInverse * vec4(_fs2b60, 1.0)).xyz;
vec3 _y018ew = _h4gwes + cameraPosition;

bool isWater = (dhMaterialId == DH_BLOCK_WATER);
waveHeight = 0.0;
waveNormal = vec3(0.0, 1.0, 0.0);

#ifdef WATER_WAVES_ENABLED
if (false) {
}
#endif

float _n47zda = _2kkryz(_y018ew);
_y018ew.y += _n47zda;
_h4gwes = _y018ew - cameraPosition;
_fs2b60 = (gbufferModelView * vec4(_h4gwes, 1.0)).xyz;
gl_Position = gl_ProjectionMatrix * vec4(_fs2b60, 1.0);

viewDistance = length(_fs2b60);
viewDir = normalize(_h4gwes);
viewPos = _fs2b60;
worldPos = _y018ew;

normal = normalize(gl_NormalMatrix * gl_Normal);

materialId = dhMaterialId;

vec2 _33xr0a = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
vec2 _sgak2o = clamp((_33xr0a - 0.03125) * 1.06667, 0.0, 1.0);
skylight = _sgak2o.y;
blocklight = _sgak2o.x;
}
