PGraphics mask;
PImage img;
void setup(){
  size(500,500);
  img=loadImage("read.png");
  img.resize(200,200);

  //background(40);
  imageMode(CENTER);
  fill(201,27,135);
  ellipse(width/2,height/2,200,200);
  image(img,width/2,height/2);
}