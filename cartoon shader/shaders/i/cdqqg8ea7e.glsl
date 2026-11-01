float _hxej7j(ivec2 _xibcy1) {
float _23zpod = texelFetch(depthtex0, _xibcy1, 0).x;
float _cskgny = texelFetch(dhDepthTex, _xibcy1, 0).x;
bool _kny80e = _yfr6tv(_cskgny);

if (_23zpod >= 0.9999 && _kny80e) {
return _cskgny;
}
return _23zpod;
}

float _oz1zr8(ivec2 _xibcy1) {
float _23zpod = texelFetch(depthtex0, _xibcy1, 0).x;
float _cskgny = texelFetch(dhDepthTex, _xibcy1, 0).x;
bool _kny80e = _yfr6tv(_cskgny);

if (_23zpod >= 0.9999 && _kny80e) {
return _wf8ve2(_cskgny);
}
return _zdldl1(_23zpod);
}

float _xvf2zs(in ivec2 _c97jk9) {
int _8tunql = OUTLINE_PIXEL_SIZE;

ivec2 _v72aun = _c97jk9 - _8tunql;
ivec2 _sa9f46 = _c97jk9 + _8tunql;

float _23zpod = texelFetch(depthtex0, _c97jk9, 0).x;
float _cskgny = texelFetch(dhDepthTex, _c97jk9, 0).x;

float _5bnrow = texelFetch(depthtex0, _v72aun, 0).x;
float _nnwbpg = texelFetch(depthtex0, _sa9f46, 0).x;
float _sjlshw = texelFetch(depthtex0, ivec2(_v72aun.x, _sa9f46.y), 0).x;
float _0l1nb1 = texelFetch(depthtex0, ivec2(_sa9f46.x, _v72aun.y), 0).x;

float _mg86ln = texelFetch(dhDepthTex, _v72aun, 0).x;
float _bky9hy = texelFetch(dhDepthTex, _sa9f46, 0).x;
float _dkdc4w = texelFetch(dhDepthTex, ivec2(_v72aun.x, _sa9f46.y), 0).x;
float _itwj0e = texelFetch(dhDepthTex, ivec2(_sa9f46.x, _v72aun.y), 0).x;

float _307ci8 = (_23zpod >= 0.9999 && _yfr6tv(_cskgny)) ? _cskgny : _23zpod;
float _qtmy89 = (_5bnrow >= 0.9999 && _yfr6tv(_mg86ln)) ? _mg86ln : _5bnrow;
float _f1wak4 = (_nnwbpg >= 0.9999 && _yfr6tv(_bky9hy)) ? _bky9hy : _nnwbpg;
float _jn5crc = (_sjlshw >= 0.9999 && _yfr6tv(_dkdc4w)) ? _dkdc4w : _sjlshw;
float _of9ilj = (_0l1nb1 >= 0.9999 && _yfr6tv(_itwj0e)) ? _itwj0e : _0l1nb1;

float zC = (_23zpod >= 0.9999 && _yfr6tv(_cskgny))
? _wf8ve2(_cskgny)
: _zdldl1(_23zpod);

bool _q409sk = _23zpod < 0.9999;
bool _pouuem = _23zpod >= 0.9999 && _yfr6tv(_cskgny);

bool _o7gxue = _5bnrow < 0.9999;
bool _qq69be = _nnwbpg < 0.9999;
bool _k58z9s = _sjlshw < 0.9999;
bool _r0s4jy = _0l1nb1 < 0.9999;

bool _5bijx5 = _5bnrow >= 0.9999 && _yfr6tv(_mg86ln);
bool _041in7 = _nnwbpg >= 0.9999 && _yfr6tv(_bky9hy);
bool _1w7ux0 = _sjlshw >= 0.9999 && _yfr6tv(_dkdc4w);
bool _dzo5a3 = _0l1nb1 >= 0.9999 && _yfr6tv(_itwj0e);

if (_q409sk) {

if (_5bijx5 || _041in7 || _1w7ux0 || _dzo5a3) {
return 0.0;
}
}

if (_pouuem) {

if (_o7gxue || _qq69be || _k58z9s || _r0s4jy) {
return 0.0;
}

float _mi8q8o = _wf8ve2(_cskgny);
float _yebrll = _mi8q8o;
float _wrl9wx = _mi8q8o;

if (_5bijx5) { float z = _wf8ve2(_mg86ln); _yebrll = max(_yebrll, z); _wrl9wx = min(_wrl9wx, z); }
if (_041in7) { float z = _wf8ve2(_bky9hy); _yebrll = max(_yebrll, z); _wrl9wx = min(_wrl9wx, z); }
if (_1w7ux0) { float z = _wf8ve2(_dkdc4w); _yebrll = max(_yebrll, z); _wrl9wx = min(_wrl9wx, z); }
if (_dzo5a3) { float z = _wf8ve2(_itwj0e); _yebrll = max(_yebrll, z); _wrl9wx = min(_wrl9wx, z); }

if (_yebrll - _wrl9wx > 100.0) {
return 0.0;
}
}

#if OUTLINES == 1
float _2zs1mf = near / (1.0 - _qtmy89);
float _b8i8m4 = near / (1.0 - _f1wak4);
float _cr41tl = near / (1.0 - _jn5crc);
float _c9u8bu = near / (1.0 - _of9ilj);

float _k80gf0 = _2zs1mf + _b8i8m4 + _cr41tl + _c9u8bu;
return _qn45m7(_k80gf0 - (near * 4.0) / (1.0 - _307ci8));
#else
float z0 = (_5bijx5) ? _wf8ve2(_mg86ln) : _zdldl1(_5bnrow);
float z1 = (_041in7) ? _wf8ve2(_bky9hy) : _zdldl1(_nnwbpg);
float z2 = (_1w7ux0) ? _wf8ve2(_dkdc4w) : _zdldl1(_sjlshw);
float z3 = (_dzo5a3) ? _wf8ve2(_itwj0e) : _zdldl1(_0l1nb1);

float _qveis6 = z0 - zC;
float _0smt6y = z1 - zC;
float _po4j92 = z2 - zC;
float _rah3mm = z3 - zC;

float _tyr8gq = max(max(max(_qveis6, _0smt6y), _po4j92), _rah3mm);

float _hjv25d = abs(_qveis6 - _0smt6y);
float _k5leti = abs(_po4j92 - _rah3mm);
float _ctc51d = max(_hjv25d, _k5leti);

float _22pn7r = _tyr8gq / max(zC, 1.0);
float _cc27o9 = _ctc51d / max(zC, 1.0);

return smoothstep(0.10, 0.22, _22pn7r) * smoothstep(0.05, 0.12, _cc27o9);
#endif
}

float _2mskwk(vec3 c, bool _htcc8u) {
if (!_htcc8u) return 1.0;
vec3 _59bql9 = clamp(c, vec3(0.0), vec3(1.0));
vec3 _s0lzby = _j0nlr9(_59bql9);
float _m5kcpz = _59bql9.g - max(_59bql9.r, _59bql9.b);
float _2rmthv = _59bql9.g / max(0.0001, (_59bql9.r + _59bql9.b) * 0.5);
float _7el0bg = abs(_s0lzby.x - 0.3333333);
_7el0bg = min(_7el0bg, 1.0 - _7el0bg);
float _9a14cj = 1.0 - smoothstep(0.10, 0.18, _7el0bg);
float _9xrlf0 = smoothstep(0.28, 0.60, _s0lzby.y);
float _1cxgii = smoothstep(0.08, 0.35, _s0lzby.z);
float _1d6yae = smoothstep(0.06, 0.18, _m5kcpz);
float _4ilpvq = smoothstep(1.15, 1.75, _2rmthv);
float _rimlzj = _9a14cj * _9xrlf0 * _1cxgii * _1d6yae * _4ilpvq;
return 1.0 - clamp(_rimlzj, 0.0, 1.0);
}
