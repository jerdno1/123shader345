float _fzhskc(vec2 p) {
return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float _cks7vw(vec2 p) {
vec2 i = floor(p);
vec2 f = fract(p);
f = f * f * (3.0 - 2.0 * f);
float a = _fzhskc(i);
float b = _fzhskc(i + vec2(1.0, 0.0));
float c = _fzhskc(i + vec2(0.0, 1.0));
float d = _fzhskc(i + vec2(1.0, 1.0));
return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float _yuyzge(vec3 p) {
p = fract(p * vec3(0.1031, 0.1030, 0.0973));
p += dot(p, p.yzx + 33.33);
return fract((p.x + p.y) * p.z);
}

float _lpglwu(vec3 p) {
vec3 i = floor(p);
vec3 f = fract(p);
f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

float a = _yuyzge(mod(i,               vec3(289.0)));
float b = _yuyzge(mod(i + vec3(1,0,0), vec3(289.0)));
float c = _yuyzge(mod(i + vec3(0,1,0), vec3(289.0)));
float d = _yuyzge(mod(i + vec3(1,1,0), vec3(289.0)));
float e = _yuyzge(mod(i + vec3(0,0,1), vec3(289.0)));
float g = _yuyzge(mod(i + vec3(1,0,1), vec3(289.0)));
float h = _yuyzge(mod(i + vec3(0,1,1), vec3(289.0)));
float k = _yuyzge(mod(i + vec3(1,1,1), vec3(289.0)));

return mix(mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
mix(mix(e, g, f.x), mix(h, k, f.x), f.y), f.z);
}
