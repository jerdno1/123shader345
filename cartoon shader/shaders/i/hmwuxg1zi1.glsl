#ifndef PIXELATION_GLSL
#define PIXELATION_GLSL

#ifdef PIXELATED_SHADOWS

float _cfyq6b() {
return max(float(PIXELATED_SHADOW_GRID), 1.0);
}

vec2 _drci0d(vec2 uv, vec4 _s4ja50) {
vec2 _093yxc = (floor(uv * _s4ja50.zw) + 0.5) * _s4ja50.xy;
vec2 _565os1 = _093yxc - uv;

vec2 _s6osq5 = dFdx(uv);
vec2 _rewkyd = dFdy(uv);
float _vcwsb1 = _s6osq5.x * _rewkyd.y - _rewkyd.x * _s6osq5.y;
if (abs(_vcwsb1) < 1e-8 || dot(abs(_s6osq5) + abs(_rewkyd), vec2(1.0)) < 1e-8) {
return vec2(0.0);
}

mat2 _wgztq2 = mat2(_rewkyd.y, -_rewkyd.x, -_s6osq5.y, _s6osq5.x) * (1.0 / _vcwsb1);
return _565os1 * _wgztq2;
}

vec2 _qrjbox(sampler2D _r4digw, vec2 uv) {
vec2 _9zsy4a = vec2(textureSize(_r4digw, 0)) * (_cfyq6b() / 16.0);
return _drci0d(uv, vec4(1.0 / _9zsy4a, _9zsy4a));
}

vec2 _9fkx96(vec3 worldPos, vec3 _tkgg08) {
vec3 _w378yf = fract(worldPos);
vec3 _h8v0ry = abs(_tkgg08);

if (_h8v0ry.y >= _h8v0ry.x && _h8v0ry.y >= _h8v0ry.z) return _w378yf.xz;
if (_h8v0ry.x >= _h8v0ry.z) return _w378yf.zy;
return _w378yf.xy;
}

vec2 _jr7tr0(vec3 worldPos, vec3 _tkgg08) {
vec2 _n46wpv = _9fkx96(worldPos, _tkgg08);
vec2 _olkawy = vec2(_cfyq6b());
return _drci0d(_n46wpv, vec4(1.0 / _olkawy, _olkawy));
}

vec3 _bfimjh(vec3 _tkgg08) {
vec3 _h8v0ry = abs(_tkgg08);

if (_h8v0ry.y >= _h8v0ry.x && _h8v0ry.y >= _h8v0ry.z) return vec3(1.0, 0.0, 0.0);
if (_h8v0ry.x >= _h8v0ry.z) return vec3(0.0, 0.0, 1.0);
return vec3(1.0, 0.0, 0.0);
}

vec3 _sua9dj(vec3 _tkgg08) {
vec3 _h8v0ry = abs(_tkgg08);

if (_h8v0ry.y >= _h8v0ry.x && _h8v0ry.y >= _h8v0ry.z) return vec3(0.0, 0.0, 1.0);
return vec3(0.0, 1.0, 0.0);
}

vec3 _bm079d(vec3 _tkgg08, vec2 _2d3iqa) {
return _bfimjh(_tkgg08) * _2d3iqa.x
+ _sua9dj(_tkgg08) * _2d3iqa.y;
}

vec3 _fknrwx(vec3 _tkgg08, vec2 _xsqf5j) {
return _bm079d(_tkgg08, _xsqf5j / _cfyq6b());
}

vec3 _5kwiu1(vec3 worldPos, vec3 _tkgg08) {
vec2 _n46wpv = _9fkx96(worldPos, _tkgg08);
vec2 _olkawy = vec2(_cfyq6b());
vec2 _5ufes7 = (floor(_n46wpv * _olkawy) + 0.5) / _olkawy;
vec3 _uqemxl = worldPos + _bm079d(_tkgg08, _5ufes7 - _n46wpv);
return mix(worldPos, _uqemxl, clamp(PIXELATED_SHADOW_STRENGTH, 0.0, 1.0));
}

vec3 _yqlisi(vec3 _1gq9yg, vec2 _8bx2qx) {
if (dot(abs(_8bx2qx), vec2(1.0)) < 1e-8) return _1gq9yg;

vec3 dx = dFdx(_1gq9yg);
vec3 dy = dFdy(_1gq9yg);
vec3 _uu6zkv = _1gq9yg + clamp(dx * _8bx2qx.x + dy * _8bx2qx.y, vec3(-1.0), vec3(1.0));
return mix(_1gq9yg, _uu6zkv, clamp(PIXELATED_SHADOW_STRENGTH, 0.0, 1.0));
}

#endif

#endif
