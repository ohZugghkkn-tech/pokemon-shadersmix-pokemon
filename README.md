# Pokemon ShaderMix

A standalone, single-pass GLSL shader combining:

- ScaleFX/Scale3x-style edge-aware pixel-art reconstruction
- Bevel-style per-pixel highlights
- Image-adjustment controls (saturation, contrast, luminance, gamma, and RGB balance)

## Use

Load `pokemon-shadermix.glsl` as a GLSL-compatible post-processing shader. It expects `Source`, `TextureSize`, `OutputSize`, and `vTexCoord` inputs. For the intended pixel-art effect, use an output scale around 3x or higher and nearest-neighbor source sampling. Shader parameter support depends on the host.

This is a compact, independent single-pass integration and **not** a byte-for-byte merge of the upstream ScaleFX multi-pass pipeline. The upstream ScaleFX pipeline uses multiple intermediate passes; this file implements a Scale3x-style neighborhood decision to keep the result in one shader. The `colorspace-tools.h` header is not incorporated; color adjustments use a small luminance-based operation instead.

See [ATTRIBUTIONS.md](ATTRIBUTIONS.md) for source credits and license information. The combined shader is distributed under GPL-2.0-or-later because it incorporates the GPL-licensed Bevel shader approach; upstream license notices remain applicable to their respective works.
