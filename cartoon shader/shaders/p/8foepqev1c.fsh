/* RENDERTARGETS: 0,1,3,4,5 */

#include "/settings.glsl"
#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
uniform float biome_swamp;

uniform sampler2D gtexture;
uniform sampler2D shadowtex0;
uniform float alphaTestRef;
uniform float sunAngle;
uniform int currentRenderedItemId;
uniform int isEyeInWater;
uniform vec3 shadowLightPosition;
uniform int frameCounter;
uniform vec3 cameraPosition;
#ifdef LPV_ENABLED
uniform mat4 gbufferModelViewInverse;
#endif
#include "/include/lighting.glsl"
#ifdef EMISSIVE_MASKING
#include "/include/emissive_mask.glsl"
#endif
#ifdef PBR_ENABLED
uniform sampler2D normals;
uniform sampler2D specular;
#include "/include/pbr.glsl"
#endif

#ifdef END_SHADER
uniform float frameTimeCounter;
#ifdef END_EVENT_ENABLED
#include "/include/end_event.glsl"
#endif
#endif

in vec2 texcoord;
in vec4 glcolor;
in float skylight;
in float blocklight;
in float viewDistance;
in vec4 shadowPos;
in vec3 normal;
in vec3 worldPos;
#ifdef PBR_ENABLED
in vec3 tangentVec;
in vec3 binormalVec;
in vec3 viewPosOut;
#endif

void main() {
vec4 _yssmf1 = texture(gtexture, texcoord) * glcolor;

#ifdef TEXTURE_PALETTE_ENABLED
{
float _1pxkd6 = float(TEXTURE_PALETTE_LEVELS);
_yssmf1.rgb = floor(_yssmf1.rgb * _1pxkd6) / _1pxkd6;
}
#endif

if (_yssmf1.a < alphaTestRef) {
discard;
}

vec3 _dwo81a = _yssmf1.rgb;
#ifdef LPV_ENABLED
_pis44d = _dwo81a;
_06143i = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
#endif

bool _80z6y5 = (currentRenderedItemId >= 10020 && currentRenderedItemId <= 10059) || currentRenderedItemId == 10087 || currentRenderedItemId == 10089;

float _v5ukcy = 0.0;
bool _uotxkf = false;

#ifdef EMISSIVE_MASKING
if (_80z6y5) {
int _mid1t4 = (currentRenderedItemId == 10087) ? 46 : ((currentRenderedItemId == 10089) ? 47 : currentRenderedItemId - 10020);
_v5ukcy = _xojoff(_mid1t4, _dwo81a);
_uotxkf = (_v5ukcy >= 0.05);
}
#else
_uotxkf = _80z6y5;
_v5ukcy = _uotxkf ? 1.0 : 0.0;
#endif

#ifdef END_SHADER
if (!_uotxkf) {

#ifdef SHADOWS_ENABLED
if (shadowPos.w > 0.5) {
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

float _w3e3up = 0.003;
float _kmd3qn = (SHADOW_NORMAL_BIAS * 0.0001) * (1.1 - _id7o0g);
float _ats6ga = _w3e3up + _kmd3qn;

vec3 _qxvw16 = _p43sug;
_qxvw16.z -= _ats6ga;

vec3 shadow = _nmx2gt(shadowtex0, shadowcolor0, _qxvw16, _w02w60, _izh8vx, 0.0);
float _zmw5cz = max(skylight, 0.15);
shadow = mix(vec3(1.0), shadow, _zmw5cz);
shadow = mix(vec3(1.0), shadow, SHADOW_OPACITY);
float _t8xmom = dot(shadow, vec3(0.299, 0.587, 0.114));
float _ungdrs = skylight;
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
vec3 _evko43 = _yssmf1.rgb;
_yssmf1.rgb = _iroce3(_evko43, sunAngle, _ungdrs, blocklight, 0.0, shadow, worldPos.y);
float _nd19sa = _nz5r9d(sunAngle);
if (_nd19sa > 0.001) {
vec3 _x0uomv = _iroce3(_evko43, sunAngle, _ungdrs, blocklight, 0.0, vec3(1.0), worldPos.y);
_yssmf1.rgb = mix(_yssmf1.rgb, _x0uomv, _nd19sa);
}
_yssmf1.rgb *= _bbncmg(_nd19sa, _utlnv9(sunAngle).x, _ungdrs);
} else {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _6xm99w(_yssmf1.rgb, sunAngle, skylight, blocklight, worldPos.y);
}
#else
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _6xm99w(_yssmf1.rgb, sunAngle, skylight, blocklight, worldPos.y);
#endif

float _fv1on9 = mix(0.15, 1.0, smoothstep(0.0, 0.5, skylight));
_yssmf1.rgb *= _fv1on9;

float _zuxja7 = 0.55;
float _1cr2qa = 0.15;

float _zd6ere = 0.0;
vec3 _7jfeo6 = vec3(0.0);

#if defined(END_SHADER) && defined(END_EVENT_ENABLED)
float _do4zke = _u746aw(frameTimeCounter);
if (_do4zke > 0.001) {
float _2pv68z = _171d84(blocklight, skylight);
vec3 _wzl9xk = vec3(END_BLOCKLIGHT_R, END_BLOCKLIGHT_G, END_BLOCKLIGHT_B);
_7jfeo6 = _dwo81a * _wzl9xk * _2pv68z * _2pv68z * END_BLOCKLIGHT_BRIGHTNESS;
_zd6ere = _do4zke;
}
_zuxja7 = mix(_zuxja7, 0.02, _do4zke);
_1cr2qa = mix(_1cr2qa, 0.0, _do4zke);
#endif

_yssmf1.rgb *= _zuxja7;
vec3 _99621u = vec3(0.08, 0.06, 0.35);
_yssmf1.rgb += _99621u * _1cr2qa;

_yssmf1.rgb += _7jfeo6 * _zd6ere;

#ifdef HANDHELD_LIGHT_ENABLED
_yssmf1.rgb += _6p2kch(worldPos, _dwo81a, _yssmf1.rgb);
#endif
} else {

_yssmf1.rgb = _dwo81a * EMISSIVE_BRIGHTNESS * END_EMISSIVE_BOOST;
}
#else

if (!_uotxkf) {

#ifdef SHADOWS_ENABLED
if (shadowPos.w > 0.5) {
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

float _w3e3up = 0.003;
float _kmd3qn = (SHADOW_NORMAL_BIAS * 0.0001) * (1.1 - _id7o0g);
float _ats6ga = _w3e3up + _kmd3qn;

vec3 _qxvw16 = _p43sug;
_qxvw16.z -= _ats6ga;

vec3 shadow = _nmx2gt(shadowtex0, shadowcolor0, _qxvw16, _w02w60, _izh8vx, 0.0);
float _zmw5cz = max(skylight, 0.15);
shadow = mix(vec3(1.0), shadow, _zmw5cz);
shadow = mix(vec3(1.0), shadow, SHADOW_OPACITY);

float _t8xmom = dot(shadow, vec3(0.299, 0.587, 0.114));
float _ungdrs = skylight;
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _iroce3(_yssmf1.rgb, sunAngle, _ungdrs, blocklight, 0.0, shadow, worldPos.y);
} else {
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _6xm99w(_yssmf1.rgb, sunAngle, skylight, blocklight, worldPos.y);
}
#else
#ifdef LPV_ENABLED
_osnipo = worldPos;
_5pkrr5 = normalize(mat3(gbufferModelViewInverse) * normal);
#endif
_yssmf1.rgb = _6xm99w(_yssmf1.rgb, sunAngle, skylight, blocklight, worldPos.y);
#endif

#ifdef HANDHELD_LIGHT_ENABLED
_yssmf1.rgb += _6p2kch(worldPos, _dwo81a, _yssmf1.rgb);
#endif
} else {

_yssmf1.rgb = _dwo81a * EMISSIVE_BRIGHTNESS;
}
#endif

float _nf0yd5 = _uotxkf ? 1.0 : 0.0;
float _9dnv8b = 0.0;

#ifdef PBR_ENABLED
if (!_uotxkf) {
vec4 _dp25va = texture(normals, texcoord);
vec4 _jx5qo9   = texture(specular, texcoord);
PBRMaterial pm = pbr_decode(_dp25va, _jx5qo9, _dwo81a, PBR_NORMAL_STRENGTH);
_9dnv8b = _qk34ll(pm);
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
vec3 _mgx03l = pm.F0 * (1.0 - r) * 0.15 * max(skylight, 0.15) * _5dyf8q;
if (NdotL > 0.0) {
float _xfzuai = mix(32.0, 4.0, r);
float _jv85j4 = pow(_x102pb, _xfzuai);
float _ndnwba = (_xfzuai + 2.0) / (2.0 * 3.14159265);
vec3 _xyhmor = _jv85j4 * _ndnwba * F * NdotL;
float _4dti9e = fract(sunAngle);
float _xya605 = smoothstep(0.00, 0.15, _4dti9e) * (1.0 - smoothstep(0.40, 0.55, _4dti9e));
_yssmf1.rgb += _xyhmor * _5dyf8q * PBR_SPECULAR_STRENGTH * max(skylight, 0.15) * _xya605;
}
_yssmf1.rgb += _mgx03l;
}
if (_9dnv8b > 0.001) {
_nf0yd5 = max(_nf0yd5, _9dnv8b);
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS);
}
}
#endif

gl_FragData[0] = _yssmf1;

gl_FragData[1] = vec4(0.0, _nf0yd5, 0.0, 0.75);

vec3 _pq1dl3 = vec3(0.0);

const float HAND_BLOOM_SCALE = 0.6;
if (_uotxkf) {
int _pmfn2z = currentRenderedItemId;
vec3 tint;
if (_pmfn2z == 10021 || _pmfn2z == 10043) {
tint = vec3(0.3, 0.7, 1.0);
} else if (_pmfn2z == 10087 || _pmfn2z == 10089) {
tint = vec3(0.3, 1.0, 0.4);
} else if (_pmfn2z == 10038 || _pmfn2z == 10058) {
tint = vec3(1.0, 0.2, 0.2);
} else if (_pmfn2z == 10023 || _pmfn2z == 10024 || _pmfn2z == 10025 ||
_pmfn2z == 10027 || _pmfn2z == 10028 || _pmfn2z == 10029 || _pmfn2z == 10031 ||
_pmfn2z == 10032 || _pmfn2z == 10033 || _pmfn2z == 10034 ||
_pmfn2z == 10040 || _pmfn2z == 10044 ||
_pmfn2z == 10046 || _pmfn2z == 10047 || _pmfn2z == 10048 || _pmfn2z == 10049 ||
_pmfn2z == 10051 || _pmfn2z == 10052 || _pmfn2z == 10053 ||
_pmfn2z == 10054 || _pmfn2z == 10055 || _pmfn2z == 10059) {

tint = _dwo81a;
} else {
tint = vec3(1.0, 0.85, 0.4);
}
_pq1dl3 = tint * EMISSIVE_BRIGHTNESS * HAND_BLOOM_SCALE * clamp(_v5ukcy, 0.0, 1.0);
}
#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
_pq1dl3 = max(
_pq1dl3,
_7qz11m(_dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS * HAND_BLOOM_SCALE)
);
}
#endif
gl_FragData[2] = vec4(_pq1dl3, 1.0);
gl_FragData[3] = vec4(0.0);
gl_FragData[4] = vec4(0.0);
}
