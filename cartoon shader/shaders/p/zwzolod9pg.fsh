/* RENDERTARGETS: 7,1,3,4,5 */

#include "/settings.glsl"
#include "/include/shadow.glsl"
#include "/include/pixelation.glsl"
uniform float biome_swamp;

uniform sampler2D gtexture;
uniform sampler2D shadowtex0;
#ifdef PBR_ENABLED
uniform sampler2D specular;
#endif
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

#ifdef EMISSIVE_MASKING
float _v5ukcy = 0.0;
bool _uotxkf = false;
if (_80z6y5) {
int _mid1t4 = (currentRenderedItemId == 10087) ? 46 : ((currentRenderedItemId == 10089) ? 47 : currentRenderedItemId - 10020);
_v5ukcy = _xojoff(_mid1t4, _dwo81a);
_uotxkf = (_v5ukcy >= 0.05);
}
#else
bool _uotxkf = _80z6y5;
#endif
float _9dnv8b = 0.0;
#ifdef PBR_ENABLED
if (!_uotxkf) {
_9dnv8b = _k86yw1(texture(specular, texcoord));
}
#endif

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
float _ungdrs = max(skylight, _t8xmom * 0.95);
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

#ifdef PBR_ENABLED
if (_9dnv8b > 0.001) {
_yssmf1.rgb = _kg9mcg(_yssmf1.rgb, _dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS);
}
#endif

float _nf0yd5 = max(_uotxkf ? 1.0 : 0.0, _9dnv8b);
vec3 _pq1dl3 = vec3(0.0);
#ifdef PBR_ENABLED
_pq1dl3 = _7qz11m(_dwo81a, _9dnv8b, EMISSIVE_BRIGHTNESS * 0.6);
#endif
gl_FragData[0] = _yssmf1;
gl_FragData[1] = vec4(0.0, _nf0yd5, 0.0, 0.5);
gl_FragData[2] = vec4(_pq1dl3, 1.0);

vec3 _bsthpc = glcolor.rgb;
float _p3rlbf = max(max(_bsthpc.r, _bsthpc.g), _bsthpc.b);
if (_p3rlbf > 0.001) _bsthpc /= _p3rlbf;
vec4 _1zel5u = vec4(texture(gtexture, texcoord).rgb * _bsthpc, 0.6);

gl_FragData[3] = _nf0yd5 > 0.001 ? vec4(0.0) : _1zel5u;
gl_FragData[4] = vec4(0.0);
}
