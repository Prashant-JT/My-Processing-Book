class Office {
  PShape window;
  PShape guy;
  PShape girl;
  PShape desk1;
  PShape bookshelf;
  PShape lamp;
  PShape tv;
  PShape painting;
  int spotLights;

  Office() {
    guy = loadShape("office-guy.obj");
    guy.scale(3);
    girl = loadShape("mei-posed-001.obj");
    girl.scale(320);
    window = loadShape("window-frame-and-pane.obj");
    window.scale(100);
    desk1 = loadShape("office-desk.obj");
    desk1.scale(300);
    bookshelf = loadShape("bookshelf-antonio-rodriguez.obj");
    bookshelf.scale(500);
    lamp = loadShape("lamp.obj");
    lamp.scale(20);
    tv = loadShape("screen.obj");
    tv.scale(100);
    painting = loadShape("oil-paintings-with-frame.obj");
    painting.scale(30);

    spotLights = 0;
  }

  void show() {
    textureMode(NORMAL);
    showPerson();
    showWindow();
    showDesk();
    showTV();
    showRoom();
    showBookshelf();
    showPainting();
  }

  void showPerson() {
    // Guy
    pushMatrix();
    translate(-400, 300, -1000);
    rotateX(PI-0.25);
    rotateY(PI);
    shape(guy);
    popMatrix();

    // Girl
    pushMatrix();
    translate(400, 300, 1000);
    rotateX(PI);
    shape(girl);
    popMatrix();
  }

  void showWindow() {
    // Window 1
    pushMatrix();
    translate(750, -100, 0);
    rotateY(PI/2);
    shape(window);
    popMatrix();

    // Window 2
    pushMatrix();
    translate(750, -100, 700);
    rotateY(PI/2);
    shape(window);
    popMatrix();
  }

  void showDesk() {
    // Desk
    pushMatrix();
    translate(650, 80, -750);
    rotateX(PI);
    shininess(5.0); 
    desk1.setFill(color(128, 128, 128));
    shape(desk1);
    popMatrix();

    // Lamp
    pushMatrix();
    translate(650, 90, -1000);
    rotateX(PI);
    rotateY(PI);
    shininess(5.0); 
    lamp.setFill(color(192, 192, 192));
    shape(lamp);
    popMatrix();
  }

  void showTV() {
    // Television
    pushMatrix();
    translate(-730, 200, 300);
    rotateY(PI/2);
    rotateZ(PI);
    shininess(5.0); 
    shape(tv);
    popMatrix();
  }

  void showRoom() {
    // Create room
    // Different spot lights
    switch (spotLights) {
    case 1:
      spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
      break;
    case 2:
      spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
      spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
      break;
    case 3:
      spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
      spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
      spotLight(0, 255, 0, -1000, -500, -1000, 1, 1, 1, PI/2, 10);
      break;
    default:
      spotLight(255, 0, 0, 200, -500, 1000, -1, 1, -1, PI/2, 10);
      spotLight(255, 255, 0, -1000, -500, 1000, 1, 1, -1, PI/2, 10);
      spotLight(0, 255, 0, -1000, -500, -1000, 1, 1, 1, PI/2, 10);
      spotLight(0, 0, 255, 1000, -500, -1000, -1, 1, 1, PI/2, 10);
      break;
    }
    
    // Ceilling light
    directionalLight(150, 150, 150, 0, -1, 0);
    lightSpecular(200, 200, 200);
    
    float val = (float) mouseX / ( float ) width*( float ) 180 ;
    ambientLight ( ( int ) val, ( int ) val, ( int ) val ) ;
    box(1500, height, 3000);
  }

  void showBookshelf() {
    // Bookshelf
    pushMatrix();
    translate(-400, 370, 1415);
    rotateX(PI);
    shape(bookshelf);
    popMatrix();
  }

  void showPainting() {
    // Paintings
    pushMatrix();
    translate(300, -20, 1495);
    rotateX(PI);
    shape(painting);
    popMatrix();
  }
  
  // Set number of spot lights
  void setLights() {
    if (spotLights < 4) {
      spotLights++;
    } else {
      spotLights = 0;
    }
  }
}
