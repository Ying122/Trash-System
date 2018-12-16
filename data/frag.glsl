uniform float weight;
uniform float alphaScale;
uniform vec2 resolution;
uniform bool circle;

varying vec2 center;
varying vec2 normal;
varying vec4 vertColor;

void main() {
    vec2 v = gl_FragCoord.xy - center;
    float alpha = 1.0 - abs(2.0 * dot(normalize(normal), v) / weight);
    if (circle){
        vec2 d = gl_FragCoord.xy - vec2(resolution.x/2.,resolution.y/2.);
        if (length(d)>300)
            discard;
    }
    gl_FragColor = vec4(vertColor.rgb, alpha*alphaScale);
}
