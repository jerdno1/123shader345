/* RENDERTARGETS: 0,1,2,3 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"
#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
#include "/include/entity_depth_record.glsl"

uniform sampler2D gtexture;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor1;
uniform float alphaTestRef;
uniform vec3 fogColor;
uniform int biome_category;
uniform float fogStart;
uniform float fogEnd;
uniform float sunAngle;
uniform vec3 shadowLightPosition;
uniform int frameCounter;
uniform int entityId;
uniform int currentRenderedItemId;
uniform float frameTimeCounter;
uniform int isEyeInWater;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform vec4 entityColor;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;

#include "/include/lighting.glsl"
#ifdef EMISSIVE_MASKING
#include "/include/emissive_mask.glsl"
#endif
#ifdef PBR_ENABLED
uniform sampler2D normals;
uniform sampler2D specular;
#include "/include/pbr.glsl"
#endif
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
#include "/include/end_event.glsl"
#endif

in vec2 texcoord;
in vec4 glcolor;
in float viewDistance;
in float skylight;
in float blocklight;
in float emissiveLayer;
in float emissive;
flat in float emissiveType;
in vec4 shadowPos;
in vec3 normal;
in vec3 worldPos;
in float nametagHolo;
#ifdef PBR_ENABLED
in vec3 tangentVec;
in vec3 binormalVec;
in vec3 viewPosOut;
#endif

#include "/include/fog_color.glsl"

#include "/include/noise.glsl"

void main() {

#ifdef EMISSIVE
{
vec4 _40yja6 = texture(gtexture, texcoord) * glcolor;
if (_40yja6.a < 0.01) discard;
_40yja6.rgb *= EMISSIVE_BRIGHTNESS;
gl_FragData[0] = vec4(_40yja6.rgb, 1.0);
gl_FragData[1] = vec4(0.0, 1.0, 0.0, 0.5);
gl_FragData[2] = vec4(_40yja6.rgb * 0.5, 1.0);
gl_FragData[3] = vec4(_40yja6.rgb * 0.5, 1.0);
_w272gd();
return;
}
#endif

vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;

if (emissiveLayer > 0.5) {
if (_yssmf1.a < alphaTestRef) discard;
vec3 _ujkzaq = _yssmf1.rgb * EMISSIVE_BRIGHTNESS * ENTITY_EMISSIVE_BRIGHTNESS;
vec3 _pq1dl3 = _yssmf1.rgb * EMISSIVE_BRIGHTNESS * ENTITY_EMISSIVE_BLOOM * 2.0;
gl_FragData[0] = vec4(_ujkzaq, 1.0);
gl_FragData[1] = vec4(0.0, 1.0, 0.0, 0.5);
gl_FragData[2] = vec4(_pq1dl3, 1.0);
gl_FragData[3] = vec4(_pq1dl3, 1.0);
_w272gd();
return;
}

#ifdef MAGICAL_TOUCH

float _6qwad8 = max(max(glcolor.r, glcolor.g), glcolor.b);
float _aslobc = min(min(glcolor.r, glcolor.g), glcolor.b);
float _aitjxw = _6qwad8 - _aslobc;
bool _xg9i3h = (_6qwad8 > 0.70 && _aitjxw < 0.035);
if (_xg9i3h) _yssmf1.rgb /= _6qwad8;
#else
vec3 _3v9zqi = normalize(mat3(gbufferModelViewInverse) * normal);
_yssmf1.rgb *= _7q50sc(_3v9zqi);
#endif

float _nf0yd5 = emissive;
float _9dnv8b = 0.0;

if (_nf0yd5 > 0.5) {
vec3 _z7t6ex = texture(gtexture, texcoord).rgb;
float _0pa3k8 = dot(_z7t6ex, vec3(0.299, 0.587, 0.114));
float _z3wc75 = max(_z7t6ex.r, max(_z7t6ex.g, _z7t6ex.b));
float _xwk5bs = min(_z7t6ex.r, min(_z7t6ex.g, _z7t6ex.b));
float _205mjt = (_z3wc75 - _xwk5bs) / max(_z3wc75, 0.001);
if (_0pa3k8 > 0.65 && _205mjt < 0.3) _nf0yd5 = 0.0;
}

#ifdef TEXTURE_PALETTE_ENABLED
{
float _1pxkd6 = float(TEXTURE_PALETTE_LEVELS);
_yssmf1.rgb = floor(_yssmf1.rgb * _1pxkd6) / _1pxkd6;
}
#endif

_yssmf1.rgb = mix(_yssmf1.rgb, entityColor.rgb, entityColor.a);

if (_yssmf1.a < alphaTestRef) {
discard;
}

float _m392wf = max(_yssmf1.r, max(_yssmf1.g, _yssmf1.b));
bool _dynz8t = (_yssmf1.a < 0.9 && _m392wf < 0.08 && entityColor.a < 0.001 && nametagHolo < 0.5);
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
if (_dynz8t && _u746aw(frameTimeCounter) > 0.98) {
discard;
}
#endif

#ifdef CHUNK_FADE_OUT_ENABLED
#ifndef DISTANT_HORIZONS
if (!_9cwhip(biome) && !_z0kr59(biome)) {
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
}
#endif
#endif

vec3 _kz6npv = _yssmf1.rgb;
float _ml0ahp = skylight;
#ifdef LPV_ENABLED

_pis44d = _kz6npv;
_06143i = dot(_kz6npv, vec3(0.299, 0.587, 0.114));

_n7k2vf = 1.0;
#endif

{
if (entityId == 100) {

} else if (entityId == 101) {
if (_yssmf1.r > 0.8 && _yssmf1.g < 0.2 && _yssmf1.b < 0.2) _nf0yd5 = 1.0 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 102) {

} else if (entityId == 103) {
if (_yssmf1.r > 0.7 && _yssmf1.g > 0.8 && _yssmf1.b < 0.4) _nf0yd5 = 0.8 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 104) {
if (_yssmf1.r > 0.8 && _yssmf1.g > 0.9 && _yssmf1.b > 0.9) _nf0yd5 = 0.9 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 105) {
_nf0yd5 = 0.7 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 106) {
if (_yssmf1.r > 0.5 && _yssmf1.g > 0.8 && _yssmf1.b > 0.9) _nf0yd5 = 0.8 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 107) {
if (_yssmf1.r > 0.6 && _yssmf1.g < 0.3 && _yssmf1.b < 0.3) _nf0yd5 = 0.9 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 108) {
if (_yssmf1.r > 0.9 && _yssmf1.g > 0.5 && _yssmf1.b < 0.6) _nf0yd5 = 0.6 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 109) {
_nf0yd5 = 1.0;
} else if (entityId == 110) {
_nf0yd5 = 1.0;
}
}

bool _wr95xz = (currentRenderedItemId >= 10020 && currentRenderedItemId <= 10059) || currentRenderedItemId == 10087 || currentRenderedItemId == 10089;
bool _317u98 = false;
float _bsf6d1 = 0.0;
if (_wr95xz) {
#ifdef EMISSIVE_MASKING
int _k2ocbm = (currentRenderedItemId == 10087) ? 46 : ((currentRenderedItemId == 10089) ? 47 : currentRenderedItemId - 10020);
_bsf6d1 = _xojoff(_k2ocbm, _kz6npv);
_317u98 = (_bsf6d1 >= 0.05);
#else
_317u98 = true;
#endif
}

vec3 _s0nzrv = vec3(0.0);
vec3 _x7zh8u = vec3(0.0);

if (_317u98) {

_s0nzrv = _kz6npv * EMISSIVE_BRIGHTNESS;

#ifdef EMISSIVE_MASKING
_x7zh8u = _kz6npv * EMISSIVE_BRIGHTNESS * clamp(_bsf6d1, 0.0, 1.0);
#else
_x7zh8u = vec3(1.0, 0.85, 0.4) * EMISSIVE_BRIGHTNESS;
if (currentRenderedItemId == 10021 || currentRenderedItemId == 10043) {
_x7zh8u = vec3(0.3, 0.7, 1.0) * EMISSIVE_BRIGHTNESS;
}
int _pmfn2z = currentRenderedItemId;
if (_pmfn2z == 10023 || _pmfn2z == 10024 || _pmfn2z == 10025 ||
_pmfn2z == 10027 || _pmfn2z == 10028 || _pmfn2z == 10029 || _pmfn2z == 10031 ||
_pmfn2z == 10032 || _pmfn2z == 10033 || _pmfn2z == 10034 ||
_pmfn2z == 10040 || _pmfn2z == 10044 ||
_pmfn2z == 10046 || _pmfn2z == 10047 || _pmfn2z == 10048 || _pmfn2z == 10049 ||
_pmfn2z == 10051 || _pmfn2z == 10052 || _pmfn2z == 10053 ||
_pmfn2z == 10054 || _pmfn2z == 10055 || _pmfn2z == 10058 || _pmfn2z == 10059) {
_x7zh8u = _kz6npv * EMISSIVE_BRIGHTNESS;
}
#endif
_nf0yd5 = 1.0;
} else if (_wr95xz && !_317u98) {

_nf0yd5 = 0.0;
} else if (_nf0yd5 > 0.5 && !_wr95xz) {

float _qk41wi = EMISSIVE_BRIGHTNESS * max(_nf0yd5, 1.0);
float _rmn0ak = 1.25 + 0.75 * max(_nf0yd5, 1.0);
_s0nzrv = _kz6npv;
_x7zh8u = _kz6npv * _qk41wi * ENTITY_EMISSIVE_BLOOM * _rmn0ak;
}

if (entityId == 109 && _nf0yd5 > 0.5) {
_s0nzrv = _kz6npv;
_x7zh8u = _kz6npv * 0.15;
}

if (entityId == 105 && _nf0yd5 > 0.5) {
_s0nzrv = _kz6npv;
_x7zh8u = _kz6npv * 0.01;
}

if (entityId == 110 && _nf0yd5 > 0.5) {
_s0nzrv = _kz6npv * EMISSIVE_BRIGHTNESS;
_x7zh8u = _kz6npv * 0.15;
}

#ifdef SHADOWS_ENABLED
if (shadowPos.w > 0.5 && _nf0yd5 < 0.5 && !_9cwhip(biome)) {

float _id7o0g = dot(normal, normalize(shadowLightPosition));

float _izh8vx = _h1jpqh(gl_FragCoord.xy, frameCounter);

vec3 _p43sug = shadowPos.xyz;
#ifdef PIXELATED_SHADOWS
vec2 _3g5hwx = _qrjbox(gtexture, texcoord);
_p43sug = _yqlisi(_p43sug, _3g5hwx);
#endif
_izh8vx = _e4hc8m(_izh8vx, _p43sug);

float r = _55535n(_p43sug.xy * 2.0 - 1.0);
float _w02w60 = r + SHADOW_DISTORTION;

vec3 _qxvw16 = _p43sug;
_qxvw16.z -= 0.0005;

#ifdef MAGICAL_TOUCH
vec3 shadow = _syjysd(shadowtex1, shadowcolor0, shadowcolor1, _qxvw16, 0.0);
#else
vec3 shadow = _xlukz2(shadowtex1, shadowcolor0, shadowcolor1, _qxvw16, _w02w60, _izh8vx, 0.0);
#endif

float _38pqcl = dot(shadow, vec3(0.299, 0.587, 0.114));
float _p1fyzl = _38pqcl;
float _bg2hka = max(skylight, min(_38pqcl * 0.95, 1.0 / 15.0));
_ml0ahp = _bg2hka;

shadow = mix(vec3(1.0), shadow, _bg2hka);

shadow = mix(vec3(1.0), shadow, SHADOW_OPACITY);
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
_x3j9yv = smoothstep(0.02, 0.20, blocklight);
#endif
vec3 _evko43 = _yssmf1.rgb;
float _71irn6 = smoothstep(0.5 / 15.0, 2.0 / 15.0, skylight);
float _l9cqvi = smoothstep(float(SEA_LEVEL_OFFSET) - 4.0, float(SEA_LEVEL_OFFSET) + 2.0, worldPos.y);
float _i5wc7f = max(_71irn6, _l9cqvi);
_joda6y = clamp(_p1fyzl * _hrakns(sunAngle) * _i5wc7f, 0.0, 1.0);
_yssmf1.rgb = _iroce3(_evko43, sunAngle, _bg2hka, blocklight, _nf0yd5, shadow, worldPos.y);
float _nd19sa = _nz5r9d(sunAngle);
if (_nd19sa > 0.001) {
vec3 _x0uomv = _iroce3(_evko43, sunAngle, _bg2hka, blocklight, _nf0yd5, vec3(1.0), worldPos.y);
_yssmf1.rgb = mix(_yssmf1.rgb, _x0uomv, _nd19sa);
}
_yssmf1.rgb *= _bbncmg(_nd19sa, _utlnv9(sunAngle).x, _bg2hka);
} else {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
_x3j9yv = smoothstep(0.02, 0.20, blocklight);
#endif
_yssmf1.rgb = _rdf2ja(_yssmf1.rgb, sunAngle, skylight, blocklight, _nf0yd5, worldPos.y);
}
#else
{
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
_x3j9yv = smoothstep(0.02, 0.20, blocklight);
#endif
_yssmf1.rgb = _rdf2ja(_yssmf1.rgb, sunAngle, skylight, blocklight, _nf0yd5, worldPos.y);
}
#endif
#ifdef HANDHELD_LIGHT_ENABLED
if (_nf0yd5 < 0.5) _yssmf1.rgb += _6p2kch(worldPos, _kz6npv, _yssmf1.rgb);
#endif
float _7b60gn = max(_kz6npv.r, max(_kz6npv.g, _kz6npv.b));
_yssmf1.rgb *= smoothstep(0.01, 0.06, _7b60gn);

_yssmf1.rgb *= TERRAIN_BRIGHTNESS;

#ifdef PBR_ENABLED
if (_nf0yd5 < 0.5) {
vec4 _dp25va = texture(normals, texcoord);
vec4 _jx5qo9   = texture(specular, texcoord);
PBRMaterial pm = pbr_decode(_dp25va, _jx5qo9, _kz6npv, PBR_NORMAL_STRENGTH);
_9dnv8b = _qk34ll(pm);

if (pm.hasNormal && PBR_AO_STRENGTH > 0.001) {
float _hrcpes = 1.0 - skylight;
_yssmf1.rgb *= mix(1.0, mix(1.0, pm.ao, PBR_AO_STRENGTH * 0.5), _hrcpes);
}

if (pm.hasSpec && pm.roughness < 0.999) {
vec3 N = _3af26h(pm.nTangent, tangentVec, binormalVec, normal);
vec3 L = normalize(shadowLightPosition);
vec3 V = normalize(-viewPosOut);
vec3 H = normalize(V + L);
float NdotL = max(dot(N, L), 0.0);
float _x102pb = max(dot(N, H), 0.0);
float _i9o95p = max(dot(N, V), 1e-3);
float _5dyf8q = smoothstep(0.02, 0.15, _i9o95p);
float r = clamp(pm.roughness, 0.5, 1.0);
vec3  F = _6hjzil(_i9o95p, pm.F0);
vec3 _mgx03l = pm.F0 * (1.0 - r) * 0.15 * skylight * _5dyf8q;
if (NdotL > 0.0) {
float _xfzuai = mix(32.0, 4.0, r);
float _jv85j4 = pow(_x102pb, _xfzuai);
float _ndnwba = (_xfzuai + 2.0) / (2.0 * 3.14159265);
vec3 _xyhmor = _jv85j4 * _ndnwba * F * NdotL;
float _4dti9e = fract(sunAngle);
float _xya605 = smoothstep(0.00, 0.15, _4dti9e) * (1.0 - smoothstep(0.40, 0.55, _4dti9e));
_yssmf1.rgb += _xyhmor * _5dyf8q * PBR_SPECULAR_STRENGTH * skylight * _xya605;
}
_yssmf1.rgb += _mgx03l;
}
if (_9dnv8b > 0.001) {
_nf0yd5 = max(_nf0yd5, _9dnv8b);
_x7zh8u = max(
_x7zh8u,
_7qz11m(_kz6npv, _9dnv8b, EMISSIVE_BRIGHTNESS)
);
}
}
#endif

#ifdef END_SHADER
if (_nf0yd5 < 0.5) {
float _acsjl5 = 0.55;
vec3 _99621u = vec3(0.08, 0.06, 0.35);
float _98hjvs = 0.15;
float _gizcv9 = 0.55;

float _tkjq88 = 0.0;
vec3 _88uz3t = vec3(0.0);

#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
float _y2oclv = _u746aw(frameTimeCounter);
if (_y2oclv > 0.001) {
float _2pv68z = _171d84(blocklight, skylight);
vec3 _wzl9xk = vec3(END_BLOCKLIGHT_R, END_BLOCKLIGHT_G, END_BLOCKLIGHT_B);
_88uz3t = _kz6npv * _wzl9xk * _2pv68z * _2pv68z * END_BLOCKLIGHT_BRIGHTNESS * TERRAIN_BRIGHTNESS;

#ifdef HANDHELD_LIGHT_ENABLED
_88uz3t += _6p2kch(worldPos, _kz6npv, vec3(0.0)) * TERRAIN_BRIGHTNESS;
#endif

_tkjq88 = _y2oclv;
}
_acsjl5 = mix(_acsjl5, 0.02, _y2oclv);
_98hjvs = mix(_98hjvs, 0.0, _y2oclv);
_gizcv9 = mix(_gizcv9, 0.0, _y2oclv);
#endif

_yssmf1.rgb *= _acsjl5;
_yssmf1.rgb += _99621u * _98hjvs;
_yssmf1.rgb = mix(_yssmf1.rgb, _yssmf1.rgb * vec3(0.55, 0.58, 1.35), _gizcv9);

_yssmf1.rgb += _88uz3t * _tkjq88;
}
#endif

if (_317u98) {

_yssmf1.rgb = _kz6npv * EMISSIVE_BRIGHTNESS;
} else if (_nf0yd5 > 0.5) {
_yssmf1.rgb = max(_yssmf1.rgb, _s0nzrv);
}

#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _kz6npv, _9dnv8b, EMISSIVE_BRIGHTNESS);
}
#endif

bool _a7qvpx = false;
#ifdef NETHER_FOG_ENABLED
_a7qvpx = _9cwhip(biome);
#endif
if (isEyeInWater != 1 && !_a7qvpx) {
float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
_yssmf1.rgb = mix(_1jzgf0(), _yssmf1.rgb, _lr3hjh);
}

gl_FragData[0] = vec4(_yssmf1.rgb, 1.0);
float _o2v7ej = 0.5;
#ifdef END_SHADER
if (_dynz8t) _o2v7ej = 0.0;
#endif
gl_FragData[1] = vec4(1.0, _nf0yd5, _ml0ahp, _o2v7ej);
gl_FragData[2] = vec4(_x7zh8u, 1.0);
gl_FragData[3] = vec4(_x7zh8u, 1.0);
if (_o2v7ej > 0.01) _w272gd();
}
