class Paddle {
  
  private float posx1;
  private float posy1;
  private float posx2;
  private float posy2;
  private float minDistance;
  private float maxDistance;
  private float posRemapped;
  
  public Paddle() {
    this.posx1 = 5;
    this.posy1 = height/2 - 30;
    this.posx2 = width-15;
    this.posy2 = height/2 - 30;
    this.minDistance = 7.0;
    this.maxDistance = 30.0;
  }
  
  public float getPosx1() {
    return this.posx1;
  }
  
  public float getPosy1() {
    return this.posy1;
  }
  
  public float getPosx2() {
    return this.posx2;
  }
  
  public float getPosy2() {
    return this.posy2;
  }
  
  // Move players
  void move(float distance) {
    if (z) { // Player 1 down
      if (this.posy1 < height-89) {
        this.posy1 += 10;
      }
    }
    
    if (a) { 
      if (this.posy1 > 5) { // Player 1 up
        this.posy1 -= 10;
      }
    }
    
    if (distance == -1) return;    
    if (distance > maxDistance) distance = maxDistance;
    if (distance < minDistance) distance = minDistance;
    
    // Map player 2 position 
    posRemapped = map(distance, minDistance, maxDistance, 0, height-89);
    this.posy2 = posRemapped;
  }
}
