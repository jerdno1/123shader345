/* RENDERTARGETS: 2,3 */

#include "/settings.glsl"

uniform sampler2D colortex2;
uniform sampler2D colortex3;

in vec2 texcoord;

const float weights[7] = float[7](
0.198596, 0.175713, 0.121703, 0.065984, 0.028002, 0.009300, 0.002216
);

vec4 _fkfqtk(vec2 uv, vec2 _8a1ql9, vec2 _fr7eub) {
if (uv.x < 0.0 || uv.y < 0.0 || uv.x > BLOOM_RENDER_SCALE || uv.y > BLOOM_RENDER_SCALE) return vec4(0.0);
return texture(colortex2, clamp(uv, _8a1ql9, _fr7eub));
}

vec4 _5zwpla(vec2 uv, vec2 _8a1ql9, vec2 _fr7eub) {
if (uv.x < 0.0 || uv.y < 0.0 || uv.x > BLOOM_RENDER_SCALE || uv.y > BLOOM_RENDER_SCALE) return vec4(0.0);
return texture(colortex3, clamp(uv, _8a1ql9, _fr7eub));
}

void main() {
#ifdef BLOOM_ENABLED
vec2 _s4ja50 = 1.0 / vec2(textureSize(colortex2, 0));
vec2 _7jen7c = texcoord * BLOOM_RENDER_SCALE;
vec2 _8a1ql9 = _s4ja50 * 0.5;
vec2 _fr7eub = vec2(BLOOM_RENDER_SCALE) - _s4ja50 * 0.5;
vec2 _f9ef2n = vec2(_s4ja50.x * BLOOM_RADIUS * BLOOM_CLOSE_RADIUS * 8.0 * BLOOM_RENDER_SCALE, 0.0);
vec2 _c4vpix = vec2(_s4ja50.x * BLOOM_RADIUS * BLOOM_FAR_RADIUS * 3.0 * BLOOM_RENDER_SCALE, 0.0);

vec4 _0m5p3q = _fkfqtk(_7jen7c, _8a1ql9, _fr7eub) * weights[0];
vec4 _pcz6c3 = _5zwpla(_7jen7c, _8a1ql9, _fr7eub) * weights[0];

for (int i = 1; i < 5; i++) {
vec2 _rzc894 = _f9ef2n * (float(i) + 0.5);
vec2 _88zsen = _c4vpix * (float(i) + 0.5);
_0m5p3q += _fkfqtk(_7jen7c + _rzc894, _8a1ql9, _fr7eub) * weights[i];
_0m5p3q += _fkfqtk(_7jen7c - _rzc894, _8a1ql9, _fr7eub) * weights[i];
_pcz6c3 += _5zwpla(_7jen7c + _88zsen, _8a1ql9, _fr7eub) * weights[i];
_pcz6c3 += _5zwpla(_7jen7c - _88zsen, _8a1ql9, _fr7eub) * weights[i];
}

gl_FragData[0] = _0m5p3q;
gl_FragData[1] = _pcz6c3;
#else
gl_FragData[0] = vec4(0.0);
gl_FragData[1] = vec4(0.0);
#endif
}
