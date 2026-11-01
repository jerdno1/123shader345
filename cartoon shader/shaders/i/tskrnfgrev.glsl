#ifndef OCEAN_WAVES_GLSL
#define OCEAN_WAVES_GLSL

vec2 _9r44dy(vec2 _d8i1xw, vec2 _zw1fcv, float _a4mjmv, float _id7095) {
float x = dot(_zw1fcv, _d8i1xw) * _a4mjmv + _id7095;
float _8ystdl = exp(sin(x) - 1.0);
float dx = _8ystdl * cos(x);
return vec2(_8ystdl, -dx);
}

float _v3mxzl(vec2 _d8i1xw, float _bim3ym, int _9q6nxy) {

float _tthu35 = 188.0 * 3.14159265 / 180.0;
float wc = cos(_tthu35), ws = sin(_tthu35);
_d8i1xw = vec2(wc * _d8i1xw.x - ws * _d8i1xw.y, ws * _d8i1xw.x + wc * _d8i1xw.y);
_d8i1xw.x *= 1.15;
vec2 _5e4dwu = vec2(cos(_tthu35), sin(_tthu35));
float _rx5ubx = length(_d8i1xw) * 0.1;
float _2aoq7x = 0.0;
float _oah0e7 = 1.0;
float _5uockt = 2.0;
float _d8tv7f = 1.0;
float _kiwu3k = 0.0;
float _sdncfw = 0.0;
for (int i = 0; i < _9q6nxy; i++) {
vec2 _llxraj = vec2(sin(_2aoq7x), cos(_2aoq7x));
_llxraj = normalize(mix(_llxraj, _5e4dwu * sign(dot(_llxraj, _5e4dwu)), 0.55));
vec2 _9x8roc = _9r44dy(_d8i1xw, _llxraj, _oah0e7, _bim3ym * _5uockt + _rx5ubx);
_d8i1xw += _llxraj * _9x8roc.y * _d8tv7f * OCEAN_WAVE_DRAG;
_kiwu3k += _9x8roc.x * _d8tv7f;
_sdncfw += _d8tv7f;
_d8tv7f = mix(_d8tv7f, 0.0, 0.2);
_oah0e7 *= 1.45;
_5uockt *= 1.08;
_2aoq7x += 2692.0;
}
return _kiwu3k / _sdncfw;
}

float _45bx2x(vec2 _d8i1xw, float _bim3ym, int _9q6nxy) {
float _0q333t = _v3mxzl(_d8i1xw, _bim3ym, _9q6nxy);

float _pkw3ft = (_0q333t - 0.53) * 2.0;
float _q0br7e = tanh(_pkw3ft) * 0.5 + 0.5;
float h = clamp(_q0br7e, 0.0, 1.0);
h = pow(h, 0.7);
return h;
}

float _bfhp87(vec2 _d8i1xw, float _bim3ym, int _9q6nxy) {

float _tthu35 = 188.0 * 3.14159265 / 180.0;
float wc = cos(_tthu35), ws = sin(_tthu35);
_d8i1xw = vec2(wc * _d8i1xw.x - ws * _d8i1xw.y, ws * _d8i1xw.x + wc * _d8i1xw.y);
_d8i1xw.x *= 1.15;
vec2 _5e4dwu = vec2(cos(_tthu35), sin(_tthu35));
float _rx5ubx = length(_d8i1xw) * 0.1;
float _2aoq7x = 0.0;
float _oah0e7 = 1.0;
float _5uockt = 2.0;
float _d8tv7f = 1.0;
float _kiwu3k = 0.0;
for (int i = 0; i < _9q6nxy; i++) {
vec2 _llxraj = vec2(sin(_2aoq7x), cos(_2aoq7x));
_llxraj = normalize(mix(_llxraj, _5e4dwu * sign(dot(_llxraj, _5e4dwu)), 0.55));
vec2 _9x8roc = _9r44dy(_d8i1xw, _llxraj, _oah0e7, _bim3ym * _5uockt + _rx5ubx);
_d8i1xw += _llxraj * _9x8roc.y * _d8tv7f * OCEAN_WAVE_DRAG;
_kiwu3k += _9x8roc.x * _d8tv7f;
_d8tv7f = mix(_d8tv7f, 0.0, 0.2);
_oah0e7 *= 1.45;
_5uockt *= 1.08;
_2aoq7x += 2692.0;
}
return _kiwu3k;
}

vec3 _d39cs2(vec2 _d8i1xw, float _bim3ym, int _9q6nxy) {
float e = 0.01;
float _swfcra = 0.005;
float H  = _bfhp87(_d8i1xw, _bim3ym, _9q6nxy) * _swfcra;
float Hx = _bfhp87(_d8i1xw - vec2(e, 0.0), _bim3ym, _9q6nxy) * _swfcra;
float Hz = _bfhp87(_d8i1xw + vec2(0.0, e), _bim3ym, _9q6nxy) * _swfcra;

float _sua1ci = (H - Hx) / e;
float _w49331 = (Hz - H) / e;

return normalize(vec3(-_sua1ci, 1.0, -_w49331));
}

#endif
