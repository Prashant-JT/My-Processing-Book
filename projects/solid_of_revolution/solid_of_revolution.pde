PShape obj;
ArrayList <PVector> points;

void setup() {
  size(600, 600, P3D);
  background(0);
  fill(255);
  stroke(255);
  points = new ArrayList<PVector>();
}

void draw() {
  // Center line
  line(width/2, 0, width/2, height);
  
  if (!points.isEmpty()) {
    line((points.get(points.size()-1).x), (points.get(points.size()-1).y), mouseX, mouseY);
  }
  
  /*
  for (int i = 0; i < points.size()-1; i=i+2) {
    ellipse(points.get(i).x, points.get(i).y, 5, 5);
    //line(point.x, point.y, width/2, height);
    line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
  }
  */
}

void mousePressed() {
  if (mouseX >= width/2) { 
    //ellipse(mouseX, mouseY, 5, 5);
    points.add(new PVector(mouseX, mouseY));
  }
}
