#include "/settings.glsl"
#include "/include/waving.glsl"
#include "/include/shadow.glsl"
#include "/include/hovering.glsl"

#ifdef LPV_ENABLED
#include "/include/lpv/lpv_common.glsl"
layout(r8ui) uniform writeonly uimage3D lpvVoxelImg;
#endif

out vec2 texcoord;
flat out int block_id_out;
out float grass_blade_mask_out;
flat out float grass_cube_mask_out;
flat out float leaf_flat_mask_out;
flat out int block_id_raw_out;
out float shaft_height_metric_out;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;
attribute vec3 at_midBlock;

vec3 _l1nqm3(mat4 m, vec3 p) {
return (m * vec4(p, 1.0)).xyz;
}

void main() {
texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

float skylight = clamp(gl_MultiTexCoord1.y / 240.0, 0.0, 1.0);
bool _ziieqn = texcoord.y < mc_midTexCoord.y;

int _ykf7bd = int(mc_Entity.x);
block_id_raw_out = _ykf7bd;
bool _savnz7 = (_ykf7bd == 20002 || _ykf7bd == 20003);
bool _05axw5 = (_ykf7bd >= 10000) && !_savnz7;
int _hwevwv = _05axw5 ? (_ykf7bd - 10000) : 0;
bool _hc558u = (_hwevwv == 201 || _ykf7bd == 10201);
float blocklight = clamp(gl_MultiTexCoord1.x / 240.0, 0.0, 1.0);
block_id_out = _hwevwv;
grass_blade_mask_out = 0.0;
grass_cube_mask_out = 1.0;
leaf_flat_mask_out = 0.0;

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

vec3 _gpy6je = _l1nqm3(gl_ModelViewMatrix, gl_Vertex.xyz);
vec3 _y018ew = _l1nqm3(shadowModelViewInverse, _gpy6je) + cameraPosition;

#ifdef LPV_ENABLED
if (_05axw5) {

bool _th3335 = (_hwevwv >= 90 && _hwevwv <= 93);
bool _0w3j2n = _w4fwrl(_hwevwv);
if (!_th3335 && !_0w3j2n) {
int _t30xgc = _hwevwv;
if (_hwevwv == 30) {
int _eslrwh = clamp(int(floor(blocklight * 15.0 + 0.5)), 1, 15);
_t30xgc = (_eslrwh >= 15) ? 30 : (100 + _eslrwh);
}

vec3 _hmlyeh = gl_Vertex.xyz + at_midBlock.xyz / 64.0;
if (_hc558u) {
_hmlyeh = gl_Vertex.xyz + at_midBlock.xyz / 64.0;
}
vec3 _6mok1m = (gl_ModelViewMatrix * vec4(_hmlyeh, 1.0)).xyz;
vec3 _gdm3gi = (shadowModelViewInverse * vec4(_6mok1m, 1.0)).xyz;
vec3 _8ejcsz = _cs4po4(_gdm3gi, cameraPosition);
if (_x3urej(_8ejcsz)) {
ivec3 _xibcy1 = _y5lpmz(_8ejcsz);
imageStore(lpvVoxelImg, _xibcy1, uvec4(uint(_t30xgc + 1), 0u, 0u, 0u));
}
}
}
#endif

if (_hwevwv == 15 || _w4fwrl(_hwevwv)) {
vec3 n = normalize(gl_Normal);
float _qxf0ju = 1.0 - step(0.2, abs(n.y));
float _adc4s1 = step(0.98, max(abs(n.x), abs(n.z)));
grass_blade_mask_out = (_hwevwv == 15)
? _qxf0ju * (1.0 - _adc4s1)
: (_ink644(_hwevwv, gl_Vertex.xyz, at_midBlock.xyz, gl_Normal) ? 1.0 : 0.0);

vec3 _c3dvye = abs(abs(at_midBlock.xyz) - vec3(32.0));
float _stgsoq = max(max(_c3dvye.x, _c3dvye.y), _c3dvye.z);
grass_cube_mask_out = (_hwevwv == 15) ? 1.0 - step(0.25, _stgsoq) : 1.0;
}

if (_hwevwv == 5 || _hwevwv == 82) {
vec3 _c3dvye = abs(abs(at_midBlock.xyz) - vec3(32.0));
float _stgsoq = max(max(_c3dvye.x, _c3dvye.y), _c3dvye.z);
leaf_flat_mask_out = step(0.25, _stgsoq);
}

if (_hc558u) {
vec3 _dowst9 = gl_Vertex.xyz + at_midBlock.xyz / 64.0;
vec3 _vq977m = _l1nqm3(gl_ModelViewMatrix, _dowst9);
vec3 _b1ydcs = _l1nqm3(shadowModelViewInverse, _vq977m) + cameraPosition;
vec3 _x9o9cb = sign(at_midBlock.xyz);
_x9o9cb = mix(vec3(1.0), _x9o9cb, step(vec3(0.001), abs(at_midBlock.xyz)));
vec3 _igxaf0 = _dowst9 - _x9o9cb * 0.5;
_gpy6je = _l1nqm3(gl_ModelViewMatrix, _igxaf0);
_y018ew = _l1nqm3(shadowModelViewInverse, _gpy6je) + cameraPosition;
if (_tgu3yk) {
vec3 _6ipq5s = _88bpsk(_b1ydcs, false, skylight, _hwevwv, vec3(0.0));
_y018ew += _6ipq5s - _b1ydcs;
}
_y018ew += _9sxz35(_b1ydcs);
}

if (_tgu3yk && !_hc558u) {
if (_hwevwv == 15) {

if (grass_blade_mask_out > 0.5) {
_y018ew = _88bpsk(_y018ew, _ziieqn, skylight, _hwevwv, at_midBlock.xyz);
}
} else if (_w4fwrl(_hwevwv)) {
if (grass_blade_mask_out > 0.5) {
_y018ew = _88bpsk(_y018ew, true, skylight, _hwevwv, at_midBlock.xyz);
}
} else {
_y018ew = _88bpsk(_y018ew, _ziieqn, skylight, _hwevwv, at_midBlock.xyz);
}
}

float _n47zda = _2kkryz(_y018ew);
_y018ew.y += _n47zda;
shaft_height_metric_out = _y018ew.y - cameraPosition.y;

_gpy6je = _l1nqm3(shadowModelView, _y018ew - cameraPosition);

gl_Position = gl_ProjectionMatrix * vec4(_gpy6je, 1.0);

gl_Position.xyz = _2y5umb(gl_Position.xyz);
}
