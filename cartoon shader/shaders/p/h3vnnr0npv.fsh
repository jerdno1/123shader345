/* RENDERTARGETS: 9,13 */

const bool _jyzb7p = false;

#extension GL_ARB_shader_storage_buffer_object : require

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

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

in vec2 texcoord;

uniform sampler2D colortex1;
uniform sampler2D colortex9;
uniform sampler2D colortex13;
uniform sampler2D depthtex0;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform int isEyeInWater;
uniform float biome_swamp;
uniform int biome;
uniform int biome_category;
uniform float sunAngle;
uniform ivec2 eyeBrightnessSmooth;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;
uniform int frameCounter;

#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED) || defined(CAVE_FOG_ENABLED)

#include "/include/fog_taa.glsl"

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
ivec2 _2l09tc = ivec2(gl_FragCoord.xy);
vec4 _gc5n04 = _lfvr68(colortex9);
if (isEyeInWater == 1 || frameCounter <= 1) {

gl_FragData[0] = _gc5n04;
gl_FragData[1] = _gc5n04;
} else {
vec4 _8izj9y = _luv9fi(_gc5n04, colortex13, depthtex0, texcoord);

float _13rsme = texture(colortex1, texcoord).b;
float _pbfs9z = smoothstep(0.5 / 15.0, 1.0 / 15.0, _13rsme);
float _cm427v = smoothstep(0.55, 0.60, fract(sunAngle)) * (1.0 - smoothstep(0.94, 0.98, fract(sunAngle)));
float _da3yip = mix(1.0, _pbfs9z, _cm427v);
float _vgmjb0 = 1.0 - smoothstep(1.0 / 15.0, 3.0 / 15.0, _13rsme);
float _4r4doi = mix(1.0, 0.0, _vgmjb0);
float _c8a8c0 = dot(_gc5n04.rgb, vec3(0.299, 0.587, 0.114));
float _iw9lke = smoothstep(
ATMO_DUST_MIN_BRIGHTNESS,
max(ATMO_DUST_MAX_BRIGHTNESS * 0.20, ATMO_DUST_MIN_BRIGHTNESS + 0.0001),
_c8a8c0);
_4r4doi = mix(max(_4r4doi, _iw9lke), 0.0, _vgmjb0);
float _c5uhe5 = _2vpc5n(biome_swamp, biome, biome_category);
_8izj9y = mix(_8izj9y, _gc5n04, _c5uhe5);
float _0k2vvp = fract(sunAngle);
float _85tjia = smoothstep(0.55, 0.6, _0k2vvp) * (1.0 - smoothstep(0.9, 0.95, _0k2vvp));
_8izj9y = mix(_8izj9y, _gc5n04, _85tjia);
_8izj9y = mix(_gc5n04, _8izj9y, _4r4doi);
if (_da3yip <= 0.001 && _gc5n04.a <= 0.001) _8izj9y = _gc5n04;

gl_FragData[0] = _8izj9y;
gl_FragData[1] = _8izj9y;
}
}

#else

void main() {
gl_FragData[0] = vec4(0.0);
gl_FragData[1] = vec4(0.0);
}

#endif
