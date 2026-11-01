#ifdef LAVA_CRUST_ENABLED

vec3 _rmzct0(vec3 _yssmf1, vec3 _wb02o7, vec3 N) {

#ifndef VOXY_PROGRAM
if (biome == 82 && abs(N.y) > 0.5) {
vec2 _xe63ks = floor(_wb02o7.xz * 16.0) / 16.0;
float t = frameTimeCounter * 0.15;

float _huatah = atan(_xe63ks.y - floor(_xe63ks.y / 6.0) * 6.0 - 3.0,
_xe63ks.x - floor(_xe63ks.x / 6.0) * 6.0 - 3.0);
float _t25r5m = length(vec2(_xe63ks.x - floor(_xe63ks.x / 6.0) * 6.0 - 3.0,
_xe63ks.y - floor(_xe63ks.y / 6.0) * 6.0 - 3.0));

float s1 = sin(_huatah * 2.0 + _t25r5m * 5.0 - t * 1.5) * 0.5 + 0.5;

vec2 _lyv2vi = _xe63ks + vec2(2.7, 1.3);
float a2 = atan(_lyv2vi.y - floor(_lyv2vi.y / 8.0) * 8.0 - 4.0,
_lyv2vi.x - floor(_lyv2vi.x / 8.0) * 8.0 - 4.0);
float d2 = length(vec2(_lyv2vi.x - floor(_lyv2vi.x / 8.0) * 8.0 - 4.0,
_lyv2vi.y - floor(_lyv2vi.y / 8.0) * 8.0 - 4.0));
float s2 = sin(a2 * 3.0 - d2 * 4.0 + t * 1.2) * 0.5 + 0.5;

float _za3y2e = _lpglwu(vec3(_xe63ks * 2.0, t * 0.3)) * 0.5 + 0.5;
float _mlggni = mix(s1, s2, 0.4) * 0.7 + _za3y2e * 0.3;

float _ai0jb5 = smoothstep(0.05, 0.55, _mlggni);
_ai0jb5 = floor(_ai0jb5 * 7.0 + 0.5) / 7.0;
float _a58f6r = smoothstep(0.05, 0.8, _mlggni);
_a58f6r = floor(_a58f6r * 7.0 + 0.5) / 7.0;

vec3 _c7mktm = mix(_yssmf1 * 0.15, _yssmf1 * 0.5, _a58f6r);
vec3 _hvijkq = mix(_yssmf1, _c7mktm, _ai0jb5);
_hvijkq = max(vec3(0.01), _hvijkq);

float _ra6fay = (_wb02o7.y > 30.0 && _wb02o7.y < 32.0) ? 1.0 : 0.5;
return mix(_yssmf1, _hvijkq, LAVA_NOISE_INTENSITY * _ra6fay);
}
#endif

float _zdxp7g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
float _9v5zln = _zdxp7g * 7.48 + 0.5;

float _9tapbf = 1.0 - abs(N.y);

vec2 _yvoel9 = (floor(_wb02o7.xz * 16.0) + _wb02o7.y * 32.0) * 0.000666;
vec2 _bywy68 = vec2(frameTimeCounter * 0.012, 0.0);

float _bfcizj = -1.0 * LAVA_NOISE_AMOUNT;
float _x4fzef = LAVA_NOISE_INTENSITY;
vec3 _zei33g = _yssmf1;

float e2 = _9v5zln * 0.50;
e2 = e2 * e2; e2 = e2 * e2;
_zei33g += min(e2, 0.2) * LAVA_TEMPERATURE * 0.65;

if (_9tapbf > 0.5) {
vec3 _52givv = floor(_wb02o7 * 16.0) / 16.0;
float _9qq73p = frameTimeCounter * 0.7;

float _0k1meq = _lpglwu(vec3(_52givv.x * 3.0, (_52givv.y + _9qq73p) * 0.8, _52givv.z * 3.0)) * 0.3;
_0k1meq += _lpglwu(vec3(_52givv.x * 1.5, (_52givv.y + _9qq73p) * 0.4, _52givv.z * 1.5)) * 0.4;

float _ww5u1b = _lpglwu(vec3(_52givv.x * 0.5, 0.0, _52givv.z * 0.5)) * 12.0;

float _cofhbo = sin((_52givv.y + _9qq73p) * 0.7 + _0k1meq + _ww5u1b) * 0.5 + 0.5;

float _za3y2e = _lpglwu(_52givv * 2.5 + vec3(0.0, _9qq73p * 0.5, 0.0)) * 0.5 + 0.5;
_za3y2e -= (_lpglwu(_52givv * 8.0 + vec3(0.0, _9qq73p * 0.3, 0.0)) * 0.5 + 0.5) * 0.08;
_za3y2e += (_lpglwu(_52givv * 5.0 + vec3(0.0, _9qq73p * 0.2, 0.0)) * 0.5 + 0.5) * 0.3;
_cofhbo = clamp(_cofhbo * 0.45 + _za3y2e * 0.55, 0.0, 1.0);

float _ai0jb5 = 1.0 - pow(_cofhbo, 5.0);
_ai0jb5 = floor(_ai0jb5 * 7.0 + 0.5) / 7.0;

float _swfcra = sqrt(_cofhbo);
_swfcra = floor(_swfcra * 7.0 + 0.5) / 7.0;
vec3 _c7mktm = mix(vec3(0.25, 0.05, 0.02), vec3(0.71, 0.16, 0.07), _swfcra);
_zei33g = mix(_yssmf1, _c7mktm, _ai0jb5 * 0.6);

_zei33g = max(vec3(0.01), _zei33g);
return mix(_yssmf1, _zei33g, _x4fzef);
}

#ifdef LAVA_HAS_NOISETEX
_bfcizj += texture2DLod(noisetex, _yvoel9 * 0.15 + _bywy68 * 0.1, 2.0).r;
_bfcizj -= texture2DLod(noisetex, _yvoel9 * 5.0 + _bywy68 * 0.05, 3.0).g * 0.08;
_bfcizj += texture2DLod(noisetex, _yvoel9 * 1.5 + _bywy68 * 0.03, 2.0).r * 0.45;
_bfcizj *= texture2DLod(noisetex, _yvoel9 * 0.05 + _bywy68 * 0.02, 2.0).r * 0.5;
_9v5zln *= 1.6;
float _ai0jb5 = smoothstep(0.05, 0.55, _bfcizj);
_ai0jb5 = floor(_ai0jb5 * 7.0 + 0.5) / 7.0;
float _swfcra = smoothstep(0.05, 0.8, _bfcizj);
_swfcra = floor(_swfcra * 7.0 + 0.5) / 7.0;
vec3 _c7mktm = mix(vec3(0.71, 0.16, 0.07), vec3(0.25, 0.05, 0.02), _swfcra);
_zei33g = mix(_yssmf1, _c7mktm, _ai0jb5);
#else

_bfcizj += _lpglwu(vec3((_yvoel9 * 0.15 + _bywy68 * 0.1) * 256.0, 0.0));
_bfcizj -= _lpglwu(vec3((_yvoel9 * 5.0 + _bywy68 * 0.05) * 256.0, 0.0)) * 0.08;
_bfcizj += _lpglwu(vec3((_yvoel9 * 1.5 + _bywy68 * 0.03) * 256.0, 0.0)) * 0.45;
_bfcizj *= _lpglwu(vec3((_yvoel9 * 0.05 + _bywy68 * 0.02) * 256.0, 0.0)) * 0.5;
_9v5zln *= 1.6;
float _ai0jb5 = smoothstep(0.05, 0.55, _bfcizj);
_ai0jb5 = floor(_ai0jb5 * 7.0 + 0.5) / 7.0;
float _swfcra = smoothstep(0.05, 0.8, _bfcizj);
_swfcra = floor(_swfcra * 7.0 + 0.5) / 7.0;
vec3 _c7mktm = mix(vec3(0.71, 0.16, 0.07), vec3(0.25, 0.05, 0.02), _swfcra);
_zei33g = mix(_yssmf1, _c7mktm, _ai0jb5);
#endif

_zei33g = max(vec3(0.01), _zei33g);

float _ra6fay = (_wb02o7.y > 30.0 && _wb02o7.y < 32.0) ? 1.0 : 0.5;
_yssmf1 = mix(_yssmf1, _zei33g, _x4fzef * _ra6fay);

return _yssmf1;
}

#endif
