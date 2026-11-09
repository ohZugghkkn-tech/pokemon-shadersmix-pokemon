#version 130

/*
 * Pokemon ShaderMix — single-pass pixel-art shader
 *
 * This shader combines a ScaleFX/Scale3x-style edge-aware pixel-art
 * reconstruction, a Bevel-style per-pixel highlight, and Image Adjustment
 * controls for saturation, contrast, luminance, channel balance, and gamma.
 * It is a standalone integration, not a byte-for-byte copy of the upstream
 * multi-pass ScaleFX or Image Adjustment shaders. See ATTRIBUTIONS.md.
 *
 * Copyright (C) 2011-2014 Hyllian/Jararaca (Bevel shader concept)
 * Copyright (C) 2026 ohZugghkkn-tech (integration)
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 2 of the License, or (at your option)
 * any later version.
 */

#pragma parameter edge_threshold "Edge match threshold" 0.08 0.01 0.30 0.01
#pragma parameter bevel_level "Bevel level" 0.18 0.0 0.5 0.01
#pragma parameter saturation "Saturation" 1.0 0.0 2.0 0.05
#pragma parameter contrast "Contrast" 1.0 0.0 2.0 0.05
#pragma parameter luminance "Luminance" 1.0 0.0 2.0 0.05
#pragma parameter target_gamma "Target gamma" 2.2 0.5 4.0 0.1
#pragma parameter red_level "Red channel" 1.0 0.0 2.0 0.05
#pragma parameter green_level "Green channel" 1.0 0.0 2.0 0.05
#pragma parameter blue_level "Blue channel" 1.0 0.0 2.0 0.05

#if __VERSION__ >= 130
#define VARYING_IN in
#define VARYING_OUT out
#define TEX texture
#else
#define VARYING_IN varying
#define VARYING_OUT varying
#define TEX texture2D
#endif

#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#endif

VARYING_IN vec2 vTexCoord;
uniform sampler2D Source;
uniform vec2 TextureSize;
uniform vec2 OutputSize;

#ifdef PARAMETER_UNIFORM
uniform float edge_threshold;
uniform float bevel_level;
uniform float saturation;
uniform float contrast;
uniform float luminance;
uniform float target_gamma;
uniform float red_level;
uniform float green_level;
uniform float blue_level;
#else
#define edge_threshold 0.08
#define bevel_level 0.18
#define saturation 1.0
#define contrast 1.0
#define luminance 1.0
#define target_gamma 2.2
#define red_level 1.0
#define green_level 1.0
#define blue_level 1.0
#endif

#if __VERSION__ >= 130
out vec4 FragColor;
#else
#define FragColor gl_FragColor
#endif

vec4 samplePixel(vec2 p)
{
    vec2 uv = (clamp(p, vec2(0.0), TextureSize - vec2(1.0)) + 0.5) / TextureSize;
    return TEX(Source, uv);
}

bool sameColor(vec3 a, vec3 b)
{
    return distance(a, b) <= edge_threshold;
}

// Scale3x-style 3x3 neighborhood decision, used as a compact single-pass
// edge-aware alternative to the original five-pass ScaleFX pipeline.
vec3 edgeAwarePixel(vec2 cell, vec2 phase)
{
    vec3 A = samplePixel(cell + vec2(-1.0, -1.0)).rgb;
    vec3 B = samplePixel(cell + vec2( 0.0, -1.0)).rgb;
    vec3 C = samplePixel(cell + vec2( 1.0, -1.0)).rgb;
    vec3 D = samplePixel(cell + vec2(-1.0,  0.0)).rgb;
    vec3 E = samplePixel(cell).rgb;
    vec3 F = samplePixel(cell + vec2( 1.0,  0.0)).rgb;
    vec3 G = samplePixel(cell + vec2(-1.0,  1.0)).rgb;
    vec3 H = samplePixel(cell + vec2( 0.0,  1.0)).rgb;
    vec3 I = samplePixel(cell + vec2( 1.0,  1.0)).rgb;

    bool bd = sameColor(B, D);
    bool bf = sameColor(B, F);
    bool dh = sameColor(D, H);
    bool fh = sameColor(F, H);

    // phase maps the output pixel to one of the nine subpixels of a 3x grid.
    if (!sameColor(B, H) && !sameColor(D, F)) {
        if (phase.y < 0.5 && phase.x < 0.5 && bd) return D;
        if (phase.y < 0.5 && phase.x > 1.5 && bf) return F;
        if (phase.y > 1.5 && phase.x < 0.5 && dh) return D;
        if (phase.y > 1.5 && phase.x > 1.5 && fh) return F;

        if (phase.y < 0.5 && phase.x >= 0.5 && phase.x <= 1.5 &&
            ((bd && !sameColor(E, C)) || (bf && !sameColor(E, A)))) return B;
        if (phase.y > 1.5 && phase.x >= 0.5 && phase.x <= 1.5 &&
            ((dh && !sameColor(E, I)) || (fh && !sameColor(E, G)))) return H;
        if (phase.x < 0.5 && phase.y >= 0.5 && phase.y <= 1.5 &&
            ((bd && !sameColor(E, G)) || (dh && !sameColor(E, A)))) return D;
        if (phase.x > 1.5 && phase.y >= 0.5 && phase.y <= 1.5 &&
            ((bf && !sameColor(E, I)) || (fh && !sameColor(E, C)))) return F;
    }
    return E;
}

vec3 adjustColor(vec3 color)
{
    float y = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(y), color, saturation);
    color = (color - 0.5) * contrast + 0.5;
    color *= luminance;
    color = pow(max(color, vec3(0.0)), vec3(2.2 / max(target_gamma, 0.01)));
    return clamp(color * vec3(red_level, green_level, blue_level), 0.0, 1.0);
}

vec3 applyBevel(vec3 color, vec2 localPosition)
{
    // Per-pixel edge highlight inspired by Hyllian's Bevel shader.
    float edgeDistance = min(min(localPosition.x, 1.0 - localPosition.x),
                             min(localPosition.y, 1.0 - localPosition.y));
    float bevel = 1.0 - smoothstep(0.0, 0.5, edgeDistance);
    return clamp(color + mix(vec3(bevel_level), vec3(1.0 - bevel_level), color) * bevel * 0.35,
                 0.0, 1.0);
}

void main()
{
    vec2 sourcePosition = vTexCoord * TextureSize - 0.5;
    vec2 cell = floor(sourcePosition + 0.5);
    vec2 localPosition = fract(sourcePosition + 0.5);
    vec2 scale = max(OutputSize / TextureSize, vec2(1.0));
    vec2 phase = floor(localPosition * scale);
    vec3 color = edgeAwarePixel(cell, phase);
    color = applyBevel(color, localPosition);
    color = adjustColor(color);
    FragColor = vec4(color, TEX(Source, vTexCoord).a);
}
