#ifdef METALNESS_ENABLED

vec3 _mzowin(vec3 _exbfzp, float sunAngle) {
TimeWeightsSimple ts = getTimeWeightsSimple(sunAngle);

float _vic1om = _exbfzp.y * 0.5 + 0.5;
vec3 _n6yb0b = mix(vec3(0.6, 0.7, 0.8), vec3(0.4, 0.6, 1.0), _vic1om);
vec3 _r8ov9p = mix(vec3(0.4, 0.3, 0.3), vec3(1.0, 0.6, 0.4), _vic1om);
vec3 _kfo8lp = mix(vec3(0.02, 0.02, 0.04), vec3(0.1, 0.15, 0.25), _vic1om);

return _n6yb0b * ts.day + _r8ov9p * ts.twilight + _kfo8lp * ts.night;
}

float _qn8xck(float _75gmpr, float F0) {
float ct = max(_75gmpr, 0.05);
return F0 + (1.0 - F0) * pow(1.0 - ct, 5.0);
}

float _8hor3m(float _x102pb, float roughness) {
float a = roughness * roughness;
float a2 = a * a;
float _ogwka4 = _x102pb * _x102pb * (a2 - 1.0) + 1.0;
return a2 / (3.14159265 * _ogwka4 * _ogwka4);
}

vec3 _c4o6e5(vec3 _exbfzp) {
float _vic1om = _exbfzp.y * 0.5 + 0.5;
vec3 _t91ml5 = vec3(0.05, 0.02, 0.10);
vec3 _j41frw = vec3(0.25, 0.10, 0.45);
return mix(_t91ml5, _j41frw, _vic1om);
}

float _rd4a4a(vec3 _dwo81a) {
float _zdxp7g = dot(_dwo81a, vec3(0.299, 0.587, 0.114));
return mix(0.35, 1.20, smoothstep(0.20, 0.78, _zdxp7g));
}

vec3 _pkp5jj(vec3 _dwo81a, vec3 _qiryo8, float _8x2khv, float _0v7t0i) {
float _48xuzq = dot(_qiryo8, vec3(0.299, 0.587, 0.114));
if (_48xuzq <= 0.0005) return vec3(0.0);

vec3 _j4ni3g = clamp(_qiryo8 / max(_48xuzq, 0.0001), vec3(0.0), vec3(4.0));
float _7nhat8 = _48xuzq * _8x2khv * _0v7t0i;
return _dwo81a * _j4ni3g * _7nhat8;
}

vec3 _pqvb9e(vec3 _x2q5fe, vec3 viewDir, vec3 _s0ptut, vec3 _xyc8gw, float _38mvsj, vec3 _7aqewt, float _bim3ym, vec3 _dwo81a, float _3txq63, float blocklight, vec3 _qiryo8) {
bool _gziqej = (_38mvsj > 0.5 && _38mvsj < 1.5);
bool _0op4qx = (_38mvsj > 1.5);

float _l42euj = _rd4a4a(_dwo81a);

vec3 N = normalize(_s0ptut);
vec3 L = normalize(_xyc8gw);
vec3 V = normalize(-viewDir);
vec3 H = normalize(V + L);
vec3 R = reflect(-V, N);

float _i9o95p = max(dot(N, V), 0.001);
float _x102pb = max(dot(N, H), 0.0);
float NdotL = max(dot(N, L), 0.0);

float _4q13rs = _gziqej ? 16.0 : 32.0;
float _uaj4g9 = pow(_x102pb, _4q13rs);
vec3 specular = _dwo81a * _uaj4g9 * _l42euj * METALNESS_INTENSITY * 5.0;

vec3 _zkxffk = _pkp5jj(_dwo81a, _qiryo8, _l42euj, METALNESS_INTENSITY) * 0.6;

return _x2q5fe + specular + _zkxffk;
}

vec3 _2q5cue(vec3 _x2q5fe, vec3 viewDir, vec3 _s0ptut, vec3 _xyc8gw, float sunAngle, float _38mvsj, vec3 _7aqewt, vec3 _dwo81a, float _3txq63, float blocklight, vec3 _qiryo8) {
bool _gziqej = (_38mvsj > 0.5 && _38mvsj < 1.5);
bool _0op4qx = (_38mvsj > 1.5);

float _l42euj = _rd4a4a(_dwo81a);

vec3 N = normalize(_s0ptut);
vec3 L = normalize(_xyc8gw);
vec3 V = normalize(-viewDir);
vec3 H = normalize(V + L);
vec3 R = reflect(-V, N);

float _i9o95p = max(dot(N, V), 0.001);
float _x102pb = max(dot(N, H), 0.0);
float NdotL = max(dot(N, L), 0.0);

TimeWeightsSimple metalTS = getTimeWeightsSimple(sunAngle);
float _vog09b = metalTS.day + metalTS.twilight * 0.5;
float _0hqqca = mix(0.08, 1.0, _vog09b);

float _4q13rs = _gziqej ? 16.0 : 8.0;
float _n26mvg = pow(_x102pb, _4q13rs);
float _ulc1wy = _gziqej ? 4.0 : 1.5;
vec3 specular = _dwo81a * _n26mvg * _l42euj * METALNESS_INTENSITY * _ulc1wy * _3txq63 * _0hqqca;

vec3 _og8468 = vec3(0.0);

vec3 _zkxffk = _pkp5jj(_dwo81a, _qiryo8, _l42euj, METALNESS_INTENSITY) * 0.75;

return _x2q5fe + specular + _zkxffk;
}
#endif
