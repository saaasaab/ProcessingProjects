Rect[] rs = new Rect[colors.length];

void state_changeColors() {
  int marginX = 100;
  int marginY = 100;
  int highlightIndex=0;
  float highlightDist=10E5;
  background(defaultColor);


  int off = 10;

  for (int i = 0; i < rs.length; i++) {
    rs[i] = new Rect(marginX, marginY+i*100, colors, off, i);
  }

  for (Rect r : rs) {
    r.update();
    r.display();

    if (r.distToBox < highlightDist) {
      highlightDist = r.distToBox;
      highlightIndex = r.index;
    }
  }
  rs[highlightIndex].display();

  if (mouseReleased) {
    COLORSTATE = highlightIndex;
    state_colorGrid = true;
    state_changeColors = false;  
    mouseReleased = false;
  }
}

class Rect {
  float x, y;
  int off;
  int LOfBox = width-2*off;
  float HOfBox = 10;
  color[][] c;
  int fillet = 6;
  int index = 0;
  float scale = 1;
  float distToBox = 0;
  float colorBoxSize = 10;
  Rect (int x_, int y_, color[][] c_, int o_, int i_) {
    x=x_;
    y=y_;
    c=c_;
    off=o_;
    index = i_;
    colorBoxSize = ((width-(x+25*off))-(c[0].length+1)*off)/c[0].length;
  }
  void display() {
    stroke(0);

    fill(200, 200, 200);

    rect(x*scale, y, (colorBoxSize*(colors.length+1)+(colors.length+2)*off) *scale, (colorBoxSize+off*2)*scale, fillet); //Background rectangle


    for (int i = 0; i < c[index].length-1; i++) {
      fill(c[index][i]);
      rect((x+off+i*colorBoxSize+i*off)*scale, off+y, colorBoxSize*scale, colorBoxSize*scale, fillet);
    }
  }

  void update() {
    scale = constrain(map(abs(mouseY-(y+2*off+(colorBoxSize)/2)), 0, 150, 1.4, 1), 1, 1.4);
    distToBox = abs(mouseY-(y+2*off+(colorBoxSize)/2));
  }
  //When you select the palette, if highlights the box starting at the left accelerating to the right
}