class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float w;
  float[] colorP;

  Particle() {
    pos = PVector.random2D().mult(250);
    vel = new PVector(0, 0);
    acc = pos.copy().mult(random(0.0001, 0.00001));
    w = random(3, 5);
    colorP = new float[3];
    for (int i = 0; i < colorP.length; i++) {
      colorP[i] = random(200, 255);
    }
  }

  void update(boolean cond) {
    vel.add(acc);
    pos.add(vel);
    // Accelerate particle
    if (cond) {
      pos.add(vel);
      pos.add(vel);
      pos.add(vel);
    }
  }

  boolean edges() {
    if (pos.x < -width / 2 || pos.x > width / 2 || pos.y < -height / 2 || pos.y > height / 2) {
      return true;
    } else {
      return false;
    }
  }

  void show() {
    noStroke();
    fill(colorP[0], colorP[1], colorP[2]);
    ellipse(pos.x, pos.y, w, w);
  }
}
