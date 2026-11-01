#ifndef END_EVENT_GLSL
#define END_EVENT_GLSL

struct EndEvent {
float skyDarkness;
float vortexSpeedMult;
float vortexSizeMult;
float effectsFade;
float cloudSpeedMult;
float eyeOpen;
float bangFlash;
float bangProgress;
float terrainDarkness;
float fogDarkness;
float suctionWarp;
float vortexTime;
float cloudTime;
};

float _8m595n(float t) {
return t * t * (3.0 - 2.0 * t);
}

EndEvent getEndEvent(float _bim3ym) {
EndEvent e;
e.skyDarkness = 0.0;
e.vortexSpeedMult = 1.0;
e.vortexSizeMult = 1.0;
e.effectsFade = 1.0;
e.cloudSpeedMult = 1.0;
e.eyeOpen = 0.0;
e.bangFlash = 0.0;
e.bangProgress = -1.0;
e.terrainDarkness = 0.0;
e.fogDarkness = 0.0;
e.suctionWarp = 0.0;
e.vortexTime = _bim3ym;
e.cloudTime = _bim3ym;

float _3v0h8k = END_EVENT_CYCLE;

float _h0917b = 12.0;
float _ksgm5l = 10.0;
#ifdef END_EVENT_BLACKOUT_ENABLED
float _5ystod = END_EVENT_BLACKOUT;
#else
float _5ystod = 0.0;
#endif
float _7a43br = 4.0;
float _lsj7ux = 12.0;
float _go8a5j = 10.0;

float _vzg0q0 = _h0917b + _ksgm5l + _5ystod + _7a43br + _lsj7ux + _go8a5j;
float _19h4bs = _3v0h8k - _vzg0q0;
float t = mod(_bim3ym, _3v0h8k);

if (t < _19h4bs) return e;

float et = t - _19h4bs;

float _0pqt16 = _h0917b;
float _s4nxhq = _0pqt16 + _ksgm5l;
float _fe2b5g = _s4nxhq + _5ystod;
float _d36u71 = _fe2b5g + _7a43br;
float _ccaryg = _d36u71 + _lsj7ux;

float _eh80md = _h0917b + 5.0 * _h0917b / 3.0;

float _vtyqnq = (6.0 + 12.0) * 0.5 * _ksgm5l;

float _vgk9xz = _h0917b + 4.0 * _h0917b / 3.0;
float _dbl3bw = (5.0 + 10.0) * 0.5 * _ksgm5l;

float _thur9a = 0.0;
float _oon8mk = 0.0;

if (et < _0pqt16) {
float p = et / _h0917b;
p = p * p;
e.vortexSpeedMult = mix(1.0, 6.0, p);
e.cloudSpeedMult = mix(1.0, 5.0, p);
e.vortexSizeMult = mix(1.0, 0.5, p);

_thur9a = et + 5.0 * et * et * et / (3.0 * _h0917b * _h0917b);

_oon8mk = et + 4.0 * et * et * et / (3.0 * _h0917b * _h0917b);
}

else if (et < _s4nxhq) {
float p = (et - _0pqt16) / _ksgm5l;
float _1ecnkz = _8m595n(p);
e.vortexSpeedMult = mix(6.0, 12.0, _1ecnkz);
e.cloudSpeedMult = mix(5.0, 10.0, _1ecnkz);
e.vortexSizeMult = mix(0.5, 0.0, _1ecnkz);
e.skyDarkness = _1ecnkz;
e.effectsFade = 1.0 - _1ecnkz;
e.suctionWarp = _1ecnkz;
e.terrainDarkness = _1ecnkz;
e.fogDarkness = _1ecnkz;

float _n8hcyb = et - _0pqt16;
float _qth9hy = mix(6.0, mix(6.0, 12.0, _1ecnkz), 0.5);
_thur9a = _eh80md + _qth9hy * _n8hcyb;

float _834kv7 = mix(5.0, mix(5.0, 10.0, _1ecnkz), 0.5);
_oon8mk = _vgk9xz + _834kv7 * _n8hcyb;
}

else if (et < _fe2b5g) {
e.skyDarkness = 1.0;
e.effectsFade = 0.0;
e.vortexSpeedMult = 0.0;
e.vortexSizeMult = 0.0;
e.cloudSpeedMult = 0.0;
e.suctionWarp = 1.0;
e.terrainDarkness = 1.0;
e.fogDarkness = 1.0;

float _kx7po9 = et - _s4nxhq;
float _cb9sst = _kx7po9 / _5ystod;
float _7jvvv9 = _8m595n(_cb9sst);

float _rhw6hg = _eh80md + _vtyqnq;
float _2386zv = (_h0917b + _ksgm5l) + _kx7po9;
_thur9a = mix(_rhw6hg, _2386zv, _7jvvv9);

float _0cd539 = _vgk9xz + _dbl3bw;
_oon8mk = mix(_0cd539, _2386zv, _7jvvv9);
}

else if (et < _d36u71) {
float p = (et - _fe2b5g) / _7a43br;
float _3tnt74 = pow(p, 0.4);
float _81e2ty = p * p;
e.bangProgress = p;
e.bangFlash = max(1.0 - p * 4.0, 0.0);
e.bangFlash *= e.bangFlash;
e.skyDarkness = 1.0 - _3tnt74;
e.effectsFade = _3tnt74;
e.vortexSpeedMult = 1.0;
e.vortexSizeMult = _81e2ty;
e.cloudSpeedMult = mix(0.0, 1.0, _3tnt74);
e.suctionWarp = 1.0 - _3tnt74;
e.terrainDarkness = 1.0 - _3tnt74;
e.fogDarkness = 1.0 - _3tnt74;

_thur9a = et;
_oon8mk = et;
}

else if (et < _ccaryg) {
float p = (et - _d36u71) / _lsj7ux;

#ifdef END_EVENT_EYE_ENABLED
if (p < 0.20) {
e.eyeOpen = _8m595n(p / 0.20);
} else if (p < 0.51) {
e.eyeOpen = 1.0;
} else if (p < 0.535) {
float _up8op2 = (p - 0.51) / 0.025;
e.eyeOpen = 1.0 - _8m595n(_up8op2);
} else if (p < 0.555) {
float _up8op2 = (p - 0.535) / 0.02;
e.eyeOpen = _8m595n(_up8op2);
} else if (p < 0.80) {
e.eyeOpen = 1.0;
} else {
float _cnappo = (p - 0.80) / 0.20;
e.eyeOpen = 1.0 - _8m595n(_cnappo);
}
#endif

_thur9a = et;
_oon8mk = et;
}

else {

_thur9a = et;
_oon8mk = et;
}

e.vortexTime = (_bim3ym - t) + _19h4bs + _thur9a;
e.cloudTime = (_bim3ym - t) + _19h4bs + _oon8mk;

#ifndef END_EVENT_BLACKOUT_ENABLED

e.skyDarkness = 0.0;
e.effectsFade = 1.0;
e.terrainDarkness = 0.0;
e.fogDarkness = 0.0;
e.cloudTime = _bim3ym;
#endif

return e;
}

float _u746aw(float _bim3ym) {
#ifndef END_EVENT_BLACKOUT_ENABLED
return 0.0;
#else
float _3v0h8k = END_EVENT_CYCLE;
float _0pqt16 = 12.0;
float _s4nxhq = _0pqt16 + 10.0;
float _fe2b5g = _s4nxhq + END_EVENT_BLACKOUT;
float _d36u71 = _fe2b5g + 4.0;
float _vzg0q0 = _d36u71 + 12.0 + 10.0;
float _19h4bs = _3v0h8k - _vzg0q0;
float t = mod(_bim3ym, _3v0h8k);

if (t < _19h4bs) return 0.0;
float et = t - _19h4bs;

if (et >= _0pqt16 && et < _s4nxhq) {
float p = (et - _0pqt16) / 10.0;
return _8m595n(p);
}

if (et >= _s4nxhq && et < _fe2b5g) return 1.0;

if (et >= _fe2b5g && et < _d36u71) {
float p = (et - _fe2b5g) / 4.0;
return 1.0 - pow(p, 0.4);
}
return 0.0;
#endif
}

#endif
