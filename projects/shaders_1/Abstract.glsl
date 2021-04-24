#ifdef GL_ES
  precision mediump float;
#endif

uniform vec2 u_resolution; 
uniform float u_time; 
uniform float u_fluid_speed; // Higher number will make it slower.
uniform float u_color_intensity = 0.5;

const int complexity = 50; // More points of color

void main() {
  vec2 p = (2.0 * gl_FragCoord.xy - u_resolution) / max(u_resolution.x, u_resolution.y);

  for (int i = 1; i < complexity; i++) {
    vec2 newp = p + u_time * 0.001;
    // + mouse.y / mouse_factor + mouse_offset
    newp.x += 0.6 / float(i) * sin(float(i) * p.y + u_time / u_fluid_speed + 20.3 * float(i)) + 0.5;
    // - mouse.x / mouse_factor + mouse_offset
    newp.y += 0.6 / float(i) * sin(float(i) * p.x + u_time / u_fluid_speed + 0.3 * float(i + 10)) - 0.5;
    p = newp;
  }

  vec3 color = vec3(u_color_intensity*sin(5.0*p.x) + u_color_intensity, u_color_intensity*sin(3.0*p.y) + 
                    u_color_intensity, u_color_intensity*sin(p.x+p.y) + u_color_intensity);
  gl_FragColor = vec4(color, 1.0);
}
