#include "/settings.glsl"

#ifdef LPV_ENABLED

#include "/include/lpv/lpv_common.glsl"

layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;

const ivec3 workGroups = ivec3(32, 16, 32);

uniform usampler3D lpvVoxelSampler;

writeonly uniform image3D lpvLightA;
writeonly uniform image3D lpvLightB;

uniform sampler3D lpvLightSamplerA;
uniform sampler3D lpvLightSamplerB;

uniform int frameCounter;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform mat4 gbufferModelViewInverse;

ivec3 _7hfhb1(ivec3 p) {
return clamp(p, ivec3(0), _s41vj8 - ivec3(1));
}

int _308rn9(ivec3 _i3eo76) {
return int(texelFetch(lpvVoxelSampler, _7hfhb1(_i3eo76), 0).r) - 1;
}

bool _kppqut(ivec3 _i3eo76) {
return _98tocj(_308rn9(_i3eo76));
}

uint _lsrlmk(int blockId) {
const uint _dk17t2 = 0x3Fu;
const uint _zdx4zy = 0x33u;

if (blockId < 0) return _dk17t2;
if (_98tocj(blockId)) return 0u;

if (blockId == 5 || blockId == 82) return _zdx4zy;

return _dk17t2;
}

bool _irkzgi(uint _q4j75g, int _izgncn) {
return ((_q4j75g >> _izgncn) & 1u) != 0u;
}

vec3 _5a7zlg(sampler3D lightSampler, ivec3 _10f83d) {
return texelFetch(lightSampler, _7hfhb1(_10f83d), 0).rgb;
}

vec3 _rg6te5() {

return normalize(mat3(gbufferModelViewInverse) * vec3(0.0, 0.0, -1.0));
}

bool _54g5b0(ivec3 _gpy6je) {
#ifndef LPV_OPT_BEHIND_PLAYER_CULL
return false;
#else
vec3 _oaxqkx = (vec3(_gpy6je) + vec3(0.5) - _isafey) * _vfkrnc;
vec3 _josugg = abs(_oaxqkx);

if (_josugg.x + _josugg.y + _josugg.z <= 16.0) return false;
if (dot(_oaxqkx, _oaxqkx) <= 1.0) return false;

return dot(normalize(_oaxqkx), _rg6te5()) < -0.05;
#endif
}

bool _z31uhi(ivec3 _gpy6je) {
#ifndef LPV_OPT_HALF_RATE_SPREADING
return true;
#else
bool _d26h2c = _gpy6je.z >= (_s41vj8.z / 2);
bool _vhpo85 = (frameCounter & 1) != 0;
return _d26h2c == _vhpo85;
#endif
}

bool _oskrpa(ivec3 _gpy6je) {
vec3 _36074s = abs((vec3(_gpy6je) + vec3(0.5)) - _isafey);
float _5l6znc = max(max(_36074s.x, _36074s.y), _36074s.z);
float _avlfra = _fsho2m.x * 0.5 * clamp(LPV_RENDER_DISTANCE, 0.0, 1.0);

return _5l6znc > _avlfra + 2.0;
}

bool _tngis5(uint _mbzo8l, ivec3 _cdyb88, ivec3 _llxraj) {
int _2yqb47 = _308rn9(_cdyb88);

if (_98tocj(_2yqb47)) return false;

uint _r7qwdd = _lsrlmk(_2yqb47);

if (_llxraj.x < 0) return _irkzgi(_mbzo8l, 0) && _irkzgi(_r7qwdd, 1);
if (_llxraj.x > 0) return _irkzgi(_mbzo8l, 1) && _irkzgi(_r7qwdd, 0);
if (_llxraj.y < 0) return _irkzgi(_mbzo8l, 2) && _irkzgi(_r7qwdd, 3);
if (_llxraj.y > 0) return _irkzgi(_mbzo8l, 3) && _irkzgi(_r7qwdd, 2);
if (_llxraj.z < 0) return _irkzgi(_mbzo8l, 4) && _irkzgi(_r7qwdd, 5);
if (_llxraj.z > 0) return _irkzgi(_mbzo8l, 5) && _irkzgi(_r7qwdd, 4);

return false;
}

vec3 _eoy87l(sampler3D lightSampler, ivec3 _10f83d, ivec3 _cfpe4s) {
vec3 _idhca6 = vec3(0.0);
int _waiuhz = _308rn9(_cfpe4s);
uint _mbzo8l = _lsrlmk(_waiuhz);

ivec3 _llxraj = ivec3( 1, 0, 0);
if (_tngis5(_mbzo8l, _cfpe4s + _llxraj, _llxraj)) _idhca6 += _5a7zlg(lightSampler, _10f83d + _llxraj);
_llxraj = ivec3(-1, 0, 0);
if (_tngis5(_mbzo8l, _cfpe4s + _llxraj, _llxraj)) _idhca6 += _5a7zlg(lightSampler, _10f83d + _llxraj);
_llxraj = ivec3( 0, 1, 0);
if (_tngis5(_mbzo8l, _cfpe4s + _llxraj, _llxraj)) _idhca6 += _5a7zlg(lightSampler, _10f83d + _llxraj);
_llxraj = ivec3( 0,-1, 0);
if (_tngis5(_mbzo8l, _cfpe4s + _llxraj, _llxraj)) _idhca6 += _5a7zlg(lightSampler, _10f83d + _llxraj);
_llxraj = ivec3( 0, 0, 1);
if (_tngis5(_mbzo8l, _cfpe4s + _llxraj, _llxraj)) _idhca6 += _5a7zlg(lightSampler, _10f83d + _llxraj);
_llxraj = ivec3( 0, 0,-1);
if (_tngis5(_mbzo8l, _cfpe4s + _llxraj, _llxraj)) _idhca6 += _5a7zlg(lightSampler, _10f83d + _llxraj);

float _8rifx6 = 7.0 + 2.0 / (1.0 + 4.0 * max(LPV_RADIUS, 0.01));

_8rifx6 = max(_8rifx6 - 1.0, 6.0005);
return _idhca6 / _8rifx6;
}

vec3 _29w87z(sampler3D lightSampler, ivec3 _10f83d) {
vec3 _idhca6 = vec3(0.0);
_idhca6 += _5a7zlg(lightSampler, _10f83d + ivec3( 1,  0,  0));
_idhca6 += _5a7zlg(lightSampler, _10f83d + ivec3(-1,  0,  0));
_idhca6 += _5a7zlg(lightSampler, _10f83d + ivec3( 0,  1,  0));
_idhca6 += _5a7zlg(lightSampler, _10f83d + ivec3( 0, -1,  0));
_idhca6 += _5a7zlg(lightSampler, _10f83d + ivec3( 0,  0,  1));
_idhca6 += _5a7zlg(lightSampler, _10f83d + ivec3( 0,  0, -1));
return _idhca6 / 6.42;
}

void _651nmm(writeonly image3D writeImg, sampler3D readSampler) {
ivec3 _gpy6je = ivec3(gl_GlobalInvocationID);
if (any(greaterThanEqual(_gpy6je, _s41vj8))) return;

if (_oskrpa(_gpy6je)) {
imageStore(writeImg, _gpy6je, vec4(0.0));
return;
}

ivec3 _pov7tg = _gpy6je
- ivec3(floor(previousCameraPosition / _vfkrnc))
+ ivec3(floor(cameraPosition / _vfkrnc));

uint _nsxrfl = texelFetch(lpvVoxelSampler, _gpy6je, 0).r;
int blockId = int(_nsxrfl) - 1;

bool _g09cw8 = blockId >= 0 && _98tocj(blockId);
if (_g09cw8) {
imageStore(writeImg, _gpy6je, vec4(0.0));
return;
}

if (_54g5b0(_gpy6je)) {
return;
}

vec3 _czo6s6 = vec3(0.0);
vec3 _z6rtf0 = vec3(1.0);
float _tamecm = 1.0;

if (blockId >= 0) {

vec3 _q30s9y = _d56v3m(blockId);
_czo6s6 = _q30s9y * _q30s9y;
_z6rtf0 = _gs0fh0(blockId);
_tamecm = _2i50b2(blockId);

#ifdef LPV_DEBUG_GLASS_VOXELS

if (blockId == 64) {
_czo6s6 = vec3(250.0, 0.0, 0.0);
} else if (blockId == 68) {
_czo6s6 = vec3(0.0, 250.0, 0.0);
}
#endif
}

if (!_z31uhi(_gpy6je)) {
vec3 _hpi1n6 = _5a7zlg(readSampler, _pov7tg);
imageStore(writeImg, _gpy6je, vec4(max(_hpi1n6, _czo6s6), 1.0));
return;
}

#if LPV_ISOLATION_STAGE <= 1
vec3 _z73o4z = vec3(0.0);
#else
#if LPV_EDGE_AWARENESS != 0
vec3 _z73o4z = _eoy87l(readSampler, _pov7tg, _gpy6je);
#else
vec3 _z73o4z = _29w87z(readSampler, _pov7tg);
#endif
_z73o4z *= _z6rtf0 * _tamecm;
#endif

vec3 _oqmso0 = _z73o4z + _czo6s6;

imageStore(writeImg, _gpy6je, vec4(_oqmso0, 1.0));
}

void main() {
if ((frameCounter & 1) == 0) {
_651nmm(lpvLightA, lpvLightSamplerB);
} else {
_651nmm(lpvLightB, lpvLightSamplerA);
}
}

#else

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
const ivec3 workGroups = ivec3(1, 1, 1);
void main() {}

#endif
