import peasy.*;

PeasyCam cam;
PShape window;
PShape guy;
PShape sofa;
boolean moveLeft, moveRight, moveForward, moveBack = false;

void setup() {
  size(800, 600, P3D);

  guy = loadShape("office-guy.obj");
  guy.scale(3);
  window = loadShape("window-frame-and-pane.obj");
  window.scale(100);
  /*sofa = loadShape("sofa-test.obj");
  sofa.scale(100);*/

  cam = new PeasyCam(this, 500);
}

void draw() {
  background(200);

  translate(0, 0, -500);

  pushMatrix();
  translate(750, -100, 0);
  rotateY(PI/2);
  shape(window);
  popMatrix();
  
  pushMatrix();
  translate(-400, 300, -1000);
  rotateX(PI-0.25);
  rotateY(PI);
  shape(guy);
  popMatrix();
  
  /*
  pushMatrix();
  translate(0,0, 0);
  //rotateX(PI-0.25);
  //rotateY(PI);
  sofa.setFill(color(random(255)));
  shape(sofa);
  popMatrix();*/

  //camera(0, 0, ((height/2) / tan(PI/6)) + 50, 0, 0, 0, 0, 1, 0);

  pushMatrix();
  noFill();
  box(1500, height, 3000);
  popMatrix();
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
