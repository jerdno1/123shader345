#include "/settings.glsl"

#include "/include/hovering.glsl"

out vec2 texcoord;
out vec4 glcolor;
out vec3 worldPos;
out vec3 normal;
flat out float isHologram;
out vec3 viewPos;
out float skylight;
out float blocklight;
out float viewDistance;
flat out float emissive;
flat out float emissiveType;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

attribute vec4 mc_Entity;

void main() {
texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

int _ykf7bd = int(mc_Entity.x);
bool _05axw5 = (_ykf7bd >= 10000);
int _hwevwv = _05axw5 ? (_ykf7bd - 10000) : 0;

if (_05axw5) {
float _g7jk3o = max(max(gl_Color.r, gl_Color.g), gl_Color.b);
vec3 _2bhl0x = (_g7jk3o > 0.15) ? (gl_Color.rgb / _g7jk3o) : gl_Color.rgb;
glcolor = vec4(_2bhl0x, gl_Color.a);
} else {
glcolor = gl_Color;
}

viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
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

bool isIce = (_hwevwv == 8);
bool _8c84yh = false;
bool _n5tvnf = (_hwevwv == 80 || (_hwevwv >= 64 && _hwevwv <= 79));
isHologram = (_05axw5 && _n5tvnf && !isIce) ? 1.0 : 0.0;

bool _o2s36w = (_hwevwv == 88 || _hwevwv == 63);
emissive = _o2s36w ? 1.0 : 0.0;
emissiveType = float(_hwevwv - 20);
}
