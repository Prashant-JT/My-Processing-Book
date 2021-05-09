import processing.sound.*;
import processing.serial.*;

boolean start = false;
boolean a, z;
int score1, score2, showgoal;
float movX, movY;

Serial arduino;
String value = "0";

SoundFile goal;
SoundFile tock;
SoundFile whistle;

Message message;
Ball ball;
Paddle paddle;

void setup() {
  size(800, 500);

  message = new Message();
  ball = new Ball();
  paddle = new Paddle();    

  goal = new SoundFile(this, "data/goal.mp3");
  tock = new SoundFile(this, "data/tock.mp3");
  whistle = new SoundFile(this, "data/whistle.mp3");

  // Arduino port
  String portName = Serial.list()[0];
  arduino = new Serial(this, portName, 9600);

  reset();
}

void draw() {
  if (start) {
    message.startGame();
    ball.updateBall();
    paddle.move(getSensorDistance());
    checkCollision();
    ball.checkGoal();
    message.updateScores();
  } else {
    message.help();
  }
}

void reset() {
  // Reset positions variables 
  ball.resetPos();  
  movX = 3;
  movY = 5 * sin(ball.getAngle());  

  // Left or right
  if (random(1) < 0.5) {
    movX = -movX;
  }
}

void restartScores() {
  score1 = 0;
  score2 = 0;
  reset();
}

void checkCollision() {
  // Collision with player 1
  if (movX < 0 && ball.getBallPosX()-10 <= paddle.getPosx1()+10 && ball.getBallPosY() >= paddle.getPosy1() && ball.getBallPosY() <= paddle.getPosy1()+55) {
    movX--; // Speed up ball velocity
    movX = -movX;
    thread("tock");
  }

  // Collision with player 2
  if (movX > 0 && ball.getBallPosX()+10 >= paddle.getPosx2() && ball.getBallPosY() >= paddle.getPosy2() && ball.getBallPosY() <= paddle.getPosy2()+55) {
    movX++; // Speed up ball velocity
    movX = -movX;
    thread("tock");
  }
}

float getSensorDistance() {
  if (arduino.available() > 0) {
    value = arduino.readStringUntil('\n');
  }

  return (value != null) ? float(value) : -1;
}

// Detect key released
void keyReleased() {
  if (key == 'z' || key == 'Z') z = false;
  if (key == 'a' || key == 'A') a = false;
}

// Detect pressed keys
void keyPressed() {
  if (keyPressed) {       
    if (key == 'z' || key == 'Z') z = true;
    if (key == 'a' || key == 'A') a = true;
    if (key == 'r' || key == 'R') restartScores();
    if (key == 'h' || key == 'H') {
      thread("whistle");
      start = !start;
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
