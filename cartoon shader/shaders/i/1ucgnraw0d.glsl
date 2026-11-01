#ifndef CAZTOON_LEAF1_PIXEL_TOON_GLSL
#define CAZTOON_LEAF1_PIXEL_TOON_GLSL

const int CAZTOON_LEAF1_BLOCK_ID = 10201;
const int CAZTOON_LEAF1_REDUCED_BLOCK_ID = 201;

bool _e4o816(int _w99178) {
return _w99178 == CAZTOON_LEAF1_BLOCK_ID || _w99178 == CAZTOON_LEAF1_REDUCED_BLOCK_ID;
}

vec3 _8w1fma(vec3 _yssmf1, int _w99178, float _7fkei4) {
if (!_e4o816(_w99178)) {
return _yssmf1;
}

float _nqerdc = clamp(_7fkei4, 0.0, 4.0);

vec3 _p6bxo1 = _yssmf1 * vec3(1.06, 1.06, 0.78);
vec3 _uan8k1 = _yssmf1 * vec3(0.78, 0.95, 0.66);
vec3 _6i83aa = _yssmf1 * vec3(0.58, 0.78, 0.55);
vec3 _ru44yf = _yssmf1 * vec3(0.42, 0.62, 0.49);
vec3 _3n0xc1 = _yssmf1 * vec3(0.30, 0.48, 0.42);

vec3 _diiscg = _p6bxo1;
_diiscg = mix(_diiscg, _uan8k1, smoothstep(0.65, 1.25, _nqerdc));
_diiscg = mix(_diiscg, _6i83aa, smoothstep(1.65, 2.25, _nqerdc));
_diiscg = mix(_diiscg, _ru44yf, smoothstep(2.65, 3.25, _nqerdc));
_diiscg = mix(_diiscg, _3n0xc1, smoothstep(3.55, 4.0, _nqerdc));

return _diiscg;
}

#endif
