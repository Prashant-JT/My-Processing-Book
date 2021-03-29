class Pillar {
  float xPos, opening;
  boolean crashed = false;
  
  Pillar(int i) {
    xPos = 100 + (i * 200);
    opening = random(200) + 100;
  }
  
  void drawPillar() {
    line(xPos, 0, xPos, opening - 100);  
    line(xPos, opening + 100, xPos, 800);
  }
  
  void checkPosition() {
    if (xPos < 0) {
      xPos += (200 * 3);
      opening = random(200) + 100;
      crashed = false;
    }
    
    if (xPos < 250 && !crashed) {
      crashed = true;
      score++;
    }
  }
  
}
