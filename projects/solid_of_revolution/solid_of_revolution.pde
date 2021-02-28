PShape figure;
ArrayList <PVector> points;

void setup() {
  size(600, 600, P3D);
  background(0);
  fill(255);
  stroke(255);
  strokeWeight(4);
  points = new ArrayList<PVector>();
}

void draw() {
  background(0);
  // Center line
  line(width/2, 0, width/2, height);
  
  if (!points.isEmpty()) {
    line((points.get(points.size()-1).x), (points.get(points.size()-1).y), mouseX, mouseY);
    
    // Draw current figure
    if (points.size() > 1) {
      for (int i = 0; i < points.size()-1; i++) {
        line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
      }
    }
  }
   
}

// Detect when user click to create a vertex
void mousePressed() {
  if (mouseX >= width/2) { 
    points.add(new PVector(mouseX, mouseY));
  }
}
