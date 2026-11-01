/* RENDERTARGETS: 0 */

#include "/settings.glsl"

in vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex7;
uniform sampler2D colortex8;
uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D colortex11;

uniform float viewWidth;
uniform float viewHeight;
uniform vec3 cameraPosition;

uniform int isEyeInWater;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D dhDepthTex;
uniform float far;
uniform float dhFarPlane;
uniform float near;
uniform vec3 fogColor;
uniform float sunAngle;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform sampler2D shadowtex0;

#include "/include/shadow.glsl"

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

#define SEA_LEVEL_OFFSET_DEFAULT 63
#ifndef SEA_LEVEL_OFFSET
#define SEA_LEVEL_OFFSET SEA_LEVEL_OFFSET_DEFAULT
#endif

void main() {
vec4 _bcg6fd = texture(colortex0, texcoord);
vec3 _yssmf1 = _bcg6fd.rgb;
float _6x7txv = _bcg6fd.a;

float _4f6yyb = texture(depthtex1, texcoord).r;
float _a8w17j = texture(depthtex2, texcoord).r;
float _2ql2nv = texture(depthtex0, texcoord).r;
vec4 _alcc4c = texelFetch(colortex1, ivec2(gl_FragCoord.xy), 0);
bool _yjolhc = (_4f6yyb >= 0.9999);

bool _xvtoay = (_2ql2nv < _a8w17j - 0.000001) && (abs(_2ql2nv - _4f6yyb) < 0.000001);

if (_xvtoay) {
gl_FragData[0] = vec4(_yssmf1, _6x7txv);
return;
}

bool _vbdnok = false;

bool _h278bp = !_xvtoay && (_alcc4c.a > 0.01 && _alcc4c.a < 0.99);

vec4 _m995av = texelFetch(colortex5, ivec2(gl_FragCoord.xy), 0);
vec4 _wxcvh0 = texelFetch(colortex4, ivec2(gl_FragCoord.xy), 0);
bool _2uxgrb = (_wxcvh0.a > 0.45);
bool _kgt9i1 = _yjolhc && (_2ql2nv < 0.9999) && (_m995av.y < 0.5) && !_2uxgrb;
if (isEyeInWater != 1) {

vec2 _6ujuwx = texcoord;
bool _kj4uqc = (_m995av.y > 0.9) && (_m995av.w * 2.0 - 1.0 < 0.5);
if (_kj4uqc) {
float _6cto2c = _m995av.x;
vec2 _imixdk = vec2((_6cto2c - 0.5) * 0.8, (_6cto2c - 0.5) * 1.2);
float _5spi1j = 14.0 / max(viewWidth, 1.0);
_6ujuwx += _imixdk * _5spi1j;
_6ujuwx = clamp(_6ujuwx, vec2(0.0), vec2(1.0));
}
vec4 _h1cocf = texture(colortex8, _6ujuwx);

_h1cocf.a *= 1.0 - smoothSwamp;
_h1cocf.rgb *= 1.0 - smoothSwamp;
if (_h1cocf.a > 0.001 && !_h278bp && !_kgt9i1) {
_yssmf1 = _yssmf1 * (1.0 - _h1cocf.a) + _h1cocf.rgb;
}
}

#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED)
if (isEyeInWater != 1) {
vec4 _5frq09 = max(texture(colortex9, texcoord), vec4(0.0));
if (_5frq09.a > 0.001) {
_yssmf1 = _5frq09.rgb + _yssmf1 * (1.0 - _5frq09.a);
}
}
#endif

#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED)
if (isEyeInWater == 1) {
vec4 _5frq09 = max(texture(colortex9, texcoord), vec4(0.0));
if (_5frq09.a > 0.001) {
float _qmkhf9 = texture(colortex1, texcoord).g;

float _i7t2yn = _qmkhf9 * 0.5 * (1.0 - smoothstep(0.3, 0.6, _5frq09.a));
float _w2eeyu = _5frq09.a * (1.0 - _i7t2yn);
_yssmf1 = _5frq09.rgb * (_w2eeyu / max(_5frq09.a, 0.001)) + _yssmf1 * (1.0 - _w2eeyu);
}
}
#endif

#ifdef UNDERWATER_FOG_ENABLED
if (isEyeInWater == 1) {
float _rfqxfd = texture(colortex1, texcoord).g;
if (_rfqxfd > 0.01) {
vec4 _u69pcl = max(texture(colortex9, texcoord), vec4(0.0));
float _nv0nxz = 1.0 - _u69pcl.a;
_yssmf1 *= 1.0 + _rfqxfd * 3.5 * _nv0nxz;
}
}
#endif

#ifdef UNDERWATER_FOG_ENABLED
if (isEyeInWater == 1) {
vec4 _h1cocf = texture(colortex8, texcoord);

float _z9ilrg = float(SEA_LEVEL_OFFSET) - cameraPosition.y;
float _ocg1e7 = smoothstep(0.5, 6.0, _z9ilrg);
_h1cocf.a *= (1.0 - _ocg1e7);
_h1cocf.rgb *= (1.0 - _ocg1e7);
if (_h1cocf.a > 0.001 && !_h278bp && !_kgt9i1) {

_yssmf1 += _h1cocf.rgb * _h1cocf.a;
}
}
#endif

gl_FragData[0] = vec4(_yssmf1, _6x7txv);
}
