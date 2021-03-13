class Rocket {
  float angle;
  float distance;
  float orbitSpeed;
  PVector vector;
  PShape rocket;
  
  Rocket(float d, float o) {
    vector = PVector.random3D();
    distance = d;
    vector.mult(distance);
    angle = random(TWO_PI);
    orbitSpeed = o;
    
    rocket = loadShape("rocket.obj");
    rocket.scale(50);
  }
  
  void orbit() {
    angle = angle + orbitSpeed;
  }
  
  void show() {
    pushMatrix();
    noStroke();
    fill(255);
    
    // Create perpendicular vector to orbit and rotate rocket 
    PVector v = new PVector(1, 0, 1);
    PVector p = vector.cross(v);
    rotate(angle, p.x, p.y, p.z);
    
    translate(vector.x, vector.y, vector.z);
    shape(rocket);
    
    popMatrix();
  }
  
  
}
