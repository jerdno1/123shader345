/* RENDERTARGETS: 10 */

#include "/settings.glsl"

in vec2 texcoord;

uniform sampler2D colortex10;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;

float _6xgxvk(float _swfcra) {
return (near * far) / (_swfcra * (near - far) + far);
}

bool _zqinnw(vec4 _ino0s9) {
return !any(isnan(_ino0s9)) && !any(isinf(_ino0s9)) && _ino0s9.a >= 0.0 && _ino0s9.a <= 1.0001;
}

vec4 _lfvr68(sampler2D fogTex) {
vec2 _460ux4 = vec2(viewWidth, viewHeight);
ivec2 _64317f = ivec2(max(_460ux4 * FOG_RENDER_SCALE, vec2(1.0)));
ivec2 _6ova42 = ivec2(floor(gl_FragCoord.xy * FOG_RENDER_SCALE));
float _w6k1ug = _6xgxvk(texture(depthtex0, texcoord).r);

const ivec2 OFFSETS[5] = ivec2[](
ivec2(0, 0),
ivec2(1, 0),
ivec2(-1, 0),
ivec2(0, 1),
ivec2(0, -1)
);

vec4 _idhca6 = vec4(0.0);
float _apkqux = 0.0;
float _w8dbmu = max(_w6k1ug * 0.05, 0.25);

for (int i = 0; i < 5; i++) {
ivec2 _jmyufn = clamp(_6ova42 + OFFSETS[i], ivec2(0), _64317f - ivec2(1));
vec2 _b5dy23 = (vec2(_jmyufn) + 0.5) / _460ux4;
vec2 _nccj5z = (vec2(_jmyufn) / FOG_RENDER_SCALE + 0.5) / _460ux4;
float _slnatl = _6xgxvk(texture(depthtex0, clamp(_nccj5z, vec2(0.0), vec2(1.0))).r);
vec4 _xnnc9k = texture(fogTex, _b5dy23);
if (!_zqinnw(_xnnc9k)) continue;
float _d8tv7f = abs(_slnatl - _w6k1ug) < _w8dbmu ? 1.0 : 0.0001;
_idhca6 += _xnnc9k * _d8tv7f;
_apkqux += _d8tv7f;
}

return _apkqux > 0.0 ? _idhca6 / _apkqux : vec4(0.0);
}

void main() {
gl_FragData[0] = _lfvr68(colortex10);
}
