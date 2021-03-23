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
  
  // Actual position
  PVector getPosition() {
    return vector;
  }
  
  // Update positions
  void setPosition(boolean forward, boolean back, boolean left, boolean right) {
    if (forward) {
      vector.z -= cos(radians(angle))*20;
      vector.x += sin(radians(angle))*20;
    } else if (back) {
      vector.z += cos(radians(angle))*20;
      vector.x -= sin(radians(angle))*20;
    } else if (left) {
      angle -= 2;
    } else if (right) {
      angle += 2;
    }
  }
  
  // Rotation
  PVector rotatePerson() {
    PVector p = new PVector(sin(radians(angle))*(width*1000), 
                            cos(radians(angle))*(-width*1000));
    return p;
  }
  
  // Update angle
  void updateAngle() {
    if (angle > 360) angle = 0;
  }
  
  // Reset position
  void resetPosition() {
    vector = new PVector(0, 0, 0);
  }
  
}
