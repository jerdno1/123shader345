#include "/settings.glsl"

#include "/include/waving.glsl"
#include "/include/hovering.glsl"
#include "/include/shadow.glsl"
#include "/include/ocean_waves.glsl"

const float _b0rv5t = 0.0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;
uniform float sunAngle;
uniform int frameCounter;
uniform float biome_beach;
uniform float biome_ocean;
uniform float biome_swamp;
out vec2 texcoord;
out vec4 glcolor;
out float viewDistance;
out float postMask;
out float isWater;
out float isHologram;
out vec3 worldPos;
out vec3 viewPos;
out vec3 normal;
out float skylight;
out float blocklight;
out vec3 waveNormal;
out float waveHeight;
out vec4 shadowPos;
flat out float isIce;
flat out float isHeatSource;
flat out int blockId;
out float waterBlockFracY;
out float waterFlowFlag;
#ifdef PBR_ENABLED
out vec3 tangentVec;
out vec3 binormalVec;
#endif

attribute vec4 mc_Entity;
attribute vec4 at_midBlock;
#ifdef PBR_ENABLED
attribute vec4 at_tangent;
#endif

void main() {
texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
glcolor = gl_Color;
viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _h4gwes = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec3 _y018ew = _h4gwes + cameraPosition;

int _ykf7bd = int(mc_Entity.x);
bool _05axw5 = (_ykf7bd >= 10000);
int _hwevwv = _05axw5 ? (_ykf7bd - 10000) : 0;
bool _qg5hoq = (_05axw5 && _hwevwv == 1);

float _nq4gm2 = floor(_y018ew.y);
float _3yl73c = _y018ew.y - _nq4gm2;

float _ld3fls = abs(_3yl73c - 0.875);

waterBlockFracY = clamp(_ld3fls * 4.0, 0.0, 1.0);

waterFlowFlag = (_ld3fls > 0.05) ? 1.0 : 0.0;

waveNormal = vec3(0.0, 1.0, 0.0);
waveHeight = 0.0;
#ifdef WATER_WAVES_ENABLED

#define WAVE_RAW(f) (smoothstep(0.15, 0.25, f) * (1.0 - pow(smoothstep(0.25, 1.15, f), 0.45)))
#define WAVE(px) WAVE_RAW(1.0 - fract(px))

#define OWAVE(px) (pow(0.5 + 0.5 * sin((fract(px) - 0.25) * 6.2832), 1.6))
#define SMAX(a, b, k) (max(a, b) + pow(max(k - abs(a - b), 0.0) / k, 3.0) * k * 0.166667)

bool _8jbl1a = abs(_y018ew.y - float(SEA_LEVEL_OFFSET)) < 1.0;
float _n4k7cp = biome_beach;
#ifdef BEACH_WAVES_EVERYWHERE
_n4k7cp = 1.0;
#endif
if (_qg5hoq && gl_Normal.y > 0.5 && _n4k7cp > 0.01 && _n4k7cp >= biome_ocean && _8jbl1a) {

float t = frameTimeCounter * WATER_WAVE_SPEED;
float wx = _y018ew.x * WATER_WAVE_SCALE;
float wz = _y018ew.z * WATER_WAVE_SCALE;
float _36zwff = 1.0 - smoothstep(48.0, 80.0, length(_y018ew.xz - cameraPosition.xz));
float _jkk37u = 0.8 * _n4k7cp * _36zwff;

float _k2dif7 = sin(wz * 0.21 + 3.7) * 2.5 + sin(wz * 0.53 + 1.2) * 1.3;
float _5wqi8l = sin(wz * 0.37 + 5.1) * 1.8 + sin(wz * 0.71 + 2.8) * 1.1;
float _4dso50 = sin(wz * 0.62 + 0.9) * 1.2 + sin(wz * 0.89 + 4.3) * 0.8;

float w1 = WAVE((wx * 0.8 + _k2dif7 - t * 1.0) / 6.2832);
float w2 = WAVE((wx * 1.8 + _5wqi8l - t * 1.6) / 6.2832);
float height = clamp(SMAX(w1, w2 * 0.55, 0.15), 0.0, 1.0);
height += WAVE((wx * 4.0 + _4dso50 - t * 2.2) / 6.2832) * 0.15 * height;

float _33gbao = -_jkk37u * (1.0 - height);
_y018ew.y += _33gbao;
waveHeight = clamp(height, 0.0, 1.0);

float _9x1fsz = 0.05;
float _mpb753 = (_y018ew.x + _9x1fsz) * WATER_WAVE_SCALE;
float _e169xt = (_y018ew.z + _9x1fsz) * WATER_WAVE_SCALE;

float hx = clamp(SMAX(WAVE((_mpb753 * 0.8 + _k2dif7 - t) / 6.2832), WAVE((_mpb753 * 1.8 + _5wqi8l - t * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
hx += WAVE((_mpb753 * 4.0 + _4dso50 - t * 2.2) / 6.2832) * 0.15 * hx;

float _yy5akm = sin(_e169xt * 0.21 + 3.7) * 2.5 + sin(_e169xt * 0.53 + 1.2) * 1.3;
float _cgpxz9 = sin(_e169xt * 0.37 + 5.1) * 1.8 + sin(_e169xt * 0.71 + 2.8) * 1.1;
float _ari0z1 = sin(_e169xt * 0.62 + 0.9) * 1.2 + sin(_e169xt * 0.89 + 4.3) * 0.8;
float hz = clamp(SMAX(WAVE((wx * 0.8 + _yy5akm - t) / 6.2832), WAVE((wx * 1.8 + _cgpxz9 - t * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
hz += WAVE((wx * 4.0 + _ari0z1 - t * 2.2) / 6.2832) * 0.15 * hz;

float _sua1ci = (-_jkk37u * (1.0 - hx) - _33gbao) / _9x1fsz;
float _w49331 = (-_jkk37u * (1.0 - hz) - _33gbao) / _9x1fsz;
waveNormal = normalize(vec3(-_sua1ci, 1.0, -_w49331));

} else if (_qg5hoq && gl_Normal.y > 0.5 && biome_swamp < 0.01) {

waveHeight = 0.5;
waveNormal = vec3(0.0, 1.0, 0.0);
}
#undef WAVE
#undef WAVE_RAW
#undef OWAVE
#undef SMAX
#endif

float _n47zda = _2kkryz(_y018ew);
_y018ew.y += _n47zda;
_h4gwes = _y018ew - cameraPosition;
viewPos = (gbufferModelView * vec4(_h4gwes, 1.0)).xyz;
gl_Position = gl_ProjectionMatrix * vec4(viewPos, 1.0);

worldPos = _y018ew;
viewDistance = length(viewPos);

normal = normalize(gl_NormalMatrix * gl_Normal);
#ifdef PBR_ENABLED
tangentVec = normalize(gl_NormalMatrix * at_tangent.xyz);
binormalVec = normalize(cross(normal, tangentVec) * at_tangent.w);
#endif

isWater = _qg5hoq ? 1.0 : 0.0;
bool _czpz57 = (_05axw5 && _hwevwv == 8);
isIce = _czpz57 ? 1.0 : 0.0;
bool _su0dny = (_05axw5 && _hwevwv == 14);
postMask = (isWater > 0.5) ? 0.0 : 1.0;

isHologram = (_05axw5 && _hwevwv >= 64 && _hwevwv <= 80) ? 1.0 : 0.0;
bool _5bc65s = (_hwevwv == 20 || _hwevwv == 21 || _hwevwv == 22 || _hwevwv == 36 || _hwevwv == 39 || _hwevwv == 40);
isHeatSource = (_05axw5 && _5bc65s) ? 1.0 : 0.0;
blockId = _hwevwv;

vec2 lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
blocklight = clamp(lmcoord.x, 0.0, 1.0);
skylight = clamp(lmcoord.y, 0.0, 1.0);

#ifdef SWAYING_LANTERNS
if (_05axw5 && (_hwevwv == 6 || _hwevwv == 89)) {
_y018ew = _88bpsk(_y018ew, false, skylight, _hwevwv, at_midBlock.xyz);
_h4gwes = _y018ew - cameraPosition;
viewPos = (gbufferModelView * vec4(_h4gwes, 1.0)).xyz;
gl_Position = gl_ProjectionMatrix * vec4(viewPos, 1.0);
worldPos = _y018ew;
viewDistance = length(viewPos);
}
#endif

shadowPos = vec4(0.0);
#ifdef SHADOWS_ENABLED
vec4 _hh4bkg = shadowProjection * shadowModelView * vec4(_h4gwes, 1.0);
vec3 _85c9ns = _hh4bkg.xyz;
float _c4cke4 = _ckk90a(_85c9ns);
vec3 _g9b9g4 = _2y5umb(_85c9ns);
shadowPos.xyz = _g9b9g4 * 0.5 + 0.5;

vec4 _luwc0h = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * normal), 1.0);
shadowPos.xyz += _luwc0h.xyz / _luwc0h.w * _c4cke4;
shadowPos.w = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));
#endif
}
