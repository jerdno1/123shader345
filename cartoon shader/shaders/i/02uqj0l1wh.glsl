#ifdef TAA_ENABLED

uniform float viewWidth;
uniform float viewHeight;
uniform float framemod8;

const vec2 jitterOffsets[8] = vec2[8](
vec2( 0.125,-0.375),
vec2(-0.125, 0.375),
vec2( 0.625, 0.125),
vec2( 0.375,-0.625),
vec2(-0.625, 0.625),
vec2(-0.875,-0.125),
vec2( 0.375,-0.875),
vec2( 0.875, 0.875)
);

vec2 _ayrn1e(vec2 _5zlm8i, float w) {
return _5zlm8i + jitterOffsets[int(framemod8)] * (w / vec2(viewWidth, viewHeight));
}

#else

vec2 _ayrn1e(vec2 _5zlm8i, float w) {
return _5zlm8i;
}

#endif
