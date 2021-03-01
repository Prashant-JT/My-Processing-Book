PShape figure;
PShape figureSolid;
ArrayList <PVector> points;
boolean drawFigure;

void setup() {
  size(800, 700, P3D);
  background(0);
  fill(255);
  stroke(255);
  strokeWeight(3);
  drawFigure = false;
  points = new ArrayList<PVector>();
}

void draw() {
  background(0);
  // Center line
  line(width/2, 0, width/2, height);
  controlsMessage();
  
  if (drawFigure) {
    // [minY, maxY]
    float[] minMaxY = minMaxY();
    // Place mouse in the center of the figure
    translate(mouseX, mouseY - (minMaxY[0] - (minMaxY[0] - minMaxY[1])/2));
    shape(figureSolid);
  }else if (!points.isEmpty()) {
    line((points.get(points.size()-1).x), (points.get(points.size()-1).y), mouseX, mouseY);
    ellipse((points.get(points.size()-1).x), (points.get(points.size()-1).y), 5, 5);
    
    // Draw current edges
    if (points.size() > 1) {
      for (int i = 0; i < points.size()-1; i++) {
        line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
        ellipse((points.get(i).x), (points.get(i).y), 5, 5);
      }
    }
  }
  
}

// Create figure
void drawFigure() {
  ArrayList <ArrayList> solid = new ArrayList<ArrayList>();
  figureSolid = createShape(GROUP);
  figure = createShape();
  figure.beginShape(LINES);
  
  // Translate points
  for (PVector point : points) {
    ArrayList <PVector> pointTranslated = new ArrayList<PVector>();
    for (int i = 0; i < 360; i++) {
      pointTranslated.add(translatePoints(point, radians(i)));
    }
    solid.add(pointTranslated);
  }
  
  // Close shape and add to final figure
  figure.endShape(CLOSE);
  figureSolid.addChild(figure);
   
  // Create solid of revolution
  drawSolidRevolution(solid);
}

PVector translatePoints(PVector point, float theta) { 
  // x2 = x1 * cos0 - y1 * sen0
  float x2 = (point.x - width/2) * cos(theta) - point.z * sin(theta);
  // y2 = y1
  float y2 = point.y;
  // z2 = x1 * sen0 + z1 * cos0
  float z2 = (point.x - width/2) * sin(theta) + point.z * cos(theta);
  figure.vertex(x2, y2, z2);
  return new PVector(x2, y2, z2);
}

// Create solid of revolution
void drawSolidRevolution(ArrayList solid) {
  fill(0);
  for (int i = 1; i < solid.size(); i++) {
    ArrayList <PVector> currentPoint = (ArrayList) solid.get(i);
    ArrayList <PVector> previousPoint = (ArrayList) solid.get(i-1);
    for (int j = 11; j < 360; j = j+10) {
       PShape t = createShape();
       t.beginShape(TRIANGLES);
       t.vertex(currentPoint.get(j).x, currentPoint.get(j).y, currentPoint.get(j).z);
       t.vertex(previousPoint.get(j).x, previousPoint.get(j).y, previousPoint.get(j).z);
       t.vertex(currentPoint.get(j-9).x, currentPoint.get(j-9).y, currentPoint.get(j-9).z);
       t.endShape(CLOSE);
       
       figureSolid.addChild(t);
    }
  }
}

float[] minMaxY() {
  float maxY = 0;
  float minY = 0;
  for (PVector point : points) {
    if (point.y > maxY) maxY = point.y;
    if (point.y < minY) minY = point.y;
  }
  return new float[] {minY, maxY};
}

// Clear all points of the figure
void clearPoints() {
  points.clear();
}

void controlsMessage() {
  fill(255);
  textFont(createFont("Georgia", 12));
  text("Draw vertexes on the right side of the centered line", 10, height - 140);
  text("Right click to create new vertex", 10, height - 120);
  text("Press 'x' to delete last vertex", 10, height - 80);
  text("Press 'd' to draw solid of revolution", 10, height - 60);
  text("Press 'c' to clear screen", 10, height - 100);
  text("© Prashant Jeswani Tejwani", 10, height - 20);
}

// Detect when user clicks to create a new vertex
void mousePressed() {
  if (mouseX >= width/2 && !drawFigure) {
    points.add(new PVector(mouseX, mouseY));
  }
}

// Detect controls
void keyPressed() {
  if (key == 'c') {
    // Clear screen
    drawFigure = false;
    clearPoints();
  }else if(key == 'x' && points.size() > 0 && !drawFigure) {
    // Remove last vertex
    points.remove(points.get(points.size()-1));
  }else if (key == 'd' && points.size() > 2) {
    // Draw last vertex
    line((points.get(points.size()-1).x), (points.get(points.size()-1).y), points.get(0).x, points.get(0).y);
    drawFigure = true;
    drawFigure();
  }
}
