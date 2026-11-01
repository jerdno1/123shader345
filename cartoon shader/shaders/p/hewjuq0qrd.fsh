/* RENDERTARGETS: 10 */

#include "/settings.glsl"

#if defined(HAZE_FOG_ACTIVE) || defined(NETHER_FOG_ENABLED)

#include "/include/biome_overrides.glsl"

in vec2 texcoord;

uniform sampler2D colortex1;
uniform sampler2D colortex5;
uniform sampler2D colortex10;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D dhDepthTex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 dhProjectionInverse;
uniform mat4 vxProjInv;
uniform sampler2D vxDepthTexTrans;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float sunAngle;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float dhNearPlane;
uniform float dhFarPlane;
uniform float rainStrength;
uniform int frameCounter;
uniform int biome;
uniform int biome_category;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;
uniform int isEyeInWater;
uniform ivec2 eyeBrightnessSmooth;

#include "/include/depth_utils.glsl"
#include "/include/sky_timeline.glsl"

vec3 _bfm8sy() {

vec3 _5gj819 = _9ruyvd(sunAngle, 0.0);
vec3 _yssmf1 = mix(fogColor, _5gj819, 0.5);
float _obst5k = _dfzmvk(biome_snowy, biome, biome_category);
float _gj2dau = _2vpc5n(biome_swamp, biome, biome_category);
float _qjyghv = _avnajg(biome_jungle, biome, biome_category, _gj2dau);
float _x5lo9i = _j4acyp(biome_arid, biome, biome_category);
float _diiukt = _g4a6za(_huw7hc(biome_savanna, biome, biome_category), _gj2dau);
_yssmf1 = _af4aog(_yssmf1, _obst5k, _qjyghv, _gj2dau, _x5lo9i, _diiukt);
float _rkfcys = dot(_yssmf1, vec3(0.299, 0.587, 0.114));

_yssmf1 = mix(vec3(_rkfcys), _yssmf1, 1.5);
_yssmf1 = max(_yssmf1, vec3(0.0));

float _6qwad8 = max(_yssmf1.r, max(_yssmf1.g, _yssmf1.b));
if (_6qwad8 > 0.001) _yssmf1 /= _6qwad8;
return _yssmf1 * HAZE_FOG_BRIGHTNESS;
}

vec3 _wux0h5() {
TimeWeights tw = getTimeWeights(sunAngle);

vec3 _9fpt1m      = vec3(DAY_ZENITH_R,      DAY_ZENITH_G,      DAY_ZENITH_B);
vec3 _vqy7od   = vec3(SUNSET_ZENITH_R,   SUNSET_ZENITH_G,   SUNSET_ZENITH_B);
vec3 _rb85u3 = vec3(BLUEHOUR_ZENITH_R,  BLUEHOUR_ZENITH_G,  BLUEHOUR_ZENITH_B);
vec3 _jl63ac    = vec3(NIGHT_ZENITH_R,     NIGHT_ZENITH_G,     NIGHT_ZENITH_B);
vec3 _d56bsq  = vec3(SUNRISE_ZENITH_R,   SUNRISE_ZENITH_G,   SUNRISE_ZENITH_B);

vec3 _riel36 = _9fpt1m      * tw.day
+ _vqy7od   * tw.sunset
+ _rb85u3 * tw.blueHour
+ _jl63ac    * tw.night
+ _d56bsq  * tw.sunrise;

float _rkfcys = dot(_riel36, vec3(0.299, 0.587, 0.114));
_riel36 = mix(vec3(_rkfcys), _riel36, 0.5);
_riel36 *= vec3(0.7, 0.75, 1.0);

float _huatah = fract(sunAngle);
float _xya605 = smoothstep(0.02, 0.08, _huatah) * (1.0 - smoothstep(0.44, 0.52, _huatah));
float _h0gyrr = smoothstep(0.55, 0.62, _huatah) * (1.0 - smoothstep(0.90, 0.96, _huatah));
float _hrymrq = max(_xya605, _h0gyrr * 0.30);
float _4hoxs4 = clamp(tw.night + tw.blueHour * 0.35, 0.0, 1.0);

float _45isel = mix(1.15, 1.05, _4hoxs4);

return _riel36 * WEATHER_FOG_BRIGHTNESS * _hrymrq * _45isel;
}

void main() {

vec2 _duy16z = (floor(gl_FragCoord.xy) / FOG_RENDER_SCALE + 0.5) / vec2(viewWidth, viewHeight);
#define texcoord _duy16z

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome)) {

float _nxln75 = texture(depthtex0, texcoord).r;
float _s8jv7w = texture(depthtex1, texcoord).r;
float _rh9n3u = texture(vxDepthTexTrans, texcoord).r;
vec4 _cs5kq4 = texture(colortex1, texcoord);
bool _k7ty2u = _7bqo1l(_nxln75);
bool _lnede6 = _7bqo1l(_s8jv7w);
bool _l7q5zt = _2fqi4q(vxProjInv) && (_rh9n3u > 0.00001 && _rh9n3u < 0.9999);

bool _z4pexn = (_cs5kq4.a > 0.01 && _cs5kq4.a < 0.99);

vec3 _2qmeme;
bool _7gfcmc = false;
if (_z4pexn && _k7ty2u) {

_7gfcmc = _cwcjr4(
gbufferProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _nxln75, _2qmeme);
} else if (_lnede6) {

_7gfcmc = _cwcjr4(
gbufferProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _s8jv7w, _2qmeme);
} else if (_l7q5zt) {
_7gfcmc = _cwcjr4(
vxProjInv, gbufferModelViewInverse, cameraPosition, texcoord, _rh9n3u, _2qmeme);
}
if (!_7gfcmc) {
vec3 _229jul;
if (!_c0ckez(gbufferProjectionInverse, texcoord, 1.0, _229jul)) {
_229jul = vec3(texcoord * 2.0 - 1.0, -1.0);
}
vec3 _choeuv = _lcgfcm(
mat3(gbufferModelViewInverse) * _229jul,
_lcgfcm(mat3(gbufferModelViewInverse) * vec3(0.0, 0.0, -1.0), vec3(0.0, 0.0, -1.0)));
_2qmeme = cameraPosition + _choeuv * 640.0;
}

vec3 _ox59pm = _2qmeme - cameraPosition;
vec3 _rcfndn = _lcgfcm(_ox59pm, vec3(0.0, 0.0, -1.0));
float _an6zve = min(length(_ox59pm), 640.0);

int _hkx0wz = 24;
float _1xjzh9 = _an6zve / float(_hkx0wz);
float _chw1pt = fract(52.9829189 * fract(0.06711056 * gl_FragCoord.x + 0.00583715 * gl_FragCoord.y)
+ 0.6180339887 * float(frameCounter));

vec3 _h0kcwu = vec3(1.0, 0.35, 0.08);
#ifdef BIOME_SOUL_SAND_VALLEY
if (biome == BIOME_SOUL_SAND_VALLEY) {
_h0kcwu = vec3(1.0/255.0, 158.0/255.0, 210.0/255.0) * 1.5;
}
#endif
vec3 _pnb5fc = vec3(0.0);
float _2aws42 = 1.0;

for (int i = 0; i < _hkx0wz; i++) {
float t = (float(i) + _chw1pt) * _1xjzh9;
if (t > _an6zve) break;
vec3 _tj3223 = cameraPosition + _rcfndn * t;

float ht = clamp((_tj3223.y - 31.0) / (45.0 - 31.0), 0.0, 1.0);

float _3crd8e = 1.0 - pow(ht, 0.3);
float _6zh0ul = _3crd8e * 15.0 * _1xjzh9 * 0.005;

if (_6zh0ul > 0.0) {
float _go9sq0 = _3crd8e;
vec3 _nvr7mg = _h0kcwu * (0.3 + 0.7 * _go9sq0);
_pnb5fc += _nvr7mg * _6zh0ul * _2aws42;
_2aws42 *= exp(-_6zh0ul);
}
if (_2aws42 < 0.01) break;
}

float _bcufmy = 1.0 - _2aws42;

if (_cs5kq4.g > 0.5 && !_z4pexn) {
_pnb5fc *= 0.7;
_bcufmy *= 0.7;
}

gl_FragData[0] = vec4(_pnb5fc, _bcufmy);
return;
}
#else
if (_9cwhip(biome)) {
gl_FragData[0] = vec4(0.0);
return;
}
#endif
#ifdef END_SHADER
gl_FragData[0] = vec4(0.0);
return;
#else
#ifdef CAT_THE_END
if (biome_category == CAT_THE_END) {
gl_FragData[0] = vec4(0.0);
return;
}
#endif
#endif

if (isEyeInWater == 1) {
gl_FragData[0] = vec4(0.0);
return;
}

#ifdef HAZE_FOG_ACTIVE

float _2zs1mf = texture(depthtex0, texcoord).r;
float _b8i8m4 = texture(depthtex1, texcoord).r;
float _ips7jr = texture(dhDepthTex, texcoord).r;
float vxDepth = texture(vxDepthTexTrans, texcoord).r;
vec3 _0x5uwo;
bool _aa77op = _yfr6tv(_ips7jr) && _cwcjr4(
dhProjectionInverse, gbufferModelViewInverse, cameraPosition, texcoord, _ips7jr, _0x5uwo);
bool _pgh3p7 = _2fqi4q(vxProjInv) && _7bqo1l(vxDepth);
vec4 _alcc4c = texture(colortex1, texcoord);
bool _rv9f3n = (_alcc4c.a > 0.999 && !_7bqo1l(_2zs1mf));
bool _kt17lp = (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);
bool _d293zd = (_2zs1mf < _b8i8m4 - 0.00001);
bool _0t1n6k = (texture(colortex5, texcoord).y > 0.9) && _d293zd;
bool _45847i = _pgh3p7 && (_d293zd || _rv9f3n);

float _1r3mt9;
bool _nwgn5g = false;
if (_kt17lp) {

_1r3mt9 = _2zs1mf;
} else if (_0t1n6k && _7bqo1l(_2zs1mf)) {
_1r3mt9 = _2zs1mf;
} else if (_45847i) {
_1r3mt9 = vxDepth;
_nwgn5g = true;
} else if (_d293zd && !_kt17lp) {
_1r3mt9 = _7bqo1l(_b8i8m4) ? _b8i8m4 : _2zs1mf;
} else {
_1r3mt9 = _2zs1mf;
}
vec3 _003it1;
bool _h52zhs = _7bqo1l(_1r3mt9) && _cwcjr4(
_nwgn5g ? vxProjInv : gbufferProjectionInverse,
gbufferModelViewInverse,
cameraPosition,
texcoord,
_1r3mt9,
_003it1);

if (!_h52zhs && !_aa77op) {

gl_FragData[0] = vec4(0.0);
return;
}

vec3 _q62x7r;
float _cunixp;

if (_h52zhs) {
vec3 _ys8kd8 = _003it1 - cameraPosition;
_q62x7r = _lcgfcm(_ys8kd8, vec3(0.0, 0.0, -1.0));
_cunixp = length(_ys8kd8);
} else {

if (_aa77op) {
vec3 _bv8q46 = _0x5uwo - cameraPosition;
_cunixp = length(_bv8q46);
_q62x7r = _lcgfcm(_bv8q46, vec3(0.0, 0.0, -1.0));
} else {

vec3 _enbfdh;
if (!_c0ckez(gbufferProjectionInverse, texcoord, 1.0, _enbfdh)) {
_enbfdh = vec3(texcoord * 2.0 - 1.0, -1.0);
}
_q62x7r = _lcgfcm(
mat3(gbufferModelViewInverse) * _enbfdh,
_lcgfcm(mat3(gbufferModelViewInverse) * vec3(0.0, 0.0, -1.0), vec3(0.0, 0.0, -1.0)));
_cunixp = float(HAZE_FOG_DIST_END);
}
}

float _isil8r = float(SEA_LEVEL_OFFSET) + float(HAZE_FOG_MIN_Y);
float _osm8sq = float(HAZE_FOG_MAX_Y - HAZE_FOG_MIN_Y);
float _wzks95    = _isil8r + _osm8sq * (1.0 + rainStrength);
float _9cvacp = (_wzks95 - _isil8r) * 0.5;

float _pmyyus = rainStrength * 0.8;
float _xx5ojq = max(0.0, float(HAZE_FOG_DIST_START) * (1.0 - _pmyyus));
float _q92vvk  = min(_cunixp, float(HAZE_FOG_DIST_END));

if (_xx5ojq >= _q92vvk) {
gl_FragData[0] = vec4(0.0);
return;
}

float _54jqpj = cameraPosition.y + _q62x7r.y * _xx5ojq;
float _r6w9bo = cameraPosition.y + _q62x7r.y * _q92vvk;
if (max(_54jqpj, _r6w9bo) < _isil8r || min(_54jqpj, _r6w9bo) > _wzks95) {
gl_FragData[0] = vec4(0.0);
return;
}

if (abs(_q62x7r.y) > 0.0001) {
float _7q4159 = (_isil8r - cameraPosition.y) / _q62x7r.y;
float _do8ywd = (_wzks95    - cameraPosition.y) / _q62x7r.y;
float _rcith2 = min(_7q4159, _do8ywd);
float _rw7ie8  = max(_7q4159, _do8ywd);
_xx5ojq = max(_xx5ojq, _rcith2);
_q92vvk  = min(_q92vvk, _rw7ie8);
if (_xx5ojq >= _q92vvk) {
gl_FragData[0] = vec4(0.0);
return;
}
}

float _zxq7hh = _9cvacp;
float _olh45k = max(_zxq7hh, 0.001);
float _y4avgu = (1.0 - smoothstep(_wzks95, _wzks95 + _olh45k, cameraPosition.y))
* smoothstep(_isil8r - _olh45k, _isil8r, cameraPosition.y);
bool _8w9bah = (_y4avgu > 0.01);

float _izh8vx = 0.5;

vec3 _nvr7mg = _bfm8sy();
vec3 _9w9wx2 = _wux0h5();
_nvr7mg = mix(_nvr7mg, _9w9wx2, rainStrength);

float _3tqs27 = max(HAZE_FOG_DENSITY + rainStrength * 0.3, 0.01);
float _8cn0an = float(eyeBrightnessSmooth.y) / 240.0;
float _baifgx = 1.0 - smoothstep(0.18, 0.52, _8cn0an);
float _i2b1zg = smoothstep(0.12, 0.55, _baifgx);

float _30qw16 = _q92vvk - _xx5ojq;
float _gduy5n = _30qw16 / float(HAZE_FOG_STEPS);

float _7jvfok = _3tqs27 * 0.003;

vec3  _mq5jbs = vec3(0.0);
float _8gkfsz = 1.0;

for (int i = 0; i < HAZE_FOG_STEPS; i++) {
float t = _xx5ojq + (float(i) + _izh8vx) * _gduy5n;
vec3 _tj3223 = cameraPosition + _q62x7r * t;

float _hamevo = 1.0 - smoothstep(_wzks95 - max(_9cvacp, 0.001), _wzks95, _tj3223.y);
float _3euaee = smoothstep(_isil8r, _isil8r + 2.0, _tj3223.y);
float _3crd8e = _hamevo * _3euaee;

float _exv93s = float(HAZE_FOG_DIST_END);
float _36zwff = 1.0 - smoothstep(_exv93s * 0.2, _exv93s, t);

float _6zh0ul = _3crd8e * _36zwff * _7jvfok * _gduy5n * (1.0 - _i2b1zg);

if (_6zh0ul > 0.0) {
_mq5jbs += _nvr7mg * _6zh0ul * _8gkfsz;
_8gkfsz *= exp(-_6zh0ul);
}

if (_8gkfsz < 0.01) break;
}

float _9gel4l = 1.0 - _8gkfsz;

float _ztky6h = mix(1.0, HAZE_FOG_INSIDE_OPACITY, _y4avgu);
_9gel4l *= _ztky6h;
_mq5jbs *= _ztky6h;

gl_FragData[0] = vec4(_mq5jbs, _9gel4l);
#else
gl_FragData[0] = vec4(0.0);
#endif
#undef texcoord
}

#else

in vec2 texcoord;

void main() {
gl_FragData[0] = vec4(0.0);
}

#endif
