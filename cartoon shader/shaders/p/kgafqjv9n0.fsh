/* RENDERTARGETS: 7,1,2,3,4,5 */

#include "/settings.glsl"
#include "/include/glass_reflection_payload.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
#include "/include/hovering.glsl"
#include "/include/water_color.glsl"
#include "/include/ocean_waves.glsl"

uniform sampler2D gtexture;
uniform sampler2D shadowtex0;
#ifdef PBR_ENABLED
uniform sampler2D normals;
uniform sampler2D specular;
#endif
uniform sampler2D depthtex1;
uniform mat4 gbufferProjectionInverse;
uniform float near;
uniform float far;
uniform float alphaTestRef;
uniform vec3 fogColor;
uniform int biome_category;
uniform float fogStart;
uniform float fogEnd;
uniform float sunAngle;
uniform vec3 shadowLightPosition;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform float biome_swamp;
uniform int isEyeInWater;
uniform float viewWidth;
uniform float viewHeight;
uniform int frameCounter;

#include "/include/lighting.glsl"
#ifdef PBR_ENABLED
#include "/include/pbr.glsl"
#endif
uniform float frameTimeCounter;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_arid;
uniform float biome_savanna;
uniform float biome_beach;
uniform float biome_ocean;

in vec2 texcoord;
in vec4 glcolor;
in float viewDistance;
in float postMask;
in float isWater;
in float isHologram;
in vec3 worldPos;
in vec3 viewPos;
in vec3 normal;
in float skylight;
in float blocklight;
in vec3 waveNormal;
in float waveHeight;
in vec4 shadowPos;
flat in float isIce;
flat in float isHeatSource;
flat in int blockId;
in float waterBlockFracY;
in float waterFlowFlag;
#ifdef PBR_ENABLED
in vec3 tangentVec;
in vec3 binormalVec;
#endif

#include "/include/fog_color.glsl"

float _w5dqoo(float x) {
return fract(sin(x * 12.9898) * 43758.5453);
}

#include "/include/noise.glsl"

float _umnk9n(vec3 _yssmf1) {
float _xgal31 = max(max(_yssmf1.r, _yssmf1.g), _yssmf1.b);
float _aslobc = min(min(_yssmf1.r, _yssmf1.g), _yssmf1.b);
float _zj0avb = _xgal31 > 0.01 ? (_xgal31 - _aslobc) / _xgal31 : 0.0;

bool _zyjl9z = (_yssmf1.b > _yssmf1.r * 1.2) && (_yssmf1.b > 0.25) && (_zj0avb > 0.3);
if (_zyjl9z) return 0.0;

bool _xrk8sx = (_yssmf1.b > _yssmf1.r) && (_xgal31 > 0.6) && (_zj0avb < 0.4);
if (_xrk8sx) return 0.0;

return 1.0;
}

vec3 _woie3o(int id, vec3 _enloex) {
if (id == 64) return vec3(1.0, 0.1, 0.1);
if (id == 65) return vec3(1.0, 0.3, 0.1);
if (id == 66) return vec3(1.0, 1.0, 0.1);
if (id == 67) return vec3(1.0, 0.75, 0.5);
if (id == 68) return vec3(0.3, 1.0, 0.3);
if (id == 69) return vec3(0.1, 1.0, 0.1);
if (id == 70) return vec3(0.1, 0.15, 1.0);
if (id == 71) return vec3(0.5, 0.65, 1.0);
if (id == 72) return vec3(0.3, 0.8, 1.0);
if (id == 73) return vec3(0.7, 0.3, 1.0);
if (id == 74) return vec3(1.0, 0.1, 1.0);
if (id == 75) return vec3(1.0, 0.4, 1.0);
if (id == 76) return vec3(0.05);
if (id >= 77 && id <= 79) return vec3(1.0);
return _enloex;
}

#if defined(PIXELATED_SHADOWS) && defined(SHADOWS_ENABLED)
vec3 _jvjur6(vec3 _uyjapd, vec3 _grfjdi) {
vec3 _q9rkda = _uyjapd - cameraPosition;
vec3 _id3sae = (shadowProjection * shadowModelView * vec4(_q9rkda, 1.0)).xyz;
float _ug3i3h = _ckk90a(_id3sae);
vec3 _4bqgs3 = _2y5umb(_id3sae) * 0.5 + 0.5;
vec4 _mnvvf9 = shadowProjection * vec4(mat3(shadowModelView) * _grfjdi, 1.0);
_4bqgs3.xyz += _mnvvf9.xyz / _mnvvf9.w * _ug3i3h;
return _4bqgs3;
}

float _irhugw(vec3 _tkgg08) {
vec3 _1z1cu1 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _4gjzln = 1.0 - clamp(dot(normalize(_tkgg08), _1z1cu1), 0.0, 1.0);
return (0.35 + 0.65 * _4gjzln) / float(_qezbw4);
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

void main() {
vec4 _r4digw = texture(gtexture, texcoord);
vec4 _yssmf1 = _r4digw * glcolor;
if (_yssmf1.a < alphaTestRef) {
discard;
}

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
_yssmf1.a *= _fxiwh2;
if (_yssmf1.a < 0.01) {
discard;
}
}
#endif
#endif
}

vec3 _dwo81a = _yssmf1.rgb;
#ifdef LPV_ENABLED
_pis44d = _dwo81a;
_06143i = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
#endif
float emissive = 0.0;
vec3 _mxcjdz = vec3(0.0);
vec3 _axybuj = vec3(0.0);

float _499ujg = 0.0;
if (blockId == 88 || blockId == 63) {
emissive = 1.0;
_yssmf1.a = 1.0;
if (blockId == 88) {
float _f5dj31 = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
float _anidwx = smoothstep(0.10, 0.70, _f5dj31);
float _03qgyw = mix(0.55, 1.95, _anidwx * _anidwx);
_yssmf1.rgb *= EMISSIVE_BRIGHTNESS * 2.5 * _03qgyw;
} else {
_yssmf1.rgb *= EMISSIVE_BRIGHTNESS;
}

vec3 _tkgg08 = normalize(mat3(gbufferModelViewInverse) * normal);
_499ujg = 100.0 / 255.0;
if (abs(_tkgg08.x) > 0.5) _499ujg = 150.0 / 255.0;
else if (abs(_tkgg08.z) > 0.5) _499ujg = 200.0 / 255.0;
}
bool _u7zbom = !gl_FrontFacing;

float shadow = 1.0;
#ifdef SHADOWS_ENABLED
if (skylight > 0.1) {
vec3 _p43sug = shadowPos.xyz;
#ifdef PIXELATED_SHADOWS
vec3 _2zjeh0 = normalize(mat3(gbufferModelViewInverse) * normal);
vec3 _lm95q2 = _5kwiu1(worldPos, _2zjeh0);
_p43sug = _jvjur6(_lm95q2, _2zjeh0);
#endif

#if defined(PIXELATED_SHADOWS) || defined(SHARP_SHADOWS) || defined(MAGICAL_TOUCH)
#ifdef PIXELATED_SHADOWS
shadow = _dxmo4t(shadowtex0, _p43sug, _lm95q2, _2zjeh0);
#else
shadow = _q06ww9(shadowtex0, _p43sug, 0.0);
#endif
float _rjtkh7 = 1.0 - _xr26fh(_p43sug, viewDistance);
shadow = mix(1.0, shadow, _s4lpf1(_p43sug) * _rjtkh7);
#else
float _izh8vx = _h1jpqh(gl_FragCoord.xy, frameCounter);
_izh8vx = _e4hc8m(_izh8vx, _p43sug);
float r = _55535n(_p43sug.xy * 2.0 - 1.0);
float _w02w60 = r + SHADOW_DISTORTION;
shadow = _x245zo(shadowtex0, _p43sug, _w02w60, viewDistance, _izh8vx);
#endif

shadow = mix(1.0, shadow, skylight);
shadow = mix(1.0, shadow, SHADOW_OPACITY);

float _6obksq = 1.0 - smoothstep(0.0, 0.15, shadowPos.w);
shadow = mix(shadow, 0.0, _6obksq);
}
#endif

float _d5ovut = blocklight;
vec4 _xrdem2 = vec4(0.0);
bool _hdgqqa = (blockId >= 64 && blockId <= 80);
if (_hdgqqa && _u7zbom) discard;
float _xp7jv7 = 0.0;
float _56k3j0 = 0.0;
float _r66fbx = 0.0;
bool _0mjp3o = false;

if (isWater > 0.5) {
vec3 _rp4u74 = normalize(mat3(gbufferModelViewInverse) * normal);
float _n4k7cp = biome_beach;
#ifdef BEACH_WAVES_EVERYWHERE
_n4k7cp = 1.0;
#endif

if (isEyeInWater == 1) {

float _agv44g = abs(worldPos.y - float(SEA_LEVEL_OFFSET));
if (_agv44g < 1.5) {
discard;
}
if (_u7zbom) {
if (_rp4u74.y > 0.5) {
#include "/include/water/water_inside_ceiling.glsl"
} else if (_rp4u74.y < -0.5) {
#include "/include/water/water_inside_floor.glsl"
} else {
#include "/include/water/water_inside_walls.glsl"
}
} else {
#include "/include/water/water_inside_front.glsl"
}
} else {

if (_n4k7cp > 0.01 && _n4k7cp >= biome_ocean
&& _rp4u74.y < 0.5 && _rp4u74.y > -0.5
&& worldPos.y > float(SEA_LEVEL_OFFSET) - 1.0 && worldPos.y < float(SEA_LEVEL_OFFSET) + 1.0) {
discard;
}

if (_u7zbom) {
#include "/include/water/water_outside_back.glsl"
} else {
if (_rp4u74.y > 0.5) {
#include "/include/water/water_outside_top.glsl"
} else {
#include "/include/water/water_outside_sides.glsl"
_0mjp3o = true;
}
}

}

float _pycbpa = smoothstep(0.0, 0.8, waterBlockFracY);
_yssmf1.a = WATER_OPACITY;

if (biome_swamp > 0.01 && isEyeInWater != 1 && _rp4u74.y > 0.5) {
float st = frameTimeCounter * 0.3;

vec2 _ntz20f = floor(worldPos.xz * 16.0) / 16.0;

float _wksarx = _cks7vw(_ntz20f * 0.15 + vec2(st * 0.08, -st * 0.06));
float _pxe7rs = _cks7vw(_ntz20f * 0.15 + vec2(-st * 0.07, st * 0.09) + vec2(13.5, -8.2));
vec2 _zt1tk0 = (vec2(_wksarx, _pxe7rs) - 0.5) * 1.8;
vec2 _9z4r2s = _ntz20f + _zt1tk0;
float _6mj3b7 = _cks7vw(_9z4r2s * 0.35 + vec2(st * 0.10, -st * 0.08));
float _6hf4pm = _cks7vw(_9z4r2s * 0.7 + vec2(-st * 0.12, st * 0.11) + vec2(7.3, -4.1));
float _8536of = _cks7vw(_9z4r2s * 1.4 + vec2(st * 0.06, st * 0.14) + vec2(-3.5, 9.2));
float _qp0qrf = _6mj3b7 * 0.5 + _6hf4pm * 0.35 + _8536of * 0.15;
float _1ullzn = smoothstep(0.35, 0.80, _qp0qrf);

float _vwc6wd = length(worldPos.xz - cameraPosition.xz);
float _gsm0b1 = 1.0 - smoothstep(40.0, 80.0, _vwc6wd);
_1ullzn *= _gsm0b1;

float _9xa04e = mix(0.5, 1.0, _1ullzn * biome_swamp);
_xrdem2.x = max(_xrdem2.x, _9xa04e);
}

float _wowu50 = max(_n4k7cp, biome_ocean);

float _lapaim = 1.0 - smoothstep(WATER_BLUR_START, WATER_BLUR_END, length(worldPos.xz - cameraPosition.xz));
float _2je5x6 = (_n4k7cp >= biome_ocean) ? _lapaim : 1.0;

#define FWAVE_RAW(f) (smoothstep(0.15, 0.25, f) * (1.0 - pow(smoothstep(0.25, 1.15, f), 0.45)))
#define FWAVE(px) FWAVE_RAW(1.0 - fract(px))

#define FOWAVE(px) (pow(0.5 + 0.5 * sin((fract(px) - 0.25) * 6.2832), 1.6))
#define FSMAX(a, b, k) (max(a, b) + pow(max(k - abs(a - b), 0.0) / k, 3.0) * k * 0.166667)

#ifdef WATER_FOAM_ENABLED
if (_n4k7cp > 0.01 && _n4k7cp >= biome_ocean
&& worldPos.y > float(SEA_LEVEL_OFFSET) - 1.0 && worldPos.y < float(SEA_LEVEL_OFFSET) + 1.0) {
float ft = frameTimeCounter * WATER_WAVE_SPEED;
float _c1hb78 = worldPos.x * WATER_WAVE_SCALE;
float _yq6ewo = worldPos.z * WATER_WAVE_SCALE;

float _vjdhmm = sin(_yq6ewo * 0.21 + 3.7) * 2.5 + sin(_yq6ewo * 0.53 + 1.2) * 1.3;
float _aovtg7 = sin(_yq6ewo * 0.37 + 5.1) * 1.8 + sin(_yq6ewo * 0.71 + 2.8) * 1.1;
float _ybobds = sin(_yq6ewo * 0.62 + 0.9) * 1.2 + sin(_yq6ewo * 0.89 + 4.3) * 0.8;

float _h8lkwk = FWAVE((_c1hb78 * 0.8 + _vjdhmm - ft) / 6.2832);
float _g4hkm3 = FWAVE((_c1hb78 * 1.8 + _aovtg7 - ft * 1.6) / 6.2832);
float _kdyzdg = clamp(FSMAX(_h8lkwk, _g4hkm3 * 0.55, 0.15), 0.0, 1.0);
_kdyzdg += FWAVE((_c1hb78 * 4.0 + _ybobds - ft * 2.2) / 6.2832) * 0.15 * _kdyzdg;

float _sfmo6s = sin(_c1hb78 * 4.5 + _yq6ewo * 1.2 - ft * 3.0) * 0.08
+ sin(_c1hb78 * 7.0 - _yq6ewo * 2.3 + ft * 4.5) * 0.05
+ sin(_c1hb78 * 2.8 + _yq6ewo * 5.5 + ft * 2.2) * 0.06
+ sin(_c1hb78 * 11.0 + _yq6ewo * 3.8 - ft * 5.5) * 0.03
+ sin(_c1hb78 * 5.5 - _yq6ewo * 8.0 + ft * 3.8) * 0.04;
_kdyzdg = clamp(_kdyzdg + _sfmo6s * _kdyzdg, 0.0, 1.0);

_xrdem2.x = mix(0.5, _kdyzdg, _n4k7cp) + _56k3j0;

float _ijy5rx = 0.15;
float _n599ck = (worldPos.x + _ijy5rx) * WATER_WAVE_SCALE;
float _ue9p1y = clamp(FSMAX(FWAVE((_n599ck * 0.8 + _vjdhmm - ft) / 6.2832), FWAVE((_n599ck * 1.8 + _aovtg7 - ft * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_ue9p1y += FWAVE((_n599ck * 4.0 + _ybobds - ft * 2.2) / 6.2832) * 0.15 * _ue9p1y;
float _kwlp6v = (worldPos.z + _ijy5rx) * WATER_WAVE_SCALE;
float _nuj31l = sin(_kwlp6v * 0.21 + 3.7) * 2.5 + sin(_kwlp6v * 0.53 + 1.2) * 1.3;
float _hyidgu = sin(_kwlp6v * 0.37 + 5.1) * 1.8 + sin(_kwlp6v * 0.71 + 2.8) * 1.1;
float _t5mw87 = sin(_kwlp6v * 0.62 + 0.9) * 1.2 + sin(_kwlp6v * 0.89 + 4.3) * 0.8;
float _l3f01s = clamp(FSMAX(FWAVE((_c1hb78 * 0.8 + _nuj31l - ft) / 6.2832), FWAVE((_c1hb78 * 1.8 + _hyidgu - ft * 1.6) / 6.2832) * 0.55, 0.15), 0.0, 1.0);
_l3f01s += FWAVE((_c1hb78 * 4.0 + _t5mw87 - ft * 2.2) / 6.2832) * 0.15 * _l3f01s;
float _zd9oup = (_ue9p1y - _kdyzdg) / _ijy5rx;
float _zbpwxl = (_l3f01s - _kdyzdg) / _ijy5rx;
float _qjlyjz = length(vec2(_zd9oup, _zbpwxl));
float _hn16ls = smoothstep(0.0, 0.28, _zd9oup);
float _cgc43z = smoothstep(0.0, 0.28, -_zd9oup);

float _6q557u = smoothstep(0.84, 0.97, _kdyzdg);
float _xb2gn4 = _cks7vw(worldPos.xz * 2.2 + vec2(-ft * 0.9, ft * 0.5));
float _2yhfj4 = _cks7vw(worldPos.xz * 3.9 + vec2(ft * 1.3, -ft * 0.8) + vec2(5.7, -3.1));
_6q557u = smoothstep(0.10, 0.66, _6q557u + _6q557u * pow(clamp(_xb2gn4 * 0.70 + _2yhfj4 * 0.30, 0.0, 1.0), 3.6) * 0.38);

float _23cmm2 = smoothstep(0.74, 0.92, _kdyzdg) * (1.0 - smoothstep(0.96, 0.995, _kdyzdg));
vec2 _eu0til = worldPos.xz * vec2(3.8, 3.2) + vec2(-ft * 1.8, ft * 1.2);
float _93kcwn = pow(clamp(_cks7vw(_eu0til + vec2(2.7, -1.9)) * 0.65 + _cks7vw(_eu0til * 1.7 + vec2(-5.4, 4.1)) * 0.35, 0.0, 1.0), 4.6);
_6q557u = max(_6q557u, _93kcwn * _23cmm2 * smoothstep(0.18, 0.95, _qjlyjz) * mix(0.65, 1.0, _hn16ls) * 0.55);

float _hxtzg7 = smoothstep(0.08, 0.76, _kdyzdg) * (1.0 - smoothstep(0.90, 0.98, _kdyzdg));
vec2 _gqoxjk = normalize(vec2(1.0, 0.24));
vec2 _76jp1p = vec2(-_gqoxjk.y, _gqoxjk.x);
vec2 _tvajd3 = vec2(dot(worldPos.xz, _gqoxjk), dot(worldPos.xz, _76jp1p)) + vec2(-ft * 0.55, ft * 0.10);
float _wksarx = _cks7vw(_tvajd3 * 0.28 + vec2(0.0, ft * 0.03));
float _pxe7rs = _cks7vw(_tvajd3 * 0.46 + vec2(13.7, -8.4) + vec2(-ft * 0.04, ft * 0.02));
vec2 _8rj0h6 = _tvajd3 + vec2((_wksarx - 0.5) * 0.9, (_pxe7rs - 0.5) * 0.6);
float nA = _cks7vw(_8rj0h6 * 0.72);
float nB = _cks7vw(_8rj0h6 * 1.25 + vec2(4.6, -2.9));
float nC = _cks7vw(_8rj0h6 * 2.10 + vec2(-7.1, 3.8));
float _fcz0c2 = pow(clamp((1.0 - abs(nA * 2.0 - 1.0)) * 0.62 + (1.0 - abs(nB * 2.0 - 1.0)) * 0.30 + (1.0 - abs(nC * 2.0 - 1.0)) * 0.08, 0.0, 1.0), 1.85);
_fcz0c2 *= smoothstep(0.36, 0.74, nA + nB * 0.38);
float _1epsxk = pow(max(nB - 0.70, 0.0) * 3.3, 2.4) * mix(0.0002, 0.0020, smoothstep(0.45, 0.92, _kdyzdg));
float _3j2z90 = _fcz0c2 * _hxtzg7 * mix(0.42, 1.0, _cgc43z) * mix(0.70, 1.05, smoothstep(0.26, 0.88, clamp(_kdyzdg + _1epsxk, 0.0, 1.0)));
float _g2z7fx = max(_6q557u, _3j2z90);

float _cu4ufk = _g4hkm3;
float _ef64h9 = FWAVE((_n599ck * 1.8 + _aovtg7 - ft * 1.6) / 6.2832);
float _31pglp = FWAVE((_c1hb78 * 1.8 + _hyidgu - ft * 1.6) / 6.2832);
float _b3pk82 = length(vec2(_ef64h9 - _cu4ufk, _31pglp - _cu4ufk)) / _ijy5rx;
float _t72mzf = smoothstep(0.0, 0.24, -(_ef64h9 - _cu4ufk) / _ijy5rx);
float _7dwdb0 = max(smoothstep(0.56, 0.82, _cu4ufk) * (1.0 - smoothstep(0.88, 0.98, _cu4ufk)) * 0.65,
smoothstep(0.24, 0.54, _cu4ufk) * (1.0 - smoothstep(0.70, 0.92, _cu4ufk)) * _t72mzf * 0.80);
_7dwdb0 *= smoothstep(0.04, 0.20, _b3pk82);
float _1eqg8c = _cks7vw(worldPos.xz * 1.25 + vec2(-ft * 0.55, ft * 0.25));
float _gb00hy = _cks7vw(worldPos.xz * 2.10 + vec2(ft * 0.90, -ft * 0.60) + vec2(6.1, -2.3));
_7dwdb0 *= smoothstep(0.40, 0.86, _1eqg8c * 0.72 + _gb00hy * 0.28) * (1.0 - smoothstep(0.83, 0.96, _kdyzdg)) * 0.72;

float _7vhcjd = max(_g2z7fx, _7dwdb0) * _n4k7cp * _2je5x6;

_xrdem2.x += _7vhcjd;
}

#endif
#undef FWAVE
#undef FWAVE_RAW
#undef FOWAVE
#undef FSMAX

#ifdef WATER_FOAM_ENABLED
if (isEyeInWater != 1 && _rp4u74.y > 0.5) {
vec2 _16n4rq = gl_FragCoord.xy / textureSize(depthtex1, 0);
float _klqean = texture(depthtex1, _16n4rq).r;

vec4 _v8celk = vec4(_16n4rq * 2.0 - 1.0, _klqean * 2.0 - 1.0, 1.0);
vec4 _f5kpt2 = gbufferProjectionInverse * _v8celk;
_f5kpt2 /= _f5kpt2.w;
vec3 _qi52uz = (gbufferModelViewInverse * _f5kpt2).xyz + cameraPosition;

float _vprtmg = worldPos.y - _qi52uz.y;

float _rom2qx = 1.0 - smoothstep(0.0, 0.6, _vprtmg);
_rom2qx *= _rom2qx;

_rom2qx *= step(0.0, _vprtmg) * step(_klqean, 0.999999);

float _m4co1z = frameTimeCounter;
float _3qanxw = _cks7vw(worldPos.xz * 2.5 + vec2(_m4co1z * 0.8, -_m4co1z * 0.6));
float _l92pzl = _cks7vw(worldPos.xz * 5.0 + vec2(-_m4co1z * 1.2, _m4co1z * 0.9) + vec2(7.3, -4.1));
float _8gudyr = _3qanxw * 0.6 + _l92pzl * 0.4;
_8gudyr = smoothstep(0.35, 0.55, _8gudyr);
_rom2qx *= _8gudyr;

_rom2qx *= _2je5x6;

_xrdem2.x += _rom2qx * WATER_FOAM_INTENSITY * 0.15;
}
#endif

#ifdef WATER_PLAYER_FOAM_ENABLED
if (isEyeInWater != 1 && _rp4u74.y > 0.5) {
vec3 _5sf11s = eyePosition - vec3(0.0, 1.62, 0.0);
vec2 _8ur7qh = worldPos.xz - _5sf11s.xz;
float _lb2ewh = length(_8ur7qh);
float _1kda7y = frameTimeCounter;

float _dmnp9j = 1.0 - smoothstep(0.0, 1.0, abs(worldPos.y - _5sf11s.y));

float _nr5rfo = WATER_PLAYER_FOAM_RADIUS;
float _txavkz = 1.0 - smoothstep(_nr5rfo * 0.3, _nr5rfo, _lb2ewh);

float _fljyws = _cks7vw(worldPos.xz * 6.0 + vec2(_1kda7y * 2.5, -_1kda7y * 1.8));
float _5lpa59 = _cks7vw(worldPos.xz * 10.0 + vec2(-_1kda7y * 3.0, _1kda7y * 2.2) + vec2(3.7, -2.1));
float _j25mk1 = _fljyws * 0.55 + _5lpa59 * 0.45;
_j25mk1 = smoothstep(0.25, 0.55, _j25mk1);

float _huatah = atan(_8ur7qh.y, _8ur7qh.x);
float _ual9me = sin(_huatah * 5.0 + _1kda7y * 4.0) * 0.3
+ sin(_huatah * 8.0 - _1kda7y * 6.0) * 0.2;
_txavkz *= smoothstep(-0.1, 0.2, _txavkz + _ual9me * 0.3);

float _w5b1fo = _txavkz * _j25mk1 * _dmnp9j * WATER_PLAYER_FOAM_INTENSITY * _2je5x6;

_xrdem2.x += _w5b1fo * 0.12;
}
#endif

#ifdef WATER_WAVES_ENABLED
if (_rp4u74.y > 0.5 && _xrdem2.y < 0.5) {
_xrdem2.x = 0.5;
_xrdem2.y = 1.0;
_xrdem2.z = 0.5;
_xrdem2.w = 1.0;
}
#endif

if (_xrdem2.y < 0.5) {
vec3 _n8gfxt = _u7zbom ? -_rp4u74 : _rp4u74;
_xrdem2.x = max(_xrdem2.x, 0.5);
_xrdem2.y = _kup5d9(_n8gfxt);
_xrdem2.z = _n8gfxt.x * 0.5 + 0.5;
_xrdem2.w = _n8gfxt.y * 0.5 + 0.5;
}

#ifdef WATER_FOAM_ENABLED
if (isEyeInWater != 1 && _rp4u74.y > 0.5 && _n4k7cp < 0.99) {
float _c7ste3 = frameTimeCounter;
vec2 _8lbg3f = floor(worldPos.xz * 16.0) / 16.0;

float ct = _c7ste3 * WATER_WAVE_SPEED * 0.2;
vec3 _0rl3ii = vec3(_8lbg3f.x, 0.0, _8lbg3f.y) * 0.35;

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

float _w00hjk = 12.0;
float _n2f1t4 = 2.5;
float _nsyelw = 0.07;
vec2 _r6ugfh = worldPos.xz * _nsyelw;
vec2 _vf2ebm = floor(_r6ugfh);

float _r4mnbw = 0.0;

for (int gx = -1; gx <= 1; gx++) {
for (int gy = -1; gy <= 1; gy++) {
vec2 _h908e6 = _vf2ebm + vec2(float(gx), float(gy));

float h1 = fract(sin(dot(_h908e6, vec2(127.1, 311.7))) * 43758.5453);
float h2 = fract(sin(dot(_h908e6, vec2(269.5, 183.3))) * 43758.5453);
float h3 = fract(sin(dot(_h908e6, vec2(419.2, 371.9))) * 43758.5453);

float _31394t = floor((_c7ste3 + h1 * _w00hjk) / _w00hjk);
float h4 = fract(sin(dot(vec2(_31394t, h1 * 100.0), vec2(127.1, 311.7))) * 43758.5453);
float h5 = fract(sin(dot(vec2(_31394t, h2 * 100.0), vec2(269.5, 183.3))) * 43758.5453);

float _c1cy1c = mod(_c7ste3 + h1 * _w00hjk, _w00hjk) / _w00hjk;
vec2 _pnr1f3 = vec2(h3 - 0.5, h1 - 0.5) * _c1cy1c * 0.5;
vec2 _o8zme9 = _h908e6 + vec2(0.2 + h4 * 0.6, 0.2 + h5 * 0.6) + _pnr1f3;

vec2 _ic9jj6 = _r6ugfh - _o8zme9;

float _huatah = atan(_ic9jj6.y, _ic9jj6.x);
float _31trnd = 1.0 + 0.2 * sin(_huatah * 3.0 + h3 * 6.28)
+ 0.1 * sin(_huatah * 5.0 + h1 * 6.28);
float _t25r5m = length(_ic9jj6) * _31trnd;

float _c4eczi = mod(_c7ste3 + h1 * _w00hjk, _w00hjk) / _w00hjk;

float _td7lfx = 0.45;
float _9zitwm = smoothstep(0.0, 0.4, _c4eczi) * _td7lfx;
float _wn2hnz = smoothstep(0.3, 0.95, _c4eczi) * _td7lfx * 1.3;

float _8ahrec = _9zitwm > 0.0001
? 1.0 - smoothstep(_9zitwm * 0.4, _9zitwm, _t25r5m)
: 0.0;
float _18rqbh = _wn2hnz > 0.0001
? smoothstep(_wn2hnz * 0.3, _wn2hnz, _t25r5m)
: 1.0;
float _md07hl = _8ahrec * _18rqbh;

float _795b2k = step(0.4, h2);

_r4mnbw = max(_r4mnbw, _rbvgpe * _md07hl * _795b2k);
}
}
_r4mnbw *= 0.10 * (1.0 - _n4k7cp);

float _uco02z = length(worldPos.xz - cameraPosition.xz);
float _7c0u6d = 1.0 - smoothstep(24.0, 60.0, _uco02z);

_xrdem2.x += _r4mnbw * _7c0u6d;
}
#endif

}

if (isWater < 0.5 && emissive < 0.5) {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _iroce3(_yssmf1.rgb, sunAngle, skylight, _d5ovut, 0.0, shadow, worldPos.y);

#ifdef PBR_ENABLED
vec4 _dp25va = texture(normals, texcoord);
vec4 _jx5qo9   = texture(specular, texcoord);
PBRMaterial pm = pbr_decode(_dp25va, _jx5qo9, _dwo81a, PBR_NORMAL_STRENGTH);
float _9dnv8b = _qk34ll(pm);

if (!_hdgqqa && pm.hasSpec && pm.roughness < 0.999) {
vec3 N  = _3af26h(pm.nTangent, tangentVec, binormalVec, normal);
vec3 L  = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 Nw = normalize(mat3(gbufferModelViewInverse) * N);
vec3 Vw = normalize(cameraPosition - worldPos);
vec3 _l9i1nf = Vw + L;
float _bttslr = dot(_l9i1nf, _l9i1nf);
vec3 Hw = _bttslr > 1e-10
? _l9i1nf * inversesqrt(_bttslr)
: vec3(0.0);
float NdotL = max(dot(Nw, L),  0.0);
float _x102pb = max(dot(Nw, Hw), 0.0);
float _i9o95p = max(dot(Nw, Vw), 1e-3);
float _5dyf8q = smoothstep(0.02, 0.15, _i9o95p);
float r = clamp(pm.roughness, 0.5, 1.0);
float _xfzuai = mix(32.0, 4.0, r);
float _jv85j4 = pow(_x102pb, _xfzuai);
float _ndnwba = (_xfzuai + 2.0) / (2.0 * 3.14159265);
vec3  F = _6hjzil(_i9o95p, pm.F0);
vec3 _xyhmor = _jv85j4 * _ndnwba * F * NdotL;
vec3 _mgx03l = pm.F0 * (1.0 - r) * 0.15 * skylight * _5dyf8q;
float _4dti9e = fract(sunAngle);
float _xya605 = smoothstep(0.00, 0.15, _4dti9e) * (1.0 - smoothstep(0.40, 0.55, _4dti9e));
_yssmf1.rgb += _xyhmor * _5dyf8q * PBR_SPECULAR_STRENGTH * shadow * skylight * _xya605 + _mgx03l;
}

if (_9dnv8b > 0.001) {
emissive = max(emissive, _9dnv8b);
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS);
_mxcjdz = max(_mxcjdz, _7qz11m(_dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS));
}
#endif
}

#ifdef HANDHELD_LIGHT_ENABLED
if (emissive < 0.5) _yssmf1.rgb += _6p2kch(worldPos, _dwo81a, _yssmf1.rgb);
#endif

if (emissive < 0.5) {
float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
if (isEyeInWater == 1) {
vec3 _xw3oj9 = fogColor;
_yssmf1.rgb = mix(_xw3oj9, _yssmf1.rgb, _lr3hjh);
}
}

if (_hdgqqa) {
_yssmf1.a *= 0.65;
} else if (isIce > 0.5) {
_yssmf1.a = max(_yssmf1.a, 0.90);
}

if (isWater > 0.5) {

float _5rpbwt = fract(sunAngle);
float _93klxy = 1.0 - smoothstep(0.02, 0.08, _5rpbwt) * (1.0 - smoothstep(0.44, 0.52, _5rpbwt));
_yssmf1.a = mix(_yssmf1.a, 1.0, biome_swamp * _93klxy);
}
#if ICE_DEBUG_MODE == 1

if (isIce > 0.5)        _yssmf1 = vec4(1.0, 0.0, 1.0, 1.0);
else if (isWater > 0.5) _yssmf1 = vec4(1.0, 1.0, 0.0, 1.0);
else                    _yssmf1 = vec4(0.0, 1.0, 0.0, 1.0);
#endif

gl_FragData[0] = _yssmf1;

float _lj17av = (_499ujg > 0.0) ? _499ujg : isHeatSource;
gl_FragData[1] = vec4(postMask, emissive, skylight, _lj17av);
gl_FragData[2] = vec4(_mxcjdz, 1.0);
gl_FragData[3] = vec4(_mxcjdz, 1.0);

if (isWater > 0.5) {
vec3 _0uom9c = _xwb441(sunAngle, 1.0, biome_swamp, 0.0, 0.0, 0.0);

_0uom9c.b = _r66fbx;

_0uom9c.r = mix(_0uom9c.r, _56k3j0 * 2.0, biome_swamp);
gl_FragData[4] = vec4(_0uom9c, 0.3);
} else if (isIce > 0.5) {

vec4 _z7t6ex = texture(gtexture, texcoord);
gl_FragData[4] = vec4(_z7t6ex.rgb, 0.8);
} else if (_hdgqqa) {

vec4 _z7t6ex = texture(gtexture, texcoord) * glcolor;
vec3 _83s24y = _woie3o(blockId, _z7t6ex.rgb);
gl_FragData[4] = vec4(_83s24y, 0.6);
} else {
gl_FragData[4] = vec4(0.0);
}

if (isIce > 0.5 && isWater < 0.5) {
vec3 _37st8u = normalize(mat3(gbufferModelViewInverse) * normal);
vec3 _ytslnh = _37st8u * 0.5 + 0.5;
float _w8f3wy = dot(floor(255.0 * vec2(_d5ovut, skylight) + 0.5), vec2(1.0 / 65535.0, 256.0 / 65535.0));
float _z1csct = dot(floor(255.0 * vec2(0.5, 0.0) + 0.5), vec2(1.0 / 65535.0, 256.0 / 65535.0));
_xrdem2 = vec4(_w8f3wy, _z1csct, _ytslnh.x, _ytslnh.y);
}
#ifdef MATERIAL_REFLECTIONS_ENABLED
else if (_hdgqqa) {

vec3 _oi22up = normalize(mat3(gbufferModelViewInverse) * normal);
if (_u7zbom) _oi22up = -_oi22up;
vec3 _xvgd0e = _oi22up * 0.5 + 0.5;
float _qrchws = dot(max(_dwo81a, vec3(0.0)), vec3(0.299, 0.587, 0.114));
float _e8usq7 = smoothstep(0.08, 0.72, _qrchws);
float _cegnx2 = pow(1.0 - _e8usq7, 2.0);
float _ks8bl1 = _uaiic5(_oi22up.z);
_xrdem2 = vec4(_cegnx2, _ks8bl1, _xvgd0e.x, _xvgd0e.y);
}
#endif
gl_FragData[5] = _xrdem2;
}
