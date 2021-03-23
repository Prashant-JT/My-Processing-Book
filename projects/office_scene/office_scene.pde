Office office;
Person person;
boolean moveLeft, moveRight, moveForward, moveBack = false;
boolean help;

void setup() {
  size(800, 600, P3D);
  office = new Office();
  person = new Person();
  help = true;
}

void draw() {
  // Show or hide controls
  if (help) {
    pushMatrix();
    translate(width/2, height/2, 0);
    camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0); 
    help();
    popMatrix();
  } else {
    // Create office scene
    office.show();

    // Update camera
    person.updateAngle();
    person.show();
    person.setPosition(moveForward, moveBack, moveLeft, moveRight);
    camera(person.getPosition().x, person.getPosition().y, person.getPosition().z, 
      person.rotatePerson().x, 0, person.rotatePerson().y, 0, 1, 0);
  }
}

// User controls
void help() {
  fill(255);
  background(0);
  textAlign(CENTER);
  textFont(createFont("Georgia", 18));
  text("Press 'h' to show/hide controls", 0, -120);
  text("Press 'w' to move forward", 0, -90);
  text("Press 's' to move backward", 0, -60);
  text("Press 'a' to rotate left", 0, -30);
  text("Press 'd' to rotate right", 0, 0);
  text("Left click to on/off lights", 0, 30);
  text("Press 'r' to reset position", 0, 60);
  text("© Prashant Jeswani Tejwani", 0, 150);
  textFont(createFont("Georgia", 12));
  text("Note: Rendering time when hiding controls for the first time is high, it may take a few seconds", 0, 250);
}

void keyReleased() {
  if (!help) { 
    if (key == 'w') moveForward = false;
    if (key == 's') moveBack = false;
    if (key == 'a') moveLeft = false;
    if (key == 'd') moveRight = false;
  }
}

void keyPressed() {
  if (key == 'h') {
    if (help) {
      help = false;
    } else {
      help = true;
    }
  }

  if (!help) { 
    if (key == 'w') moveForward = true;
    if (key == 's') moveBack = true;
    if (key == 'a') moveLeft = true;
    if (key == 'd') moveRight = true;
    if (key == 'r') person.resetPosition();
  }
}

void mouseClicked() {
  office.setLights();
}
