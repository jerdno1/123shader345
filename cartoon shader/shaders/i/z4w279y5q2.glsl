#ifndef ENTITY_PARTICLE_DEPTH_GLSL
#define ENTITY_PARTICLE_DEPTH_GLSL

uniform usampler2D entityDepthSampler;
uniform float near;
uniform float far;

float _wc8ygf(float _swfcra) {
return (near * far) / (_swfcra * (near - far) + far);
}

bool _na31gs() {
uint _p1pujc = texelFetch(entityDepthSampler, ivec2(gl_FragCoord.xy), 0).r;
if (_p1pujc == 0u) return false;

float _u1jwdi = 1.0 - uintBitsToFloat(_p1pujc);
float _103ykr = _wc8ygf(_u1jwdi);
float _0jfobd = _wc8ygf(gl_FragCoord.z);
float _4yjx0q = min(0.08, 0.02 + _103ykr * 0.00025);
return _0jfobd > _103ykr + _4yjx0q;
}

#endif
