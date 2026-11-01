out vec2 texcoord;
out vec4 glcolor;
out vec3 worldPos;
out vec3 normal;
out float isHologram;

uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;

attribute vec4 mc_Entity;

void main() {
gl_Position = ftransform();

texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
glcolor = gl_Color;

vec3 viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _h4gwes = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
worldPos = _h4gwes + cameraPosition;
normal = normalize(gl_NormalMatrix * gl_Normal);

int _ykf7bd = int(mc_Entity.x);
bool _05axw5 = (_ykf7bd >= 10000);
int _hwevwv = _05axw5 ? (_ykf7bd - 10000) : 0;

bool _n5tvnf = (_hwevwv == 14 || _hwevwv == 80 || (_hwevwv >= 64 && _hwevwv <= 79));
isHologram = (_05axw5 && _n5tvnf) ? 1.0 : 0.0;
}
