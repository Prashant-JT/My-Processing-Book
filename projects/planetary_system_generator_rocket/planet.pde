class Planet {
  float radius;
  float angle;
  float distance;
  ArrayList<Planet> planets;
  float orbitSpeed;
  PVector vector;
  PShape globe;

  Planet(float r, float d, float o, PImage img) {
    planets = new ArrayList<Planet>();
    vector = PVector.random3D();
    radius = r;
    distance = d;
    vector.mult(distance);
    angle = random(TWO_PI);
    orbitSpeed = o;
    
    noStroke();
    noFill();
    globe = createShape(SPHERE, radius);
    globe.setTexture(img);
  }

  void orbit() {
    angle = angle + orbitSpeed;
    if (planets != null) {
      for (int i = 0; i < planets.size(); i++) {
        planets.get(i).orbit();
      }
    }
  }

  void spawnMoons(int total, int level) {   
    for (int i = 0; i < total; i++) {
      float r = radius/(level*2); // planet radius
      float d = random((radius+r), (radius+r)*4); // distance to sun
      float o = random(-0.02, 0.02); // velocity
      int index = int(random(0, textures.length)); // random texture
      planets.add(new Planet (r, d, o, textures[index]));
      if (level < 3) { // number of moons
        int num = int(random(0, 3));
        planets.get(i).spawnMoons(num, level+1);
      }
    }
  }
  
  /*
  void addPlanet() {
    this.spawnMoons(1,1);
  }
  
  void removePlanet() {
    if(planets.size() > 0)
      planets.remove(planets.get(planets.size()-1));
  }*/

  void show() {
    pushMatrix();
    noStroke();
    fill(255);
    
    // Create perpendicular vector to orbit and rotate planets 
    PVector v = new PVector(1, 0, 1);
    PVector p = vector.cross(v);
    rotate(angle, p.x, p.y, p.z);
    
    translate(vector.x, vector.y, vector.z);
    shape(globe);
    
    // Draw moons of planets
    if (planets != null) {
      for (int i = 0; i < planets.size(); i++) {
        planets.get(i).show();
      }
    }
    popMatrix();
  }
}
