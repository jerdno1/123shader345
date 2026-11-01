vec3 _j0nlr9(vec3 c) {
vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
float d = q.x - min(q.w, q.y);
float e = 1.0e-10;
return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 _ks5u3i(vec3 c) {
vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 _srsa76(vec3 _yssmf1, float _mg3t00, float _a8645a) {
vec3 _s0lzby = _j0nlr9(_yssmf1);
_s0lzby.x = fract(_s0lzby.x + _mg3t00 / 360.0);
_s0lzby.y *= _a8645a;
return _ks5u3i(_s0lzby);
}

vec3 _s36mo2(float _e30o2u) {
float h = mod(_e30o2u, 360.0) / 60.0;
float x = 1.0 - abs(mod(h, 2.0) - 1.0);

vec3 rgb;
if (h < 1.0) rgb = vec3(1.0, x, 0.0);
else if (h < 2.0) rgb = vec3(x, 1.0, 0.0);
else if (h < 3.0) rgb = vec3(0.0, 1.0, x);
else if (h < 4.0) rgb = vec3(0.0, x, 1.0);
else if (h < 5.0) rgb = vec3(x, 0.0, 1.0);
else rgb = vec3(1.0, 0.0, x);

return rgb;
}

vec3 _1lfi6y(vec3 _yssmf1, float _e30o2u, float _kytein, float _zj0avb) {
if (_kytein < 0.001) return _yssmf1;

float _8s1sib = _e30o2u > 0.0 ? 180.0 + _e30o2u : 360.0 + _e30o2u;
vec3 _z6rtf0 = _s36mo2(_8s1sib);

_z6rtf0 = mix(vec3(1.0), _z6rtf0, clamp(_zj0avb, 0.0, 5.0));

vec3 _l43hgk = _yssmf1 * _z6rtf0;

return mix(_yssmf1, _l43hgk, clamp(_kytein, 0.0, 1.0));
}

vec3 _kuinxe(vec3 _8tqn4j, vec3 _ae2wjm, float t) {
vec3 _nqfeog = _j0nlr9(_8tqn4j);
vec3 _ikdjdr = _j0nlr9(_ae2wjm);

float _tmjlkl = _ikdjdr.x - _nqfeog.x;
if (_tmjlkl > 0.5) _nqfeog.x += 1.0;
else if (_tmjlkl < -0.5) _ikdjdr.x += 1.0;

vec3 _vzi334 = mix(_nqfeog, _ikdjdr, t);
_vzi334.x = fract(_vzi334.x);

return _ks5u3i(_vzi334);
}

vec3 _5cn91p(vec3 _8tqn4j, vec3 _ae2wjm, float t) {

vec3 _emypmh = mix(_8tqn4j, _ae2wjm, t);

float _50z1vp = 1.0 + 0.3 * sin(t * 3.14159);
vec3 _s0lzby = _j0nlr9(_emypmh);
_s0lzby.y = min(_s0lzby.y * _50z1vp, 1.0);

return _ks5u3i(_s0lzby);
}
