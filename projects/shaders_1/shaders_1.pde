PShader shader;
float speed;
float color_intensity;
boolean help;

void setup() {
  size(800, 600, P2D);
  speed = 1.0;
  color_intensity = 0.5;
  help = true;
  textAlign(CENTER, CENTER);
  shader = loadShader("Abstract.glsl");
}

void draw() {
  if (help) {
    background(0);
    fill(255);
    textSize(26);
    text("Shaders I", width/2, height/2 - 100);
    textSize(14);
    text("Press 'c' to change color intensity", width/2, height/2 - 60);
    text("Press 's' to slow down movement", width/2, height/2 - 40);
    text("Click to show/hide menu", width/2, height/2 - 20);
    text("Default values", width/2, height/2 + 20);
    text("Speed (Range: 1.0 to Inf): " + speed, width/2, height/2 + 40);
    text("Color intensity (Range: 0.0 to 1.0): " + color_intensity, width/2, height/2 + 60);
    text("© Prashant Jeswani Tejwani", 100, height - 20);
  } else {
    noStroke();
    shader.set("u_resolution", float(width), float(height));
    shader.set("u_time", millis() / 1000.0);
    shader.set("u_fluid_speed", speed);
    shader.set("u_color_intensity", color_intensity);
    shader(shader);
    rect(0, 0, width, height);
  }
}

void mousePressed() {
  help = !help;
}

void keyPressed() {
  if (key == 's') speed++;
  if (key == 'c') {
    if (color_intensity <= 1.0) { 
      color_intensity += 0.1;
    } else {
      color_intensity = 0.1;
    }
  }
}
