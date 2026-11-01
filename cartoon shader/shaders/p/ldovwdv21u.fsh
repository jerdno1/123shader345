/* RENDERTARGETS: 0,14 */

const bool _tu3da4 = false;
const bool DEBUG_CAVE_FOG_ALPHA_VIEW = false;
const bool DEBUG_CAVE_FOG_DISTANCE_VIEW = false;

#include "/settings.glsl"
#include "/include/glass_reflection_payload.glsl"
#ifdef PBR_ENABLED
#include "/include/pbr.glsl"
#endif

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex7;
uniform sampler2D colortex8;
uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D colortex11;
uniform sampler2D colortex13;
uniform sampler2D colortex14;
uniform sampler2D colortex15;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D dhDepthTex;
uniform sampler2D dhDepthTex1;
uniform sampler2D vxDepthTexOpaque;
uniform sampler2D vxDepthTexTrans;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform mat4 dhProjection;
uniform mat4 dhProjectionInverse;
uniform mat4 vxProjInv;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform sampler2D shadowtex0;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform vec3 shadowLightPosition;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform float viewWidth;
uniform float viewHeight;
uniform float far;
uniform float near;
uniform float sunAngle;
uniform float dhFarPlane;
uniform float dhNearPlane;
uniform float darknessFactor;
uniform float darknessLightFactor;
uniform float blindness;
uniform float nightVision;

uniform int isEyeInWater;
uniform int biome;
uniform int biome_category;
uniform int worldDay;
uniform int worldTime;
uniform int frameCounter;
uniform int renderVanillaClouds;

#define FRAME_TIME_COUNTER_DECLARED
uniform float frameTimeCounter;
#define RAIN_STRENGTH_DECLARED
uniform float rainStrength;
uniform float thunderStrength;

uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_savanna;
uniform float biome_beach;
uniform float biome_ocean;
uniform vec3 fogColor;
uniform vec3 skyColor;

uniform ivec2 eyeBrightnessSmooth;

#ifdef HANDHELD_LIGHT_ENABLED
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;
uniform int heldItemId;
uniform int heldItemId2;
uniform vec3 eyePosition;
#endif

in vec2 texcoord;

#include "/include/biome_overrides.glsl"

#include "/include/depth_utils.glsl"
#include "/include/water_color.glsl"
#include "/include/ocean_waves.glsl"
#include "/include/color_utils.glsl"
#include "/include/sky_timeline.glsl"
#include "/include/voxy_compat.glsl"
#include "/include/noise.glsl"
#include "/include/shadow.glsl"
#include "/include/tornado_particles.glsl"
#ifdef HANDHELD_LIGHT_ENABLED
#include "/include/held_light_post.glsl"
#endif

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

#define SEA_LEVEL_OFFSET_DEFAULT 63
#ifndef SEA_LEVEL_OFFSET
#define SEA_LEVEL_OFFSET SEA_LEVEL_OFFSET_DEFAULT
#endif

#ifdef CLOUDS_3D_ENABLED
#include "/include/volumetric_clouds.glsl"
#endif
#ifdef CLOUDS_VANILLA_ENABLED
#include "/include/vanilla_clouds.glsl"
#endif
#include "/include/ilv_reflections.glsl"

#ifdef END_SHADER
#if defined(END_EVENT_ENABLED)
#include "/include/end_event.glsl"
#endif
#ifdef END_SKY_ENABLED
#include "/include/end_sky.glsl"
#endif
#endif

vec3 _asihvs();
vec3 _hbv38n();

bool _h6zv90() {
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

bool _0rit85() {
float _7nbmph = length(sunPosition);
float _ay4twu = length(shadowLightPosition);
vec3 _54cryr = max(skyColor, vec3(0.0));
vec3 _bs5gl8 = max(fogColor, vec3(0.0));
float _d3jt6o = max(max(_54cryr.r, _54cryr.g), _54cryr.b);
float _nyqdu3 = max(max(_bs5gl8.r, _bs5gl8.g), _bs5gl8.b);
bool _h2axle = (_7nbmph < 0.001 && _ay4twu < 0.001);
bool _6zglpi = (_d3jt6o < 0.06 && _nyqdu3 < 0.08);
return _6zglpi && _h2axle;
}

vec2 _drk3b8() {
vec3 _r8pxgv = normalize(shadowLightPosition);
vec3 _7pgc8e = _r8pxgv * 1000.0;
vec4 _f1qe0z = gbufferProjection * vec4(_7pgc8e, 1.0);
if (_f1qe0z.w <= 0.00001) return vec2(-1.0);
vec2 _siftnl = _f1qe0z.xy / _f1qe0z.w;
return _siftnl * 0.5 + 0.5;
}

vec4 _8agsfg(sampler2D _r4digw, vec2 uv) {
vec4 _rk79pn = texture(_r4digw, uv);
if (any(isnan(_rk79pn)) || any(isinf(_rk79pn)) || _rk79pn.a < 0.0 || _rk79pn.a > 1.0001) return vec4(0.0);
return max(_rk79pn, vec4(0.0));
}

vec4 _nwv54f(sampler2D _r4digw, vec2 uv) {
vec4 _rk79pn = _8agsfg(_r4digw, uv);
_rk79pn.rgb = _rk79pn.rgb * _rk79pn.rgb;
_rk79pn.rgb = _rk79pn.rgb * _rk79pn.rgb;
_rk79pn.rgb *= 32.0;
return _rk79pn;
}

vec3 _a3jxj7(vec2 uv, float _swfcra) {
vec4 _8wjl9m = vec4(uv * 2.0 - 1.0, _swfcra * 2.0 - 1.0, 1.0);
vec4 viewPos = gbufferProjectionInverse * _8wjl9m;
viewPos /= viewPos.w;
vec4 worldPos = gbufferModelViewInverse * viewPos;
return worldPos.xyz + cameraPosition;
}

vec3 _b8ua9d(vec2 uv, float _swfcra) {
vec3 worldPos;
if (_cwcjr4(
dhProjectionInverse, gbufferModelViewInverse, cameraPosition, uv, _swfcra, worldPos)) {
return worldPos;
}
return cameraPosition;
}

vec3 _1u0ne4(mat4 _41z3b6, vec2 uv, float _swfcra) {
vec4 _8wjl9m = vec4(uv * 2.0 - 1.0, _swfcra * 2.0 - 1.0, 1.0);
vec4 viewPos = _41z3b6 * _8wjl9m;
float _p8s4ll = (abs(viewPos.w) < 1e-6) ? (viewPos.w < 0.0 ? -1e-6 : 1e-6) : viewPos.w;
return viewPos.xyz / _p8s4ll;
}

vec3 _7wyf50(vec2 uv, float _0a1qdy) {
if (!_2fqi4q(vxProjInv)) {
return _1u0ne4(gbufferProjectionInverse, uv, _0a1qdy);
}
float vxDepth = texture(vxDepthTexTrans, uv).r;
float _vprtmg = _7bqo1l(vxDepth) ? vxDepth : _0a1qdy;
return _1u0ne4(vxProjInv, uv, _vprtmg);
}

vec3 _g84n3q(mat4 _6kwtyi, vec3 viewPos) {
vec4 _f1qe0z = _6kwtyi * vec4(viewPos, 1.0);
float _p8s4ll = (abs(_f1qe0z.w) < 1e-6) ? (_f1qe0z.w < 0.0 ? -1e-6 : 1e-6) : _f1qe0z.w;
vec3 _siftnl = _f1qe0z.xyz / _p8s4ll;
return _siftnl * 0.5 + 0.5;
}

float _47sqax(vec3 _hygfvv, float _1144g3, float skylight) {
if (!_2fqi4q(vxProjInv)) return 1.0;
if (_1144g3 <= 0.00001 || _1144g3 >= 0.99999) return 1.0;
if (skylight <= 0.05) return 1.0;

vec3 _q15nbr = normalize(shadowLightPosition);
if (length(_q15nbr) < 0.001) return 1.0;

float _a557rr = 1.0;
if (_a557rr <= 0.0001) return 1.0;

mat4 _hh4nvv = inverse(vxProjInv);

float _505ihe = 1.5;
float _ygdc5d = 2.0;
const int VXY_SSRT_STEPS = 10;

for (int i = 0; i < VXY_SSRT_STEPS; i++) {
vec3 _7a91kw = _hygfvv + _q15nbr * _505ihe;
vec3 _ilotk8 = _g84n3q(_hh4nvv, _7a91kw);

if (_ilotk8.x <= 0.0 || _ilotk8.x >= 1.0 ||
_ilotk8.y <= 0.0 || _ilotk8.y >= 1.0 ||
_ilotk8.z <= 0.0 || _ilotk8.z >= 1.0) {
break;
}

float _slnatl = texture(vxDepthTexTrans, _ilotk8.xy).r;

if (_slnatl > 0.00001 && _slnatl < 0.99999) {
vec3 _7zouf3 =
_1u0ne4(vxProjInv, _ilotk8.xy, _slnatl);

float _01kxpu = _7zouf3.z - _7a91kw.z;
if (_01kxpu > 0.35 && _01kxpu < 20.0) {
return mix(1.0, 0.0, _a557rr);
}
}

_505ihe += _ygdc5d;
_ygdc5d *= 1.18;
}

return 1.0;
}

vec3 _937urf(
float _gloime,
float _hg321h,
float skylight,
float _jvfij5
) {
vec4 _jqmu3t = voxy_time_of_day_lighting(sunAngle);
float _y22te0 = _jqmu3t.x;
float _z92ecz = _jqmu3t.z;
float voxyAngle = fract(sunAngle);
float _7vcusu = (1.0 - step(0.5, voxy_quantized_light_level(skylight))) * (1.0 / 15.0);
float _mv1tmz = voxy_vanilla_skylight_brightness(max(skylight, _7vcusu));

float _zpw0c7 = smoothstep(0.38, 0.45, voxyAngle) * (1.0 - smoothstep(0.48, 0.55, voxyAngle))
+ smoothstep(0.95, 1.0, voxyAngle) + (1.0 - smoothstep(0.0, 0.05, voxyAngle));
float _nf77dj = smoothstep(0.07, 0.15, voxyAngle) * (1.0 - smoothstep(0.40, 0.46, voxyAngle));
float _ydmrin = smoothstep(0.58, 0.66, voxyAngle) * (1.0 - smoothstep(0.92, 0.98, voxyAngle));
float _grvh4h = SKYLIGHT_COLOR_TINT
* (1.0 - _nf77dj * 0.6)
* (1.0 - _ydmrin * 0.7);
float _kytein = clamp(_grvh4h + _zpw0c7 * SUNSET_TERRAIN_TINT, 0.0, 1.0);
float _4knsqu = clamp(SKYLIGHT_TINT_LIGHT_SATURATION, 0.0, 1.0);
vec3 _8bjer1 = voxy_tod_skylight_tint(sunAngle);
vec3 _b75czz = voxy_normalize_light_color(skyColor);
float _zkhgkx = smoothstep(0.5, 0.9, _z92ecz);
vec3 _xbixhz = voxy_normalize_light_color(_8bjer1 * mix(vec3(1.0), _b75czz, _zkhgkx));
float _9b7299 = voxy_luma(_xbixhz);
_xbixhz = mix(_xbixhz, vec3(_9b7299), _ydmrin * 0.85);

float _40jp91 = 1.0 + _zpw0c7 * (SUNSET_TERRAIN_TINT * 1.09);
vec3 _fe6xmr = voxy_normalize_light_color(voxy_applySaturation(_xbixhz, SKYLIGHT_TINT_SATURATION * _40jp91));
float _b7pzhz = mix(1.0, SKYLIGHT_TINT_SATURATION * _40jp91, _4knsqu);
vec3 _jpx7iz = voxy_normalize_light_color(voxy_applySaturation(_xbixhz, _b7pzhz));
float _279ort = clamp(_kytein * 0.68, 0.0, 1.0);
vec3 _djla22 = voxy_normalize_light_color(mix(vec3(1.0), _fe6xmr, _279ort));
vec3 _c4ysuh = voxy_normalize_light_color(mix(vec3(1.0), _jpx7iz, _279ort));

float _6l75mg = 1.0 - smoothstep(0.0, 0.25, _y22te0);
float _xcnno9 = 0.15 * _mv1tmz * (1.0 - _6l75mg * 0.75);
vec3 _oumalh = _djla22 * _xcnno9;

float _tvxt53 = clamp(_mv1tmz * _y22te0 * _gloime, 0.0, 1.0);
float _4vax1c = clamp(_mv1tmz * _y22te0 * _hg321h, 0.0, 1.0);
float _u3cfpb = clamp(_mv1tmz * _y22te0, 0.0, 1.0);
_tvxt53 = clamp(_tvxt53 + _mv1tmz * _gloime * _6l75mg * 0.30, 0.0, 1.0);
_4vax1c = clamp(_4vax1c + _mv1tmz * _hg321h * _6l75mg * 0.30, 0.0, 1.0);
_u3cfpb = clamp(_u3cfpb + _mv1tmz * _6l75mg * 0.30, 0.0, 1.0);

vec3 _0zecuo = mix(_oumalh, _c4ysuh, _tvxt53);
vec3 _pynnuw = mix(_oumalh, _c4ysuh, _4vax1c);
vec3 _2kk4rd = mix(_oumalh, _c4ysuh, _u3cfpb);
_0zecuo = mix(_0zecuo, _2kk4rd, _jvfij5);
_pynnuw = mix(_pynnuw, _2kk4rd, _jvfij5);
return clamp(_pynnuw / max(_0zecuo, vec3(0.001)), vec3(0.0), vec3(1.0));
}

#define BIOME_COLOR_SMOOTHING_HAS_SSBO
#include "/include/distance_fog.glsl"

#if (defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)) && defined(WALL_RUNOFF_ENABLED)
float _6l8nya(vec2 p) {
return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float _qcukfb(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * (3.0 - 2.0 * f);
float a = _6l8nya(i);
float b = _6l8nya(i + vec2(1.0, 0.0));
float c = _6l8nya(i + vec2(0.0, 1.0));
float d = _6l8nya(i + vec2(1.0, 1.0));
return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}
#endif

void main() {
ivec2 _2l09tc = ivec2(gl_FragCoord.xy);

vec4 _f7jn6z = texelFetch(colortex0, _2l09tc, 0);
vec3 _ru60ur = _f7jn6z.rgb;
float _xszwck = _f7jn6z.a;
float _rnz76l = _xszwck;

vec4 _8u1o7c = texelFetch(colortex7, _2l09tc, 0);
vec4 _alcc4c = texelFetch(colortex1, _2l09tc, 0);
vec4 _ehp903 = texelFetch(colortex4, _2l09tc, 0);
vec4 _a2jf3a = texelFetch(colortex5, _2l09tc, 0);
float _wv2m0b = clamp(_alcc4c.b, 0.0, 1.0);

float _2zs1mf = texelFetch(depthtex0, _2l09tc, 0).r;
float _b8i8m4 = texelFetch(depthtex1, _2l09tc, 0).r;
float _cr41tl = texelFetch(depthtex2, _2l09tc, 0).r;
float _ips7jr = texelFetch(dhDepthTex, _2l09tc, 0).r;

float _4f6yyb = _b8i8m4;
float _a8w17j = _cr41tl;
float _2ql2nv = _2zs1mf;
bool _yjolhc = !_7bqo1l(_4f6yyb);
bool _xvtoay = (_2ql2nv < _a8w17j - 0.000001) && (abs(_2ql2nv - _4f6yyb) < 0.000001);
bool _28w8fp = (_2zs1mf < _cr41tl - 0.000001) && (abs(_2zs1mf - _b8i8m4) < 0.000001);

#if defined(END_SHADER) && defined(END_SKY_ENABLED)
{
float voxyDepth = texelFetch(vxDepthTexTrans, _2l09tc, 0).r;
bool _ndjcr8 = _2fqi4q(vxProjInv)
&& _alcc4c.a > 0.999
&& _7bqo1l(voxyDepth);
bool _fy5umg = false;
#ifdef DISTANT_HORIZONS
_fy5umg = _yfr6tv(_ips7jr);
#endif

if (_yjolhc && !_ndjcr8 && !_fy5umg) {
vec4 _1ec65m = vec4(texcoord * 2.0 - 1.0, 1.0, 1.0);
vec4 _k5hq9e = gbufferProjectionInverse * _1ec65m;
_k5hq9e.xyz /= _k5hq9e.w;
vec3 _pw9mjj = normalize(mat3(gbufferModelViewInverse) * _k5hq9e.xyz);
_ru60ur = _hijiov(_pw9mjj, frameTimeCounter, cameraPosition);
}
}
#endif

vec3 _yssmf1 = _ru60ur;

if (_xvtoay) {

float _p94ooe = _8u1o7c.a;
if (_p94ooe > 0.001 && !_28w8fp) {
_yssmf1 = _yssmf1 * (1.0 - _p94ooe) + _8u1o7c.rgb;
}
gl_FragData[0] = vec4(_yssmf1, _xszwck);
gl_FragData[1] = vec4(0.0);
return;
}

float _p94ooe = _8u1o7c.a;
bool _h278bp = !_xvtoay && (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);
bool _ws7m2h =
!_h278bp &&
!_28w8fp &&
(_alcc4c.a <= 0.01) &&
(_alcc4c.r > 0.90 && _alcc4c.r < 0.99);

bool _he7hn1 =
(_ws7m2h ||
(!_h278bp &&
!_28w8fp &&
(_p94ooe <= 0.001) &&
(_2zs1mf < _b8i8m4 - 0.00001) &&
(_ehp903.a <= 0.01)));
vec4 _m995av = _a2jf3a;
bool _2uxgrb = (_ehp903.a > 0.45);
bool _4jcu76 = _yjolhc && (_p94ooe > 0.001);
bool _kgt9i1 = _yjolhc && _7bqo1l(_2ql2nv) && (_m995av.y < 0.5) && !_2uxgrb;

bool _kt17lp = _28w8fp;
bool _6wm2rg = false;
bool isWater = false;
bool _1ty8mm = (_alcc4c.a > 0.999);
bool _wgkw3q = false;
bool _etzcl6 = false;
bool _y9l8xx = false;
bool _bm5ber = false;
bool _ju8znl = false;
vec3 _zu00vj = vec3(0.0, 1.0, 0.0);
vec3 _c085da = _yssmf1;
vec4 _622i54 = vec4(0.0);

#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)

bool _dnud18 = (_a2jf3a.z > 0.001 || _a2jf3a.w > 0.001) && !_28w8fp;

float nx = _a2jf3a.z * 2.0 - 1.0;
float ny = _a2jf3a.w * 2.0 - 1.0;
bool _4trppr = _r0mj6q(_a2jf3a.y);
bool _60hefv = _a2jf3a.y > 0.9;
float _n5xnga = _4trppr
? _olzjaf(_a2jf3a.y)
: (_60hefv ? _5rjijq(_a2jf3a.y) : 1.0);
float nz = sqrt(max(1.0 - nx * nx - ny * ny, 0.0)) * _n5xnga;
_zu00vj = vec3(nx, ny, nz);
bool _vk0ali = (_zu00vj.y > 0.5);

_6wm2rg = _60hefv;

float voxyMarker = _alcc4c.a;
_kt17lp = (voxyMarker > 0.01 && voxyMarker < 0.99) || _28w8fp;

bool _o0x6bl = (_2zs1mf < _b8i8m4 - 0.00001) || (_p94ooe > 0.001);

_1ty8mm = (voxyMarker > 0.999);

_wgkw3q = _dnud18 && _6wm2rg && _1ty8mm && !_kt17lp && !_2uxgrb;
isWater = _dnud18 && _6wm2rg && !_kt17lp && !_1ty8mm && _o0x6bl && !_2uxgrb && _7bqo1l(_2zs1mf);
if (_wgkw3q) isWater = true;
_etzcl6 = _dnud18 && _6wm2rg && !isWater && !_7bqo1l(_2zs1mf) && _yfr6tv(_ips7jr);
_y9l8xx = _dnud18 && !isWater && !_etzcl6 && !_kt17lp;

_bm5ber = (_ehp903.a > 0.75 && _ehp903.a < 0.85);

if (_bm5ber) {
isWater = false;
_etzcl6 = false;
_y9l8xx = false;
}
bool _5s4qgu = (isWater || _etzcl6) && _2uxgrb;
_ju8znl = (isWater || _etzcl6) && !_5s4qgu;

_c085da = _yssmf1;

#ifdef VOXY_SSS_ENABLED
#ifdef SHADOWS_ENABLED
if (_1ty8mm && !_wgkw3q && !isWater && !_2uxgrb && !_h278bp) {
float voxyDepthShadow = texture(vxDepthTexTrans, texcoord).r;
if (_2fqi4q(vxProjInv) && voxyDepthShadow > 0.00001 && voxyDepthShadow < 0.99999) {
vec4 voxyClipShadow = vxProjInv * vec4(texcoord * 2.0 - 1.0, voxyDepthShadow * 2.0 - 1.0, 1.0);
vec3 voxyViewShadow = voxyClipShadow.xyz / voxyClipShadow.w;
float voxySsrtVisibility = _47sqax(voxyViewShadow, voxyDepthShadow, _alcc4c.b);
float voxySsrtSkyFade = mix(1.0, voxySsrtVisibility, clamp(_alcc4c.b, 0.0, 1.0));
float voxyShadowOpacity = clamp(SHADOW_OPACITY * VOXY_SHADOW_OPACITY, 0.0, 1.0);
float voxySsrtShadow = mix(1.0, voxySsrtSkyFade, voxyShadowOpacity);
float voxyBaseShadow = voxy_unpack_shadow_baseline(_alcc4c.r);
float voxyCombinedShadow = min(voxyBaseShadow, voxySsrtShadow);
float _nd19sa =
voxy_shadow_transition_dip(sunAngle) *
voxy_has_skylight_mask(_alcc4c.b);
_yssmf1 *= _937urf(
voxyBaseShadow,
voxyCombinedShadow,
_alcc4c.b,
_nd19sa
);
}
}
#endif
#endif

float _iio55e = _a2jf3a.x;
float _bgr2if = _iio55e;
if (isWater || _etzcl6) {
ivec2 _qbl7mv = ivec2(viewWidth - 1.0, viewHeight - 1.0);
float _dx5phs = texelFetch(colortex5, clamp(_2l09tc + ivec2(-1, 0), ivec2(0), _qbl7mv), 0).x;
float _d7xbpd = texelFetch(colortex5, clamp(_2l09tc + ivec2( 1, 0), ivec2(0), _qbl7mv), 0).x;
float _m1qidr = texelFetch(colortex5, clamp(_2l09tc + ivec2(0, -1), ivec2(0), _qbl7mv), 0).x;
float _18n2h1 = texelFetch(colortex5, clamp(_2l09tc + ivec2(0,  1), ivec2(0), _qbl7mv), 0).x;
_bgr2if = (_iio55e + _dx5phs + _d7xbpd + _m1qidr + _18n2h1) * 0.2;
}

float _n4k7cp = biome_beach;
#ifdef BEACH_WAVES_EVERYWHERE
_n4k7cp = 1.0;
#endif
float _wowu50 = max(_n4k7cp, biome_ocean);

#ifdef WATER_REFLECTION_DEBUG
if (isWater) _yssmf1 = vec3(1.0, 0.0, 1.0);
if (_etzcl6) _yssmf1 = vec3(1.0, 1.0, 0.0);
if (_y9l8xx) _yssmf1 = vec3(0.0, 1.0, 1.0);
#else

#if 0

#ifdef WATER_REFLECTIONS_ENABLED
if (isWater && isEyeInWater != 1) {
if (_2zs1mf < 1.0) {
vec3 viewPos;
if (_wgkw3q) {
vec4 _fx17l9 = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
viewPos = _fx17l9.xyz / _fx17l9.w;
} else {
vec3 _53i0wc = vec3(texcoord, _2zs1mf);
viewPos = _uyoa3r(_53i0wc);
}
vec3 _6kjayw = _zu00vj;
bool _qpuyyk = (_6kjayw.y < 0.5);
if (_qpuyyk) _6kjayw = vec3(0.0, 1.0, 0.0);
_6kjayw = normalize(mix(vec3(0.0, 1.0, 0.0), _6kjayw, 0.05));
vec3 normal = normalize(mat3(gbufferModelView) * _6kjayw);

vec2 _9sc61v = vec2(0.0);
#ifdef WATER_WAVES_ENABLED
{
ivec2 _pft99a = ivec2(viewWidth - 1.0, viewHeight - 1.0);
ivec2 _0h5ikg = clamp(_2l09tc + ivec2(-1, 0), ivec2(0), _pft99a);
ivec2 _jl79xu = clamp(_2l09tc + ivec2( 1, 0), ivec2(0), _pft99a);
ivec2 _begmf9 = clamp(_2l09tc + ivec2(0, -1), ivec2(0), _pft99a);
ivec2 _nedetf = clamp(_2l09tc + ivec2(0,  1), ivec2(0), _pft99a);
float _c812gk = texelFetch(colortex5, _0h5ikg, 0).x;
float _gjidtf = texelFetch(colortex5, _jl79xu, 0).x;
float _j8nqll = texelFetch(colortex5, _begmf9, 0).x;
float _44vlry = texelFetch(colortex5, _nedetf, 0).x;
vec2 _xsqtjz = vec2(_gjidtf - _c812gk, _44vlry - _j8nqll);
float _n36ohd = max(length(viewPos), 1.0);
float _dzlx4h = 1.0 / _n36ohd;
_9sc61v = vec2(0.0);
}
#endif

TimeWeightsSimple reflTS = getTimeWeightsSimple(sunAngle);
float _rqywk2 = reflTS.day + reflTS.twilight;
float _5npzw1 = reflTS.night + reflTS.blueHour;
float _z1eswg = mix(0.15, 1.0, _rqywk2) + _5npzw1 * 0.85;
float _8eveno = mix(WATER_REFLECTION_AMOUNT, max(WATER_REFLECTION_AMOUNT, 0.85), _5npzw1) * _z1eswg * WATER_OPACITY;
float _na1t7h = 1.0;
_8eveno *= _na1t7h;
_8eveno *= _szngcf;
float _e3jstl = texelFetch(colortex1, _2l09tc, 0).b;

vec2 lmcoord = vec2(0.0, _e3jstl);

vec3 _alj00v = reflect(normalize(viewPos), normal);
vec3 _n59wg6 = mat3(gbufferModelViewInverse) * _alj00v;

if (_qpuyyk) {

vec3 _q12rgm = _zu00vj;
_q12rgm.y = 0.0;
float _6texqa = length(_q12rgm);
if (_6texqa < 0.001) _q12rgm = vec3(0.0, 0.0, 1.0);
else _q12rgm /= _6texqa;

vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec3 _x90s48 = normalize(worldPos);
vec3 _abzd1t = reflect(_x90s48, _q12rgm);
_abzd1t.y += 0.15;

float _6cto2c = _a2jf3a.x;
_abzd1t.x += (_6cto2c - 0.5) * 0.12;
_abzd1t.y += (_6cto2c - 0.5) * 0.08;
_abzd1t = normalize(_abzd1t);

vec3 _0dpy3q;
if (_abzd1t.y > 0.0) {
vec3 _3n76ds = normalize(mat3(gbufferModelView) * _abzd1t);
_0dpy3q = _b617kd(_3n76ds, worldPos + cameraPosition, false) * 0.8;
} else {
vec3 _jrbx5b = normalize(vec3(_abzd1t.x, 0.001, _abzd1t.z));
vec3 _84x5hh = normalize(mat3(gbufferModelView) * _jrbx5b);
_0dpy3q = _b617kd(_84x5hh, worldPos + cameraPosition, false) * 0.8;
}

float _0k0ylx = smoothstep(13.0 / 15.0, 14.0 / 15.0, _e3jstl);

vec3 _69ghbv = _q12rgm;
_69ghbv.y += (_6cto2c - 0.5) * 0.1;
_69ghbv.x += (_6cto2c - 0.5) * 0.05;
_69ghbv = normalize(_69ghbv);
vec3 _kejtti = normalize(mat3(gbufferModelView) * _69ghbv);
vec2 _37nx9n = vec2((_6cto2c - 0.5) * 0.008, (_6cto2c - 0.5) * 0.015);
vec3 _uxy67q = _yssmf1;
_8g66fe(_yssmf1, viewPos, _kejtti, lmcoord, _8eveno, _37nx9n, _4zuzjy, _vkr2o4);
vec3 _skywkx = _yssmf1 - _uxy67q;
_yssmf1 = _uxy67q;
_yssmf1 += _skywkx * WATER_BRIGHTNESS;
float _9sn5qt = clamp(length(_skywkx) * 5.0, 0.0, 1.0);
vec3 _9sgfl5 = mix(_yssmf1, _0dpy3q, _8eveno * _0k0ylx);
_yssmf1 = mix(_9sgfl5, _yssmf1, _9sn5qt);

{
vec3 _mt7k70 = normalize(mat3(gbufferModelView) * _q12rgm);
_mt7k70 = normalize(_mt7k70 + vec3((_6cto2c - 0.5) * 0.5, (_6cto2c - 0.5) * 0.5, 0.0));
vec3 _h19uni = normalize(shadowLightPosition);
vec3 _do5q0z = normalize(-viewPos);
vec3 _6efx2f = _do5q0z + _h19uni;
float _6n07wa = dot(_6efx2f, _6efx2f);
float _2znn0w = _6n07wa > 1e-10
? max(dot(_mt7k70, _6efx2f * inversesqrt(_6n07wa)), 0.0)
: 0.0;
float _jadth6 = smoothstep(0.95, 0.99, _2znn0w);
TimeWeightsSimple sideSpecTS = getTimeWeightsSimple(sunAngle);
float _c0lo5q = sideSpecTS.day + sideSpecTS.twilight * 0.7;
float _96rjg8 = 1.0 + sideSpecTS.twilight * 2.0;
float _smcc8x = _jadth6 * _c0lo5q * _e3jstl * _96rjg8;
vec3 _ear2q4 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), sideSpecTS.twilight);
vec3 _w3dtzp = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 _96wo5e = shadowProjection * shadowModelView * vec4(_w3dtzp, 1.0);
vec3 _2cnyn8 = _2y5umb(_96wo5e.xyz / _96wo5e.w);
vec3 _xjw7ed = _2cnyn8 * 0.5 + 0.5;
float _inktnv = 0.0;
if (_xjw7ed.x > 0.0 && _xjw7ed.x < 1.0 && _xjw7ed.y > 0.0 && _xjw7ed.y < 1.0) {
float _0ra2st = texture(shadowtex0, _xjw7ed.xy).r;
_inktnv = step(_xjw7ed.z - 0.001, _0ra2st);
}
_c085da = _yssmf1;
_yssmf1 += _ear2q4 * _smcc8x * WATER_SPECULAR_INTENSITY * _inktnv * _szngcf * mix(1.0, 0.1, smoothSwamp);
}
} else {

vec3 _uxy67q = _yssmf1;
_8g66fe(_yssmf1, viewPos, normal, lmcoord, _8eveno, _9sc61v, _4zuzjy, _vkr2o4);
vec3 _6g0two = _yssmf1 - _uxy67q;
float wb = WATER_BRIGHTNESS;
_yssmf1 = _uxy67q + _6g0two * wb;

vec3 _bfci6m = normalize(shadowLightPosition);
vec3 _pxuxe9 = normalize(-viewPos);
vec3 _72h9xh = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz + cameraPosition;
float _i5po7g = frameTimeCounter * WATER_WAVE_SPEED * 0.5;

#define SPEC_HASH(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)
vec3 _850ec7 = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 0.4, _i5po7g * 0.25);
vec3 _38o16g = floor(_850ec7); vec3 _lr78db = fract(_850ec7);
_lr78db = _lr78db * _lr78db * (3.0 - 2.0 * _lr78db);
float _j0jh0s = mix(mix(mix(SPEC_HASH(_38o16g), SPEC_HASH(_38o16g+vec3(1,0,0)), _lr78db.x),
mix(SPEC_HASH(_38o16g+vec3(0,1,0)), SPEC_HASH(_38o16g+vec3(1,1,0)), _lr78db.x), _lr78db.y),
mix(mix(SPEC_HASH(_38o16g+vec3(0,0,1)), SPEC_HASH(_38o16g+vec3(1,0,1)), _lr78db.x),
mix(SPEC_HASH(_38o16g+vec3(0,1,1)), SPEC_HASH(_38o16g+vec3(1,1,1)), _lr78db.x), _lr78db.y), _lr78db.z);
vec3 _qteiii = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 0.9, _i5po7g * 0.6) + vec3(17.0);
vec3 _6vuthm = floor(_qteiii); vec3 _z9c5ak = fract(_qteiii);
_z9c5ak = _z9c5ak * _z9c5ak * (3.0 - 2.0 * _z9c5ak);
float _6750t9 = mix(mix(mix(SPEC_HASH(_6vuthm), SPEC_HASH(_6vuthm+vec3(1,0,0)), _z9c5ak.x),
mix(SPEC_HASH(_6vuthm+vec3(0,1,0)), SPEC_HASH(_6vuthm+vec3(1,1,0)), _z9c5ak.x), _z9c5ak.y),
mix(mix(SPEC_HASH(_6vuthm+vec3(0,0,1)), SPEC_HASH(_6vuthm+vec3(1,0,1)), _z9c5ak.x),
mix(SPEC_HASH(_6vuthm+vec3(0,1,1)), SPEC_HASH(_6vuthm+vec3(1,1,1)), _z9c5ak.x), _z9c5ak.y), _z9c5ak.z);
vec3 _mao7v6 = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 1.8, _i5po7g * 1.0) + vec3(31.0);
vec3 _jlilj6 = floor(_mao7v6); vec3 _wypf73 = fract(_mao7v6);
_wypf73 = _wypf73 * _wypf73 * (3.0 - 2.0 * _wypf73);
float _p12qvd = mix(mix(mix(SPEC_HASH(_jlilj6), SPEC_HASH(_jlilj6+vec3(1,0,0)), _wypf73.x),
mix(SPEC_HASH(_jlilj6+vec3(0,1,0)), SPEC_HASH(_jlilj6+vec3(1,1,0)), _wypf73.x), _wypf73.y),
mix(mix(SPEC_HASH(_jlilj6+vec3(0,0,1)), SPEC_HASH(_jlilj6+vec3(1,0,1)), _wypf73.x),
mix(SPEC_HASH(_jlilj6+vec3(0,1,1)), SPEC_HASH(_jlilj6+vec3(1,1,1)), _wypf73.x), _wypf73.y), _wypf73.z);
#undef SPEC_HASH

float wx = (_j0jh0s - 0.5) * 0.5 + (_6750t9 - 0.5) * 0.3 + (_p12qvd - 0.5) * 0.2;
float wz = (_6750t9 - 0.5) * 0.5 + (_p12qvd - 0.5) * 0.3 + (_j0jh0s - 0.5) * 0.2;

vec3 _l1sqth = normalize(normal + mat3(gbufferModelView) * vec3(wx * 1.0, 0.0, wz * 1.0));
vec3 _wyn6z0 = _pxuxe9 + _bfci6m;
float _uycece = dot(_wyn6z0, _wyn6z0);
float _ujrze4 = _uycece > 1e-10
? max(dot(_l1sqth, _wyn6z0 * inversesqrt(_uycece)), 0.0)
: 0.0;
TimeWeightsSimple topTS = getTimeWeightsSimple(sunAngle);
float _srk3qw = topTS.day + topTS.twilight * 0.7;
float _bbpwrx = 1.0 + topTS.twilight * 2.0;
float _zytka9 = smoothstep(0.95, 0.99, _ujrze4);
float _kpgt2b = _zytka9 * _srk3qw * _e3jstl * _bbpwrx;
vec3 _t3aag0 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), topTS.twilight);

vec3 _uui686 = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 _lil6a4 = shadowProjection * shadowModelView * vec4(_uui686, 1.0);
vec3 _ptzw8f = _2y5umb(_lil6a4.xyz / _lil6a4.w);
vec3 _oq0cry = _ptzw8f * 0.5 + 0.5;
float _2gxq8x = 0.0;
if (_oq0cry.x > 0.0 && _oq0cry.x < 1.0 && _oq0cry.y > 0.0 && _oq0cry.y < 1.0) {
float _6ampvv = texture(shadowtex0, _oq0cry.xy).r;
_2gxq8x = step(_oq0cry.z - 0.001, _6ampvv);
}
float _4carkr = _kpgt2b * WATER_SPECULAR_INTENSITY * 0.4 * _2gxq8x * _szngcf * mix(1.0, 0.1, smoothSwamp);
_c085da = _yssmf1;
_yssmf1 += _t3aag0 * _4carkr;
}
}
}

if (_etzcl6 && _ju8znl && isEyeInWater != 1) {
vec3 _h6gefa = vec3(
_a2jf3a.z * 2.0 - 1.0,
_a2jf3a.w * 2.0 - 1.0,
0.0
);
_h6gefa.z = sqrt(max(1.0 - _h6gefa.x * _h6gefa.x - _h6gefa.y * _h6gefa.y, 0.0));
vec3 _zs71tl = normalize(mat3(gbufferModelView) * _h6gefa);

vec3 _1y3u2e = vec3(texcoord, _ips7jr);
vec3 _r81jg2 = _1y3u2e * 2.0 - 1.0;
vec4 _sa838t = dhProjectionInverse * vec4(_r81jg2, 1.0);
vec3 _u5ch89 = _sa838t.xyz / _sa838t.w;

float _61doab = 1.0 - abs(dot(normalize(-_u5ch89), _zs71tl));
_61doab *= _61doab;
_61doab *= _61doab;
float _3eupdr = mix(0.6, 1.0, _61doab) * WATER_REFLECTION_FADE;
_3eupdr = clamp(_3eupdr, 0.0, 1.0);

TimeWeightsSimple dhReflTS = getTimeWeightsSimple(sunAngle);
float _bobj8h = dhReflTS.day + dhReflTS.twilight;
float _75fu70 = dhReflTS.night + dhReflTS.blueHour;
float _5f2oo5 = mix(0.15, 1.0, _bobj8h) + _75fu70 * 0.85;

vec3 _18e44z = reflect(normalize(_u5ch89), _zs71tl);
vec3 _xlaso6 = (gbufferModelViewInverse * vec4(_u5ch89, 1.0)).xyz + cameraPosition;
{
float _rtijgp = frameTimeCounter * WATER_WAVE_SPEED;
vec2 _nf2v0q = _xlaso6.xz * WATER_WAVE_SCALE * 2.5;
float _53ketq = sin(_nf2v0q.x * 3.0 + _nf2v0q.y * 0.3 + _rtijgp * 1.5) * 0.5
+ sin(_nf2v0q.x * 5.0 + _nf2v0q.y * 0.5 + _rtijgp * 2.2) * 0.3
+ sin(_nf2v0q.x * 8.0 + _nf2v0q.y * 0.2 + _rtijgp * 3.0) * 0.2;
float _xf4jm8 = sin(_nf2v0q.x * 0.3 + _nf2v0q.y * 3.0 + _rtijgp * 1.3) * 0.5
+ sin(_nf2v0q.x * 0.5 + _nf2v0q.y * 5.0 + _rtijgp * 2.0) * 0.3;
_18e44z.x += _53ketq * 0.005;
_18e44z.z += _xf4jm8 * 0.005;
_18e44z = normalize(_18e44z);
}
float _l8qz4r = mix(0.20, 1.0, _75fu70 / max(_bobj8h + _75fu70, 0.001));
float _dvzuik = max(_bobj8h, _75fu70);
_l8qz4r = mix(0.60, _l8qz4r, _dvzuik);
float _m5fm5g = _75fu70 / max(_bobj8h + _75fu70, 0.001);
float _x4uohz = mix(WATER_SKY_BRIGHTNESS_DAY, WATER_SKY_BRIGHTNESS_NIGHT, _m5fm5g);
_x4uohz = mix(mix(WATER_SKY_BRIGHTNESS_DAY, WATER_SKY_BRIGHTNESS_NIGHT, 0.5), _x4uohz, _dvzuik);
vec3 _o6gp8p = _b617kd(_18e44z, _xlaso6, false) * 1.0;

float _avjypc = WATER_REFLECTION_AMOUNT * _5f2oo5 * _3eupdr * WATER_SKY_REFLECTION * WATER_OPACITY;
float _yycsj2 = 1.0;
_avjypc *= _yycsj2;
float _kmcabm = texelFetch(colortex1, _2l09tc, 0).b;
_avjypc *= smoothstep(13.0 / 15.0, 14.0 / 15.0, _kmcabm);
_avjypc = clamp(_avjypc, 0.0, 1.0);
_avjypc *= _szngcf;
_yssmf1 = mix(_yssmf1, _o6gp8p, _avjypc);
}
#endif

_1rzokf = _yssmf1 - preSSR;

ssrPreSpecularColor = _c085da;

_yssmf1 = preSSR;

_c085da = preSSR;

#endif
#endif
#endif

if (isEyeInWater != 1) {
vec2 _6ujuwx = texcoord;
bool _kj4uqc = (_m995av.y > 0.9) && (_m995av.w * 2.0 - 1.0 < 0.5);
if (_kj4uqc) {
float _6cto2c = _m995av.x;
vec2 _imixdk = vec2((_6cto2c - 0.5) * 0.8, (_6cto2c - 0.5) * 1.2);
float _5spi1j = 14.0 / max(viewWidth, 1.0);
_6ujuwx += _imixdk * _5spi1j;
_6ujuwx = clamp(_6ujuwx, vec2(0.0), vec2(1.0));
}
vec4 _h1cocf = texture(colortex8, _6ujuwx);
float _zfkaed = clamp(1.0 - _xszwck, 0.0, 1.0);
float _td1tdn = _h1cocf.a;
float _j5mf30 = 1e20;

if (_7bqo1l(_b8i8m4)) {
_j5mf30 = min(_j5mf30, length(_1u0ne4(gbufferProjectionInverse, texcoord, _b8i8m4)));
}
if (_yfr6tv(_ips7jr)) {
_j5mf30 = min(_j5mf30, length(_b8ua9d(texcoord, _ips7jr) - cameraPosition));
}
float _m7cz58 = texture(vxDepthTexTrans, texcoord).r;
if (_2fqi4q(vxProjInv) && _7bqo1l(_m7cz58)) {
_j5mf30 = min(_j5mf30, length(_1u0ne4(vxProjInv, texcoord, _m7cz58)));
}

bool _rzhuct = (_td1tdn > 0.001) && (_j5mf30 < _td1tdn - 1.0);
if (_zfkaed > 0.001 && !_h278bp && !_kgt9i1 && !_rzhuct) {
_yssmf1 = _yssmf1 * (1.0 - _zfkaed) + _h1cocf.rgb;
}
}

float _o7giip = 0.0;
vec3 _pb67e8 = _yssmf1;

#if defined(NETHER_FOG_ENABLED) || defined(END_FOG_ENABLED) || defined(OVERWORLD_FOG_ENABLED)

bool _jxqxpy = false;
#ifdef NETHER_FOG_ENABLED
_jxqxpy = _h278bp && _9cwhip(biome);
#endif
{
vec3 _96c5w8 = vec3(0.0);
float _waurma = 1.0;
float _9o6ms5 = 0.0;

float _l584tr;
vec3 _7qpuxx;
bool _hounzx = false;
bool _uveofz = false;

float vxDepthFog = texture(vxDepthTexTrans, texcoord).r;
bool _kd5trg = _2fqi4q(vxProjInv) && _7bqo1l(vxDepthFog);
bool _7zeca0 = _yfr6tv(_ips7jr);
bool _xshl70 =
_ju8znl &&
((_wgkw3q && (_kd5trg || _7bqo1l(_2zs1mf))) ||
(_etzcl6 && _7zeca0) ||
(!_wgkw3q && !_etzcl6 && isWater && _7bqo1l(_2ql2nv)));

if (_h278bp || _he7hn1) {
_l584tr = _2zs1mf;
_7qpuxx = _a3jxj7(texcoord, _2zs1mf);
_uveofz = false;
_hounzx = false;
} else if (_xshl70) {
if (_wgkw3q) {
_l584tr = _kd5trg ? vxDepthFog : _2zs1mf;
vec3 vxWaterView = _7wyf50(texcoord, _2zs1mf);
_7qpuxx = (gbufferModelViewInverse * vec4(vxWaterView, 1.0)).xyz + cameraPosition;
_uveofz = false;
} else if (_etzcl6) {
_l584tr = _ips7jr;
_7qpuxx = _b8ua9d(texcoord, _l584tr);
_uveofz = true;
} else {
_l584tr = _2ql2nv;
_7qpuxx = _a3jxj7(texcoord, _l584tr);
_uveofz = false;
}
_hounzx = false;
} else if (_7bqo1l(_4f6yyb)) {

_l584tr = _4f6yyb;
_7qpuxx = _a3jxj7(texcoord, _l584tr);
_uveofz = false;
float _n73w3a = _zdldl1(_4f6yyb);
float _gy8ett = _7zeca0 ? _wf8ve2(_ips7jr) : 1e10;
if (_7zeca0 && _gy8ett < _n73w3a) {
_l584tr = _ips7jr;
_7qpuxx = _b8ua9d(texcoord, _l584tr);
_uveofz = true;
}
_hounzx = false;
} else if (_kd5trg) {
_l584tr = vxDepthFog;
vec4 vxClip = vxProjInv * vec4(texcoord * 2.0 - 1.0, vxDepthFog * 2.0 - 1.0, 1.0);
vec3 vxView = vxClip.xyz / vxClip.w;
_7qpuxx = (gbufferModelViewInverse * vec4(vxView, 1.0)).xyz + cameraPosition;
_uveofz = false;
_hounzx = false;
} else if (_7zeca0) {
_l584tr = _ips7jr;
_7qpuxx = _b8ua9d(texcoord, _l584tr);
_uveofz = true;
_hounzx = false;
} else {
_hounzx = true;
_l584tr = 1.0;
vec4 _8wjl9m = vec4(texcoord * 2.0 - 1.0, 0.0, 1.0);
vec4 viewPos = gbufferProjectionInverse * _8wjl9m;
vec3 viewDir = normalize(viewPos.xyz);
vec4 _st4awd = gbufferModelViewInverse * vec4(viewDir, 0.0);
_7qpuxx = cameraPosition + _st4awd.xyz * far;
_uveofz = false;
}

vec4 _rk79pn = (isEyeInWater == 2) ? vec4(0.0, 0.0, 0.0, 1.0) : _ycfkak(texcoord, _l584tr, _7qpuxx, _hounzx, _uveofz);

if ((_h278bp && !_jxqxpy) || _ws7m2h) {
_rk79pn = vec4(0.0, 0.0, 0.0, 1.0);
}

_96c5w8 = _rk79pn.rgb;
_waurma = clamp(_rk79pn.a, 0.0, 1.0);
_9o6ms5 = clamp(1.0 - _waurma, 0.0, 1.0);

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome) && _hounzx) {
vec3 _6xt7r3 = _ktauxr(biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B)) * NETHER_BRIGHTNESS;
_yssmf1 = _6xt7r3;
_9o6ms5 = 1.0;
}
#endif

_9o6ms5 *= _rnz76l;
_96c5w8 *= _rnz76l;
_waurma = 1.0 - _9o6ms5;

if (_9o6ms5 > 0.001) {

bool _7dnqj0 = _alcc4c.g > 0.5;
#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome) && _7dnqj0 && !_jxqxpy) {
float _2zxz7z = length(_7qpuxx - cameraPosition);
float _xf3a9d = NETHER_DISTANCE_FOG_START * 1.5;
float _ckgfiz = 1.0 - smoothstep(_xf3a9d, float(NETHER_FOG_DISTANCE), _2zxz7z);
_9o6ms5 *= mix(1.0, 0.0, _ckgfiz);
_96c5w8 *= mix(1.0, 0.0, _ckgfiz);
_waurma = 1.0 - _9o6ms5;
}
#endif

#ifdef END_SHADER

{
float _uohh66 = 1.0 - _9o6ms5;
vec3 _4bbmv6 = _yssmf1 * (1.0 - _9o6ms5 * 0.4) + _96c5w8;
vec3 _ll4wqp = _yssmf1 * _uohh66 + _96c5w8;

float _6khuh5 = 0.5;
#ifdef END_EVENT_ENABLED
float _imqx64 = getEndEvent(frameTimeCounter).fogDarkness;
_6khuh5 = mix(_6khuh5, 1.0, _imqx64);
#endif

_yssmf1 = mix(_4bbmv6, _ll4wqp, _6khuh5);
}
#else

_yssmf1 = _yssmf1 * _waurma + _96c5w8;
#endif
_o7giip = max(_o7giip, _9o6ms5);
}
}
#endif

#ifdef END_SHADER
{
bool _4kdcpu = (_alcc4c.g > 0.5) && !_h278bp;
bool _jwox2w = _yjolhc && !_yfr6tv(_ips7jr) && !(_alcc4c.a > 0.999);
if (!_4kdcpu && !_jwox2w) {
vec3 _wi9nhq = _yssmf1;
float _zuxja7 = 0.73;
vec3 _99621u = vec3(0.08, 0.06, 0.35);
float _1cr2qa = 0.15;
float _25ofey = 0.55;

#ifdef END_EVENT_ENABLED
float _do4zke = getEndEvent(frameTimeCounter).terrainDarkness;
_zuxja7 = mix(_zuxja7, 0.02, _do4zke);
_1cr2qa = mix(_1cr2qa, 0.0, _do4zke);
_25ofey = mix(_25ofey, 0.0, _do4zke);
#endif

float _nonrn7 = _h278bp ? 0.1 : 1.0;
_yssmf1 *= mix(1.0, _zuxja7, _nonrn7);
_yssmf1 += _99621u * _1cr2qa * _nonrn7;
_yssmf1 = mix(_yssmf1, _yssmf1 * vec3(0.55, 0.58, 1.35), _25ofey * _nonrn7);

vec3 _ykaqen;
if (_alcc4c.a > 0.999) {

float _dxb0th = texture(vxDepthTexTrans, texcoord).r;
if (_2fqi4q(vxProjInv) && _7bqo1l(_dxb0th)) {
vec4 _igjsu7 = vxProjInv * vec4(texcoord * 2.0 - 1.0, _dxb0th * 2.0 - 1.0, 1.0);
_ykaqen = (gbufferModelViewInverse * vec4(_igjsu7.xyz / _igjsu7.w, 1.0)).xyz + cameraPosition;
} else {
vec4 _b0a0on = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _4f6yyb * 2.0 - 1.0, 1.0);
_ykaqen = (gbufferModelViewInverse * vec4(_b0a0on.xyz / _b0a0on.w, 1.0)).xyz + cameraPosition;
}
} else if (!_7bqo1l(_4f6yyb) && _yfr6tv(_ips7jr)) {
_ykaqen = _b8ua9d(texcoord, _ips7jr);
} else {
vec4 _b0a0on = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _4f6yyb * 2.0 - 1.0, 1.0);
_ykaqen = (gbufferModelViewInverse * vec4(_b0a0on.xyz / _b0a0on.w, 1.0)).xyz + cameraPosition;
}
float _ctspwg = _h278bp ? 0.0 : (1.0 - smoothstep(28.0, 53.0, _ykaqen.y));
_yssmf1 *= mix(1.0, 0.25, _ctspwg);

#if defined(END_EVENT_ENABLED) && defined(HANDHELD_LIGHT_ENABLED)
if (!_h278bp && _do4zke > 0.001) {
_yssmf1 += _cq86ij(_ykaqen, _wi9nhq, _yssmf1) * _do4zke;
}
#endif
}
}
#endif

#if 0
#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)

TimeWeightsSimple wsTS = getTimeWeightsSimple(sunAngle);
float _oz8bl7 = wsTS.day + wsTS.twilight;
float _dfufsf = wsTS.night + wsTS.blueHour;
float _hh8a92 = _dfufsf / max(_oz8bl7 + _dfufsf, 0.001);
float _ask1av = max(_oz8bl7, _dfufsf);
_hh8a92 = mix(0.0, _hh8a92, _ask1av);

if (isWater || _etzcl6) {
float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
float _pg1f5w = mix(WATER_SATURATION, WATER_SATURATION * WATER_NIGHT_SATURATION, _hh8a92);
_yssmf1 = mix(vec3(_zdxp7g), _yssmf1, _pg1f5w);
}

#ifdef UNDERWATER_FOG_ENABLED
if ((isWater || _etzcl6) && isEyeInWater != 1) {
float _2pqkf9 = _2zs1mf;
float _mkla6u = texelFetch(depthtex1, _2l09tc, 0).r;

vec4 _u6hwxw = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2pqkf9 * 2.0 - 1.0, 1.0);
vec3 _ibfp74 = _u6hwxw.xyz / _u6hwxw.w;
vec4 _mqux7i = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _mkla6u * 2.0 - 1.0, 1.0);
vec3 _y6k1ty = _mqux7i.xyz / _mqux7i.w;

float _vsug70 = max(length(_y6k1ty) - length(_ibfp74), 0.0);

if (_vsug70 < 0.5 && (_1ty8mm || _etzcl6)) {
vec3 _qyg78u = (gbufferModelViewInverse * vec4(_ibfp74, 1.0)).xyz + cameraPosition;
_vsug70 = max(float(SEA_LEVEL_OFFSET) - _qyg78u.y + 2.0, 0.0);
}

vec3 _70glmg = vec3(0.009, 0.004, 0.0015);
vec3 _x1c0w8 = exp(-_vsug70 * _70glmg);
vec3 _ksrktm = vec3(0.1, 0.4, 0.8);

#ifdef WATER_DEBUG_COLORS_ENABLED
_yssmf1 = vec3(voxyMarker);
if (_1ty8mm) _yssmf1 = vec3(1.0, 0.0, 0.0);
if (_etzcl6) _yssmf1 = vec3(0.0, 1.0, 0.0);
if (_wgkw3q) _yssmf1 = vec3(1.0, 1.0, 0.0);
#endif
}
#endif

#ifdef WATER_FOAM_ENABLED
if ((isWater || _etzcl6) && isEyeInWater != 1) {
vec3 _z5wyi5;
if (_wgkw3q) {
_z5wyi5 = _7wyf50(texcoord, _2zs1mf);
} else if (_etzcl6) {
vec4 _arm6hc = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _ips7jr * 2.0 - 1.0, 1.0);
_z5wyi5 = _arm6hc.xyz / _arm6hc.w;
} else {
vec4 _k1w1wj = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_z5wyi5 = _k1w1wj.xyz / _k1w1wj.w;
}
vec3 _s9t5pq = (gbufferModelViewInverse * vec4(_z5wyi5, 1.0)).xyz + cameraPosition;
float _5pxwpu = frameTimeCounter * WATER_WAVE_SPEED;
float _tzdfvl = 0.15;

#define RF_WAVE_RAW(f) (smoothstep(0.15, 0.25, f) * (1.0 - pow(smoothstep(0.25, 1.15, f), 0.45)))
#define RF_WAVE(px) RF_WAVE_RAW(1.0 - fract(px))
#define RF_OWAVE(px) (pow(0.5 + 0.5 * sin((fract(px) - 0.25) * 6.2832), 1.6))
#define RF_SMAX(a, b, k) (max(a, b) + pow(max(k - abs(a - b), 0.0) / k, 3.0) * k * 0.166667)

vec2 _6exbeo = vec2(0.0);
bool _mxedkp = (_zu00vj.y < 0.5) && _6wm2rg;

if (_mxedkp) {
float _kcvx4r = texelFetch(colortex5, _2l09tc, 0).x;
_6exbeo = vec2((_kcvx4r - 0.5) * 0.8, (_kcvx4r - 0.5) * 1.2);
} else if (biome_beach > 0.01 && biome_beach >= biome_ocean) {
float _tm7pcm = _s9t5pq.x * WATER_WAVE_SCALE;
float _asfihw = _s9t5pq.z * WATER_WAVE_SCALE;
float _s3g5nt = sin(_asfihw * 0.21 + 3.7) * 2.5 + sin(_asfihw * 0.53 + 1.2) * 1.3;
float _qjrb5k = sin(_asfihw * 0.37 + 5.1) * 1.8 + sin(_asfihw * 0.71 + 2.8) * 1.1;
float _ejqt5w = sin(_asfihw * 0.62 + 0.9) * 1.2 + sin(_asfihw * 0.89 + 4.3) * 0.8;
float _rbrsqu = clamp(RF_SMAX(RF_WAVE((_tm7pcm * 0.8 + _s3g5nt - _5pxwpu) / 6.2832), RF_WAVE((_tm7pcm * 1.8 + _qjrb5k - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_rbrsqu += RF_WAVE((_tm7pcm * 4.0 + _ejqt5w - _5pxwpu * 2.2) / 6.2832) * 0.15 * _rbrsqu;
float _3hm2qw = (_s9t5pq.x + _tzdfvl) * WATER_WAVE_SCALE;
float _eh8p8i = clamp(RF_SMAX(RF_WAVE((_3hm2qw * 0.8 + _s3g5nt - _5pxwpu) / 6.2832), RF_WAVE((_3hm2qw * 1.8 + _qjrb5k - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_eh8p8i += RF_WAVE((_3hm2qw * 4.0 + _ejqt5w - _5pxwpu * 2.2) / 6.2832) * 0.15 * _eh8p8i;
float _gbyll2 = (_s9t5pq.z + _tzdfvl) * WATER_WAVE_SCALE;
float _2csvvv = sin(_gbyll2 * 0.21 + 3.7) * 2.5 + sin(_gbyll2 * 0.53 + 1.2) * 1.3;
float _0bo46n = sin(_gbyll2 * 0.37 + 5.1) * 1.8 + sin(_gbyll2 * 0.71 + 2.8) * 1.1;
float _yx3wmu = sin(_gbyll2 * 0.62 + 0.9) * 1.2 + sin(_gbyll2 * 0.89 + 4.3) * 0.8;
float _s6xooi = clamp(RF_SMAX(RF_WAVE((_tm7pcm * 0.8 + _2csvvv - _5pxwpu) / 6.2832), RF_WAVE((_tm7pcm * 1.8 + _0bo46n - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_s6xooi += RF_WAVE((_tm7pcm * 4.0 + _yx3wmu - _5pxwpu * 2.2) / 6.2832) * 0.15 * _s6xooi;
_6exbeo = vec2(_eh8p8i - _rbrsqu, _s6xooi - _rbrsqu) / _tzdfvl;
}
#undef RF_WAVE
#undef RF_WAVE_RAW
#undef RF_OWAVE
#undef RF_SMAX

float _l1wxos = max(_wowu50, 0.5);
float _rrq5rt = max(length(_z5wyi5), 1.0);
float _4ihf8u = 1.0 - smoothstep(30.0, 80.0, _rrq5rt);
float _2pzycx = (biome_beach > 0.01) ? 18.0 : 14.0;
float _5spi1j = _2pzycx * _l1wxos / max(_rrq5rt * 0.02, 0.5);
ivec2 _gtrgdq = _2l09tc + ivec2(_6exbeo * _5spi1j);
_gtrgdq = clamp(_gtrgdq, ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));
float _n2ipkh = texelFetch(depthtex1, _gtrgdq, 0).r;
if (_n2ipkh > _2zs1mf && _4ihf8u > 0.01) {
vec3 _27vcup = texelFetch(colortex0, _gtrgdq, 0).rgb;
vec4 _zjpojh = texelFetch(colortex7, _gtrgdq, 0);
vec3 _zst3en = _zjpojh.a > 0.001 ? _27vcup * (1.0 - _zjpojh.a) + _zjpojh.rgb : _27vcup;
_yssmf1 = mix(_yssmf1, _zst3en, 0.95 * _4ihf8u);
}
}
#endif

if (false && (isWater || _etzcl6) && _ju8znl && isEyeInWater != 1) {
float _qahbnu;
if (_etzcl6) {
vec4 _n80w6r = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _ips7jr * 2.0 - 1.0, 1.0);
_qahbnu = -_n80w6r.z / _n80w6r.w;
} else {
vec4 _4ozgo0 = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_qahbnu = -_4ozgo0.z / _4ozgo0.w;
}

float fogDensity = mix(0.025, 2.0, biome_swamp);
float _bs5gl8 = mix(0.95, 1.0, biome_swamp);
float _dppv7e = 1.0 - exp(-_qahbnu * fogDensity);
_dppv7e = clamp(_dppv7e, 0.0, _bs5gl8);

if (_dppv7e > 0.001) {
float _7jexot = fract(sunAngle);
float _u2bg4c = smoothstep(0.40, 0.48, _7jexot) * (1.0 - smoothstep(0.48, 0.55, _7jexot))
+ smoothstep(0.94, 1.0, _7jexot) + (1.0 - smoothstep(0.0, 0.06, _7jexot));
if (_u2bg4c > 0.001) {
float _scsgwb = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1 = mix(_yssmf1, vec3(_scsgwb), _u2bg4c * 0.6);
}
vec3 _w95fch = _xwb441(sunAngle, 1.0, 0.0, 0.0, 0.0, 0.0);
vec3 _34qfhm = vec3(0.04, 0.08, 0.02);
vec3 _e3558u = mix(_w95fch, _34qfhm, biome_swamp);
_yssmf1 *= mix(vec3(1.0), _e3558u * 3.0, _dppv7e);
_yssmf1 += _e3558u * _dppv7e;
}
}

#ifdef SWAMP_SNAKE_LIGHT_ENABLED
if ((isWater || _etzcl6) && isEyeInWater != 1 && biome_swamp > 0.01) {
float _p8u65t = _etzcl6 ? _ips7jr : _2zs1mf;
vec3 _ze09gm = _uyoa3r(vec3(texcoord, _p8u65t));
vec3 _yvi3je = (gbufferModelViewInverse * vec4(_ze09gm, 1.0)).xyz + cameraPosition;

float st = frameTimeCounter;
vec3 _tpreuc = vec3(
floor(cameraPosition.x / 16.0) * 16.0 + 8.0,
_yvi3je.y,
floor(cameraPosition.z / 16.0) * 16.0 + 8.0
);

vec3 viewDir = normalize(_yvi3je - cameraPosition);
float _29e9cj = 0.0;
int _amohs0 = 6;
float _cunixp = 6.0;
float _ygdc5d = _cunixp / float(_amohs0);

for (int s = 0; s < _amohs0; s++) {
float _n092m6 = _ygdc5d * (float(s) + 0.5);
vec3 _tj3223 = _yvi3je + viewDir * _n092m6;
float _9pz08u = exp(-_n092m6 * 1.0);
for (int i = 0; i < 16; i++) {
float tt = float(i) * 0.8;
float sx = sin(tt * 1.2 + st * 0.4) * 3.0 + sin(tt * 0.5 + st * 0.15) * 6.0;
float sz = cos(tt * 0.9 + st * 0.3) * 4.0 + cos(tt * 0.4 + st * 0.2) * 5.0;
float sy = -0.5 - sin(tt * 1.8 + st * 0.5) * 0.5 - abs(sin(tt * 0.3 + st * 0.1)) * 1.0;
vec3 _eokqru = _tpreuc + vec3(sx, sy, sz);
float _t25r5m = length(_tj3223 - _eokqru);
_29e9cj += _9pz08u / (1.0 + _t25r5m * _t25r5m * 2.0);
}
}
_29e9cj = _29e9cj / float(_amohs0);
_29e9cj = clamp(_29e9cj * 0.25, 0.0, 1.0);
vec3 _f1qzlp = vec3(0.2, 0.55, 0.1);
_yssmf1 += _f1qzlp * _29e9cj * biome_swamp;
}
#endif

#endif
#endif

if (isEyeInWater == 1) {
bool _qanvxg = (_alcc4c.a > 0.999);
float _ye9gcm = texture(vxDepthTexTrans, texcoord).r;
bool _did8bj = _qanvxg && _2fqi4q(vxProjInv) && _7bqo1l(_ye9gcm);
bool _e7dp2n = false;

if (_did8bj) {
vec3 _k9zk6j = _1u0ne4(vxProjInv, texcoord, _ye9gcm);
vec3 _6zbddm = (gbufferModelViewInverse * vec4(_k9zk6j, 1.0)).xyz + cameraPosition;
_e7dp2n = (_6zbddm.y > float(SEA_LEVEL_OFFSET) + 0.5);
} else if (!_qanvxg) {
_e7dp2n = !_7bqo1l(_b8i8m4);
if (!_e7dp2n) {
vec3 _k9zk6j = _1u0ne4(gbufferProjectionInverse, texcoord, _b8i8m4);
vec3 _6zbddm = (gbufferModelViewInverse * vec4(_k9zk6j, 1.0)).xyz + cameraPosition;
_e7dp2n = (_6zbddm.y > float(SEA_LEVEL_OFFSET) + 0.5);
}
}
if (_e7dp2n) {
vec4 _qylpe9 = vec4(texcoord * 2.0 - 1.0, 0.5, 1.0);
vec4 _beixpi = gbufferProjectionInverse * _qylpe9;
vec3 _ntbz44 = normalize(_beixpi.xyz);
vec3 _3frwov = normalize(mat3(gbufferModelViewInverse) * _ntbz44);
float _lj1z7e = (float(SEA_LEVEL_OFFSET) - cameraPosition.y) / max(_3frwov.y, 0.001);
vec2 _sx37ew = cameraPosition.xz + _3frwov.xz * max(_lj1z7e, 0.0);

vec2 _1ie0vs = _sx37ew * 0.5;
float _23ypj8 = frameTimeCounter * WATER_WAVE_SPEED;
float _a5i6nt = cos(_1ie0vs.x * 2.0 + _1ie0vs.y * 0.7 + _23ypj8 * 1.2) * 0.3
+ cos(_1ie0vs.x * 1.3 - _1ie0vs.y * 1.8 + _23ypj8 * 0.8) * 0.2;
float _4npl6q = cos(_1ie0vs.y * 2.2 + _1ie0vs.x * 0.5 + _23ypj8 * 1.0) * 0.3
+ cos(_1ie0vs.y * 1.5 - _1ie0vs.x * 1.6 + _23ypj8 * 1.1) * 0.2;

float _k4dgp4 = 14.0;
ivec2 _0ja0jq = _2l09tc + ivec2(vec2(_a5i6nt, _4npl6q) * _k4dgp4);
_0ja0jq = clamp(_0ja0jq, ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));
vec3 _hju1lg = texelFetch(colortex0, _0ja0jq, 0).rgb;
vec4 _vxqjfp = texelFetch(colortex7, _0ja0jq, 0);
vec3 _2bhavk = _vxqjfp.a > 0.001
? _hju1lg * (1.0 - _vxqjfp.a) + _vxqjfp.rgb
: _hju1lg;

float _acy6bj = length(_sx37ew - cameraPosition.xz);
float _eqjy44 = 8.0;
float _joj3gh = 1.0 - smoothstep(_eqjy44 * 0.5, _eqjy44, _acy6bj);

vec3 _4vs6sx = normalize(mat3(gbufferModelViewInverse) * sunPosition);
float _7jzhx5 = 1.0 - smoothstep(-0.05, 0.3, _4vs6sx.y);
float _n8emmr = smoothstep(0.0, 0.15, _4vs6sx.y) * (1.0 - smoothstep(0.15, 0.35, _4vs6sx.y));
vec3 _e61p9c = vec3(0.12, 0.22, 0.50);
vec3 _50ch13 = vec3(0.60, 0.22, 0.05);
vec3 _xoc41t = vec3(0.10, 0.18, 0.42);

vec3 _9qhwrx = vec3(0.06, 0.12, 0.05);
vec3 _ves6rp = vec3(0.04, 0.08, 0.03);
_e61p9c = mix(_e61p9c, _9qhwrx, smoothSwamp);
_50ch13 = mix(_50ch13, _9qhwrx, smoothSwamp);
_xoc41t = mix(_xoc41t, _ves6rp, smoothSwamp);
vec3 _9ajq7u = mix(mix(_e61p9c, _50ch13, _n8emmr), _xoc41t, _7jzhx5);
_yssmf1 = mix(_9ajq7u, _2bhavk * 2.0, _joj3gh);
_p94ooe = 0.0;
}
}

if ((isWater || _etzcl6) && _ju8znl && isEyeInWater != 1) {

vec3 _ibfp74;
if (_wgkw3q) {
_ibfp74 = _7wyf50(texcoord, _2zs1mf);
} else if (_etzcl6) {
vec4 _a2olgj = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_ibfp74 = _a2olgj.xyz / _a2olgj.w;
} else {
vec4 _u6hwxw = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_ibfp74 = _u6hwxw.xyz / _u6hwxw.w;
}

float _1kqzye = texelFetch(depthtex1, _2l09tc, 0).r;
vec4 _mqux7i = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _1kqzye * 2.0 - 1.0, 1.0);
vec3 _y6k1ty = _mqux7i.xyz / _mqux7i.w;

vec3 _z987nl = (gbufferModelViewInverse * vec4(_ibfp74, 1.0)).xyz + cameraPosition;
vec3 _dmxr6n = (gbufferModelViewInverse * vec4(_y6k1ty, 1.0)).xyz + cameraPosition;
float _vsug70;
if (_wgkw3q) {

float vxTerrainDepth = texelFetch(vxDepthTexOpaque, _2l09tc, 0).r;
if (_7bqo1l(vxTerrainDepth) && _2fqi4q(vxProjInv)) {
vec3 vxTerrainView = _1u0ne4(vxProjInv, texcoord, vxTerrainDepth);
vec3 vxTerrainWorld = (gbufferModelViewInverse * vec4(vxTerrainView, 1.0)).xyz + cameraPosition;
_vsug70 = max(_z987nl.y - vxTerrainWorld.y, 0.0);
} else {
_vsug70 = max(float(SEA_LEVEL_OFFSET) - _z987nl.y + 2.0, 0.0);
}
} else if (_etzcl6) {

float _5ljod9 = texelFetch(dhDepthTex1, _2l09tc, 0).r;
if (_yfr6tv(_5ljod9)) {
vec4 _tom23t = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _5ljod9 * 2.0 - 1.0, 1.0);
vec3 _r583y8 = _tom23t.xyz / _tom23t.w;
vec3 _jsx2i9 = (gbufferModelViewInverse * vec4(_r583y8, 1.0)).xyz + cameraPosition;
_vsug70 = max(_z987nl.y - _jsx2i9.y, 0.0);
} else {
_vsug70 = max(float(SEA_LEVEL_OFFSET) - _z987nl.y + 2.0, 0.0);
}
} else if (_7bqo1l(_1kqzye) && !_1ty8mm) {
_vsug70 = max(_z987nl.y - _dmxr6n.y, 0.0);
} else {
_vsug70 = max(float(SEA_LEVEL_OFFSET) - _z987nl.y + 2.0, 0.0);
}
_vsug70 = min(_vsug70, 16.0);

vec3 _70glmg = vec3(0.12, 0.06, 0.025);
vec3 _x1c0w8 = exp(-_vsug70 * _70glmg);

vec3 _ke54vf = _xwb441(sunAngle, biome_beach, biome_swamp, biome_jungle, biome_snowy, biome_arid) * 0.4;
vec3 _kcz121 = mix(_ke54vf, _yssmf1, _x1c0w8);
_yssmf1 = mix(_yssmf1, _kcz121, _wv2m0b);
}

float _9ez73h = 0.0;

#ifdef WATER_WAVES_ENABLED
if (_ju8znl && !_wgkw3q && isEyeInWater != 1 && storedScreenSkylight > 0.1) {
float _znhofy = _etzcl6 ? _ips7jr : _2zs1mf;
bool _1v45e6 = _etzcl6 ? _yfr6tv(_znhofy)
: _7bqo1l(_znhofy);

float _mrab89 = _b8i8m4;
bool _z3xg23 = false;
bool _cud3w9 = false;
bool _h36yzz = _7bqo1l(_mrab89);

if (_etzcl6) {
float _pyuwp6 = texelFetch(dhDepthTex1, _2l09tc, 0).r;
_h36yzz = _yfr6tv(_pyuwp6);
_mrab89 = _pyuwp6;
_z3xg23 = _h36yzz;
} else if (!_h36yzz) {
float _gqxoyx = texture(vxDepthTexTrans, texcoord).r;
_h36yzz = _2fqi4q(vxProjInv) && _7bqo1l(_gqxoyx);
_mrab89 = _gqxoyx;
_cud3w9 = _h36yzz;
}

if (_1v45e6 && _h36yzz) {
vec3 _0nm6pf = _etzcl6 ? _b8ua9d(texcoord, _znhofy)
: _a3jxj7(texcoord, _znhofy);
vec3 _t4s6ew;
if (_z3xg23) {
_t4s6ew = _b8ua9d(texcoord, _mrab89);
} else if (_cud3w9) {
vec4 _xu0429 = vxProjInv * vec4(texcoord * 2.0 - 1.0, _mrab89 * 2.0 - 1.0, 1.0);
vec3 _k6tz9y = _xu0429.xyz / _xu0429.w;
_t4s6ew = (gbufferModelViewInverse * vec4(_k6tz9y, 1.0)).xyz + cameraPosition;
} else {
_t4s6ew = _a3jxj7(texcoord, _mrab89);
}
float _fjzad9 = _0nm6pf.y - _t4s6ew.y;

if (_fjzad9 > 0.05) {
float ct = frameTimeCounter * WATER_WAVE_SPEED * 0.4;
vec3 _0rl3ii = _t4s6ew * 0.75;

float cA = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _0rl3ii;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
cA += abs(_lpglwu(p * _oah0e7 + ct * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
cA = 1.0 - cA / _56jsby;
}

float cB = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _0rl3ii + 5.0;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
cB += abs(_lpglwu(p * _oah0e7 + ct * 1.15 * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
cB = 1.0 - cB / _56jsby;
}

float _rbvgpe = min(cA, cB);
_rbvgpe = pow(_rbvgpe, 2.0) * 2.5;
_rbvgpe = max(_rbvgpe - 0.15, 0.0) * (1.0 / 0.85);

float _96tsu0 = 1.0 - smoothstep(1.5, 8.0, _fjzad9);
_96tsu0 *= exp(-_fjzad9 * 0.25);
TimeWeightsSimple causticTS = getTimeWeightsSimple(sunAngle);
float _6g9iq0 = causticTS.day + causticTS.twilight * 0.5;
float _xalu1b = 1.0;
#ifdef SHADOWS_ENABLED
{
vec3 _gu8vhj = _t4s6ew - cameraPosition;
vec4 _x0nuft = shadowProjection * shadowModelView * vec4(_gu8vhj, 1.0);
vec3 _lfo3f3 = _2y5umb(_x0nuft.xyz / _x0nuft.w);
vec3 _654jix = _lfo3f3 * 0.5 + 0.5;
if (_654jix.x > 0.0 && _654jix.x < 1.0 &&
_654jix.y > 0.0 && _654jix.y < 1.0 &&
_654jix.z > 0.0 && _654jix.z < 1.0) {
float _lx1v7v = texture(shadowtex0, _654jix.xy).r;
_xalu1b = step(_654jix.z - 0.001, _lx1v7v);
_xalu1b = mix(1.0, _xalu1b, _s4lpf1(_654jix));
}
}
#endif
_9ez73h = _rbvgpe * _96tsu0 * _6g9iq0 * _xalu1b * storedScreenSkylight * 0.28;
}
}
}
#endif

if ((isWater || _etzcl6) && _ju8znl && isEyeInWater != 1 && (_b8i8m4 < 1.0 || _wgkw3q) && storedScreenSkylight > 0.01) {
float _7jexot = fract(sunAngle);
float _j8trca = smoothstep(0.38, 0.45, _7jexot) * (1.0 - smoothstep(0.48, 0.55, _7jexot))
+ smoothstep(0.95, 1.0, _7jexot) + (1.0 - smoothstep(0.0, 0.05, _7jexot));
float _c6wfhf = smoothstep(0.07, 0.15, _7jexot) * (1.0 - smoothstep(0.40, 0.46, _7jexot));
float _j4jevi = clamp(SKYLIGHT_COLOR_TINT * (1.0 - _c6wfhf * 0.6) + _j8trca * SUNSET_TERRAIN_TINT, 0.0, 1.0);

vec3 _9yg7gl = _9ruyvd(sunAngle, 0.5);
float _g2h3yt = max(dot(_9yg7gl, vec3(0.299, 0.587, 0.114)), 0.35);
_9yg7gl = clamp(_9yg7gl / _g2h3yt, vec3(0.0), vec3(2.0));
vec3 _ch07hw = mix(vec3(1.0), _9yg7gl, _j4jevi);
_yssmf1 *= _ch07hw;
}

#ifdef WATER_WAVES_ENABLED
if (isEyeInWater != 1 && _9ez73h > 0.001) {
_yssmf1 *= 1.0 + _9ez73h;
}
#endif

vec3 _4c6yes;
bool _2994yj =
isEyeInWater != 1 &&
_p94ooe > 0.001 &&
!isWater &&
!_etzcl6 &&
!_2uxgrb;
bool _hopnkv = false;
{

bool _vrwuf5 = (_2zs1mf < _b8i8m4 - 0.00005);
bool _u7b31k =
!_h278bp &&
!_2uxgrb &&
(_2zs1mf < _b8i8m4 - 0.00005) &&
(_ehp903.a <= 0.01);
bool _fgnnbo =
(_4jcu76 ||
_vrwuf5 ||
!_u7b31k);
_hopnkv = _2994yj && _fgnnbo;
if (_p94ooe > 0.001 && !_28w8fp && _fgnnbo && !_2994yj) {
vec4 _5p15qq = _8u1o7c;
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
{
float _5rqee5 = dot(max(_5p15qq.rgb, vec3(0.0)), vec3(0.299, 0.587, 0.114));
bool _unda4s = (_5p15qq.a < 0.9 && _5rqee5 < 0.04 && _ehp903.a <= 0.01);
if (_unda4s) {
float _xxfl7v = 1.0 - getEndEvent(frameTimeCounter).terrainDarkness;
_5p15qq.rgb *= _xxfl7v;
_5p15qq.a *= _xxfl7v;
}
}
#endif
_yssmf1 = _yssmf1 * (1.0 - _5p15qq.a) + _5p15qq.rgb;
}

bool _t0klds = _2uxgrb && _yjolhc && !_yfr6tv(_ips7jr);
if (_t0klds && isEyeInWater != 1) {
float _gmtyst = texture(vxDepthTexTrans, texcoord).r;
bool _3xhopb = _2fqi4q(vxProjInv) && _7bqo1l(_gmtyst);
bool _m2wgr6 = (_alcc4c.a > 0.999);
if (!_3xhopb && !_m2wgr6) {
const float _v0gj7e = 0.45;
_yssmf1 += _hbv38n() * (1.0 - _v0gj7e);
}
}
_4c6yes = _yssmf1;
}

#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)
#ifndef WATER_REFLECTION_DEBUG
#ifdef WATER_FOAM_ENABLED

if ((isWater || _etzcl6) && _ju8znl && isEyeInWater != 1 && !_wgkw3q) {
vec3 _z5wyi5;
if (_etzcl6) {
float _x7gjed = _ips7jr;
vec4 _arm6hc = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _x7gjed * 2.0 - 1.0, 1.0);
_z5wyi5 = _arm6hc.xyz / _arm6hc.w;
} else {
vec4 _k1w1wj = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_z5wyi5 = _k1w1wj.xyz / _k1w1wj.w;
}
vec3 _s9t5pq = (gbufferModelViewInverse * vec4(_z5wyi5, 1.0)).xyz + cameraPosition;
float _5pxwpu = frameTimeCounter * WATER_WAVE_SPEED;
float _tzdfvl = 0.15;

#define RF_WAVE_RAW_10B(f) (smoothstep(0.15, 0.25, f) * (1.0 - pow(smoothstep(0.25, 1.15, f), 0.45)))
#define RF_WAVE_10B(px) RF_WAVE_RAW_10B(1.0 - fract(px))
#define RF_SMAX_10B(a, b, k) (max(a, b) + pow(max(k - abs(a - b), 0.0) / k, 3.0) * k * 0.166667)

vec2 _6exbeo = vec2(0.0);
bool _mxedkp = (_zu00vj.y < 0.5) && _6wm2rg;

if (_mxedkp) {
float _kcvx4r = texelFetch(colortex5, _2l09tc, 0).x;
_6exbeo = vec2((_kcvx4r - 0.5) * 0.8, (_kcvx4r - 0.5) * 1.2);
} else if (_n4k7cp > 0.01 && _n4k7cp >= biome_ocean) {
float _tm7pcm = _s9t5pq.x * WATER_WAVE_SCALE;
float _asfihw = _s9t5pq.z * WATER_WAVE_SCALE;
float _s3g5nt = sin(_asfihw * 0.21 + 3.7) * 2.5 + sin(_asfihw * 0.53 + 1.2) * 1.3;
float _qjrb5k = sin(_asfihw * 0.37 + 5.1) * 1.8 + sin(_asfihw * 0.71 + 2.8) * 1.1;
float _ejqt5w = sin(_asfihw * 0.62 + 0.9) * 1.2 + sin(_asfihw * 0.89 + 4.3) * 0.8;
float _rbrsqu = clamp(RF_SMAX_10B(RF_WAVE_10B((_tm7pcm * 0.8 + _s3g5nt - _5pxwpu) / 6.2832), RF_WAVE_10B((_tm7pcm * 1.8 + _qjrb5k - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_rbrsqu += RF_WAVE_10B((_tm7pcm * 4.0 + _ejqt5w - _5pxwpu * 2.2) / 6.2832) * 0.15 * _rbrsqu;
float _3hm2qw = (_s9t5pq.x + _tzdfvl) * WATER_WAVE_SCALE;
float _eh8p8i = clamp(RF_SMAX_10B(RF_WAVE_10B((_3hm2qw * 0.8 + _s3g5nt - _5pxwpu) / 6.2832), RF_WAVE_10B((_3hm2qw * 1.8 + _qjrb5k - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_eh8p8i += RF_WAVE_10B((_3hm2qw * 4.0 + _ejqt5w - _5pxwpu * 2.2) / 6.2832) * 0.15 * _eh8p8i;
float _gbyll2 = (_s9t5pq.z + _tzdfvl) * WATER_WAVE_SCALE;
float _2csvvv = sin(_gbyll2 * 0.21 + 3.7) * 2.5 + sin(_gbyll2 * 0.53 + 1.2) * 1.3;
float _0bo46n = sin(_gbyll2 * 0.37 + 5.1) * 1.8 + sin(_gbyll2 * 0.71 + 2.8) * 1.1;
float _yx3wmu = sin(_gbyll2 * 0.62 + 0.9) * 1.2 + sin(_gbyll2 * 0.89 + 4.3) * 0.8;
float _s6xooi = clamp(RF_SMAX_10B(RF_WAVE_10B((_tm7pcm * 0.8 + _2csvvv - _5pxwpu) / 6.2832), RF_WAVE_10B((_tm7pcm * 1.8 + _0bo46n - _5pxwpu * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_s6xooi += RF_WAVE_10B((_tm7pcm * 4.0 + _yx3wmu - _5pxwpu * 2.2) / 6.2832) * 0.15 * _s6xooi;
_6exbeo = vec2(_eh8p8i - _rbrsqu, _s6xooi - _rbrsqu) / _tzdfvl;
} else {

#define RF_HASH(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)
vec3 _kakt9r = vec3(_s9t5pq.xz * WATER_WAVE_SCALE * 0.4, _5pxwpu * 0.5);
vec3 _sr0kan = floor(_kakt9r); vec3 _ihs4q0 = fract(_kakt9r);
_ihs4q0 = _ihs4q0 * _ihs4q0 * (3.0 - 2.0 * _ihs4q0);
float _oglenk = mix(mix(mix(RF_HASH(_sr0kan), RF_HASH(_sr0kan+vec3(1,0,0)), _ihs4q0.x),
mix(RF_HASH(_sr0kan+vec3(0,1,0)), RF_HASH(_sr0kan+vec3(1,1,0)), _ihs4q0.x), _ihs4q0.y),
mix(mix(RF_HASH(_sr0kan+vec3(0,0,1)), RF_HASH(_sr0kan+vec3(1,0,1)), _ihs4q0.x),
mix(RF_HASH(_sr0kan+vec3(0,1,1)), RF_HASH(_sr0kan+vec3(1,1,1)), _ihs4q0.x), _ihs4q0.y), _ihs4q0.z);
vec3 _hsw0uw = vec3(_s9t5pq.xz * WATER_WAVE_SCALE * 0.9, _5pxwpu * 1.2) + vec3(17.0);
vec3 _ktq0ek = floor(_hsw0uw); vec3 _swo2xw = fract(_hsw0uw);
_swo2xw = _swo2xw * _swo2xw * (3.0 - 2.0 * _swo2xw);
float _8nihrl = mix(mix(mix(RF_HASH(_ktq0ek), RF_HASH(_ktq0ek+vec3(1,0,0)), _swo2xw.x),
mix(RF_HASH(_ktq0ek+vec3(0,1,0)), RF_HASH(_ktq0ek+vec3(1,1,0)), _swo2xw.x), _swo2xw.y),
mix(mix(RF_HASH(_ktq0ek+vec3(0,0,1)), RF_HASH(_ktq0ek+vec3(1,0,1)), _swo2xw.x),
mix(RF_HASH(_ktq0ek+vec3(0,1,1)), RF_HASH(_ktq0ek+vec3(1,1,1)), _swo2xw.x), _swo2xw.y), _swo2xw.z);
vec3 _x2t9cw = vec3(_s9t5pq.xz * WATER_WAVE_SCALE * 1.8, _5pxwpu * 2.0) + vec3(31.0);
vec3 _5zwa5t = floor(_x2t9cw); vec3 _n4loj4 = fract(_x2t9cw);
_n4loj4 = _n4loj4 * _n4loj4 * (3.0 - 2.0 * _n4loj4);
float _68wtio = mix(mix(mix(RF_HASH(_5zwa5t), RF_HASH(_5zwa5t+vec3(1,0,0)), _n4loj4.x),
mix(RF_HASH(_5zwa5t+vec3(0,1,0)), RF_HASH(_5zwa5t+vec3(1,1,0)), _n4loj4.x), _n4loj4.y),
mix(mix(RF_HASH(_5zwa5t+vec3(0,0,1)), RF_HASH(_5zwa5t+vec3(1,0,1)), _n4loj4.x),
mix(RF_HASH(_5zwa5t+vec3(0,1,1)), RF_HASH(_5zwa5t+vec3(1,1,1)), _n4loj4.x), _n4loj4.y), _n4loj4.z);
#undef RF_HASH
float _tm7pcm = (_oglenk - 0.5) * 0.5 + (_8nihrl - 0.5) * 0.3 + (_68wtio - 0.5) * 0.2;
float _asfihw = (_8nihrl - 0.5) * 0.5 + (_68wtio - 0.5) * 0.3 + (_oglenk - 0.5) * 0.2;
_6exbeo = vec2(_tm7pcm, _asfihw) * 0.8;
}
#undef RF_WAVE_10B
#undef RF_WAVE_RAW_10B
#undef RF_SMAX_10B

float _l1wxos = max(_wowu50, 0.5);
float _rrq5rt = max(length(_z5wyi5), 1.0);

float _dow6ff = mix(30.0, 60.0, smoothSwamp);
float _8ycc6e = mix(80.0, 120.0, smoothSwamp);
float _4ihf8u = 1.0 - smoothstep(_dow6ff, _8ycc6e, _rrq5rt);
float _2pzycx = (_n4k7cp > 0.01) ? 18.0 : mix(14.0, 22.0, smoothSwamp);
float _5spi1j = _2pzycx * _l1wxos / max(_rrq5rt * 0.02, 0.5);
ivec2 _gtrgdq = _2l09tc + ivec2(_6exbeo * _5spi1j);
_gtrgdq = clamp(_gtrgdq, ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));
float _n2ipkh = texelFetch(depthtex1, _gtrgdq, 0).r;
if (_n2ipkh > _2zs1mf && _4ihf8u > 0.01) {
vec3 _27vcup = texelFetch(colortex0, _gtrgdq, 0).rgb;
vec4 _zjpojh = texelFetch(colortex7, _gtrgdq, 0);
vec3 _zst3en = _zjpojh.a > 0.001 ? _27vcup * (1.0 - _zjpojh.a) + _zjpojh.rgb : _27vcup;
_yssmf1 = mix(_yssmf1, _zst3en, 0.95 * _4ihf8u);
}
}
#endif
#endif
#endif

_c085da = _yssmf1;

vec3 _4zuzjy = vec3(0.0);
float _vkr2o4 = 0.0;
if ((isWater || _etzcl6) && _ju8znl && isEyeInWater != 1) {
vec3 _baed9l = _xwb441(sunAngle, biome_beach, biome_swamp, biome_jungle, biome_snowy, biome_arid);
vec3 _tyg9em = vec3(0.0, 66.0, 102.0) / 255.0;
float _acrwcp = max(max(biome_swamp, biome_jungle), max(biome_snowy, biome_arid));
_4zuzjy = mix(_tyg9em, _baed9l, clamp(_acrwcp, 0.0, 1.0));
float _fpug4y = dot(_4zuzjy, vec3(0.299, 0.587, 0.114));
_4zuzjy = mix(vec3(_fpug4y), _4zuzjy, 2.0);
_4zuzjy = max(_4zuzjy, vec3(0.0));
float _qhjyae = mix(0.05, 1.0, texelFetch(colortex1, _2l09tc, 0).b);
_4zuzjy *= _qhjyae;

_vkr2o4 = 0.0;
}

float _szngcf = 1.0;
if ((isWater || _etzcl6) && _p94ooe > WATER_OPACITY + 0.02) {
float _wvio0y = clamp((_p94ooe - WATER_OPACITY) / (1.0 - WATER_OPACITY), 0.0, 1.0);
_szngcf *= 1.0 - _wvio0y;
}

#ifdef WATER_REFLECTIONS_ENABLED
if (isWater && _ju8znl && isEyeInWater != 1) {
if (_2zs1mf < 1.0) {
vec3 viewPos;
if (_wgkw3q) {
viewPos = _7wyf50(texcoord, _2zs1mf);
} else {
vec3 _53i0wc = vec3(texcoord, _2zs1mf);
viewPos = _uyoa3r(_53i0wc);
}
vec3 _6kjayw = _zu00vj;
bool _qpuyyk = (_6kjayw.y < 0.5);
if (_qpuyyk) _6kjayw = vec3(0.0, 1.0, 0.0);
_6kjayw = normalize(mix(vec3(0.0, 1.0, 0.0), _6kjayw, 0.05));
vec3 normal = normalize(mat3(gbufferModelView) * _6kjayw);

vec2 _9sc61v = vec2(0.0);
#ifdef WATER_WAVES_ENABLED
{
ivec2 _pft99a = ivec2(viewWidth - 1.0, viewHeight - 1.0);
ivec2 _0h5ikg = clamp(_2l09tc + ivec2(-1, 0), ivec2(0), _pft99a);
ivec2 _jl79xu = clamp(_2l09tc + ivec2( 1, 0), ivec2(0), _pft99a);
ivec2 _begmf9 = clamp(_2l09tc + ivec2(0, -1), ivec2(0), _pft99a);
ivec2 _nedetf = clamp(_2l09tc + ivec2(0,  1), ivec2(0), _pft99a);
float _c812gk = texelFetch(colortex5, _0h5ikg, 0).x;
float _gjidtf = texelFetch(colortex5, _jl79xu, 0).x;
float _j8nqll = texelFetch(colortex5, _begmf9, 0).x;
float _44vlry = texelFetch(colortex5, _nedetf, 0).x;
vec2 _xsqtjz = vec2(_gjidtf - _c812gk, _44vlry - _j8nqll);
float _n36ohd = max(length(viewPos), 1.0);
float _dzlx4h = 1.0 / _n36ohd;
_9sc61v = vec2(0.0);
}
#endif

TimeWeightsSimple reflTS = getTimeWeightsSimple(sunAngle);
float _rqywk2 = reflTS.day + reflTS.twilight;
float _5npzw1 = reflTS.night + reflTS.blueHour;
float _z1eswg = mix(0.15, 1.0, _rqywk2) + _5npzw1 * 0.85;
float _8eveno = mix(WATER_REFLECTION_AMOUNT, max(WATER_REFLECTION_AMOUNT, 0.85), _5npzw1) * _z1eswg * WATER_OPACITY;
float _na1t7h = 1.0;
_8eveno *= _na1t7h;
_8eveno *= _szngcf;
float _e3jstl = _wv2m0b;

vec2 lmcoord = vec2(0.0, _e3jstl);

vec3 _alj00v = reflect(normalize(viewPos), normal);
vec3 _n59wg6 = mat3(gbufferModelViewInverse) * _alj00v;

if (_qpuyyk) {
vec3 _q12rgm = _zu00vj;
_q12rgm.y = 0.0;
float _6texqa = length(_q12rgm);
if (_6texqa < 0.001) _q12rgm = vec3(0.0, 0.0, 1.0);
else _q12rgm /= _6texqa;

vec3 worldPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec3 _x90s48 = normalize(worldPos);
vec3 _abzd1t = reflect(_x90s48, _q12rgm);
_abzd1t.y += 0.15;

float _6cto2c = _a2jf3a.x;
_abzd1t.x += (_6cto2c - 0.5) * 0.12;
_abzd1t.y += (_6cto2c - 0.5) * 0.08;
_abzd1t = normalize(_abzd1t);

vec3 _0dpy3q;
if (_abzd1t.y > 0.0) {
vec3 _3n76ds = normalize(mat3(gbufferModelView) * _abzd1t);
_0dpy3q = _b617kd(_3n76ds, worldPos + cameraPosition, false) * 0.8;
} else {
vec3 _jrbx5b = normalize(vec3(_abzd1t.x, 0.001, _abzd1t.z));
vec3 _84x5hh = normalize(mat3(gbufferModelView) * _jrbx5b);
_0dpy3q = _b617kd(_84x5hh, worldPos + cameraPosition, false) * 0.8;
}

float _0k0ylx = smoothstep(13.0 / 15.0, 14.0 / 15.0, _e3jstl);

vec3 _69ghbv = _q12rgm;
_69ghbv.y += (_6cto2c - 0.5) * 0.1;
_69ghbv.x += (_6cto2c - 0.5) * 0.05;
_69ghbv = normalize(_69ghbv);
vec3 _kejtti = normalize(mat3(gbufferModelView) * _69ghbv);
vec2 _37nx9n = vec2((_6cto2c - 0.5) * 0.008, (_6cto2c - 0.5) * 0.015);
vec3 _uxy67q = _yssmf1;
_8g66fe(_yssmf1, viewPos, _kejtti, lmcoord, _8eveno, _37nx9n, _4zuzjy, _vkr2o4);
vec3 _skywkx = _yssmf1 - _uxy67q;
_yssmf1 = _uxy67q;
_yssmf1 += _skywkx * WATER_BRIGHTNESS;
float _fmsvmx = smoothstep(0.05, 0.75, clamp(_ehp903.b, 0.0, 1.0));
float _2far8a = 1.0 - smoothstep(3.0 / 15.0, 10.0 / 15.0, _e3jstl);
float _vlg20y = dot(max(_skywkx, vec3(0.0)), vec3(0.299, 0.587, 0.114));
vec3 _ks5rmh = max(_skywkx * (1.8 + _2far8a * 1.1), vec3(_vlg20y));
_yssmf1 += _ks5rmh * _fmsvmx * (0.14 + _2far8a * 0.40) * WATER_BRIGHTNESS;
float _9sn5qt = clamp(length(_skywkx) * 5.0, 0.0, 1.0);
vec3 _9sgfl5 = mix(_yssmf1, _0dpy3q, _8eveno * _0k0ylx);
_yssmf1 = mix(_9sgfl5, _yssmf1, _9sn5qt);

{
vec3 _mt7k70 = normalize(mat3(gbufferModelView) * _q12rgm);
_mt7k70 = normalize(_mt7k70 + vec3((_6cto2c - 0.5) * 0.5, (_6cto2c - 0.5) * 0.5, 0.0));
vec3 _h19uni = normalize(shadowLightPosition);
vec3 _do5q0z = normalize(-viewPos);
vec3 _k94h2a = normalize(_do5q0z + _h19uni);
float _2znn0w = max(dot(_mt7k70, _k94h2a), 0.0);
float _jadth6 = smoothstep(0.95, 0.99, _2znn0w);
TimeWeightsSimple sideSpecTS = getTimeWeightsSimple(sunAngle);
float _c0lo5q = sideSpecTS.day + sideSpecTS.twilight * 0.7;
float _96rjg8 = 1.0 + sideSpecTS.twilight * 2.0;
float _smcc8x = _jadth6 * _c0lo5q * _e3jstl * _96rjg8;
vec3 _ear2q4 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), sideSpecTS.twilight);
vec3 _w3dtzp = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 _96wo5e = shadowProjection * shadowModelView * vec4(_w3dtzp, 1.0);
vec3 _2cnyn8 = _2y5umb(_96wo5e.xyz / _96wo5e.w);
vec3 _xjw7ed = _2cnyn8 * 0.5 + 0.5;
float _inktnv = 0.0;
if (_xjw7ed.x > 0.0 && _xjw7ed.x < 1.0 && _xjw7ed.y > 0.0 && _xjw7ed.y < 1.0) {
float _0ra2st = texture(shadowtex0, _xjw7ed.xy).r;
_inktnv = step(_xjw7ed.z - 0.001, _0ra2st);
}
_c085da = _yssmf1;
_yssmf1 += _ear2q4 * _smcc8x * WATER_SPECULAR_INTENSITY * _inktnv * _szngcf * mix(1.0, 0.1, smoothSwamp);
}
} else {

vec3 _uxy67q = _yssmf1;
_8g66fe(_yssmf1, viewPos, normal, lmcoord, _8eveno, _9sc61v, _4zuzjy, _vkr2o4);
vec3 _6g0two = _yssmf1 - _uxy67q;
float wb = WATER_BRIGHTNESS;
_yssmf1 = _uxy67q + _6g0two * wb;
float _yk0e0n = smoothstep(0.05, 0.75, clamp(_ehp903.b, 0.0, 1.0));
float _n5nv24 = 1.0 - smoothstep(3.0 / 15.0, 10.0 / 15.0, _e3jstl);
float _cxfjzv = dot(max(_6g0two, vec3(0.0)), vec3(0.299, 0.587, 0.114));
vec3 _offj7v = max(_6g0two * (2.2 + _n5nv24 * 1.4), vec3(_cxfjzv));
_yssmf1 += _offj7v * _yk0e0n * (0.20 + _n5nv24 * 0.55) * WATER_BRIGHTNESS;

vec3 _bfci6m = normalize(shadowLightPosition);
vec3 _pxuxe9 = normalize(-viewPos);
vec3 _72h9xh = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz + cameraPosition;
float _i5po7g = frameTimeCounter * WATER_WAVE_SPEED * 0.5;

#define SPEC_HASH(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)
vec3 _850ec7 = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 0.4, _i5po7g * 0.25);
vec3 _38o16g = floor(_850ec7); vec3 _lr78db = fract(_850ec7);
_lr78db = _lr78db * _lr78db * (3.0 - 2.0 * _lr78db);
float _j0jh0s = mix(mix(mix(SPEC_HASH(_38o16g), SPEC_HASH(_38o16g+vec3(1,0,0)), _lr78db.x),
mix(SPEC_HASH(_38o16g+vec3(0,1,0)), SPEC_HASH(_38o16g+vec3(1,1,0)), _lr78db.x), _lr78db.y),
mix(mix(SPEC_HASH(_38o16g+vec3(0,0,1)), SPEC_HASH(_38o16g+vec3(1,0,1)), _lr78db.x),
mix(SPEC_HASH(_38o16g+vec3(0,1,1)), SPEC_HASH(_38o16g+vec3(1,1,1)), _lr78db.x), _lr78db.y), _lr78db.z);
vec3 _qteiii = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 0.9, _i5po7g * 0.6) + vec3(17.0);
vec3 _6vuthm = floor(_qteiii); vec3 _z9c5ak = fract(_qteiii);
_z9c5ak = _z9c5ak * _z9c5ak * (3.0 - 2.0 * _z9c5ak);
float _6750t9 = mix(mix(mix(SPEC_HASH(_6vuthm), SPEC_HASH(_6vuthm+vec3(1,0,0)), _z9c5ak.x),
mix(SPEC_HASH(_6vuthm+vec3(0,1,0)), SPEC_HASH(_6vuthm+vec3(1,1,0)), _z9c5ak.x), _z9c5ak.y),
mix(mix(SPEC_HASH(_6vuthm+vec3(0,0,1)), SPEC_HASH(_6vuthm+vec3(1,0,1)), _z9c5ak.x),
mix(SPEC_HASH(_6vuthm+vec3(0,1,1)), SPEC_HASH(_6vuthm+vec3(1,1,1)), _z9c5ak.x), _z9c5ak.y), _z9c5ak.z);
vec3 _mao7v6 = vec3(_72h9xh.xz * WATER_WAVE_SCALE * 1.8, _i5po7g * 1.0) + vec3(31.0);
vec3 _jlilj6 = floor(_mao7v6); vec3 _wypf73 = fract(_mao7v6);
_wypf73 = _wypf73 * _wypf73 * (3.0 - 2.0 * _wypf73);
float _p12qvd = mix(mix(mix(SPEC_HASH(_jlilj6), SPEC_HASH(_jlilj6+vec3(1,0,0)), _wypf73.x),
mix(SPEC_HASH(_jlilj6+vec3(0,1,0)), SPEC_HASH(_jlilj6+vec3(1,1,0)), _wypf73.x), _wypf73.y),
mix(mix(SPEC_HASH(_jlilj6+vec3(0,0,1)), SPEC_HASH(_jlilj6+vec3(1,0,1)), _wypf73.x),
mix(SPEC_HASH(_jlilj6+vec3(0,1,1)), SPEC_HASH(_jlilj6+vec3(1,1,1)), _wypf73.x), _wypf73.y), _wypf73.z);
#undef SPEC_HASH

float wx = (_j0jh0s - 0.5) * 0.5 + (_6750t9 - 0.5) * 0.3 + (_p12qvd - 0.5) * 0.2;
float wz = (_6750t9 - 0.5) * 0.5 + (_p12qvd - 0.5) * 0.3 + (_j0jh0s - 0.5) * 0.2;

vec3 _l1sqth = normalize(normal + mat3(gbufferModelView) * vec3(wx * 1.0, 0.0, wz * 1.0));
vec3 _e5hu3i = normalize(_pxuxe9 + _bfci6m);
float _ujrze4 = max(dot(_l1sqth, _e5hu3i), 0.0);
TimeWeightsSimple topTS = getTimeWeightsSimple(sunAngle);
float _srk3qw = topTS.day + topTS.twilight * 0.7;
float _bbpwrx = 1.0 + topTS.twilight * 2.0;
float _zytka9 = smoothstep(0.95, 0.99, _ujrze4);
float _kpgt2b = _zytka9 * _srk3qw * _e3jstl * _bbpwrx;
vec3 _t3aag0 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), topTS.twilight);

vec3 _uui686 = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
vec4 _lil6a4 = shadowProjection * shadowModelView * vec4(_uui686, 1.0);
vec3 _ptzw8f = _2y5umb(_lil6a4.xyz / _lil6a4.w);
vec3 _oq0cry = _ptzw8f * 0.5 + 0.5;
float _2gxq8x = 0.0;
if (_oq0cry.x > 0.0 && _oq0cry.x < 1.0 && _oq0cry.y > 0.0 && _oq0cry.y < 1.0) {
float _6ampvv = texture(shadowtex0, _oq0cry.xy).r;
_2gxq8x = step(_oq0cry.z - 0.001, _6ampvv);
}
float _4carkr = _kpgt2b * WATER_SPECULAR_INTENSITY * 0.4 * _2gxq8x * _szngcf * mix(1.0, 0.1, smoothSwamp);
_c085da = _yssmf1;
_yssmf1 += _t3aag0 * _4carkr;
}
}
}

if (_etzcl6 && _ju8znl && isEyeInWater != 1) {

vec3 _h6gefa = vec3(
_a2jf3a.z * 2.0 - 1.0,
_a2jf3a.w * 2.0 - 1.0,
0.0
);
_h6gefa.z = sqrt(max(1.0 - _h6gefa.x * _h6gefa.x - _h6gefa.y * _h6gefa.y, 0.0));
vec3 _zs71tl = normalize(mat3(gbufferModelView) * _h6gefa);

vec3 _1y3u2e = vec3(texcoord, _ips7jr);
vec3 _r81jg2 = _1y3u2e * 2.0 - 1.0;
vec4 _sa838t = dhProjectionInverse * vec4(_r81jg2, 1.0);
vec3 _u5ch89 = _sa838t.xyz / _sa838t.w;
vec3 _xlaso6 = (gbufferModelViewInverse * vec4(_u5ch89, 1.0)).xyz + cameraPosition;
float _2cvd85 = length(_u5ch89);

vec3 _q8fnr3 = normalize(-_u5ch89);
float _ahq880 = max(dot(_zs71tl, _q8fnr3), 0.0);
float _2j9n9h = 1.0 - _ahq880;
_2j9n9h *= _2j9n9h;
_2j9n9h *= _2j9n9h;
float _61doab = mix(0.6, 1.0, _2j9n9h);

TimeWeightsSimple dhReflTS = getTimeWeightsSimple(sunAngle);
float _bobj8h = dhReflTS.day + dhReflTS.twilight;
float _75fu70 = dhReflTS.night + dhReflTS.blueHour;
float _5f2oo5 = mix(0.15, 1.0, _bobj8h) + _75fu70 * 0.85;
float _avjypc = mix(WATER_REFLECTION_AMOUNT, max(WATER_REFLECTION_AMOUNT, 0.85), _75fu70) * _5f2oo5 * WATER_OPACITY;
_avjypc *= _61doab;
_avjypc *= _szngcf;
_avjypc = clamp(_avjypc, 0.0, 1.0);

float _2b263r = 1.0 / (1.0 + _2cvd85 * 0.005);
float _h2j7qg = frameTimeCounter * WATER_WAVE_SPEED;
vec2 _79fwy8 = _xlaso6.xz * WATER_WAVE_SCALE * 2.5;
float _tesqfw = sin(_79fwy8.x * 3.0 + _79fwy8.y * 0.3 + _h2j7qg * 1.5) * 0.5
+ sin(_79fwy8.x * 5.0 + _79fwy8.y * 0.5 + _h2j7qg * 2.2) * 0.3
+ sin(_79fwy8.x * 8.0 + _79fwy8.y * 0.2 + _h2j7qg * 3.0) * 0.2;
float _3ccbw4 = sin(_79fwy8.x * 0.3 + _79fwy8.y * 3.0 + _h2j7qg * 1.3) * 0.5
+ sin(_79fwy8.x * 0.5 + _79fwy8.y * 5.0 + _h2j7qg * 2.0) * 0.3;
_tesqfw *= _2b263r;
_3ccbw4 *= _2b263r;

vec3 _5l6xad = reflect(normalize(_xlaso6 - cameraPosition), _h6gefa);
_5l6xad.x += _tesqfw * 0.01;
_5l6xad.z += _3ccbw4 * 0.01;
_5l6xad = normalize(_5l6xad);

vec3 _zxtul4 = reflect(normalize(_u5ch89), _zs71tl);
_zxtul4.x += _tesqfw * 0.008;
_zxtul4.z += _3ccbw4 * 0.008;
_zxtul4 = normalize(_zxtul4);

bool _j1oi4g = false;
vec3 _i7qnln = vec3(0.0);
{

float _larq29 = _jwhmer(gl_FragCoord.xy);

float _jpq3xb = _2cvd85 * 0.015 + 0.25;
vec3 _8ruyl4 = _u5ch89 + _zs71tl * _jpq3xb;

float _88dbc4 = 1.0 + _larq29 * 1.5;
vec3 _vsfht3 = _zxtul4;
vec3 _88rlxp = _8ruyl4;

for (int i = 0; i < 32; i++) {
_88rlxp += _vsfht3 * _88dbc4;

vec4 _c1ax6l = dhProjection * vec4(_88rlxp, 1.0);
if (_c1ax6l.w <= 0.0) break;
vec3 _u9xa69 = (_c1ax6l.xyz / _c1ax6l.w) * 0.5 + 0.5;

if (_u9xa69.x < 0.0 || _u9xa69.x > 1.0 ||
_u9xa69.y < 0.0 || _u9xa69.y > 1.0) break;

float _cap3th = texture(dhDepthTex, _u9xa69.xy).r;
if (_yfr6tv(_cap3th)) {
float _nf98wt = _wf8ve2(_u9xa69.z);
float _0k11ym = _wf8ve2(_cap3th);
float _bv8q46 = _nf98wt - _0k11ym;

if (_bv8q46 > 0.0 && _bv8q46 < _88dbc4 * 2.0) {
float _yd66u5 = smoothstep(0.0, 0.08, min(_u9xa69.x, 1.0 - _u9xa69.x));
float _3wl2j7 = smoothstep(0.0, 0.08, min(_u9xa69.y, 1.0 - _u9xa69.y));
float _xmxpih = _yd66u5 * _3wl2j7;
if (_xmxpih > 0.01) {
_i7qnln = texture(colortex0, _u9xa69.xy).rgb;
_j1oi4g = true;

_i7qnln *= _xmxpih;
_j1oi4g = (_xmxpih > 0.3);
}
break;
}
}

_88dbc4 *= 1.22;
}
}

vec3 _o6gp8p = _b617kd(_5l6xad, _xlaso6, false);
float _3kxq7v = fract(sunAngle);
float _ovyudg = smoothstep(0.46, 0.54, _3kxq7v);
float _kp3w38 = mix(1.0, 0.6, _ovyudg);
float _qvw4je = smoothstep(0.54, 0.59, _3kxq7v) * (1.0 - smoothstep(0.92, 0.96, _3kxq7v));
_kp3w38 = mix(_kp3w38, 1.0, _qvw4je);
_o6gp8p *= _kp3w38 * 1.5;
float _quthxd = dot(_o6gp8p, vec3(0.299, 0.587, 0.114));
_o6gp8p = mix(vec3(_quthxd), _o6gp8p, WATER_SATURATION);

vec3 _h9jvbp = _j1oi4g ? _i7qnln : _o6gp8p;

_yssmf1 = mix(_yssmf1, _h9jvbp, _avjypc * WATER_BRIGHTNESS);

{
vec3 _8s1ue9 = normalize(shadowLightPosition);

float _l983hk = _2b263r * _2b263r;

float _lg0thg = frameTimeCounter * WATER_WAVE_SPEED * 0.5 * _l983hk;

#define DH_SPEC_HASH(p) fract(sin(dot(p, vec3(127.1, 311.7, 74.7))) * 43758.5453)
vec3 _iqpz5g = vec3(_xlaso6.xz * WATER_WAVE_SCALE * 0.4, _lg0thg * 0.25);
vec3 _l1y4ow = floor(_iqpz5g); vec3 _hg0h82 = fract(_iqpz5g);
_hg0h82 = _hg0h82 * _hg0h82 * (3.0 - 2.0 * _hg0h82);
float _0b3802 = mix(mix(mix(DH_SPEC_HASH(_l1y4ow), DH_SPEC_HASH(_l1y4ow+vec3(1,0,0)), _hg0h82.x),
mix(DH_SPEC_HASH(_l1y4ow+vec3(0,1,0)), DH_SPEC_HASH(_l1y4ow+vec3(1,1,0)), _hg0h82.x), _hg0h82.y),
mix(mix(DH_SPEC_HASH(_l1y4ow+vec3(0,0,1)), DH_SPEC_HASH(_l1y4ow+vec3(1,0,1)), _hg0h82.x),
mix(DH_SPEC_HASH(_l1y4ow+vec3(0,1,1)), DH_SPEC_HASH(_l1y4ow+vec3(1,1,1)), _hg0h82.x), _hg0h82.y), _hg0h82.z);
vec3 _3h661k = vec3(_xlaso6.xz * WATER_WAVE_SCALE * 0.9, _lg0thg * 0.6) + vec3(17.0);
vec3 _ot9dha = floor(_3h661k); vec3 _21zila = fract(_3h661k);
_21zila = _21zila * _21zila * (3.0 - 2.0 * _21zila);
float _klhcle = mix(mix(mix(DH_SPEC_HASH(_ot9dha), DH_SPEC_HASH(_ot9dha+vec3(1,0,0)), _21zila.x),
mix(DH_SPEC_HASH(_ot9dha+vec3(0,1,0)), DH_SPEC_HASH(_ot9dha+vec3(1,1,0)), _21zila.x), _21zila.y),
mix(mix(DH_SPEC_HASH(_ot9dha+vec3(0,0,1)), DH_SPEC_HASH(_ot9dha+vec3(1,0,1)), _21zila.x),
mix(DH_SPEC_HASH(_ot9dha+vec3(0,1,1)), DH_SPEC_HASH(_ot9dha+vec3(1,1,1)), _21zila.x), _21zila.y), _21zila.z);
#undef DH_SPEC_HASH

float _ynpclq = ((_0b3802 - 0.5) * 0.5 + (_klhcle - 0.5) * 0.3) * _l983hk;
float _c7s6i5 = ((_klhcle - 0.5) * 0.5 + (_0b3802 - 0.5) * 0.3) * _l983hk;
vec3 _i2whm1 = normalize(_zs71tl + mat3(gbufferModelView) * vec3(_ynpclq, 0.0, _c7s6i5));
vec3 _2oo9lz = normalize(_q8fnr3 + _8s1ue9);
float _4rko9x = max(dot(_i2whm1, _2oo9lz), 0.0);
float _r9jlt8 = smoothstep(0.95, 0.99, _4rko9x);
float _b16u8q = dhReflTS.day + dhReflTS.twilight * 0.7;
float _pfiej3 = 1.0 + dhReflTS.twilight * 2.0;
float _wnl61k = _r9jlt8 * _b16u8q * _pfiej3;
vec3 _fnj5el = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), dhReflTS.twilight);
_yssmf1 += _fnj5el * _wnl61k * WATER_SPECULAR_INTENSITY * _szngcf * mix(1.0, 0.1, smoothSwamp);
}
}

#endif

#if ICE_DEBUG_MODE != 2
if (_bm5ber && _7bqo1l(_2ql2nv)) {
vec3 _j9j27i;
bool _g3l5kb = (_alcc4c.a > 0.999);
if (_g3l5kb) {
_j9j27i = _7wyf50(texcoord, _2zs1mf);
} else {
_j9j27i = _uyoa3r(vec3(texcoord, _2zs1mf));
}
vec3 _37st8u = _zu00vj;
if (length(_37st8u) < 0.01) _37st8u = vec3(0.0, 1.0, 0.0);
vec3 _g61nc1 = normalize(mat3(gbufferModelView) * _37st8u);

float _2fea70 = texelFetch(colortex1, _2l09tc, 0).b;
float _qgi5bg = 0.3 * smoothstep(0.1, 0.8, _2fea70);

vec3 _4yidmq = _yssmf1;

_rynysb(_yssmf1, _j9j27i, _g61nc1, vec2(0.0, _2fea70), _qgi5bg, vec2(0.0), vec3(1.0), 0.0, 1.0, 1.0);

vec3 _u1wz1y = (gbufferModelViewInverse * vec4(_j9j27i, 1.0)).xyz + cameraPosition;
float _15s9kq = frameTimeCounter * 0.5;
float _dte8ji = sin(_u1wz1y.x * 2.5 + _u1wz1y.z * 0.3 + _15s9kq * 1.2) * 0.5
+ sin(_u1wz1y.x * 4.0 + _u1wz1y.z * 0.8 + _15s9kq * 1.8) * 0.3;
float _noe7hp = sin(_u1wz1y.z * 2.5 + _u1wz1y.x * 0.3 + _15s9kq * 1.0) * 0.5
+ sin(_u1wz1y.z * 4.0 + _u1wz1y.x * 0.6 + _15s9kq * 1.5) * 0.3;

vec3 _zm6e81 = _g61nc1;
_zm6e81.x += _dte8ji * 0.03;
_zm6e81.z += _noe7hp * 0.03;
_zm6e81 = normalize(_zm6e81);

vec3 _q5xewt = normalize(shadowLightPosition);
vec3 _6eyn5e = normalize(-_j9j27i);
vec3 _9c4ve5 = normalize(_6eyn5e + _q5xewt);
float _y3qp6i = max(dot(_zm6e81, _9c4ve5), 0.0);
float _kbewin = smoothstep(0.985, 0.995, _y3qp6i);
TimeWeightsSimple iceTS = getTimeWeightsSimple(sunAngle);
float _ltcmnd = iceTS.day + iceTS.twilight * 0.7;
float _f3b2a5 = 1.0 + iceTS.twilight * 2.0;
float _6gp8xl = _kbewin * _ltcmnd * _2fea70 * _f3b2a5;
vec3 _gy49b2 = mix(vec3(1.0, 0.95, 0.85),
vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B), iceTS.twilight);

vec3 _pkal6g = (gbufferModelViewInverse * vec4(_j9j27i, 1.0)).xyz;
vec4 _e81ct4 = shadowProjection * shadowModelView * vec4(_pkal6g, 1.0);
vec3 _40n7gf = _2y5umb(_e81ct4.xyz / _e81ct4.w);
vec3 _z78uvl = _40n7gf * 0.5 + 0.5;
float _ug8rp0 = 0.0;
if (_z78uvl.x > 0.0 && _z78uvl.x < 1.0 && _z78uvl.y > 0.0 && _z78uvl.y < 1.0) {
_ug8rp0 = step(_z78uvl.z - 0.001, texture(shadowtex0, _z78uvl.xy).r);
}
_yssmf1 += _gy49b2 * _6gp8xl * WATER_SPECULAR_INTENSITY * _ug8rp0;
}
#endif

#if ICE_DEBUG_MODE == 3

if (_bm5ber)      _yssmf1 = mix(_yssmf1, vec3(1.0, 0.0, 1.0), 0.5);
else if (isWater)    _yssmf1 = mix(_yssmf1, vec3(1.0, 1.0, 0.0), 0.5);
else if (_2uxgrb) _yssmf1 = mix(_yssmf1, vec3(0.0, 1.0, 0.0), 0.5);
#endif

#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)
#ifndef WATER_REFLECTION_DEBUG

if (false && (isWater || _etzcl6) && _ju8znl && isEyeInWater != 1) {
float _qahbnu;
if (_etzcl6) {
vec4 _n80w6r = dhProjectionInverse * vec4(texcoord * 2.0 - 1.0, _ips7jr * 2.0 - 1.0, 1.0);
_qahbnu = -_n80w6r.z / _n80w6r.w;
} else {
vec4 _4ozgo0 = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_qahbnu = -_4ozgo0.z / _4ozgo0.w;
}

float fogDensity = mix(0.025, 2.0, biome_swamp);
float _bs5gl8 = mix(0.95, 1.0, biome_swamp);
float _dppv7e = 1.0 - exp(-_qahbnu * fogDensity);
_dppv7e = clamp(_dppv7e, 0.0, _bs5gl8);

if (_dppv7e > 0.001) {
float _7jexot = fract(sunAngle);
float _u2bg4c = smoothstep(0.40, 0.48, _7jexot) * (1.0 - smoothstep(0.48, 0.55, _7jexot))
+ smoothstep(0.94, 1.0, _7jexot) + (1.0 - smoothstep(0.0, 0.06, _7jexot));
if (_u2bg4c > 0.001) {
float _scsgwb = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1 = mix(_yssmf1, vec3(_scsgwb), _u2bg4c * 0.6);
}
vec3 _w95fch = _xwb441(sunAngle, 1.0, 0.0, 0.0, 0.0, 0.0);
vec3 _34qfhm = vec3(0.04, 0.08, 0.02);
vec3 _e3558u = mix(_w95fch, _34qfhm, biome_swamp);
_yssmf1 *= mix(vec3(1.0), _e3558u * 3.0, _dppv7e);
_yssmf1 += _e3558u * _dppv7e;
}
}

#endif
#endif

#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)
#ifndef WATER_REFLECTION_DEBUG

#ifdef WATER_FOAM_ENABLED
if ((isWater || _etzcl6) && _ju8znl && _wowu50 > 0.01 && _iio55e > 0.001 && isEyeInWater != 1) {
vec4 _uvi6pi = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
float _zoab65 = max(-_uvi6pi.z / _uvi6pi.w, 1.0);
int _qit7y2 = clamp(int(_zoab65 * 0.15), 2, 20);
ivec2 _lg8ofx = ivec2(viewWidth - 1.0, viewHeight - 1.0);
float _c812gk = texelFetch(colortex5, clamp(_2l09tc + ivec2(-_qit7y2, 0), ivec2(0), _lg8ofx), 0).x;
float _gjidtf = texelFetch(colortex5, clamp(_2l09tc + ivec2( _qit7y2, 0), ivec2(0), _lg8ofx), 0).x;
float _rxuxq7 = abs(_gjidtf - _c812gk);
float _dpxz4g = 0.0;
_yssmf1 *= mix(vec3(1.0), vec3(0.75, 0.88, 0.90), _dpxz4g);
}
#endif

bool _m91v4p = (_2zs1mf < _b8i8m4 - 0.0001) && !_h278bp;
bool _z9y8eb = (_ehp903.a > 0.55 && _ehp903.a < 0.65) && _m91v4p && (_p94ooe > 0.001);
#ifdef GLASS_FILTER_ENABLED
if (_z9y8eb && !_h278bp) {
vec3 tint = max(_ehp903.rgb, vec3(0.0));
float _5linhz = max(max(tint.r, tint.g), tint.b);
if (_5linhz > 0.01) {
tint /= _5linhz;
float _pg1f5w = clamp(GLASS_FILTER_SATURATION, 0.5, 1.35);
float _03vtqp = dot(tint, vec3(0.299, 0.587, 0.114));
tint = mix(vec3(_03vtqp), tint, _pg1f5w);
tint = clamp(tint, vec3(0.0), vec3(1.5));

vec3 _7kfc8t = _yssmf1 * tint;
float _4izkmo = max(dot(max(_yssmf1, vec3(0.0)), vec3(0.299, 0.587, 0.114)), 0.001);
float _1f6jtq = max(dot(max(_7kfc8t, vec3(0.0)), vec3(0.299, 0.587, 0.114)), 0.001);
_7kfc8t *= _4izkmo / _1f6jtq;

float _2pzym2 = clamp(_p94ooe, 0.0, 1.0);
float _nuzjng = clamp(GLASS_FILTER_STRENGTH * GLASS_FILTER_ENFORCEMENT * _2pzym2, 0.0, 0.45);
_yssmf1 = mix(_yssmf1, _7kfc8t, _nuzjng);
}
}
#endif

#if defined(WATER_REFLECTIONS_ENABLED) || defined(MATERIAL_REFLECTIONS_ENABLED)
#ifndef WATER_REFLECTION_DEBUG
bool _tb2ibx = (_a2jf3a.y > 0.9 && _a2jf3a.y < 0.99);

float _1dslcr = 0.0;
{
vec3 _81ymew;
if (_wgkw3q) {
_81ymew = _7wyf50(texcoord, _2zs1mf);
} else {
vec4 fc = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_81ymew = fc.xyz / fc.w;
}
_1dslcr = ((gbufferModelViewInverse * vec4(_81ymew, 1.0)).xyz + cameraPosition).y;
}
bool _dn4308 = (_1dslcr > float(SEA_LEVEL_OFFSET) - 1.5 && _1dslcr < float(SEA_LEVEL_OFFSET) + 1.5);
if ((isWater || _etzcl6) && _ju8znl && isEyeInWater != 1 && _szngcf > 0.01 && !_tb2ibx && _dn4308) {
float _wu2c3e = smoothstep(0.5, 1.0, _a2jf3a.x);
vec3 _64i9yz = vec3(WATER_FOAM_COLOR_R, WATER_FOAM_COLOR_G, WATER_FOAM_COLOR_B) * WATER_FOAM_INTENSITY;

TimeWeightsSimple foamTS = getTimeWeightsSimple(sunAngle);
float _d3gvsd = fract(sunAngle);
float _zspxxe = smoothstep(0.50, 0.60, _d3gvsd) * (1.0 - smoothstep(0.92, 0.98, _d3gvsd));
float _ic9plf = mix(1.0, 0.55, _zspxxe);
_64i9yz *= _ic9plf;

vec3 _kwg48q;
if (_wgkw3q) {
_kwg48q = (gbufferModelViewInverse * vec4(_7wyf50(texcoord, _2zs1mf), 1.0)).xyz;
} else {
vec4 _6b4y0f = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_kwg48q = (gbufferModelViewInverse * vec4(_6b4y0f.xyz / _6b4y0f.w, 1.0)).xyz;
}
vec3 _ml2863 = normalize(_kwg48q);
vec3 _nipdat = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _5s2zwk = max(dot(_ml2863, _nipdat), 0.0);
float _1nen5w = foamTS.twilight * 2.0 + foamTS.day * 0.5;
float _j01z5t = 1.0 + pow(_5s2zwk, 4.0) * _1nen5w;
_64i9yz *= _j01z5t;
_yssmf1 = mix(_yssmf1, _64i9yz, _wu2c3e * _szngcf * (1.0 - smoothSwamp));
}
#endif
#endif

if ((isWater || _etzcl6) && _ju8znl && isEyeInWater != 1 && _szngcf > 0.01 && !_tb2ibx && _dn4308 && smoothSwamp < 0.99) {

vec3 _ttsb4o;
if (_wgkw3q) {
_ttsb4o = _7wyf50(texcoord, _2zs1mf);
} else {
vec4 _ficete = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
_ttsb4o = _ficete.xyz / _ficete.w;
}
vec3 _x4s0jk = (gbufferModelViewInverse * vec4(_ttsb4o, 1.0)).xyz + cameraPosition;
vec2 _0fdp2x = floor(_x4s0jk.xz * 16.0) / 16.0;

float st = frameTimeCounter * WATER_WAVE_SPEED;

float ct = st * 0.15;
vec3 _0rl3ii = vec3(_0fdp2x.x, 0.0, _0fdp2x.y) * 0.35;

float cA = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _0rl3ii;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
cA += abs(_lpglwu(p * _oah0e7 + ct * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
cA = 1.0 - cA / _56jsby;
}
float cB = 0.0;
{
float _jkk37u = 1.0, _oah0e7 = 0.7, _56jsby = 0.0;
vec3 p = _0rl3ii + 5.0;
for (int i = 0; i < 2; i++) {
p = vec3(p.x * 0.866 - p.z * 0.5, p.y, p.x * 0.5 + p.z * 0.866);
cB += abs(_lpglwu(p * _oah0e7 + ct * 1.15 * (1.0 + float(i) * 0.3)) - 0.5) * _jkk37u;
_56jsby += _jkk37u * 0.5;
_jkk37u *= 0.5;
_oah0e7 *= 2.0;
}
cB = 1.0 - cB / _56jsby;
}
float _t24xx2 = min(cA, cB);
_t24xx2 = pow(_t24xx2, 2.0) * 2.5;
_t24xx2 = max(_t24xx2 - 0.15, 0.0) * (1.0 / 0.85);

float _37dwn5 = _lpglwu(vec3(_0fdp2x * 4.0, ct * 0.5)) * 0.4;
_t24xx2 += _37dwn5;

_t24xx2 = floor(_t24xx2 * 5.0 + 0.5) / 5.0;
_t24xx2 = max(_t24xx2, 0.0);

vec3 _8pcya6 = _9ruyvd(sunAngle, 0.2);

TimeWeightsSimple specTS = getTimeWeightsSimple(sunAngle);
float _01j10j = specTS.day * 1.0 + specTS.twilight * 0.8 + (specTS.night + specTS.blueHour) * 0.1;

float _v0cq2w = length(_ttsb4o);
float _0u0vq9 = _wgkw3q
? 0.35 * (1.0 - smoothstep(2048.0, 4096.0, _v0cq2w))
: 1.0 - smoothstep(80.0, 200.0, _v0cq2w);

float _8jz3rx = texelFetch(colortex1, _2l09tc, 0).b;
float _51djm0 = smoothstep(0.5, 0.8, _8jz3rx);

vec3 _v7azl1 = normalize(_x4s0jk - cameraPosition);
vec3 _wwcrp0 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _wnr39r = max(dot(_v7azl1, _wwcrp0), 0.0);
float _embnb1 = specTS.twilight * 3.0 + specTS.day * 1.0;
float _5jqpm7 = 1.0 + pow(_wnr39r, 4.0) * _embnb1;

vec3 _wi52nt = _8pcya6 * _t24xx2 * _01j10j * _0u0vq9 * _51djm0 * 0.07 * _5jqpm7 * (1.0 - smoothSwamp);
_yssmf1 += _wi52nt * _szngcf;
}

_622i54 = vec4(0.0);
#ifdef MATERIAL_REFLECTIONS_ENABLED
{
bool _u0py49 = _28w8fp;
bool _xz1uey = _kt17lp;
if (_y9l8xx && isEyeInWater != 1 && !_u0py49 && !_xz1uey) {
if (_2zs1mf < 1.0) {
float _7gjbuw = _a2jf3a.z * 2.0 - 1.0;
float _hyvjmy = _a2jf3a.w * 2.0 - 1.0;
bool _0ieh9w = _r0mj6q(_a2jf3a.y);
float _2yrtlk = _0ieh9w
? _olzjaf(_a2jf3a.y)
: 1.0;
float _7hg859 = sqrt(max(1.0 - _7gjbuw * _7gjbuw - _hyvjmy * _hyvjmy, 0.0)) * _2yrtlk;
vec3 _tkgg08 = vec3(_7gjbuw, _hyvjmy, _7hg859);
vec3 _pi9d5v = normalize(mat3(gbufferModelView) * _tkgg08);

float _xp73ke = clamp(_a2jf3a.x, 0.0, 1.0);
float _pkbby0 = 0.0;
#ifdef PBR_ENABLED
_mo1vol(_a2jf3a, _xp73ke, _pkbby0);
#endif

if (_0ieh9w) _pkbby0 = 0.0;
float _brkljl = 1.0 - sqrt(clamp(_xp73ke, 0.0, 1.0));

vec3 _53i0wc = vec3(texcoord, _2zs1mf);
vec3 _bhn8ab = _uyoa3r(_53i0wc);
float _605k1y = texelFetch(colortex1, _2l09tc, 0).b;

vec3 V = normalize(-_bhn8ab);
float _i9o95p = max(dot(_pi9d5v, V), 0.0);

float _ewltmj = 1.0 - _i9o95p;
float _bdaki2 = (1.0 - _brkljl) * 0.7;
float _7ziqie = max(_ewltmj - _bdaki2, 0.0) / max(1.0 - _bdaki2, 0.001);
_7ziqie = _7ziqie * _7ziqie;
_7ziqie = max(_7ziqie * sqrt(max(_brkljl, 0.0)) - _jwhmer(gl_FragCoord.xy) * 0.01, 0.0);

float _gu4bua = smoothstep(0.02, 0.10, fract(sunAngle)) * (1.0 - smoothstep(0.40, 0.48, fract(sunAngle)));
float _a3qff0 = smoothstep(7.0 / 15.0, 12.0 / 15.0, _605k1y);
float _7q116t = clamp(MATERIAL_REFLECTION_AMOUNT, 0.0, 1.0);
float _gyvs34 = max(_7ziqie, _brkljl * 0.35);
float _4kfrur = _7q116t * MATERIAL_REFLECTION_FRESNEL;
_4kfrur *= _gyvs34;
_4kfrur *= mix(1.0, mix(0.1, 1.0, _gu4bua), _a3qff0);
float _9wbplh = max(_4kfrur, _7q116t * (0.45 + 0.55 * _brkljl));
float _zjrr00 = mix(_4kfrur, _9wbplh, _pkbby0);

float _g1b400 = length(_bhn8ab);
float _dbuluw = 1.0 - smoothstep(float(SSR_RENDER_DISTANCE) * 0.8, float(SSR_RENDER_DISTANCE), _g1b400);
_zjrr00 *= _dbuluw;

if (_zjrr00 > 0.001) {

vec3 _llic46 = _yssmf1;
float _gmp6zb = _605k1y;
float _sn9hxp = _zjrr00;
_s6xcsn(_yssmf1, _bhn8ab, _pi9d5v, _sn9hxp, _gmp6zb, _xp73ke);

vec3 _1rzokf = _yssmf1 - _llic46;
_622i54 = vec4(_1rzokf, 1.0);

_yssmf1 = _llic46;
}

}
}
}
#endif

#if defined(PUDDLES_ENABLED)
{
float rs = clamp(rainStrength, 0.0, 1.0);
float _dhvutn = clamp(PUDDLES_STRENGTH, 0.0, 1.0) * rs;

_dhvutn *= (1.0 - clamp(biome_arid, 0.0, 1.0)) * (1.0 - clamp(biome_snowy, 0.0, 1.0));

float _93d7sl = _cr41tl;
bool _k13xwz = _28w8fp;
if (!isWater && !_kt17lp && !_k13xwz && _dhvutn > 0.0001 && isEyeInWater != 1) {
float _jujpg7 = _93d7sl;
float _13rsme = texelFetch(colortex1, _2l09tc, 0).b;
float _195n7k = texelFetch(colortex1, _2l09tc, 0).r;
bool _r8vx3d = (_195n7k < 0.1);
if (_7bqo1l(_jujpg7) && _13rsme > 0.95 && !_r8vx3d) {
vec2 px = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0));
vec3 _widkrb = _uyoa3r(vec3(texcoord, _jujpg7));
float dR = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(1, 0)), 0).r;
float dL = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(-1, 0)), 0).r;
float dU = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, -1)), 0).r;
float dD = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, 1)), 0).r;
vec3 vR = _uyoa3r(vec3(texcoord + vec2(px.x, 0.0), dR));
vec3 vL = _uyoa3r(vec3(texcoord - vec2(px.x, 0.0), dL));
vec3 vU = _uyoa3r(vec3(texcoord - vec2(0.0, px.y), dU));
vec3 vD = _uyoa3r(vec3(texcoord + vec2(0.0, px.y), dD));
vec3 _omtxs4 = vR - vL;
vec3 _zq8qas = vD - vU;
vec3 _xg1atf = normalize(cross(_omtxs4, _zq8qas));
vec3 _kgvkrd = normalize(gbufferModelView[1].xyz);
float _oy0rvo = clamp(abs(dot(_xg1atf, _kgvkrd)), 0.0, 1.0);
float _m9yqla = smoothstep(0.85, 0.98, _oy0rvo);

vec3 _h4gwes = (gbufferModelViewInverse * vec4(_widkrb, 1.0)).xyz;
vec3 _virvf6 = _h4gwes + cameraPosition;
float n = _cks7vw(_virvf6.xz * 0.12);
float _quhal2 = smoothstep(0.62, 0.86, n);
_quhal2 = pow(_quhal2, 1.35);
float _6yhcvq = smoothstep(0.56, 0.82, n);
float _aac565 = _quhal2;
float _vb59sc = clamp(_6yhcvq - _aac565, 0.0, 1.0);

float _ugpysn = smoothstep(0.90, 0.98, _13rsme);
float _crbmp4 = _dhvutn * _m9yqla * _quhal2 * _ugpysn;
if (_crbmp4 > 0.0001) {
float _pwjgx8 = mix(1.0, 0.80, _crbmp4);
_pwjgx8 *= mix(1.0, 0.82, _vb59sc * _dhvutn);
_yssmf1 *= _pwjgx8;
_yssmf1 += vec3(0.03) * _vb59sc * _dhvutn;

vec3 _k8hw2a = normalize(mix(_xg1atf, _kgvkrd, 0.75));

float _i6s1i1 = _crbmp4 * clamp(PUDDLES_REFLECTION_STRENGTH, 0.0, 1.0);
_i6s1i1 *= mix(0.85, 1.20, _quhal2);
_8g66fe(_yssmf1, _widkrb, _k8hw2a, vec2(0.0, 1.0), _i6s1i1, vec2(0.0), vec3(1.0), 0.0);
}
}
}
}
#endif

#if defined(WALL_RUNOFF_ENABLED)
{
float rs = clamp(rainStrength, 0.0, 1.0);
float _shwujn = clamp(WALL_RUNOFF_STRENGTH, 0.0, 1.0) * rs;
if (!isWater && _shwujn > 0.0001 && isEyeInWater != 1) {
float _13rsme = texelFetch(colortex1, _2l09tc, 0).b;

float _dx68iw = smoothstep(0.80, 0.96, _13rsme);
if (_dx68iw > 0.001) {
float _flyxix = texelFetch(depthtex2, _2l09tc, 0).r;
if (_7bqo1l(_flyxix)) {
vec2 px = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0));
vec3 _zp3pqx = _uyoa3r(vec3(texcoord, _flyxix));
float _44487g = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(1, 0)), 0).r;
float _u639gk = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(-1, 0)), 0).r;
float _7gt8bb = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, -1)), 0).r;
float _5kcs1f = texelFetch(depthtex2, ivec2(_2l09tc + ivec2(0, 1)), 0).r;
vec3 _tcm15w = _uyoa3r(vec3(texcoord + vec2(px.x, 0.0), _44487g));
vec3 _o5wxx8 = _uyoa3r(vec3(texcoord - vec2(px.x, 0.0), _u639gk));
vec3 _om64ud = _uyoa3r(vec3(texcoord - vec2(0.0, px.y), _7gt8bb));
vec3 _7yd6bw = _uyoa3r(vec3(texcoord + vec2(0.0, px.y), _5kcs1f));
vec3 _0njql1 = _tcm15w - _o5wxx8;
vec3 _sny3q6 = _7yd6bw - _om64ud;
vec3 _3icj0v = normalize(cross(_0njql1, _sny3q6));
vec3 _9ax0mw = normalize(gbufferModelView[1].xyz);
float _odbw4j = clamp(abs(dot(_3icj0v, _9ax0mw)), 0.0, 1.0);
float _iilw4w = 1.0 - smoothstep(0.30, 0.70, _odbw4j);

vec3 _bdl8m5 = (gbufferModelViewInverse * vec4(_zp3pqx, 1.0)).xyz;
vec3 _t9wask = _bdl8m5 + cameraPosition;

float _uurrfu = _qcukfb(_t9wask.xz * 0.90);
float _0b3yy5 = _t9wask.x * 2.2 + _t9wask.z * 1.7 + _uurrfu * 2.0;
float _pa8k6j = fract(_0b3yy5);
float _7dbvbt = 1.0 - abs(_pa8k6j - 0.5) * 2.0;
_7dbvbt = pow(clamp(_7dbvbt, 0.0, 1.0), 6.0);

float t = frameTimeCounter * clamp(WALL_RUNOFF_SPEED, 0.0, 5.0);
float _9qq73p = fract(_t9wask.y * 1.25 - t + _uurrfu);
float _jbizr2 = min(_9qq73p, 1.0 - _9qq73p);
float _n5wopi = 1.0 - smoothstep(0.00, 0.10, _jbizr2);

float _q4j75g = _shwujn * _dx68iw * _iilw4w * _7dbvbt;

_q4j75g *= mix(0.88, 1.0, _n5wopi);
_q4j75g = clamp(_q4j75g, 0.0, 1.0);

if (_q4j75g > 0.0001) {

vec3 _lwzedv = _yssmf1 * vec3(0.88, 0.92, 0.96);
_yssmf1 = mix(_yssmf1, _lwzedv, _q4j75g);
}
}
}
}
}
#endif

#endif
#endif

if (isEyeInWater != 1 && (isWater || _etzcl6 || _wgkw3q)) {
vec4 _hyop77 = texture(colortex8, texcoord);
float _1ntexb = clamp(1.0 - _xszwck, 0.0, 1.0);
if (_1ntexb > 0.001) {
_yssmf1 = _yssmf1 * (1.0 - _1ntexb) + _hyop77.rgb;
}
}

#ifdef SHADOWS_ENABLED
if (isEyeInWater != 1 && (isWater || _etzcl6) && !_wgkw3q) {
vec4 _7wafff = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
vec3 _xy2m0t = _7wafff.xyz / _7wafff.w;
vec3 _u6pa8o = (gbufferModelViewInverse * vec4(_xy2m0t, 1.0)).xyz;
vec4 _29lfkg = shadowProjection * shadowModelView * vec4(_u6pa8o, 1.0);
vec3 _517rqy = _2y5umb(_29lfkg.xyz);
vec3 _kdtomp = _517rqy * 0.5 + 0.5;
_kdtomp.z -= 0.001;
float _xbgga8 = 1.0;
if (_kdtomp.x > 0.0 && _kdtomp.x < 1.0 &&
_kdtomp.y > 0.0 && _kdtomp.y < 1.0 &&
_kdtomp.z > 0.0 && _kdtomp.z < 1.0) {
_xbgga8 = step(_kdtomp.z, texture(shadowtex0, _kdtomp.xy).r);
}

_xbgga8 = mix(1.0, _xbgga8, _s4lpf1(_kdtomp));

_xbgga8 = mix(1.0, _xbgga8, SHADOW_OPACITY * 0.5);
_yssmf1 *= _xbgga8;
}
#endif

if (isEyeInWater != 1) {

bool _aqgfno = (_alcc4c.g > 0.5);
float _jfm5x8 = dot(max(_yssmf1, vec3(0.0)), vec3(0.299, 0.587, 0.114));
float _o9zacs = _aqgfno ? smoothstep(0.08, 0.32, _jfm5x8) : 0.0;
#ifdef NETHER_FOG_ENABLED

if (_jxqxpy) _o9zacs = 0.0;
#endif
float _ckgfiz = mix(1.0, 0.15, _o9zacs);

float _5rqee5 = dot(max(_8u1o7c.rgb, vec3(0.0)), vec3(0.299, 0.587, 0.114));
float _gt53py =
smoothstep(0.001, 0.035, _p94ooe) *
smoothstep(0.12, 0.45, _5rqee5) *
(_2994yj ? 0.0 : 1.0) *
(_2uxgrb ? 0.0 : 1.0) *
((_m995av.y > 0.5 || isWater || _etzcl6 || _wgkw3q || _y9l8xx) ? 0.0 : 1.0);

#if defined(HAZE_FOG_ACTIVE) || defined(NETHER_FOG_ENABLED)
{
vec4 _wmzd8j = _8agsfg(colortex10, texcoord);

if (_ws7m2h) _wmzd8j = vec4(0.0);
_wmzd8j *= 1.0 - _gt53py;
#ifdef HAZE_FOG_ACTIVE
if (!_9cwhip(biome)) {
float _mjt7k5 = texture(vxDepthTexTrans, texcoord).r;
bool _bdztl7 = (_2fqi4q(vxProjInv) && _7bqo1l(_mjt7k5)) || (_alcc4c.a > 0.999);
bool _l17qh9 = _yjolhc && !_yfr6tv(_ips7jr) && !_bdztl7;
if (_l17qh9) _wmzd8j = vec4(0.0);
}
#endif
if (_wmzd8j.a > 0.001) {
float _bjqjnw = _wmzd8j.a * _ckgfiz;
_yssmf1 = _wmzd8j.rgb * _ckgfiz + _yssmf1 * (1.0 - _bjqjnw);
}
}
#endif

#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED) || defined(CAVE_FOG_ENABLED)
{
vec4 _5frq09 = _8agsfg(colortex9, texcoord);
_5frq09 *= _xszwck;

if (_5frq09.a > 0.001) {
float _wr1t2f = _5frq09.a * _ckgfiz;
_yssmf1 = _5frq09.rgb * _ckgfiz + _yssmf1 * (1.0 - _wr1t2f);
}
}
#endif

#ifdef WEATHER_FOG_ENABLED
{
vec4 _s1fxzx = _8agsfg(colortex11, texcoord);
if (_s1fxzx.a > 0.001) {
float _kj2obo = _ckgfiz;
#ifdef STORM_EFFECTS_ENABLED

float _3qc34e = max(
clamp(biome_arid, 0.0, 1.0),
max(clamp(biome_snowy, 0.0, 1.0) - clamp(biome_swamp, 0.0, 1.0) * 0.5, 0.0)
) * clamp(rainStrength, 0.0, 1.0);
_kj2obo = mix(
_kj2obo,
1.0,
smoothstep(0.05, 0.65, _3qc34e)
);
#endif
float _j5k9w4 = _s1fxzx.a * _kj2obo;
_yssmf1 = _s1fxzx.rgb * _kj2obo + _yssmf1 * (1.0 - _j5k9w4);
}
}
#endif

if (_hopnkv && !_28w8fp) {
vec4 _5p15qq = _8u1o7c;
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
{
float _5rqee5 = dot(max(_5p15qq.rgb, vec3(0.0)), vec3(0.299, 0.587, 0.114));
bool _unda4s = (_5p15qq.a < 0.9 && _5rqee5 < 0.04 && _ehp903.a <= 0.01);
if (_unda4s) {
float _xxfl7v = 1.0 - getEndEvent(frameTimeCounter).terrainDarkness;
_5p15qq.rgb *= _xxfl7v;
_5p15qq.a *= _xxfl7v;
}
}
#endif
_yssmf1 = _yssmf1 * (1.0 - _5p15qq.a) + _5p15qq.rgb;
}

#ifdef TORNADO_LEAVES_ENABLED
{
float _pj6adr = texture(depthtex1, texcoord).r;
bool _dsymzw = _pj6adr >= 0.999999;
float _oiablf = 10.0 / 15.0;
float _h0l6yb = texture(colortex1, texcoord).b;
float _0w16x9 = clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0);
bool _iix163 = _h0l6yb > _oiablf || (_dsymzw && _0w16x9 > _oiablf);
if (_iix163) {
vec4 _clj5xh = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _pj6adr * 2.0 - 1.0, 1.0);
vec3 _8ixl2m = _clj5xh.xyz / _clj5xh.w;
vec3 _qpxijo = (gbufferModelViewInverse * vec4(_8ixl2m, 1.0)).xyz;
vec3 _3lq7iy   = normalize(_qpxijo);
float _letyj1 = length(_qpxijo);
vec4 _h1qb4z = _m6v1zx(cameraPosition, _3lq7iy, _letyj1, frameTimeCounter);
_yssmf1 = mix(_yssmf1, _h1qb4z.rgb, _h1qb4z.a);
vec4 _vrm37i = _g3wuwv(cameraPosition, _3lq7iy, _letyj1, frameTimeCounter);
_yssmf1 = mix(_yssmf1, _vrm37i.rgb, _vrm37i.a);
}
}
#endif
}

if (isEyeInWater == 1) {
float _8db01s = texture(depthtex0, texcoord).r;
float _v3ixnx = texture(vxDepthTexTrans, texcoord).r;
bool _5un4fd = _2fqi4q(vxProjInv) && (_alcc4c.a > 0.999) && _7bqo1l(_v3ixnx);
bool _qjcioo = (_8db01s < 1.0) || _5un4fd;
if (_qjcioo) {
float _qeo3d1 = texture(colortex1, texcoord).g;

float _gm697x = (_qeo3d1 > 0.5) ? 0.15 : 1.0;
vec3 _din5zd;
if (_5un4fd && !_7bqo1l(_8db01s)) {
vec4 _fvg5u7 = vec4(texcoord * 2.0 - 1.0, _v3ixnx * 2.0 - 1.0, 1.0);
vec4 _7oho7s = vxProjInv * _fvg5u7;
_din5zd = _7oho7s.xyz / _7oho7s.w;
} else {
vec4 _fvg5u7 = vec4(texcoord * 2.0 - 1.0, _8db01s * 2.0 - 1.0, 1.0);
vec4 _7oho7s = gbufferProjectionInverse * _fvg5u7;
_din5zd = _7oho7s.xyz / _7oho7s.w;
}
float _4tgkt5 = length(_din5zd);
float _pp1xrs = smoothstep(0.0, 40.0, _4tgkt5) * 0.6 * _gm697x;
vec3 _fjnc3n = vec3(UNDERWATER_FOG_R, UNDERWATER_FOG_G, UNDERWATER_FOG_B);
float _l0bgts = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _hqpe8l = _l0bgts * _fjnc3n;
_yssmf1 = mix(_yssmf1, _hqpe8l, _pp1xrs);
}
}

#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED)
if (isEyeInWater == 1) {
vec4 _5frq09 = _8agsfg(colortex9, texcoord);
if (_5frq09.a > 0.001) {
float _qmkhf9 = texture(colortex1, texcoord).g;
float _i7t2yn = _qmkhf9 * 0.5 * (1.0 - smoothstep(0.3, 0.6, _5frq09.a));
float _w2eeyu = _5frq09.a * (1.0 - _i7t2yn);
_yssmf1 = _5frq09.rgb * (_w2eeyu / max(_5frq09.a, 0.001)) + _yssmf1 * (1.0 - _w2eeyu);
}
}
#endif

#ifdef UNDERWATER_FOG_ENABLED
if (isEyeInWater == 1) {
vec4 _h1cocf = texture(colortex8, texcoord);
float _t1428e = clamp(1.0 - _xszwck, 0.0, 1.0);
float _z9ilrg = float(SEA_LEVEL_OFFSET) - cameraPosition.y;
float _ocg1e7 = smoothstep(0.5, 6.0, _z9ilrg);
_t1428e *= (1.0 - _ocg1e7);
_h1cocf.rgb *= (1.0 - _ocg1e7);
if (_t1428e > 0.001 && !_h278bp && !_kgt9i1) {
_yssmf1 += _h1cocf.rgb * _t1428e;
}
}
#endif

#if !defined(NETHER_SHADER) && !defined(END_SHADER)
{
vec2 _x30m22 = _drk3b8();
float _9uskbg = fract(sunAngle);
float _5wptqb = smoothstep(0.02, 0.08, _9uskbg) * (1.0 - smoothstep(0.42, 0.48, _9uskbg));
float _l7nr0z = smoothstep(0.0, 0.03, _9uskbg) * (1.0 - smoothstep(0.06, 0.10, _9uskbg));
float _osel2d  = smoothstep(0.40, 0.44, _9uskbg) * (1.0 - smoothstep(0.46, 0.48, _9uskbg));
float _coedud = _5wptqb + max(_l7nr0z, _osel2d) * 0.5;

if (_x30m22.x > -0.5 && _coedud > 0.001) {
vec2 _ic9jj6 = texcoord - _x30m22;
_ic9jj6.x *= viewWidth / viewHeight;
float _t25r5m = length(_ic9jj6);

float _0kcimn = 1.0 - smoothstep(0.0, 0.25, abs(_9uskbg - 0.25));
float _h7gypw = mix(1.0, 1.8, _0kcimn);

float r = SUN_GLOW_RADIUS * 0.08 * _h7gypw;
float _jjyhed = exp(-_t25r5m * _t25r5m / (r * r));

float r2 = SUN_GLOW_RADIUS * 0.2 * _h7gypw;
float _nbz5uy = 1.0 / (1.0 + pow(_t25r5m / r2, 4.0));

float _hl0eel = _jjyhed * 0.35 + _nbz5uy * 0.08;
_hl0eel *= _coedud * SUN_GLOW_INTENSITY;
if (isEyeInWater == 1) _hl0eel *= 0.0;

bool _p48by5 = _yjolhc && !_yfr6tv(_ips7jr);
if (!_p48by5) {
#ifdef WEATHER_FOG_ENABLED
float _jj2kyj = _8agsfg(colortex11, texcoord).a;
_hl0eel *= _jj2kyj * 0.5;
#else
_hl0eel = 0.0;
#endif
}
_hl0eel *= smoothstep(0.0, 0.15, max(rainStrength, biome_swamp));

_yssmf1 += vec3(1.0) * _hl0eel;
}
}
#endif

#if !defined(NETHER_SHADER) && !defined(END_SHADER)
{
vec3 _dyorla = normalize(moonPosition);
vec3 _ojvojc = _dyorla * 1000.0;
vec4 _a2d5mm = gbufferProjection * vec4(_ojvojc, 1.0);
if (_a2d5mm.w > 0.00001) {
vec2 _9psmjx = (_a2d5mm.xy / _a2d5mm.w) * 0.5 + 0.5;
float _xxa6du = fract(sunAngle);
float _00nx1g = smoothstep(0.52, 0.58, _xxa6du) * (1.0 - smoothstep(0.94, 0.98, _xxa6du));

if (_00nx1g > 0.001) {
vec2 _m0t3cb = texcoord - _9psmjx;
_m0t3cb.x *= viewWidth / viewHeight;
float _rjy12c = length(_m0t3cb);

float mr = SUN_GLOW_RADIUS * 0.12;
float _xf6zml = exp(-_rjy12c * _rjy12c / (mr * mr));

float _5h2ei7 = SUN_GLOW_RADIUS * 0.35;
float _5avmb3 = 1.0 / (1.0 + pow(_rjy12c / _5h2ei7, 4.0));

float _krasn9 = _xf6zml * 0.25 + _5avmb3 * 0.04;
_krasn9 *= _00nx1g;
if (isEyeInWater == 1) _krasn9 = 0.0;
bool _glhblz = _yjolhc && !_yfr6tv(_ips7jr);
if (!_glhblz) _krasn9 = 0.0;

_yssmf1 += vec3(0.7, 0.8, 1.0) * _krasn9;
}
}
}
#endif

#if !defined(NETHER_SHADER) && !defined(END_SHADER)
{
if (!_0rit85()) {
ivec2 _ljtiq9 = ivec2(gl_FragCoord.xy);
float _bm3u0z = texelFetch(depthtex0, _ljtiq9, 0).x;
float _dde2th = texelFetch(dhDepthTex, _ljtiq9, 0).x;
bool _qenku9 = (!_7bqo1l(_bm3u0z) && !_yfr6tv(_dde2th));
if (_qenku9 && _o7giip > 0.05) {
float _tw06t7 = fract(sunAngle);
float _w6m21r = smoothstep(0.0, 0.04, _tw06t7) * (1.0 - smoothstep(0.50, 0.54, _tw06t7));
float _8z4u6y = dot(_pb67e8, vec3(0.299, 0.587, 0.114));
float _6awrwq = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
float _64hnxi = smoothstep(0.15, 0.4, _8z4u6y - _6awrwq);
_64hnxi *= 1.0 - smoothstep(0.3, 0.8, _o7giip);
_64hnxi *= _w6m21r;
_yssmf1 = mix(_yssmf1, _pb67e8, _64hnxi);
}
}
}
#endif

if (isEyeInWater == 1) {
float _yftq4o = texture(colortex1, texcoord).g;
float _j4jevi = (_yftq4o > 0.5) ? 0.05 : 1.0;
vec3 _vl2z5n = vec3(UNDERWATER_FOG_R, UNDERWATER_FOG_G, UNDERWATER_FOG_B);
vec3 _z5aupq = _yssmf1;

_yssmf1.r *= mix(0.55, 0.75, _vl2z5n.r);
_yssmf1.g *= mix(0.75, 0.95, _vl2z5n.g);

float _scsgwb = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1.b = mix(_yssmf1.b, max(_yssmf1.b, _scsgwb * 0.6), 0.3);

_yssmf1 = mix(vec3(_scsgwb), _yssmf1, 0.85);

_yssmf1 = mix(_z5aupq, _yssmf1, _j4jevi);
}

if (darknessFactor > 0.01) {
float _bigj3g = darknessLightFactor;

float _zvq4jp = texture(colortex1, texcoord).g;
float _42r8kn = (_zvq4jp > 0.5) ? 0.4 : 0.0;
float _z43s1z = _bigj3g * (1.0 - _42r8kn);
_yssmf1 *= 1.0 - _z43s1z * 0.85;

vec2 _2yy8xt = texcoord * 2.0 - 1.0;
float _r4dpq4 = dot(_2yy8xt, _2yy8xt);
_yssmf1 *= 1.0 - _r4dpq4 * _bigj3g * 0.5;
}

if (blindness > 0.01) {
float _21rzsc = texture(depthtex0, texcoord).r;
if (_7bqo1l(_21rzsc)) {
vec4 _3qs86v = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _21rzsc * 2.0 - 1.0, 1.0);
float _9ln4an = length(_3qs86v.xyz / _3qs86v.w);
float _oqh4ey = smoothstep(3.0, 6.0, _9ln4an) * blindness;
_yssmf1 = mix(_yssmf1, vec3(0.0), _oqh4ey);
} else {

_yssmf1 = mix(_yssmf1, vec3(0.0), blindness);
}
}

if (nightVision > 0.01) {
float _xohyxz = dot(_yssmf1, vec3(0.299, 0.587, 0.114));

float _6l6fxi = (1.0 - smoothstep(0.0, 0.5, _xohyxz)) * 0.6;
_yssmf1 *= 1.0 + _6l6fxi * nightVision;

_yssmf1.g *= 1.0 + 0.05 * nightVision;
}

if (smoothSwamp > 0.01 && isEyeInWater != 1 && _7bqo1l(_2zs1mf) && (isWater || _etzcl6)) {

float _zv1ic2;
bool _yh67zw = _7bqo1l(_b8i8m4);
if (_yh67zw) {
vec4 _zspc7t = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _b8i8m4 * 2.0 - 1.0, 1.0);
vec3 _8a1rr3 = _zspc7t.xyz / _zspc7t.w;
_zv1ic2 = ((gbufferModelViewInverse * vec4(_8a1rr3, 1.0)).xyz + cameraPosition).y;
} else {

_zv1ic2 = float(SEA_LEVEL_OFFSET) - 10.0;
}
float _7rsuv9 = float(SEA_LEVEL_OFFSET) - _zv1ic2;
if (_7rsuv9 > 0.0) {

float _5jrfy0 = smoothstep(0.0, 4.0, _7rsuv9);

float _qb8870 = smoothstep(0.5, 0.8, _p94ooe);
_5jrfy0 *= (1.0 - _qb8870);
vec3 _1pbyxg = vec3(0.06, 0.12, 0.05);
_yssmf1 = mix(_yssmf1, _1pbyxg, _5jrfy0 * smoothSwamp);
}
}

if (smoothSwamp > 0.01 && isEyeInWater != 1 && _7bqo1l(_2zs1mf) && (isWater || _etzcl6)) {
float _20axr5 = _ehp903.r;
float _gai5ta = smoothstep(0.1, 0.5, _20axr5);
if (_gai5ta > 0.001) {

vec4 _kotkys = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _2zs1mf * 2.0 - 1.0, 1.0);
vec3 _7l8gvx = _kotkys.xyz / _kotkys.w;
vec3 _rbsax2 = (gbufferModelViewInverse * vec4(_7l8gvx, 1.0)).xyz + cameraPosition;
float _rpuf96 = frameTimeCounter;

float _1g798q = 16.0;
float _q4dhxn = 0.05;
vec2 _vx5pvj = _rbsax2.xz * _q4dhxn;
vec2 _opr0bq = floor(_vx5pvj);
float _9gk2ex = 0.0;
for (int gx = -1; gx <= 1; gx++) {
for (int gy = -1; gy <= 1; gy++) {
vec2 _h908e6 = _opr0bq + vec2(float(gx), float(gy));

float h1 = fract(sin(dot(_h908e6, vec2(213.7, 479.1))) * 28571.3);
float h2 = fract(sin(dot(_h908e6, vec2(367.3, 151.9))) * 63841.7);
float h3 = fract(sin(dot(_h908e6, vec2(523.1, 289.5))) * 91547.1);
float _31394t = floor((_rpuf96 + h1 * _1g798q) / _1g798q);
float h4 = fract(sin(dot(vec2(_31394t, h1 * 100.0), vec2(213.7, 479.1))) * 28571.3);
float h5 = fract(sin(dot(vec2(_31394t, h2 * 100.0), vec2(367.3, 151.9))) * 63841.7);
float _c4eczi = mod(_rpuf96 + h1 * _1g798q, _1g798q) / _1g798q;
vec2 _pnr1f3 = vec2(h3 - 0.5, h1 - 0.5) * _c4eczi * 0.4;
vec2 _o8zme9 = _h908e6 + vec2(0.2 + h4 * 0.6, 0.2 + h5 * 0.6) + _pnr1f3;
vec2 _ic9jj6 = _vx5pvj - _o8zme9;
float _huatah = atan(_ic9jj6.y, _ic9jj6.x);
float _31trnd = 1.0 + 0.2 * sin(_huatah * 3.0 + h3 * 6.28) + 0.1 * sin(_huatah * 5.0 + h1 * 6.28);
float _t25r5m = length(_ic9jj6) * _31trnd;
float _td7lfx = 0.5;
float _9zitwm = smoothstep(0.0, 0.35, _c4eczi) * _td7lfx;
float _wn2hnz = smoothstep(0.25, 0.90, _c4eczi) * _td7lfx * 1.3;
float _8ahrec = _9zitwm > 0.0001
? 1.0 - smoothstep(_9zitwm * 0.4, _9zitwm, _t25r5m)
: 0.0;
float _18rqbh = _wn2hnz > 0.0001
? smoothstep(_wn2hnz * 0.3, _wn2hnz, _t25r5m)
: 1.0;
float _md07hl = _8ahrec * _18rqbh;
float _795b2k = step(0.35, h2);
_9gk2ex = max(_9gk2ex, _md07hl * _795b2k);
}
}

_gai5ta *= _9gk2ex;

vec3 _awdave = normalize((gbufferModelViewInverse * vec4(_7l8gvx, 1.0)).xyz);
vec3 _lnv1lo = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _09sqds = max(dot(_awdave, _lnv1lo), 0.0);
TimeWeightsSimple stTS = getTimeWeightsSimple(sunAngle);
float _cqnajs = stTS.day + stTS.twilight * 0.7;
float _8wfipp = pow(_09sqds, 4.0) * _cqnajs * 2.0;
vec3 _ane8fg = vec3(0.18, 0.25, 0.12) + vec3(0.15, 0.12, 0.05) * _8wfipp;
_yssmf1 = mix(_yssmf1, _ane8fg, _gai5ta * smoothSwamp);
}
}

if (smoothSwamp > 0.01 && isEyeInWater != 1 && _7bqo1l(_2zs1mf) && (isWater || _etzcl6)) {
float rx = _a2jf3a.x;
float _i1y7t7 = smoothstep(0.5, 1.0, rx);
if (_i1y7t7 > 0.001) {
_yssmf1 = mix(_yssmf1, _yssmf1 * vec3(0.55, 0.35, 0.15), _i1y7t7 * smoothSwamp);
}
}

vec4 _pshn7o = texelFetch(colortex13, _2l09tc, 0);
float _pnsvt6 = _9cwhip(biome) ? 0.0 : ((_pshn7o.a > 1.0) ? (_pshn7o.a - 1.0) : 0.0);
if (DEBUG_CAVE_FOG_DISTANCE_VIEW && _pnsvt6 > 0.001) {
float _c1ycuf = texture(depthtex0, texcoord).r;
float _2dczlz = texture(depthtex1, texcoord).r;
float _mjgamg  = max(_c1ycuf, _2dczlz);
float _x25k3u = 0.0;
if (_7bqo1l(_mjgamg)) {
vec4 _8xomwy = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, _mjgamg * 2.0 - 1.0, 1.0);
vec3 _3y2bdj = _8xomwy.xyz / _8xomwy.w;
_x25k3u = clamp(length(_3y2bdj) / CAVE_FOG_MAX_DIST, 0.0, 1.0);
}
gl_FragData[0] = vec4(vec3(_x25k3u), 1.0);
} else if (DEBUG_CAVE_FOG_ALPHA_VIEW && _pnsvt6 > 0.001) {
gl_FragData[0] = vec4(vec3(_pnsvt6), 1.0);
} else {
gl_FragData[0] = vec4(_yssmf1, _xszwck);
}

if (_622i54.a < 0.5) {
_622i54 = (_pnsvt6 > 0.001) ? vec4(0.0) : vec4(_o7giip, 0.0, 0.0, 0.0);
}
gl_FragData[1] = _622i54;
}
