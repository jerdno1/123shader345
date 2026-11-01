#include "/settings.glsl"

uniform sampler2D gtexture;
uniform float alphaTestRef;

in vec2 texcoord;
flat in int block_id_out;
in float grass_blade_mask_out;
flat in float grass_cube_mask_out;
flat in float leaf_flat_mask_out;
flat in int block_id_raw_out;
in float shaft_height_metric_out;

/* DRAWBUFFERS:01 */
layout(location = 0) out vec4 shadowcolor;
layout(location = 1) out vec4 shadowcolor1out;

vec3 _wprw2k(vec3 tint) {
float _5linhz = max(max(tint.r, tint.g), tint.b);
if (_5linhz <= 0.0001) return vec3(1.0);
tint /= _5linhz;
tint = pow(clamp(tint, vec3(0.0), vec3(1.0)), vec3(1.35));
return clamp(tint, vec3(0.0), vec3(1.0));
}

vec3 _l37wim(int blockId) {
if (blockId == 64) return _wprw2k(vec3(1.0, 0.1, 0.1));
if (blockId == 65) return _wprw2k(vec3(1.0, 0.3, 0.1));
if (blockId == 66) return _wprw2k(vec3(1.0, 1.0, 0.1));
if (blockId == 67) return _wprw2k(vec3(1.0, 0.75, 0.5));
if (blockId == 68) return _wprw2k(vec3(0.3, 1.0, 0.3));
if (blockId == 69) return _wprw2k(vec3(0.1, 1.0, 0.1));
if (blockId == 70) return _wprw2k(vec3(0.1, 0.15, 1.0));
if (blockId == 71) return _wprw2k(vec3(0.5, 0.65, 1.0));
if (blockId == 72) return _wprw2k(vec3(0.3, 0.8, 1.0));
if (blockId == 73) return _wprw2k(vec3(0.7, 0.3, 1.0));
if (blockId == 74) return _wprw2k(vec3(1.0, 0.1, 1.0));
if (blockId == 75) return _wprw2k(vec3(1.0, 0.4, 1.0));
if (blockId == 76) return vec3(0.05);
return vec3(1.0);
}

void main() {

bool _m5cxj4 = (block_id_raw_out == 20002 || block_id_raw_out == 20003);
#ifndef FLOATING_TEXT_SHADOWS
if (_m5cxj4) discard;
#endif

float _o0jvje = (block_id_raw_out == 0 || _m5cxj4) ? 1.0 : 0.0;
float _094zxa = 0.25 + max(shaft_height_metric_out, 0.0) * 0.05;
_094zxa = clamp(_094zxa, 0.25, 1.0);
if (_o0jvje > 0.5) _094zxa = 0.25;

vec4 _yssmf1 = texture(gtexture, texcoord);
bool _sv28ej = (block_id_out == 88);

bool _67wt8n = (block_id_out >= 121 && block_id_out <= 128) || (block_id_raw_out >= 10121 && block_id_raw_out <= 10128);
if (_67wt8n) {
discard;
}
if (block_id_out == 15 && grass_cube_mask_out < 0.5) {
discard;
}

#ifdef MAGICAL_TOUCH
if (block_id_out == 2 || block_id_out == 3 || block_id_out == 4 || block_id_out == 19 || block_id_out == 60 || block_id_out == 61 || block_id_out == 62) {
discard;
}
if (block_id_out == 15 || _67wt8n) {

if ((block_id_out == 15 && grass_cube_mask_out < 0.5) || grass_blade_mask_out > 0.01) {
discard;
}
}
#endif

if (block_id_out == 1 || block_id_out == 8) discard;

bool _y4aeoy = (block_id_out == 201 || block_id_raw_out == 10201);
if (leaf_flat_mask_out > 0.5 && !_y4aeoy) discard;

float _s7uc4g = alphaTestRef;
bool _n1mw3y = (block_id_out == 2 || block_id_out == 3 || block_id_out == 4 || block_id_out == 19 || block_id_out == 60 || block_id_out == 61 || block_id_out == 62);
if (_n1mw3y) _s7uc4g = max(_s7uc4g, 0.35);

bool _id8pw8 = (block_id_out == 5 || block_id_out == 82 || _y4aeoy);

if (!_sv28ej && !_id8pw8 && block_id_out != 63 && _yssmf1.a < _s7uc4g) {
discard;
}
if ((_sv28ej || block_id_out == 63) && _yssmf1.a < alphaTestRef) {
discard;
}

if (_sv28ej) {
shadowcolor1out = vec4(_o0jvje, 0.0, 0.0, 0.25);
shadowcolor = vec4(0.6, 0.1, 1.0, 0.05);
return;
}
if (block_id_out == 63) {
shadowcolor1out = vec4(_o0jvje, 0.0, 0.0, 0.25);
shadowcolor = vec4(0.2, 0.8, 0.6, 0.05);
return;
}

if (_n1mw3y) {
shadowcolor1out = vec4(_o0jvje, 0.0, 0.0, _094zxa);
shadowcolor = vec4(0.0, 0.0, 0.0, 1.0);
return;
}

bool _n5tvnf = (block_id_out == 14 || (block_id_out >= 64 && block_id_out <= 79) || block_id_out == 80);
if (_n5tvnf) {
vec3 tint = _l37wim(block_id_out);

shadowcolor1out = vec4(_o0jvje, 0.0, 0.0, 0.25);
shadowcolor = vec4(tint, 0.05);
return;
}

shadowcolor1out = vec4(_o0jvje, 0.0, 0.0, _094zxa);

shadowcolor = vec4(_yssmf1.rgb, 1.0);
}
