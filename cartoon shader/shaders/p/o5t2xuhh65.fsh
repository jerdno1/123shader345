/* RENDERTARGETS: 0,1 */

#extension GL_ARB_shader_storage_buffer_object : require

#include "/settings.glsl"
#include "/include/color_utils.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/sky_timeline.glsl"

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

uniform float sunAngle;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform mat4 gbufferModelViewInverse;
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
uniform sampler2D noisetex;
uniform vec3 sunPosition;
uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

in vec3 viewPos;
in vec4 starColor;

float _ewpw6c(float p) {
p = fract(p * 0.1031);
p *= p + 33.33;
p *= p + p;
return fract(p);
}

float _v11u7s(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * 0.1031);
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.x + p3.y) * p3.z);
}

vec2 _ygigvq(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
p3 += dot(p3, p3.yzx + 33.33);
return fract((p3.xx + p3.yz) * p3.zy);
}

vec3 _yhq4kl(vec3 p) {
p = fract(p * vec3(0.1031, 0.1030, 0.0973));
p += dot(p, p.yxz + 33.33);
return fract((p.xxy + p.yxx) * p.zyx);
}

vec3 _f4c3gv(vec3 v, float _huatah) {
float c = cos(_huatah);
float s = sin(_huatah);
return vec3(v.x, v.y * c - v.z * s, v.y * s + v.z * c);
}

vec3 _2q5tj8(vec3 v, float _huatah) {
float c = cos(_huatah);
float s = sin(_huatah);
return vec3(v.x * c + v.z * s, v.y, -v.x * s + v.z * c);
}

vec3 _1i0dkg(vec3 v, float _huatah) {
float c = cos(_huatah);
float s = sin(_huatah);
return vec3(v.x * c - v.y * s, v.x * s + v.y * c, v.z);
}

vec3 _cp2up7(vec3 _llxraj) {

float _ovqpxg = radians(_cej4mm);
_llxraj = _1i0dkg(_llxraj, _ovqpxg);

float _ep7l7i = sunAngle * 6.28318;
_llxraj = _f4c3gv(_llxraj, _ep7l7i);

return _llxraj;
}

vec2 _27w4zi(vec3 _llxraj) {
vec3 _5v93f1 = abs(_llxraj);
vec2 uv;
float face;

if (_5v93f1.x >= _5v93f1.y && _5v93f1.x >= _5v93f1.z) {
uv = _llxraj.zy / _5v93f1.x;
face = _llxraj.x > 0.0 ? 0.0 : 1.0;
} else if (_5v93f1.y >= _5v93f1.x && _5v93f1.y >= _5v93f1.z) {
uv = _llxraj.xz / _5v93f1.y;
face = _llxraj.y > 0.0 ? 2.0 : 3.0;
} else {
uv = _llxraj.xy / _5v93f1.z;
face = _llxraj.z > 0.0 ? 4.0 : 5.0;
}

uv += face * 100.0;
return uv;
}

float _yu471x(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * (3.0 - 2.0 * f);

float a = _v11u7s(i);
float b = _v11u7s(i + vec2(1.0, 0.0));
float c = _v11u7s(i + vec2(0.0, 1.0));
float d = _v11u7s(i + vec2(1.0, 1.0));

return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float _rlbob2(vec2 p, int _c5iapm) {
float _ino0s9 = 0.0;
float _2qekwd = 0.5;
float _a4mjmv = 1.0;

for (int i = 0; i < _c5iapm; i++) {
_ino0s9 += _2qekwd * _yu471x(p * _a4mjmv);
_2qekwd *= 0.5;
_a4mjmv *= 2.0;
}

return _ino0s9;
}

float _hjxr3d(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);

float _tm2ehs = 1.0;
for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 _kthqft = vec2(float(x), float(y));
vec2 _j5jwle = _ygigvq(i + _kthqft);
vec2 _zvczxm = _kthqft + _j5jwle - f;
float d = length(_zvczxm);
_tm2ehs = min(_tm2ehs, d);
}
}
return _tm2ehs;
}

float _9mmvvk(vec3 _llxraj, float _bim3ym) {
_llxraj = normalize(_llxraj);

_llxraj = _cp2up7(_llxraj);

vec2 _ufcu6o = _27w4zi(_llxraj) * STAR_SCALE;

vec2 _h908e6 = floor(_ufcu6o);
vec2 _pjm5wu = fract(_ufcu6o);

float _6hl4a5 = 0.0;

for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 nc = _h908e6 + vec2(x, y);

float _2xxeoy = _v11u7s(nc);
if (_2xxeoy > STAR_DENSITY) continue;

vec2 sp = _ygigvq(nc) * 0.6 + 0.2;

vec2 d = _pjm5wu - vec2(x, y) - sp;
float _t25r5m = length(d);

float _3j5sp9 = 0.4 + _v11u7s(nc + 500.0) * 0.6;

float _j1b98s = _v11u7s(nc + 700.0) * 6.28318;
float _pcghs4 = 0.5 + _v11u7s(nc + 800.0) * 2.0;
float _gg05ax = 0.7 + 0.3 * sin(_bim3ym * _pcghs4 + _j1b98s);

float _dq2uwi = _v11u7s(nc + 900.0);
_gg05ax = mix(1.0, _gg05ax, _dq2uwi * STAR_TWINKLE);

float _ulytmb = _3j5sp9 * _gg05ax * STAR_BRIGHTNESS;

float _nr5rfo = STAR_SIZE * (0.5 + _v11u7s(nc + 400.0) * 0.5);

float s = 1.0 - smoothstep(0.0, _nr5rfo, _t25r5m);
_6hl4a5 = max(_6hl4a5, s * _ulytmb);
}
}

return _6hl4a5;
}

vec3 _72p72f(vec3 _llxraj, float _bim3ym) {
_llxraj = normalize(_llxraj);

_llxraj = _cp2up7(_llxraj);

vec3 _8izj9y = vec3(0.0);

for (int i = 0; i < 3; i++) {

float _xy4mk0 = float(i) * 47.0;
float _3v0h8k = 15.0 + _ewpw6c(_xy4mk0) * 20.0;
float t = mod(_bim3ym + _xy4mk0, _3v0h8k);

float _fkxviz = 0.5 + _ewpw6c(_xy4mk0 + 10.0) * 1.0;
if (t > _fkxviz) continue;

float _tqnl3k = _ewpw6c(_xy4mk0 + 20.0) * 6.28318;
float _37c6ge = 0.2 + _ewpw6c(_xy4mk0 + 30.0) * 0.6;
vec3 _rducww = vec3(
cos(_tqnl3k) * cos(_37c6ge),
sin(_37c6ge),
sin(_tqnl3k) * cos(_37c6ge)
);

float _tepzih = _ewpw6c(_xy4mk0 + 40.0) * 6.28318;
vec3 _yor7k9 = vec3(cos(_tepzih), -0.3, sin(_tepzih));
_yor7k9 = normalize(_yor7k9);

float _9lasr8 = 0.3 + _ewpw6c(_xy4mk0 + 50.0) * 0.4;
vec3 _cfpe4s = _rducww + _yor7k9 * t * _9lasr8;
_cfpe4s = normalize(_cfpe4s);

float _yhk26k = acos(clamp(dot(_llxraj, _cfpe4s), -1.0, 1.0));

vec3 _2fsb5y = _llxraj - _cfpe4s;
float _4ezzmy = dot(_2fsb5y, _yor7k9);
float _j2p78c = length(_2fsb5y - _yor7k9 * _4ezzmy);

float _xzuadt = 0.003;
float _ppxmoo = 0.08 * (1.0 - t / _fkxviz);

if (_j2p78c < _xzuadt && _4ezzmy > -_ppxmoo && _4ezzmy < 0.01) {
float _0v7t0i = (1.0 - _j2p78c / _xzuadt);
_0v7t0i *= smoothstep(-_ppxmoo, 0.0, _4ezzmy);
_0v7t0i *= 1.0 - t / _fkxviz;
_0v7t0i *= STAR_SHOOTING_BRIGHTNESS;

_8izj9y += vec3(0.9, 0.95, 1.0) * _0v7t0i;
}
}

return _8izj9y;
}

vec3 _juwfwp(vec3 _h8ie4b, vec3 _3p73xa, vec3 _61es6w, float height, float _nklv5c, float _s04wi4) {
float h = clamp(height, 0.0, 1.0);

float _of8wg5 = clamp(DAY_ZENITH_HEIGHT, 0.45, 0.95);
float t = smoothstep(0.0, _of8wg5, h);
return mix(_h8ie4b, _61es6w, t);
}

#include "/include/ringed_planet.glsl"

#ifdef END_SKY_ENABLED

#ifdef END_STARS_ENABLED
vec3 _6ux19b(vec3 _llxraj, float _bim3ym) {
_llxraj = normalize(_llxraj);
vec2 _ufcu6o = _27w4zi(_llxraj) * STAR_SCALE;

vec2 _h908e6 = floor(_ufcu6o);
vec2 _pjm5wu = fract(_ufcu6o);

vec3 _8izj9y = vec3(0.0);

for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 nc = _h908e6 + vec2(float(x), float(y));

float _2xxeoy = _v11u7s(nc);
if (_2xxeoy > END_STAR_DENSITY) continue;

vec2 sp = _ygigvq(nc) * 0.6 + 0.2;
vec2 d = _pjm5wu - vec2(float(x), float(y)) - sp;
float _t25r5m = length(d);

float _3j5sp9 = 0.4 + _v11u7s(nc + 500.0) * 0.6;

float _j1b98s = _v11u7s(nc + 700.0) * 6.28318;
float _pcghs4 = 0.5 + _v11u7s(nc + 800.0) * 2.0;
float _gg05ax = 0.7 + 0.3 * sin(_bim3ym * _pcghs4 + _j1b98s);

float _ulytmb = _3j5sp9 * _gg05ax * END_STAR_BRIGHTNESS;

float _nr5rfo = STAR_SIZE * (0.5 + _v11u7s(nc + 400.0) * 0.5);
float s = 1.0 - smoothstep(0.0, _nr5rfo, _t25r5m);

vec3 _w1xm0p = vec3(1.0);
if (END_STAR_COLOR_SHIFT > 0.0) {
float _49znj4 = _v11u7s(nc + 1000.0);
vec3 tint;
if (_49znj4 < 0.3) {
tint = vec3(0.7, 0.5, 1.0);
} else if (_49znj4 < 0.55) {
tint = vec3(0.4, 0.7, 1.0);
} else if (_49znj4 < 0.75) {
tint = vec3(0.3, 0.9, 0.8);
} else {
tint = vec3(1.0, 0.95, 0.9);
}
_w1xm0p = mix(vec3(1.0), tint, END_STAR_COLOR_SHIFT);
}

_8izj9y = max(_8izj9y, _w1xm0p * s * _ulytmb);
}
}

return _8izj9y;
}
#endif

#ifdef END_NEBULA_ENABLED
vec3 _fbevfo(vec3 _llxraj, float _bim3ym) {

vec2 uv = vec2(atan(_llxraj.z, _llxraj.x), asin(clamp(_llxraj.y, -1.0, 1.0)));
uv *= END_NEBULA_SCALE;

float _pnr1f3 = _bim3ym * END_NEBULA_SPEED;
vec2 _8e9vz4 = uv + vec2(_pnr1f3, _pnr1f3 * 0.3);
vec2 _tq4dba = uv + vec2(-_pnr1f3 * 0.7, _pnr1f3 * 0.5);

float _wxhfvt = _rlbob2(_8e9vz4 * 0.6, 5);
float _u26ghr = _rlbob2(_tq4dba * 0.8 + vec2(50.0, 25.0), 4);

float _0nf46u = _rlbob2(_8e9vz4 * 1.2 + vec2(100.0, 50.0), 4);

float _o3riww = _rlbob2(uv * 0.4 + vec2(-30.0, 80.0) + _pnr1f3 * 0.3, 3);

float v = _hjxr3d(_8e9vz4 * 2.0);

float _s0a22j = smoothstep(0.20, 0.55, _wxhfvt);
_s0a22j *= 0.5 + 0.5 * smoothstep(0.15, 0.50, _u26ghr);

_s0a22j *= 0.6 + 0.4 * smoothstep(0.25, 0.60, _0nf46u);

_s0a22j *= 0.6 + 0.4 * (1.0 - smoothstep(0.0, 0.5, v));

float _x9g3a3 = smoothstep(0.50, 0.80, _wxhfvt) * 0.5;
_s0a22j += _x9g3a3;

vec3 _8tqn4j = vec3(END_NEBULA_R1, END_NEBULA_G1, END_NEBULA_B1);
vec3 _ae2wjm = vec3(END_NEBULA_R2, END_NEBULA_G2, END_NEBULA_B2);
float _0dw0rl = smoothstep(0.3, 0.7, _o3riww);
vec3 _5lwty5 = mix(_8tqn4j, _ae2wjm, _0dw0rl);

vec3 _fyiobc = vec3(0.7, 0.6, 0.9) * smoothstep(0.70, 0.95, _wxhfvt) * 0.3;

return (_5lwty5 * _s0a22j + _fyiobc) * END_NEBULA_INTENSITY;
}
#endif

#ifdef END_AURORA_ENABLED
vec3 _zuvn42(vec3 _llxraj, float _bim3ym) {
float _ra294w = _llxraj.y;
if (_ra294w < 0.02) return vec3(0.0);

float _lejoh7 = smoothstep(0.02, max(END_AURORA_HEIGHT * 0.3, 0.0201), _ra294w)
* (1.0 - smoothstep(END_AURORA_HEIGHT * 0.5, END_AURORA_HEIGHT + 0.3, _ra294w));

float _huatah = atan(_llxraj.z, _llxraj.x);

float _fi57z9 = sin(_huatah * 3.0 + _bim3ym * END_AURORA_SPEED * 0.7) * 0.5 + 0.5;
float _0it7cy = sin(_huatah * 5.0 - _bim3ym * END_AURORA_SPEED * 1.1 + 2.0) * 0.5 + 0.5;
float _2xuuow = sin(_huatah * 7.0 + _bim3ym * END_AURORA_SPEED * 0.4 + 4.5) * 0.5 + 0.5;
float _nj8hqt = sin(_huatah * 2.0 + _bim3ym * END_AURORA_SPEED * 0.9 + 1.0) * 0.5 + 0.5;

float _akoorp = _yu471x(vec2(_huatah * 2.0, _bim3ym * END_AURORA_SPEED * 0.3));
float _8ystdl = sin(_ra294w * 12.0 + _akoorp * 4.0 + _bim3ym * END_AURORA_SPEED) * 0.5 + 0.5;

float _yyc6b6 = _yu471x(vec2(_huatah * 4.0 + _bim3ym * 0.05, _ra294w * 8.0));
_yyc6b6 = smoothstep(0.1, 0.6, _yyc6b6);

float _hygsf5 = _fi57z9 * _0it7cy * 0.5 + _2xuuow * 0.3 + _nj8hqt * 0.2;
_hygsf5 *= _8ystdl;
_hygsf5 *= 0.6 + 0.4 * _yyc6b6;
_hygsf5 = pow(_hygsf5, 1.5);

vec3 _8tqn4j = vec3(END_AURORA_R1, END_AURORA_G1, END_AURORA_B1);
vec3 _ae2wjm = vec3(END_AURORA_R2, END_AURORA_G2, END_AURORA_B2);
float _d9tmy2 = sin(_huatah * 2.0 + _bim3ym * END_AURORA_SPEED * 0.2) * 0.5 + 0.5;
vec3 _l1mtos = mix(_8tqn4j, _ae2wjm, _d9tmy2);

return _l1mtos * _hygsf5 * _lejoh7 * END_AURORA_INTENSITY;
}
#endif

#ifdef END_VOID_PARTICLES_ENABLED
vec3 _i7ycxr(vec3 _llxraj, float _bim3ym) {
_llxraj = normalize(_llxraj);
vec2 _7szgzz = _27w4zi(_llxraj) * 30.0;

vec2 _h908e6 = floor(_7szgzz);
vec2 _pjm5wu = fract(_7szgzz);

vec3 _8izj9y = vec3(0.0);

for (int x = -1; x <= 1; x++) {
for (int y = -1; y <= 1; y++) {
vec2 nc = _h908e6 + vec2(float(x), float(y));

float _2xxeoy = _v11u7s(nc + vec2(200.0, 300.0));
if (_2xxeoy > END_VOID_PARTICLE_DENSITY) continue;

vec2 sp = _ygigvq(nc + vec2(200.0, 300.0)) * 0.6 + 0.2;

float _vx5wz6 = _v11u7s(nc + vec2(500.0, 600.0)) * 6.28318;
float _9e8wbp = 0.3 + _v11u7s(nc + vec2(700.0, 800.0)) * 1.5;
float _zyuid3 = 0.5 + 0.5 * sin(_bim3ym * _9e8wbp + _vx5wz6);

float _31786g = sin(_bim3ym * 0.1 + _vx5wz6) * 0.02;
float _whh2fa = cos(_bim3ym * 0.08 + _vx5wz6 * 1.3) * 0.02;

vec2 d = _pjm5wu - vec2(float(x), float(y)) - sp + vec2(_31786g, _whh2fa);
float _t25r5m = length(d);

float _ogil6l = 1.0 - smoothstep(0.0, 0.04, _t25r5m);
_ogil6l *= _zyuid3;

float _lotpgi = _v11u7s(nc + vec2(900.0, 100.0));
vec3 _in6bp0 = mix(vec3(0.6, 0.2, 1.0), vec3(0.2, 0.8, 0.9), _lotpgi);

_8izj9y += _in6bp0 * _ogil6l * END_VOID_PARTICLE_BRIGHTNESS * 0.3;
}
}

return _8izj9y;
}
#endif

vec3 _hijiov(vec3 _st4awd, float _bim3ym) {
float height = _jh7gqv(max(_st4awd.y, 0.0));

vec3 _xyezyl = vec3(END_SKY_HORIZON_R, END_SKY_HORIZON_G, END_SKY_HORIZON_B);
vec3 _gbifj2 = vec3(END_SKY_MID_R, END_SKY_MID_G, END_SKY_MID_B);
vec3 _riel36 = vec3(END_SKY_ZENITH_R, END_SKY_ZENITH_G, END_SKY_ZENITH_B);

vec3 _od2x3w = _juwfwp(_xyezyl, _gbifj2, _riel36, height, 0.25, 0.65);

if (_st4awd.y < 0.0) {
float _w35u7s = 1.0 - smoothstep(-0.4, 0.0, _st4awd.y);
#ifdef END_FOG_ENABLED
vec3 _2rme2p = vec3(END_FOG_R, END_FOG_G, END_FOG_B);
#else
vec3 _2rme2p = _xyezyl * 0.3;
#endif
_od2x3w = mix(_xyezyl, _2rme2p, _w35u7s);
}

_od2x3w *= END_SKY_BRIGHTNESS;

#ifdef END_STARS_ENABLED
_od2x3w += _6ux19b(_st4awd, _bim3ym);
#endif

#ifdef END_NEBULA_ENABLED
_od2x3w += _fbevfo(_st4awd, _bim3ym);
#endif

#ifdef END_AURORA_ENABLED
_od2x3w += _zuvn42(_st4awd, _bim3ym);
#endif

#ifdef END_VOID_PARTICLES_ENABLED
_od2x3w += _i7ycxr(_st4awd, _bim3ym);
#endif

return _od2x3w;
}

#endif

#include "/include/clouds_2d.glsl"

#include "/include/night_effects.glsl"

vec3 _z28ws4(vec3 _yssmf1, float _a8645a) {
vec3 _s0lzby = _j0nlr9(_yssmf1);
_s0lzby.y = clamp(_s0lzby.y * _a8645a, 0.0, 1.0);
return _ks5u3i(_s0lzby);
}

float _jh7gqv(float h) {
float x = clamp(h, 0.0, 1.0);
float _i0turt = max(SKY_GRADIENT_CURVE, 0.001);
return pow(x, 1.0 / _i0turt);
}

vec3 _dyo4p6(vec3 _x2q5fe, vec3 _7ty3xo, float _kc9t4n) {
return mix(_x2q5fe, _7ty3xo, clamp(_kc9t4n, 0.0, 1.0));
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

void main() {

vec3 viewDir = normalize(viewPos);
vec3 _st4awd = normalize(mat3(gbufferModelViewInverse) * viewDir);

#ifdef NETHER_FOG_ENABLED
if (_9cwhip(biome)) {
vec3 _s95hxf = _ktauxr(biome, vec3(NETHER_FOG_R, NETHER_FOG_G, NETHER_FOG_B));
gl_FragData[0] = vec4(_s95hxf * 0.15, 1.0);
gl_FragData[1] = vec4(0.0);
return;
}
#endif

if (_0rit85()) {
vec3 _mzunbj = max(fogColor, skyColor * 0.8);
gl_FragData[0] = vec4(_mzunbj, 1.0);
gl_FragData[1] = vec4(0.0);
return;
}

float _e3aar4 = _jh7gqv(max(_st4awd.y, 0.0));
float _huatah = fract(sunAngle);

TimeWeights tw = getTimeWeights(sunAngle);
float _p6xjdc = tw.day;
float twilight = tw.sunset + tw.sunrise;
float blueHour = tw.blueHour + tw.dawn;
float _6tk9k5 = tw.night;

float _kaxwu0 = _p6xjdc;
float _hmmwvh = twilight;
float _2iwsel = blueHour;
float _pxf9l0 = _6tk9k5;

vec3 _h4of6g = vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B);
vec3 _30f0tp = vec3(DAY_MID_R, DAY_MID_G, DAY_MID_B);
vec3 _gmfo88 = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);
vec3 _mw99cp = _h4of6g;
vec3 _evq3fl = _30f0tp;
vec3 _mzcgmx = _gmfo88;

vec3 _x70tse = _tvhml8(fogColor);
vec3 _bonu7f = _un92z1(skyColor);
float _rxs39p = _jpbsbi(biome_snowy);
float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
float _2d13on = _avnajg(biome_jungle, biome, biome_category, _lfojrz);
float _9yfvgh = _za404r(biome_arid);
float _fgx2j8 = _g4a6za(_i0sr2e(biome_savanna), _lfojrz);
float _xmiuzq = _90d23l(biome_ocean);
float _ypru3e = _5pe64i(_9yfvgh, _fgx2j8);
float _6kr23z = clamp(biome_pale_garden, 0.0, 1.0);
#ifndef OVERWORLD_BIOME_SKY_ENABLED

_rxs39p = 0.0;
_lfojrz = 0.0;
_2d13on = 0.0;
_9yfvgh = 0.0;
_fgx2j8 = 0.0;
_xmiuzq = 0.0;
_ypru3e = 0.0;
_6kr23z = 0.0;
#endif
vec3 _6epga1 = _e6gplv();
vec3 _9ubczf = _b8134m();
vec3 _0ngtua = _d36tdk();

if (_rxs39p > 0.001) {
_mw99cp = mix(_mw99cp, vec3(0.92, 0.94, 0.96), _rxs39p);
_evq3fl = mix(_evq3fl, vec3(0.88, 0.91, 0.95), _rxs39p);
_mzcgmx = mix(_mzcgmx, vec3(0.75, 0.85, 0.95), _rxs39p);
}
if (_2d13on > 0.001) {
_mw99cp = mix(_mw99cp, vec3(81.0, 189.0, 92.0) / 255.0, _2d13on);
_evq3fl = mix(_evq3fl, vec3(154.0, 194.0, 110.0) / 255.0, _2d13on);
_mzcgmx = mix(_mzcgmx, vec3(122.0, 211.0, 255.0) / 255.0, _2d13on);
}
if (_lfojrz > 0.001) {
_mw99cp = mix(_mw99cp, vec3(66.0, 128.0, 75.0) / 255.0, _lfojrz);
_evq3fl = mix(_evq3fl, vec3(83.0, 77.0, 102.0) / 255.0, _lfojrz);
_mzcgmx = mix(_mzcgmx, vec3(144.0, 199.0, 90.0) / 255.0, _lfojrz);
}
if (_ypru3e > 0.001) {
_mw99cp = mix(_mw99cp, vec3(235.0, 213.0, 185.0) / 255.0, _ypru3e);
_evq3fl = mix(_evq3fl, vec3(214.0, 206.0, 224.0) / 255.0, _ypru3e);
_mzcgmx = mix(_mzcgmx, vec3(150.0, 145.0, 207.0) / 255.0, _ypru3e);
}
if (_fgx2j8 > 0.001) {
_mw99cp = mix(_mw99cp, _6epga1, _fgx2j8);
_evq3fl = mix(_evq3fl, _0ngtua, _fgx2j8);
_mzcgmx = mix(_mzcgmx, _9ubczf, _fgx2j8);
}
if (_6kr23z > 0.001) {
_mw99cp = mix(_mw99cp, _1iquw2(), _6kr23z);
_evq3fl = mix(_evq3fl, _ch7orx(), _6kr23z);
_mzcgmx = mix(_mzcgmx, _f9f345(), _6kr23z);
}

float _xnhnuy = max(max(max(_rxs39p, _2d13on), max(_lfojrz, _ypru3e)), max(_fgx2j8, _6kr23z));
bool _bd3ss9 = _xnhnuy > 0.001;

float _4odmh4 = max(length(_bonu7f - _gmfo88), length(_x70tse - _h4of6g));

float _7e4wx1 = max(smoothstep(0.03, 0.18, _4odmh4), _xmiuzq);
#ifndef OVERWORLD_BIOME_SKY_ENABLED

_7e4wx1 = 0.0;
#endif

if (!_bd3ss9 && _7e4wx1 > 0.001) {
vec3 _b9bun4 = _x70tse;
vec3 _idwjay = _bonu7f;
vec3 _yf1n2g = mix(_b9bun4, _idwjay, 0.55);
_mw99cp = mix(_mw99cp, _b9bun4, _7e4wx1);
_evq3fl = mix(_evq3fl, _yf1n2g, _7e4wx1);
_mzcgmx = mix(_mzcgmx, _idwjay, _7e4wx1);
}

float _15ht8g = _bd3ss9 ? 1.0 : (SKY_BIOME_BLEND * _7e4wx1);
float _kd2jix = _15ht8g;

float _4m03tr = max(_lfojrz, _6kr23z);
float _7utkgq = _15ht8g * _4m03tr * 0.35;
float _oh9mgb = _15ht8g * _4m03tr * 0.25;
float _srqyfz = _15ht8g * _4m03tr * 0.2;

vec3 _mlvzfk = vec3(DAY_HORIZON_R, DAY_HORIZON_G, DAY_HORIZON_B);
vec3 _pp9t85 = vec3(DAY_MID_R, DAY_MID_G, DAY_MID_B);
vec3 _9fpt1m = vec3(DAY_ZENITH_R, DAY_ZENITH_G, DAY_ZENITH_B);

_mlvzfk = _dyo4p6(_mlvzfk, _mw99cp, _kd2jix);
_pp9t85 = _dyo4p6(_pp9t85, _evq3fl, _kd2jix);
_9fpt1m = _dyo4p6(_9fpt1m, _mzcgmx, _kd2jix);

_mlvzfk = _z28ws4(_mlvzfk, SKY_SATURATION);
_pp9t85 = _z28ws4(_pp9t85, SKY_SATURATION);
_9fpt1m = _z28ws4(_9fpt1m, SKY_SATURATION);
if (_fgx2j8 > 0.001) {
float _purj7z = clamp(_fgx2j8 * _kd2jix, 0.0, 1.0);
_mlvzfk = mix(_mlvzfk, _6epga1, _purj7z);
_pp9t85 = mix(_pp9t85, _0ngtua, _purj7z);
_9fpt1m = mix(_9fpt1m, _9ubczf, _purj7z);
}
vec3 _n6yb0b = _juwfwp(_mlvzfk, _pp9t85, _9fpt1m, _e3aar4, DAY_MID_HEIGHT, DAY_ZENITH_HEIGHT);

vec3 _9cn7gb = vec3(SUNSET_HORIZON_R, SUNSET_HORIZON_G, SUNSET_HORIZON_B);
vec3 _hjqkxl = vec3(SUNSET_MID_R, SUNSET_MID_G, SUNSET_MID_B);
vec3 _vqy7od = vec3(SUNSET_ZENITH_R, SUNSET_ZENITH_G, SUNSET_ZENITH_B);
_9cn7gb = _dyo4p6(_9cn7gb, _mw99cp, _7utkgq);
_hjqkxl = _dyo4p6(_hjqkxl, _evq3fl, _7utkgq);
_vqy7od = _dyo4p6(_vqy7od, _mzcgmx, _7utkgq);
_9cn7gb = _z28ws4(_9cn7gb, SKY_SATURATION);
_hjqkxl = _z28ws4(_hjqkxl, SKY_SATURATION);
_vqy7od = _z28ws4(_vqy7od, SKY_SATURATION);
vec3 _u1f3pc = _juwfwp(_9cn7gb, _hjqkxl, _vqy7od, _e3aar4, SUNSET_MID_HEIGHT, SUNSET_ZENITH_HEIGHT);

vec3 _9z0hmw = vec3(BLUEHOUR_HORIZON_R, BLUEHOUR_HORIZON_G, BLUEHOUR_HORIZON_B);
vec3 _pdl78i = vec3(BLUEHOUR_MID_R, BLUEHOUR_MID_G, BLUEHOUR_MID_B);
vec3 _jz1qvk = vec3(BLUEHOUR_ZENITH_R, BLUEHOUR_ZENITH_G, BLUEHOUR_ZENITH_B);
_9z0hmw = _dyo4p6(_9z0hmw, _mw99cp, _oh9mgb);
_pdl78i = _dyo4p6(_pdl78i, _evq3fl, _oh9mgb);
_jz1qvk = _dyo4p6(_jz1qvk, _mzcgmx, _oh9mgb);
_9z0hmw = _z28ws4(_9z0hmw, SKY_SATURATION);
_pdl78i = _z28ws4(_pdl78i, SKY_SATURATION);
_jz1qvk = _z28ws4(_jz1qvk, SKY_SATURATION);
vec3 _nzihnm = _juwfwp(_9z0hmw, _pdl78i, _jz1qvk, _e3aar4, BLUEHOUR_MID_HEIGHT, BLUEHOUR_ZENITH_HEIGHT);

vec3 _zu1sj9 = vec3(NIGHT_HORIZON_R, NIGHT_HORIZON_G, NIGHT_HORIZON_B);
vec3 _sr0zwy = vec3(NIGHT_MID_R, NIGHT_MID_G, NIGHT_MID_B);
vec3 _jl63ac = vec3(NIGHT_ZENITH_R, NIGHT_ZENITH_G, NIGHT_ZENITH_B);
_zu1sj9 = _dyo4p6(_zu1sj9, _mw99cp, _srqyfz);
_sr0zwy = _dyo4p6(_sr0zwy, _evq3fl, _srqyfz);
_jl63ac = _dyo4p6(_jl63ac, _mzcgmx, _srqyfz);
_zu1sj9 = _z28ws4(_zu1sj9, SKY_SATURATION);
_sr0zwy = _z28ws4(_sr0zwy, SKY_SATURATION);
_jl63ac = _z28ws4(_jl63ac, SKY_SATURATION);
vec3 _kfo8lp = _juwfwp(_zu1sj9, _sr0zwy, _jl63ac, _e3aar4, NIGHT_MID_HEIGHT, NIGHT_ZENITH_HEIGHT);

vec3 _ttpo7r = vec3(SUNRISE_HORIZON_R, SUNRISE_HORIZON_G, SUNRISE_HORIZON_B);
vec3 _eqhrpi = vec3(SUNRISE_MID_R, SUNRISE_MID_G, SUNRISE_MID_B);
vec3 _d56bsq = vec3(SUNRISE_ZENITH_R, SUNRISE_ZENITH_G, SUNRISE_ZENITH_B);
_ttpo7r = _z28ws4(_ttpo7r, SKY_SATURATION);
_eqhrpi = _z28ws4(_eqhrpi, SKY_SATURATION);
_d56bsq = _z28ws4(_d56bsq, SKY_SATURATION);
vec3 _v84gll = _juwfwp(_ttpo7r, _eqhrpi, _d56bsq, _e3aar4, SUNSET_MID_HEIGHT, SUNSET_ZENITH_HEIGHT);

vec3 _px26is = vec3(DAWN_HORIZON_R, DAWN_HORIZON_G, DAWN_HORIZON_B);
vec3 _ilhfwg = vec3(DAWN_MID_R, DAWN_MID_G, DAWN_MID_B);
vec3 _lz5y7z = vec3(DAWN_ZENITH_R, DAWN_ZENITH_G, DAWN_ZENITH_B);
_px26is = _z28ws4(_px26is, SKY_SATURATION);
_ilhfwg = _z28ws4(_ilhfwg, SKY_SATURATION);
_lz5y7z = _z28ws4(_lz5y7z, SKY_SATURATION);
vec3 _hu0453 = _juwfwp(_px26is, _ilhfwg, _lz5y7z, _e3aar4, BLUEHOUR_MID_HEIGHT, BLUEHOUR_ZENITH_HEIGHT);

vec3 _oalagc = _n6yb0b * DAY_BRIGHTNESS;
vec3 _cg7apb = _u1f3pc * SUNSET_BRIGHTNESS;
vec3 _ey4fdh = _nzihnm * BLUEHOUR_BRIGHTNESS;
vec3 _0nyw91 = _kfo8lp * NIGHT_BRIGHTNESS;
vec3 _h7suoy = _v84gll * SUNRISE_BRIGHTNESS;
vec3 _bzu0bh = _hu0453 * DAWN_BRIGHTNESS;

vec3 _yssmf1 = _oalagc    * tw.day
+ _cg7apb * tw.sunset
+ _ey4fdh   * tw.blueHour
+ _0nyw91  * tw.night
+ _h7suoy * tw.sunrise
+ _bzu0bh   * tw.dawn;

float _oui5et = smoothstep(0.0, 0.5, _e3aar4);

float _p141w5 = min(tw.day, tw.sunset + tw.sunrise) * 2.5;
float _698129 = min(tw.day, tw.sunset + tw.sunrise) * 2.0;
float _92388v = mix(_p141w5, _698129, _oui5et);

vec3 _y2j94g = mix(vec3(1.0, 0.92, 0.4), vec3(0.85, 0.15, 0.55), _oui5et);
_y2j94g *= max(DAY_BRIGHTNESS, SUNSET_BRIGHTNESS);
_yssmf1 = mix(_yssmf1, _y2j94g, _92388v * mix(0.45, 0.55, _oui5et));

float _4am4t1 = min(tw.sunset, tw.blueHour) * 2.0;
vec3 _at014b = mix(vec3(0.9, 0.25, 0.55), vec3(0.4, 0.1, 1.0), _oui5et);
_at014b *= mix(SUNSET_BRIGHTNESS, BLUEHOUR_BRIGHTNESS, 0.5);
_yssmf1 = mix(_yssmf1, _at014b, _4am4t1 * mix(0.4, 0.55, _oui5et));

_yssmf1 *= 1.0 - rainStrength * (float(SKY_RAIN_DARKNESS) / 100.0);

#ifdef STARS_ENABLED

float _bhxo7g = 1.0 - smoothstep(0.15, 0.70, rainStrength);
float _4hoxs4 = (_6tk9k5 + blueHour * 0.5) * _bhxo7g * (1.0 - _lfojrz);
if (_4hoxs4 > 0.01 && _st4awd.y > -0.1) {

float _o6gbcn = _9mmvvk(_st4awd, frameTimeCounter);

float _eo29pw = smoothstep(-0.1, 0.15, _st4awd.y);

_yssmf1 += vec3(_o6gbcn) * _4hoxs4 * _eo29pw;

#ifdef STAR_SHOOTING_ENABLED
if (_6tk9k5 > 0.5) {
vec3 _52gryp = _72p72f(_st4awd, frameTimeCounter);
_yssmf1 += _52gryp * _eo29pw * _bhxo7g;
}
#endif
}
#endif

#ifdef NIGHT_NEBULA_ENABLED
{
float _mvdl5o = 1.0 - smoothstep(0.15, 0.70, rainStrength);
float _k6cd4q = (_6tk9k5 + blueHour * 0.4) * _mvdl5o * (1.0 - _lfojrz);
if (_k6cd4q > 0.01) {
vec3 _o3zovc = _xy5uo8(_st4awd, frameTimeCounter);
_yssmf1 += _o3zovc * _k6cd4q;
}
}
#endif

#ifdef METEORS_ENABLED
{
float _ute0ii = 1.0 - smoothstep(0.15, 0.70, rainStrength);
float _qvw15c = (_6tk9k5 + blueHour * 0.3) * _ute0ii * (1.0 - _lfojrz);
if (_qvw15c > 0.01 && _st4awd.y > -0.05) {
vec3 _7xrwoh = _7qubiq(_st4awd, frameTimeCounter);
float _ivddgy = smoothstep(-0.05, 0.15, _st4awd.y);
_yssmf1 += _7xrwoh * _qvw15c * _ivddgy;
}
}
#endif

#ifdef CLOUDS_2D_ENABLED
{
vec4 _u9na24 = _uowus3(_st4awd, cameraPosition, frameTimeCounter, sunAngle);

_yssmf1 = mix(_yssmf1, _u9na24.rgb, _u9na24.a);
}
#endif

#ifdef RINGED_PLANET_ENABLED
{

vec3 _9nsyz3 = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
vec3 _5ejy0y = vec3(0.0);

_mipgsl(_yssmf1, _5ejy0y, _st4awd, _9nsyz3);
}
#endif

if (_lfojrz > 0.001) {
_yssmf1 *= mix(1.0, 0.6, _lfojrz);
}

gl_FragData[0] = vec4(_yssmf1, 1.0);
gl_FragData[1] = vec4(0.0);
}
