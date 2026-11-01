#include "/settings.glsl"

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

#include "/include/color_utils.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/sky_timeline.glsl"
#include "/include/water_color.glsl"
#include "/include/volumetric_clouds.glsl"

#ifdef END_SHADER
#if defined(END_EVENT_ENABLED)
#include "/include/end_event.glsl"
#endif
#ifdef END_SKY_ENABLED
#include "/include/end_sky.glsl"
#endif
#endif

vec4 _nwv54f(sampler2D _r4digw, vec2 uv) {
vec4 _rk79pn = max(texture(_r4digw, uv), vec4(0.0));

_rk79pn.rgb = _rk79pn.rgb * _rk79pn.rgb;
_rk79pn.rgb = _rk79pn.rgb * _rk79pn.rgb;
_rk79pn.rgb *= 32.0;
return _rk79pn;
}

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex8;
uniform sampler2D colortex5;
uniform sampler2D colortex7;
uniform sampler2D colortex14;
uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D colortex11;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D dhDepthTex;
uniform sampler2D vxDepthTexTrans;
uniform mat4 vxProjInv;
uniform float near;
uniform float far;
uniform float dhNearPlane;
uniform float dhFarPlane;
uniform float frameTimeCounter;
uniform int frameCounter;
uniform float sunAngle;
uniform int worldDay;
uniform int worldTime;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform int biome;
uniform int biome_category;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_snowy;
uniform float biome_arid;
uniform float biome_savanna;
uniform float biome_ocean;
uniform vec3 shadowLightPosition;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform int heldItemId;
uniform int heldItemId2;
uniform int heldBlockLightValue;
uniform int heldBlockLightValue2;
uniform float viewWidth;
uniform float viewHeight;
uniform int isEyeInWater;
uniform vec3 eyePosition;
uniform float rainStrength;
uniform float thunderStrength;
uniform ivec2 eyeBrightnessSmooth;

float _i5vilq() {
return clamp(BLOOM_DISTANCE_COMPENSATION * 4.0, 0.0, 1.0);
}

float _2wbfev(float _co5r8t) {
float _ym4kyq = 1.73;
float _rsw0xq = max(gbufferProjection[1][1] / _ym4kyq, 0.35);
return _co5r8t / _rsw0xq;
}

float _we0ipv(float _k5zkk5, float _hdc9nq) {
float _xa8ad0 = 1.0 - smoothstep(0.15, 0.75, _hdc9nq);
float _uyc73z = mix(0.35, 0.62, _xa8ad0);
_uyc73z += 0.08 * smoothstep(10.0, 28.0, _k5zkk5) * _xa8ad0;
_uyc73z += 0.06 * smoothstep(28.0, 84.0, _k5zkk5) * _xa8ad0;
_uyc73z -= 0.08 * smoothstep(180.0, 320.0, _k5zkk5);
return clamp(_uyc73z, 0.35, 0.68);
}

float _cu4uue(vec2 uv) {
vec2 _s4ja50 = 1.0 / vec2(textureSize(colortex1, 0));
float _hdc9nq = 0.0;

_hdc9nq += step(0.5, texture(colortex1, uv).g) * 0.24;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x, 0.0), vec2(0.0), vec2(1.0))).g) * 0.13;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x, 0.0), vec2(0.0), vec2(1.0))).g) * 0.13;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2(0.0, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.13;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2(0.0,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.13;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.06;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.06;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.06;
_hdc9nq += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.06;

return clamp(_hdc9nq, 0.0, 1.0);
}

float _2ae57a(vec2 uv) {
vec2 _s4ja50 = 1.0 / vec2(textureSize(colortex1, 0));
float _xoryyp = 0.0;

_xoryyp += step(0.5, texture(colortex1, uv).g) * 0.18;

_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x, 0.0), vec2(0.0), vec2(1.0))).g) * 0.12;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x, 0.0), vec2(0.0), vec2(1.0))).g) * 0.12;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(0.0, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.12;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(0.0,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.12;

_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;

_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(-_s4ja50.x * 2.0, 0.0), vec2(0.0), vec2(1.0))).g) * 0.05;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2( _s4ja50.x * 2.0, 0.0), vec2(0.0), vec2(1.0))).g) * 0.05;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(0.0, -_s4ja50.y * 2.0), vec2(0.0), vec2(1.0))).g) * 0.05;
_xoryyp += step(0.5, texture(colortex1, clamp(uv + vec2(0.0,  _s4ja50.y * 2.0), vec2(0.0), vec2(1.0))).g) * 0.05;

return clamp(_xoryyp, 0.0, 1.0);
}

in vec2 texcoord;

vec3 _asihvs();
vec3 _hbv38n();

#include "/include/depth_utils.glsl"

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

vec3 _5dzmdq(vec3 _yssmf1, float _1pxkd6, float _izh8vx, vec2 _rrv196, int _tybbyx) {

float _bfcizj = fract(sin(dot(_rrv196 + float(_tybbyx) * 0.1, vec2(12.9898, 78.233))) * 43758.5453);
_bfcizj = (_bfcizj - 0.5) * _izh8vx / _1pxkd6;

_yssmf1 += _bfcizj;
_yssmf1 = floor(_yssmf1 * _1pxkd6 + 0.5) / _1pxkd6;

return clamp(_yssmf1, 0.0, 1.0);
}

vec3 _q9oroj(int _kiyxjg) {
if (_kiyxjg == 10021 || _kiyxjg == 10043) return vec3(0.35, 0.82, 1.0);
if (_kiyxjg == 10022 || _kiyxjg == 10039) return vec3(1.0, 0.42, 0.15);
if (_kiyxjg == 10024 || _kiyxjg == 10032 || _kiyxjg == 10044) return vec3(0.70, 0.92, 1.0);
if (_kiyxjg == 10026 || _kiyxjg == 10038 || _kiyxjg == 10058) return vec3(1.0, 0.25, 0.15);
if (_kiyxjg == 10052) return vec3(0.45, 1.00, 0.70);
if (_kiyxjg == 10053) return vec3(0.95, 0.72, 1.00);
if (_kiyxjg == 10027 || _kiyxjg == 10051) return vec3(1.0, 0.80, 0.45);
return vec3(1.0, 0.78, 0.50);
}

float _qn45m7(in float x) {
return clamp(x, 0.0, 1.0);
}

vec3 _x7i4gn(vec3 _yssmf1, float _r6hyq6) {
float _qidvgw = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _5pcsb1 = vec3(_qidvgw);
vec3 _twsve4 = _5pcsb1 + (_yssmf1 - _5pcsb1) * max(_r6hyq6, 0.0);
_twsve4 = max(_twsve4, vec3(0.0));

float _fujn7h = dot(_twsve4, vec3(0.299, 0.587, 0.114));
if (_fujn7h > 0.0001 && _qidvgw > 0.0001) {
_twsve4 *= _qidvgw / _fujn7h;
}

return max(_twsve4, vec3(0.0));
}

#include "/include/color_grading.glsl"

#include "/include/outline.glsl"

#ifdef HANDHELD_LIGHT_ENABLED
#include "/include/held_light_post.glsl"
#endif

vec3 _a3jxj7(vec2 uv, float _swfcra) {
vec4 _8wjl9m = vec4(uv * 2.0 - 1.0, _swfcra * 2.0 - 1.0, 1.0);
vec4 viewPos = gbufferProjectionInverse * _8wjl9m;
viewPos /= viewPos.w;
vec4 worldPos = gbufferModelViewInverse * viewPos;
return worldPos.xyz + cameraPosition;
}

vec3 _b8ua9d(vec2 uv, float _swfcra) {

float _co5r8t = _wf8ve2(_swfcra);

vec4 _8wjl9m = vec4(uv * 2.0 - 1.0, -1.0, 1.0);
vec4 _0bcjo7 = gbufferProjectionInverse * _8wjl9m;
_0bcjo7 /= _0bcjo7.w;
vec3 viewDir = normalize(_0bcjo7.xyz);

vec3 viewPos = viewDir * (_co5r8t / max(abs(viewDir.z), 0.001));

vec4 worldPos = gbufferModelViewInverse * vec4(viewPos, 1.0);
return worldPos.xyz + cameraPosition;
}

#include "/include/noise.glsl"
#define BIOME_COLOR_SMOOTHING_HAS_SSBO
#include "/include/distance_fog.glsl"

void main() {
vec2 _s4ja50 = 1.0 / vec2(textureSize(colortex0, 0));
vec2 _xcbaum = texcoord;

vec3 _yssmf1 = texture(colortex0, _xcbaum).rgb;
float _rnz76l = texture(colortex0, _xcbaum).a;
float _xszwck = 1.0 - _rnz76l;
vec4 _470dd1 = texture(colortex1, texcoord);
float outlineMask = (_470dd1.a > 0.999) ? 1.0 : _470dd1.r;

#ifdef UNDERWATER_FOG_ENABLED
if (isEyeInWater == 1) {

float _2u5cp4 = texelFetch(depthtex0, ivec2(gl_FragCoord.xy), 0).x;
float _zhzjbu = texelFetch(colortex1, ivec2(gl_FragCoord.xy), 0).a;
bool _ktjv8b = (_zhzjbu > 0.999);
bool _g231y6 = !_7bqo1l(_2u5cp4) && !_ktjv8b;
bool _qu9k0q = false;

if (_qu9k0q || _g231y6) {
vec2 px = 1.0 / vec2(viewWidth, viewHeight);
float _euywlx = 2.5;

vec3 _m13gk4 = _yssmf1 * 0.25;
float _4s5hla = 0.25;

vec2 offsets[8] = vec2[8](
vec2( px.x, 0.0) * _euywlx,   vec2(-px.x, 0.0) * _euywlx,
vec2(0.0,  px.y) * _euywlx,   vec2(0.0, -px.y) * _euywlx,
vec2( px.x,  px.y) * _euywlx * 0.7, vec2(-px.x,  px.y) * _euywlx * 0.7,
vec2( px.x, -px.y) * _euywlx * 0.7, vec2(-px.x, -px.y) * _euywlx * 0.7
);
float weights[8] = float[8](0.125, 0.125, 0.125, 0.125, 0.0625, 0.0625, 0.0625, 0.0625);

for (int i = 0; i < 8; i++) {
vec2 _rbbd13 = _xcbaum + offsets[i];
float _xhj9wv = texture(depthtex0, _rbbd13).r;
float _89exay = texture(depthtex1, _rbbd13).r;
bool _uh4n4w = (_xhj9wv < _89exay - 0.00001);
bool _903xv4 = !_7bqo1l(_xhj9wv);
if (_uh4n4w || _903xv4) {
_m13gk4 += texture(colortex0, _rbbd13).rgb * weights[i];
_4s5hla += weights[i];
}
}

_yssmf1 = _m13gk4 / _4s5hla;
}
}
#endif

float _o7giip = 0.0;

vec4 _ehp903 = texture(colortex4, texcoord);

#ifdef GLASS_FILTER_ENABLED
{
ivec2 _s6loqa = ivec2(gl_FragCoord.xy);
float _mdbkch = texelFetch(depthtex0, _s6loqa, 0).x;
float _d2dajb = texelFetch(depthtex1, _s6loqa, 0).x;
bool _faau47 = (_mdbkch < _d2dajb - 0.00001);

bool _fa8hg2 = (_ehp903.a > 0.45);

float _2xw8ee = clamp(_ehp903.a * GLASS_FILTER_STRENGTH, 0.0, 0.75);
float _fm7rlf = clamp(texture(colortex7, texcoord).a, 0.0, 1.0);
bool _uzq5ch = (texture(colortex1, texcoord).a > 0.01 && texture(colortex1, texcoord).a < 0.99);
_2xw8ee *= (_faau47 && _fa8hg2 && !_uzq5ch) ? 1.0 : 0.0;

if (_2xw8ee > 0.0001) {
vec3 tint = max(_ehp903.rgb, vec3(0.0));

float _t17lmr = dot(tint, vec3(0.299, 0.587, 0.114));
float _pg1f5w = clamp(GLASS_FILTER_SATURATION, 0.5, 1.35);
tint = clamp(mix(vec3(_t17lmr), tint, _pg1f5w), vec3(0.0), vec3(1.5));

float _ph8q60 = max(dot(tint, vec3(0.299, 0.587, 0.114)), 0.001);
vec3 _d314r9 = clamp(tint / _ph8q60, vec3(0.0), vec3(3.0));

float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _epi87u = _yssmf1 * _d314r9;
float _1f6jtq = max(dot(max(_epi87u, vec3(0.0)), vec3(0.299, 0.587, 0.114)), 0.001);
_epi87u *= max(_zdxp7g, 0.001) / _1f6jtq;

float _nuzjng = clamp(_2xw8ee * GLASS_FILTER_ENFORCEMENT * _fm7rlf * 0.5, 0.0, 0.25);
_yssmf1 = mix(_yssmf1, _epi87u, _nuzjng);
}
}
#endif

bool _w5hu9s = false;

#ifdef FAKE_TERRAIN_ENABLED
{

if (!_9cwhip(biome) && !_h6zv90()) {
float _1yw2j2 = texture(depthtex0, texcoord).x;
float _rckf4j = texture(dhDepthTex, texcoord).x;

float _axed1r = texture(dhDepthTex, vec2(0.5, 0.05)).x;
float _sihcm7 = texture(dhDepthTex, vec2(0.15, 0.05)).x;
float _wb1bp8 = texture(dhDepthTex, vec2(0.85, 0.05)).x;
bool _p9qeaj = _yfr6tv(_rckf4j) || _yfr6tv(_axed1r) || _yfr6tv(_sihcm7) || _yfr6tv(_wb1bp8) || (dhFarPlane > far * 1.5);
if (!_p9qeaj) {

} else {

bool _2v9fuq = _yfr6tv(_rckf4j);
bool _yjolhc = (_1yw2j2 >= 0.9999 && !_2v9fuq);

bool _vn2pjy = false;
if (!_yjolhc && _1yw2j2 >= 0.9999 && _2v9fuq) {
vec3 _xlaso6 = _b8ua9d(texcoord, _rckf4j);
_vn2pjy = (_xlaso6.y < float(FAKE_TERRAIN_Y));
}

if (_yjolhc || _vn2pjy) {

vec4 _kdu0jv = vec4(texcoord * 2.0 - 1.0, 1.0, 1.0);
vec4 _d5w6zo = gbufferProjectionInverse * _kdu0jv;
_d5w6zo /= _d5w6zo.w;
vec3 _v601z8 = normalize(mat3(gbufferModelViewInverse) * _d5w6zo.xyz);

float _2at7s9 = float(FAKE_TERRAIN_Y);
float _mymqma = cameraPosition.y;

if (_mymqma > _2at7s9) {

float t = -1.0;
if (_v601z8.y < -0.001) {

t = (_2at7s9 - _mymqma) / _v601z8.y;
}

if (t > 0.0 && t < FAKE_TERRAIN_DISTANCE) {
vec3 _r0gipz = cameraPosition + _v601z8 * t;
float _lzgagx = length(_r0gipz - cameraPosition);

if (_lzgagx > FAKE_TERRAIN_START) {
vec3 _x2lvmw = vec3(WATER_COLOR_R, WATER_COLOR_G, WATER_COLOR_B);

vec3 _hj0fjq = _gkt4lb(_x2lvmw, sunAngle);

vec3 viewDir = -_v601z8;
vec3 _khzelv = vec3(0.0, 1.0, 0.0);
vec3 _bnien0 = normalize(mat3(gbufferModelView) * viewDir);
vec3 _4l9672 = normalize(mat3(gbufferModelView) * _khzelv);
_hj0fjq += _ii8hrk(_bnien0, normalize(shadowLightPosition), _4l9672, sunAngle);

vec3 _alj00v = reflect(normalize(-_bnien0), _4l9672);
vec3 _n59wg6 = reflect(-viewDir, _khzelv);

TimeWeightsSimple ilvTS = getTimeWeightsSimple(sunAngle);
float _2or95l = max(dot(_alj00v, gbufferModelView[1].xyz), 0.0);
float _9t3e1l = 1.0 - _2or95l; _9t3e1l *= _9t3e1l; _9t3e1l *= _9t3e1l; _9t3e1l = 1.0 - _9t3e1l;
vec3 _f2djza = _9ruyvd(sunAngle, _9t3e1l);
float _4w4mfw = dot(_alj00v, normalize(shadowLightPosition)) * 0.5 + 0.5;
_4w4mfw = 1.0 - (1.0 - _4w4mfw) * (1.0 - _4w4mfw);
_4w4mfw *= (1.0 - _2or95l) * (1.0 - (1.0 - ilvTS.twilight) * (1.0 - ilvTS.twilight));
vec3 _21h1x9 = (sunAngle > 0.25 && sunAngle < 0.75)
? vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B)
: vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B);
_f2djza = mix(_f2djza, _21h1x9, _4w4mfw);
_f2djza = min(_f2djza, 1.0);

_f2djza *= 1.5;

#ifdef CLOUDS_3D_ENABLED
if (_n59wg6.y > 0.001) {
float _13rsme = texelFetch(colortex1, ivec2(gl_FragCoord.xy), 0).b;
float _0td29d = step(12.0 / 15.0, _13rsme);
float _ci50nx = (float(worldDay) * 24000.0 + float(worldTime)) / 20.0;
vec3 _xtjpzc = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 _9p72uj = _n59wg6;
_9p72uj.y = max(_9p72uj.y, 0.12);
_9p72uj = normalize(_9p72uj);
vec3 _ecnm9v = vec3(cameraPosition.x, 63.0, cameraPosition.z);
vec4 _23av16 = _8qfvgd(_9p72uj, _ci50nx, _ecnm9v, sunAngle, _xtjpzc, gl_FragCoord.xy, frameCounter);
_23av16.a *= _0td29d * 0.4;
if (_23av16.a > 0.001) {
_f2djza = mix(_f2djza, _23av16.rgb, _23av16.a);
}
}
#endif

float _75gmpr = abs(dot(_bnien0, _4l9672));
float _ewltmj = 1.0 - _75gmpr;
_ewltmj *= _ewltmj;
_ewltmj *= _ewltmj;
float _oun1yh = mix(0.3, 1.0, _ewltmj) * WATER_REFLECTION_FADE;
_oun1yh = clamp(_oun1yh, 0.0, 1.0);
float _xpakd9 = WATER_REFLECTION_AMOUNT * _oun1yh * WATER_SKY_REFLECTION;
_hj0fjq = mix(_hj0fjq, _f2djza, _xpakd9);

float _36zwff = smoothstep(FAKE_TERRAIN_DISTANCE * 0.6, FAKE_TERRAIN_DISTANCE * 0.95, _lzgagx);

float _8srcc5 = smoothstep(FAKE_TERRAIN_START, FAKE_TERRAIN_START + 32.0, _lzgagx);

float _q6893q = smoothstep(0.0, 0.06, -_v601z8.y);

_hj0fjq = mix(_hj0fjq, _yssmf1.rgb, _36zwff);
float _drjm4t = 1.0 - clamp(_xszwck, 0.0, 1.0);
float _k6dni3 = _8srcc5 * _drjm4t * _q6893q;
_yssmf1.rgb = mix(_yssmf1.rgb, _hj0fjq, _k6dni3);
if (_k6dni3 > 0.001) {
_w5hu9s = true;
}
}
}
} else if (_v601z8.y > 0.001 && _mymqma < _2at7s9) {

float t = (_2at7s9 - _mymqma) / _v601z8.y;

if (t > 0.0 && t < FAKE_TERRAIN_DISTANCE) {
vec3 _r0gipz = cameraPosition + _v601z8 * t;
float _lzgagx = length(_r0gipz - cameraPosition);

if (_lzgagx > FAKE_TERRAIN_START) {
vec3 _x2lvmw = vec3(WATER_COLOR_R, WATER_COLOR_G, WATER_COLOR_B) * 0.2;
float _8srcc5 = smoothstep(FAKE_TERRAIN_START, FAKE_TERRAIN_START + 200.0, _lzgagx);
float _drjm4t = 1.0 - clamp(_xszwck, 0.0, 1.0);
float _k6dni3 = _8srcc5 * _drjm4t;
_yssmf1.rgb = mix(_yssmf1.rgb, _x2lvmw, _k6dni3);
if (_k6dni3 > 0.001) {
_w5hu9s = true;
}
}
}
}
}
}
}
}
#endif

bool _p48by5 = false;
bool _u95twn = false;
vec3 _g3qr01 = cameraPosition;

vec4 _alcc4c = texture(colortex1, texcoord);
float _2z5x7k = _alcc4c.g;
bool _7dnqj0 = _2z5x7k > 0.001;
bool _ux4ees = (_alcc4c.a > 0.3 && _alcc4c.a < 0.7);
bool _rv9f3n = false;

vec3 _pb67e8 = _yssmf1;

ivec2 _lgrsgs = ivec2(gl_FragCoord.xy);
float _2ql2nv = texelFetch(depthtex0, _lgrsgs, 0).x;
float _4f6yyb = texelFetch(depthtex1, _lgrsgs, 0).x;
float _cskgny = texelFetch(dhDepthTex, _lgrsgs, 0).x;
_rv9f3n = (_alcc4c.a > 0.999 && !_7bqo1l(_2ql2nv));
bool _ozweo0 = (_cskgny < 0.9999);
bool _7zeca0 = _yfr6tv(_cskgny);

bool _adujp1 = (_2ql2nv < _4f6yyb - 0.00001);
bool _fdtg96 = (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);
bool _8t1k61 = _adujp1 && _ehp903.a > 0.01 && _ehp903.a <= 0.45;

bool _vbdnok = (isEyeInWater == 1) && (_ehp903.a > 0.20 && _ehp903.a < 0.40);

bool _d293zd = _adujp1;
bool _n5tvnf = _d293zd && _ehp903.a > 0.45;

float _1r3mt9;
vec3 _bu16tm;
bool _yjolhc = false;
bool _snwfpe = false;

{

float _xhwidi = (isEyeInWater == 1) ? _4f6yyb : _2ql2nv;

bool _w4h543 = _7bqo1l(_xhwidi) || _rv9f3n;

float vxDepthScene = texture(vxDepthTexTrans, texcoord).r;
bool _pgh3p7 = _2fqi4q(vxProjInv) && _rv9f3n && _7bqo1l(vxDepthScene);

float _13kg8r = _w4h543 ? _zdldl1(_xhwidi) : 1e10;
float _gy8ett = _7zeca0 ? _wf8ve2(_cskgny) : 1e10;
if (_w4h543 && _13kg8r < _gy8ett) {
_1r3mt9 = _xhwidi;
if (_pgh3p7 && !_7bqo1l(_xhwidi)) {

vec4 vxClip = vxProjInv * vec4(texcoord * 2.0 - 1.0, vxDepthScene * 2.0 - 1.0, 1.0);
vec3 vxView = vxClip.xyz / vxClip.w;
_bu16tm = (gbufferModelViewInverse * vec4(vxView, 1.0)).xyz + cameraPosition;
} else {
_bu16tm = _a3jxj7(texcoord, _1r3mt9);
}
_snwfpe = false;
} else if (_7zeca0) {
_1r3mt9 = _cskgny;
_bu16tm = _b8ua9d(texcoord, _1r3mt9);
_snwfpe = true;
} else {
_yjolhc = true;
_1r3mt9 = 1.0;
vec4 _8wjl9m = vec4(texcoord * 2.0 - 1.0, 0.0, 1.0);
vec4 viewPos = gbufferProjectionInverse * _8wjl9m;
vec3 viewDir = normalize(viewPos.xyz);
vec4 _st4awd = gbufferModelViewInverse * vec4(viewDir, 0.0);
_bu16tm = cameraPosition + _st4awd.xyz * far;
_snwfpe = false;
}
}

_p48by5 = _yjolhc;
_u95twn = _snwfpe;
_g3qr01 = _bu16tm;

#ifdef CG_POSTERIZE_ENABLED
_yssmf1 = _5dzmdq(_yssmf1, float(CG_POSTERIZE_LEVELS), CG_POSTERIZE_DITHER, gl_FragCoord.xy, frameCounter);
#endif

float _vkbwd3 = 1.0;

#ifdef WEATHER_FOG_ENABLED
_vkbwd3 *= (1.0 - max(texture(colortex11, texcoord), vec4(0.0)).a);
#endif
#ifdef HAZE_FOG_ACTIVE
{
float _bjqjnw = _yjolhc ? 0.0 : max(texture(colortex10, texcoord), vec4(0.0)).a;
_vkbwd3 *= (1.0 - _bjqjnw);
}
#endif
#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED)
_vkbwd3 *= (1.0 - max(texture(colortex9, texcoord), vec4(0.0)).a);
#endif

{
vec4 _mhj22e = texture(colortex14, texcoord);
float _4pmuzl = (_mhj22e.a < 0.5) ? _mhj22e.r : 0.0;
_o7giip = max(1.0 - _vkbwd3, _4pmuzl);
}

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome) && _yjolhc) _o7giip = 1.0;
#endif

#if 0
if (_adujp1 && !_fdtg96) {
if (_kd5trg) {
_l584tr = vxDepthFog;
vec4 vxClip = vxProjInv * vec4(texcoord * 2.0 - 1.0, vxDepthFog * 2.0 - 1.0, 1.0);
vec3 vxView = vxClip.xyz / vxClip.w;
_7qpuxx = (gbufferModelViewInverse * vec4(vxView, 1.0)).xyz + cameraPosition;
_uveofz = false;
_hounzx = false;
} else if (_4f6yyb < 0.9999) {
float _r5ho6z = _zdldl1(_4f6yyb);
float _97i2f3 = _7zeca0 ? _wf8ve2(_cskgny) : 1e10;
if (_r5ho6z < _97i2f3) {
_l584tr = _4f6yyb;
_7qpuxx = _a3jxj7(texcoord, _l584tr);
_uveofz = false;
_hounzx = false;
} else {
_l584tr = _cskgny;
_7qpuxx = _b8ua9d(texcoord, _l584tr);
_uveofz = true;
_hounzx = false;
}
} else if (_7zeca0) {
_l584tr = _cskgny;
_7qpuxx = _b8ua9d(texcoord, _l584tr);
_uveofz = true;
_hounzx = false;
} else {

_l584tr = _2ql2nv;
_7qpuxx = _a3jxj7(texcoord, _l584tr);
_uveofz = false;
_hounzx = false;
}
}

vec4 _rk79pn = (isEyeInWater == 2) ? vec4(0.0, 0.0, 0.0, 1.0) : _ycfkak(texcoord, _l584tr, _7qpuxx, _hounzx, _uveofz);

#ifdef OVERWORLD_FOG_ENABLED
if (isEyeInWater == 1 && !_9cwhip(biome) && !_h6zv90()) {
_rk79pn = vec4(0.0, 0.0, 0.0, 1.0);
}

if (isEyeInWater != 1 && !_9cwhip(biome) && !_h6zv90()) {

bool _yd4mdp = !_adujp1 && _bu16tm.y < float(SEA_LEVEL_OFFSET);
if (_8t1k61 || _yd4mdp) {
float _38mxz3 = smoothstep(float(SEA_LEVEL_OFFSET) - 4.0, float(SEA_LEVEL_OFFSET) + 1.0, _bu16tm.y);
if (_8t1k61) _38mxz3 = 0.0;
_rk79pn.rgb *= _38mxz3;
_rk79pn.a = mix(1.0, _rk79pn.a, _38mxz3);
}
}
#endif
_96c5w8 = _rk79pn.rgb;
_waurma = clamp(_rk79pn.a, 0.0, 1.0);
_9o6ms5 = clamp(1.0 - _waurma, 0.0, 1.0);

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome) && _yjolhc) {
vec3 _6xt7r3 = _ktauxr(biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B)) * NETHER_BRIGHTNESS;
_yssmf1 = _6xt7r3;
_9o6ms5 = 1.0;
}
#endif

_9o6ms5 *= _rnz76l;
_96c5w8 *= _rnz76l;
_waurma = 1.0 - _9o6ms5;

if (_9o6ms5 > 0.001) {

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome) && _7dnqj0) {
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
vec3 _4bbmv6 = _yssmf1 * (1.0 - _9o6ms5 * 0.25) + _96c5w8;
vec3 _ll4wqp = _yssmf1 * _uohh66 + _96c5w8;

#ifdef END_EVENT_ENABLED
float _imqx64 = getEndEvent(frameTimeCounter).fogDarkness;
float _nujy9w = _imqx64;
#else
float _nujy9w = 0.0;
#endif

_yssmf1 = mix(_4bbmv6, _ll4wqp, _nujy9w);
}
#else

_yssmf1 = _yssmf1 * _waurma + _96c5w8;
#endif
_o7giip = max(_o7giip, _9o6ms5);
_vkbwd3 *= _waurma;
}
}
#endif

#if 0

#ifdef HAZE_FOG_ACTIVE
{
vec4 _wmzd8j = max(texture(colortex10, texcoord), vec4(0.0));
if (_p48by5) _wmzd8j = vec4(0.0);
if (_wmzd8j.a > 0.001) {
_yssmf1 = _wmzd8j.rgb + _yssmf1 * (1.0 - _wmzd8j.a);
}
}
#endif

#ifdef WEATHER_FOG_ENABLED
{
vec4 _s1fxzx = max(texture(colortex11, texcoord), vec4(0.0));
if (_s1fxzx.a > 0.001) {
_yssmf1 = _s1fxzx.rgb + _yssmf1 * (1.0 - _s1fxzx.a);
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

if (!_p48by5) {
#ifdef WEATHER_FOG_ENABLED
float _jj2kyj = max(texture(colortex11, texcoord), vec4(0.0)).a;
_hl0eel *= _jj2kyj * 0.5;
#else
_hl0eel = 0.0;
#endif
}
_hl0eel *= smoothstep(0.0, 0.15, max(rainStrength, biome_swamp));

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
if (!_p48by5) _krasn9 = 0.0;

}
}
}
#endif
#endif

#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
if (_h6zv90() && !_p48by5) {
float _adkpym = getEndEvent(frameTimeCounter).fogDarkness;
if (_adkpym > 0.001) {
vec3 _epe7vd = _yssmf1;
float _xwbtes = length(_g3qr01 - cameraPosition);
float _46spvj = 20.0;
float _c2izcd = clamp(_xwbtes / _46spvj, 0.0, 1.0);
float _cv7m64 = 1.0 - exp(-_c2izcd * _c2izcd * 8.0);
_cv7m64 *= _adkpym;
_yssmf1 = mix(_yssmf1, vec3(0.0), _cv7m64);
#ifdef HANDHELD_LIGHT_ENABLED
_yssmf1 += _cq86ij(_g3qr01, _epe7vd, _yssmf1) * _adkpym;
#endif
_o7giip = max(_o7giip, _cv7m64);
}
}
#endif

#if defined(END_SHADER) && defined(END_SKY_ENABLED) && defined(END_VOID_CLOUDS_ENABLED)
if (_h6zv90() && !_p48by5) {
float _joxc1m = length(_g3qr01 - cameraPosition);
vec3 _sn8ynv = normalize(_g3qr01 - cameraPosition);
#ifdef END_EVENT_ENABLED
EndEvent vcEvent = getEndEvent(frameTimeCounter);
vec4 _i8rt8f = _m2f00k(_sn8ynv, vcEvent.cloudTime, frameTimeCounter, cameraPosition, _joxc1m, vcEvent.suctionWarp);
#else
vec4 _i8rt8f = _m2f00k(_sn8ynv, frameTimeCounter, frameTimeCounter, cameraPosition, _joxc1m, 0.0);
#endif
if (_i8rt8f.a > 0.001) {
vec3 _f3lxq9 = _i8rt8f.rgb / _i8rt8f.a;
#ifdef END_EVENT_ENABLED
float _iyvif0 = _i8rt8f.a * vcEvent.effectsFade;
#else
float _iyvif0 = _i8rt8f.a;
#endif
_yssmf1 = mix(_yssmf1, _f3lxq9, _iyvif0);
}
}
#endif

#if defined(END_SHADER) && defined(END_SKY_ENABLED) && defined(END_ENDER_PARTICLES_ENABLED)
if (_h6zv90()) {
float _km6kph = _p48by5 ? END_ENDER_PARTICLE_RANGE : length(_g3qr01 - cameraPosition);
vec3 _nlbdar = _p48by5 ? normalize(mat3(gbufferModelViewInverse) * (gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, 1.0, 1.0)).xyz) : normalize(_g3qr01 - cameraPosition);
vec3 _oj11ka = _djokld(_nlbdar, frameTimeCounter, cameraPosition, _km6kph);
#ifdef END_EVENT_ENABLED
_oj11ka *= getEndEvent(frameTimeCounter).effectsFade;
#endif
_yssmf1 += _oj11ka;
}
#endif

#if defined(END_SHADER) && defined(END_SKY_ENABLED) && defined(END_RINGS_ENABLED)
if (_h6zv90()) {
vec3 _5nfoyu = normalize(mat3(gbufferModelViewInverse) * (gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, 1.0, 1.0)).xyz);
float _itzp44 = _p48by5 ? 10000.0 : length(_g3qr01 - cameraPosition);
vec3 _2fcmap = _gj1nsb(_5nfoyu, frameTimeCounter, cameraPosition, _itzp44);
#ifdef END_EVENT_ENABLED
_2fcmap *= getEndEvent(frameTimeCounter).effectsFade;
#endif
_yssmf1 += _2fcmap;
}
#endif

#if defined(END_SHADER) && defined(END_EVENT_ENABLED) && defined(END_EVENT_EYE_ENABLED) && defined(END_EVENT_SPOTLIGHT_ENABLED)
{
EndEvent ebEvent = getEndEvent(frameTimeCounter);
if (_h6zv90() && ebEvent.eyeOpen > 0.01) {

ivec2 _ez0jck = ivec2(gl_FragCoord.xy);
float _7z6l5n = texelFetch(depthtex0, _ez0jck, 0).x;
float _p6in8a = texelFetch(dhDepthTex, _ez0jck, 0).x;
bool _jg1h5b = _yfr6tv(_p6in8a);

vec4 _gkydur = vec4(texcoord * 2.0 - 1.0, 0.5, 1.0);
vec4 _tsd50p = gbufferProjectionInverse * _gkydur;
vec3 _jtj4fm = normalize(_tsd50p.xyz);
vec4 _9w33av = gbufferModelViewInverse * vec4(_jtj4fm, 0.0);
vec3 _emyjkl = normalize(_9w33av.xyz);

float _eirq7v = 1000.0;
bool _rzvi05 = (_7z6l5n >= 0.9999 && !_jg1h5b);
if (!_rzvi05) {
vec3 _826iqi = vec3(0.0);
if (_7z6l5n < 0.9999) {
_826iqi = _a3jxj7(texcoord, _7z6l5n);
} else if (_jg1h5b) {
_826iqi = _b8ua9d(texcoord, _p6in8a);
} else {
_rzvi05 = true;
}
if (!_rzvi05) _eirq7v = length(_826iqi - cameraPosition);
}

vec3 _qz3rwh = vec3(eyePosition.x, 0.0, eyePosition.z);
float _7e7hxo = END_EVENT_SPOTLIGHT_RADIUS;
float _2wgy7o = eyePosition.y - 1.6;
float _aq0xt8 = _2wgy7o + 300.0;

vec2 _ldnfzz = cameraPosition.xz - _qz3rwh.xz;
vec2 _3mjmdd = _emyjkl.xz;
float _vb3y1t = dot(_3mjmdd, _3mjmdd);
float _0hsk5d = 2.0 * dot(_ldnfzz, _3mjmdd);
float _gqo4gt = dot(_ldnfzz, _ldnfzz) - _7e7hxo * _7e7hxo;
float _j48c7z = _0hsk5d * _0hsk5d - 4.0 * _vb3y1t * _gqo4gt;

float _x46xhj = 0.0;
if (_j48c7z > 0.0 && _vb3y1t > 0.0001) {
float _q3ry0r = sqrt(_j48c7z);
float _jsd235 = (-_0hsk5d - _q3ry0r) / (2.0 * _vb3y1t);
float _pvzx83 = (-_0hsk5d + _q3ry0r) / (2.0 * _vb3y1t);

float _zd1qbr = _rzvi05 ? 1000.0 : _eirq7v;
_jsd235 = max(_jsd235, 0.0);
_pvzx83 = min(_pvzx83, _zd1qbr);

if (_pvzx83 > _jsd235) {

if (abs(_emyjkl.y) > 0.0001) {
float _mboklv = (_2wgy7o - cameraPosition.y) / _emyjkl.y;
float _w34ntf = (_aq0xt8 - cameraPosition.y) / _emyjkl.y;
if (_mboklv > _w34ntf) { float _6t7lzo = _mboklv; _mboklv = _w34ntf; _w34ntf = _6t7lzo; }
_jsd235 = max(_jsd235, _mboklv);
_pvzx83 = min(_pvzx83, _w34ntf);
} else {

if (cameraPosition.y < _2wgy7o || cameraPosition.y > _aq0xt8) {
_pvzx83 = _jsd235;
}
}

if (_pvzx83 > _jsd235) {

float _rw9p48 = _pvzx83 - _jsd235;

_x46xhj = _rw9p48 / (_7e7hxo * 2.0);

vec2 _hso3jj = cameraPosition.xz + _3mjmdd * ((_jsd235 + _pvzx83) * 0.5) - _qz3rwh.xz;
float _4jppcz = length(_hso3jj);
float _jjxfss = 1.0 - smoothstep(_7e7hxo * 0.3, _7e7hxo, _4jppcz);
_x46xhj *= _jjxfss;

float _xkavvo = cameraPosition.y + _emyjkl.y * ((_jsd235 + _pvzx83) * 0.5);
float _zgy6fk = 1.0 - smoothstep(_aq0xt8 - 60.0, _aq0xt8, _xkavvo);
_x46xhj *= _zgy6fk;
}
}
}

float _i3k8wn = mix(1.0, 0.35, ebEvent.eyeOpen);
float _37err3 = 0.0;
if (!_rzvi05) {

vec3 _5n6v53;
if (_7z6l5n < 0.9999) {
_5n6v53 = _a3jxj7(texcoord, _7z6l5n);
} else if (_jg1h5b) {
_5n6v53 = _b8ua9d(texcoord, _p6in8a);
} else {
_5n6v53 = cameraPosition;
}

float _u7zx2v = length(_5n6v53.xz - eyePosition.xz);
float _3vbz7p = 1.0 - smoothstep(END_EVENT_SPOTLIGHT_RADIUS * 0.3, END_EVENT_SPOTLIGHT_RADIUS * 1.2, _u7zx2v);

float _eh2il4 = length(_5n6v53 - eyePosition);
float _7bscul = 1.0 - smoothstep(1.0, 3.0, _eh2il4);
_37err3 = max(_3vbz7p, _7bscul);
}
float _loxmqc = mix(_i3k8wn, 1.0, _37err3);
_yssmf1 *= _loxmqc;

vec3 _vuh9y2 = vec3(
END_EVENT_EYE_IRIS_R * 0.4 + 0.6,
END_EVENT_EYE_IRIS_G * 0.2 + 0.5,
END_EVENT_EYE_IRIS_B * 0.3 + 0.7
);

_yssmf1 += _vuh9y2 * _x46xhj * ebEvent.eyeOpen * END_EVENT_SPOTLIGHT_INTENSITY * 0.4;

float _h2pgsq = ebEvent.eyeOpen;
float _gr7zu5 = 1.0 - clamp(_x46xhj * 3.0 + _37err3, 0.0, 1.0);

float _ph31ph = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1 = mix(_yssmf1, vec3(_ph31ph), _gr7zu5 * _h2pgsq * 0.65);

vec3 _olrmgz = vec3(0.35, 0.15, 0.65);
_yssmf1 = mix(_yssmf1, _yssmf1 * _olrmgz * 2.5, _gr7zu5 * _h2pgsq * 0.3);

float _d6h3rm = length(texcoord - vec2(0.5));
float _hc251l = smoothstep(0.25, 0.8, _d6h3rm);
_yssmf1 *= 1.0 - _hc251l * _h2pgsq * 0.8;
}
}
#endif

#if OUTLINES != 0 && !defined(NEON_GAME_MODE)
ivec2 _490yg3 = ivec2(gl_FragCoord.xy);

float _qg5wbo = 1.0 - _vkbwd3;
float _20vn9j = 1.0 - smoothstep(0.0, 0.35, max(_o7giip, _qg5wbo));

float _l2xodk = texture(colortex1, texcoord).b;
float _xtvwvf = 1.0 - smoothstep(1.0 / 15.0, 3.0 / 15.0, _l2xodk);
float _i4hvp2 = texture(depthtex0, texcoord).r;
float _gzwjxj = _7bqo1l(_i4hvp2) ? _zdldl1(_i4hvp2) : 0.0;
float _x0c5o2 = 1.0 - smoothstep(10.0, 40.0, _gzwjxj);
float _3v8tjf = mix(_20vn9j, _x0c5o2, _xtvwvf) * (1.0 - rainStrength);

float _bm56by = _8t1k61 ? 0.0 : 1.0;
float _y38h77 = 1.0;
#if defined(CLOUDS_3D_ENABLED) || defined(CLOUDS_VANILLA_ENABLED)

float _7lp9mq = clamp(_xszwck, 0.0, 1.0);
_y38h77 = 1.0 - smoothstep(0.02, 0.20, _7lp9mq);
#endif
bool _b0gq46 = _u95twn && !_p48by5;
vec3 _z4jiwv = _yssmf1;
float _loygth = _2mskwk(_z4jiwv, _b0gq46);
float _mh8qe1 = 1.0;
#ifndef VOXY_LOD_OUTLINES
if (_rv9f3n) _mh8qe1 = 0.0;
#endif
float _znbx06 = _xvf2zs(_490yg3) * outlineMask * _3v8tjf * _bm56by * _y38h77 * _loygth * _mh8qe1;
_yssmf1 *= 1.0 + _znbx06 * OUTLINE_BRIGHTNESS;
float _sag6q7 = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _0ngd0q = mix(vec3(_sag6q7), _yssmf1, max(OUTLINE_SATURATION, 0.0));
_yssmf1 = mix(_yssmf1, max(_0ngd0q, vec3(0.0)), clamp(_znbx06, 0.0, 1.0));
#endif

#ifdef BLOOM_ENABLED
vec2 _p1y7a7 = 1.0 / vec2(textureSize(colortex2, 0));
vec2 _irylbx = clamp(texcoord * BLOOM_RENDER_SCALE, _p1y7a7 * 0.5, vec2(BLOOM_RENDER_SCALE) - _p1y7a7 * 0.5);
vec3 _z3o0uh = texture(colortex2, _irylbx).rgb;
vec3 _zujd38 = texture(colortex3, _irylbx).rgb;
vec3 _0m5p3q = _z3o0uh + _zujd38;

if (_2z5x7k >= 0.5 && !_yjolhc) {
_0m5p3q = vec3(0.0);
}

#ifdef END_SHADER
if (_yjolhc) _0m5p3q = vec3(0.0);
#endif

_0m5p3q *= sqrt(BLOOM_RADIUS / 0.3);
#ifdef END_SHADER
_0m5p3q *= END_BLOOM_BOOST;
#endif

#ifdef ATMO_FOG_ENABLED
if (isEyeInWater != 1) {
vec4 _5frq09 = max(texture(colortex9, texcoord), vec4(0.0));
float _5ti3zq = _p48by5 ? 1.0 : texelFetch(colortex1, ivec2(gl_FragCoord.xy), 0).b;
float _wfy7vr = smoothstep(0.4, 0.8, _5ti3zq);
_0m5p3q += _5frq09.rgb * _5frq09.a * _wfy7vr * 0.5;
}
#endif

_0m5p3q = _x7i4gn(_0m5p3q, BLOOM_SATURATION);

float _ayb6l3 = (isEyeInWater == 1) ? 0.0 : 0.3;

vec4 _y1uyo7 = texture(colortex14, texcoord);
float _mptslq = (_y1uyo7.a < 0.5) ? _y1uyo7.r : 0.0;
_vkbwd3 *= (1.0 - _mptslq);
#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome)) _ayb6l3 = 0.05;
#endif

#ifdef CAVE_FOG_ENABLED
#ifndef END_SHADER
if (!_9cwhip(biome))
{

bool _lp4ya8 = (_2ql2nv < _4f6yyb - 0.00001);
float _f07jfz = _lp4ya8 ? 1.0 : texture(colortex1, texcoord).b;
float _apinsq = 1.0 - smoothstep(1.0 / 15.0, 3.0 / 15.0, _f07jfz);
if (_apinsq > 0.01) {

_ayb6l3 = mix(_ayb6l3, 0.0, _apinsq);
float _rys20j = texture(depthtex0, texcoord).r;
if (_7bqo1l(_rys20j)) {
float _jwwpqs = _zdldl1(_rys20j);
float _4k27zv = smoothstep(3.0, 20.0, _jwwpqs) * _apinsq;
_vkbwd3 *= 1.0 - _4k27zv;
}
}
}
#endif
#endif
_0m5p3q *= max(_vkbwd3, _ayb6l3);

_yssmf1 += _0m5p3q;
#endif

#if !defined(NETHER_SHADER) && !defined(END_SHADER)
{
vec2 _x30m22 = _drk3b8();
float _682vh0 = fract(sunAngle);

float sunrise = smoothstep(0.0, 0.03, _682vh0) * (1.0 - smoothstep(0.06, 0.10, _682vh0));
float sunset  = smoothstep(0.40, 0.44, _682vh0) * (1.0 - smoothstep(0.46, 0.48, _682vh0));
float _ytn9sx    = smoothstep(0.10, 0.20, _682vh0) * (1.0 - smoothstep(0.30, 0.40, _682vh0));
float _4afi21  = max(sunrise, sunset) + _ytn9sx * 0.35;
if (isEyeInWater != 1 && _x30m22.x > -0.5 && _4afi21 > 0.001) {
vec2 _ic9jj6 = texcoord - _x30m22;
_ic9jj6.x *= viewWidth / viewHeight;
float _t25r5m = length(_ic9jj6);
float r = SUN_GLOW_RADIUS * 0.7;
float _jjyhed = 1.0 / (1.0 + pow(_t25r5m / r, 2.5));

float _qidmxw;
bool _lhzwat = (_yjolhc || (_xszwck > 0.1) || _n5tvnf) && !_ux4ees;
if (_lhzwat) {
_qidmxw = 1.0;
} else {

vec2 _s4ja50 = 1.0 / vec2(viewWidth, viewHeight);
vec2 _58els0 = normalize(_x30m22 - texcoord) * _s4ja50;
float _87bvww = 0.0;
for (int i = 1; i <= 8; i++) {
vec2 _rbbd13 = texcoord + _58els0 * float(i) * 2.0;
float _cvetr1 = (isEyeInWater == 1) ? texture(depthtex1, _rbbd13).r : texture(depthtex0, _rbbd13).r;
float _caimfo = 1.0 - texture(colortex0, _rbbd13).a;
bool _cekk7s = !_7bqo1l(_cvetr1) || (_caimfo > 0.1);
if (_cekk7s) _87bvww += 1.0;
}

float _b7eypz = smoothstep(4.0, 7.0, _87bvww);
_qidmxw = _b7eypz * 0.5;
if (_rv9f3n || _ux4ees) _qidmxw = 0.0;
}

if (_qidmxw > 0.01) {
_jjyhed *= _4afi21 * SUN_GLOW_INTENSITY * 0.15 * _qidmxw;
vec3 _f1qzlp = _hbv38n();
float _et2iuv = dot(_f1qzlp, vec3(0.299, 0.587, 0.114));
if (_et2iuv < 0.1) _f1qzlp = vec3(1.0, 0.95, 0.8);
else _f1qzlp /= _et2iuv;
_jjyhed *= 1.0 - clamp(_o7giip * 0.8, 0.0, 1.0);
_jjyhed *= 1.0 - smoothstep(0.15, 0.70, rainStrength);
_jjyhed *= 1.0 - clamp(biome_swamp, 0.0, 1.0);
_yssmf1 += _f1qzlp * _jjyhed;
}
}
}
#endif

#if !defined(NETHER_SHADER) && !defined(END_SHADER)
{
float _ub2qag = fract(sunAngle);

float _rbw6d2 = smoothstep(0.38, 0.44, _ub2qag) * (1.0 - smoothstep(0.50, 0.60, _ub2qag));

if (_rbw6d2 > 0.001 && isEyeInWater != 1) {
vec3 _rx0uxl = normalize(mat3(gbufferModelViewInverse) * normalize(vec3(
(texcoord.x * 2.0 - 1.0) / gbufferProjection[0][0],
(texcoord.y * 2.0 - 1.0) / gbufferProjection[1][1],
-1.0)));

float _mt00jt = exp(-_rx0uxl.y * _rx0uxl.y * 20.0);

float _0jytiq = _yjolhc ? 1.0 : _xszwck * 0.5;

float _k4wq28 = _rbw6d2 * _mt00jt * _0jytiq * SUN_GLOW_INTENSITY * 0.3;
_k4wq28 *= 1.0 - smoothstep(0.15, 0.70, rainStrength);
_k4wq28 *= 1.0 - clamp(biome_swamp, 0.0, 1.0);

float _9m83sv = smoothstep(0.38, 0.56, _ub2qag);
vec3 _675nfr = mix(vec3(1.0, 0.95, 0.5), vec3(0.85, 0.3, 0.5), _9m83sv);

_yssmf1 += _675nfr * _k4wq28;
}
}
#endif

#if !defined(NETHER_SHADER) && !defined(END_SHADER)
#if SUN_BRIGHTNESS_BOOST > 0.0
{
vec2 _x30m22 = _drk3b8();
if (_x30m22.x > -0.5) {

vec2 _ic9jj6 = texcoord - _x30m22;
_ic9jj6.x *= viewWidth / viewHeight;
float _hq1t8p = length(_ic9jj6);

float _et7mz7 = 1.0 / (1.0 + _hq1t8p * _hq1t8p * 4.0);

float _huatah = fract(sunAngle);
float _xya605 = smoothstep(0.02, 0.07, _huatah) * (1.0 - smoothstep(0.44, 0.48, _huatah));

float _skufgy = (1.0 - smoothstep(0.1, 0.6, rainStrength)) * (1.0 - clamp(_o7giip * 0.8, 0.0, 1.0));

float _hu0rvg = _et7mz7 * _xya605 * _skufgy * SUN_BRIGHTNESS_BOOST;
_hu0rvg *= 1.0 - clamp(biome_swamp, 0.0, 1.0);

}
}
#endif
#endif

#if defined(STORM_EFFECTS_ENABLED) && defined(STORM_PARTICLES) && defined(WEATHER_FOG_ENABLED)
{
float _4oahdz = clamp(biome_arid, 0.0, 1.0) * rainStrength;
float _nzo28b = clamp(biome_snowy, 0.0, 1.0) * rainStrength;
float pW = max(_4oahdz, _nzo28b);
float _e4913p = clamp(float(eyeBrightnessSmooth.y) / 240.0, 0.0, 1.0);
float _e9eqvt = smoothstep(0.45, 0.9, _e4913p);
float _1ug4tw = texture(depthtex0, texcoord).r;
bool _5115zw = (_1ug4tw > 0.00001 && _1ug4tw < 0.999999);
float _calqs4 = _5115zw ? texture(colortex1, texcoord).b : 1.0;
float _nncbxe = smoothstep(0.80, 0.95, _calqs4);
pW *= mix(_nncbxe, 1.0, _e9eqvt);
if (pW > 0.003 && isEyeInWater == 0) {
float _rgfna9 = clamp(thunderStrength, 0.0, 1.0);

vec4 _s92p36 = gbufferProjectionInverse * vec4(texcoord * 2.0 - 1.0, 1.0, 1.0);
vec3 _pyssqf = normalize(mat3(gbufferModelViewInverse) * (_s92p36.xyz / _s92p36.w));
float _sil5dm = length(_bu16tm - cameraPosition);

float _x0bpbz = 0.7 + frameTimeCounter * 0.00035 + 0.35 * sin(frameTimeCounter * 0.0011);
vec2 _y7mklj = vec2(cos(_x0bpbz), sin(_x0bpbz));

const vec2 _2t6zh5 = vec2(0.7682, 0.6402);
vec3 _sj3s3y = vec3(_2t6zh5.x, 0.0, _2t6zh5.y) * (frameTimeCounter * 2.2);

float _k49epe = smoothstep(0.55, 0.62, fract(sunAngle)) * (1.0 - smoothstep(0.90, 0.96, fract(sunAngle)));
vec3 _f8139c = vec3(0.69411765, 0.61176471, 0.43921569) * mix(1.0, 0.48, _k49epe);
vec3 _zxz2lr = (_4oahdz >= _nzo28b) ? _f8139c : vec3(0.97, 0.99, 1.06);

float _dxbzgt = 2.0 * abs(gbufferProjectionInverse[1][1]) / viewHeight;
float _rbf6ma = min(_sil5dm, float(STORM_PARTICLE_DISTANCE));
float _f0gfrq = clamp(0.40 * STORM_PARTICLE_AMOUNT, 0.0, 0.95);
for (int i = 0; i < 8; i++) {
float fi = float(i);
float d = 2.5 + fi * 1.6 + fi * fi * 0.42;
if (d > _rbf6ma) break;
vec3 _newvwh = cameraPosition + _pyssqf * d;
vec3 pp = _newvwh - _sj3s3y;
float _7gmu2v = smoothstep(float(SEA_LEVEL_OFFSET), float(SEA_LEVEL_OFFSET) + 2.0, _newvwh.y);
float cs = 1.8 + fi * 0.5;
vec3 q = pp / cs + vec3(31.7, 17.3, 57.1) * fi;
vec3 _h908e6 = floor(q);
vec3 fr = q - _h908e6;

float h1 = fract(sin(dot(mod(_h908e6, 289.0), vec3(127.1, 311.7, 74.7))) * 43758.5453);
if (h1 < _f0gfrq) {

const float _erwn6v = 9.0;
float _o06bhm = frameTimeCounter + h1 * _erwn6v * 17.0;
float _0mbyqm = mod(_o06bhm, _erwn6v);
float _id4cg2 = floor(_o06bhm / _erwn6v);
float hc = fract(h1 + _id4cg2 * 0.6180339887);
float _mmhjh6 = smoothstep(0.0, 1.5, _0mbyqm) * (1.0 - smoothstep(6.0, 7.5, _0mbyqm));
float h2 = fract(hc * 91.17 + 0.37);
float h3 = fract(hc * 53.7 + 0.71);

float _o3lk9x = frameTimeCounter * (0.45 + h2 * 0.4) + hc * 6.2831;
vec3 _y5hhd1 = vec3(0.5);
_y5hhd1.xz += _y7mklj * (0.20 * sin(_o3lk9x));
_y5hhd1 += 0.13 * vec3(
sin(frameTimeCounter * (0.5 + h2 * 0.7) + hc * 6.2831),
sin(frameTimeCounter * (0.6 + h3 * 0.6) + h2 * 6.2831),
sin(frameTimeCounter * (0.4 + hc * 0.7) + h3 * 6.2831));

vec3 dd = (fr - _y5hhd1) * cs;

float _t8q566 = dot(dd, _pyssqf);
vec3 _maroqa = dd - _pyssqf * _t8q566;
float _x7b2u6 = max(abs(_maroqa.x), max(abs(_maroqa.y), abs(_maroqa.z)));

float _n9iynb = mix(4.0, 9.0, h2 * h2) * 0.70 * STORM_PARTICLE_SIZE;
float _2qirk7 = 0.5 * _n9iynb * _dxbzgt * d;
float aa = 1.5 * _dxbzgt * d;
float _ywsw4x = 1.0 - smoothstep(_2qirk7 - aa * 0.5, _2qirk7 + aa * 0.5, _x7b2u6);

vec3 _nuzfjc = smoothstep(vec3(0.0), vec3(0.3), fr) * (vec3(1.0) - smoothstep(vec3(0.7), vec3(1.0), fr));
float _qvzi6q = _nuzfjc.x * _nuzfjc.y * _nuzfjc.z;
float _nqerdc = mix(0.8, 1.15, h3);
float _az4bgs = 1.0 - fi * 0.12;
float _wi6v2t = _ywsw4x * _qvzi6q * _mmhjh6 * pW * _7gmu2v
* 0.65 * STORM_PARTICLE_OPACITY * _az4bgs;
_yssmf1 = mix(_yssmf1, _zxz2lr * _nqerdc, _wi6v2t);
}
}
}
}
#endif

{

#ifdef POST_SHARPEN
{
vec2 _s4ja50 = 1.0 / vec2(viewWidth, viewHeight);
vec3 n = texture(colortex0, texcoord + vec2(0.0,  _s4ja50.y)).rgb;
vec3 s = texture(colortex0, texcoord + vec2(0.0, -_s4ja50.y)).rgb;
vec3 e = texture(colortex0, texcoord + vec2( _s4ja50.x, 0.0)).rgb;
vec3 w = texture(colortex0, texcoord + vec2(-_s4ja50.x, 0.0)).rgb;
vec3 _zp9nfz = (n + s + e + w) * 0.25;
_yssmf1 = _yssmf1 + (_yssmf1 - _zp9nfz) * POST_SHARPEN_STRENGTH;
}
#endif

_yssmf1 = (_yssmf1 - 0.5) * POST_CONTRAST + 0.5 + POST_BRIGHTNESS;

float _rkfcys = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
_yssmf1 = mix(vec3(_rkfcys), _yssmf1, POST_SATURATION);

#ifdef Y_FADE_ENABLED
{
if (!_p48by5) {
float _ra6fay = 1.0 - smoothstep(YFADE_BOTTOM_Y, YFADE_TOP_Y, _g3qr01.y);
vec3 _67dif5 = vec3(YFADE_COLOR_R, YFADE_COLOR_G, YFADE_COLOR_B);
_yssmf1 = mix(_yssmf1, _67dif5, _ra6fay * YFADE_OPACITY);
}
}
#endif

#ifdef COLOR_GRADING_ENABLED
_yssmf1 = _8ppq8e(_yssmf1, texcoord, frameTimeCounter, frameCounter);
#endif
}

#ifdef LAVA_FOG_ENABLED

if (isEyeInWater == 2) {
vec3 _d3fzcw = vec3(0.75, 0.28, 0.03);
vec3 _e8nt0u = vec3(0.95, 0.65, 0.1);
#ifdef BIOME_SOUL_SAND_VALLEY
if (biome == BIOME_SOUL_SAND_VALLEY) {
_d3fzcw = vec3(0.01, 0.45, 0.65);
_e8nt0u = vec3(0.1, 0.6, 0.85);
}
#endif
float _g5gc1g = _yjolhc ? 100.0 : _zdldl1(_2ql2nv);
float _71iofa = 1.0 - exp(-_g5gc1g * 1.5);

vec2 _gg4v77 = texcoord * 2.0 - 1.0;
float _r4dpq4 = dot(_gg4v77, _gg4v77);
float _v9b6vp = smoothstep(0.3, 1.2, _r4dpq4) * 0.3;

vec3 _nlxjl1 = mix(_d3fzcw, _e8nt0u, _v9b6vp);
_yssmf1 = mix(_yssmf1, _nlxjl1, clamp(_71iofa, 0.0, 1.0));
}
#endif
#ifdef VOXY_DEBUG_BRIGHTNESS_MATCH

{
vec4 _f6rzge = texture(colortex0, texcoord);
gl_FragColor = vec4(_f6rzge.rgb, 1.0);
return;
}
#endif
gl_FragColor = vec4(clamp(_yssmf1, 0.0, 1.0), 1.0);
}
