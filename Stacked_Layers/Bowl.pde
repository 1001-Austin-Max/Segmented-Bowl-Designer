class Bowl {
  ArrayList<Layer> layers = new ArrayList<Layer>();
  float totalThickness = 0;
  float totalRadius = 0;
  float[] pers = {1.2,0}; //x rotation, translate down scale
  Bowl() {
  }

  void display() {
    if (editing == null) {
      miniLayers();
      pushMatrix();
      translate(x,y,-(totalThickness/2)-(100*layers.size()));
      rotateX(1.2);
      //scale(width/totalRadius);
      translate(-x,-y,totalThickness);
      for (Layer l : layers) {
        l.display(x,y);
        translate(0,0,l.thickness);
      }
      popMatrix();
    } else {
      editing.display(x,y);
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
    if(layers.size() > 0){
      float y = width/layers.size();
      int i = 0;
      for(float lastX = width/layers.size(); lastX < width + (width/layers.size()); lastX+=width/layers.size()){
        line(lastX, 0, 0,lastX, y,0);
        Layer l = layers.get(i);
        pushMatrix();
        translate(lastX-(width/(2*layers.size())), y/2);
        scale((width/layers.size())/(3*l.radius));
        translate(-lastX+(width/(2*layers.size())), -y/2);
        l.display(lastX-(width/(2*layers.size())), y/2);
        popMatrix();
        i++;
      }
      line(0,y,0,width,y,0);
    }
  }
}