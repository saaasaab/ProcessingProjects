boolean state_colorGrid = true;
boolean state_changeActivities = false;
boolean state_changeColors = false;
boolean showTime = true;  //Start/Stops the timer from showing up
boolean selectColor = false;
boolean freezeCell = false; //Stops the mouse from updating
boolean selectEndOftime = false; //whether or not the last time is being picked
boolean mouseReleased = false;
boolean inBounds = true; // Test to see if the mouse is inbounds the grid
boolean okToBeOutLate = false;
boolean step1=false;
boolean step2=false;
boolean step3=false;
boolean step4=false;
boolean step5=false;
boolean step6=false;

float startColorX = 0; //used in the circleCreator function but needs to be accessed in the mouseReleased
float startColorY = 0; //used in the circleCreator function but needs to be accessed in the mouseReleased


int endColorX = 0;
int endColorY = 0;

int posX; //Used with freezeCell
int posY; //Used with freezeCell
int offset=40;

int numBoxX=16;
int numBoxY=18;

int COLORSTATE = 0;
//int numBoxX=36; 
//int numBoxY=40;
int boxSize;
int[] gridShapes = new color[numBoxX*numBoxY];
int closestIndex;

float boxW=100;
float boxH=40;
float minIncrement = 1440/(numBoxX * numBoxY);

color closestColor = color(255, 255, 255);
color defaultColor = color(255, 255, 255);

color colors[][] = {
  {#cf202e, #f78822, #f6db35, #6dc067, #00B2C4, #4185be, #8f499c, defaultColor}, //Bass
  {#ff7f7f, #ff9f7f, #ffcf7f, #afff7f, #7fff7f, #7fe9ff, #7fb0ff, defaultColor}, //Pastel
  {#1a080e, #3d203b, #543246, #773a4d, #a75252, #cf7862, #ffce9c, defaultColor}, //Super Nova
  {#112318, #1e3a29, #305d42, #4d8061, #89a257, #bedc7f, #eeffcc, defaultColor}, //Ammo-8
  {#cf202e, #f78822, #f6db35, #6dc067, #00B2C4, #4185be, #8f499c, defaultColor}, 
  {#cf202e, #f78822, #f6db35, #6dc067, #00B2C4, #4185be, #8f499c, defaultColor}};
int[] gridColors = new int[numBoxX*numBoxY];



String[] activities = {"Ready", "Drive", "Email", "Relax", "Bathroom", "Writing", "Sleeping", "Playing"};
Menu_bar mp;
void setup() {
  size(800, 1060);
  for (int i = 0; i < gridColors.length; i++) {
    gridColors[i]=colors[0].length-1;//defaultColor; //Set the array of gridColors to the defalt
    gridShapes[i]=0;
  }

  boxSize = (width-2*offset)/numBoxX; //Find the box size
  buildMenuBar();
}

void draw() {
  if (state_colorGrid) {
    state_colorGrid();
  } else if (state_changeActivities) {
    state_changeActivities();
  } else if (state_changeColors) {
    state_changeColors();
  }
  //println(min(gridColors));
}
void toDoList() {
  println("Register the mouse when out of bounds");
  println("Make a nice bouncy animation when hit edges");
  println("Create menu items");
  println("Find the elusive bug that fills in the entire sheet");
  println("Don't create a circle when clicked out of bounds");
  println("Add a flickering delay");
  println("");
  println("");
  println("");
}

void setSteps() {
  step1=showTime && inBounds && !mousePressed;
  step2=mousePressed && !selectEndOftime && (inBounds|| okToBeOutLate);
  step3=selectColor && mouseReleased;
  step4=selectEndOftime && mouseReleased;
  step5=selectEndOftime && mouseReleased;
}

void state_colorGrid() {
  background(255);
  createGrid(); //Draw the box to the screen
  fill(defaultColor); 

  inBounds = checkInbound();
  setSteps();
  //Step 1 Determine what time to start



  if (step1) { //if showtime == true then the timer will display but not if mouse is out off bounds
    displayTimer(); // show the timer
    highlightCell(); // highlight the cell
  }

  //Step 2 Click and Hold on desired time
  if (step2) { // if selecting the first time
    okToBeOutLate = true; //Only here if clicked in a valid spot
    if (freezeCell == false) { //stops the circle selector from moving with the mouse
      posX = mouseX; //set the x pos
      posY = mouseY; //set the y pos
    }
    showTime = false; //stop showing the timer
    selectColor = true; // used to determine what the closestColor is
    freezeCell = true; //resets the freezecell
    //Step 3 Move to select acivity  

    circleCreator(posX, posY); //creates the circle selector
  } 
  //released is included to prevent the drawing "Feature"
  else if (step4) { 
    //If the user is selecting the second time
    mouseReleased = false; // reset the mouseReleased
    endColorX = gridNum(mouseX); //find the x grid num
    endColorY = gridNum(mouseY); //find the y grid num
    gridColors[endColorX+endColorY*numBoxX] = closestIndex; // Set the grid = to selected color
  } else {
    showTime = true;
    selectColor = false;
    freezeCell = false;
    okToBeOutLate = false;
    mouseReleased = false;
  }
  //Step 3 Set the grid cell to the color/Activity
  if (step3) {
    gridColors[int(startColorX)+int(startColorY)*numBoxX]= closestIndex;
    fill(defaultColor);
    selectColor = false;
    showTime = true;
    selectEndOftime = true;
    mouseReleased = false;
    okToBeOutLate = false;
  }
  if (step5) {
    selectEndOftime = false;
    connectStartAndEnd(startColorX, startColorY, endColorX, endColorY);
    mouseReleased=false;
  }
}



void circleCreator(int posx, int posy) {

  PImage imgSmall, imgLarge ;
  int x = gridNum(posx)*boxSize+offset+boxSize/2;
  int y = gridNum(posy)*boxSize+offset+boxSize/2;

  int px = mouseX;
  int py = mouseY;
  rectMode(CENTER);
  rect(x,y,60,60,60/3);
  //ellipse(x, y, 60, 60);
  rectMode(CORNER);
  
  float closestX = 0;
  float closestY = 0;
  float closestDis = 1E10;
  closestIndex=0;
  closestColor = color(255, 255, 255);

  float a = 0;
  float numChoices = 8.0;

  imgSmall=loadImage("read.png");
  imgLarge=loadImage("read.png");
  imgSmall.resize(30, 30);
  imgLarge.resize(60, 60);
  imageMode(CENTER);
  for (int i = 0; i < numChoices; i++) {
    a = i/numChoices*2*PI;
    fill(colors[COLORSTATE][i]);
    ellipse(x-cos(a)*50, y-sin(a)*50, 30, 30);
    image(imgSmall, x-cos(a)*50, y-sin(a)*50);
    float distToCircle = dist(px, py, x-cos(a)*50, y-sin(a)*50);
    if (distToCircle < closestDis) {
      closestDis = distToCircle;
      closestX = x-cos(a)*50;
      closestY = y-sin(a)*50;
      closestColor = colors[COLORSTATE][i];
      closestIndex = i;
    }
  }
  displayActivity(x, y, closestIndex);
  if (closestDis < 100) { 
    fill(colors[COLORSTATE][closestIndex]);
    ellipse(closestX, closestY, 60, 60);
    image(imgLarge, closestX, closestY);
    selectColor = true;
    startColorX = gridNum(posx);
    startColorY = gridNum(posy);
  } else {

    selectColor = false;
  }
  fill(defaultColor);
}

void displayActivity(int px, int py, int index) {
  fill(defaultColor);
  rect(px, py+2*boxH, boxW+boxW/2, boxH, 10);  
  textSize(24);
  fill(0, 102, 153);
  //textAlign(CENTER, CENTER);
  text(activities[index], px+boxW*3.0/4.0, py+5.0/2.0*boxH);
  fill(defaultColor);
}

void connectStartAndEnd(float startX, float startY, float endX, float endY) {
  int start = int(startX+startY*numBoxX);
  int end = int(endX+endY*numBoxX);

  if (start>end) {
    int scapegoat = start;
    start = end;
    end = scapegoat;
  }
  for (int i = start+1; i < end; i ++) {
    gridColors[i] = closestIndex;
    gridShapes[i]=1;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == ENTER) {
      saveFrame("layout.png");
      println("Done");
      exit();
    }
  }
}

boolean checkInbound() {
  if (
    mouseX>=offset && mouseX < offset+numBoxX*boxSize && 
    mouseY>=offset && mouseY < offset+numBoxY*boxSize) {
    return(true);
  } else {

    return(false);
  }
}

void highlightCell() {
  //int num = gridNum(); 
  int x = constrain(gridNum(mouseX), 0, numBoxX-1)*boxSize;
  int y = constrain(gridNum(mouseY), 0, numBoxY-1)*boxSize;
  fill(120, 120, 120);
  rect(x+offset, y+offset, boxSize, boxSize, 6);
  fill(defaultColor);
}

void createGrid() {
   PImage img;
   img=loadImage("read.png");
   img.resize(boxSize,boxSize);
  //println(colors[COLORSTATE][gridColors[1+1*numBoxX]]);
  for (int i = 0; i < numBoxX; i++) {
    for (int j = 0; j < numBoxY; j++) {
      fill(colors[COLORSTATE][gridColors[i+j*numBoxX]]);
      
      if (gridShapes[i+j*numBoxX]==0) {
        
        rect(offset+i*boxSize, offset+j*boxSize, boxSize, boxSize, boxSize/3);
        if(colors[COLORSTATE][gridColors[i+j*numBoxX]]!=-1){
          imageMode(CENTER);
          image(img,offset+i*boxSize+boxSize/2, offset+j*boxSize+boxSize/2);
          
        }
      } else if (gridShapes[i+j*numBoxX]==1) {
        ellipse(offset+i*boxSize+boxSize/4, offset+j*boxSize+boxSize/2, boxSize*2.0/4.0, boxSize*2.0/4.0);
        ellipse(offset+i*boxSize+boxSize*3.0/4.0, offset+j*boxSize+boxSize/2, boxSize*2.0/4.0, boxSize*2.0/4.0);
      }
    }
  }
}

void displayTimer() {
  float x = map(mouseX, 0, width, 0, width-boxW);
  float y = offset+int((mouseY-offset)/boxSize)*boxSize;
  y = max(y, boxH);
  x = constrain(x, offset, offset+(numBoxX-1)*boxSize); 
  y = constrain(y, offset, offset+(numBoxY-1)*boxSize);
  rect(x, y-boxH, boxW, boxH, 10);
  displayTime(x, y);
}

void displayTime(float x, float y) {
  int boxNumber = 
    gridNum(int(constrain(mouseX, offset, offset+(numBoxX-1)*boxSize)))+
    gridNum(int(constrain(mouseY, offset, offset+(numBoxY-1)*boxSize)))*numBoxX;
  //println(min(gridNum(int(x)),numBoxX));
  float time=(boxNumber+1)*minIncrement;
  String hr =nf((int(time/60) % 12) == 0 ? 12 : int(time/60) % 12, 2); 
  //My super complicated way to handle the Mod 12 so the time doesn't say 00:15
  String min = nf(int(time%60), 2); 
  //time to get minutes and then convert that to display format
  String clockTime = hr+":"+min;//Set up the display format
  textSize(24);
  fill(0, 102, 153);
  textAlign(CENTER, CENTER);
  text(clockTime, x+boxW/2, y-boxH/2);
  fill(defaultColor);
}

int gridNum(int pos) { //Get the x or y position in the grid
  return(int((pos-offset)/boxSize));
}

void mouseReleased() {//REset after function is called
  mouseReleased = true;
}

void buildMenuBar() {
  mp = new Menu_bar(this, "Time Tracker", 100, 100);
}

/*println(
 "showTime",showTime, "  selectColor", selectColor, "  okToBe",okToBeOutLate, "  freezeCell",freezeCell, "  selectEndOftime",selectEndOftime,
 " inBounds",inBounds, "  mouseReleased",mouseReleased);//Debug the Booleans
 */