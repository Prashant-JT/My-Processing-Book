import oscP5.*;

Bird bird = new Bird();
Pillar[] pillars = new Pillar[3];
boolean end = false;
boolean intro = true;
int score = 0;
int found;
float mouthHeight;
boolean openMouth;

OscP5 oscP5; 

void setup() {
  size(500, 600);
  for (int i = 0; i < 3; i++) {
    pillars[i] = new Pillar(i);
  }

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  
  openMouth = false;
}

void draw() {
  background(0);

  if (found > 0) {    
    if (mouthHeight > 3 && !openMouth) {
      if (end) {
        bird.jump();
        openMouth = true;
        intro = false;
        if (!end) {
          reset();
        }
      }
    }
  }

  if (end) bird.move();
  bird.drawBird();
  if (end) bird.drag();
  bird.checkCollisions();

  for (int i = 0; i < 3; i++) {
    pillars[i].drawPillar();
    pillars[i].checkPosition();
  }

  fill(0);
  stroke(255);
  textSize(32);

  if (end) {
    rect(20, 20, 100, 50);
    fill(255);
    text(score, 30, 58);
  } else {
    help();
  }
}

void help() {
  rect(110, 105, 300, 50);
  rect(160, 200, 200, 90);
  fill(255);

  if (intro) {
    text("Face Flappy bird", 140, 140);
    text("Click to Play", 175, 240);
    textFont(createFont("Georgia", 16));
    text("Raise eyebrows to jump", 175, 270);
    text("© Prashant Jeswani Tejwani", 10, height-10);
  } else {
    text("Game over", 180, 140);
    text("Score", 195, 240);
    text(score, 300, 240);
    textFont(createFont("Georgia", 16));
    text("Click to restart", 210, 270);
    textFont(createFont("Georgia", 16));
    text("© Prashant Jeswani Tejwani", 10, height-10);
  }
}

void reset() {
  end = true;
  score = 0;
  bird.yPos = 300;
  for (int i = 0; i < 3; i++) {
    pillars[i].xPos += 550;
    pillars[i].crashed = false;
  }
}

void mousePressed() {
  bird.jump();
  intro = false;
  if (!end) {
    reset();
  }
}

public void found (int i) {
  found = i;
}

public void mouthHeightReceived(float h) {
  println(h);
  if(h <= 3) openMouth = false;
  mouthHeight = h;
}
