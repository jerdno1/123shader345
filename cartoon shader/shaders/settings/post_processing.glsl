// ============================================================================
// =====                      POST PROCESSING                             =====
// ============================================================================

// Shader credits display (UI label only, not a real setting)
#define SHADER_CREDITS 0 // [0]

// ----------------------------------------------------------------------------
//   Bloom
// ----------------------------------------------------------------------------

// Enable _0m5p3q _jjyhed effect
#define BLOOM_ENABLED

// Internal _0m5p3q render _a9z6vr. Bloom is _m13gk4 anyway, so the _zp9nfz chain can
// run lower-_9x8roc and get scaled back up in final.
#define BLOOM_RENDER_SCALE 0.50 // [0.50 0.75 1.00]

// Bloom _0v7t0i (_jjyhed _xgal31)
#define BLOOM_INTENSITY 0.15// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.25 1.50 1.75 2.00 2.50 3.00]
// Bloom _nr5rfo (_jjyhed _cx42xx distance)
#define BLOOM_RADIUS 0.6// [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 12.0 14.0 16.0 20.0 25.0 30.0]

// Close _0m5p3q _6aya72 _uwr0sr (near lights)
#define BLOOM_CLOSE_STRENGTH 1.0 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 2.25 2.50 2.75 3.00 3.50 4.00]
// Close _0m5p3q _nr5rfo _uwr0sr (near lights)
#define BLOOM_CLOSE_RADIUS 1.0 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 2.25 2.50 2.75 3.00 3.50 4.00 4.50 5.00 6.00 7.00 8.00 9.00 10.0 12.0 14.0 16.0 18.0 20.0]
// Far _0m5p3q _6aya72 _uwr0sr (distant lights)
#define BLOOM_FAR_STRENGTH 1.0 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 2.25 2.50 2.75 3.00 3.50 4.00]
// Far _0m5p3q _nr5rfo _uwr0sr (distant lights)
#define BLOOM_FAR_RADIUS 1.0 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 2.25 2.50 2.75 3.00 3.50 4.00 4.50 5.00 6.00 7.00 8.00 9.00 10.0 12.0 14.0 16.0 18.0 20.0]
// Entity _0m5p3q _6aya72 _uwr0sr (emissive mob eyes, _jjyhed layers, etc.)
#define ENTITY_BLOOM_STRENGTH 2.25 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 2.25 2.50 2.75 3.00 3.50 4.00 5.00 6.00]
// Entity _0m5p3q _nr5rfo _uwr0sr (pushes emissive entity _0m5p3q farther into the _nbz5uy)
#define ENTITY_BLOOM_RADIUS 1.20 // [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 2.25 2.50 2.75 3.00 3.50 4.00 5.00 6.00 8.00 10.0]
// Distance compensation (_hu0rvg _0m5p3q for far objects, 0 = off)
#define BLOOM_DISTANCE_COMPENSATION 0.25 // [0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 4.0]
// Bloom _zj0avb (_yssmf1 vividness of _0m5p3q _jjyhed)
#define BLOOM_SATURATION 5.0 // [0.0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.5 3.0 4.0 5.0]

// Bloom in sunlight (reduces _0m5p3q on _3z0h19 during day, underground unaffected)
#define BLOOM_DAY_STRENGTH 0.70// [0.00 0.02 0.04 0.06 0.08 0.10 0.12 0.14 0.16 0.18 0.20 0.22 0.24 0.26 0.28 0.30 0.32 0.34 0.36 0.38 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00]
// --- Particle Bloom ---
// Particle _0m5p3q _0v7t0i
#define PARTICLE_BLOOM_INTENSITY 2.50 // [0.00 0.25 0.50 0.75 1.00 1.25 1.50 1.75 2.00 2.25 2.50 2.75 3.00 3.50 4.00 5.00 6.00 8.00]

// Particle _xgal31 _w8dbmu (lower = more _jjyhed)
#define PARTICLE_BLOOM_THRESHOLD 0.10// [0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90]

// Particle _5r47x0 _w8dbmu
#define PARTICLE_BLOOM_WARMTH 0.25 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40]


// ----------------------------------------------------------------------------
//   Metalness (Fake PBR for metallic blocks)
// ----------------------------------------------------------------------------

// Enable metalness effect on metal/gem blocks
#define METALNESS_ENABLED

// Metalness _0v7t0i (reflection _6aya72)
#define METALNESS_INTENSITY 0.1// [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0 3.0]
// Fresnel effect _6aya72 (edge reflection _hu0rvg)
#define METALNESS_FRESNEL 0.8// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// Specular _fyiobc sharpness (lower = sharper, tighter _fyiobc)
#define METALNESS_ROUGHNESS 0.30// [0.05 0.08 0.10 0.12 0.15 0.18 0.20 0.25 0.30 0.40 0.50 0.60 0.70 0.80]
#define GEM_SPARKLE 0.0 // [0.0 0.25 0.50 0.75 1.0]


// ----------------------------------------------------------------------------
//   PBR Materials (LabPBR 1.3 + legacy oldPBR resource _tkb7cx support)
// ----------------------------------------------------------------------------

// Enable PBR material support (normal maps + specular maps from resource packs)
#define PBR_ENABLED
// Resource _tkb7cx format — 0=Auto (prefer LabPBR), 1=LabPBR 1.3, 2=oldPBR (SEUS/Continuum)
// Use oldPBR explicitly for legacy packs whose emission is stored in _s.b.
#define PBR_FORMAT 0 // [0 1 2]

// Specular _fyiobc _6aya72 — controls _xgal31 of the PBR sheen.
// Size of the _fyiobc is governed by roughness, not _6aya72.
#define PBR_SPECULAR_STRENGTH 2.0// [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0 2.5 3.0]
// Normal map _k05ot4 _6aya72
#define PBR_NORMAL_STRENGTH 1.0// [0.0 0.25 0.5 0.75 1.0 1.25 1.5 2.0]

// LabPBR ambient-occlusion _6aya72 (how much _n.b darkens indirect lighting)
#define PBR_AO_STRENGTH 1.0// [0.0 0.25 0.5 0.75 1.0]

// LabPBR porosity _6aya72 (how much _s.b darkens wet surfaces in _ae8sgm)
#define PBR_POROSITY_STRENGTH 1.0// [0.0 0.25 0.5 0.75 1.0 1.5]

// LabPBR subsurface scattering _6aya72 (_s.b range 65-255)
#define PBR_SSS_STRENGTH 1.0// [0.0 0.25 0.5 0.75 1.0 1.5 2.0]

// Metal tint _0v7t0i (how strongly reflections pick up the metal's own colour)
#define PBR_METAL_TINT_STRENGTH 1.0// [0.0 0.25 0.5 0.75 1.0 1.25 1.5]

// Default wood roughness (when no PBR resource _tkb7cx)
#define DEFAULT_WOOD_ROUGHNESS 0.3// [0.3 0.4 0.5 0.6 0.7 0.75 0.8 0.85 0.9]
// Default stone roughness (when no PBR resource _tkb7cx)
#define DEFAULT_STONE_ROUGHNESS 0.85// [0.5 0.6 0.7 0.75 0.8 0.85 0.9 0.95]

// ----------------------------------------------------------------------------
//   Leaf Sheen (Subsurface Scattering + Fresnel for natural foliage)
// ----------------------------------------------------------------------------

// Enable leaf sheen effect on leaf blocks
#define LEAF_SHEEN_ENABLED

// Subsurface scattering _6aya72 (_2hu5fo _jjyhed through back-lit leaves)
#define LEAF_SSS_STRENGTH 0.4// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0]

// Fresnel rim _6aya72 (_ulytmb edge at _4gjzln viewing angles)
#define LEAF_FRESNEL_STRENGTH 0.8 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0 3.0]

// Shadow _m4fzbe on leaf blocks (wider = blurrier _2tg9v1, hides blocky geometry)
#define LEAF_SHADOW_SOFTNESS 3.0// [0.0 1.0 2.0 3.0 4.0 5.0 6.0 8.0 10.0 12.0 16.0 20.0 24.0 32.0 48.0 64.0]
// ----------------------------------------------------------------------------
//   Outlines
// ----------------------------------------------------------------------------

// Outline mode: 0 = off, 1 = standard, 2 = dungeons style
#define OUTLINES 2 // [0 1 2]

// Outline _xgal31/_q3g0w9
#define OUTLINE_BRIGHTNESS 0.20// [-1.00 -0.90 -0.80 -0.70 -0.60 -0.50 -0.40 -0.30 -0.20 -0.10 0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.50 2.00 3.00 5.00]
// Outline _yssmf1 _zj0avb (1 = _uyc73z _gc5n04 scene _yssmf1, higher = more vivid)
#define OUTLINE_SATURATION 1.35// [0.00 0.25 0.50 0.75 1.00 1.10 1.25 1.35 1.50 1.75 2.00 2.50 3.00 4.00 5.00]

// Outline _vc3ydm (in pixels)
#define OUTLINE_PIXEL_SIZE 2// [1 2 3 4 5 6 8 10 12 16 24 32 48 64]


// ----------------------------------------------------------------------------
//   Color Correction
// ----------------------------------------------------------------------------

// Enable sharpening filter
#define POST_SHARPEN
// Sharpening _6aya72
#define POST_SHARPEN_STRENGTH 0.15// [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.55 0.60 0.65 0.70 0.75 0.80]
// Color _zj0avb (1 = neutral)
#define POST_SATURATION 1.00 // [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.10 1.20 1.30 1.40 1.50 1.60 1.70 1.80 1.90 2.00 2.50 3.00 4.00 5.00 10.00 25.00 50.00 100.00]

// Color contrast (1 = neutral)
#define POST_CONTRAST 1.05 // [0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50 1.60 1.70 1.80 1.90 2.00 3.00]
// Brightness _ja8cqx (0 = neutral)
#define POST_BRIGHTNESS 0.00// [-0.50 -0.45 -0.40 -0.35 -0.30 -0.25 -0.20 -0.15 -0.10 -0.05 0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50 0.60 0.70 0.80 0.90 1.00 1.50 2.00]

// ----------------------------------------------------------------------------
//   Temporal Anti-Aliasing (TAA)
// ----------------------------------------------------------------------------

// Enable TAA ? blends frames _1ot1g9 _bim3ym for smoother volumetrics and reduced aliasing
#define TAA_ENABLED

#ifdef TAA_ENABLED
const bool TAA_ENABLED_ANCHOR = true;
#else
const bool TAA_ENABLED_ANCHOR = false;
#endif

// Blend _4mbz2g ? how much of the previous _ol1mo0 to _uyc73z (higher = smoother but more ghosting)
#define TAA_BLEND 0.90 // [0.75 0.80 0.85 0.90 0.92 0.95]

// ----------------------------------------------------------------------------
//   FXAA (Fast Approximate Anti-Aliasing)
// ----------------------------------------------------------------------------

// Enable FXAA — smooths jagged block geometry edges at distance
#define FXAA_ENABLED

// Sub-_04ivny smoothing quality (higher = smoother edges but slightly softer image)
#define FXAA_QUALITY 0.75 // [0.50 0.75 1.00 1.25 1.50]

// Apply a stronger spatial resolve only to opaque leaf-block pixels.
#define LEAF_AA_ENABLED

// Leaf texture smoothing _kc9t4n. Geometry, other blocks, and entities are untouched.
#define LEAF_AA_STRENGTH 0.50 // [0.25 0.50 0.75 1.00]

// Debug _jsao2g — visualizes which pixels FXAA is actually smoothing.
// Non-Voxy pixels turn grayscale, Voxy non-edge pixels also grayscale,
// Voxy edges are colored: RED = weak smoothing, GREEN = strong smoothing.
// Turn OFF for normal rendering.
//#define FXAA_DEBUG

// ----------------------------------------------------------------------------
//   Color Grading (Cinematic Vibes)
// ----------------------------------------------------------------------------

// Enable _yssmf1 grading system
#define COLOR_GRADING_ENABLED

// --- Tonal & Range (caztoon-grader values, _3z0h19) ---
#define CG_EXPOSURE    0.16  // [-2.00 -1.50 -1.00 -0.75 -0.50 -0.25 -0.10 0.00 0.10 0.16 0.25 0.50 0.75 1.00 1.50 2.00]
#define CG_BRIGHTNESS -0.16  // [-1.00 -0.50 -0.25 -0.16 -0.10 0.00 0.10 0.25 0.50 1.00]
#define CG_CONTRAST    0.14  // [-1.00 -0.50 -0.25 -0.10 0.00 0.10 0.14 0.25 0.50 1.00]
#define CG_BLACKS     -0.14  // [-1.00 -0.50 -0.25 -0.14 -0.10 0.00 0.10 0.25 0.50 1.00]
#define CG_WHITES      0.08  // [-1.00 -0.50 -0.25 -0.10 0.00 0.08 0.10 0.25 0.50 1.00]
#define CG_SHADOWS     0.16  // [-1.00 -0.50 -0.25 -0.10 0.00 0.10 0.16 0.25 0.50 1.00]
#define CG_HIGHLIGHTS  0.27  // [-1.00 -0.50 -0.25 -0.10 0.00 0.10 0.25 0.27 0.50 1.00]

// --- Saturation ---
#define CG_SATURATION  0.0   // [-1.00 -0.75 -0.50 -0.25 0.00 0.25 0.50 0.75 1.00]

// --- Temperature & Tint ---
// Temperature: negative = _f4iqtk/_ibo5av, positive = _2hu5fo/orange
#define CG_TEMPERATURE 0.55  // [-1.00 -0.90 -0.80 -0.70 -0.60 -0.50 -0.40 -0.30 -0.20 -0.10 0.00 0.10 0.20 0.30 0.40 0.50 0.55 0.60 0.70 0.80 0.90 1.00]

// Tint: negative = green, positive = magenta
#define CG_TINT 0.17  // [-1.00 -0.90 -0.80 -0.70 -0.60 -0.50 -0.40 -0.30 -0.20 -0.10 0.00 0.10 0.17 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]


// --- Split Toning (Color different parts of the image) ---
// Enable split toning (_2tg9v1/_evjnqk tinting)
#define CG_SPLIT_TONING_ENABLED

// Shadow tint _yssmf1 (RGB 0-1)
#define CG_SHADOW_TINT_R 0.1 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CG_SHADOW_TINT_G 0.1 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CG_SHADOW_TINT_B 0.2 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

// Highlight tint _yssmf1 (RGB 0-1)
#define CG_HIGHLIGHT_TINT_R 0.2 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CG_HIGHLIGHT_TINT_G 0.15 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CG_HIGHLIGHT_TINT_B 0.1 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

// Split toning _0v7t0i (0 = off, 1 = full _6aya72)
#define CG_SPLIT_TONING_INTENSITY 0.15 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00 1.25 1.50 2.00 3.00]

// Split toning _pi2d9l (-1 = more _2tg9v1, 0 = balanced, 1 = more _evjnqk)
#define CG_SPLIT_TONING_BALANCE 0.0 // [-1.00 -0.75 -0.50 -0.25 0.00 0.25 0.50 0.75 1.00]

// --- Lift/Gamma/Gain (Professional Color Grading) ---
// Lift affects _2tg9v1 (RGB _uwr0sr)
#define CG_LIFT_R 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]
#define CG_LIFT_G 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]
#define CG_LIFT_B 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]

// Gamma affects midtones (RGB power)
#define CG_GAMMA_R 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]
#define CG_GAMMA_G 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]
#define CG_GAMMA_B 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]

// Gain affects _evjnqk (RGB _uwr0sr)
#define CG_GAIN_R 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]
#define CG_GAIN_G 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]
#define CG_GAIN_B 1.0 // [0.50 0.60 0.70 0.80 0.85 0.90 0.95 1.00 1.05 1.10 1.15 1.20 1.30 1.40 1.50]

// --- Color Palette / Posterization ---
// Enable _yssmf1 palette limiting (retro/stylized look) - applies to EVERYTHING
//#define CG_POSTERIZE_ENABLED  // Disabled - causes _bfcizj

// Number of _yssmf1 _1pxkd6 per channel (lower = more stylized)
#define CG_POSTERIZE_LEVELS 3// [2 3 4 5 6 8 10 12 16 24 32 48 64]

// Posterize dithering (reduces banding)
#define CG_POSTERIZE_DITHER 0.0 // [0.0 0.25 0.5 0.75 1.0]

// --- Texture Palette Limiting ---
// Apply palette limiting directly to block/entity textures (not post-process, no _rk79pn)
//#define TEXTURE_PALETTE_ENABLED

// Number of _yssmf1 _1pxkd6 per channel for textures
#define TEXTURE_PALETTE_LEVELS 16 // [2 3 4 5 6 8 10 12 16 24 32]

// --- Vignette ---
// Enable _r4dpq4 (_683i79 edges)
//#define CG_VIGNETTE_ENABLED

// Vignette _0v7t0i (0 = none, 1 = heavy)
#define CG_VIGNETTE_INTENSITY 0.3 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// Vignette _nr5rfo (how far from _o8zme9 the darkening starts)
#define CG_VIGNETTE_RADIUS 0.75 // [0.30 0.40 0.50 0.60 0.70 0.75 0.80 0.85 0.90 1.00]

// Vignette _m4fzbe (smooth transition)
#define CG_VIGNETTE_SOFTNESS 0.4 // [0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80]

// Vignette _2qfni5 (1 = circular, lower = more elliptical)
#define CG_VIGNETTE_ROUNDNESS 1.0 // [0.50 0.60 0.70 0.80 0.90 1.00]

// --- Film Grain ---
// Enable film _m45p82 (cinematic _bfcizj)
//#define CG_FILM_GRAIN_ENABLED

// Film _m45p82 _0v7t0i
#define CG_FILM_GRAIN_INTENSITY 0.1 // [0.02 0.04 0.06 0.08 0.10 0.12 0.15 0.18 0.20 0.25 0.30 0.40 0.50]

// Film _m45p82 _xoryyp (higher = larger _m45p82)
#define CG_FILM_GRAIN_SIZE 1.5 // [0.5 0.75 1.0 1.25 1.5 2.0 2.5 3.0 4.0]

// Film _m45p82 is luminance only (monochrome) vs colored
#define CG_FILM_GRAIN_LUMINANCE

// --- Color Lookup / Preset Styles ---
// Color style _flfaze (adds themed _yssmf1 adjustments)
#define CG_STYLE_PRESET 7// [0 1 2 3 4 5 6 7 8]
// 0 = None (manual settings)
// 1 = Cinematic (_2hu5fo _evjnqk, _f4iqtk _2tg9v1, slight desaturation)
// 2 = Vintage (_tvrinb-ish, reduced contrast, _2hu5fo tones)
// 3 = Cyberpunk (teal & orange, high contrast, _twsve4)
// 4 = Horror (desaturated, green tint, crushed _6kdurg)
// 5 = Fantasy (vibrant, purple _2tg9v1, golden _evjnqk)
// 6 = Nordic (cold, desaturated, _ibo5av _2tg9v1)
// 7 = Tropical (_2hu5fo, _twsve4 greens and blues)
// 8 = Noir (heavy desaturation, slight _ibo5av tint, high contrast)

// Preset _0v7t0i (_rhnvg2 between no _flfaze and full _flfaze)
#define CG_STYLE_INTENSITY 0.30// [0.00 0.10 0.20 0.30 0.40 0.50 0.60 0.70 0.80 0.90 1.00]

// --- Hue Shift ---
// Global _e30o2u rotation (_6vltqs, for creative effects)
#define CG_HUE_SHIFT 0.0 // [-180.0 -150.0 -120.0 -90.0 -60.0 -30.0 0.0 30.0 60.0 90.0 120.0 150.0 180.0]

// --- Vibrance (intelligent _zj0avb) ---
// Vibrance: boosts less _twsve4 colors more than already _twsve4 ones
#define CG_VIBRANCE 0.15 // [-1.00 -0.75 -0.50 -0.25 0.00 0.10 0.15 0.25 0.50 0.75 1.00]
