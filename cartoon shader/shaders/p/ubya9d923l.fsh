/* RENDERTARGETS: 11,15 */

const bool _qyvr6i = false;

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

in vec2 texcoord;

uniform sampler2D colortex11;
uniform sampler2D colortex15;
uniform sampler2D depthtex0;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform float sunAngle;
uniform float frameTime;
uniform float rainStrength;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform float biome_swamp;
uniform float biome_snowy;
uniform float biome_arid;
uniform int biome;
uniform int biome_category;
uniform ivec2 eyeBrightnessSmooth;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;
uniform int frameCounter;

#ifdef WEATHER_FOG_ENABLED

#include "/include/fog_taa.glsl"
#include "/include/sky_timeline.glsl"

float _6xgxvk(float _swfcra) {
return (near * far) / (_swfcra * (near - far) + far);
}

vec4 _lfvr68(sampler2D fogTex) {
vec2 _460ux4 = vec2(viewWidth, viewHeight);
ivec2 _64317f = ivec2(max(_460ux4 * FOG_RENDER_SCALE, vec2(1.0)));
ivec2 _6ova42 = ivec2(floor(gl_FragCoord.xy * FOG_RENDER_SCALE));
float _w6k1ug = _6xgxvk(texture(depthtex0, texcoord).r);

const ivec2 OFFSETS[5] = ivec2[](
ivec2(0, 0),
ivec2(1, 0),
ivec2(-1, 0),
ivec2(0, 1),
ivec2(0, -1)
);

vec4 _idhca6 = vec4(0.0);
float _apkqux = 0.0;
float _w8dbmu = max(_w6k1ug * 0.05, 0.25);

for (int i = 0; i < 5; i++) {
ivec2 _jmyufn = clamp(_6ova42 + OFFSETS[i], ivec2(0), _64317f - ivec2(1));
vec2 _b5dy23 = (vec2(_jmyufn) + 0.5) / _460ux4;
vec2 _nccj5z = (vec2(_jmyufn) / FOG_RENDER_SCALE + 0.5) / _460ux4;
float _slnatl = _6xgxvk(texture(depthtex0, clamp(_nccj5z, vec2(0.0), vec2(1.0))).r);
vec4 _xnnc9k = texture(fogTex, _b5dy23);
if (!_c82v48(_xnnc9k)) continue;
float _d8tv7f = abs(_slnatl - _w6k1ug) < _w8dbmu ? 1.0 : 0.0001;
_idhca6 += _xnnc9k * _d8tv7f;
_apkqux += _d8tv7f;
}

return _apkqux > 0.0 ? _idhca6 / _apkqux : vec4(0.0);
}

void main() {

float _f37exz = float(eyeBrightnessSmooth.y) / 240.0;
vec4 _m4ow96 = texture(colortex15, texcoord);
if (any(isnan(_m4ow96)) || any(isinf(_m4ow96)) ||
_m4ow96.a < 0.0 || _m4ow96.a > 2.0001) {
_m4ow96 = vec4(0.0);
}
vec4 _gc5n04 = _lfvr68(colortex11);
if (frameCounter <= 1 || _f37exz < 0.10 || _m4ow96.a > 1.001) {
gl_FragData[0] = _gc5n04;
gl_FragData[1] = _m4ow96;
return;
}

vec4 _8izj9y = _luv9fi(_gc5n04, colortex15, depthtex0, texcoord);
TimeWeights tw = getTimeWeights(sunAngle);
float _0avo9x = clamp(tw.night + tw.blueHour * 0.35, 0.0, 1.0);
float _shsa01 = mix(1.0, 0.30, _0avo9x);
float _wjd2eq = _2vpc5n(biome_swamp, biome, biome_category);
vec3 _jdbaon = max(_gc5n04.rgb, vec3(0.0));
float _kyub50 = dot(_jdbaon, vec3(0.299, 0.587, 0.114));
float _eoma67 = length(_jdbaon - vec3(_kyub50));
float _7xecur = smoothstep(0.04, 0.14, _eoma67) * smoothstep(0.01, 0.08, _gc5n04.a);
float _l7i9lr = mix(_shsa01, 0.70, _7xecur);

float _lgiltl = clamp(WEATHER_FOG_TAA_BLEND, 0.0, 1.0);
_l7i9lr *= _lgiltl;

#ifdef STORM_EFFECTS_ENABLED

float _rc11wj = clamp(rainStrength, 0.0, 1.0);
float _o26nz5 = clamp(biome_arid, 0.0, 1.0) * _rc11wj;
float _zlgpmy = max(clamp(biome_snowy, 0.0, 1.0) - _wjd2eq * 0.5, 0.0) * _rc11wj;
float _3xgyco = smoothstep(0.05, 0.65, max(_o26nz5, _zlgpmy));

float _i58dm5 = clamp(frameTime, 1.0 / 240.0, 0.10);
float _6vuvkn = length(cameraPosition - previousCameraPosition) / _i58dm5;
float _mz7rpj = smoothstep(0.25, 3.0, _6vuvkn);
vec2 _rmub0a = _9wkdzz(texcoord, depthtex0);
float _d5gm4m = length((_rmub0a - texcoord) * vec2(viewWidth, viewHeight));
float _e1mu5w = smoothstep(0.75, 4.0, _d5gm4m);
float _sppme7 = max(_mz7rpj, _e1mu5w);

vec4 _2ums92 = abs(_8izj9y - _gc5n04);
float _vr7lis = max(_2ums92.r, max(_2ums92.g, _2ums92.b));
float _3nwsdu = max(
smoothstep(0.08, 0.30, _2ums92.a),
smoothstep(0.10, 0.45, _vr7lis)
);

float _mweaf1 = mix(0.35, 0.60, _lgiltl);
float _n8mmjh = mix(0.02, 0.12, _lgiltl);
float _46mef9 = mix(_mweaf1, _n8mmjh, _sppme7);
_46mef9 *= mix(1.0, 0.10, _3nwsdu);
_l7i9lr = mix(
_l7i9lr,
min(_l7i9lr, _46mef9),
_3xgyco
);
#endif

_8izj9y = mix(_gc5n04, _8izj9y, _l7i9lr);

_8izj9y = mix(_8izj9y, _gc5n04, _wjd2eq);
gl_FragData[0] = _8izj9y;
gl_FragData[1] = _8izj9y;
}

#else

void main() {
gl_FragData[0] = vec4(0.0);
gl_FragData[1] = vec4(0.0);
}

#endif
