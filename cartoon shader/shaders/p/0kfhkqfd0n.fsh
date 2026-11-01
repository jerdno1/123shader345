#include "/settings.glsl"

#if TERRAIN_PROFILE_MODE == 1
#undef SHADOWS_ENABLED
#undef CLOUD_SHADOWS_ENABLED
#elif TERRAIN_PROFILE_MODE == 2
#undef LPV_ENABLED
#elif TERRAIN_PROFILE_MODE == 3
#undef BLOOM_ENABLED
#elif TERRAIN_PROFILE_MODE == 4
#undef MATERIAL_REFLECTIONS_ENABLED
#elif TERRAIN_PROFILE_MODE == 5
#undef PBR_ENABLED
#elif TERRAIN_PROFILE_MODE == 6
#undef METALNESS_ENABLED
#elif TERRAIN_PROFILE_MODE == 7
#undef EMISSIVE_MASKING
#undef HANDHELD_LIGHT_ENABLED
#elif TERRAIN_PROFILE_MODE == 8
#undef LEAF_SHEEN_ENABLED
#elif TERRAIN_PROFILE_MODE == 9
#undef CHUNK_FADE_OUT_ENABLED
#elif TERRAIN_PROFILE_MODE == 10
#undef WATER_WAVES_ENABLED
#elif TERRAIN_PROFILE_MODE == 11
#define TERRAIN_PROFILE_SKIP_PURE_TEX_FETCH
#elif TERRAIN_PROFILE_MODE == 12
#define TERRAIN_PROFILE_SKIP_FOLIAGE_LIGHT_GRADIENT
#elif TERRAIN_PROFILE_MODE == 13
#define TERRAIN_PROFILE_SKIP_FACE_SHADING
#elif TERRAIN_PROFILE_MODE == 14
#define TERRAIN_PROFILE_SKIP_GRASS_PATCH_NOISE
#elif TERRAIN_PROFILE_MODE == 15
#define TERRAIN_PROFILE_BASE_TEXTURE_ONLY
#elif TERRAIN_PROFILE_MODE == 16
#define TERRAIN_PROFILE_SKIP_MAIN_LIGHTING
#elif TERRAIN_PROFILE_MODE == 21
#undef BLOOM_ENABLED
#undef MATERIAL_REFLECTIONS_ENABLED
#define TERRAIN_PROFILE_BASE_TEXTURE_ONLY
#endif

#if defined(BLOOM_ENABLED) && (defined(MATERIAL_REFLECTIONS_ENABLED) || defined(LEAF_AA_ENABLED))
/* RENDERTARGETS: 0,1,2,3,5 */
#elif defined(BLOOM_ENABLED)
/* RENDERTARGETS: 0,1,2,3 */
#elif defined(MATERIAL_REFLECTIONS_ENABLED) || defined(LEAF_AA_ENABLED)
/* RENDERTARGETS: 0,1,5 */
#else
/* RENDERTARGETS: 0,1 */
#endif

#if defined(MATERIAL_REFLECTIONS_ENABLED) || defined(LEAF_AA_ENABLED)
void _d5fiqv(vec4 _ino0s9) {
#ifdef BLOOM_ENABLED
gl_FragData[4] = _ino0s9;
#else
gl_FragData[2] = _ino0s9;
#endif
}
#endif

#include "/include/biome_overrides.glsl"
#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
#include "/include/hovering.glsl"
#include "/include/ocean_waves.glsl"

uniform sampler2D gtexture;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
#ifdef PBR_ENABLED
uniform sampler2D normals;
uniform sampler2D specular;
#endif
uniform float alphaTestRef;
uniform vec3 fogColor;
uniform int biome_category;
uniform float fogStart;
uniform float fogEnd;
uniform float far;
uniform float sunAngle;
uniform vec3 shadowLightPosition;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform int currentRenderedItemId;
uniform float biome_swamp;
uniform int isEyeInWater;
uniform int frameCounter;

uniform ivec2 eyeBrightness;
uniform ivec2 eyeBrightnessSmooth;

#include "/include/lighting.glsl"
#ifdef EMISSIVE_MASKING
#include "/include/emissive_mask.glsl"
#endif
uniform float frameTimeCounter;
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
#include "/include/end_event.glsl"
#endif
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_arid;
uniform float biome_savanna;

in vec2 texcoord;
in vec2 midTexCoord;
in vec4 glcolor;
in float viewDistance;
in float outlineMask;
in float skylight;
in float blocklight;
flat in float emissive;
flat in float emissiveType;
in vec3 worldPos;
flat in vec3 blockCenterWorld;
in vec4 shadowPos;
flat in float isGrassGeometry;
flat in float isHeatSource;
flat in float isHologram;
flat in float metalness;
flat in float reflective;
in vec3 normal;
flat in vec3 geoNormal;
flat in float blockId;
in float leafAO;
#ifdef PBR_ENABLED
in vec3 tangentVec;
in vec3 binormalVec;
#endif

#include "/include/fog_color.glsl"

#if defined(CLOUDS_2D_ENABLED) && defined(CLOUD_SHADOWS_ENABLED)
#include "/include/cloud_shadow.glsl"
#endif

float _w5dqoo(float x) {
return fract(sin(x * 12.9898) * 43758.5453);
}

#include "/include/noise.glsl"
#include "/include/caztoon_grass_patches.glsl"
#include "/include/caztoon_leaf1_pixel_toon.glsl"
#include "/include/lava_crust.glsl"

#ifdef LEAF_AA_ENABLED
const float LEAF_AA_MATERIAL_TAG = 0.25;

bool _clyfkl(float id) {
int _hcr7dx = int(id + 0.5);
return _hcr7dx == 10005 || _hcr7dx == 10082 || _hcr7dx == 10201;
}
#endif

#include "/include/metalness.glsl"
#ifdef PBR_ENABLED
#include "/include/pbr.glsl"
#endif

#if defined(PIXELATED_SHADOWS) && defined(SHADOWS_ENABLED)
vec3 _jvjur6(vec3 _uyjapd, vec3 _grfjdi) {
vec3 _q9rkda = _uyjapd - cameraPosition;
vec3 _id3sae = (shadowProjection * shadowModelView * vec4(_q9rkda, 1.0)).xyz;
float _ug3i3h = _ckk90a(_id3sae);
vec3 _1z1cu1 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _nkw71t = dot(normalize(_grfjdi), _1z1cu1);
_ug3i3h *= mix(0.12, 1.0, smoothstep(0.08, 0.45, _nkw71t));
vec3 _4bqgs3 = _2y5umb(_id3sae) * 0.5 + 0.5;
vec4 _mnvvf9 = shadowProjection * vec4(mat3(shadowModelView) * _grfjdi, 1.0);
_4bqgs3.xyz += _mnvvf9.xyz / _mnvvf9.w * _ug3i3h;
return _4bqgs3;
}

float _irhugw(vec3 _tkgg08) {
vec3 _1z1cu1 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _bp3bkg = clamp(dot(normalize(_tkgg08), _1z1cu1), 0.0, 1.0);
return mix(0.10, 0.45, smoothstep(0.08, 0.45, _bp3bkg)) / float(_qezbw4);
}

float _34qihk(sampler2D shadowtex, vec3 _wnd49b, vec3 _tkgg08, vec2 _xsqf5j) {
vec3 _56owf7 = _wnd49b + _fknrwx(_tkgg08, _xsqf5j);
return _4m3l6t(shadowtex, _jvjur6(_56owf7, _tkgg08), _irhugw(_tkgg08));
}

float _dxmo4t(sampler2D shadowtex, vec3 _dougct, vec3 _wnd49b, vec3 _tkgg08) {
float shadow = _4m3l6t(shadowtex, _dougct, _irhugw(_tkgg08));
float _d8tv7f = 1.0;
float _6noprb = max(PIXELATED_SHADOW_BLUR, 0.0) * clamp(PIXELATED_SHADOW_STRENGTH, 0.0, 1.0);
if (_6noprb <= 0.0) return shadow;

float _70a66z = clamp(_6noprb, 0.0, 1.0);
float _fivls5 = clamp(_6noprb - 1.0, 0.0, 1.0);
float _ylxwyp = clamp(_6noprb - 2.0, 0.0, 1.0);
float _91omva = clamp(_6noprb - 3.0, 0.0, 1.0);

shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 1.0,  0.0)) * _70a66z;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2(-1.0,  0.0)) * _70a66z;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 0.0,  1.0)) * _70a66z;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 0.0, -1.0)) * _70a66z;
_d8tv7f += 4.0 * _70a66z;

shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 1.0,  1.0)) * _fivls5;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2(-1.0,  1.0)) * _fivls5;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 1.0, -1.0)) * _fivls5;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2(-1.0, -1.0)) * _fivls5;
_d8tv7f += 4.0 * _fivls5;

shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 2.0,  0.0)) * _ylxwyp;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2(-2.0,  0.0)) * _ylxwyp;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 0.0,  2.0)) * _ylxwyp;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 0.0, -2.0)) * _ylxwyp;
_d8tv7f += 4.0 * _ylxwyp;

shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 2.0,  2.0)) * _91omva;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2(-2.0,  2.0)) * _91omva;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2( 2.0, -2.0)) * _91omva;
shadow += _34qihk(shadowtex, _wnd49b, _tkgg08, vec2(-2.0, -2.0)) * _91omva;
_d8tv7f += 4.0 * _91omva;

return shadow / _d8tv7f;
}
#endif

float _5j1313(vec3 _56owf7) {
#ifdef SHADOWS_ENABLED
vec3 _mr97ic = _56owf7 - cameraPosition;
vec3 _kffjyx = (shadowProjection * shadowModelView * vec4(_mr97ic, 1.0)).xyz;
vec3 _i1hwjb = _2y5umb(_kffjyx) * 0.5 + 0.5;

float _c4cke4 = _ckk90a(_kffjyx) + max(0.18 / float(_qezbw4), 0.00004);
float _qs6otz = _4m3l6t(shadowtex1, _i1hwjb, _c4cke4);
float _ebb45a = _s4lpf1(_i1hwjb) * (1.0 - _xr26fh(_i1hwjb, viewDistance));
return mix(1.0, _qs6otz, _ebb45a);
#else
return 1.0;
#endif
}

float _y4hv3b(vec3 _ktvks8) {
#ifdef SHADOWS_ENABLED
vec3 _xyc8gw = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 _2pqlxa = (abs(_xyc8gw.y) > 0.92) ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 1.0, 0.0);
vec3 _seahhw = normalize(cross(_2pqlxa, _xyc8gw));
vec3 _48txvo = normalize(cross(_xyc8gw, _seahhw));

vec3 _ocvwnd = _ktvks8 + _xyc8gw * 0.62;
float _cx42xx = 0.34;

float _qs6otz = 0.0;
_qs6otz += _5j1313(_ocvwnd) * 2.0;
_qs6otz += _5j1313(_ocvwnd + _seahhw * _cx42xx);
_qs6otz += _5j1313(_ocvwnd - _seahhw * _cx42xx);
_qs6otz += _5j1313(_ocvwnd + _48txvo * _cx42xx);
_qs6otz += _5j1313(_ocvwnd - _48txvo * _cx42xx);
_qs6otz += _5j1313(_ocvwnd + (_seahhw + _48txvo) * (_cx42xx * 0.70));
_qs6otz += _5j1313(_ocvwnd - (_seahhw + _48txvo) * (_cx42xx * 0.70));
_qs6otz /= 8.0;

return clamp(_qs6otz, 0.0, 1.0);
#else
return 1.0;
#endif
}

void main() {
vec2 _aycn9b = texcoord;

vec4 _yssmf1 = texture(gtexture, _aycn9b) * glcolor;

if (_yssmf1.a < alphaTestRef) {
discard;
}

int _tql6uh = int(blockId + 0.5);
if (_e4o816(_tql6uh)) {
if (_yssmf1.a < 0.5) {
discard;
}
_yssmf1.a = 1.0;
}
vec3 _ixfcdc = normalize(mat3(gbufferModelViewInverse) * geoNormal);
_yssmf1.rgb = _5w9i4q(_yssmf1.rgb, worldPos, _ixfcdc, _tql6uh, frameTimeCounter, glcolor.rgb);

if (!_9cwhip(biome) && !_z0kr59(biome) && isEyeInWater != 1) {
#ifdef CHUNK_FADE_OUT_ENABLED
#ifndef DISTANT_HORIZONS

float _o5g13l = length(worldPos.xz - cameraPosition.xz);
float _tt79nt = smoothstep(CHUNK_FADE_OUT_RADIUS, CHUNK_FADE_OUT_RADIUS + 24.0, _o5g13l);
if (_tt79nt > 0.001) {
float _025mu8 = 1.0 - _tt79nt;
float _zekzgg = SEA_LEVEL_OFFSET - 96.0;
float _q73t75 = SEA_LEVEL_OFFSET + 320.0;

float _q4j75g = _cks7vw(worldPos.xz * 0.12);
float _j5jye0 = (_q4j75g - 0.5) * 10.0;
float _go7jgh = mix(_zekzgg, _q73t75, _025mu8) + _j5jye0;
float _fxiwh2 = 1.0 - smoothstep(_go7jgh - 8.0, _go7jgh + 8.0, worldPos.y);
_yssmf1.rgb *= mix(0.60, 1.0, _fxiwh2);
if (_fxiwh2 < 0.02) {
discard;
}
}
#endif
#endif
}

#if defined(TERRAIN_PROFILE_SKIP_PURE_TEX_FETCH)
vec3 _vefeh2 = _yssmf1.rgb;
#elif defined(EMISSIVE_MASKING) || defined(LPV_ENABLED)
vec3 _vefeh2 = texture(gtexture, _aycn9b).rgb;
#else
vec3 _vefeh2 = _yssmf1.rgb;
#endif

vec3 _dwo81a = _yssmf1.rgb;

float _5jvqov = blocklight;
float _pl1tew = skylight;
float _led594 = emissive;

#ifdef TERRAIN_PROFILE_BASE_TEXTURE_ONLY
gl_FragData[0] = vec4(_dwo81a, _yssmf1.a);
gl_FragData[1] = vec4(outlineMask, _led594, _pl1tew, isHeatSource);
#ifdef BLOOM_ENABLED
gl_FragData[2] = vec4(0.0);
gl_FragData[3] = vec4(0.0);
#endif
#if defined(MATERIAL_REFLECTIONS_ENABLED) || defined(LEAF_AA_ENABLED)
#ifdef LEAF_AA_ENABLED
_d5fiqv(_clyfkl(blockId)
? vec4(0.0, LEAF_AA_MATERIAL_TAG, 0.0, 0.0)
: vec4(0.0));
#else
_d5fiqv(vec4(0.0));
#endif
#endif
return;
#endif

#ifdef EMISSIVE_MASKING
float _0eryme = 0.0;
if (emissive > 0.5) {
_0eryme = _xojoff(int(floor(emissiveType + 0.5)), _vefeh2);

int _xnk1dn = int(floor(emissiveType + 0.5));
if (_xnk1dn == 39 || _xnk1dn == 40 || _xnk1dn == 41) {
vec3 _eew2z8 = fract(worldPos);
vec3 _oh6aye = abs(normalize(mat3(gbufferModelViewInverse) * normal));
vec2 _n46wpv;
if (_oh6aye.y > _oh6aye.x && _oh6aye.y > _oh6aye.z) _n46wpv = _eew2z8.xz;
else if (_oh6aye.x > _oh6aye.z) _n46wpv = _eew2z8.yz;
else _n46wpv = _eew2z8.xy;
const int cbMask[16] = int[](
0, 0, 1632, 1632, 1632, 15996, 15996, 0,
0, 15996, 15996, 1632, 1632, 1632, 0, 0
);
ivec2 _xibcy1 = clamp(ivec2(floor(_n46wpv * 16.0)), ivec2(0), ivec2(15));
bool _aqgfno = (cbMask[_xibcy1.y] & (1 << _xibcy1.x)) != 0;
_0eryme *= _aqgfno ? 1.0 : 0.0;
}

if (_0eryme < 0.05) {
_led594 = 0.0;
}

int _sm7pv3 = int(floor(emissiveType + 0.5));
if (_sm7pv3 == 44) {
_led594 = 0.0;
}
}
#endif

bool _pnov9n = (currentRenderedItemId == 10020 || currentRenderedItemId == 10021);

int _1rtzjb = int(blockId + 0.5);
bool _s4z93e = _e4o816(_1rtzjb);
bool _t5b5pz = (_1rtzjb == 10005 || _1rtzjb == 10082);
bool _ifylrp = (_1rtzjb == 10015);
#ifndef TERRAIN_PROFILE_SKIP_FOLIAGE_LIGHT_GRADIENT
if (isGrassGeometry > 0.5 && _ifylrp) {
float _oyhb7s = dFdx(blocklight);
float _0mxa0f = dFdy(blocklight);
vec2 _r5y5h0 = fract(worldPos.xz);
float _sm9mfv = (_r5y5h0.x - 0.5) * _oyhb7s * 8.0 + (_r5y5h0.y - 0.5) * _0mxa0f * 8.0;
_5jvqov = clamp(blocklight + _sm9mfv, 0.0, 1.0);
}
#endif

vec3 shadow = vec3(1.0);
float _621xrq = 0.0;
vec3 _74ncvf = vec3(0.0);
float _pqzh8s = 0.0;
vec3 _zjldd7 = vec3(0.0);
#ifdef SHADOWS_ENABLED
if (_led594 < 0.5 && !_9cwhip(biome)) {

vec3 _p43sug = shadowPos.xyz;
#ifdef PIXELATED_SHADOWS
vec3 _2zjeh0 = normalize(mat3(gbufferModelViewInverse) * geoNormal);
vec3 _lm95q2 = _5kwiu1(worldPos, _2zjeh0);
_p43sug = _jvjur6(_lm95q2, _2zjeh0);
#endif

int _v7tcei = int(blockId + 0.5);
bool _rtus79 = _t5b5pz;
float _5jah4i = 1.0;

float _izh8vx = _h1jpqh(gl_FragCoord.xy, frameCounter);
_izh8vx = _e4hc8m(_izh8vx, _p43sug);
float r = _55535n(_p43sug.xy * 2.0 - 1.0);
float _w02w60 = r + SHADOW_DISTORTION;

if (_s4z93e) {
shadow = vec3(_elt4kp(shadowtex0, _p43sug, _w02w60, viewDistance, _izh8vx));
} else {

#if defined(PIXELATED_SHADOWS) || defined(SHARP_SHADOWS) || defined(MAGICAL_TOUCH)
#ifdef PIXELATED_SHADOWS
float _91kmlh = _dxmo4t(shadowtex0, _p43sug, _lm95q2, _2zjeh0);
float _w4igdb = _dxmo4t(shadowtex1, _p43sug, _lm95q2, _2zjeh0);
#else
float _91kmlh = _q06ww9(shadowtex0, _p43sug, 0.0);
float _w4igdb = _q06ww9(shadowtex1, _p43sug, 0.0);
#endif
float _u2akbz = 1.0 - _91kmlh;
float _oghvu1 = 1.0 - _w4igdb;

float _mxc934 = _u2akbz * (1.0 - _oghvu1);
float _mifr90 = _oghvu1;

vec4 _2ojubc = texture(shadowcolor0, _p43sug.xy);

vec3 _z6rtf0 = _2ojubc.rgb;
float _onbgtf = max(max(_z6rtf0.r, _z6rtf0.g), _z6rtf0.b);
if (_onbgtf > 0.001) _z6rtf0 /= _onbgtf;

vec3 _wwfca0 = mix(vec3(1.0), _z6rtf0, 0.7) * 2.10;
_pqzh8s = max(_pqzh8s, _mxc934 * _5jah4i);
_zjldd7 = max(_zjldd7, _wwfca0 * _pqzh8s);

shadow = vec3(1.0);
shadow = mix(shadow, vec3(0.0), _mifr90);
shadow = mix(shadow, min(_wwfca0, vec3(1.6)), _mxc934);
float _rjtkh7 = 1.0 - _xr26fh(_p43sug, viewDistance);
shadow = mix(vec3(1.0), shadow, _s4lpf1(_p43sug) * _rjtkh7);
#else
shadow = _5nbkwe(shadowtex0, shadowcolor0, _p43sug, _w02w60, viewDistance, _izh8vx);
#endif

#if defined(LEAF_SHEEN_ENABLED) && defined(MAGICAL_TOUCH) && !defined(PIXELATED_SHADOWS)
if (_rtus79 && LEAF_SHADOW_SOFTNESS > 0.0) {
float _la51bv = dot(shadow, vec3(0.299, 0.587, 0.114));
float _5hcbbb = _7t996k(
shadowtex0, _p43sug, _w02w60, viewDistance, _izh8vx
);
shadow = _la51bv > 0.001
? shadow * (_5hcbbb / _la51bv)
: vec3(_5hcbbb);
}
#endif
}

bool _zmq552 = _cnabfq(_v7tcei) || _s4z93e || _rtus79;
#ifdef MAGICAL_TOUCH
_zmq552 = _zmq552 || (_v7tcei == 10002 || _v7tcei == 10003 || _v7tcei == 10004 || _v7tcei == 10019 || _v7tcei == 10060 || _v7tcei == 10061 || _v7tcei == 10062);
#endif
if (isGrassGeometry < 0.5 && !_zmq552) {
float _6obksq = (1.0 - smoothstep(0.02, 0.30, shadowPos.w)) * _5jah4i;
shadow = mix(shadow, vec3(0.0), _6obksq);
}

if (_v7tcei == 10018) {
shadow = mix(shadow, vec3(1.0), 0.5);
}

_621xrq = dot(shadow, vec3(0.333)) * _5jah4i;
_74ncvf = shadow * _5jah4i;

shadow = mix(vec3(1.0), shadow, _pl1tew);

float _poar2o = dot(shadow, vec3(0.299, 0.587, 0.114));

float _683i79 = mix(1.0, _poar2o, SHADOW_OPACITY);

shadow = (_poar2o > 0.001) ? shadow * (_683i79 / _poar2o) : vec3(_683i79);

}
#endif

float _poar2o = 1.0;
#ifdef SHADOWS_ENABLED
_poar2o = dot(shadow, vec3(0.299, 0.587, 0.114));
#endif

#if defined(CLOUDS_2D_ENABLED) && defined(CLOUD_SHADOWS_ENABLED)
if (_pl1tew > 0.1) {
float _80do1j = _ddtj35(worldPos, frameTimeCounter);
shadow *= _80do1j;
}
#endif

#ifndef TERRAIN_PROFILE_SKIP_FACE_SHADING
{
#ifdef MAGICAL_TOUCH
float _110wa2 = 1.0 - smoothstep(0.0, 2.0 / 15.0, _pl1tew);
#else
float _110wa2 = 1.0;
#endif
bool _tzsluk = _cnabfq(_1rtzjb) || _s4z93e || _t5b5pz;
if (_110wa2 > 0.01 && !_tzsluk) {
vec3 _3v9zqi = normalize(mat3(gbufferModelViewInverse) * geoNormal);
float _433mrg = _7q50sc(_3v9zqi);
_yssmf1.rgb *= mix(1.0, _433mrg, _110wa2);
}
}
#endif

#ifdef LPV_ENABLED

_osnipo = _s4z93e ? blockCenterWorld : worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
if (isGrassGeometry > 0.5 || _s4z93e) {

_5pkrr5 = vec3(0.0, 1.0, 0.0);
}

bool _ys5mfy =
isGrassGeometry > 0.5 ||
_1rtzjb == 10005 || _1rtzjb == 10015 || _1rtzjb == 10018 ||
_1rtzjb == 10060 || _1rtzjb == 10061 || _1rtzjb == 10062 ||
_1rtzjb == 10082 || _s4z93e || _cnabfq(_1rtzjb);
_x3j9yv = 1.0;
vec3 _egm65t = _ys5mfy ? _dwo81a : _vefeh2;
if (_s4z93e) {

_egm65t = vec3(0.52);
}
_pis44d = _egm65t;

_06143i = _s4z93e ? 0.52 : dot(_egm65t, vec3(0.299, 0.587, 0.114));
#endif

vec3 _evko43 = _yssmf1.rgb;
float _u7z3ex = smoothstep(0.5 / 15.0, 2.0 / 15.0, _pl1tew);
float _t06kzd = smoothstep(float(SEA_LEVEL_OFFSET) - 4.0, float(SEA_LEVEL_OFFSET) + 2.0, worldPos.y);
float _q85lda = max(_u7z3ex, _t06kzd);
_joda6y = clamp(max(_621xrq, _pqzh8s) * _hrakns(sunAngle) * _q85lda, 0.0, 1.0);
#ifdef TERRAIN_PROFILE_SKIP_MAIN_LIGHTING
_yssmf1.rgb = _evko43;
#else
_yssmf1.rgb = _iroce3(_evko43, sunAngle, _pl1tew, _5jvqov, _led594, shadow, worldPos.y);
float _nd19sa = _nz5r9d(sunAngle) * _ukv2q2(_pl1tew);
if (_nd19sa > 0.001) {
vec3 _x0uomv = _iroce3(_evko43, sunAngle, _pl1tew, _5jvqov, _led594, vec3(1.0), worldPos.y);
_yssmf1.rgb = mix(_yssmf1.rgb, _x0uomv, _nd19sa);
}
_yssmf1.rgb *= _bbncmg(_nd19sa, _utlnv9(sunAngle).x, _pl1tew);
#endif

#ifdef WATER_WAVES_ENABLED
if (isEyeInWater == 1 && worldPos.y < float(SEA_LEVEL_OFFSET) && _pl1tew > 0.1) {
float _54y6l2 = float(SEA_LEVEL_OFFSET);
float _kgch6q = _54y6l2 - worldPos.y;

float ct = frameTimeCounter * WATER_WAVE_SPEED * 0.4;
vec3 _0rl3ii = worldPos * 0.75;

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

float _34lotr = exp(-_kgch6q * 0.03);

float _5jq5y1 = clamp(shadowPos.w, 0.0, 1.0);

float _up3jv8 = 1.0;
#ifdef UNDERWATER_FOG_ENABLED
{
float _t1gdbd = length(worldPos - cameraPosition);
float _18f1mu = UNDERWATER_FOG_DENSITY * 0.008;
_up3jv8 = exp(-_t1gdbd * _18f1mu);
}
#endif

float _cavu1d = _rbvgpe * _34lotr * _up3jv8 * _5jq5y1 * _pl1tew * 0.45;

_yssmf1.rgb *= 1.0 + _cavu1d;
}
#endif

#ifdef EMISSIVE_MASKING
if (emissive > 0.5 && _0eryme >= 0.05) {
int _1hfx9l = int(floor(emissiveType + 0.5));
if (_1hfx9l == 44) {

float _x2nvme = smoothstep(0.7, 0.95, dot(_dwo81a, vec3(0.333)));
_yssmf1.rgb = mix(_yssmf1.rgb, _dwo81a * (1.0 + _x2nvme * 0.1), 0.75);
} else {
vec3 _b966pi = (_1hfx9l == 19) ? _vefeh2 : _dwo81a;
vec3 _6xt8s6 = _b966pi * EMISSIVE_BRIGHTNESS;
#ifdef END_SHADER
_6xt8s6 *= END_EMISSIVE_BOOST;
#endif
_yssmf1.rgb = mix(_yssmf1.rgb, _6xt8s6, clamp(_0eryme, 0.0, 1.0));
}
}
#endif

bool _anrfx5 = false;
vec3 _0mfaw3 = vec3(0.0);
#ifdef HANDHELD_LIGHT_ENABLED
float _wm3kzh = length(worldPos - eyePosition);

bool _pqfdkn = (heldItemId >= 10020 && heldItemId <= 10059) || heldItemId == 10087 || heldItemId == 10089 ||
(heldItemId2 >= 10020 && heldItemId2 <= 10059) || heldItemId2 == 10087 || heldItemId2 == 10089;

if (_wm3kzh < 2.0 && _pqfdkn && blockId < 1.0) {
#ifdef EMISSIVE_MASKING
int _k2ocbm = 0;
if (heldItemId == 10087) _k2ocbm = 46;
else if (heldItemId == 10089) _k2ocbm = 47;
else if (heldItemId >= 10020 && heldItemId <= 10059) _k2ocbm = heldItemId - 10020;
else if (heldItemId2 == 10087) _k2ocbm = 46;
else if (heldItemId2 == 10089) _k2ocbm = 47;
else if (heldItemId2 >= 10020 && heldItemId2 <= 10059) _k2ocbm = heldItemId2 - 10020;
float _kbslek = _xojoff(_k2ocbm, _dwo81a);
float hm = clamp(_kbslek, 0.0, 1.0);

vec3 _hj0fjq = _6xm99w(_dwo81a, sunAngle, skylight, blocklight, worldPos.y);
vec3 _dr8rt1 = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_EMISSION;
_yssmf1.rgb = mix(_hj0fjq, _dr8rt1, hm);
_led594 = (hm > 0.05) ? 1.0 : 0.0;
float _99w79e = (_k2ocbm == 46) ? 0.15 : 1.0;
_0mfaw3 = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_STRENGTH * hm * _99w79e;
_anrfx5 = (hm > 0.05);
#else
_yssmf1.rgb = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_EMISSION;
_led594 = 1.0;
_0mfaw3 = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_STRENGTH;
_anrfx5 = true;
#endif
}

if (!_anrfx5) {
bool _mb7dua = (heldBlockLightValue > 7 || heldBlockLightValue2 > 7);
if (_mb7dua && _wm3kzh < HELD_BLOOM_RADIUS && blockId < 1.0) {
float _vmhdrc = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
if (_vmhdrc > HELD_BLOOM_THRESHOLD && blocklight > 0.8) {
#ifdef EMISSIVE_MASKING
int _z7nxc7 = 0;
if (heldItemId == 10087) _z7nxc7 = 46;
else if (heldItemId == 10089) _z7nxc7 = 47;
else if (heldItemId >= 10020 && heldItemId <= 10063) _z7nxc7 = heldItemId - 10020;
else if (heldItemId2 == 10087) _z7nxc7 = 46;
else if (heldItemId2 == 10089) _z7nxc7 = 47;
else if (heldItemId2 >= 10020 && heldItemId2 <= 10063) _z7nxc7 = heldItemId2 - 10020;
float _pdyjq8 = _xojoff(_z7nxc7, _dwo81a);
float fm = clamp(_pdyjq8, 0.0, 1.0);
vec3 _hj0fjq = _6xm99w(_dwo81a, sunAngle, skylight, blocklight, worldPos.y);
vec3 _dr8rt1 = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_EMISSION;
_yssmf1.rgb = mix(_hj0fjq, _dr8rt1, fm);
_led594 = (fm > 0.05) ? 1.0 : 0.0;
_0mfaw3 = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_STRENGTH * fm;
_anrfx5 = (fm > 0.05);
#else
_yssmf1.rgb = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_EMISSION;
_led594 = 1.0;
_0mfaw3 = _dwo81a * EMISSIVE_BRIGHTNESS * HELD_BLOOM_STRENGTH;
_anrfx5 = true;
#endif
}
}
}
#endif
#ifdef HANDHELD_LIGHT_ENABLED
if (_led594 < 0.5) _yssmf1.rgb += _6p2kch(worldPos, _dwo81a, _yssmf1.rgb);
#endif
_yssmf1.rgb *= TERRAIN_BRIGHTNESS;

#ifdef END_SHADER
if (_led594 < 0.5) {

#ifdef END_TERRAIN_PATCHES_ENABLED
{
vec3 _irms09 = worldPos * END_TERRAIN_PATCH_SCALE;
float pn = 0.0;
float _9imorn = 0.6;
for (int _hiq5ip = 0; _hiq5ip < 3; _hiq5ip++) {
vec3 ip = floor(_irms09);
vec3 fp = fract(_irms09);
fp = fp * fp * (3.0 - 2.0 * fp);
float a = fract(sin(dot(ip, vec3(127.1, 311.7, 74.7))) * 43758.5453);
float b = fract(sin(dot(ip + vec3(1,0,0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float c = fract(sin(dot(ip + vec3(0,1,0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float d = fract(sin(dot(ip + vec3(1,1,0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float e = fract(sin(dot(ip + vec3(0,0,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float f = fract(sin(dot(ip + vec3(1,0,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float g = fract(sin(dot(ip + vec3(0,1,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float h = fract(sin(dot(ip + vec3(1,1,1), vec3(127.1, 311.7, 74.7))) * 43758.5453);
float z0 = mix(mix(a, b, fp.x), mix(c, d, fp.x), fp.y);
float z1 = mix(mix(e, f, fp.x), mix(g, h, fp.x), fp.y);
pn += mix(z0, z1, fp.z) * _9imorn;
_irms09 *= 2.3;
_9imorn *= 0.45;
}
float _u52tde = smoothstep(0.25, 0.55, pn);
_u52tde = mix(1.0, 1.0 - END_TERRAIN_PATCH_STRENGTH, 1.0 - _u52tde);
_yssmf1.rgb *= _u52tde;
}
#endif

#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
EndEvent endEvent = getEndEvent(frameTimeCounter);
#endif
#if defined(END_SHADER) && defined(END_EVENT_ENABLED) && defined(END_EVENT_EYE_ENABLED) && defined(END_EVENT_SPOTLIGHT_ENABLED)
if (endEvent.eyeOpen > 0.01) {

vec2 _awklhc = eyePosition.xz;
vec2 _nbbjog = worldPos.xz;
float _0p5r17 = length(_nbbjog - _awklhc);

float _o17vev = END_EVENT_SPOTLIGHT_RADIUS;
float _h961bo = 1.0 - smoothstep(_o17vev * 0.4, _o17vev, _0p5r17);

float _5l5nx9 = max(normal.y, 0.0);
_h961bo *= _5l5nx9;

_h961bo *= endEvent.eyeOpen;

vec3 _xr5c57 = vec3(
END_EVENT_EYE_IRIS_R * 0.5 + 0.5,
END_EVENT_EYE_IRIS_G * 0.3 + 0.4,
END_EVENT_EYE_IRIS_B * 0.4 + 0.6
);
_yssmf1.rgb += _dwo81a * _xr5c57 * _h961bo * END_EVENT_SPOTLIGHT_INTENSITY * TERRAIN_BRIGHTNESS;
}
#endif
}
#endif

#if !defined(END_SHADER) && !defined(TERRAIN_PROFILE_SKIP_GRASS_PATCH_NOISE)
{
int _q71p17 = int(blockId + 0.5);
int _nd700x = (_q71p17 >= 10000) ? (_q71p17 - 10000) : -1;
if (_nd700x == 15 && _led594 < 0.5) {

float _5l5nx9 = max(normal.y, 0.0);
if (_5l5nx9 > 0.3) {
vec2 _3yeyai = worldPos.xz * 0.15;
float pn = 0.0;
float _9imorn = 0.6;
for (int _hiq5ip = 0; _hiq5ip < 3; _hiq5ip++) {
vec2 ip = floor(_3yeyai);
vec2 fp = fract(_3yeyai);
fp = fp * fp * (3.0 - 2.0 * fp);
float a = fract(sin(dot(ip, vec2(127.1, 311.7))) * 43758.5453);
float b = fract(sin(dot(ip + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453);
float c = fract(sin(dot(ip + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
float d = fract(sin(dot(ip + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453);
pn += mix(mix(a, b, fp.x), mix(c, d, fp.x), fp.y) * _9imorn;
_3yeyai *= 2.3;
_9imorn *= 0.45;
}

float _fiz8w3 = 1.0 - smoothstep(0.25, 0.55, pn);
float _hvy9wi = 0.20 * _fiz8w3 * _5l5nx9;

_yssmf1.rgb *= mix(vec3(1.0), vec3(0.7, 0.8, 0.95), _hvy9wi);
}
}
}
#endif

#ifdef TEXTURE_PALETTE_ENABLED
if (_led594 < 0.5) {
float _1pxkd6 = float(TEXTURE_PALETTE_LEVELS);
_yssmf1.rgb = floor(_yssmf1.rgb * _1pxkd6) / _1pxkd6;
}
#endif

#ifdef METALNESS_ENABLED
if (metalness > 0.5 && _led594 < 0.5) {
int _7go1ng = int(blockId + 0.5);
vec3 viewDir = normalize(worldPos - cameraPosition);

vec3 _86zxyk = normalize(mat3(gbufferModelViewInverse) * normal);
vec3 _5nq8zq = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 _jduub4 = vec3(1.0, 0.85, 0.60) * blocklight * blocklight;
#ifdef LPV_ENABLED
{
vec3 _hgiqyd = _dqt2v3(worldPos, _86zxyk, 1.0) * BLOCKLIGHT_BRIGHTNESS * 5.0;
float _qha32b = dot(_hgiqyd, vec3(0.299, 0.587, 0.114));
if (_qha32b > 0.001) _jduub4 = _hgiqyd;
}
#endif
float _pw06is = 1.0;
if (_7go1ng == 10090) {

float _525y13 = max(max(_dwo81a.r, _dwo81a.g), _dwo81a.b);
_pw06is = smoothstep(0.40, 0.62, _525y13);
}

#ifdef END_SHADER
float _7rnk99 = frameTimeCounter * 0.15;
vec3 _8c6zyk = normalize(vec3(sin(_7rnk99) * 0.4, 0.8, cos(_7rnk99) * 0.4));
vec3 _fb9wfw = _pqvb9e(_yssmf1.rgb, viewDir, _86zxyk, _8c6zyk, metalness, worldPos, frameTimeCounter, _dwo81a, 1.0, blocklight, _jduub4);
_yssmf1.rgb = mix(_yssmf1.rgb, _fb9wfw, _pw06is);
#else
float _3txq63 = dot(shadow, vec3(0.333)) * smoothstep(0.1, 0.5, skylight);
vec3 _fb9wfw = _2q5cue(_yssmf1.rgb, viewDir, _86zxyk, _5nq8zq, sunAngle, metalness, worldPos, _dwo81a, _3txq63, blocklight, _jduub4);
_yssmf1.rgb = mix(_yssmf1.rgb, _fb9wfw, _pw06is);
#endif
}
#endif

#ifdef PBR_ENABLED
PBRMaterial pbrMat = pbr_fallback(normal, DEFAULT_STONE_ROUGHNESS);
vec3 _z87xc0 = normal;
float _9dnv8b = 0.0;

if (_led594 < 0.5) {
vec4 _dp25va = texture(normals, texcoord);
vec4 _jx5qo9   = texture(specular, texcoord);

pbrMat = pbr_decode(_dp25va, _jx5qo9, _dwo81a, PBR_NORMAL_STRENGTH);
_9dnv8b = _qk34ll(pbrMat);

vec3 N;
if (pbrMat.hasData) {
N = _3af26h(pbrMat.nTangent, tangentVec, binormalVec, normal);
} else {

int _q71p17 = int(blockId + 0.5);
int _nd700x = (_q71p17 >= 10000) ? (_q71p17 - 10000) : -1;
if      (_nd700x == 10) pbrMat.roughness = DEFAULT_WOOD_ROUGHNESS;
else if (_nd700x == 17) pbrMat.roughness = 0.45;
else if (_nd700x == 99) pbrMat.roughness = DEFAULT_STONE_ROUGHNESS;
else                  pbrMat.roughness = -1.0;
N = normalize(normal);
}
_z87xc0 = N;
}

if (_led594 < 0.5 && metalness < 0.5) {

if (pbrMat.hasNormal && PBR_AO_STRENGTH > 0.001) {
float _hypycq = dot(shadow, vec3(0.299, 0.587, 0.114)) * _pl1tew;
float _x5imya = 1.0 - _hypycq;
float _5opcy3 = mix(1.0, pbrMat.ao, PBR_AO_STRENGTH * 0.5);
_yssmf1.rgb *= mix(1.0, _5opcy3, _x5imya);
}

if (pbrMat.hasSpec && pbrMat.roughness < 0.999) {
vec3 L      = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 _9jf9pv = normalize(mat3(gbufferModelViewInverse) * _z87xc0);
vec3 _ktti75 = normalize(cameraPosition - worldPos);
vec3 _1i015x = normalize(_ktti75 + L);
float NdotL = max(dot(_9jf9pv, L),      0.0);
float _x102pb = max(dot(_9jf9pv, _1i015x), 0.0);
float _i9o95p = max(dot(_9jf9pv, _ktti75), 1e-3);
vec3 _7xdnqm = vec3(0.0);
float _lkxfj7 = 0.0;
#ifdef LPV_ENABLED
if (pbrMat.hasSpec || pbrMat.metalness > 0.5) {
_7xdnqm = _dqt2v3(worldPos, _9jf9pv, 1.0) * BLOCKLIGHT_BRIGHTNESS * 5.0;
_lkxfj7 = dot(_7xdnqm, vec3(0.299, 0.587, 0.114));
}
#endif

float _rvunrw = dot(shadow, vec3(0.299, 0.587, 0.114)) * _pl1tew;

float _4dti9e = fract(sunAngle);
float _xya605 = smoothstep(0.00, 0.15, _4dti9e) * (1.0 - smoothstep(0.40, 0.55, _4dti9e));

float _5dyf8q = smoothstep(0.02, 0.15, _i9o95p);

float r = clamp(pbrMat.roughness, 0.5, 1.0);

float _xfzuai = mix(32.0, 4.0, r);
float _jv85j4 = pow(_x102pb, _xfzuai);

float _ndnwba = (_xfzuai + 2.0) / (2.0 * 3.14159265);
vec3  F = _6hjzil(_i9o95p, pbrMat.F0);
vec3 specular = _jv85j4 * _ndnwba * F * NdotL;
specular *= _5dyf8q * PBR_SPECULAR_STRENGTH * _rvunrw * _xya605;

vec3 _mgx03l = pbrMat.F0 * (1.0 - r) * _5dyf8q;
_mgx03l *= 0.15 * _pl1tew + _lkxfj7 * 0.35;
if (_lkxfj7 > 0.001) {
vec3 _mr6tzf = clamp(_7xdnqm / max(_lkxfj7, 0.0001), vec3(0.0), vec3(4.0));
_mgx03l *= mix(vec3(1.0), _mr6tzf, smoothstep(0.004, 0.06, _lkxfj7) * 0.45);
}

_yssmf1.rgb += specular + _mgx03l;

if (pbrMat.metalness > 0.5) {
vec3 R = reflect(-_ktti75, _9jf9pv);
float _kgogih = smoothstep(7.0 / 15.0, 12.0 / 15.0, _pl1tew);
vec3 _4gdz4v = _mzowin(R, sunAngle) * _kgogih;
if (_lkxfj7 > 0.001) {
vec3 _7188p4 = _7xdnqm * 1.4;
_4gdz4v = mix(_4gdz4v, _7188p4, smoothstep(0.004, 0.06, _lkxfj7) * (1.0 - _kgogih));
}
vec3 _vb9y3c = _6hjzil(_i9o95p, pbrMat.F0);
float _r1of5p = 0.35 * PBR_METAL_TINT_STRENGTH * pbrMat.metalness * _5dyf8q;
_yssmf1.rgb += _4gdz4v * _vb9y3c * _r1of5p * max(max(_pl1tew, 0.2), _lkxfj7 * 1.5);
}
}

if (pbrMat.hasData && pbrMat.porosity > 0.001 && PBR_POROSITY_STRENGTH > 0.001) {
float wetness = clamp(rainStrength, 0.0, 1.0) * smoothstep(0.5, 1.0, _pl1tew);
float _pwjgx8 = 1.0 - 0.35 * pbrMat.porosity * PBR_POROSITY_STRENGTH * wetness;
_yssmf1.rgb *= _pwjgx8;
}

if (pbrMat.hasData && pbrMat.hasSSS && PBR_SSS_STRENGTH > 0.001) {
vec3 L = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 V = normalize(worldPos - cameraPosition);
float _zp66rw = max(dot(V, L), 0.0);
float _ivej6k = pow(_zp66rw, 3.0) * pbrMat.sss * PBR_SSS_STRENGTH;
float _tn2sdh = dot(shadow, vec3(0.299, 0.587, 0.114)) * _pl1tew;
_yssmf1.rgb += _dwo81a * _ivej6k * _tn2sdh * 0.8;
}

}

if (_9dnv8b > 0.001) {
_led594 = max(_led594, _9dnv8b);
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS);
}
#endif

#ifdef LEAF_SHEEN_ENABLED
#ifdef MAGICAL_TOUCH
{
int _q71p17 = int(blockId + 0.5);
if ((_q71p17 == 10005 || _q71p17 == 10082) && _led594 < 0.5) {
vec3 _2nrisx = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 viewDir = normalize(worldPos - cameraPosition);

float _zp66rw = max(dot(viewDir, _2nrisx), 0.0);
float sss = pow(_zp66rw, 3.0) * LEAF_SSS_STRENGTH;
vec3 _p95cv4 = _yssmf1.rgb * vec3(1.2, 1.1, 0.7) * sss * _pl1tew * shadow;

_yssmf1.rgb += _p95cv4;
}
}
#endif
#endif

#ifdef LAVA_CRUST_ENABLED
{
int _bygk7d = int(blockId + 0.5);
bool _pa9b1t = (_bygk7d == 10039);
if (_pa9b1t) {
vec3 _b6tbew = normalize(mat3(gbufferModelViewInverse) * normal);
_yssmf1.rgb = _rmzct0(_yssmf1.rgb, worldPos, _b6tbew);

#ifdef BIOME_SOUL_SAND_VALLEY
if (biome == BIOME_SOUL_SAND_VALLEY) {
float _gwkmfw = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
vec3 _zc8eu3 = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _gwkmfw * 2.0;
_yssmf1.rgb = _zc8eu3;
}
#endif
}
}
#endif

#ifdef BIOME_SOUL_SAND_VALLEY
{
int _r8x4b7 = int(blockId + 0.5);
if (_r8x4b7 == 10040 && biome == BIOME_SOUL_SAND_VALLEY) {
float _gp1k8o = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
vec3 _h8kwmc = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _gp1k8o * 2.0;

float _ctu159 = max(_yssmf1.r - _yssmf1.b, 0.0);
_yssmf1.rgb = mix(_yssmf1.rgb, _h8kwmc, smoothstep(0.05, 0.2, _ctu159));
}
}
#endif

if (_led594 < 0.5 && isEyeInWater != 1 && !_9cwhip(biome)) {
float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
_yssmf1.rgb = mix(_1jzgf0(), _yssmf1.rgb, _lr3hjh);
}

#ifdef VOXY_DEBUG_BRIGHTNESS_MATCH
{
float _ieqz48 = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
_yssmf1.rgb = vec3(_ieqz48);
}
#endif

gl_FragData[0] = _yssmf1;

gl_FragData[1] = vec4(outlineMask, _led594, _pl1tew, isHeatSource);

#ifdef BLOOM_ENABLED

vec3 _mxcjdz = vec3(0.0);
#ifdef EMISSIVE_MASKING
if (emissive > 0.5 && _0eryme >= 0.05) {
int _0xx2y3 = int(floor(emissiveType + 0.5));
if (_0xx2y3 == 19) {
_mxcjdz = vec3(1.0, 0.75, 0.2) * EMISSIVE_BRIGHTNESS * 0.15;
} else if (_0xx2y3 == 17) {

_mxcjdz = vec3(1.0, 0.8, 0.3) * EMISSIVE_BRIGHTNESS * clamp(_0eryme, 0.0, 1.0) * 1.5;
} else if (_0xx2y3 == 46) {

_mxcjdz = _dwo81a * EMISSIVE_BRIGHTNESS * 0.15;
} else {
_mxcjdz = _dwo81a * EMISSIVE_BRIGHTNESS * clamp(_0eryme, 0.0, 1.0);
}
}
#else
if (_led594 > 0.5) {
int et = int(floor(emissiveType + 0.5));
bool _sxpa8v = (et == -14 || et == 0 || et == 15 || et == 16 || et == 22 || et == 30);
bool _03o7um = (et == 1 || et == 23);
if (_sxpa8v) {
_mxcjdz = vec3(1.0, 0.85, 0.4) * EMISSIVE_BRIGHTNESS;
} else if (_03o7um) {
_mxcjdz = vec3(0.3, 0.7, 1.0) * EMISSIVE_BRIGHTNESS;
} else {
_mxcjdz = _dwo81a * EMISSIVE_BRIGHTNESS;
}
}
#endif

#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
_mxcjdz = max(_mxcjdz, _7qz11m(_dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS));
}
#endif

if (_anrfx5) {
_mxcjdz = _0mfaw3;
}

#ifdef BIOME_SOUL_SAND_VALLEY
{
int _ttzm79 = int(blockId + 0.5);
if ((_ttzm79 == 10039 || _ttzm79 == 10040) && biome == BIOME_SOUL_SAND_VALLEY) {
float _m6b5e7 = dot(_mxcjdz, vec3(0.299, 0.587, 0.114));
_mxcjdz = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * _m6b5e7 * 2.0;
}
}
#endif
gl_FragData[2] = vec4(_mxcjdz, 1.0);
gl_FragData[3] = vec4(_mxcjdz, 1.0);
#endif

#if defined(MATERIAL_REFLECTIONS_ENABLED) || defined(LEAF_AA_ENABLED)
#ifdef LEAF_AA_ENABLED
if (_clyfkl(blockId)) {
_d5fiqv(vec4(0.0, LEAF_AA_MATERIAL_TAG, 0.0, 0.0));
} else
#endif
{
#ifdef MATERIAL_REFLECTIONS_ENABLED

float _28idd5 = dot(_vefeh2, vec3(0.299, 0.587, 0.114));
float _qkgbic = smoothstep(0.08, 0.72, _28idd5);
float _wphgq6 = pow(1.0 - _qkgbic, 2.0);

bool _4pe46w = (reflective > 0.5);
#ifdef PBR_ENABLED
float _977lgx = 0.0;
if (pbrMat.hasSpec && pbrMat.roughness >= 0.0) {
_977lgx = 1.0 - sqrt(clamp(pbrMat.roughness, 0.0, 1.0));

_4pe46w = _4pe46w
|| (_977lgx > 0.08)
|| (pbrMat.metalness > 0.5)
|| (pbrMat.F0scalar > 0.08);
}
#endif

if (_4pe46w && _led594 < 0.5) {
#ifdef PBR_ENABLED
vec3 _el9o7l = _z87xc0;
PBRMaterial ssrMat = pbrMat;

if (!ssrMat.hasSpec || ssrMat.roughness < 0.0) {
ssrMat.roughness = _wphgq6;
}
vec3 _tkgg08 = normalize(mat3(gbufferModelViewInverse) * _el9o7l);
_d5fiqv(_c52ppx(ssrMat, _tkgg08));
#else

vec3 _tkgg08 = normalize(mat3(gbufferModelViewInverse) * normal);
_d5fiqv(vec4(_wphgq6, 0.0, _tkgg08.x * 0.5 + 0.5, _tkgg08.y * 0.5 + 0.5));
#endif
} else {
_d5fiqv(vec4(0.0));
}
#else
_d5fiqv(vec4(0.0));
#endif
}
#endif
}
