float _zdldl1(float _swfcra) {
return (near * far) / (_swfcra * (near - far) + far);
}

float _wf8ve2(float _swfcra) {
return (dhNearPlane * dhFarPlane) / (_swfcra * (dhNearPlane - dhFarPlane) + dhFarPlane);
}

bool _7bqo1l(float _swfcra) {
return _swfcra > 0.00001 && _swfcra < 0.999999;
}

bool _yfr6tv(float _swfcra) {
return _swfcra > 0.00001 && _swfcra < 0.9999;
}

bool _ln18s1(float _ino0s9) {
return !isnan(_ino0s9) && !isinf(_ino0s9);
}

bool _ln18s1(vec2 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9));
}

bool _ln18s1(vec3 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9));
}

bool _ln18s1(vec4 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9));
}

vec3 _lcgfcm(vec3 _ino0s9, vec3 _8cc9nt) {
float _y1pmzg = dot(_ino0s9, _ino0s9);
if (!_ln18s1(_ino0s9) || !_ln18s1(_y1pmzg) || _y1pmzg <= 1e-12) {
return _8cc9nt;
}
return _ino0s9 * inversesqrt(_y1pmzg);
}

bool _c0ckez(mat4 _jggs5w, vec2 uv, float _swfcra, out vec3 _i7rmfc) {
vec4 _0l39cu = _jggs5w * vec4(uv * 2.0 - 1.0, _swfcra * 2.0 - 1.0, 1.0);
if (!_ln18s1(_0l39cu) || abs(_0l39cu.w) <= 1e-7) {
_i7rmfc = vec3(0.0);
return false;
}

_i7rmfc = _0l39cu.xyz / _0l39cu.w;
if (!_ln18s1(_i7rmfc)) {
_i7rmfc = vec3(0.0);
return false;
}
return true;
}

bool _cwcjr4(
mat4 _jggs5w,
mat4 _4thamm,
vec3 _6tcnvz,
vec2 uv,
float _swfcra,
out vec3 _ct0cij
) {
vec3 _i7rmfc;
if (!_c0ckez(_jggs5w, uv, _swfcra, _i7rmfc)) {
_ct0cij = _6tcnvz;
return false;
}

vec4 _rkmwqi = _4thamm * vec4(_i7rmfc, 1.0);
if (!_ln18s1(_rkmwqi)) {
_ct0cij = _6tcnvz;
return false;
}

_ct0cij = _rkmwqi.xyz + _6tcnvz;
return _ln18s1(_ct0cij);
}

bool _2fqi4q(mat4 vxProjInverse) {
if (!_ln18s1(vxProjInverse[0]) || !_ln18s1(vxProjInverse[1]) ||
!_ln18s1(vxProjInverse[2]) || !_ln18s1(vxProjInverse[3])) {
return false;
}
return dot(abs(vxProjInverse[3]), vec4(1.0)) > 1e-8;
}
