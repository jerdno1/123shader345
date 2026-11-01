/* RENDERTARGETS: 0,2,3 */

#include "/settings.glsl"
#include "/include/glass_reflection_payload.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex3;
uniform sampler2D colortex5;
uniform sampler2D colortex14;
uniform sampler2D depthtex0;
uniform sampler2D dhDepthTex;
uniform sampler2D noisetex;

uniform float sunAngle;
uniform float near;
uniform float far;
uniform float dhNearPlane;
uniform float dhFarPlane;
uniform float viewWidth;
uniform float viewHeight;
uniform int frameCounter;
uniform mat4 gbufferProjection;

in vec2 texcoord;

#include "/include/depth_utils.glsl"

float _25nezw(vec2 _5zlm8i) {
float _23zpod = texture(depthtex0, _5zlm8i).r;
float _cskgny = texture(dhDepthTex, _5zlm8i).r;

if (_23zpod >= 0.9999 && _cskgny < 0.9999) {
return _wf8ve2(_cskgny);
}
return _zdldl1(_23zpod);
}

float _i5vilq() {
return clamp(BLOOM_DISTANCE_COMPENSATION * 4.0, 0.0, 1.0);
}

float _2wbfev(float _co5r8t) {

float _ym4kyq = 1.73;
float _rsw0xq = max(gbufferProjection[1][1] / _ym4kyq, 0.35);
return _co5r8t / _rsw0xq;
}

float _c012cp(float _k5zkk5) {
float _i8h94i = smoothstep(10.0, 28.0, _k5zkk5);
float _9vv2yd = smoothstep(26.0, 84.0, _k5zkk5);
float _49e3a8 = smoothstep(180.0, 320.0, _k5zkk5);
return clamp(1.0 + _i8h94i * 0.30 + _9vv2yd * 0.95 - _49e3a8 * 0.35, 1.0, 2.25);
}

float _zfos97(float _k5zkk5) {
float _i8h94i = smoothstep(8.0, 24.0, _k5zkk5);
float _9vv2yd = smoothstep(24.0, 84.0, _k5zkk5);
float _49e3a8 = smoothstep(180.0, 320.0, _k5zkk5);
return clamp(1.0 + _i8h94i * 0.45 + _9vv2yd * 1.20 - _49e3a8 * 0.55, 1.0, 2.6);
}

float _2ae57a(vec2 uv) {
vec2 _s4ja50 = 1.0 / vec2(textureSize(colortex1, 0));
float _xoryyp = 0.0;

_xoryyp += step(0.001, texture(colortex1, uv).g) * 0.18;

_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2(-_s4ja50.x, 0.0), vec2(0.0), vec2(1.0))).g) * 0.12;
_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2( _s4ja50.x, 0.0), vec2(0.0), vec2(1.0))).g) * 0.12;
_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2(0.0, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.12;
_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2(0.0,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.12;

_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2(-_s4ja50.x, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;
_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2( _s4ja50.x, -_s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;
_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2(-_s4ja50.x,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;
_xoryyp += step(0.001, texture(colortex1, clamp(uv + vec2( _s4ja50.x,  _s4ja50.y), vec2(0.0), vec2(1.0))).g) * 0.08;

return clamp(_xoryyp, 0.0, 1.0);
}

float _34mudp(vec2 uv) {
float _8zni7d = texture(colortex1, uv).a;
return step(0.31, _8zni7d) * (1.0 - step(0.71, _8zni7d));
}

vec3 _5ui4qa(vec3 _z1bnjj) {
float _muha68 = max(max(_z1bnjj.r, _z1bnjj.g), _z1bnjj.b);
if (_muha68 < 0.0001) return vec3(0.0);

vec3 _e30o2u = _z1bnjj / _muha68;
float _2hu5fo = clamp((_e30o2u.r - _e30o2u.b) * 0.90 + _e30o2u.g * 0.35, 0.0, 1.0);
float _f4iqtk = clamp((max(_e30o2u.g, _e30o2u.b) - _e30o2u.r) * 0.65, 0.0, 1.0);
float _ach6ay = _muha68 * (1.0 + _2hu5fo * 0.18 - _f4iqtk * 0.04);

vec3 _ys0xcs = _e30o2u;
_ys0xcs.r = max(_ys0xcs.r, _2hu5fo * 0.16);
_ys0xcs.g = mix(_ys0xcs.g, max(_ys0xcs.g, 0.42), _2hu5fo * 0.16);

return _ys0xcs * _ach6ay;
}

vec3 _wxnwmu(vec2 uv, float _d8tv7f, float _a1ex2w, float _b6l2t2, float _1vbkuk) {
uv = clamp(uv, vec2(0.0), vec2(1.0));
float emissive = texture(colortex1, uv).g;
if (emissive <= 0.001 || _d8tv7f <= 0.0) return vec3(0.0);

vec3 _b2t6pq = _5ui4qa(texture(colortex3, uv).rgb);
float _4tvv6o = _34mudp(uv);
float _k5zkk5 = _2wbfev(_25nezw(uv));

float _1fnb30 = 1.0 / (1.0 + _k5zkk5 * 0.03);
float _1hhypt = _1fnb30 * mix(1.0, ENTITY_BLOOM_STRENGTH, _4tvv6o);
float _orlgti = mix(1.0, ENTITY_BLOOM_RADIUS, _4tvv6o);
float _l6noes = _d8tv7f * mix(1.0, _orlgti, _a1ex2w);
float _sh5h7g = _2ae57a(uv);
float _00qc25 = smoothstep(0.16, 0.68, _sh5h7g);
float _ejyy2n = 1.0 - smoothstep(0.08, 0.38, _sh5h7g);

_00qc25 = mix(_00qc25, max(_00qc25, 0.82), _4tvv6o * smoothstep(1.0, 2.0, ENTITY_BLOOM_RADIUS));
_ejyy2n *= mix(1.0, 1.0 / max(ENTITY_BLOOM_RADIUS, 0.1), _4tvv6o * 0.35);

float _apkqux = max(_00qc25 + _ejyy2n, 0.0001);
_00qc25 /= _apkqux;
_ejyy2n /= _apkqux;
float _xs6kin = mix(_00qc25, _ejyy2n, _1vbkuk);

return _b2t6pq * _1hhypt * _l6noes * _xs6kin;
}

void main() {
vec4 _10julw = texture(colortex0, texcoord);
vec3 _yssmf1 = _10julw.rgb;
float _iwav6y = _10julw.a;

#ifdef MATERIAL_REFLECTIONS_ENABLED
{
ivec2 _lgrsgs = ivec2(gl_FragCoord.xy);
vec4 _vywfk7 = texelFetch(colortex14, _lgrsgs, 0);

if (_vywfk7.a > 0.5) {
vec4 _a2jf3a = texelFetch(colortex5, _lgrsgs, 0);
vec4 _alcc4c = texelFetch(colortex1, _lgrsgs, 0);

bool _h0kpgg = (_a2jf3a.z > 0.001 || _a2jf3a.w > 0.001)
&& !(_alcc4c.a > 0.01 && _alcc4c.a < 0.99)
&& (_a2jf3a.y < 0.9);

if (_h0kpgg) {

bool _uko4cx = _r0mj6q(_a2jf3a.y);
vec3 _tpt5zg = vec3(_a2jf3a.z * 2.0 - 1.0, _a2jf3a.w * 2.0 - 1.0, 0.0);
float _nakod7 = _uko4cx
? _olzjaf(_a2jf3a.y)
: 1.0;
_tpt5zg.z = sqrt(max(1.0 - dot(_tpt5zg.xy, _tpt5zg.xy), 0.0)) * _nakod7;

float _xf8iqa = clamp(_a2jf3a.x, 0.0, 1.0);

float _izh8vx = texture(noisetex, gl_FragCoord.xy / 128.0).b;
vec2 px = vec2(1.0 / viewWidth, 1.0 / viewHeight);

float _2gthma = 1.0 - sqrt(_xf8iqa);
const float _kdg4u2 = 2.5;
const float _9n7cf7 = 2.0 * _kdg4u2 * _kdg4u2;
vec2 _s4ja50 = (3.0 + 6.0 * _izh8vx) * px;
_s4ja50 *= 1.0 - 0.75 * pow(_2gthma, 8.0);

vec4 _idhca6 = vec4(0.0);
float _gnhxr2 = 0.0;
const int K = 2;
for (int dy = -K; dy <= K; dy++) {
for (int dx = -K; dx <= K; dx++) {
vec2 _ja8cqx = vec2(float(dx), float(dy)) * _s4ja50;
vec2 _q9sbm4 = texcoord + _ja8cqx;
if (_q9sbm4.x < 0.0 || _q9sbm4.x > 1.0 ||
_q9sbm4.y < 0.0 || _q9sbm4.y > 1.0) continue;

ivec2 _s8s9ng = clamp(ivec2(_q9sbm4 * vec2(viewWidth, viewHeight)), ivec2(0), ivec2(viewWidth - 1.0, viewHeight - 1.0));

vec4 _pes4j2 = texelFetch(colortex5, _s8s9ng, 0);
bool _2rddek = _r0mj6q(_pes4j2.y);
if (_2rddek != _uko4cx) continue;
vec3 _9qjtmi = vec3(_pes4j2.z * 2.0 - 1.0, _pes4j2.w * 2.0 - 1.0, 0.0);
float _jq0zxq = _2rddek
? _olzjaf(_pes4j2.y)
: 1.0;
_9qjtmi.z = sqrt(max(1.0 - dot(_9qjtmi.xy, _9qjtmi.xy), 0.0)) * _jq0zxq;
if (length(_tpt5zg - _9qjtmi) > 0.1) continue;

vec4 _4konem = texelFetch(colortex14, _s8s9ng, 0);
if (_4konem.a < 0.95) continue;

float _s2b0vv = float(dx * dx + dy * dy);
float w = exp(-_s2b0vv / _9n7cf7);

_idhca6 += _4konem * w;
_gnhxr2 += w;
}
}

if (_gnhxr2 > 0.001) {
vec3 _5ceb8v = _idhca6.rgb / _gnhxr2;
float _mb2qqk = dot(_5ceb8v, vec3(0.299, 0.587, 0.114));
_5ceb8v = mix(vec3(_mb2qqk), _5ceb8v, 0.72);

float _e29z4i = _uko4cx
? 0.0
: clamp(_a2jf3a.y / 0.85, 0.0, 1.0);

float _13rsme = _alcc4c.b;
float _41xwde = smoothstep(0.5, 1.0, _13rsme);
float _my3ebg = _e29z4i * 0.15 * (1.0 - _41xwde);
float _kki5ur = mix(1.0, 0.3, _41xwde);
const float _bnwcus = 1.75;
float _2qm5s8 = _uko4cx ? 5.0 : 1.0;
float _v31tbv = (_kki5ur + _my3ebg) * _bnwcus * _2qm5s8;
_yssmf1 = max(_yssmf1 + _5ceb8v * _v31tbv, vec3(0.0));
}
}
}
}
#endif

gl_FragData[0] = vec4(_yssmf1, _iwav6y);

#ifdef BLOOM_ENABLED
vec3 _br4xl4 = vec3(0.0);
vec3 _sav3qg = vec3(0.0);
float _b6l2t2 = _i5vilq();
vec2 _s4ja50 = 1.0 / vec2(textureSize(colortex3, 0));

_br4xl4 += _wxnwmu(texcoord, 0.60, 0.0, _b6l2t2, 0.0);
_sav3qg += _wxnwmu(texcoord, 0.32, 0.0, _b6l2t2, 1.0);

_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x, 0.0), 0.34, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x, 0.0), 0.34, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(0.0, -_s4ja50.y), 0.34, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(0.0,  _s4ja50.y), 0.34, 1.0, _b6l2t2, 0.0);

_sav3qg += _wxnwmu(texcoord + vec2(-_s4ja50.x, 0.0), 0.20, 0.0, _b6l2t2, 1.0);
_sav3qg += _wxnwmu(texcoord + vec2( _s4ja50.x, 0.0), 0.20, 0.0, _b6l2t2, 1.0);
_sav3qg += _wxnwmu(texcoord + vec2(0.0, -_s4ja50.y), 0.20, 0.0, _b6l2t2, 1.0);
_sav3qg += _wxnwmu(texcoord + vec2(0.0,  _s4ja50.y), 0.20, 0.0, _b6l2t2, 1.0);

_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x, -_s4ja50.y), 0.24, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x, -_s4ja50.y), 0.24, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x,  _s4ja50.y), 0.24, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x,  _s4ja50.y), 0.24, 1.0, _b6l2t2, 0.0);

_sav3qg += _wxnwmu(texcoord + vec2(-_s4ja50.x, -_s4ja50.y), 0.12, 0.0, _b6l2t2, 1.0);
_sav3qg += _wxnwmu(texcoord + vec2( _s4ja50.x, -_s4ja50.y), 0.12, 0.0, _b6l2t2, 1.0);
_sav3qg += _wxnwmu(texcoord + vec2(-_s4ja50.x,  _s4ja50.y), 0.12, 0.0, _b6l2t2, 1.0);
_sav3qg += _wxnwmu(texcoord + vec2( _s4ja50.x,  _s4ja50.y), 0.12, 0.0, _b6l2t2, 1.0);

_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x * 2.0, 0.0), 0.18, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x * 2.0, 0.0), 0.18, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(0.0, -_s4ja50.y * 2.0), 0.18, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(0.0,  _s4ja50.y * 2.0), 0.18, 1.0, _b6l2t2, 0.0);

_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x * 2.0, -_s4ja50.y * 2.0), 0.12, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x * 2.0, -_s4ja50.y * 2.0), 0.12, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x * 2.0,  _s4ja50.y * 2.0), 0.12, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x * 2.0,  _s4ja50.y * 2.0), 0.12, 1.0, _b6l2t2, 0.0);

_br4xl4 += _wxnwmu(texcoord + vec2(-_s4ja50.x * 3.0, 0.0), 0.08, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2( _s4ja50.x * 3.0, 0.0), 0.08, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(0.0, -_s4ja50.y * 3.0), 0.08, 1.0, _b6l2t2, 0.0);
_br4xl4 += _wxnwmu(texcoord + vec2(0.0,  _s4ja50.y * 3.0), 0.08, 1.0, _b6l2t2, 0.0);

float _1zk16v = 1.0;
#ifndef END_SHADER
float _wjktp9 = texture(colortex1, texcoord).b;
float _yvwwnt = texture(colortex1, texcoord).g;
float _xya605 = smoothstep(0.02, 0.10, fract(sunAngle)) * (1.0 - smoothstep(0.40, 0.48, fract(sunAngle)));

float _6yzilx = (_yvwwnt > 0.001) ? _wjktp9 : 1.0;
_1zk16v = mix(1.0, BLOOM_DAY_STRENGTH, _xya605 * _6yzilx);
#endif

float _dqcdoi = _25nezw(texcoord);
float _v76y7h = clamp(_dqcdoi / 512.0, 0.0, 1.0);

#ifdef END_SHADER
{
float _fa8lyp = texture(depthtex0, texcoord).r;
if (_fa8lyp >= 0.9999) {
float _vz05vc = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
vec3 _ler6dk = vec3(0.5, 0.2, 0.7) * _vz05vc;
_br4xl4 += _ler6dk;
}
}
#endif

float _4wx69b = (length(_br4xl4) > 0.001) ? _v76y7h : 0.0;
float _jm0qw5 = (length(_sav3qg) > 0.001) ? _v76y7h : 0.0;
gl_FragData[1] = vec4(_br4xl4 * BLOOM_INTENSITY * BLOOM_CLOSE_STRENGTH * _1zk16v, _4wx69b);
gl_FragData[2] = vec4(_sav3qg * BLOOM_INTENSITY * BLOOM_FAR_STRENGTH * _1zk16v, _jm0qw5);
#else
gl_FragData[1] = vec4(0.0);
gl_FragData[2] = vec4(0.0);
#endif
}
