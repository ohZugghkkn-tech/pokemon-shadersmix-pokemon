# mGBA version

This folder is an mGBA-format shader package. Keep the `.shader` directory intact; mGBA loads its `manifest.ini` and fragment shader together.

## Install

Copy `Pokemon-ShaderMix.shader` into the `shaders` directory used by your mGBA installation, then restart mGBA and select **Pokemon ShaderMix** in the shader settings. If the shader does not appear, verify that `manifest.ini` is directly inside the `.shader` folder and that your mGBA build supports custom shaders.

Package files:

- `manifest.ini` — one-pass manifest and adjustable parameters
- `pokemon-shadermix.fs` — mGBA-compatible GLSL fragment shader (`tex`, `texSize`, `texCoord`, `gl_FragColor`)

The manifest requests 3x output dimensions; available display scaling and integer-scaling behavior depend on the mGBA version and renderer. The shader is a compact Scale3x-style edge-aware implementation and is not the original multi-pass ScaleFX pipeline. It does not include `colorspace-tools.h`.
