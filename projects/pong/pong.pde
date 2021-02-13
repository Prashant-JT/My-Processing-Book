import processing.sound.*;

boolean start = false;
int posx1;
int posy1;
int posx2;
int posy2;
int score1 = 0;
int score2 = 0;
int ballposX;
int ballposY;
int movX = 3;
int movY = -2;
int radius = 10;
int showgoal = 0;
SoundFile goal;
SoundFile tock;
SoundFile whistle;

void setup() {
  size(800, 600);
  posx1 = 5;
  posy1 = height/2 - 30;
  posx2 = width-10;
  posy2 = height/2 - 30;
  ballposX = width/2;
  ballposY = height/2 - 20;
  textFont(createFont("Georgia", 20));
  textAlign(CENTER, CENTER);
  goal = new SoundFile(this, "data/goal.mp3");
  tock = new SoundFile(this, "data/tock.mp3");
  whistle = new SoundFile(this, "data/whistle.mp3");
}

void draw() {
  if (start) {
    startGame();
    updateBall();
    checkCollision();
    checkGoal();
    updateScores();
  }else{
    textFont(createFont("Georgia", 40));
    fill(255);
    text("Click to start or pause game", width/2, height/2 - 30);
    textFont(createFont("Georgia", 20));
  }
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
  
  // Lower and upper wall
  if (ballposY+5 >= height - 25 || ballposY-5 <= 0) {
    movY = -movY;
    thread("tock");
  }
}

void checkCollision() {
  // Collision with player 1
  if (movX < 0 && ballposX-5 <= posx1+5 && ballposY >= posy1 && ballposY <= posy1+55) {
    movX = -movX;
    thread("tock");
  }
  
  // Collision with player 2
  if (movX > 0 && ballposX+5 >= posx2 && ballposY >= posy2 && ballposY <= posy2+55) {
    movX = -movX;
    thread("tock");
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
    thread("goal");
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

void mouseClicked() {
  if (start) {
    thread("whistle");
    start = false;
  }else{
    thread("whistle");
    start = true;
  }
}

// Detect pressed keys
void keyPressed() {
  if (keyPressed) {
    if (key == 'z') { // Player 1
      if (posy1 < height-89) {
        posy1 += 10;
      }
    } else if (key == 'a') { 
      if (posy1 > 5) {
        posy1 -= 10;
      }
    } else if (key == 'k') { // Player 2
      if (posy2 > 5) {
        posy2 -= 10;
      }
    } else if (key == 'm') {
      if (posy2 < height-89) {
        posy2 += 10;
      }
    }
  }
  
}

void whistle() {
  whistle.play();
}

void goal() {
  goal.play();
}

void tock() {
  tock.play();
}
