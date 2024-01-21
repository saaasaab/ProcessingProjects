
float a1 = 0;
float a2 = 0;
float a3 = 0;

float radius = 200;
int prevN = 0;
int n = 50;
float goldenRatio = (1 + sqrt(5))/2;
PVector pPoint;
PVector[] points = new PVector[n];
int index = 0;

void setup() {
  colorMode(HSB, 360, 100, 100);
  size( 800, 850,P3D);
  background(0, 12, 12);
}

void draw() {
  //if(index == 0){
    
  //}
 
 background(0, 12, 12);
  n = int(map(mouseX, 0, width, 50, 3000));
  if (n != prevN) {
    points = new PVector[n];

    for (int i = 0; i < n; i++) {
      float noise1 =  map(noise(i, a2), 0, 1, 0, PI/12);
      float noise2 = map(noise(a2, i), 0, 1, 0, PI/12);

      float theta = 2 * PI * i / goldenRatio + noise1;
      float phi = acos(1 - 2 * (i + 0.5) / n) + noise2;

      float x = cos(theta) * sin(phi);
      float y = sin(theta) * sin(phi);
      float z = (cos(phi));

      points[i] = new PVector(x, y, z);
    }
  }

  translate(width / 2, 1.8* height / 3);
  rotateX(PI/2.5);
  rotateZ(a1);
  
  //PVector point = points[index];
  stroke(a3, 250, 250);
  sphere(21);
  for (PVector point : points) {
    PVector scaled = point.copy().mult(radius);

    stroke(a3, 250, 250);
    strokeWeight(6);
   
    point(scaled.x, scaled.y, scaled.z);

    stroke(0);
    strokeWeight(2);
    line(0, 0, 0, scaled.x, scaled.y, scaled.z);

    //if( pPoint != null){
    //  PVector pScaled = pPoint.copy().mult(radius);
    //  strokeWeight(1);
    //  line(scaled.x, scaled.y, scaled.z ,pScaled.x,pScaled.y,pScaled.z);
    //}
    //pPoint = point;
    
  }

  a1+=.0031;
  a2+=.015;
  a3+=.75;

  if (a3 > 360) {
    a3 = 0;
  }
  //index++;
  //if(index == n){
  //  index = 0;
  //}
}

class Dot{
  Dot(){
    int x;
    int y;
    int z;
    
  }
}
