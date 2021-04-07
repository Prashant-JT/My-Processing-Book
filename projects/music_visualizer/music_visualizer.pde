//https://pixabay.com/music/search/genre/beats/
import processing.sound.*;

SoundFile song;
PImage background;
FFT fft;
Amplitude level;
ArrayList<Particle> particles = new ArrayList<Particle>();
boolean menu = true;
float amp;

void setup() {
  size(900, 600);
  song = new SoundFile(this, "sample.mp3");
  background = loadImage("background.jpg");
  imageMode(CENTER);
  rectMode(CENTER);
  fft = new FFT(this);
  level = new Amplitude(this);
  song.play();
  fft.input(song);
  level.input(song);
}

void draw() {
  background(0);
  translate(width/2, height/2);

  // Shake image depending on amplitude
  amp = level.analyze();
  pushMatrix();
  if (amp > 0.8) rotate(random(-0.003, 0.003));
  image(background, 0, 0, width + 100, height + 100);
  popMatrix();

  // Transparency depending on amplitude
  float alpha = map(amp*100, 0, 255, 180, 150);
  fill(0, alpha);
  noStroke();
  rect(0, 0, width, height);

  stroke(255);
  strokeWeight(3);
  noFill();

  createCircle();
  createParticles();
  
  fill(255);
  text("© Prashant Jeswani Tejwani", -(width/2) + 5, (height/2) - 10);
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
      particles.get(i).update(amp > 0.8);
      particles.get(i).show();
    } else {
      // Remove particle when out of borders
      particles.remove(i);
    }
  }
}

void mouseClicked() {
  if (song.isPlaying()) {
    song.pause();
    noLoop();
  } else {
    song.play();
    loop();
  }
}
