PShader shader;
PShape heart;
boolean help;

void setup() {
  size(700, 500, P3D);
  noStroke();
  fill(204);
  help = true;
  shader = loadShader("fragment_shader.glsl", "vertex_shader.glsl");
  heart = loadShape("Human-Heart.obj");
  heart.scale(20);
  // Parameter
  shader.set("fraction", 1.0);
}

void draw() {
  if (help) {
    background(0);
    fill(255);
    textSize(26);
    text("Shaders II", width/2 - 60, height/2 - 80);
    textSize(14);
    text("Click for heart beating", width/2 - 80, height/2 - 40);
    text("Press 'h' to show/hide menu", width/2 - 100, height/2 - 20);
    text("© Prashant Jeswani Tejwani", 20, height - 20);
  } else {
    background(0);
    shader.set("time", millis() / 1000.0);

    // Activate shader por defecto
    if (mousePressed) {
      shader(shader);
    } else {
      resetShader();
    }

    float dirY = (mouseY / float(height) - 0.5) * 2;
    float dirX = (mouseX / float(width) - 0.5) * 2;
    directionalLight(204, 204, 204, -dirX, -dirY, -1);
    translate(width/2, height/2);
    rotateX(PI);
    rotateY(PI);
    heart.setFill(color(152, 0, 46));
    shape(heart);
  }
}

void keyPressed() {
  if (key == 'h') help = !help;
}
