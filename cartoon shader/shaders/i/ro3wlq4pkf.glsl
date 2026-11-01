float _w8638d(vec3 worldPos, float _bim3ym, float thunderStrength) {
if (thunderStrength < 0.01) return 0.0;

float _jjyhed = 0.0;

for (int i = 0; i < 3; i++) {
float fi = float(i);

float _huatah = fi * 2.094 + _bim3ym * 0.03 + fi * 2.5;
float _t25r5m = 50.0 + fi * 30.0;
vec3 _utb10r = vec3(
cos(_huatah) * _t25r5m,
10.0 + fi * 20.0,
sin(_huatah) * _t25r5m
);

float d = length(worldPos - cameraPosition - _utb10r);
float _k05ot4 = 1.0 - smoothstep(5.0, 50.0, d);
if (_k05ot4 < 0.01) continue;

float _4rnwbu = LIGHTNING_INTERVAL + fi * 3.1;
float _tq26wd = fi * 5.7 + 1.3;
float t = mod(_bim3ym + _tq26wd, _4rnwbu);
float _pwnszl = smoothstep(0.0, 0.03, t) * (1.0 - smoothstep(0.06, 0.30, t));

float _qwg4zv = fract(sin(fi * 91.7 + floor((_bim3ym + _tq26wd) / _4rnwbu) * 37.3) * 43758.5453);
float _0v7t0i = 0.5 + 0.5 * _qwg4zv;

_jjyhed = max(_jjyhed, _pwnszl * _k05ot4 * _0v7t0i);
}

return _jjyhed * thunderStrength * LIGHTNING_BRIGHTNESS;
}
