class Person {
  PVector vector;
  float angle;

  Person() {
    vector = new PVector(0, 0, 0);
    angle = 0;
  }

  void show() {
    pushMatrix();
    translate(vector.x, vector.y, vector.z);
    popMatrix();
  }

  PVector getPosition() {
    return vector;
  }

  // Revisear
  void setPosition(boolean forward, boolean back, boolean left, boolean right) {
    if (forward) {
      //vector.z += 10*s;
      vector.z -= cos(radians(angle))*10;
      vector.x += sin(radians(angle))*10;
    } else if (back) {
      //vector.z += 10*s;
      vector.z += cos(radians(angle))*10;
      vector.x -= sin(radians(angle))*10;
    } else if (left) {
      angle -= 1;
    } else if (right) {
      angle += 1;
    }
  }

  PVector rotatePerson() {
    PVector p = new PVector(sin(radians(angle))*(width*1000), 
                            cos(radians(angle))*(-width*1000));
    return p;
  }
  
  void updateAngle() {
    if (angle > 360) angle = 0;
  }


  void resetPosition() {
    vector = new PVector(0, 0, 0);
  }
}
