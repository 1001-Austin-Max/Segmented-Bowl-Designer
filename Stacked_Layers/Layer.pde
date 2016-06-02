class Segment {
  float angle, centerX, centerY, completedRotation, radius, dim, depth, circleRadius, depthR;
  Segment(float a, float circleR, float d, float x, float y, float c) {
    angle = a;
    centerX = x;
    centerY = y;
    depthR = d; //how much of the radius of the layer the segment fills
    circleRadius = circleR; //from the center to the lowest radius on the section
    completedRotation = c;
    radius = circleRadius*cos(angle/2);
    depth = -(depthR*cos(angle/2)-radius); //(radius-depth)/cos(angle/2)
    dim = 2*radius*cos(angle/2);
  }
  void display() {
    pushMatrix();
    translate(centerX, centerY);
    rotate(completedRotation);
    beginShape();
    stroke(0);
    vertex(-(radius-depth)*tan(angle/2), -(radius-depth));
    vertex(-radius*tan(angle/2), -radius);
    vertex(radius*tan(angle/2), -radius);
    vertex((radius-depth)*tan(angle/2), -(radius-depth));
    vertex(-(radius-depth)*tan(angle/2), -(radius-depth));
    endShape();
    popMatrix();
  }
}

class NormalLayer extends Layer { //layers where every segment is the same
  NormalLayer(int num, float t, float r, float d, float x, float y) {
    numberOfSides = num;
    thickness = t;
    radius = r; //smallest radius of layer
    depth = d;
    this.x = x;
    this.y = y;
    anglePerSegment = TWO_PI/numberOfSides;
    circleR = radius/cos(anglePerSegment/2); //largest radius of bowl
    for (int i = 0; i<numberOfSides; i++) {
      segments.add(new Segment(anglePerSegment, circleR, depth, x, y, i*anglePerSegment));
    }
  }
}

class SegmentedLayer extends Layer { //layer with a divider between each layer
  float anglePerDiv;

  SegmentedLayer(int num, float divWidth, float t, float r, float d, float x, float y) {
    numberOfSides = num;
    thickness = t;
    radius = r;
    depth = d;
    this.x = x;
    this.y = y;
    anglePerDiv = 2*atan(divWidth/(2*radius));
    anglePerSegment = (TWO_PI-(anglePerDiv*numberOfSides))/numberOfSides;
    circleR = radius/cos(anglePerSegment/2);
    depthR = (radius-depth)/cos(anglePerSegment/2);
    float rot = (anglePerSegment+anglePerDiv)/2;
    for (float i = 0; i < TWO_PI; i+=rot) {
      segments.add(new Segment(anglePerSegment, circleR, depthR, x, y, i));
      i+=rot;
      segments.add(new Segment(anglePerDiv, circleR, depthR, x, y, i));
    }
  }
}

abstract class Layer {
  int numberOfSides;
  float radius, x, y, depth, thickness, anglePerSegment, circleR, depthR;//in inches radius is the smallest radius that the segments create since that is the biggest possible radius for the turned layer
  ArrayList<Segment> segments = new ArrayList<Segment>();
  void display() {
    for (Segment s : segments) {
      s.display();
    }
  }
}