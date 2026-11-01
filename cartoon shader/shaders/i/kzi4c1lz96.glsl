#ifndef INCLUDE_BIOME_COLOR_SMOOTHING_GLSL
#define INCLUDE_BIOME_COLOR_SMOOTHING_GLSL

vec3 _oyv7j0(vec3 _ppsr99, vec3 _8cc9nt) {
if (any(isnan(_ppsr99)) || any(isinf(_ppsr99))) return _8cc9nt;
if (dot(abs(_ppsr99), vec3(1.0)) < 0.001) return _8cc9nt;
return clamp(_ppsr99, vec3(0.0), vec3(1.0));
}

vec3 _tvhml8(vec3 _34vg5e) {
#ifndef BIOME_COLOR_SMOOTHING_HAS_SSBO
return _34vg5e;
#else
return _oyv7j0(vec3(smoothBiomeFogR, smoothBiomeFogG, smoothBiomeFogB), _34vg5e);
#endif
}

vec3 _un92z1(vec3 _ou83fx) {
#ifndef BIOME_COLOR_SMOOTHING_HAS_SSBO
return _ou83fx;
#else
return _oyv7j0(vec3(smoothBiomeSkyR, smoothBiomeSkyG, smoothBiomeSkyB), _ou83fx);
#endif
}

float _15io5k(vec3 _xyezyl, vec3 _riel36, vec3 _ookqe5, vec3 _jcnq9s) {
float _un8jrm = length(_xyezyl - _ookqe5);
float _45tmls = length(_riel36 - _jcnq9s);
return smoothstep(0.03, 0.18, max(_un8jrm, _45tmls));
}

#endif
