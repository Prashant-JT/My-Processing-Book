import peasy.*;

PeasyCam cam;
Office office;
boolean moveLeft, moveRight, moveForward, moveBack = false;

void setup() {
  size(800, 600, P3D);
  office = new Office();
  
  cam = new PeasyCam(this, 500);
}

void draw() {
  background(200);
  // Start in the center of the office
  translate(0, 0, -500);
  // Create office scene
  office.show();
}

/*
void keyReleased() {
 if (key == 'w') moveForward = false;
 if (key == 's') moveBack = false;
 if (key == 'a') moveLeft = false;
 if (key == 'd') moveRight = false;
 }
 
 void keyPressed() {
 if (key == 'r') 
 camera(0, 0, (height/2) / tan(PI/6), 0, 0, 0, 0, 1, 0);
 
 if (key == 'w') moveForward = true;
 if (key == 's') moveBack = true;
 if (key == 'a') moveLeft = true;
 if (key == 'd') moveRight = true;
 }
 */
