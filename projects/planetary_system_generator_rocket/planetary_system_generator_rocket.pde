Planet sun;
PImage sunTexture;
PImage space;
PImage[] textures = new PImage[8];
Rocket rocket;
boolean rocketCam;
boolean moveLeft, moveRight, moveForward, moveDown, moveUp, moveBack = false;
boolean help;

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
  rocket = new Rocket();
  rocketCam = false;
  help = false;
}

void draw() {
  space.resize(width, height);
  background(space);
  translate(width/2, height/2);
  lights();
  
  // Check if user is in the rocket or not
  if (rocketCam) {
    camera(rocket.getRocketPosition().x, rocket.getRocketPosition().y, rocket.getRocketPosition().z, 
      0, 0, -width, 0, 1, 0);
    
  } else {
    camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0);
  }
  
  // Show planetary and position rocket
  sun.show();
  sun.orbit();
  rocket.show();
  rocket.setPosition(moveForward, moveBack, moveLeft, moveRight, moveUp, moveDown);
  
  // Show or hide controls
  if (help) {
    pushMatrix();
    camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0); 
    help();
    popMatrix();
  }else{
    camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0); 
    textFont(createFont("Georgia", 14));
    text("Press 'h' to show controls", -(width/2)+20, -(height/2)+30);
    text("© Prashant Jeswani Tejwani", -(width/2)+20, -(height/2)+70);
  }
}

// User controls
void help() {
  fill(255);
  //textFont(createFont("Georgia", 14));
  text("Press 'h' to hide controls", -(width/2)+20, -(height/2)+30);
  if (rocketCam) {
    text("Press 'e' to exit rocket", -(width/2)+20, -(height/2)+50);
  } else {
    text("Press 'c' to enter rocket", -(width/2)+20, -(height/2)+50);
  }
  text("Press 'w' to move forward", -(width/2)+20, -(height/2)+70);
  text("Press 's' to move backward", -(width/2)+20, -(height/2)+90);
  text("Press 'a' to move left", -(width/2)+20, -(height/2)+110);
  text("Press 'd' to move right", -(width/2)+20, -(height/2)+130);
  text("Press 'q' to move up", -(width/2)+20, -(height/2)+150);
  text("Press 'x' to move down", -(width/2)+20, -(height/2)+170);
  text("Press 'r' to reset position", -(width/2)+20, -(height/2)+190);
  text("© Prashant Jeswani Tejwani", -(width/2)+20, -(height/2)+220);
}


void keyReleased() {
  if (key == 'w') moveForward = false;
  if (key == 's') moveBack = false;
  if (key == 'x') moveDown = false;
  if (key == 'q') moveUp = false;
  if (key == 'a') moveLeft = false;
  if (key == 'd') moveRight = false;
}

void keyPressed() {
  // Step out from rocket
  if (key == 'c') {
    rocketCam = true;
  } 
  
  // Enter rocket
  if (key == 'e') {
    rocketCam = false;
  }
  
  // Reset rocket position
  if (key == 'r') {
    rocket.resetPosition();
    rocketCam = false;
  }
  
  // Show or hide controls
  if (key == 'h') {
    if (help) {
      help = false;
    }else{
      help = true;
    }
  }
  
  // Rocket movement
  if (key == 'w') moveForward = true;
  if (key == 's') moveBack = true;
  if (key == 'x') moveDown = true;
  if (key == 'q') moveUp = true;
  if (key == 'a') moveLeft = true;
  if (key == 'd') moveRight = true;
}
