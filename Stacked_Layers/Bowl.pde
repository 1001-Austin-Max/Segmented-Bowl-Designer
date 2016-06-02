class Bowl {
  ArrayList<Layer> layers = new ArrayList<Layer>();
  float totalThickness = 0;
  float totalRadius = 0;
  float[] pers = {1.2, 0}; //x rotation, translate down scale
  Bowl() {
  }

  void display() {
    miniLayers();
    if (editing == null) {
      
      pushMatrix();
      translate(x, y, -(totalThickness/2)-(100*layers.size()));
      rotateX(pers[0]);
      //scale(width/totalRadius);
      translate(-x, -y, totalThickness);
      //translate(0,0,layers.get(0).thickness);
      for (Layer l : layers) {
        l.display(x, y);
        translate(0, 0, (l.thickness));
      }
      popMatrix();
    } else {
      editing.display(x, y);
    }
  }

  void addLayer(Layer l) { //int num, float divWidth, float t, float r, float d, float x, float y
    layers.add(l);
    totalRadius += l.radius;
    totalThickness+=l.thickness+30*(width/width-layers.size());
  }

  void removeLayer(Layer l) {
    layers.remove(l);
    totalThickness-=l.thickness;
  }

  void editLayer(int i) {
    editing = layers.get(i);
  }
  
  void miniLayers(){
    float xSpacer = width/layers.size();
    float start = xSpacer/2;
    float y = start;
    //translate(start,start);
    for(int i = 0; i < layers.size();i++){
      pushMatrix();
      Layer l = layers.get(i);
      noFill();
      rect(i*xSpacer, 0,(i+1)*(xSpacer), y*2);
      fill(255);
      translate((i*xSpacer)+start, start);
      scale(xSpacer/(1.2*(totalRadius/width)*l.radius));
      translate(-(i*xSpacer)-start, -start);
      l.display((i*xSpacer)+start, start);
      popMatrix();
      fill(0);
      textAlign(CENTER, TOP);
      textSize(20);
      text("Layer " + (i+1),(i*xSpacer)+start, xSpacer + 5);
    }
  }
}