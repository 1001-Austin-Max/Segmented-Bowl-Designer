class Segment {
  float angle, completedRotation, radius, dim, depth, circleRadius, depthR, thickness;
  PVector[] vertices;
  Segment(float a, float circleR, float d, float t, float c) {
    angle = a;
    thickness = t;
    depthR = d; //how much of the radius of the layer the segment fills
    circleRadius = circleR; //from the center to the lowest radius on the section
    completedRotation = c;
    radius = circleRadius*cos(angle/2);
    depth = -(depthR*cos(angle/2)-radius); //(radius-depth)/cos(angle/2)
    dim = 2*radius*cos(angle/2);
    vertices = new PVector[4];
    vertices[0] = new PVector(-(radius-depth)*tan(angle/2), -(radius-depth), 0);
    vertices[1] = new PVector(-radius*tan(angle/2), -radius, 0);
    vertices[2] = new PVector(radius*tan(angle/2), -radius, 0);
    vertices[3] = new PVector((radius-depth)*tan(angle/2), -(radius-depth), 0);
  }

  void display(float x, float y) {
    pushMatrix();
    translate(x, y, 0);
    rotate(completedRotation);
    shape3D(vertices, thickness);
    popMatrix();
  }
}

class NormalLayer extends Layer { //layers where every segment is the same
  NormalLayer(int num, float t, float r, float d) {
    numberOfSides = num;
    thickness = t;
    radius = r; //smallest radius of layer
    depth = d;
    anglePerSegment = TWO_PI/numberOfSides;
    circleR = radius/cos(anglePerSegment/2); //largest radius of bowl
    depthR = (radius-depth)/cos(anglePerSegment/2);
    for (int i = 0; i<numberOfSides; i++) {
      segments.add(new Segment(anglePerSegment, circleR, depthR, thickness, i*anglePerSegment));
    }
  }
}

class SegmentedLayer extends Layer { //layer with a divider between each layer
  float anglePerDiv;
  SegmentedLayer(int num, float divWidth, float t, float r, float d) {
    numberOfSides = num;
    thickness = t;
    radius = r;
    depth = d;
    anglePerDiv = 2*atan(divWidth/(2*radius));
    anglePerSegment = (TWO_PI-(anglePerDiv*numberOfSides))/numberOfSides;
    circleR = radius/cos(anglePerSegment/2);
    depthR = (radius-depth)/cos(anglePerSegment/2);
    float rot = (anglePerSegment+anglePerDiv)/2;
    for (float i = 0; i < TWO_PI; i+=rot) {
      segments.add(new Segment(anglePerSegment, circleR, depthR, thickness, i));
      i+=rot;
      segments.add(new Segment(anglePerDiv, circleR, depthR, thickness, i));
    }
  }
}

abstract class Layer {
  int numberOfSides;
  float radius, depth, thickness, anglePerSegment, circleR, depthR;//in inches radius is the smallest radius that the segments create since that is the biggest possible radius for the turned layer
  boolean mouseOver;
  ArrayList<Segment> segments = new ArrayList<Segment>();
  void display(float x, float y) {
    for (Segment s : segments) {
      s.display(x, y);
      //shape3D(vertices, 200);
    }
  }
}

void shape3D(PVector[] vertices, float t) {
  fill(255);
  beginShape();//top
  for (int i = 0; i < vertices.length; i++) {
    vertex(vertices[i].x, vertices[i].y, t);
  }
  endShape(CLOSE);
  beginShape();//bottom
  for (int i = 0; i < vertices.length; i++) {
    vertex(vertices[i].x, vertices[i].y, 0);
  }
  endShape(CLOSE);

  beginShape();
  vertex(vertices[0].x, vertices[0].y, t);
  vertex(vertices[1].x, vertices[1].y, t);
  vertex(vertices[1].x, vertices[1].y, 0);
  vertex(vertices[0].x, vertices[0].y, 0);
  endShape();
  beginShape();
  vertex(vertices[1].x, vertices[1].y, t);
  vertex(vertices[2].x, vertices[2].y, t);
  vertex(vertices[2].x, vertices[2].y, 0);
  vertex(vertices[1].x, vertices[1].y, 0);
  endShape();
  beginShape();
  vertex(vertices[2].x, vertices[2].y, t);
  vertex(vertices[3].x, vertices[3].y, t);
  vertex(vertices[3].x, vertices[3].y, 0);
  vertex(vertices[2].x, vertices[2].y, 0);
  endShape();
  beginShape();
  vertex(vertices[3].x, vertices[3].y, t);
  vertex(vertices[0].x, vertices[0].y, t);
  vertex(vertices[0].x, vertices[0].y, 0);
  vertex(vertices[3].x, vertices[3].y, 0);
  endShape();
}