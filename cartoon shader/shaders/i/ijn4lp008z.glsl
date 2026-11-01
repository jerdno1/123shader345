#ifndef SKY_FALLBACK_GLSL
#define SKY_FALLBACK_GLSL

#include "/include/sky_timeline.glsl"

vec3 _4e5pg9(vec3 _exbfzp, float sunAngle) {
TimeWeightsSimple ts = getTimeWeightsSimple(sunAngle);

vec3 _xb0g31 = normalize(mat3(gbufferModelViewInverse) * _exbfzp);

float height = clamp(_xb0g31.y * 0.5 + 0.5, 0.0, 1.0);

vec3 _od2x3w = _9ruyvd(sunAngle, height);

if (_xb0g31.y < 0.0) {
_od2x3w *= 0.5 + 0.5 * (1.0 + _xb0g31.y);
}

vec3 _xtjpzc = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
float _wnr39r = dot(_xb0g31, _xtjpzc);

float _xf5rzj = pow(max(_wnr39r, 0.0), 32.0);
vec3 _5yiprg = mix(vec3(1.0, 0.95, 0.8), vec3(1.0, 0.6, 0.3), ts.twilight);
_od2x3w += _5yiprg * _xf5rzj * (ts.day + ts.twilight * 0.5) * 0.6;

float _xf6zml = pow(max(-_wnr39r, 0.0), 16.0);
_od2x3w += vec3(0.4, 0.5, 0.7) * _xf6zml * ts.night * 0.3;

return _od2x3w;
}

#endif
