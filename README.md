# Pokemon ShaderMix

This repository includes a single-file GLSL version and an mGBA-ready shader package.

## mGBA (folder package)

For mGBA, use the whole [`Pokemon-ShaderMix.shader` folder](mgba/Pokemon-ShaderMix.shader/), not the standalone GLSL file. Installation notes are in [`mgba/README.md`](mgba/README.md). To download the package, download the repository ZIP and extract the `.shader` folder intact.

## Standalone GLSL version

[`pokemon-shadermix.glsl`](pokemon-shadermix.glsl) is for compatible shader hosts; it is not the mGBA package entry point.

The combined effect is a compact single-pass Scale3x-style edge-aware pixel-art filter with bevel-style highlighting and image-adjustment controls. It is not a verbatim merge of the original multi-pass ScaleFX pipeline. See [ATTRIBUTIONS.md](ATTRIBUTIONS.md) for source credits and license information.
