
String[] lines;


void loadPreviousFile() {
  String filename = "saveState.txt";
  gridShapes = new color[numBoxX*numBoxY];
  lines = loadStrings(filename);  
  numBoxX=int(lines[0]);
  numBoxY=int(lines[1]);
  COLORSTATE = int(lines[2]);
  int count = 3;
  for (int i = count; i < numBoxX*numBoxY+count; i++) {
    gridShapes[i-count] = int(lines[i]);
  }    

  count = numBoxX*numBoxY+count;
  for (int i = count; i < count + numBoxX*numBoxY; i++) {
    gridColors[i-count] = int(lines[i]);
  }    
  
  //x = new int[lines.length];
  //y = new int[lines.length];
  //for (int i = 0; i < lines.length; i++) {
  //String[] hold = split(lines[i], '\t');
  //x[i]=int(hold[0]);
  //y[i]=int(hold[1]);   
  //}
  
  
}

void saveNewFile() {
  String[] lines={};
  //Save the numBoxX
  lines = append(lines, str(numBoxX));
  
  //Save the numBoxY
  lines = append(lines, str(numBoxY));
  
  //COLORSTATE
  lines = append(lines, str(COLORSTATE));

  //gridShapes
  for (int i = 0; i < gridShapes.length; i++) {
    lines = append(lines, str(gridShapes[i]));
  }

  //gridColors
  for (int i = 0; i < gridColors.length; i++) {
    lines = append(lines, str(gridColors[i]));
  }
  saveStrings("saveState.txt", lines);


  exit(); // Stop the program
}