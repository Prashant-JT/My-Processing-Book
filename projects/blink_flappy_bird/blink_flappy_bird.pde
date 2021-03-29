import oscP5.*;

Bird bird = new Bird();
Pillar[] pillars = new Pillar[3];
boolean end = false;
boolean intro = true;
int score = 0;
OscP5 oscP5;
int found;
float eyeLeftBefore, eyeRightBefore;
float eyeLeft, eyeRight;
float[] rawArray;

void setup() {
  size(500, 600);
  frameRate(50);

  for (int i = 0; i < 3; i++) {
    pillars[i] = new Pillar(i);
  }

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "rawData", "/raw");

  rawArray = new float[132]; 
  eyeLeftBefore = -1;
  eyeRightBefore = -1;
}

void draw() {
  background(0);

  // Face found
  if (found > 0) {
    pushMatrix();
    translate(60, height-100);
    scale(2);
    drawFacePoints(); 
    drawFacePolygons();
    popMatrix();

    if (eyeLeft < eyeLeftBefore - 0.8 && eyeRight < eyeRightBefore - 0.8) {
      if (end) {
        bird.jump();
        intro = false;
        if (!end) {
          reset();
        }
      }
    }
  }
  
  // Update bird
  if (end) bird.move();
  bird.drawBird();
  if (end) bird.drag();
  bird.checkCollisions();
  
  // Draw pillars
  for (int i = 0; i < 3; i++) {
    pillars[i].drawPillar();
    pillars[i].checkPosition();
  }

  fill(0);
  stroke(255);
  textSize(32);
  
  // Show controls
  if (end) {
    rect(20, 20, 100, 50);
    fill(255);
    text(score, 30, 58);
  } else {
    help();
  }
}

// User controls
void help() {
  rect(110, 105, 300, 50);
  rect(160, 200, 200, 90);
  fill(255);

  if (intro) {
    text("Face Flappy bird", 140, 140);
    text("Click to Play", 175, 240);
    textFont(createFont("Georgia", 16));
    text("Click or blink eyes to jump", 166, 270);
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

// Reset game
void reset() {
  end = true;
  score = 0;
  bird.yPos = 300;
  for (int i = 0; i < 3; i++) {
    pillars[i].xPos += 550;
    pillars[i].crashed = false;
  }
}

// Alternative jump
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

// Check left blink
public void eyeLeftReceived(float f) { 
  if (eyeLeftBefore == 6) eyeLeftBefore = f; 

  if (f < eyeLeftBefore - 1.2) {
    eyeLeftBefore = f;
  }

  if (eyeLeft > eyeLeftBefore) {
    eyeLeftBefore = eyeLeft;
  }

  eyeLeft = f;
}

// Check right blink
public void eyeRightReceived(float f) {
  if (eyeRightBefore == -1) eyeRightBefore = f; 

  if (f < eyeLeftBefore - 1.2) {
    eyeLeftBefore = f;
  }

  if (eyeRight > eyeRightBefore) {
    eyeRightBefore = eyeRight;
  }

  eyeRight = f;
}

// Draw face
void drawFacePoints() {
  int nData = rawArray.length;
  for (int val=0; val<nData; val+=2) {
    fill(255);
    ellipse(rawArray[val], rawArray[val+1], 3, 3);
  }
}

void drawFacePolygons() {
  fill(255);
  stroke(50); 

  // Face outline
  beginShape();
  for (int i=0; i<34; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  for (int i=52; i>32; i-=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape(CLOSE);

  // Eyes
  beginShape();
  for (int i=72; i<84; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape(CLOSE);
  beginShape();
  for (int i=84; i<96; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape(CLOSE);

  // Upper lip
  beginShape();
  for (int i=96; i<110; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  for (int i=124; i>118; i-=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape(CLOSE);

  // Lower lip
  beginShape();
  for (int i=108; i<120; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  vertex(rawArray[96], rawArray[97]);
  for (int i=130; i>124; i-=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape(CLOSE);

  // Nose bridge
  beginShape();
  for (int i=54; i<62; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape();

  // Nose bottom
  beginShape();
  for (int i=62; i<72; i+=2) {
    vertex(rawArray[i], rawArray[i+1]);
  }
  endShape();
}

public void rawData(float[] raw) {
  rawArray = raw;
}
