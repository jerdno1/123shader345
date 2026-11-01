/* RENDERTARGETS: 0 */

in vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform float viewWidth;
uniform float viewHeight;

void main() {
vec4 _bcg6fd = texture(colortex0, texcoord);
vec3 _yssmf1 = _bcg6fd.rgb;

vec2 _8tunql = 1.0 / vec2(viewWidth, viewHeight);

const float P_UP = 100.0 / 255.0;
const float P_X  = 150.0 / 255.0;
const float P_Z  = 200.0 / 255.0;
const float P_TOL = 2.0 / 255.0;

float _9wzuio = texture(colortex1, texcoord).a;
bool _46kkwt = (abs(_9wzuio - P_UP) < P_TOL) ||
(abs(_9wzuio - P_X)  < P_TOL) ||
(abs(_9wzuio - P_Z)  < P_TOL);

if (_46kkwt) {
gl_FragData[0] = _bcg6fd;
return;
}

vec3 _jjyhed = vec3(0.0);
float _ydli7i = 0.0;

const float GLOW_RADIUS = 40.0;
const int RING_SAMPLES = 12;
const int RINGS = 5;

for (int r = 1; r <= RINGS; r++) {
float _nr5rfo = GLOW_RADIUS * float(r) / float(RINGS);
float _jja8pn = 1.0 - float(r - 1) / float(RINGS);
_jja8pn = _jja8pn * _jja8pn * _jja8pn;

for (int s = 0; s < RING_SAMPLES; s++) {
float _huatah = float(s) * 6.2831853 / float(RING_SAMPLES);
vec2 _ja8cqx = vec2(cos(_huatah), sin(_huatah)) * _nr5rfo;
vec2 _rbbd13 = texcoord + _ja8cqx * _8tunql;

if (_rbbd13.x < 0.0 || _rbbd13.x > 1.0 || _rbbd13.y < 0.0 || _rbbd13.y > 1.0) continue;

float _0owwpf = texture(colortex1, _rbbd13).a;
bool _fanqxn = (abs(_0owwpf - P_UP) < P_TOL) ||
(abs(_0owwpf - P_X)  < P_TOL) ||
(abs(_0owwpf - P_Z)  < P_TOL);

if (_fanqxn) {
vec3 _sazg6z = texture(colortex0, _rbbd13).rgb;
_jjyhed += _sazg6z * _jja8pn;
_ydli7i += _jja8pn;
}
}
}

if (_ydli7i > 0.01) {
_jjyhed /= _ydli7i;
float _0v7t0i = min(_ydli7i * 0.08, 0.6);
_yssmf1 += _jjyhed * _0v7t0i;
}

gl_FragData[0] = vec4(_yssmf1, _bcg6fd.a);
}
