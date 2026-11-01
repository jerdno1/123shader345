/* RENDERTARGETS: 0,1,2 */

#include "/settings.glsl"
#include "/include/biome_overrides.glsl"

uniform sampler2D gtexture;
uniform vec3 shadowLightPosition;
uniform vec3 sunPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform int biome;
uniform int biome_category;
uniform int isEyeInWater;
uniform float biome_swamp;

in vec2 uv;
in vec3 viewPos;
in vec4 tint;

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

if (_0rit85()) {
discard;
}

#ifdef END_SKY_ENABLED
{
bool _8tg5d5 = false;
#ifdef CAT_THE_END
_8tg5d5 = (biome_category == CAT_THE_END);
#else
_8tg5d5 = _z0kr59(biome);
#endif
if (_8tg5d5) discard;
}
#endif

vec4 _yssmf1 = texture(gtexture, uv) * tint;

if (_yssmf1.a < 0.1) discard;

float _wnr39r = dot(normalize(viewPos), normalize(shadowLightPosition));
float _rb63ys = dot(normalize(viewPos), normalize(-shadowLightPosition));
bool _fkrvye = _wnr39r > 0.8 || _rb63ys > 0.8;

#ifdef STARS_ENABLED

if (!_fkrvye) {
float _zdxp7g = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
bool _t8wpr5 = (_zdxp7g < 0.20) && (_yssmf1.a < 0.99);
if (_t8wpr5) discard;
}
#endif

float _lfojrz = _2vpc5n(biome_swamp, biome, biome_category);
if (!_fkrvye && _lfojrz > 0.01) {
float _unln3z = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
if (_unln3z < 0.30 && _yssmf1.a < 0.99) discard;
}

gl_FragData[0] = _yssmf1;

float emissive = _fkrvye ? 1.0 : 0.0;

float _z2tgiu = dot(_yssmf1.rgb, vec3(0.299, 0.587, 0.114));
vec3 _vqm48q = _z2tgiu > 0.01 ? _yssmf1.rgb / _z2tgiu : vec3(1.0);
vec3 _kc1rml = _vqm48q * SUN_MOON_BLOOM;

if (isEyeInWater == 1) { _kc1rml = vec3(0.0); }
gl_FragData[1] = vec4(0.0, emissive, 0.0, 0.0);
gl_FragData[2] = vec4(_kc1rml, 1.0);
}
