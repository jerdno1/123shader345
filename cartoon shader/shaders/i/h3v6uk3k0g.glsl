vec2 neighbourOffsets[8] = vec2[8](
vec2( 0.0, -1.0),
vec2(-1.0,  0.0),
vec2( 1.0,  0.0),
vec2( 0.0,  1.0),
vec2(-1.0, -1.0),
vec2( 1.0, -1.0),
vec2(-1.0,  1.0),
vec2( 1.0,  1.0)
);

vec2 _2ljfpb(vec3 _gpy6je) {
_gpy6je = _gpy6je * 2.0 - 1.0;

vec4 _lrrcua = gbufferProjectionInverse * vec4(_gpy6je, 1.0);
_lrrcua /= _lrrcua.w;
_lrrcua = gbufferModelViewInverse * _lrrcua;

vec3 _55xmlz = cameraPosition - previousCameraPosition;

_55xmlz *= float(_gpy6je.z > 0.56);

vec4 _ftqlvi = _lrrcua + vec4(_55xmlz, 0.0);
_ftqlvi = gbufferPreviousModelView * _ftqlvi;
_ftqlvi = gbufferPreviousProjection * _ftqlvi;
return _ftqlvi.xy / _ftqlvi.w * 0.5 + 0.5;
}

vec3 _z5oe3a(sampler2D _r4digw, vec2 uv, vec2 _9x8roc) {
vec2 _d8i1xw = uv * _9x8roc;
vec2 _l4naxv = floor(_d8i1xw - 0.5) + 0.5;
vec2 f = _d8i1xw - _l4naxv;
vec2 f2 = f * f;
vec2 f3 = f * f2;

float c = 0.7;
vec2 w0 =        -c  * f3 +  2.0 * c         * f2 - c * f;
vec2 w1 =  (2.0 - c) * f3 - (3.0 - c)        * f2         + 1.0;
vec2 w2 = -(2.0 - c) * f3 + (3.0 -  2.0 * c) * f2 + c * f;
vec2 w3 =         c  * f3 -                c  * f2;

vec2 _kbsbwr = w1 + w2;
vec2 _nzxbmo = (_l4naxv + w2 / _kbsbwr) / _9x8roc;
vec2 _a5ens6 = (_l4naxv - 1.0) / _9x8roc;
vec2 _b4ikt0 = (_l4naxv + 2.0) / _9x8roc;

vec4 _yssmf1 = vec4(textureLod(_r4digw, vec2(_nzxbmo.x, _a5ens6.y ), 0).rgb, 1.0) * (_kbsbwr.x * w0.y ) +
vec4(textureLod(_r4digw, vec2(_a5ens6.x,  _nzxbmo.y), 0).rgb, 1.0) * (w0.x  * _kbsbwr.y) +
vec4(textureLod(_r4digw, vec2(_nzxbmo.x, _nzxbmo.y), 0).rgb, 1.0) * (_kbsbwr.x * _kbsbwr.y) +
vec4(textureLod(_r4digw, vec2(_b4ikt0.x,  _nzxbmo.y), 0).rgb, 1.0) * (w3.x  * _kbsbwr.y) +
vec4(textureLod(_r4digw, vec2(_nzxbmo.x, _b4ikt0.y ), 0).rgb, 1.0) * (_kbsbwr.x * w3.y );
return _yssmf1.rgb / _yssmf1.a;
}

vec3 _06sdnf(vec3 _59bql9) {
return vec3(
_59bql9.r * 0.25 + _59bql9.g * 0.5 + _59bql9.b * 0.25,
_59bql9.r * 0.5 - _59bql9.b * 0.5,
_59bql9.r * -0.25 + _59bql9.g * 0.5 + _59bql9.b * -0.25
);
}

vec3 _ikl862(vec3 _59bql9) {
float n = _59bql9.r - _59bql9.b;
return vec3(n + _59bql9.g, _59bql9.r + _59bql9.b, n - _59bql9.g);
}

vec3 _5djbqg(vec3 q, vec3 _34lgx4, vec3 _lcfuk8) {
vec3 _0igbml = 0.5 * (_lcfuk8 + _34lgx4);
vec3 _s6pzck = 0.5 * (_lcfuk8 - _34lgx4) + 0.00000001;

vec3 _1uyq0q = q - _0igbml;
vec3 _2supsb = _1uyq0q / _s6pzck;
vec3 _dpgsbm = abs(_2supsb);
float _zofmbr = max(_dpgsbm.x, max(_dpgsbm.y, _dpgsbm.z));

if (_zofmbr > 1.0)
return _0igbml + _1uyq0q / _zofmbr;
else
return q;
}

vec3 _9kufa4(sampler2D currentTex, vec2 uv, vec3 _yssmf1, vec3 _3pud0t, vec2 _mcr0en) {
vec3 _07a51c = _06sdnf(_yssmf1);
vec3 _jkyfgo = _07a51c;

for (int i = 0; i < 8; i++) {
vec3 _gbnfxo = textureLod(currentTex, uv + neighbourOffsets[i] * _mcr0en, 0.0).rgb;
_gbnfxo = _06sdnf(_gbnfxo);
_07a51c = min(_07a51c, _gbnfxo);
_jkyfgo = max(_jkyfgo, _gbnfxo);
}

_3pud0t = _06sdnf(_3pud0t);
_3pud0t = _5djbqg(_3pud0t, _07a51c, _jkyfgo);
return _ikl862(_3pud0t);
}

void _zw72f2(inout vec3 _yssmf1, sampler2D currentTex, sampler2D historyTex, vec2 _tthgbs) {
vec2 _jsao2g = vec2(viewWidth, viewHeight);
float _swfcra = texture(depthtex1, _tthgbs).r;

vec3 _5zlm8i = vec3(_tthgbs, _swfcra);
vec2 _9krdj7 = _2ljfpb(_5zlm8i);

vec3 _3pud0t = _z5oe3a(historyTex, _9krdj7, _jsao2g);

if (_3pud0t == vec3(0.0)) {
return;
}

_3pud0t = _9kufa4(currentTex, _tthgbs, _yssmf1, _3pud0t, 1.0 / _jsao2g);

vec2 _fjkt1r = (_tthgbs - _9krdj7) * _jsao2g;
float _qqi2yr = float(
_9krdj7.x > 0.0 && _9krdj7.x < 1.0 &&
_9krdj7.y > 0.0 && _9krdj7.y < 1.0
);
_qqi2yr *= exp(-length(_fjkt1r)) * 0.2 + 0.7;

_yssmf1 = mix(_yssmf1, _3pud0t, _qqi2yr);
}
