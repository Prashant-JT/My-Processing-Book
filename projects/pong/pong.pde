int posx1;
int posy1;
int posx2;
int posy2;
int score1 = 0;
int score2 = 0;
int ballposX;
int ballposY;
int movX = 5;
int movY = -2;
int radius = 10;
int showgoal = 0;

void setup() {
  size(550, 350);
  posx1 = 5;
  posy1 = height/2 - 30;
  posx2 = width-10;
  posy2 = height/2 - 30;
  ballposX = width/2;
  ballposY = height/2 - 20;
  textFont(createFont("Georgia", 20));
  textAlign(CENTER, CENTER);
}

void draw() {
  startGame();
  updateBall();
  checkCollision();
  checkGoal();
  updateScores();
}

void startGame() {
  background(10);
  fill(255);
  line(width/2, 0, width/2, height);
  stroke(126);

  // players bat
  rect(posx1, posy1, 5, 55); // Player 1
  rect(posx2, posy2, 5, 55); // Player 2
}

void updateBall() {
  ellipse(ballposX, ballposY, radius, radius);
  ballposX += movX;
  ballposY += movY;
  
  if (ballposY+radius > height - 30) {
    ballposY = height - 30;
    movY = -movY;
  }
  
  if (ballposY-radius < 0) {
    ballposY = 5;
    movY = -movY;
  }
}

void checkCollision() {
  // Collision with player 1
  // ballposX >= width || ballposX <= 0 || 
  //println(movX);
  //println("ball: " + (ballposX+radius));
  if (movX < 0 && posy1 >= ballposY+radius && ballposY-radius <= posy1+55 && posx1 <= ballposX+radius && posx1-radius >= posx1+5) {
    movX = -movX;
  }
  
  // Collision with player 2
  // ballposX >= width-10 || ballposX <= 5 ||
  if (movX > 0 && posy2 <= ballposY+radius && ballposY-radius <= posy2+55 && posx2 <= ballposX+radius && posx2-radius <= posx2+5) {
    movX = -movX;
  }
}

void checkGoal() {
  if (ballposX >= width) {
    score1++; // Player 1 scores
    showgoal = 100;
  } else if (ballposX <= 0) {
    score2++; // Player 2 scores
    showgoal = 100;
  }

  // Show goal message
  if (showgoal > 0) {
    textFont(createFont("Georgia", 40));
    text("GOOOAAAL !", width/2, height/2 - 30);
    textFont(createFont("Georgia", 20));
    showgoal--;
    ballposX = width/2;
    ballposY = height/2 - 20;
  }
}

void updateScores() {
  rect(0, height-25, width, height-25);
  fill(0);
  text("Scoreboard", width/2, height-16);
  text(str(score1), 20, height-16); // Player 1 score
  text(str(score2), width-20, height-16); // Player 2 score
}

// Detect pressed keys
void keyPressed() {
  // Player 1
  if (keyPressed) {
    if (key == 'z') {
      if (posy1 < height-89) {
        posy1 += 10;
      }
    } else if (key == 'a') {
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
    } else if (keyCode == DOWN) {
      if (posy2 < height-89) {
        posy2 += 10;
      }
    }
  }
}
