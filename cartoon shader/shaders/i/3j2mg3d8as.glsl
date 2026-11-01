#ifndef CAZ_GLASS_REFLECTION_PAYLOAD_GLSL
#define CAZ_GLASS_REFLECTION_PAYLOAD_GLSL

const float GLASS_REFLECTION_META_POSITIVE_Z = 0.86;
const float GLASS_REFLECTION_META_NEGATIVE_Z = 0.88;
const float WATER_REFLECTION_META_POSITIVE_Z = 0.94;
const float WATER_REFLECTION_META_NEGATIVE_Z = 0.96;
const float WATER_REFLECTION_META_HORIZONTAL = 1.0;

float _uaiic5(float _u03ygx) {
return (_u03ygx < 0.0) ? GLASS_REFLECTION_META_NEGATIVE_Z : GLASS_REFLECTION_META_POSITIVE_Z;
}

bool _r0mj6q(float _9svbyl) {
return _9svbyl > 0.855 && _9svbyl < 0.895;
}

float _olzjaf(float _9svbyl) {
return (_9svbyl > 0.87) ? -1.0 : 1.0;
}

float _kup5d9(vec3 normal) {
if (abs(normal.y) > 0.5) return WATER_REFLECTION_META_HORIZONTAL;
return (normal.z < 0.0) ? WATER_REFLECTION_META_NEGATIVE_Z : WATER_REFLECTION_META_POSITIVE_Z;
}

float _5rjijq(float _9svbyl) {
return (_9svbyl > 0.95 && _9svbyl < 0.99) ? -1.0 : 1.0;
}

#endif
