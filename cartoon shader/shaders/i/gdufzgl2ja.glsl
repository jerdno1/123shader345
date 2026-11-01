#ifndef INCLUDE_BIOME_OVERRIDES_GLSL
#define INCLUDE_BIOME_OVERRIDES_GLSL

uniform float biome_pale_garden;

uniform bool hasCeiling;
uniform bool hasSkylight;

bool _1a4dso(int b) {
bool m = false;
#ifdef BIOME_DESERT
m = m || (b == BIOME_DESERT);
#endif
#ifdef BIOME_BADLANDS
m = m || (b == BIOME_BADLANDS);
#endif
#ifdef BIOME_ERODED_BADLANDS
m = m || (b == BIOME_ERODED_BADLANDS);
#endif
#ifdef BIOME_WOODED_BADLANDS
m = m || (b == BIOME_WOODED_BADLANDS);
#endif
return m;
}

bool _qn96wa(int b) {
return b == BIOME_SWAMP || b == BIOME_MANGROVE_SWAMP || b == 7;
}

bool _d35992(int b) {
bool m = b == BIOME_JUNGLE || b == BIOME_BAMBOO_JUNGLE || b == BIOME_SPARSE_JUNGLE;
return m && !_qn96wa(b);
}

bool _vkgr1p(int b) {
bool m = false;
#ifdef BIOME_PALE_GARDEN
m = m || (b == BIOME_PALE_GARDEN);
#endif
return m;
}

bool _lgo6lt(int b) {
bool m = false;
#ifdef BIOME_SAVANNA
m = m || (b == BIOME_SAVANNA);
#endif
#ifdef BIOME_SAVANNA_PLATEAU
m = m || (b == BIOME_SAVANNA_PLATEAU);
#endif
#ifdef BIOME_WINDSWEPT_SAVANNA
m = m || (b == BIOME_WINDSWEPT_SAVANNA);
#endif
return m;
}

bool _kuwebx(int b) {
bool m = false;
#ifdef BIOME_SNOWY_PLAINS
m = m || (b == BIOME_SNOWY_PLAINS);
#endif
#ifdef BIOME_SNOWY_TAIGA
m = m || (b == BIOME_SNOWY_TAIGA);
#endif
#ifdef BIOME_SNOWY_BEACH
m = m || (b == BIOME_SNOWY_BEACH);
#endif
#ifdef BIOME_SNOWY_SLOPES
m = m || (b == BIOME_SNOWY_SLOPES);
#endif
#ifdef BIOME_FROZEN_RIVER
m = m || (b == BIOME_FROZEN_RIVER);
#endif
#ifdef BIOME_FROZEN_OCEAN
m = m || (b == BIOME_FROZEN_OCEAN);
#endif
#ifdef BIOME_FROZEN_PEAKS
m = m || (b == BIOME_FROZEN_PEAKS);
#endif
#ifdef BIOME_ICE_SPIKES
m = m || (b == BIOME_ICE_SPIKES);
#endif
#ifdef BIOME_GROVE
m = m || (b == BIOME_GROVE);
#endif
return m;
}

bool _9cwhip(int b) {

if (hasCeiling && !hasSkylight) return true;

bool m = false;
#ifdef BIOME_NETHER_WASTES
m = m || (b == BIOME_NETHER_WASTES);
#endif
#ifdef BIOME_CRIMSON_FOREST
m = m || (b == BIOME_CRIMSON_FOREST);
#endif
#ifdef BIOME_WARPED_FOREST
m = m || (b == BIOME_WARPED_FOREST);
#endif
#ifdef BIOME_SOUL_SAND_VALLEY
m = m || (b == BIOME_SOUL_SAND_VALLEY);
#endif
#ifdef BIOME_BASALT_DELTAS
m = m || (b == BIOME_BASALT_DELTAS);
#endif
return m;
}

bool _z0kr59(int b) {
bool m = false;
#ifdef BIOME_THE_END
m = m || (b == BIOME_THE_END);
#endif
#ifdef BIOME_END_BARRENS
m = m || (b == BIOME_END_BARRENS);
#endif
#ifdef BIOME_END_HIGHLANDS
m = m || (b == BIOME_END_HIGHLANDS);
#endif
#ifdef BIOME_END_MIDLANDS
m = m || (b == BIOME_END_MIDLANDS);
#endif
#ifdef BIOME_SMALL_END_ISLANDS
m = m || (b == BIOME_SMALL_END_ISLANDS);
#endif
return m;
}

bool _l7czx3(int c) {

bool m = (c == 12) || (c == 4);
#ifdef CAT_DESERT
m = m || (c == CAT_DESERT);
#endif
#ifdef CAT_BADLANDS
m = m || (c == CAT_BADLANDS);
#endif
return m;
}

bool _bkzj48(int c) {

bool m = (c == 14);
#ifdef CAT_SWAMP
m = m || (c == CAT_SWAMP);
#endif
return m;
}

bool _bomyhb(int c) {

bool m = (c == 3);
#ifdef CAT_JUNGLE
m = m || (c == CAT_JUNGLE);
#endif
return m;
}

bool _xtge3w(int c) {

bool m = (c == 7);
#ifdef CAT_ICY
m = m || (c == CAT_ICY);
#endif
#ifdef CAT_SNOWY
m = m || (c == CAT_SNOWY);
#endif
return m;
}

bool _63jo5l(int c) {

bool m = (c == 6);
#ifdef CAT_SAVANNA
m = m || (c == CAT_SAVANNA);
#endif
return m;
}

float _dfzmvk(float smoothSnowy, int _3ae9i2, int _6ac3rz) {
return clamp(smoothSnowy, 0.0, 1.0);
}

float _2vpc5n(float smoothSwamp, int _3ae9i2, int _6ac3rz) {
return clamp(smoothSwamp, 0.0, 1.0);
}

float _avnajg(float smoothJungle, int _3ae9i2, int _6ac3rz, float _5dla5l) {
return clamp(smoothJungle, 0.0, 1.0) * (1.0 - clamp(_5dla5l, 0.0, 1.0));
}

float _j4acyp(float smoothArid, int _3ae9i2, int _6ac3rz) {
return clamp(smoothArid, 0.0, 1.0);
}

float _huw7hc(float _84w5al, int _3ae9i2, int _6ac3rz) {
return clamp(_84w5al, 0.0, 1.0);
}

float _jpbsbi(float smoothSnowy) {
return clamp(smoothSnowy, 0.0, 1.0);
}

float _arnt2g(float smoothSwamp) {
return clamp(smoothSwamp, 0.0, 1.0);
}

float _b1pxak(float smoothJungle, float _5dla5l) {
return clamp(smoothJungle, 0.0, 1.0) * (1.0 - clamp(_5dla5l, 0.0, 1.0));
}

float _za404r(float smoothArid) {
return clamp(smoothArid, 0.0, 1.0);
}

float _i0sr2e(float _84w5al) {
return clamp(_84w5al, 0.0, 1.0);
}

float _90d23l(float smoothOcean) {
return clamp(smoothOcean, 0.0, 1.0);
}

float _g4a6za(float _tgd7ug, float _5dla5l) {
return clamp(_tgd7ug, 0.0, 1.0) * (1.0 - clamp(_5dla5l, 0.0, 1.0));
}

vec3 _e6gplv() {
return vec3(101.0, 224.0, 196.0) / 255.0;
}

vec3 _b8134m() {
return vec3(98.0, 148.0, 240.0) / 255.0;
}

vec3 _d36tdk() {
return mix(_e6gplv(), _b8134m(), 0.55);
}

vec3 _1iquw2() {
return vec3(138.0, 129.0, 124.0) / 255.0;
}

vec3 _f9f345() {
return vec3(177.0, 176.0, 175.0) / 255.0;
}

vec3 _ch7orx() {
return mix(_1iquw2(), _f9f345(), 0.5);
}

vec3 _t7aktn() {
return _1iquw2();
}

vec3 _ktauxr(int _3ae9i2, vec3 _34vg5e) {

#ifdef END_FOG_ENABLED
if (_z0kr59(_3ae9i2)) return vec3(END_FOG_R, END_FOG_G, END_FOG_B);
#endif

#ifdef BIOME_CRIMSON_FOREST
if (_3ae9i2 == BIOME_CRIMSON_FOREST) return vec3(0.75, 0.12, 0.08);
#endif
#ifdef BIOME_BASALT_DELTAS
if (_3ae9i2 == BIOME_BASALT_DELTAS) return vec3(0.38, 0.38, 0.40);
#endif
#if defined(BIOME_WARPED_FOREST) || defined(BIOME_SOUL_SAND_VALLEY)
#ifdef BIOME_WARPED_FOREST
if (_3ae9i2 == BIOME_WARPED_FOREST) return vec3(0.09, 0.83, 1.00);
#endif
#ifdef BIOME_SOUL_SAND_VALLEY
if (_3ae9i2 == BIOME_SOUL_SAND_VALLEY) return vec3(0.10, 0.72, 0.76);
#endif
#endif

if (_9cwhip(_3ae9i2)) return _34vg5e;

if (_kuwebx(_3ae9i2)) return vec3(0.92, 0.94, 0.96);
if (_lgo6lt(_3ae9i2)) return _e6gplv();
if (_1a4dso(_3ae9i2)) return vec3(235.0, 213.0, 185.0) / 255.0;
if (_qn96wa(_3ae9i2)) return vec3(0.32, 0.42, 0.28);
if (_d35992(_3ae9i2)) return vec3(0.36, 0.62, 0.28);
if (_vkgr1p(_3ae9i2)) return _t7aktn();
return _34vg5e;
}

vec3 _7spagj(int _3ae9i2, vec3 _ou83fx) {
#ifdef END_SKY_ENABLED
if (_z0kr59(_3ae9i2)) return vec3(END_SKY_ZENITH_R, END_SKY_ZENITH_G, END_SKY_ZENITH_B);
#endif
if (_kuwebx(_3ae9i2)) return vec3(0.85, 0.90, 0.98);
if (_lgo6lt(_3ae9i2)) return _b8134m();
if (_1a4dso(_3ae9i2)) return vec3(150.0, 145.0, 207.0) / 255.0;
if (_qn96wa(_3ae9i2)) return vec3(0.45, 0.55, 0.42);
if (_d35992(_3ae9i2)) return vec3(0.28, 0.56, 0.24);
if (_vkgr1p(_3ae9i2)) return _f9f345();

return _ou83fx;
}

vec3 _yfroai(int _3ae9i2, int _6ac3rz, vec3 _34vg5e) {

if (_kuwebx(_3ae9i2) || _xtge3w(_6ac3rz)) return vec3(0.92, 0.94, 0.96);
if (_qn96wa(_3ae9i2) || _bkzj48(_6ac3rz)) return vec3(66.0, 128.0, 75.0) / 255.0;
if (_d35992(_3ae9i2) || _bomyhb(_6ac3rz)) return vec3(81.0, 189.0, 92.0) / 255.0;
if (_lgo6lt(_3ae9i2) || _63jo5l(_6ac3rz)) {
return _e6gplv();
}
if (_1a4dso(_3ae9i2) || _l7czx3(_6ac3rz)) {
return vec3(235.0, 213.0, 185.0) / 255.0;
}
if (_vkgr1p(_3ae9i2)) return _t7aktn();
return _34vg5e;
}

vec3 _fbc9j6(int _3ae9i2, int _6ac3rz, vec3 _ou83fx) {

if (_kuwebx(_3ae9i2) || _xtge3w(_6ac3rz)) return vec3(0.75, 0.85, 0.95);
if (_qn96wa(_3ae9i2) || _bkzj48(_6ac3rz)) return vec3(144.0, 199.0, 90.0) / 255.0;
if (_d35992(_3ae9i2) || _bomyhb(_6ac3rz)) return vec3(122.0, 211.0, 255.0) / 255.0;
if (_lgo6lt(_3ae9i2) || _63jo5l(_6ac3rz)) {
return _b8134m();
}
if (_1a4dso(_3ae9i2) || _l7czx3(_6ac3rz)) {
return vec3(150.0, 145.0, 207.0) / 255.0;
}
if (_vkgr1p(_3ae9i2)) return _f9f345();
return _ou83fx;
}

vec3 _ak436t(int _3ae9i2, int _6ac3rz, vec3 _ao9j8f) {
if (_kuwebx(_3ae9i2) || _xtge3w(_6ac3rz)) return vec3(0.92, 0.94, 0.96);
if (_qn96wa(_3ae9i2) || _bkzj48(_6ac3rz)) return vec3(66.0, 128.0, 75.0) / 255.0;
if (_d35992(_3ae9i2) || _bomyhb(_6ac3rz)) return vec3(81.0, 189.0, 92.0) / 255.0;
if (_lgo6lt(_3ae9i2) || _63jo5l(_6ac3rz)) {
return _e6gplv();
}
if (_1a4dso(_3ae9i2) || _l7czx3(_6ac3rz)) {
return vec3(235.0, 213.0, 185.0) / 255.0;
}
if (_vkgr1p(_3ae9i2)) return _1iquw2();
return _ao9j8f;
}

vec3 _3w9605(int _3ae9i2, int _6ac3rz, vec3 _ktdan2) {
if (_kuwebx(_3ae9i2) || _xtge3w(_6ac3rz)) return vec3(0.92, 0.94, 0.98);

if (_qn96wa(_3ae9i2) || _bkzj48(_6ac3rz)) return vec3(83.0, 77.0, 102.0) / 255.0;
if (_d35992(_3ae9i2) || _bomyhb(_6ac3rz)) return vec3(154.0, 194.0, 110.0) / 255.0;
if (_lgo6lt(_3ae9i2) || _63jo5l(_6ac3rz)) {
return _d36tdk();
}
if (_1a4dso(_3ae9i2) || _l7czx3(_6ac3rz)) {
return vec3(214.0, 206.0, 224.0) / 255.0;
}
if (_vkgr1p(_3ae9i2)) return _ch7orx();
return _ktdan2;
}

vec3 _2zssci(int _3ae9i2, int _6ac3rz, vec3 _e7gshf) {
if (_kuwebx(_3ae9i2) || _xtge3w(_6ac3rz)) return vec3(0.75, 0.85, 0.95);
if (_qn96wa(_3ae9i2) || _bkzj48(_6ac3rz)) return vec3(144.0, 199.0, 90.0) / 255.0;
if (_d35992(_3ae9i2) || _bomyhb(_6ac3rz)) return vec3(122.0, 211.0, 255.0) / 255.0;
if (_lgo6lt(_3ae9i2) || _63jo5l(_6ac3rz)) {
return _b8134m();
}
if (_vkgr1p(_3ae9i2)) return _f9f345();
if (_1a4dso(_3ae9i2) || _l7czx3(_6ac3rz)) {
return vec3(150.0, 145.0, 207.0) / 255.0;
}
return _e7gshf;
}

float _5pe64i(float _9yfvgh, float _fgx2j8) {
return clamp(_9yfvgh, 0.0, 1.0);
}

vec3 _kmbrsi(vec3 _cfhufr, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh) {
vec3 _8izj9y = _cfhufr;
if (_i6r0ml  > 0.001) _8izj9y = mix(_8izj9y, vec3(0.92, 0.94, 0.96), _i6r0ml);
if (_2d13on > 0.001) _8izj9y = mix(_8izj9y, vec3(81.0, 189.0, 92.0) / 255.0,  _2d13on);
if (_lfojrz  > 0.001) _8izj9y = mix(_8izj9y, vec3(66.0, 128.0, 75.0) / 255.0,  _lfojrz);
if (_9yfvgh   > 0.001) _8izj9y = mix(_8izj9y, vec3(235.0, 213.0, 185.0) / 255.0, _9yfvgh);
return _8izj9y;
}

vec3 _af4aog(vec3 _cfhufr, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh, float _fgx2j8) {
float _alha5v = _g4a6za(_fgx2j8, _lfojrz);
vec3 _8izj9y = _kmbrsi(_cfhufr, _i6r0ml, _2d13on, _lfojrz, _5pe64i(_9yfvgh, _alha5v));
if (_alha5v > 0.001) _8izj9y = mix(_8izj9y, _e6gplv(), _alha5v);
if (biome_pale_garden > 0.001) _8izj9y = mix(_8izj9y, _t7aktn(), clamp(biome_pale_garden, 0.0, 1.0));
return _8izj9y;
}

vec3 _g35vu4(vec3 _to6th3, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh) {
vec3 _8izj9y = _to6th3;
if (_i6r0ml  > 0.001) _8izj9y = mix(_8izj9y, vec3(0.75, 0.85, 0.95), _i6r0ml);
if (_2d13on > 0.001) _8izj9y = mix(_8izj9y, vec3(122.0, 211.0, 255.0) / 255.0, _2d13on);
if (_lfojrz  > 0.001) _8izj9y = mix(_8izj9y, vec3(144.0, 199.0, 90.0) / 255.0,  _lfojrz);
if (_9yfvgh   > 0.001) _8izj9y = mix(_8izj9y, vec3(150.0, 145.0, 207.0) / 255.0, _9yfvgh);
return _8izj9y;
}

vec3 _8i3fbp(vec3 _to6th3, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh, float _fgx2j8) {
float _alha5v = _g4a6za(_fgx2j8, _lfojrz);
vec3 _8izj9y = _g35vu4(_to6th3, _i6r0ml, _2d13on, _lfojrz, _5pe64i(_9yfvgh, _alha5v));
if (_alha5v > 0.001) _8izj9y = mix(_8izj9y, _b8134m(), _alha5v);
if (biome_pale_garden > 0.001) _8izj9y = mix(_8izj9y, _f9f345(), clamp(biome_pale_garden, 0.0, 1.0));
return _8izj9y;
}

vec3 _a5aq31(vec3 _k7huen, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh) {
vec3 _8izj9y = _k7huen;
if (_i6r0ml  > 0.001) _8izj9y = mix(_8izj9y, vec3(0.92, 0.94, 0.96), _i6r0ml);
if (_2d13on > 0.001) _8izj9y = mix(_8izj9y, vec3(81.0, 189.0, 92.0) / 255.0,  _2d13on);
if (_lfojrz  > 0.001) _8izj9y = mix(_8izj9y, vec3(66.0, 128.0, 75.0) / 255.0,  _lfojrz);
if (_9yfvgh   > 0.001) _8izj9y = mix(_8izj9y, vec3(235.0, 213.0, 185.0) / 255.0, _9yfvgh);
return _8izj9y;
}

vec3 _xlx4bl(vec3 _k7huen, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh, float _fgx2j8) {
float _alha5v = _g4a6za(_fgx2j8, _lfojrz);
vec3 _8izj9y = _a5aq31(_k7huen, _i6r0ml, _2d13on, _lfojrz, _5pe64i(_9yfvgh, _alha5v));
if (_alha5v > 0.001) _8izj9y = mix(_8izj9y, _e6gplv(), _alha5v);
if (biome_pale_garden > 0.001) _8izj9y = mix(_8izj9y, _1iquw2(), clamp(biome_pale_garden, 0.0, 1.0));
return _8izj9y;
}

vec3 _0yq4dx(vec3 _gxhruz, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh) {
vec3 _8izj9y = _gxhruz;
if (_i6r0ml  > 0.001) _8izj9y = mix(_8izj9y, vec3(0.92, 0.94, 0.98), _i6r0ml);
if (_2d13on > 0.001) _8izj9y = mix(_8izj9y, vec3(154.0, 194.0, 110.0) / 255.0, _2d13on);
if (_lfojrz  > 0.001) _8izj9y = mix(_8izj9y, vec3(83.0, 77.0, 102.0) / 255.0,   _lfojrz);
if (_9yfvgh   > 0.001) _8izj9y = mix(_8izj9y, vec3(214.0, 206.0, 224.0) / 255.0, _9yfvgh);
return _8izj9y;
}

vec3 _ze8dg7(vec3 _gxhruz, float _i6r0ml, float _2d13on, float _lfojrz, float _9yfvgh, float _fgx2j8) {
float _alha5v = _g4a6za(_fgx2j8, _lfojrz);
vec3 _8izj9y = _0yq4dx(_gxhruz, _i6r0ml, _2d13on, _lfojrz, _5pe64i(_9yfvgh, _alha5v));
if (_alha5v > 0.001) _8izj9y = mix(_8izj9y, _d36tdk(), _alha5v);
if (biome_pale_garden > 0.001) _8izj9y = mix(_8izj9y, _ch7orx(), clamp(biome_pale_garden, 0.0, 1.0));
return _8izj9y;
}

vec3 _3vbi0y(int _3ae9i2, int _6ac3rz) {
vec3 _iwuhpl = vec3(0.18, 0.26, 0.40);
#ifdef CAVE_FOG_USE_BIOME_SKY_COLOR
return _2zssci(_3ae9i2, _6ac3rz, _iwuhpl);
#endif
#ifdef BIOME_DRIPSTONE_CAVES
if (_3ae9i2 == BIOME_DRIPSTONE_CAVES) _iwuhpl = vec3(107.0,  98.0,  95.0) / 255.0;
#endif
#ifdef BIOME_LUSH_CAVES
if (_3ae9i2 == BIOME_LUSH_CAVES)      _iwuhpl = vec3( 80.0,  83.0,   5.0) / 255.0;
#endif
#ifdef BIOME_DEEP_DARK
if (_3ae9i2 == BIOME_DEEP_DARK)       _iwuhpl = vec3(0.14, 0.20, 0.30);
#endif

#ifdef BIOME_TERRALITH_GLOWING_GROTTO
if (_3ae9i2 == BIOME_TERRALITH_GLOWING_GROTTO) _iwuhpl = vec3(0.20, 0.55, 0.95);
#endif
#ifdef BIOME_GLOWING_GROTTO
if (_3ae9i2 == BIOME_GLOWING_GROTTO) _iwuhpl = vec3(0.20, 0.55, 0.95);
#endif
#ifdef BIOME_TERRALITH_CAVE_GLOWING_GROTTO
if (_3ae9i2 == BIOME_TERRALITH_CAVE_GLOWING_GROTTO) _iwuhpl = vec3(0.20, 0.55, 0.95);
#endif
return _iwuhpl;
}

vec3 _3vbi0y(int _3ae9i2) {
return _3vbi0y(_3ae9i2, 0);
}

vec3 _gabxsk(vec3 _z2o9gx, float _703fao) {
vec3 _lfsa79 = _z2o9gx;
float t = smoothstep(-8.0, 8.0, _703fao);
return mix(_lfsa79, _z2o9gx, t);
}

vec3 _a9ahaz(int _3ae9i2, float _703fao) {
return _gabxsk(_3vbi0y(_3ae9i2, 0), _703fao);
}

#endif
