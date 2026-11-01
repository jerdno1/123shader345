#ifndef ENTITY_DEPTH_RECORD_GLSL
#define ENTITY_DEPTH_RECORD_GLSL

layout(r32ui) uniform coherent uimage2D entityDepthImg;

void _w272gd() {
uint _p1pujc = floatBitsToUint(max(1.0 - gl_FragCoord.z, 0.0));
if (_p1pujc != 0u) {
imageAtomicMax(entityDepthImg, ivec2(gl_FragCoord.xy), _p1pujc);
}
}

#endif
