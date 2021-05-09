class Message { 
  
  public Message () {
    textFont(createFont("Georgia", 20));
    textAlign(CENTER, CENTER);
  }
  
  void startGame () {
    background(10);
    fill(255);
    line(width/2, 0, width/2, height);
    stroke(126);
    
    // Players bat
    rect(paddle.getPosx1(), paddle.getPosy1(), 10, 55); // Player 1
    rect(paddle.getPosx2(), paddle.getPosy2(), 10, 55); // Player 2
  }  
  
  void help () {
    textFont(createFont("Georgia", 40));
    fill(255);
    background(0);
    text("Distance sensor pong", width/2, height/2 - 100);
    textFont(createFont("Georgia", 16));
    text("CONTROLS FOR PLAYERS", width/2, height/2);
    noFill();
    stroke(255);
    rect(width/2 - 265, height/2 + 35, 530, 130);
    fill(255);
    text("Player 1 - A to move up | Z to move down", width/2, height/2 + 55);
    text("Player 2 - Move hand away to move up | Bring hand near to move down", width/2, height/2 + 85);
    text("To restart scores, press r", width/2, height/2 + 115);
    text("To play/pause, press h", width/2, height/2 + 140);
  }
  
  void updateScores() {
    rect(0, height-25, width, height-25);
    fill(0);
    text("Scoreboard", width/2, height-16);
    text(str(score1), 20, height-16); // Player 1 score
    text(str(score2), width-20, height-16); // Player 2 score
  }
  
  void goal() {
    textFont(createFont("Georgia", 40));
    text("GOOOAAAL !", width/2, height/2 - 30);
    textFont(createFont("Georgia", 20));  
  }
}
