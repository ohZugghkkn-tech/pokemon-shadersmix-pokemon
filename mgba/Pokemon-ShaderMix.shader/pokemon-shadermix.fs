// Pokemon ShaderMix — mGBA GLSL fragment shader
// Single-pass pixel-art edge reconstruction with bevel and image adjustments.
// This is an independent compact Scale3x-style implementation, not the original
// multi-pass ScaleFX shader. See repository ATTRIBUTIONS.md for credits/licensing.

uniform sampler2D tex;
uniform vec2 texSize;
varying vec2 texCoord;

uniform float edge_threshold;
uniform float bevel_level;
uniform float saturation;
uniform float contrast;
uniform float luminance;
uniform float target_gamma;
uniform float red_level;
uniform float green_level;
uniform float blue_level;

vec4 pixelAt(vec2 offset)
{
    vec2 uv = texCoord + offset / texSize;
    return texture2D(tex, clamp(uv, vec2(0.0), vec2(1.0)));
}

bool sameColor(vec3 a, vec3 b)
{
    return distance(a, b) <= edge_threshold;
}

vec3 scale3xPixel(vec2 phase)
{
    // Neighborhood:
    // A B C
    // D E F
    // G H I
    vec3 A = pixelAt(vec2(-1.0, -1.0)).rgb;
    vec3 B = pixelAt(vec2( 0.0, -1.0)).rgb;
    vec3 C = pixelAt(vec2( 1.0, -1.0)).rgb;
    vec3 D = pixelAt(vec2(-1.0,  0.0)).rgb;
    vec3 E = pixelAt(vec2( 0.0,  0.0)).rgb;
    vec3 F = pixelAt(vec2( 1.0,  0.0)).rgb;
    vec3 G = pixelAt(vec2(-1.0,  1.0)).rgb;
    vec3 H = pixelAt(vec2( 0.0,  1.0)).rgb;
    vec3 I = pixelAt(vec2( 1.0,  1.0)).rgb;

    bool bd = sameColor(B, D);
    bool bf = sameColor(B, F);
    bool dh = sameColor(D, H);
    bool fh = sameColor(F, H);

    // Scale3x corner rules sampled over a 3x3 subpixel phase.
    if (!sameColor(B, H) && !sameColor(D, F)) {
        if (phase.x < 0.5 && phase.y < 0.5 && bd) return D;
        if (phase.x > 1.5 && phase.y < 0.5 && bf) return F;
        if (phase.x < 0.5 && phase.y > 1.5 && dh) return D;
        if (phase.x > 1.5 && phase.y > 1.5 && fh) return F;

        if (phase.x >= 0.5 && phase.x <= 1.5 && phase.y < 0.5 &&
            ((bd && !sameColor(E, C)) || (bf && !sameColor(E, A)))) return B;
        if (phase.x >= 0.5 && phase.x <= 1.5 && phase.y > 1.5 &&
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
    float edgeDistance = min(min(localPosition.x, 1.0 - localPosition.x),
                             min(localPosition.y, 1.0 - localPosition.y));
    float edge = 1.0 - smoothstep(0.0, 0.5, edgeDistance);
    vec3 highlight = mix(vec3(bevel_level), vec3(1.0 - bevel_level), color);
    return clamp(color + highlight * edge * 0.35, 0.0, 1.0);
}

void main()
{
    vec2 pixelPosition = texCoord * texSize;
    vec2 localPosition = fract(pixelPosition);
    vec2 phase = floor(localPosition * 3.0);

    vec4 original = texture2D(tex, texCoord);
    vec3 color = scale3xPixel(phase);
    color = applyBevel(color, localPosition);
    color = adjustColor(color);
    gl_FragColor = vec4(color, original.a);
}
