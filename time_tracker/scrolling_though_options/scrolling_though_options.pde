Rect[] rs = new Rect[10];
void setup() {
  size(500, 800);
  for (int i = 0; i < rs.length; i++) {
    rs[i] = new Rect(10, i*50, i);
  }
}
void draw() {
  background(120);
  int highlightIndex=0;
  float highlightDist=10E5;
  
  for (Rect r : rs) {
    r.update();
    r.display();
    
    if(r.distToBox < highlightDist){
      highlightDist = r.distToBox;
      highlightIndex = r.index;
    }
  }
  fill(color(127, 233, 255));
  rs[highlightIndex].display();
  fill(255);
}


class Rect {
  float x, y;
  float scale = 1;
  float distToBox = 0;
  int index = 0;
  int boxSize = 45;
  Rect (int x_, int y_, int i_) {
    x=x_;
    y=y_;
    index = i_;
  }
  void display() {
    rect(x, y, 45*scale, 45*scale,6);
    rect(x+100*scale, y, boxSize*scale, boxSize*scale,6);
  }

  void update() {


    scale = constrain(map(abs(mouseY-(y+boxSize/2)), 0, 100, 1.4, 1), 1, 1.4);
    distToBox = abs(mouseY-(y+boxSize/2));
  }
  //When you select the palette, if highlights the box starting at the left accelerating to the right
}