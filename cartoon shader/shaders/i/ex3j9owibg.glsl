vec3 _57tmdt(vec3 c) {
float _6qwad8 = max(max(c.r, c.g), c.b);
float _aslobc = min(min(c.r, c.g), c.b);
float l = (_6qwad8 + _aslobc) * 0.5;

if (_6qwad8 - _aslobc < 1e-6) return vec3(0.0, 0.0, l);

float d = _6qwad8 - _aslobc;
float s = (l > 0.5) ? d / (2.0 - _6qwad8 - _aslobc) : d / (_6qwad8 + _aslobc);

float h;
if (_6qwad8 == c.r) {
h = (c.g - c.b) / d + (c.g < c.b ? 6.0 : 0.0);
} else if (_6qwad8 == c.g) {
h = (c.b - c.r) / d + 2.0;
} else {
h = (c.r - c.g) / d + 4.0;
}
h /= 6.0;

return vec3(h, s, l);
}

float _fnr183(float _eir7ue, float _ez2tne, float x) {
return clamp((x - _eir7ue) / (_ez2tne - _eir7ue + 1e-6), 0.0, 1.0);
}

float _7koo1j(vec3 _31zkex, float _8rsgn5, float _fi5ef6) {
if (_31zkex.y < 0.01 || _31zkex.z < 0.01) return 0.0;
float _zc62yo = _31zkex.x * 360.0;
float _t25r5m = abs(_zc62yo - _8rsgn5);
_t25r5m = min(_t25r5m, 360.0 - _t25r5m);
return 1.0 - clamp(_t25r5m / _fi5ef6, 0.0, 1.0);
}

float _34ubaq(float x) { return x * x * x; }

float _xojoff(int et, vec3 _dwo81a) {
vec3 _31zkex = _57tmdt(_dwo81a);
vec3 _bigpbv = sqrt(max(_dwo81a, vec3(0.0)));
float _03pwhf = (_bigpbv.r + _bigpbv.g + _bigpbv.b) / 3.0;

if (et == 0) {
return 0.85 * _03pwhf * _31zkex.z * _fnr183(0.4, 0.6, 0.2 * _31zkex.y + 0.55 * _31zkex.z);
}

if (et == 16) {
return 0.85 * _03pwhf * _31zkex.z * _fnr183(0.4, 0.6, 0.2 * _31zkex.y + 0.55 * _31zkex.z);
}

if (et == -14 || et == 15) {

float _625rvl = _7koo1j(_31zkex, 198.0, 36.0);
if (_625rvl > 0.3) {

float _fg6oks = _fnr183(0.30, 0.45, _31zkex.z);
float _8babve = _fnr183(0.15, 0.35, _31zkex.y);
return 0.90 * _03pwhf * max(_fg6oks * _8babve, _fnr183(0.55, 0.70, _31zkex.z));
}

return 0.85 * _03pwhf * _31zkex.z * _fnr183(0.4, 0.6, 0.2 * _31zkex.y + 0.55 * _31zkex.z);
}

if (et == 30) {
return 0.85 * _03pwhf * _fnr183(0.78, 0.85, _31zkex.z);
}

if (et == 1 || et == 23) {

float _fg6oks = _fnr183(0.20, 0.35, _31zkex.z);
float _8babve = _fnr183(0.10, 0.25, _31zkex.y);
return 0.90 * _03pwhf * max(_fg6oks * _8babve, _fnr183(0.45, 0.60, _31zkex.z));
}

if (et == 2) {
return 0.80 * _03pwhf * (0.1 + 0.9 * _34ubaq(_31zkex.z));
}

if (et == 19) {
return 2.0 * _03pwhf * (0.2 + 0.8 * _7koo1j(_31zkex, 30.0, 15.0)) * step(0.4, _31zkex.y) * _31zkex.z;
}

if (et == 20 || et == 5) {
return 0.60 * _03pwhf * (0.1 + 0.9 * _34ubaq(_31zkex.z));
}

if (et == 39) return 0.20;
if (et == 40) return 0.05;
if (et == 41) return 0.008;

if (et == 3) {
return 0.85 * _03pwhf * _31zkex.z * _fnr183(0.4, 0.6, 0.2 * _31zkex.y + 0.55 * _31zkex.z);
}

if (et == 4 || et == 12) {
return 1.0 * _03pwhf * (0.1 + 0.9 * _34ubaq(_31zkex.z));
}

if (et == 24) {
return _03pwhf * step(0.2, _31zkex.z);
}

if (et == 6 || et == 18) {
float _u82o4j = _dwo81a.r / max(_dwo81a.g + _dwo81a.b, 0.001);
float l = 0.5 * (min(min(_dwo81a.r, _dwo81a.g), _dwo81a.b) + max(max(_dwo81a.r, _dwo81a.g), _dwo81a.b));
return 0.33 * _03pwhf * step(0.45, _u82o4j * l);
}

if (et == 7 || et == 8 || et == 9 || et == 31 || et == 32 || et == 33) {
return 0.40 * _03pwhf * (0.1 + 0.9 * _34ubaq(_31zkex.z));
}

if (et == 10) {
return 1.0;
}

if (et == 11 || et == 13) {
return 0.66 * _03pwhf * _fnr183(0.75, 0.9, _31zkex.z);
}

if (et == 14) {
return 0.2 * _03pwhf * (0.1 + 0.9 * _31zkex.z * _31zkex.z * _31zkex.z * _31zkex.z);
}

if (et == 17) {
float _ibo5av = _7koo1j(_31zkex, 200.0, 30.0);
return 1.0 * _03pwhf * _fnr183(0.35, 0.42, 0.2 * _31zkex.y + 0.5 * _31zkex.z + 0.1 * _ibo5av);
}

if (et == 21) {
return 0.85 * _03pwhf * _fnr183(0.77, 0.85, _31zkex.z);
}

if (et == 22) {
return 0.80 * _03pwhf * step(0.73, 0.8 * _31zkex.z);
}

if (et == 25) {
return 0.33 * _03pwhf * _7koo1j(_31zkex, 120.0, 50.0);
}

if (et == 26 || et == 36 || et == 37) {
return 0.2 * _03pwhf * _7koo1j(_31zkex, 200.0, 40.0) * smoothstep(0.5, 0.7, _31zkex.z);
}

if (et == 27) {
return 0.75 * _7koo1j(_31zkex, 310.0, 50.0);
}

if (et == 28) {
return 0.5 * _03pwhf * _fnr183(0.5, 0.6, _31zkex.z);
}

if (et == 29) {
return 0.80 * _03pwhf * step(0.73, 0.1 * _31zkex.y + 0.7 * _31zkex.z);
}

if (et == 34) {
return 0.3 * _03pwhf * _fnr183(0.5, 0.7, _31zkex.z);
}

if (et == 35) {
return 0.20 * _03pwhf * (0.1 + 0.9 * _31zkex.z);
}

if (et == 44) {
return 0.05;
}

if (et == 38) {
return 0.33 * _03pwhf;
}

if (et == 45) {
return 0.30;
}

if (et == 46 || et == 47) {
return 0.85;
}

if (et == 39) {
return 0.9 * _03pwhf * step(0.5, _31zkex.y);
}

if (et == 68) {
return 1.0;
}

if (et == 43) {
return 1.0;
}

return _03pwhf * (0.1 + 0.9 * _34ubaq(_31zkex.z));
}
