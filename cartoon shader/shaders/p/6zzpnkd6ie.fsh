#include "/settings.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex5;
uniform sampler2D colortex9;
uniform sampler2D colortex10;
uniform sampler2D colortex11;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;

in vec2 texcoord;

/* RENDERTARGETS: 0 */

bool _rv9f3n(ivec2 _xibcy1) {
vec4 _alcc4c = texelFetch(colortex1, _xibcy1, 0);
float _swfcra = texelFetch(depthtex0, _xibcy1, 0).r;
return (_alcc4c.a > 0.999 && _swfcra >= 0.9999);
}

bool _uszyh6(ivec2 _xibcy1) {
return texelFetch(colortex5, _xibcy1, 0).y > 0.9;
}

bool _hd2r8r(ivec2 _xibcy1) {
vec4 _mofikk = texelFetch(colortex5, _xibcy1, 0);
return abs(_mofikk.y - 0.25) < 0.01
&& _mofikk.z < 0.001
&& _mofikk.w < 0.001;
}

bool _gxamiy(ivec2 _xibcy1) {
float _c71tyg = 0.0;
#if defined(ATMO_FOG_ENABLED) || defined(UNDERWATER_FOG_ENABLED) || defined(CAVE_FOG_ENABLED)
_c71tyg = max(_c71tyg, texelFetch(colortex9, _xibcy1, 0).a);
#endif
#if defined(HAZE_FOG_ACTIVE) || defined(NETHER_FOG_ENABLED)
_c71tyg = max(_c71tyg, texelFetch(colortex10, _xibcy1, 0).a);
#endif
#ifdef WEATHER_FOG_ENABLED
_c71tyg = max(_c71tyg, texelFetch(colortex11, _xibcy1, 0).a);
#endif
return _c71tyg > 0.001;
}

#if defined(FXAA_ENABLED) || defined(LEAF_AA_ENABLED)

const float quality[12] = float[12](1.0, 1.0, 1.0, 1.0, 1.0, 1.5, 2.0, 2.0, 2.0, 2.0, 4.0, 8.0);

float _33cclh(vec3 c) {
return dot(c, vec3(0.299, 0.587, 0.114));
}

void main() {
ivec2 _lgrsgs = ivec2(gl_FragCoord.xy);
vec4 _yowcia = texelFetch(colortex0, _lgrsgs, 0);
vec3 _yssmf1 = _yowcia.rgb;

bool voxyAaPixel = false;
#ifdef FXAA_ENABLED
voxyAaPixel = _rv9f3n(_lgrsgs)
&& !_uszyh6(_lgrsgs)
&& !_gxamiy(_lgrsgs);
#endif

bool _dj4h3d = false;
#ifdef LEAF_AA_ENABLED

_dj4h3d = _hd2r8r(_lgrsgs)
&& !_uszyh6(_lgrsgs);
#endif

if (!voxyAaPixel && !_dj4h3d) {
#ifdef FXAA_DEBUG

float g = dot(_yssmf1, vec3(0.299, 0.587, 0.114));
gl_FragData[0] = vec4(vec3(g) * 0.5, _yowcia.a);
#else
gl_FragData[0] = _yowcia;
#endif
return;
}

float _ptasot = 0.0312 / FXAA_QUALITY;
float _8lg3b8 = 0.125  / FXAA_QUALITY;
float _k7owoj  = 0.75;
float _aotd73  = 1.0;
int   _9q6nxy       = 12;

#ifdef LEAF_AA_ENABLED
if (_dj4h3d) {
float _fkxkuv = clamp(LEAF_AA_STRENGTH, 0.0, 1.0);
_ptasot = mix(0.0312, 0.0100, _fkxkuv);
_8lg3b8 = mix(0.1250, 0.0500, _fkxkuv);
_k7owoj = mix(0.75, 1.00, _fkxkuv);
_aotd73 = _fkxkuv;
}
#endif

vec2 _jsao2g = 1.0 / vec2(viewWidth, viewHeight);

float _u8zzqf = _33cclh(_yssmf1);
float _47xh1m   = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2( 0, -1), 0).rgb);
float _g9rh6c     = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2( 0,  1), 0).rgb);
float _ztat16   = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2(-1,  0), 0).rgb);
float _agrtdj  = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2( 1,  0), 0).rgb);

float _m3ekjy = min(_u8zzqf, min(min(_47xh1m, _g9rh6c), min(_ztat16, _agrtdj)));
float _su4kni = max(_u8zzqf, max(max(_47xh1m, _g9rh6c), max(_ztat16, _agrtdj)));
float _iyejf8 = _su4kni - _m3ekjy;

if (_iyejf8 < max(_ptasot, _su4kni * _8lg3b8)) {
#ifdef FXAA_DEBUG

float _5pcsb1 = _u8zzqf;
gl_FragData[0] = vec4(vec3(_5pcsb1) * 0.5, _yowcia.a);
#else
gl_FragData[0] = _yowcia;
#endif
return;
}

float _eoi1au  = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2(-1, -1), 0).rgb);
float _whyja9   = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2( 1,  1), 0).rgb);
float _l2gv1h    = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2(-1,  1), 0).rgb);
float _q6a63f = _33cclh(texelFetch(colortex0, _lgrsgs + ivec2( 1, -1), 0).rgb);

float _aaz6ry    = _47xh1m + _g9rh6c;
float _6ezmy8 = _ztat16 + _agrtdj;

float _tmb7ls  = _eoi1au  + _l2gv1h;
float _ahhzz3  = _eoi1au  + _q6a63f;
float _zicbc4 = _q6a63f + _whyja9;
float _ke397y    = _whyja9   + _l2gv1h;

float _6kyvtu = abs(-2.0 * _ztat16   + _tmb7ls ) +
abs(-2.0 * _u8zzqf + _aaz6ry      ) * 2.0 +
abs(-2.0 * _agrtdj  + _zicbc4);
float _rvn4kc   = abs(-2.0 * _g9rh6c     + _ke397y   ) +
abs(-2.0 * _u8zzqf + _6ezmy8   ) * 2.0 +
abs(-2.0 * _47xh1m   + _ahhzz3 );

bool _zfyjda = (_6kyvtu >= _rvn4kc);

float _s5rs8h = _zfyjda ? _47xh1m : _ztat16;
float _5ny2t8 = _zfyjda ? _g9rh6c : _agrtdj;
float _iljyk3 = _s5rs8h - _u8zzqf;
float _byh0vm = _5ny2t8 - _u8zzqf;

bool _57hbfm = abs(_iljyk3) >= abs(_byh0vm);
float _g30tqv = 0.25 * max(abs(_iljyk3), abs(_byh0vm));

float _e82lne = _zfyjda ? _jsao2g.y : _jsao2g.x;
float _ketwql = 0.0;

if (_57hbfm) {
_e82lne = -_e82lne;
_ketwql = 0.5 * (_s5rs8h + _u8zzqf);
} else {
_ketwql = 0.5 * (_5ny2t8 + _u8zzqf);
}

vec2 _0tn9a6 = texcoord;
if (_zfyjda) _0tn9a6.y += _e82lne * 0.5;
else              _0tn9a6.x += _e82lne * 0.5;

vec2 _ja8cqx = _zfyjda ? vec2(_jsao2g.x, 0.0) : vec2(0.0, _jsao2g.y);

vec2 _8e9vz4 = _0tn9a6 - _ja8cqx;
vec2 _tq4dba = _0tn9a6 + _ja8cqx;
float _m8zzo2 = _33cclh(texture2D(colortex0, _8e9vz4).rgb) - _ketwql;
float _yx1ak7 = _33cclh(texture2D(colortex0, _tq4dba).rgb) - _ketwql;

bool _5pvfmu = abs(_m8zzo2) >= _g30tqv;
bool _rlqpbs = abs(_yx1ak7) >= _g30tqv;
bool _tkj7jm = _5pvfmu && _rlqpbs;

if (!_5pvfmu) _8e9vz4 -= _ja8cqx;
if (!_rlqpbs) _tq4dba += _ja8cqx;

if (!_tkj7jm) {
for (int i = 2; i < _9q6nxy; i++) {
if (!_5pvfmu) {
_m8zzo2 = _33cclh(texture2D(colortex0, _8e9vz4).rgb) - _ketwql;
}
if (!_rlqpbs) {
_yx1ak7 = _33cclh(texture2D(colortex0, _tq4dba).rgb) - _ketwql;
}
_5pvfmu = abs(_m8zzo2) >= _g30tqv;
_rlqpbs = abs(_yx1ak7) >= _g30tqv;
_tkj7jm = _5pvfmu && _rlqpbs;
if (!_5pvfmu) _8e9vz4 -= _ja8cqx * quality[i];
if (!_rlqpbs) _tq4dba += _ja8cqx * quality[i];
if (_tkj7jm) break;
}
}

float _ofntqh = _zfyjda ? (texcoord.x - _8e9vz4.x) : (texcoord.y - _8e9vz4.y);
float _2nzx8r = _zfyjda ? (_tq4dba.x - texcoord.x) : (_tq4dba.y - texcoord.y);

bool _0bsguf = _ofntqh < _2nzx8r;
float _6rz4n5 = min(_ofntqh, _2nzx8r);
float _nyehi8 = (_ofntqh + _2nzx8r);
float _4rtq46 = -_6rz4n5 / _nyehi8 + 0.5;

bool _l9sa0h = _u8zzqf < _ketwql;
bool _p4zx5b = ((_0bsguf ? _m8zzo2 : _yx1ak7) < 0.0) != _l9sa0h;
float _mdwcfz = _p4zx5b ? _4rtq46 : 0.0;

float _2mqzj5 = (1.0 / 12.0) * (2.0 * (_aaz6ry + _6ezmy8) + _tmb7ls + _zicbc4);
float _6i8exg = clamp(abs(_2mqzj5 - _u8zzqf) / _iyejf8, 0.0, 1.0);
float _zjkgtm = (-2.0 * _6i8exg + 3.0) * _6i8exg * _6i8exg;
float _a5n8gh = _zjkgtm * _zjkgtm * _k7owoj;

_mdwcfz = max(_mdwcfz, _a5n8gh);

vec2 _550nb0 = texcoord;
if (_zfyjda) _550nb0.y += _mdwcfz * _e82lne;
else              _550nb0.x += _mdwcfz * _e82lne;

vec3 _bd7n58 = texture2D(colortex0, _550nb0).rgb;

#ifdef FXAA_DEBUG

float _6aya72 = clamp(_mdwcfz * 2.0, 0.0, 1.0);
vec3 _6a1sp8 = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), _6aya72);
gl_FragData[0] = vec4(_6a1sp8, _yowcia.a);
#else
gl_FragData[0] = vec4(mix(_yssmf1, _bd7n58, _aotd73), _yowcia.a);
#endif
}

#else

void main() {
gl_FragData[0] = texture(colortex0, texcoord);
}

#endif
