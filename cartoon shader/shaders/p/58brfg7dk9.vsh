out vec2 texcoord;
out vec4 glcolor;
out vec2 lmcoord;
out float viewDist;

void main() {
vec2 uv = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
texcoord = uv;
glcolor = gl_Color;
lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;

viewDist = length(viewPos.xyz);
gl_Position = gl_ProjectionMatrix * viewPos;

}
