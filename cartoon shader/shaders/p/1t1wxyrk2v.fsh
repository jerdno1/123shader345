/* RENDERTARGETS: 0,1,3 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

uniform sampler2D gtexture;
#ifdef PBR_ENABLED
uniform sampler2D specular;
#endif
uniform int entityId;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform vec3 fogColor;
uniform int biome_category;
uniform float fogStart;
uniform float fogEnd;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor1;
uniform vec3 shadowLightPosition;
uniform int frameCounter;
uniform int isEyeInWater;
uniform vec4 entityColor;
uniform float biome_snowy;
uniform float biome_jungle;
uniform float biome_swamp;
uniform float biome_arid;
uniform float biome_savanna;

#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
#include "/include/entity_depth_record.glsl"
#include "/include/lighting.glsl"
#ifdef PBR_ENABLED
#include "/include/pbr.glsl"
#endif
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
#include "/include/end_event.glsl"
#endif

in vec2 texcoord;
in vec4 glcolor;
in vec3 worldPos;
in float skylight;
in float blocklight;
in float emissiveLayer;
in float viewDistance;
in float nametagHolo;
in vec4 shadowPos;
in vec3 normal;

#include "/include/fog_color.glsl"

#include "/include/noise.glsl"

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;

_yssmf1.rgb = mix(_yssmf1.rgb, entityColor.rgb, entityColor.a);

if (_yssmf1.a < 0.01) {
discard;
}

float _9dnv8b = 0.0;
#ifdef PBR_ENABLED
_9dnv8b = _k86yw1(texture(specular, texcoord));
#endif

if (emissiveLayer > 0.5) {
vec3 _ujkzaq = _yssmf1.rgb * EMISSIVE_BRIGHTNESS * ENTITY_EMISSIVE_BRIGHTNESS;
vec3 _pq1dl3 = _yssmf1.rgb * EMISSIVE_BRIGHTNESS * ENTITY_EMISSIVE_BLOOM * 2.0;
gl_FragData[0] = vec4(_ujkzaq, _yssmf1.a);
gl_FragData[1] = vec4(0.0, 1.0, 0.0, 0.5);
gl_FragData[2] = vec4(_pq1dl3, 1.0);
_w272gd();
return;
}

float _m392wf = max(_yssmf1.r, max(_yssmf1.g, _yssmf1.b));
bool _dynz8t = (entityId != 20002 && _yssmf1.a < 0.9 && _m392wf < 0.08 && entityColor.a < 0.001 && nametagHolo < 0.5);
#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
if (_dynz8t && _u746aw(frameTimeCounter) > 0.98) {
discard;
}
#endif

if (entityId == 20002 || _yssmf1.a < 0.9) {
vec3 _uzavwy = vec3(0.0);
#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
vec3 _fnflsc = _yssmf1.rgb;
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _fnflsc, _9dnv8b, EMISSIVE_BRIGHTNESS);
_uzavwy = _7qz11m(_fnflsc, _9dnv8b, EMISSIVE_BRIGHTNESS);
}
#endif
gl_FragData[0] = _yssmf1;
float _o2v7ej = 0.5;
#ifdef END_SHADER
if (_dynz8t) _o2v7ej = 0.0;
#endif
gl_FragData[1] = vec4(0.0, _9dnv8b, 0.0, _o2v7ej);
gl_FragData[2] = vec4(_uzavwy, 1.0);
if (_o2v7ej > 0.01) _w272gd();
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
_yssmf1.a *= _fxiwh2;
if (_yssmf1.a < 0.01) {
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
float emissive = 0.0;

if (entityId == 100) {

} else if (entityId == 101) {
if (_yssmf1.r > 0.8 && _yssmf1.g < 0.2 && _yssmf1.b < 0.2) emissive = 1.0 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 102) {

} else if (entityId == 103) {
if (_yssmf1.r > 0.7 && _yssmf1.g > 0.8 && _yssmf1.b < 0.4) emissive = 0.8 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 104) {
if (_yssmf1.r > 0.8 && _yssmf1.g > 0.9 && _yssmf1.b > 0.9) emissive = 0.9 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 105) {
emissive = 0.7 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 106) {
if (_yssmf1.r > 0.5 && _yssmf1.g > 0.8 && _yssmf1.b > 0.9) emissive = 0.8 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 107) {
if (_yssmf1.r > 0.6 && _yssmf1.g < 0.3 && _yssmf1.b < 0.3) emissive = 0.9 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 108) {
if (_yssmf1.r > 0.9 && _yssmf1.g > 0.5 && _yssmf1.b < 0.6) emissive = 0.6 * PROCEDURAL_GLOW_STRENGTH;
} else if (entityId == 109) {
emissive = 0.0;
}

vec3 _s0nzrv = vec3(0.0);
vec3 _x7zh8u = vec3(0.0);
if (emissive > 0.5) {
float _qk41wi = EMISSIVE_BRIGHTNESS * max(emissive, 1.0);
float _rmn0ak = 1.25 + 0.75 * max(emissive, 1.0);
_s0nzrv = _kz6npv * _qk41wi * ENTITY_EMISSIVE_BRIGHTNESS;
_x7zh8u = _kz6npv * _qk41wi * ENTITY_EMISSIVE_BLOOM * _rmn0ak;
}

if (entityId == 105 && emissive > 0.5) {
_s0nzrv = _kz6npv;
_x7zh8u = _kz6npv * 0.01;
}

if (entityId == 109) {
_x7zh8u = _kz6npv * EMISSIVE_BRIGHTNESS * 0.5;
}
#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
_x7zh8u = max(
_x7zh8u,
_7qz11m(_kz6npv, _9dnv8b, EMISSIVE_BRIGHTNESS)
);
}
#endif

#ifdef SHADOWS_ENABLED
if (shadowPos.w > 0.5 && emissive < 0.5) {
float _id7o0g = dot(normal, normalize(shadowLightPosition));

float _izh8vx = _fzhskc(gl_FragCoord.xy);

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
vec3 shadow = _syjysd(shadowtex0, shadowcolor0, shadowcolor1, _qxvw16, 0.0);
#else
vec3 shadow = _xlukz2(shadowtex0, shadowcolor0, shadowcolor1, _qxvw16, _w02w60, _izh8vx, 0.0);
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
_yssmf1.rgb = _iroce3(_evko43, sunAngle, _bg2hka, blocklight, emissive, shadow, worldPos.y);
} else {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
_x3j9yv = smoothstep(0.02, 0.20, blocklight);
#endif
_yssmf1.rgb = _rdf2ja(_yssmf1.rgb, sunAngle, skylight, blocklight, emissive, worldPos.y);
}
#else
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
_x3j9yv = smoothstep(0.02, 0.20, blocklight);
#endif
_yssmf1.rgb = _rdf2ja(_yssmf1.rgb, sunAngle, skylight, blocklight, emissive, worldPos.y);
#endif
#ifdef HANDHELD_LIGHT_ENABLED
if (emissive < 0.5) _yssmf1.rgb += _6p2kch(worldPos, _kz6npv, _yssmf1.rgb);
#endif
float _7b60gn = max(_kz6npv.r, max(_kz6npv.g, _kz6npv.b));
_yssmf1.rgb *= smoothstep(0.01, 0.06, _7b60gn);
_yssmf1.rgb *= TERRAIN_BRIGHTNESS;

#ifdef END_SHADER
if (emissive < 0.5) {
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

if (entityId == 109) {
_yssmf1.rgb = mix(_yssmf1.rgb, _kz6npv, 0.6);
}

if (emissive > 0.5) {
_yssmf1.rgb = max(_yssmf1.rgb, _s0nzrv);
}
#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
emissive = max(emissive, _9dnv8b);
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _kz6npv, _9dnv8b, EMISSIVE_BRIGHTNESS);
}
#endif

bool _a7qvpx = false;
#ifdef NETHER_FOG_ENABLED
_a7qvpx = _9cwhip(biome);
#endif
if (!_a7qvpx) {
float _ogwka4 = max(fogEnd - fogStart, 0.0001);
float _lr3hjh = clamp((fogEnd - viewDistance) / _ogwka4, 0.0, 1.0);
_yssmf1.rgb = mix(_1jzgf0(), _yssmf1.rgb, _lr3hjh);
}

gl_FragData[0] = vec4(_yssmf1.rgb, 1.0);
float _o2v7ej = 0.5;
#ifdef END_SHADER
if (_dynz8t) _o2v7ej = 0.0;
#endif
gl_FragData[1] = vec4(1.0, emissive, _ml0ahp, _o2v7ej);
gl_FragData[2] = vec4(_x7zh8u, 1.0);
if (_o2v7ej > 0.01) _w272gd();
}
