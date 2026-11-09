# Attributions and licenses

`pokemon-shadermix.glsl` is an original single-pass integration, not a verbatim copy of the upstream shader files. It adapts the general neighborhood-based pixel-art scaling approach and Bevel effect into one GLSL shader and provides image-adjustment controls.

## ScaleFX — Sp00kyFox

- Upstream: [libretro/glsl-shaders — ScaleFX](https://github.com/libretro/glsl-shaders/tree/master/scalefx)
- License: MIT
- The upstream ScaleFX source includes this copyright and permission notice, which is retained here:

> Copyright (c) 2016 Sp00kyFox - ScaleFX@web.de
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Bevel — Hyllian/Jararaca

- Upstream: [libretro/slang-shaders — bevel.slang](https://github.com/libretro/slang-shaders/blob/master/handheld/shaders/bevel.slang)
- Copyright: Copyright (C) 2011-2014 Hyllian/Jararaca - sergiogdb@gmail.com
- License: GNU GPL version 2 or (at your option) any later version (GPL-2.0-or-later)
- The combined shader is distributed under GPL-2.0-or-later. See [GNU GPL v2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html).

## Image Adjustment — hunterk

- Upstream: [libretro/glsl-shaders — image-adjustment.glsl](https://github.com/libretro/glsl-shaders/blob/master/misc/shaders/image-adjustment.glsl)
- Author: hunterk
- License: Public domain
- No upstream source code was copied verbatim; equivalent user-facing adjustment controls were implemented for this combined shader.

## colorspace-tools.h — Asmodean / SimoneT / torridgristle

- Referenced upstream: [torridgristle/reshade-shaders](https://github.com/torridgristle/reshade-shaders)
- The header is not included or copied into this repository; its colorspace helper code is not required by the standalone GLSL shader.
- License as identified for the referenced header: GPL-2.0-or-later.

## Combined-work license

The integrated shader is offered under GPL-2.0-or-later, consistent with the Bevel component's license. This statement does not change the license of the separate upstream projects or files.
