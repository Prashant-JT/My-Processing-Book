import peasy.*;

Planet sun;
PeasyCam cam;
PImage sunTexture;
PImage space;
PImage[] textures = new PImage[8];
Rocket rocket;

void setup() {
  size(800, 600, P3D);
  sunTexture = loadImage("sun.png");
  space = loadImage("space.jpg");
  textures[0] = loadImage("mars.jpg");
  textures[1] = loadImage("earth.jpg");
  textures[2] = loadImage("mercury.jpg");
  textures[3] = loadImage("neptune.jpg");
  textures[4] = loadImage("pluto.jpg");
  textures[5] = loadImage("uranus.jpg");
  textures[5] = loadImage("saturn.jpg");
  textures[7] = loadImage("jupiter.jpg");
  sun = new Planet(50, 0, 0, sunTexture);
  sun.spawnMoons(6, 1);
  rocket = new Rocket(200, 0);
  cam = new PeasyCam(this, 500);
}

void draw() {
  space.resize(width, height);
  background(space);
  //translate(width/2, height/2);
  lights();
  sun.show();
  sun.orbit();
  rocket.show();
  rocket.orbit();
  //help();
}

void help() {
  fill(255);
  textFont(createFont("Georgia", 14));
  text("Press '+' to add planets", -(width/2)+20, -(height/2)+30);
  text("Press '-' to remove planets", -(width/2)+20, -(height/2)+50);
  text("Move & zoom camera view with mouse", -(width/2)+20, -(height/2)+70);
  text("© Prashant Jeswani Tejwani", -(width/2)+20, -(height/2)+100);
}

/*void keyPressed() {
  if (key == '+') {
    sun.addPlanet();
  } else if (key == '-') {
    sun.removePlanet();
  }
}*/
