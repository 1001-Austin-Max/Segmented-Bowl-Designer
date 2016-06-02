void setup(){
  size(1000,700);
}

SegmentedLayer l = new SegmentedLayer(12,10, 0, 200, 100, 500, 350);

void draw(){
  background(255);
  l.display();
  noFill();
  //ellipse(l.x,l.y, l.radius*2,l.radius*2);
  //ellipse(s.centerX,s.centerY, s.radius,s.radius);
}