import peasy.*;

PeasyCam cam;
Office office;
Person person;
boolean moveLeft, moveRight, moveForward, moveBack = false;

void setup() {
  size(800, 600, P3D);
  office = new Office();
  person = new Person();

  //cam = new PeasyCam(this, 500);
}

void draw() {
  background(200);

  //translate(width/2, height/2, -500);

  //pushMatrix();
  // Start in the center of the office
  translate(0, 0, -500);


  // Create office scene
  office.show();

  // Update camera
  person.updateAngle();
  person.show();
  person.setPosition(moveForward, moveBack, moveLeft, moveRight);
  camera(person.getPosition().x, person.getPosition().y, person.getPosition().z, 
    person.rotatePerson().x, 0, person.rotatePerson().y, 0, 1, 0);
  
  //popMatrix();
}

void keyReleased() {
  if (key == 'w') moveForward = false;
  if (key == 's') moveBack = false;
  if (key == 'a') moveLeft = false;
  if (key == 'd') moveRight = false;
}

void keyPressed() {
  if (key == 'w') moveForward = true;
  if (key == 's') moveBack = true;
  if (key == 'a') moveLeft = true;
  if (key == 'd') moveRight = true;
}
