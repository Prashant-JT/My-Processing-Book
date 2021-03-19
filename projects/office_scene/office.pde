class Office {
  PShape window;
  PShape guy;
  PShape girl;
  PShape desk1;
  PShape bookshelf;
  PShape lamp;
  PShape tv;
  PShape painting;
  
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
    //oil-paintings-with-frame
    painting = loadShape("oil-paintings-with-frame.obj");
    painting.scale(30);
  }
  
  void show() {
    showPerson();
    showWindow();
    showDesk();
    showTV();
    showRoom();
    showBookshelf();
    showPainting();
    
    //camera(0, 0, ((height/2) / tan(PI/6)) + 50, 0, 0, 0, 0, 1, 0);
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
    //rotateY(PI);
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
    // Desk 1
    pushMatrix();
    translate(650, 80, -750);
    rotateX(PI);
    desk1.setFill(color(128, 128, 128));
    shape(desk1);
    popMatrix();
  
    // Lamp
    pushMatrix();
    translate(650, 90, -1000);
    rotateX(PI);
    rotateY(PI);
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
    shape(tv);
    popMatrix();
  }
  
  void showRoom() {
    // Create room
    pushMatrix();
    noFill();
    box(1500, height, 3000);
    popMatrix();
  }
  
  void showBookshelf(){
    // Bookshelf
    pushMatrix();
    translate(-400, 370, 1415);
    rotateX(PI);
    shape(bookshelf);
    popMatrix();
  }
  
  void showPainting() {
    // Painting
    pushMatrix();
    translate(300, -20, 1495);
    rotateX(PI);
    shape(painting);
    popMatrix();
  }
  
}
