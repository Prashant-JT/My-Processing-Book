class Office {
  PShape window;
  PShape guy;
  PShape girl;
  PShape desk;
  PShape lamp;
  PShape tv;
  
  Office() {
    guy = loadShape("office-guy.obj");
    guy.scale(3);
    girl = loadShape("mei-posed-001.obj");
    girl.scale(320);
    window = loadShape("window-frame-and-pane.obj");
    window.scale(100);
    desk = loadShape("office-desk.obj");
    desk.scale(300);
    lamp = loadShape("lamp.obj");
    lamp.scale(20);
    tv = loadShape("screen.obj");
    tv.scale(100);
  }
  
  void show() {
    showPerson();
    showWindow();
    showDesk();
    showTV();
    showRoom();
    
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
    // Desk
    pushMatrix();
    translate(650, 80, -750);
    rotateX(PI);
    desk.setFill(color(128, 128, 128));
    shape(desk);
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
  
}
