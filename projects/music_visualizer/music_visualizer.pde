import processing.sound.*;

SoundFile song;
PImage background;
ArrayList<Particle> particles = new ArrayList<Particle>();
boolean menu;
FFT fft;
Amplitude level;
Amplitude amp;
float amplitude;

void setup() {
  size(900, 600);
  song = new SoundFile(this, "sample.mp3");
  background = loadImage("background.jpg");
  menu = true;
  imageMode(CENTER);
  rectMode(CENTER);
  fft = new FFT(this);
  level = new Amplitude(this);
  fft.input(song);
  level.input(song);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  if (menu) {
    menu();
  } else {
    // Shake image depending on amplitude
    amplitude = level.analyze();
    //pushMatrix();
    if (amplitude > 0.8) rotate(random(-0.003, 0.003));
    image(background, 0, 0, width + 100, height + 100);
    //popMatrix();

    // Transparency depending on amplitude
    float alpha = map(amplitude*100, 0, 255, 180, 150);
    fill(0, alpha);
    noStroke();
    rect(0, 0, width, height);

    stroke(255);
    strokeWeight(3);
    noFill();

    createCircle();
    createParticles();

    fill(255);
    text("Press 'h' to show menu", (width/2) - 180, (height/2) - 10);
  }

  fill(255);
  text("© Prashant Jeswani Tejwani", -(width/2) + 10, (height/2) - 10);
}

// Main menu
void menu() {
  noFill();
  stroke(255);
  rect(0, -155, 300, 80);
  fill(255);

  textFont(createFont("Georgia", 20));
  text("Music visualizer", -70, -150);
  textFont(createFont("Georgia", 16));
  text("The song called 'sample.mp3' will be played and visualized", -220, 0);
  text("Click to play/pause song", -85, 30);
  text("Press 'h' to hide menu", (width/2) - 180, (height/2) - 10);
}

void createCircle() {
  float[] wave = fft.analyze();

  // Draw right side of circle
  beginShape();  
  for (int i = 0; i <= 180; i ++) {
    int index = floor(map(i, 0, 180, 0, wave.length-1));
    float r = map(wave[index], -1, 1, 150, 350);
    float x = r * sin(degrees(i));
    float y = r * cos(degrees(i));
    vertex(x, y);
  }
  endShape();

  // Draw left side of circle
  beginShape();  
  for (int i = 0; i <= 180; i ++) {
    int index = floor(map(i, 0, 180, 0, wave.length-1));
    float r = map(wave[index], -1, 1, 150, 350);
    float x = r * -sin(degrees(i));
    float y = r * cos(degrees(i));
    vertex(x, y);
  }
  endShape();
}

void createParticles() {
  particles.add(new Particle());
  for (int i = particles.size() - 1; i >= 0; i--) {
    if (!particles.get(i).edges()) {
      // Accelerate particles when amplitude > 0.8
      particles.get(i).update(amplitude > 0.8);
      particles.get(i).show();
    } else {
      // Remove particle when out of borders
      particles.remove(i);
    }
  }
}

void keyPressed() {
  if (key == 'h') {
    menu = !menu;
  }
}

void mouseClicked() {
  if (song.isPlaying()) {
    song.pause();
  } else {
    song.play();
  }
}
