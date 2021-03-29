class Bird {
  float xPos, yPos, ySpeed;
  
  Bird() {
    xPos = 250;
    yPos = 400;
  }
  
  void drawBird() {
    stroke(255);
    noFill();
    strokeWeight(2);
    ellipse(xPos, yPos, 20, 20);
  }
  
  void jump() {
    ySpeed = -10;
  }
  
  void drag() {
    ySpeed += 0.4;
  }
  
  void move() {
    yPos += ySpeed; 
    for (int i = 0; i < 3; i++) {
      pillars[i].xPos -= 3;
    }
  }
  
  void checkCollisions() {
    if (yPos > 800) end = false;
    for (int i = 0; i < 3; i++) {
      if ((xPos < pillars[i].xPos + 10 && xPos > pillars[i].xPos - 10) && 
          (yPos < pillars[i].opening - 100||yPos > pillars[i].opening + 100)) {
        end = false;
      }
    }
  }
  
}
