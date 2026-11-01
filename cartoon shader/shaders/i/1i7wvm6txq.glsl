#ifndef PBR_GLSL_INCLUDED
#define PBR_GLSL_INCLUDED

#ifndef PBR_FORMAT
#define PBR_FORMAT 0
#endif

#if PBR_FORMAT == 1
#define PBR_USE_LABPBR
#elif PBR_FORMAT == 2
#define PBR_USE_OLDPBR
#else

#ifdef MC_TEXTURE_FORMAT_OLD_PBR
#define PBR_USE_OLDPBR
#else
#define PBR_USE_LABPBR
#endif
#endif

#ifndef PBR_GGX_DEFINED
#define PBR_GGX_DEFINED
float _xojg5j(float _x102pb, float roughness) {
float a  = roughness * roughness;
float a2 = a * a;
float d  = _x102pb * _x102pb * (a2 - 1.0) + 1.0;
return a2 / (3.14159265 * d * d);
}

float _wr0z0x(float _75gmpr, float F0) {
float ct = max(_75gmpr, 0.0);
float m  = 1.0 - ct;
float m2 = m * m;
return F0 + (1.0 - F0) * m2 * m2 * m;
}

vec3 _6hjzil(float _75gmpr, vec3 F0) {
float ct = max(_75gmpr, 0.0);
float m  = 1.0 - ct;
float m2 = m * m;
return F0 + (vec3(1.0) - F0) * m2 * m2 * m;
}

float _knzn94(float _i9o95p, float NdotL, float roughness) {
float r = roughness + 1.0;
float k = (r * r) * 0.125;
float gv = _i9o95p / (_i9o95p * (1.0 - k) + k);
float gl = NdotL / (NdotL * (1.0 - k) + k);
return gv * gl;
}
#endif

vec3 _avq5zb(int metalId) {
if (metalId == 230) return vec3(0.560, 0.570, 0.580);
if (metalId == 231) return vec3(1.000, 0.710, 0.290);
if (metalId == 232) return vec3(0.913, 0.922, 0.924);
if (metalId == 233) return vec3(0.550, 0.556, 0.554);
if (metalId == 234) return vec3(0.955, 0.638, 0.538);
if (metalId == 235) return vec3(0.632, 0.626, 0.641);
if (metalId == 236) return vec3(0.673, 0.637, 0.585);
if (metalId == 237) return vec3(0.972, 0.960, 0.915);
return vec3(0.560, 0.570, 0.580);
}

struct PBRMaterial {

vec3  nTangent;
float height;
float ao;

float roughness;
float F0scalar;
vec3  F0;
float metalness;
int   metalId;

float porosity;
float sss;
bool  hasSSS;

float emission;

bool  hasData;
bool  hasNormal;
bool  hasSpec;
};

bool _q1yhes(vec4 _1nqem6, vec4 _y9hkuf) {
bool _6rhvb8 = abs(_1nqem6.r - 0.5) < 0.02
&& abs(_1nqem6.g - 0.5) < 0.02
&& _1nqem6.b > 0.95;
bool _7cc6pl  = (_y9hkuf.r + _y9hkuf.g + _y9hkuf.b + _y9hkuf.a) < 0.01;
return !(_6rhvb8 && _7cc6pl);
}

float _k86yw1(vec4 _y9hkuf) {
#ifdef PBR_USE_LABPBR
float _k3g13r = _y9hkuf.a * 255.0;
return (_k3g13r > 254.5) ? 0.0 : _y9hkuf.a;
#else
return _y9hkuf.b;
#endif
}

PBRMaterial pbr_decode(vec4 _1nqem6, vec4 _y9hkuf, vec3 _frd21n, float _nlho7w) {
PBRMaterial m;

bool _6rhvb8 = abs(_1nqem6.r - 0.5) < 0.02
&& abs(_1nqem6.g - 0.5) < 0.02
&& _1nqem6.b > 0.95;
bool _7cc6pl  = (_y9hkuf.r + _y9hkuf.g + _y9hkuf.b + _y9hkuf.a) < 0.01;
m.hasNormal = !_6rhvb8;
m.hasSpec   = !_7cc6pl;
m.hasData   = m.hasNormal || m.hasSpec;

vec2 _sf1kaz = _1nqem6.rg * 2.0 - 1.0;
_sf1kaz *= _nlho7w;
float nz = sqrt(max(1.0 - dot(_sf1kaz, _sf1kaz), 0.0));
m.nTangent = normalize(vec3(_sf1kaz, max(nz, 1e-4)));

#ifdef PBR_USE_LABPBR
m.ao     = _1nqem6.b;
m.height = _1nqem6.a;
#else
m.ao     = 1.0;
m.height = 1.0;
#endif

#ifdef PBR_USE_LABPBR

float _7fj743 = _y9hkuf.r;
m.roughness = pow(1.0 - _7fj743, 2.0);

float _j7rown = _y9hkuf.g * 255.0;
if (_j7rown > 229.5) {
int id = int(floor(_j7rown + 0.5));
m.metalId   = id;
m.metalness = 1.0;
if (id == 255) {

m.F0       = max(_frd21n, vec3(0.04));
m.F0scalar = dot(m.F0, vec3(0.333));
} else {
m.F0       = _avq5zb(id);
m.F0scalar = dot(m.F0, vec3(0.333));
}
} else {
m.metalId   = 0;
m.metalness = 0.0;

m.F0scalar = clamp(_y9hkuf.g * (255.0 / 229.0), 0.0, 1.0);
m.F0scalar = max(m.F0scalar, 0.02);
m.F0       = vec3(m.F0scalar);
}

float _ov6nyq = _y9hkuf.b * 255.0;
if (_ov6nyq < 64.5) {
m.porosity = _ov6nyq / 64.0;
m.sss      = 0.0;
m.hasSSS   = false;
} else {
m.porosity = 0.0;
m.sss      = (_ov6nyq - 65.0) / 190.0;
m.hasSSS   = (m.sss > 0.001);
}

m.emission = _k86yw1(_y9hkuf);
#else

m.roughness = pow(1.0 - _y9hkuf.r, 2.0);

m.metalness = _y9hkuf.g;
bool _gziqej = (m.metalness > 0.5);
m.metalId = 0;
if (_gziqej) {

m.F0       = max(_frd21n, vec3(0.04));
m.F0scalar = dot(m.F0, vec3(0.333));
} else {
m.F0scalar = 0.04;
m.F0       = vec3(0.04);
}

m.emission = _k86yw1(_y9hkuf);

m.porosity = 0.0;
m.sss      = 0.0;
m.hasSSS   = false;
#endif

if (!m.hasSpec) {
m.roughness = 1.0;
m.F0scalar  = 0.04;
m.F0        = vec3(0.04);
m.metalness = 0.0;
m.metalId   = 0;
m.emission  = 0.0;
m.porosity  = 0.0;
m.sss       = 0.0;
m.hasSSS    = false;
}

return m;
}

PBRMaterial pbr_fallback(vec3 _i0ua3f, float _4pc45l) {
PBRMaterial m;
m.nTangent  = vec3(0.0, 0.0, 1.0);
m.height    = 1.0;
m.ao        = 1.0;
m.roughness = _4pc45l;
m.F0scalar  = 0.04;
m.F0        = vec3(0.04);
m.metalness = 0.0;
m.metalId   = 0;
m.porosity  = 0.0;
m.sss       = 0.0;
m.hasSSS    = false;
m.emission  = 0.0;
m.hasData   = false;
m.hasNormal = false;
m.hasSpec   = false;
return m;
}

vec3 _3af26h(vec3 nTangent, vec3 _fbnohv, vec3 _fn434s, vec3 _541prc) {
mat3 TBN = mat3(normalize(_fbnohv), normalize(_fn434s), normalize(_541prc));
return normalize(TBN * nTangent);
}

float _qk34ll(PBRMaterial material) {
return material.hasSpec ? clamp(material.emission, 0.0, 1.0) : 0.0;
}

vec3 _7qz11m(vec3 _frd21n, float emission, float _xgal31) {
return max(_frd21n, vec3(0.0)) * max(_xgal31, 0.0) * clamp(emission, 0.0, 1.0);
}

vec3 _kg9mcg(vec3 _hj0fjq, vec3 _frd21n, float emission, float _xgal31) {
float _kc9t4n = clamp(emission, 0.0, 1.0);
vec3 _lg7qxv = max(_frd21n, vec3(0.0)) * max(_xgal31, 0.0);
return mix(_hj0fjq, max(_hj0fjq, _lg7qxv), _kc9t4n);
}

vec4 _c52ppx(PBRMaterial m, vec3 _tkgg08) {
float x = clamp(m.roughness, 0.0, 1.0);
float y = clamp(m.metalness, 0.0, 0.85);
return vec4(x, y, _tkgg08.x * 0.5 + 0.5, _tkgg08.y * 0.5 + 0.5);
}

void _mo1vol(vec4 _r4digw, out float roughness, out float metalness) {
roughness = clamp(_r4digw.x, 0.0, 1.0);
metalness = clamp(_r4digw.y / 0.85, 0.0, 1.0);
}

#endif
