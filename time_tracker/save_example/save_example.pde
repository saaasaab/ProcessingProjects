int[] x;
int[] y;

String[] lines;
void setup() 
{
  String filename = "lines.txt";
  lines = loadStrings(filename);  
  x = new int[lines.length];
  y = new int[lines.length];
  for (int i = 0; i < lines.length; i++) {
    String[] hold = split(lines[i], '\t');
    x[i]=int(hold[0]);
    y[i]=int(hold[1]);
  }
  size(200, 200);
}

void draw() 
{
  background(204);
  stroke(0);
  noFill();
  beginShape();
  for (int i = 0; i < x.length; i++) {
    vertex(x[i], y[i]);
  }
  endShape();
  // Show the next segment to be added
  if (x.length >= 1) {
    stroke(255);
    line(mouseX, mouseY, x[x.length-1], y[x.length-1]);
  }
}

void mousePressed() { // Click to add a line segment
  x = append(x, mouseX);
  y = append(y, mouseY);
}

void keyPressed() { // Press a key to save the data
  String[] lines = new String[x.length];
  for (int i = 0; i < x.length; i++) {
    lines[i] = x[i] + "\t" + y[i];
  }
  saveStrings("lines.txt", lines);
  exit(); // Stop the program
}