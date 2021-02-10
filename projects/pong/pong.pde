int posy1;
int posy2;
int score1 = 0;
int score2 = 0;
int ballposX;
int movX = 7;
int ballposY;
int radius = 10;
int showgoal = 0;

void setup() {
  size(800,600);
  posy1 = height/2 - 30;
  posy2 = height/2 - 30;
  ballposX = width/2;
  ballposY = height/2 - 20;
  textFont(createFont("Georgia", 20));
  textAlign(CENTER, CENTER);
}

void draw() {
  startGame();
  updateBall();
  // checkCollision();
  checkGoal();
  updateScores();
}

void startGame() {
  background(10);
  fill(255);
  line(width/2, 0, width/2, height);
  stroke(126);
  
  // players bat
  rect(5,posy1,5,55); // Player 1
  rect(width-10,posy2,5,55); // Player 2
}

void updateBall() {
  ellipse(ballposX,ballposY,radius,radius);
  ballposX += movX;
  if (ballposX+radius >= width-10) {
    //movX = -movX;
  }
  if (ballposX-radius <= 5) {
    //movX = -movX;
  }
}

void checkCollision() {
  
}

void checkGoal() {
  if (ballposX >= 800) {
    score1++; // Player 1 scores
    showgoal = 100;
  }else if (ballposX <= 0) {
    score2++; // Player 2 scores
    showgoal = 100;
  }
  
  // Show goal message
  if (showgoal > 0) {
    textFont(createFont("Georgia", 40));
    text("GOOOAAAL !",width/2, height/2 - 30);
    textFont(createFont("Georgia", 20));
    showgoal--;
    ballposX = width/2;
    ballposY = height/2 - 20;
  }
}

void updateScores() {
  rect(0,height-25,width,height-25);
  fill(0);
  text("Scoreboard",width/2, height-16);
  text(str(score1),width-20, height-16); // Player 1 score
  text(str(score2),20, height-16); // Player 2 score
}

// Detect pressed keys
void keyPressed() {
  // Player 1
  if (keyPressed) {
    if (key == 'z') {
      if (posy1 < height-89) {
        posy1 += 10;
      }
    }else if (key == 'a') {
      if (posy1 > 5) {
        posy1 -= 10;
      }
    }
  }
  
  // Player 2
  if (key == CODED) {
    if (keyCode == UP) {
      if (posy2 > 5) {
        posy2 -= 10;
      }
    }else if (keyCode == DOWN) {
      if (posy2 < height-89) {
        posy2 += 10;
      }
    }
  }
}
