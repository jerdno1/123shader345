bool _6exsk1(float _swfcra) {
return _swfcra > 0.00001 && _swfcra < 0.999999;
}

bool _3bkmax(vec2 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9));
}

bool _3bkmax(vec4 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9));
}

bool _c82v48(vec4 _ino0s9) {
return _3bkmax(_ino0s9) && _ino0s9.a >= 0.0 && _ino0s9.a <= 1.0001;
}

vec2 _9wkdzz(vec2 uv, sampler2D depthTex) {
float _swfcra = texture(depthTex, uv).r;
vec3 _gpy6je = vec3(uv, _swfcra) * 2.0 - 1.0;

vec4 viewPos = gbufferProjectionInverse * vec4(_gpy6je, 1.0);
if (!_3bkmax(viewPos.xy) || isnan(viewPos.z) || isinf(viewPos.z) ||
isnan(viewPos.w) || isinf(viewPos.w) || abs(viewPos.w) <= 1e-7) {
return vec2(-1.0);
}
viewPos /= viewPos.w;
viewPos = gbufferModelViewInverse * viewPos;
if (!_3bkmax(viewPos.xy) || isnan(viewPos.z) || isinf(viewPos.z)) return vec2(-1.0);

vec3 _55xmlz = cameraPosition - previousCameraPosition;
_55xmlz *= float(_6exsk1(_swfcra));

vec4 _pov7tg = viewPos + vec4(_55xmlz, 0.0);
_pov7tg = gbufferPreviousModelView * _pov7tg;
_pov7tg = gbufferPreviousProjection * _pov7tg;
if (!_3bkmax(_pov7tg.xy) || isnan(_pov7tg.w) || isinf(_pov7tg.w) || abs(_pov7tg.w) <= 1e-7) {
return vec2(-1.0);
}
vec2 _fkdz6q = _pov7tg.xy / _pov7tg.w * 0.5 + 0.5;
return _3bkmax(_fkdz6q) ? _fkdz6q : vec2(-1.0);
}

vec2 _lardia(vec2 uv) {

vec4 _f1qe0z = vec4(uv * 2.0 - 1.0, 1.0, 1.0);
vec4 _jsao2g = gbufferProjectionInverse * _f1qe0z;
if (!_3bkmax(_jsao2g.xy) || isnan(_jsao2g.z) || isinf(_jsao2g.z) ||
isnan(_jsao2g.w) || isinf(_jsao2g.w) || abs(_jsao2g.w) <= 1e-7) {
return vec2(-1.0);
}
vec3 _u9vn26 = _jsao2g.xyz / _jsao2g.w;
float _oqoa2l = dot(_u9vn26, _u9vn26);
if (isnan(_oqoa2l) || isinf(_oqoa2l) || _oqoa2l <= 1e-12) return vec2(-1.0);
vec3 viewDir = _u9vn26 * inversesqrt(_oqoa2l);

vec3 _st4awd = mat3(gbufferModelViewInverse) * viewDir;

vec3 _r3390j = mat3(gbufferPreviousModelView) * _st4awd;

vec4 _032ij2 = gbufferPreviousProjection * vec4(_r3390j, 0.0);

if (!_3bkmax(_r3390j.xy) || isnan(_r3390j.z) || isinf(_r3390j.z) || abs(_r3390j.z) <= 1e-7) {
return vec2(-1.0);
}
vec2 _siftnl = _032ij2.xy / -_r3390j.z * 0.5;

_siftnl = vec2(_r3390j.x / -_r3390j.z, _r3390j.y / -_r3390j.z);

_siftnl.x *= gbufferPreviousProjection[0][0];
_siftnl.y *= gbufferPreviousProjection[1][1];
vec2 _fkdz6q = _siftnl * 0.5 + 0.5;
return _3bkmax(_fkdz6q) ? _fkdz6q : vec2(-1.0);
}

vec4 _0ozqnf(vec4 _gc5n04, sampler2D historyTex, vec2 uv) {
return _gc5n04;
}

vec4 _luv9fi(vec4 _gc5n04, sampler2D historyTex, sampler2D depthTex, vec2 uv) {
vec2 _q117e6 = _9wkdzz(uv, depthTex);

bool _nhjh2p = _q117e6.x > 0.0 && _q117e6.x < 1.0 &&
_q117e6.y > 0.0 && _q117e6.y < 1.0;

if (!_nhjh2p) return _c82v48(_gc5n04) ? _gc5n04 : vec4(0.0);

vec4 _k4oy3s = texture(historyTex, _q117e6);
bool _jy62f3 = _c82v48(_gc5n04);
bool _ztx9cf = _c82v48(_k4oy3s);

if (!_jy62f3) return _ztx9cf ? _k4oy3s : vec4(0.0);
if (_gc5n04.a <= 0.0001 && dot(abs(_gc5n04.rgb), vec3(1.0)) <= 0.0001) return _gc5n04;

if (!_ztx9cf || _k4oy3s == vec4(0.0)) return _gc5n04;

float _6qwad8 = max(_gc5n04.r, max(_gc5n04.g, _gc5n04.b));
float _aslobc = min(_gc5n04.r, min(_gc5n04.g, _gc5n04.b));
float _zj0avb = (_6qwad8 > 0.001) ? (_6qwad8 - _aslobc) / _6qwad8 : 0.0;
float _i9dj3b = _6qwad8;

float _8x4juw = smoothstep(0.1, 0.5, _i9dj3b) * 0.55;
_8x4juw *= 1.0 - smoothstep(0.3, 0.7, _zj0avb);
float _rhnvg2 = mix(0.85 - _8x4juw, 0.95, smoothstep(0.3, 0.7, _zj0avb));

float _swfcra = texture(depthTex, uv).r;

if (_swfcra < 0.56) return _gc5n04;

if (!_6exsk1(_swfcra)) _rhnvg2 *= mix(0.5, 1.0, smoothstep(0.3, 0.7, _zj0avb));

vec4 _8izj9y = mix(_gc5n04, _k4oy3s, _rhnvg2);
return _c82v48(_8izj9y) ? _8izj9y : _gc5n04;
}

vec4 _luv9fi(sampler2D currentTex, sampler2D historyTex, sampler2D depthTex, vec2 uv) {
return _luv9fi(texture(currentTex, uv), historyTex, depthTex, uv);
}
