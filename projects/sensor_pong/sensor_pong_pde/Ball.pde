class Ball {
  
  private float ballposX;
  private float ballposY;
  private float angle;
  private final int diameter = 10;

  public Ball() {
    this.resetPos();
  }
  
  public float getBallPosX() {
    return this.ballposX;
  }
  
  public float getBallPosY() {
    return this.ballposY;
  }
  
  public float getAngle() {
    return this.angle;
  }
  
  public void resetPos() {
    this.ballposX = width/2;
    this.ballposY = height/2 - 20;
    this.angle = random(-PI/4, PI/4);
  }
  
  void updateBall() {
    ellipse(this.ballposX, this.ballposY, this.diameter, this.diameter);
    this.ballposX += movX;
    this.ballposY += movY;
    
    // Lower and upper wall
    if (this.ballposY+(this.diameter/2) >= height - 25 || this.ballposY-(this.diameter/2) <= 0) {
      movY = -movY;
      thread("tock");
    }
  }
    
  void checkGoal() {
    if (this.ballposX >= width) {
      score1++; // Player 1 scores
      showgoal = 100;
      thread("goal");
    } else if (this.ballposX <= 0) {
      score2++; // Player 2 scores
      showgoal = 100;
      thread("goal");
    }
    
    // Show goal message
    if (showgoal > 0) {
      message.goal();
      showgoal--;
      reset();
    }
  }
}
