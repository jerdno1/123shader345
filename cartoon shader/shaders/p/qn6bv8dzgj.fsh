/* RENDERTARGETS: 0,8 */
#extension GL_ARB_shader_storage_buffer_object : require

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

layout(std430, binding = 0) coherent buffer persistentBuffer {
float storedExposure;
float smoothBeach;
float smoothSwamp;
float smoothJungle;
float smoothSnowy;
float smoothArid;
float storedScreenSkylight;
float smoothOcean;
float smoothNetherFogR;
float smoothNetherFogG;
float smoothNetherFogB;
float smoothCaveFogR;
float smoothCaveFogG;
float smoothCaveFogB;
float storedAtmoSceneFactor;
float storedCaveFogTakeover;
float smoothBiomeFogR;
float smoothBiomeFogG;
float smoothBiomeFogB;
float smoothBiomeSkyR;
float smoothBiomeSkyG;
float smoothBiomeSkyB;
float smoothPaleGarden;
};

#define BIOME_COLOR_SMOOTHING_HAS_SSBO
#include "/include/biome_color_smoothing.glsl"

uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_savanna;

#ifdef CLOUDS_3D_ENABLED
#include "/include/volumetric_clouds.glsl"
#endif

#ifdef CLOUDS_VANILLA_ENABLED
#include "/include/vanilla_clouds.glsl"
#endif

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D dhDepthTex;

uniform float near;
uniform float far;
uniform float dhNearPlane;
uniform float dhFarPlane;
uniform float sunAngle;
uniform int worldDay;
uniform int worldTime;
uniform int frameCounter;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 shadowLightPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform int biome;
uniform int biome_category;
uniform float rainStrength;
uniform float thunderStrength;
uniform float wetness;
uniform int isEyeInWater;
uniform float frameTimeCounter;

in vec2 texcoord;

#include "/include/depth_utils.glsl"

float _1yyykw(vec2 uv, float _swfcra) {
float _co5r8t = _wf8ve2(_swfcra);
vec4 _8wjl9m = vec4(uv * 2.0 - 1.0, -1.0, 1.0);
vec4 _0bcjo7 = gbufferProjectionInverse * _8wjl9m;
_0bcjo7 /= _0bcjo7.w;
vec3 viewDir = normalize(_0bcjo7.xyz);
vec3 viewPos = viewDir * (_co5r8t / max(abs(viewDir.z), 0.001));
vec4 worldPos = gbufferModelViewInverse * vec4(viewPos, 1.0);
return worldPos.y + cameraPosition.y;
}

bool _3ljh0d() {
#ifdef END_SHADER
return true;
#else
#ifdef CAT_THE_END
return biome_category == CAT_THE_END;
#else
return _z0kr59(biome);
#endif
#endif
}

void main() {
vec3 _yssmf1 = texture(colortex0, texcoord).rgb;
vec3 _7iyinv = vec3(0.0);
float _xszwck = 0.0;
float _kyxyq3 = 0.0;

float _ips7jr = texture(dhDepthTex, texcoord).r;
bool _cqf0fr = _yfr6tv(_ips7jr);
float _2zs1mf = texture(depthtex0, texcoord).r;
float _b8i8m4 = texture(depthtex1, texcoord).r;
vec4 _alcc4c = texelFetch(colortex1, ivec2(gl_FragCoord.xy), 0);
bool _kt17lp = (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);

float _bo9fic = _kt17lp ? _2zs1mf : _b8i8m4;
bool _yjolhc = (_bo9fic >= 1.0);

vec3 _wr58r8;
float _i4dbff;
float _lxhvg4;

if (!_yjolhc && isEyeInWater != 1) {

float _7b4uat = _bo9fic;
vec4 _8wjl9m = vec4(texcoord * 2.0 - 1.0, _7b4uat * 2.0 - 1.0, 1.0);
vec4 viewPos = gbufferProjectionInverse * _8wjl9m;
viewPos /= viewPos.w;
vec3 worldPos = (gbufferModelViewInverse * viewPos).xyz + cameraPosition;
_wr58r8 = normalize(worldPos - cameraPosition);
float _0nlczg = length(worldPos - cameraPosition);
_i4dbff = _0nlczg;
_lxhvg4 = _0nlczg;
} else {

_wr58r8 = normalize(mat3(gbufferModelViewInverse) * (gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, 1.0, 1.0)).xyz);
_i4dbff = 30000.0;
_lxhvg4 = 30000.0;

if (isEyeInWater == 1 && !_yjolhc) {
float _7b4uat = _bo9fic;
vec4 _8wjl9m = vec4(texcoord * 2.0 - 1.0, _7b4uat * 2.0 - 1.0, 1.0);
vec4 viewPos = gbufferProjectionInverse * _8wjl9m;
viewPos /= viewPos.w;
float _0nlczg = length(viewPos.xyz);
_i4dbff = min(_i4dbff, _0nlczg);
_lxhvg4 = min(_lxhvg4, _0nlczg);
}

if (_cqf0fr) {
float _97i2f3 = _wf8ve2(_ips7jr);

vec4 _s3xu7p = vec4(texcoord * 2.0 - 1.0, 1.0, 1.0);
vec4 _51g9fx = gbufferProjectionInverse * _s3xu7p;
vec3 viewDir = normalize(_51g9fx.xyz / max(_51g9fx.w, 0.0001));
float _jr8s6z = _97i2f3 / max(-viewDir.z, 0.001);
float _gmuo4z = max(_jr8s6z - 1.0, 0.0);
_i4dbff = min(_i4dbff, _gmuo4z);
_lxhvg4 = min(_lxhvg4, _gmuo4z);
}
}

if (isEyeInWater == 1) {

float _lj1z7e = (float(SEA_LEVEL_OFFSET) - cameraPosition.y) / max(_wr58r8.y, 0.001);
vec2 _sx37ew = cameraPosition.xz + _wr58r8.xz * max(_lj1z7e, 0.0);
vec2 _1ie0vs = _sx37ew * 0.5;
float _23ypj8 = frameTimeCounter * WATER_WAVE_SPEED;
float _a5i6nt = cos(_1ie0vs.x * 2.0 + _1ie0vs.y * 0.7 + _23ypj8 * 1.2) * 0.3
+ cos(_1ie0vs.x * 1.3 - _1ie0vs.y * 1.8 + _23ypj8 * 0.8) * 0.2;
float _4npl6q = cos(_1ie0vs.y * 2.2 + _1ie0vs.x * 0.5 + _23ypj8 * 1.0) * 0.3
+ cos(_1ie0vs.y * 1.5 - _1ie0vs.x * 1.6 + _23ypj8 * 1.1) * 0.2;
_wr58r8 = normalize(_wr58r8 + vec3(_a5i6nt, 0.0, _4npl6q) * 0.02);
}

vec3 _2q6syd = _un92z1(skyColor);
float _rxs39p = _jpbsbi(biome_snowy);
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _9yfvgh = _za404r(biome_arid);
float _fgx2j8 = _g4a6za(_i0sr2e(biome_savanna), _lfojrz);
vec3 _9ubqqf = _8i3fbp(_2q6syd, _rxs39p, _2d13on, _lfojrz, _9yfvgh, _fgx2j8);
float _kw5y40 = max(dot(_9ubqqf, vec3(0.299, 0.587, 0.114)), 0.001);

float _kplpjq = fract(sunAngle);
float _xi2bec = smoothstep(0.0, 0.07, _kplpjq) * (1.0 - smoothstep(0.48, 0.57, _kplpjq)) * 0.75;

float _gy8koc = (1.0 - _9yfvgh) * (1.0 - _lfojrz);

_gy8koc *= mix(1.0, 0.2, clamp(biome_pale_garden, 0.0, 1.0));
float _v8e0m6 = (1.0 - wetness * (float(CLOUD_RAIN_OPACITY_REDUCTION) / 100.0)) * _gy8koc;

if (isEyeInWater == 1) _v8e0m6 *= 0.3;

#ifdef CLOUDS_VANILLA_ENABLED
if (!_3ljh0d() && !_9cwhip(biome)) {
vec3 _fc4vgl = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

float _p1vdvn = frameTimeCounter;

float _2nrne3 = 0.0;
vec4 _bmp86u = _l5e5we(_wr58r8, _p1vdvn, cameraPosition, sunAngle, _fc4vgl, _i4dbff, gl_FragCoord.xy, frameCounter, _2nrne3, _v8e0m6);
if (_bmp86u.a > 0.001) {

float _btza0b = max(dot(_bmp86u.rgb, vec3(0.299, 0.587, 0.114)), 0.001);
vec3 _ip9kzv = clamp(_9ubqqf * (_btza0b / _kw5y40), vec3(0.0), vec3(2.0));
_bmp86u.rgb = mix(_bmp86u.rgb, _ip9kzv, _xi2bec);
_7iyinv = _bmp86u.rgb;
_xszwck = max(_xszwck, _bmp86u.a);
_kyxyq3 = _2nrne3;
}
}
#endif

#ifdef CLOUDS_3D_ENABLED
if (!_3ljh0d() && !_9cwhip(biome)) {
vec3 _8bdauy = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _ci50nx = (float(worldDay) * 24000.0 + float(worldTime)) / 20.0;

float _tam685 = 0.0;
vec4 _zn4xbh = _z8z00o(_wr58r8, _ci50nx, cameraPosition, sunAngle, _8bdauy, _lxhvg4, gl_FragCoord.xy, frameCounter, _tam685);
_zn4xbh.a *= _v8e0m6;

if (_zn4xbh.a > 0.001) {
float _btza0b = max(dot(_zn4xbh.rgb, vec3(0.299, 0.587, 0.114)), 0.001);
vec3 _ip9kzv = clamp(_9ubqqf * (_btza0b / _kw5y40), vec3(0.0), vec3(2.0));
_zn4xbh.rgb = mix(_zn4xbh.rgb, _ip9kzv, _xi2bec);

_7iyinv = _7iyinv * (1.0 - _zn4xbh.a) + _zn4xbh.rgb;
_xszwck = max(_xszwck, _zn4xbh.a);
if (_tam685 > 0.0 && (_kyxyq3 <= 0.0 || _tam685 < _kyxyq3)) _kyxyq3 = _tam685;
}
}
#endif

gl_FragData[0] = vec4(_yssmf1, 1.0 - _xszwck);
gl_FragData[1] = vec4(_7iyinv, _xszwck > 0.001 ? _kyxyq3 : 0.0);
}
