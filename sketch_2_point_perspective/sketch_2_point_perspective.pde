
float horizon = 0;
int viewboxHeight = 400;
int viewboxWidth = 200;
float point1 = -300;
float point2 = 300;
void setup()
{
  size(640, 640);
  //noStroke();
}

void draw()
{
  horizon = map(mouseY, 0, height, -height/2, height/2);
  point1 = map(mouseX, 0, width, -width/2, width/2);
  point2 = map(mouseX, 0, width, width/2, -width/2);
  background(102);
  translate(width/2, height/2);
  stroke(133, 42, 0);
  rect(-viewboxWidth/2, -viewboxHeight/2, viewboxWidth, viewboxHeight);
  line(-width/2, horizon, width/2, horizon);

  PVector leftVanishPoint = new PVector(point1, horizon);

  PVector leftCorner = new PVector(-viewboxWidth/2, viewboxHeight/2);
  PVector inc = PVector.add(leftVanishPoint,leftCorner);
  inc.setMag(300);
  int offset = 20;
  float incrementalAngle = PI/30;
  
  PVector v;
  for (int i = 0; i < 20; i++) {
    
    //PVector inc = PVector.fromAngle(angleLeft + incrementalAngel*i);
 
    line(point1, horizon, leftCorner.x, leftCorner.y);
    line(point2, horizon, -leftCorner.x, leftCorner.y);
    //leftCorner.rotate(-incrementalAngle);
    leftCorner.set(leftCorner.x+offset*pow(i,1.5),leftCorner.y);
    
    //line(point2, horizon, viewboxWidth/2-offset*i, viewboxHeight/2);
   
   
  }
}
