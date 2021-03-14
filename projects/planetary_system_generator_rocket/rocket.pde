class Rocket {
  float angle;
  float distance;
  float orbitSpeed;
  PVector vector;
  PShape rocket;
  
  Rocket(float d, float o) {
    vector = new PVector(0,0,1);
    //vector = PVector.random3D();
    distance = d;
    vector.mult(distance);
    angle = PI/10;
    //angle = random(TWO_PI);
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
    
    //rotate(angle, p.x, p.y, p.z);
    rotateZ(PI);
    rotateX(-PI/2);
    
    translate(vector.x, vector.y, vector.z);
    shape(rocket);
    
    popMatrix();
  }
  
  PVector getRocketPosition() {
    return vector;
  }
  
}
