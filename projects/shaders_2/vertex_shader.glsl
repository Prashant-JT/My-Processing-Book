uniform mat4 transform;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

uniform float time;

// 2D Random
float random (in vec2 st) {
  return fract(sin(dot(st.xy, 
    vec2(7.98, 60.2)))
    * 4268.541);
}

void main() {
  vec4 newPosition = position + vec4(normal, 1.0) * random(vec2(time)) / 40;
  gl_Position = transform * newPosition;
  vertColor = color;
  vertNormal = normalize(normalMatrix * normal);
  vertLightDir = -lightNormal;
}
