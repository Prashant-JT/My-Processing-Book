import processing.sound.*;

boolean start = false;
int posx1;
int posy1;
int posx2;
int posy2;
int score1 = 0;
int score2 = 0;
float ballposX;
float ballposY;
float angle;
float movX;
float movY;
int diameter = 10;
int showgoal = 0;
SoundFile goal;
SoundFile tock;
SoundFile whistle;

void setup() {
  size(800, 500);
  posx1 = 5;
  posy1 = height/2 - 30;
  posx2 = width-15;
  posy2 = height/2 - 30;
  reset();
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
    background(0);
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
  rect(posx1, posy1, 10, 55); // Player 1
  rect(posx2, posy2, 10, 55); // Player 2
}

void updateBall() {
  ellipse(ballposX, ballposY, diameter, diameter);
  ballposX += movX;
  ballposY += movY;
  
  // Lower and upper wall
  if (ballposY+(diameter/2) >= height - 25 || ballposY-(diameter/2) <= 0) {
    movY = -movY;
    thread("tock");
  }
}

void checkCollision() {
  // Collision with player 1
  if (movX < 0 && ballposX-10 <= posx1+10 && ballposY >= posy1 && ballposY <= posy1+55) {
    movX = -movX; 
    thread("tock");
  }
  
  // Collision with player 2
  if (movX > 0 && ballposX+10 >= posx2 && ballposY >= posy2 && ballposY <= posy2+55) {
    movX = -movX;
    thread("tock");
  }
}

void checkGoal() {
  if (ballposX >= width) {
    score1++; // Player 1 scores
    showgoal = 100;
    thread("goal");
  } else if (ballposX <= 0) {
    score2++; // Player 2 scores
    showgoal = 100;
    thread("goal");
  }

  // Show goal message
  if (showgoal > 0) {
    textFont(createFont("Georgia", 40));
    text("GOOOAAAL !", width/2, height/2 - 30);
    textFont(createFont("Georgia", 20));
    showgoal--;
    reset();
  }
}

void reset() {
  // Reset positions variables
  ballposX = width/2;
  ballposY = height/2 - 20;
  angle = random(-PI/4, PI/4);
  movX = 5 * cos(angle);
  movY = 5 * sin(angle);
  
  // Left or right
  if (random(1) < 0.5) {
    movX = -movX;
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
    // Resume game
    thread("whistle");
    start = false;
  }else{
    // Pause game
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
