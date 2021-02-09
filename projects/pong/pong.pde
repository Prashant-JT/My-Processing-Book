int posy1;
int posy2;
int score1 = 0;
int score2 = 0;
int ballposX;
int movX = 7;
int ballposY;
int radius = 10;

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
  background(10);
  fill(255);
  line(width/2, 0, width/2, height);
  stroke(126);
  
  // players bat
  rect(5,posy1,5,55); // player 1
  rect(width-10,posy2,5,55); // player 2
  
  // ball update
  ellipse(ballposX,ballposY,radius,radius);
  ballposX += movX;
  if (ballposX+radius >= width-10) {
    movX = -movX;
  }
  if (ballposX-radius <= 5) {
    movX = -movX;
  }
    
  // scores
  rect(0,height-25,width,height-25);
  fill(0);
  text("Scoreboard",width/2, height-16);
  text(str(score1),width-20, height-16); // player 1 score
  text(str(score2),20, height-16); // player 2 score
}

// Pressed keys
void keyPressed() {
  // player 1
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
  
  // player 2
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
