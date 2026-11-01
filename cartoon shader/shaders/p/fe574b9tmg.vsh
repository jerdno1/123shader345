#include "/settings.glsl"

#include "/include/shadow.glsl"
#include "/include/hovering.glsl"

out vec2 texcoord;
out vec4 glcolor;
out vec3 worldPos;
out vec3 normal;
out float isHologram;
out float skylight;
out float blocklight;
out float viewDistance;
out vec4 shadowPos;
flat out int blockIdOut;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 cameraPosition;

attribute vec4 mc_Entity;

void main() {
texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

glcolor = gl_Color;

vec3 viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _h4gwes = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec3 _y018ew = _h4gwes + cameraPosition;

float _n47zda = _2kkryz(_y018ew);
if (_n47zda != 0.0) {
_y018ew.y += _n47zda;
_h4gwes = _y018ew - cameraPosition;
viewPos = (gbufferModelView * vec4(_h4gwes, 1.0)).xyz;
}
gl_Position = gl_ProjectionMatrix * vec4(viewPos, 1.0);

worldPos = _y018ew;
normal = normalize(gl_NormalMatrix * gl_Normal);
viewDistance = length(viewPos);

vec2 lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
blocklight = clamp(lmcoord.x, 0.0, 1.0);
skylight = clamp(lmcoord.y, 0.0, 1.0);

int _ykf7bd = int(mc_Entity.x);
bool _05axw5 = (_ykf7bd >= 10000);
int _hwevwv = _05axw5 ? (_ykf7bd - 10000) : 0;
isHologram = (_05axw5 && _hwevwv == 80) ? 1.0 : 0.0;
blockIdOut = _hwevwv;

shadowPos = vec4(0.0);
#ifdef SHADOWS_ENABLED
{
vec4 _hh4bkg = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _85c9ns = _hh4bkg.xyz;
float _c4cke4 = _ckk90a(_85c9ns);
vec3 _g9b9g4 = _2y5umb(_85c9ns);
shadowPos.xyz = _g9b9g4 * 0.5 + 0.5;
vec4 _93y178 = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
shadowPos.xyz += _93y178.xyz / _93y178.w * _c4cke4;
shadowPos.w = 1.0;
}
#endif
}
