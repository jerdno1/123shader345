const float _b0rv5t = 0.0;

#include "/settings.glsl"

#if TERRAIN_PROFILE_MODE == 17
#undef WAVING_PLANTS
#elif TERRAIN_PROFILE_MODE == 18
#undef WAVING_LEAVES
#elif TERRAIN_PROFILE_MODE == 19
#undef PLAYER_PLANT_INTERACTION
#elif TERRAIN_PROFILE_MODE == 20
#undef WAVING_PLANTS
#undef WAVING_LEAVES
#undef PLAYER_PLANT_INTERACTION
#undef SWAYING_LANTERNS
#elif TERRAIN_PROFILE_MODE == 21
#undef WAVING_PLANTS
#undef WAVING_LEAVES
#undef PLAYER_PLANT_INTERACTION
#undef SWAYING_LANTERNS
#endif

#include "/include/waving.glsl"
#include "/include/hovering.glsl"
#include "/include/shadow.glsl"

out vec2 texcoord;
out vec2 midTexCoord;
out vec4 glcolor;
out float viewDistance;
out float outlineMask;
out float skylight;
out float blocklight;
flat out float emissive;
flat out float emissiveType;
out vec3 worldPos;
flat out vec3 blockCenterWorld;
flat out float isGrassGeometry;
flat out float isHeatSource;
flat out float isHologram;
flat out float metalness;
flat out float reflective;
out vec4 shadowPos;
out vec3 normal;
flat out vec3 geoNormal;
flat out float blockId;
out float leafAO;
#ifdef PBR_ENABLED
out vec3 tangentVec;
out vec3 binormalVec;
#endif

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;
attribute vec4 at_midBlock;
#ifdef PBR_ENABLED
attribute vec4 at_tangent;
#endif

float _frqi0d(float _if90p5) {
return mix(0.12, 1.0, smoothstep(0.08, 0.45, _if90p5));
}

void main() {

shadowPos = vec4(0.0);
texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
midTexCoord = (gl_TextureMatrix[0] * mc_midTexCoord).xy;
outlineMask = 1.0;

float _g7jk3o = max(max(gl_Color.r, gl_Color.g), gl_Color.b);
vec3 _2bhl0x = (_g7jk3o > 0.001) ? (gl_Color.rgb / _g7jk3o) : gl_Color.rgb;

skylight = clamp(gl_MultiTexCoord1.y / 240.0, 0.0, 1.0);
blocklight = clamp(gl_MultiTexCoord1.x / 240.0, 0.0, 1.0);

vec2 uv = texcoord;
bool _ziieqn = uv.y < mc_midTexCoord.y;

int _ykf7bd = int(mc_Entity.x);
bool _05axw5 = (_ykf7bd >= 10000);
int _hwevwv = _05axw5 ? (_ykf7bd - 10000) : 0;
blockId = float(_ykf7bd);

if (_05axw5) {
#ifdef MAGICAL_TOUCH
bool _1k8tzg = (_hwevwv == 2 || _hwevwv == 3 || _hwevwv == 4 || _hwevwv == 5 || _hwevwv == 15 || _hwevwv == 18 || _hwevwv == 19 || _hwevwv == 82 || _hwevwv == 201 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62 || _w4fwrl(_hwevwv));
#else
bool _1k8tzg = false;
#endif
if (_1k8tzg) {
outlineMask = 0.0;
}

bool _o2s36w = (_hwevwv >= 20 && _hwevwv <= 59) || _hwevwv == 6 || _hwevwv == 83 || _hwevwv == 84 || _hwevwv == 85 || _hwevwv == 86 || _hwevwv == 87 || _hwevwv == 89 || (_hwevwv >= 95 && _hwevwv <= 97);
emissive = _o2s36w ? 1.0 : 0.0;

float _a10c49 = (_hwevwv >= 95 && _hwevwv <= 97) ? 5.0 : float(_hwevwv - 20);

float _i45omk = (_hwevwv == 83) ? 40.0 : (_hwevwv == 84) ? 41.0 : _a10c49;
emissiveType = (_hwevwv == 85) ? 44.0 : (_hwevwv == 86) ? 45.0 : (_hwevwv == 87) ? 46.0 : (_hwevwv == 89) ? 47.0 : _i45omk;

bool _z69n8x = (_hwevwv == 20 || _hwevwv == 21 || _hwevwv == 22 || _hwevwv == 36 || _hwevwv == 39 || _hwevwv == 40);
isHeatSource = _z69n8x ? 1.0 : 0.0;

bool _n5tvnf = (_hwevwv == 14 || _hwevwv == 80 || (_hwevwv >= 64 && _hwevwv <= 79));
isHologram = _n5tvnf ? 1.0 : 0.0;

if (_hwevwv == 12 || _hwevwv == 90 || _hwevwv == 92) {
metalness = 1.0;
} else if (_hwevwv == 13) {
metalness = 2.0;
} else {
metalness = 0.0;
}

reflective = (_hwevwv == 17 || _hwevwv == 12 || _hwevwv == 13 || _hwevwv == 91 || _hwevwv == 92) ? 1.0 : 0.0;
} else {

emissive = 0.0;
emissiveType = 0.0;
isHeatSource = 0.0;
isHologram = 0.0;
metalness = 0.0;
reflective = 0.0;
}

glcolor = vec4(_2bhl0x, gl_Color.a);
leafAO = 0.0;

bool _tgu3yk = false;
#ifdef WAVING_PLANTS
_tgu3yk = _tgu3yk || (_hwevwv == 2 || _hwevwv == 3 || _hwevwv == 4 || _hwevwv == 15 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62 || _w4fwrl(_hwevwv));
#endif
#ifdef WAVING_LEAVES
_tgu3yk = _tgu3yk || _l8jcrt(_hwevwv);
#endif
#ifdef SWAYING_LANTERNS
_tgu3yk = _tgu3yk || (_hwevwv == 6 || _hwevwv == 89);
#endif

_tgu3yk = _tgu3yk && _05axw5;

normal = normalize(gl_NormalMatrix * gl_Normal);
geoNormal = normal;
#ifdef PBR_ENABLED
tangentVec = normalize(gl_NormalMatrix * at_tangent.xyz);
binormalVec = normalize(cross(normal, tangentVec) * at_tangent.w);
#endif

if (!_tgu3yk) {
vec3 _hvdnw7 = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _kc9dhs = (gbufferModelViewInverse * vec4(_hvdnw7, 1.0)).xyz;
vec3 _krxp3b = _kc9dhs + cameraPosition;

vec3 _dowst9 = gl_Vertex.xyz + at_midBlock.xyz / 64.0;
vec3 _pqax80 = (gl_ModelViewMatrix * vec4(_dowst9, 1.0)).xyz;
vec3 _68swpa = (gbufferModelViewInverse * vec4(_pqax80, 1.0)).xyz;
blockCenterWorld = _68swpa + cameraPosition;

float _n47zda = _2kkryz(_krxp3b);
_krxp3b.y += _n47zda;
if (_hwevwv == BLOCK_CAZ_LEAF1) {
_krxp3b += _9sxz35(blockCenterWorld);
}
_kc9dhs = _krxp3b - cameraPosition;
_hvdnw7 = (gbufferModelView * vec4(_kc9dhs, 1.0)).xyz;
gl_Position = gl_ProjectionMatrix * vec4(_hvdnw7, 1.0);

worldPos = _krxp3b;
viewDistance = length(_hvdnw7);

bool _t0ylwh = _05axw5 && (_hwevwv == 2 || _hwevwv == 3 || _hwevwv == 4 || _hwevwv == 15 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62 || _w4fwrl(_hwevwv));
vec3 n = abs(gl_Normal);
float _uit0o9 = max(max(n.x, n.y), n.z);
bool _rqagzg = _uit0o9 > 0.95;
bool _ymq5lz = _t0ylwh && !_rqagzg;
isGrassGeometry = _ymq5lz ? 1.0 : 0.0;

#ifdef SHADOWS_ENABLED
float _if90p5 = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));

if (_ymq5lz || _w4fwrl(_hwevwv) || _l8jcrt(_hwevwv) || _hwevwv == 2 || _hwevwv == 18 || _hwevwv == 19 || _hwevwv == 81 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62) _if90p5 = 1.0;

{

vec4 _hh4bkg = shadowProjection * shadowModelView * vec4(_kc9dhs, 1.0);
vec3 _85c9ns = _hh4bkg.xyz;

float _c4cke4 = _ckk90a(_85c9ns);
_c4cke4 *= _frqi0d(_if90p5);

vec3 _g9b9g4 = _2y5umb(_85c9ns);

shadowPos.xyz = _g9b9g4 * 0.5 + 0.5;

vec4 normal = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
shadowPos.xyz += normal.xyz / normal.w * _c4cke4;
}
shadowPos.w = _if90p5;
#endif
return;
}

vec3 _hvdnw7 = (gl_ModelViewMatrix * gl_Vertex).xyz;
vec3 _kc9dhs = (gbufferModelViewInverse * vec4(_hvdnw7, 1.0)).xyz;
vec3 _y018ew = _kc9dhs + cameraPosition;

vec3 _dowst9 = gl_Vertex.xyz + at_midBlock.xyz / 64.0;
vec3 _pqax80 = (gl_ModelViewMatrix * vec4(_dowst9, 1.0)).xyz;
vec3 _68swpa = (gbufferModelViewInverse * vec4(_pqax80, 1.0)).xyz;
blockCenterWorld = _68swpa + cameraPosition;

#ifdef WAVING_PLANTS

bool _t0ylwh = (_hwevwv == 2 || _hwevwv == 3 || _hwevwv == 4 || _hwevwv == 15 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62 || _w4fwrl(_hwevwv));

vec3 n = abs(gl_Normal);
float _uit0o9 = max(max(n.x, n.y), n.z);
bool _rqagzg = _uit0o9 > 0.95;
bool _ymq5lz = _t0ylwh && !_rqagzg;
if (_hwevwv == 15 || _w4fwrl(_hwevwv)) {
vec3 n = normalize(gl_Normal);
float _qxf0ju = 1.0 - step(0.2, abs(n.y));
float _adc4s1 = step(0.98, max(abs(n.x), abs(n.z)));
float _cc8fhp = _qxf0ju * (1.0 - _adc4s1);
bool _ig8o2b = _8kqyj4(_hwevwv, gl_Vertex.xyz, at_midBlock.xyz, gl_Normal, _ziieqn);

bool _y10yj2 = (_hwevwv == 15 && _cc8fhp > 0.5) ||
_ig8o2b;
if (_y10yj2) {
vec3 _3lt2qk = _88bpsk(_y018ew, (_hwevwv == 15) ? _ziieqn : _ig8o2b, skylight, _hwevwv, at_midBlock.xyz);
_y018ew = _3lt2qk;
}
} else {
_y018ew = _88bpsk(_y018ew, _ziieqn, skylight, _hwevwv, at_midBlock.xyz);
}
isGrassGeometry = _ymq5lz ? 1.0 : 0.0;
#else
_y018ew = _88bpsk(_y018ew, _ziieqn, skylight, _hwevwv, at_midBlock.xyz);

bool _8h5gw9 = (_hwevwv == 2 || _hwevwv == 3 || _hwevwv == 4 || _hwevwv == 15 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62 || _w4fwrl(_hwevwv));
vec3 n2 = abs(gl_Normal);
float _hzw07z = max(max(n2.x, n2.y), n2.z);
bool _pk2boq = _hzw07z > 0.95;
bool _517kfd = _8h5gw9 && !_pk2boq;
isGrassGeometry = _517kfd ? 1.0 : 0.0;
#endif

float _n47zda = _2kkryz(_y018ew);
_y018ew.y += _n47zda;
if (_hwevwv == BLOCK_CAZ_LEAF1) {
_y018ew += _9sxz35(blockCenterWorld);
}
_kc9dhs = _y018ew - cameraPosition;
_hvdnw7 = (gbufferModelView * vec4(_kc9dhs, 1.0)).xyz;

gl_Position = gl_ProjectionMatrix * vec4(_hvdnw7, 1.0);

viewDistance = length(_hvdnw7);
worldPos = _y018ew;

#ifdef SHADOWS_ENABLED
float _if90p5 = dot(normalize(shadowLightPosition), normalize(gl_NormalMatrix * gl_Normal));

bool _dyvpbc = (_hwevwv == 15) && (max(max(abs(gl_Normal.x), abs(gl_Normal.y)), abs(gl_Normal.z)) < 0.95);
if (isGrassGeometry > 0.5 || _dyvpbc || _w4fwrl(_hwevwv) || _l8jcrt(_hwevwv) || _hwevwv == 2 || _hwevwv == 19 || _hwevwv == 81 || _hwevwv == 60 || _hwevwv == 61 || _hwevwv == 62) _if90p5 = 1.0;

{

vec4 _hh4bkg = shadowProjection * shadowModelView * vec4(_kc9dhs, 1.0);
vec3 _85c9ns = _hh4bkg.xyz;

float _c4cke4 = _ckk90a(_85c9ns);
_c4cke4 *= _frqi0d(_if90p5);

vec3 _g9b9g4 = _2y5umb(_85c9ns);

shadowPos.xyz = _g9b9g4 * 0.5 + 0.5;

vec4 normal = shadowProjection * vec4(mat3(shadowModelView) * (mat3(gbufferModelViewInverse) * (gl_NormalMatrix * gl_Normal)), 1.0);
shadowPos.xyz += normal.xyz / normal.w * _c4cke4;
}
shadowPos.w = _if90p5;
#endif
}
