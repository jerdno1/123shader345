#ifndef SHADOW_GLSL
#define SHADOW_GLSL

float _kfwxfj(float x) { return x * x * x * x; }

float _55535n(vec2 v) {
return sqrt(sqrt(_kfwxfj(v.x) + _kfwxfj(v.y)));
}

float _73r92z(float x) {
x *= x;
x *= x;
x *= x;
x *= x;
x *= x;
return x;
}

float _030aoo(float _eir7ue, float _ez2tne, float x) {
return clamp((x - _eir7ue) / max(_ez2tne - _eir7ue, 1e-6), 0.0, 1.0);
}

float _xr26fh(vec3 _i1hwjb, float viewDistance) {
vec2 _w1ppkd = abs(_i1hwjb.xy * 2.0 - 1.0);
float _ku7vgs = max(_w1ppkd.x, _w1ppkd.y);

return _030aoo(0.1, 1.0, _73r92z(_ku7vgs));
}

vec3 _2y5umb(vec3 _gpy6je) {
float _4mbz2g = _55535n(_gpy6je.xy) + SHADOW_DISTORTION;
return vec3(_gpy6je.xy / _4mbz2g, _gpy6je.z * SHADOW_DEPTH_SCALE);
}

#ifdef SHADOWS_ENABLED

uniform sampler2D shadowcolor0;

float _ckk90a(vec3 _gpy6je) {
float r = _55535n(_gpy6je.xy);
float _4mbz2g = r + SHADOW_DISTORTION;
float _i3lh0e = _4mbz2g * _4mbz2g;

float _klplei = 0.5 / SHADOW_DEPTH_SCALE;
return SHADOW_NORMAL_BIAS / float(_qezbw4) * (_i3lh0e / SHADOW_DISTORTION) * _klplei;
}

vec3 _1yh7un(vec3 _h4gwes, vec3 normal, float _4t5ihg) {

float _h68r8g = clamp(0.12 + 0.01 * length(_h4gwes), 0.0, 1.0);

float _144v7i = 2.0 - clamp(_4t5ihg, 0.0, 1.0);
return 0.25 * normal * _h68r8g * _144v7i;
}

float _h1jpqh(vec2 _gpy6je) {
return fract(52.9829189 * fract(0.06711056 * _gpy6je.x + 0.00583715 * _gpy6je.y));
}
float _h1jpqh(vec2 _gpy6je, int t) {
return _h1jpqh(_gpy6je + 5.588238 * float(t & 63));
}

float _e4hc8m(float _izh8vx, vec3 _i1hwjb) {
#ifdef PIXELATED_SHADOWS
vec2 _xfs2d2 = floor(clamp(_i1hwjb.xy, vec2(0.0), vec2(1.0)) * float(_qezbw4));
return _h1jpqh(_xfs2d2);
#else
return _izh8vx;
#endif
}

mat2 _5whpln(float _huatah) {
float c = cos(_huatah);
float s = sin(_huatah);
return mat2(c, -s, s, c);
}

const vec2[16] blueNoiseDisk = vec2[](
vec2( 0.478712,  0.875764),
vec2(-0.337956, -0.793959),
vec2(-0.955259, -0.028164),
vec2( 0.864527,  0.325689),
vec2( 0.209342, -0.395657),
vec2(-0.106779,  0.672585),
vec2( 0.156213,  0.235113),
vec2(-0.413644, -0.082856),
vec2(-0.415667,  0.323909),
vec2( 0.141896, -0.939980),
vec2( 0.954932, -0.182516),
vec2(-0.766184,  0.410799),
vec2(-0.434912, -0.458845),
vec2( 0.415242, -0.078724),
vec2( 0.728335, -0.491777),
vec2(-0.058086, -0.066401)
);

float _s4lpf1(vec3 _i1hwjb) {
vec2 _eu3q17 = min(_i1hwjb.xy, 1.0 - _i1hwjb.xy);
float _a9osj3 = smoothstep(0.0, 0.05, min(_eu3q17.x, _eu3q17.y));
float _ncxkmi = smoothstep(0.0, 0.02, _i1hwjb.z) * (1.0 - smoothstep(0.98, 1.0, _i1hwjb.z));
return _a9osj3 * _ncxkmi;
}

float _nin789() {
#ifdef PIXELATED_SHADOWS
return max(PIXELATED_SHADOW_BLUR, 0.0);
#else
return 0.0;
#endif
}

float _mnciar(vec3 _i1hwjb, float _w02w60) {
return _nin789() * (1.0 / float(_qezbw4)) * max(_w02w60, 0.0);
}

float _4m3l6t(sampler2D shadowtex, vec3 _i1hwjb, float _c4cke4) {
float _slnatl = texture(shadowtex, _i1hwjb.xy).r;
return step(_i1hwjb.z - _c4cke4, _slnatl);
}

float _q06ww9(sampler2D shadowtex, vec3 _i1hwjb, float _c4cke4) {
float shadow = _4m3l6t(shadowtex, _i1hwjb, _c4cke4);
float _6noprb = _nin789();
if (_6noprb <= 0.0) return shadow;

float _w02w60 = _55535n(_i1hwjb.xy * 2.0 - 1.0) + SHADOW_DISTORTION;
float _ge9gac = _mnciar(_i1hwjb, _w02w60);
if (_ge9gac <= 0.0) return shadow;

vec2 _sd7ouq = vec2(_ge9gac, 0.0);
vec2 _yk2yq8 = vec2(0.0, _ge9gac);
shadow *= 4.0;
shadow += _4m3l6t(shadowtex, vec3(_i1hwjb.xy + _sd7ouq, _i1hwjb.z), _c4cke4);
shadow += _4m3l6t(shadowtex, vec3(_i1hwjb.xy - _sd7ouq, _i1hwjb.z), _c4cke4);
shadow += _4m3l6t(shadowtex, vec3(_i1hwjb.xy + _yk2yq8, _i1hwjb.z), _c4cke4);
shadow += _4m3l6t(shadowtex, vec3(_i1hwjb.xy - _yk2yq8, _i1hwjb.z), _c4cke4);
return shadow * 0.125;
}

vec3 _qtp9nm(sampler2D shadowtex, sampler2D colortex, vec3 _i1hwjb, float _c4cke4) {
if (_4m3l6t(shadowtex, _i1hwjb, _c4cke4) < 0.5) {
vec4 _59bql9 = texture(colortex, _i1hwjb.xy);
return (_59bql9.a < 0.5) ? mix(vec3(1.0), _59bql9.rgb, 0.5) : vec3(0.0);
}
return vec3(1.0);
}

vec3 _8s97gp(sampler2D shadowtex, sampler2D colortex, sampler2D entityMarkerTex, vec3 _i1hwjb, float _c4cke4) {
if (_4m3l6t(shadowtex, _i1hwjb, _c4cke4) < 0.5) {
float _r2fgn0 = texture(entityMarkerTex, _i1hwjb.xy).r;
if (_r2fgn0 > 0.5) return vec3(1.0);

vec4 _59bql9 = texture(colortex, _i1hwjb.xy);
return (_59bql9.a < 0.5) ? mix(vec3(1.0), _59bql9.rgb, 0.5) : vec3(0.0);
}
return vec3(1.0);
}

vec3 _osozjc(sampler2D shadowtex, sampler2D colortex, vec3 _i1hwjb, float _c4cke4) {
vec3 shadow = _qtp9nm(shadowtex, colortex, _i1hwjb, _c4cke4);
float _6noprb = _nin789();
if (_6noprb <= 0.0) return shadow;

float _w02w60 = _55535n(_i1hwjb.xy * 2.0 - 1.0) + SHADOW_DISTORTION;
float _ge9gac = _mnciar(_i1hwjb, _w02w60);
if (_ge9gac <= 0.0) return shadow;

vec2 _sd7ouq = vec2(_ge9gac, 0.0);
vec2 _yk2yq8 = vec2(0.0, _ge9gac);
shadow *= 4.0;
shadow += _qtp9nm(shadowtex, colortex, vec3(_i1hwjb.xy + _sd7ouq, _i1hwjb.z), _c4cke4);
shadow += _qtp9nm(shadowtex, colortex, vec3(_i1hwjb.xy - _sd7ouq, _i1hwjb.z), _c4cke4);
shadow += _qtp9nm(shadowtex, colortex, vec3(_i1hwjb.xy + _yk2yq8, _i1hwjb.z), _c4cke4);
shadow += _qtp9nm(shadowtex, colortex, vec3(_i1hwjb.xy - _yk2yq8, _i1hwjb.z), _c4cke4);
return shadow * 0.125;
}

vec3 _g136pf(sampler2D shadowtex, sampler2D colortex, sampler2D entityMarkerTex, vec3 _i1hwjb, float _c4cke4) {
vec3 shadow = _8s97gp(shadowtex, colortex, entityMarkerTex, _i1hwjb, _c4cke4);
float _6noprb = _nin789();
if (_6noprb <= 0.0) return shadow;

float _w02w60 = _55535n(_i1hwjb.xy * 2.0 - 1.0) + SHADOW_DISTORTION;
float _ge9gac = _mnciar(_i1hwjb, _w02w60);
if (_ge9gac <= 0.0) return shadow;

vec2 _sd7ouq = vec2(_ge9gac, 0.0);
vec2 _yk2yq8 = vec2(0.0, _ge9gac);
shadow *= 4.0;
shadow += _8s97gp(shadowtex, colortex, entityMarkerTex, vec3(_i1hwjb.xy + _sd7ouq, _i1hwjb.z), _c4cke4);
shadow += _8s97gp(shadowtex, colortex, entityMarkerTex, vec3(_i1hwjb.xy - _sd7ouq, _i1hwjb.z), _c4cke4);
shadow += _8s97gp(shadowtex, colortex, entityMarkerTex, vec3(_i1hwjb.xy + _yk2yq8, _i1hwjb.z), _c4cke4);
shadow += _8s97gp(shadowtex, colortex, entityMarkerTex, vec3(_i1hwjb.xy - _yk2yq8, _i1hwjb.z), _c4cke4);
return shadow * 0.125;
}

float _aykm1a(sampler2D shadowtex, vec3 _i1hwjb, float _w02w60, float _izh8vx) {

if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return 1.0;
}

float _vujnw0 = (SHADOW_PCF_RADIUS + _nin789()) * (1.0 / float(_qezbw4)) * _w02w60;
mat2 _42loy0 = _5whpln(6.28318 * _izh8vx) * _vujnw0;

float shadow = 0.0;
const int _r149mm = 6;

for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _42loy0 * blueNoiseDisk[i];
vec2 _q9sbm4 = _i1hwjb.xy + _ja8cqx;

float _slnatl = texture(shadowtex, _q9sbm4).r;
shadow += step(_i1hwjb.z, _slnatl);
}

shadow /= float(_r149mm);

return mix(1.0, shadow, _s4lpf1(_i1hwjb));
}

vec3 _nmx2gt(sampler2D shadowtex, sampler2D colortex, vec3 _i1hwjb, float _w02w60, float _izh8vx, float _c4cke4) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return vec3(1.0);
}

float _vujnw0 = (SHADOW_PCF_RADIUS + _nin789()) * (1.0 / float(_qezbw4)) * _w02w60;
mat2 _42loy0 = _5whpln(6.28318 * _izh8vx) * _vujnw0;

vec3 _eu5mwn = vec3(0.0);
const int _r149mm = 6;

for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _42loy0 * blueNoiseDisk[i];
vec2 _q9sbm4 = _i1hwjb.xy + _ja8cqx;

float _slnatl = texture(shadowtex, _q9sbm4).r;
if (_i1hwjb.z - _c4cke4 > _slnatl) {
vec4 _59bql9 = texture(colortex, _q9sbm4);
vec3 _wwfca0 = (_59bql9.a < 0.5) ? mix(vec3(1.0), _59bql9.rgb, 0.5) : vec3(0.0);
_eu5mwn += _wwfca0;
} else {
_eu5mwn += vec3(1.0);
}
}

vec3 _8izj9y = _eu5mwn / float(_r149mm);
return mix(vec3(1.0), _8izj9y, _s4lpf1(_i1hwjb));
}

vec3 _xlukz2(sampler2D shadowtex, sampler2D colortex, sampler2D entityMarkerTex, vec3 _i1hwjb, float _w02w60, float _izh8vx, float _c4cke4) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return vec3(1.0);
}

float _vujnw0 = (SHADOW_PCF_RADIUS + _nin789()) * (1.0 / float(_qezbw4)) * _w02w60;
mat2 _42loy0 = _5whpln(6.28318 * _izh8vx) * _vujnw0;

vec3 _eu5mwn = vec3(0.0);
const int _r149mm = 16;

for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _42loy0 * blueNoiseDisk[i];
vec2 _q9sbm4 = _i1hwjb.xy + _ja8cqx;

float _slnatl = texture(shadowtex, _q9sbm4).r;
if (_i1hwjb.z - _c4cke4 > _slnatl) {

float _r2fgn0 = texture(entityMarkerTex, _q9sbm4).r;
if (_r2fgn0 > 0.5) {

_eu5mwn += vec3(1.0);
} else {
vec4 _59bql9 = texture(colortex, _q9sbm4);
vec3 _wwfca0 = (_59bql9.a < 0.5) ? mix(vec3(1.0), _59bql9.rgb, 0.5) : vec3(0.0);
_eu5mwn += _wwfca0;
}
} else {
_eu5mwn += vec3(1.0);
}
}

vec3 _8izj9y = _eu5mwn / float(_r149mm);
return mix(vec3(1.0), _8izj9y, _s4lpf1(_i1hwjb));
}

vec3 _qkmd9b(sampler2D shadowtex, sampler2D colortex, vec3 _i1hwjb, float _c4cke4) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return vec3(1.0);
}

vec3 shadow = _osozjc(shadowtex, colortex, _i1hwjb, _c4cke4);
return mix(vec3(1.0), shadow, _s4lpf1(_i1hwjb));
}

vec3 _syjysd(sampler2D shadowtex, sampler2D colortex, sampler2D entityMarkerTex, vec3 _i1hwjb, float _c4cke4) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return vec3(1.0);
}

vec3 shadow = _g136pf(shadowtex, colortex, entityMarkerTex, _i1hwjb, _c4cke4);
return mix(vec3(1.0), shadow, _s4lpf1(_i1hwjb));
}

float _nl4tl1(sampler2DShadow shadowtex, vec3 _i1hwjb) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return 1.0;
}
float shadow = texture(shadowtex, _i1hwjb);
return mix(1.0, shadow, _s4lpf1(_i1hwjb));
}

float _gmnstr(sampler2D shadowtex, vec3 _i1hwjb) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return 1.0;
}
float shadow = _q06ww9(shadowtex, _i1hwjb, 0.0);
return mix(1.0, shadow, _s4lpf1(_i1hwjb));
}

float _x245zo(sampler2D shadowtex, vec3 _i1hwjb, float viewDistance) {
float shadow = _gmnstr(shadowtex, _i1hwjb);
float _5jah4i = 1.0 - _xr26fh(_i1hwjb, viewDistance);
return mix(1.0, shadow, _5jah4i);
}

float _gmnstr(sampler2DShadow shadowtex, vec3 _i1hwjb) {
return _nl4tl1(shadowtex, _i1hwjb);
}

float _x245zo(sampler2D shadowtex, vec3 _i1hwjb, float _w02w60, float viewDistance, float _izh8vx) {
float shadow = _aykm1a(shadowtex, _i1hwjb, _w02w60, _izh8vx);
float _5jah4i = 1.0 - _xr26fh(_i1hwjb, viewDistance);
return mix(1.0, shadow, _5jah4i);
}

vec3 _5nbkwe(sampler2D shadowtex, sampler2D colortex, vec3 _i1hwjb, float _w02w60, float viewDistance, float _izh8vx) {
vec3 shadow = _nmx2gt(shadowtex, colortex, _i1hwjb, _w02w60, _izh8vx, 0.0);
float _5jah4i = 1.0 - _xr26fh(_i1hwjb, viewDistance);
return mix(vec3(1.0), shadow, _5jah4i);
}

float _x245zo(sampler2DShadow shadowtex, vec3 _i1hwjb, float viewDistance) {
float shadow = _nl4tl1(shadowtex, _i1hwjb);
float _5jah4i = 1.0 - _xr26fh(_i1hwjb, viewDistance);
return mix(1.0, shadow, _5jah4i);
}

float _x245zo(sampler2D shadowtex, vec3 _i1hwjb, vec3 _kffjyx, float viewDistance, float _izh8vx) {
float r = _55535n(_kffjyx.xy);
float _w02w60 = r + SHADOW_DISTORTION;
return _x245zo(shadowtex, _i1hwjb, _w02w60, viewDistance, _izh8vx);
}

float _u8jqzh(sampler2D shadowtex, vec3 _i1hwjb, float _w02w60, float _izh8vx) {
if (_i1hwjb.x < -0.01 || _i1hwjb.x > 1.01 ||
_i1hwjb.y < -0.01 || _i1hwjb.y > 1.01 ||
_i1hwjb.z < -0.01 || _i1hwjb.z > 1.01) {
return 1.0;
}

float _vujnw0 = (LEAF_SHADOW_SOFTNESS + _nin789()) * (1.0 / float(_qezbw4)) * _w02w60;
mat2 _42loy0 = _5whpln(6.28318 * _izh8vx) * _vujnw0;

float shadow = 0.0;
const int _r149mm = 6;
for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _42loy0 * blueNoiseDisk[i];
float _slnatl = texture(shadowtex, _i1hwjb.xy + _ja8cqx).r;
shadow += step(_i1hwjb.z, _slnatl);
}
shadow /= float(_r149mm);
return mix(1.0, shadow, _s4lpf1(_i1hwjb));
}

float _7t996k(sampler2D shadowtex, vec3 _i1hwjb, float _w02w60, float viewDistance, float _izh8vx) {
float shadow = _u8jqzh(shadowtex, _i1hwjb, _w02w60, _izh8vx);
float _5jah4i = 1.0 - _xr26fh(_i1hwjb, viewDistance);
return mix(1.0, shadow, _5jah4i);
}

const vec2 CAZTOON_LEAF1_SHADOW_MAP_BIAS_TEXELS = vec2(6.0, -4.0);

vec3 _tnoqzm(vec3 _i1hwjb) {
_i1hwjb.xy += CAZTOON_LEAF1_SHADOW_MAP_BIAS_TEXELS / float(_qezbw4);
return _i1hwjb;
}

float _sldrls(vec3 _i1hwjb) {
vec2 _eu3q17 = min(_i1hwjb.xy, 1.0 - _i1hwjb.xy);
float _a9osj3 = smoothstep(0.0, 0.015, min(_eu3q17.x, _eu3q17.y));
float _ncxkmi = smoothstep(0.0, 0.02, _i1hwjb.z) * (1.0 - smoothstep(0.98, 1.0, _i1hwjb.z));
return _a9osj3 * _ncxkmi;
}

float _ae8rwo(sampler2D shadowtex, vec3 _i1hwjb, float _w02w60, float viewDistance, float _izh8vx) {
vec3 _jcpol8 = _tnoqzm(_i1hwjb);
if (_jcpol8.x < -0.01 || _jcpol8.x > 1.01 ||
_jcpol8.y < -0.01 || _jcpol8.y > 1.01 ||
_jcpol8.z < -0.01 || _jcpol8.z > 1.01) {
return 1.0;
}

float _ysawue = min(_w02w60, max(SHADOW_DISTORTION, 0.10));
float _32jqi0 = min(12.0, SHADOW_DISTANCE * 0.10);
float _2m8dp2 = min(64.0, SHADOW_DISTANCE * 0.45);
float _oifh61 = smoothstep(_32jqi0, max(_2m8dp2, _32jqi0 + 1.0), viewDistance);
float _qa94t8 = mix(1.0, 0.08, _oifh61);
float _vujnw0 = (LEAF_SHADOW_SOFTNESS * 14.0 + 12.0 + _nin789())
* (1.0 / float(_qezbw4)) * _ysawue * _qa94t8;

vec2 _eu3q17 = min(_jcpol8.xy, 1.0 - _jcpol8.xy);
float _v0538k = max(min(_eu3q17.x, _eu3q17.y) - 1.0 / float(_qezbw4), 0.0);
_vujnw0 = min(_vujnw0, _v0538k / 4.10);
mat2 _42loy0 = _5whpln(6.28318 * _izh8vx) * _vujnw0;
mat2 _39ksqh = _5whpln(6.28318 * (_izh8vx + 0.37)) * _vujnw0 * 2.35;
mat2 _tff04k = _5whpln(6.28318 * (_izh8vx + 0.71)) * _vujnw0 * 4.10;

float shadow = 0.0;
float _1dknaf = _jcpol8.z - max(0.55 / float(_qezbw4), 0.00010);
const int _r149mm = 16;
for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _42loy0 * blueNoiseDisk[i];
float _slnatl = texture(shadowtex, _jcpol8.xy + _ja8cqx).r;
shadow += step(_1dknaf, _slnatl);
}
for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _39ksqh * blueNoiseDisk[i];
float _slnatl = texture(shadowtex, _jcpol8.xy + _ja8cqx).r;
shadow += step(_1dknaf, _slnatl);
}
for (int i = 0; i < _r149mm; ++i) {
vec2 _ja8cqx = _tff04k * blueNoiseDisk[i];
float _slnatl = texture(shadowtex, _jcpol8.xy + _ja8cqx).r;
shadow += step(_1dknaf, _slnatl);
}
shadow /= float(_r149mm * 3);
shadow = mix(1.0, shadow, 0.48);

return mix(1.0, shadow, _sldrls(_jcpol8));
}

float _elt4kp(sampler2D shadowtex, vec3 _i1hwjb, float _w02w60, float viewDistance, float _izh8vx) {

return _ae8rwo(shadowtex, _i1hwjb, _w02w60, viewDistance, _izh8vx);
}

#endif

#endif
