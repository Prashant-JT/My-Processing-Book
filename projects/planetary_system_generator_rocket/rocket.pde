class Rocket {
  float angle;
  PVector vector;
  PShape rocket;

  Rocket() {
    vector = new PVector(0, 0, 400);
    angle = PI/10;

    rocket = loadShape("rocket.obj");
    rocket.scale(50);
  }

  void show() {
    pushMatrix();
    noStroke();
    fill(255);

    translate(vector.x, vector.y, vector.z);
    rotateZ(PI);
    rotateX(-PI/2);
    shape(rocket);

    popMatrix();
  }

  PVector getRocketPosition() {
    return vector;
  }

  void setPosition(boolean forward, boolean back, boolean left, boolean right, boolean up, boolean down) {
    if (forward) {
      vector.z -= 3;
    } else if (back) {
      vector.z += 3;
    } else if (left) {
      vector.x -= 3;
    } else if (right) {
      vector.x += 3;
    } else if (up) {
      vector.y -= 3;
    } else if (down) {
      vector.y += 3;
    }
  }

  void resetPosition() {
    vector = new PVector(0, 0, 400);
  }
}
