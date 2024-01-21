HashMap<String, Integer> landSettings = new HashMap<>();
int videoScale = 10;

// Number of columns and rows in our system
int cols, rows;
float scaling = 5; // one square is 2 feet
int roadWidth = 40; 

Cell[][] gridCells;

void setup() {
  size(720, 480);

  CreatePropertiesMap();
  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;
  gridCells = new Cell[rows][cols];
    // Begin loop for rows
  for (int j = 0; j < rows; j++) {
     // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      // Scaling up to draw a rectangle at (x,y)
      int x = i*videoScale;
      int y = j*videoScale;
      int index = j*rows + i;
      Cell cell = new Cell(x, y, videoScale,videoScale, index);
    
      gridCells[j][i] = cell;
    }
  }
  
  
  
  //Define the property Lines;
  float landW = landSettings.get("width");
  float landWCellCountOffset = cols/2 - landW/scaling /2;
  
  float landH = landSettings.get("depth");
  float landHCellCountOffset = rows/2 - landH/scaling/2;

  // Define the roads
  float frontRoad = landSettings.get("road_front");
  float rightRoad = landSettings.get("road_right");
  float backRoad = landSettings.get("road_back");
  float leftRoad = landSettings.get("road_left");
  
  float dedication = landSettings.get("dedication");

  float frontNum = landHCellCountOffset + landH/scaling;
  float rightNum = landWCellCountOffset + landW/scaling;

  float frontSetbackWithDed = frontNum - dedication / scaling;
  
  // Begin loop for rows
  for (int j = 0; j < rows; j++) {
     // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      
      // Check for property lines
      if(
        j >= landHCellCountOffset &&  // Back
        j <= frontNum &&  // Front
        i >= landWCellCountOffset && // Left
        i <= rightNum){ // Right
       
        gridCells[j][i].setProperty(1);
        gridCells[j][i].draw();
      }
      
      // Check for roads
      if(
          ( backRoad == 1 && j <= landHCellCountOffset && j > landHCellCountOffset - roadWidth/scaling ) || // Back road
          ( leftRoad == 1 && i <= landWCellCountOffset &&  i > landWCellCountOffset - roadWidth/scaling) ||  // Left Road){
          ( frontRoad == 1 && j >= frontNum &&  j < frontNum + roadWidth/scaling ) || // Front Road
          ( rightRoad == 1 && i > rightNum &&  i <= rightNum + roadWidth/scaling )) // Right Road
      {
         gridCells[j][i].setRoad(1);
      }
      
      
      // Check for Dedications (The assumption is the dedication is on the frontage
      if(dedication > 0 &&  
          j < frontNum &&  // Front
          i >= landWCellCountOffset && // Left
          i <= rightNum &&
          j > frontSetbackWithDed){
        gridCells[j][i].setDedication(1);
        gridCells[j][i].setProperty(0);
        gridCells[j][i].setRoad(0);
      }
   
   
      setBackSetter(i,j);
      gridCells[j][i].draw();
    }
  }
  
  
  
  
  if(frontRoad == 1){
    
  }
  //float rightRoad = landSettings.get("road_right");
  //float backRoad = landSettings.get("road_back");
  //float leftRoad
  
  // Begin loop for checking the approach on the wherever there is a road
  
  // Begin loop for rows
  for (int j = 0; j < rows; j++) {
     // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      
    }
  }
}



//void draw() {
//}


void setBackSetter(int i, int j){
  int frontSB = landSettings.get("setbacks_front");
  int backSB = landSettings.get("setbacks_back");
  int leftSB = landSettings.get("setbacks_left");
  int rightSB = landSettings.get("setbacks_right");
  float dedication = landSettings.get("dedication");

  //Define the property Lines;
  float landW = landSettings.get("width");
  float landWCellCountOffset = cols/2 - landW/scaling /2;
  
  float landH = landSettings.get("depth");
  float landHCellCountOffset = rows/2 - landH/scaling/2;
  
  float frontNum = landHCellCountOffset + landH/scaling;
  float rightNum = landWCellCountOffset + landW/scaling;

  float frontSetbackWithDed = frontNum - dedication / scaling;
  
// Check for front setbacks for the building footpring
  if(frontSB > 0 &&  
      j <= frontSetbackWithDed &&  // Front
      j > frontSetbackWithDed - frontSB/ scaling && 
      i >= landWCellCountOffset && // Left
      i < rightNum
     ){
    gridCells[j][i].setSetback(1);
  }
 
 // Check for right setbacks for the building footpring
  if(rightSB > 0 &&  
      i <= rightNum &&
      i > rightNum - rightSB/ scaling &&
      j < frontSetbackWithDed && 
      j > landHCellCountOffset
     ){
    gridCells[j][i].setSetback(1);
  }
  
  // Check for left setbacks for the building footpring
  if(leftSB > 0 &&  
      i >= landWCellCountOffset &&
      i < landWCellCountOffset + leftSB/ scaling &&
      j < frontSetbackWithDed  && 
      j > landHCellCountOffset
     ){
    gridCells[j][i].setSetback(1);
  }
  
 // Check for back setbacks for the building footpring
  if(backSB > 0 &&  
      j >= landHCellCountOffset &&  // Front
      j < landHCellCountOffset +  backSB/ scaling && 
      i > landWCellCountOffset && // Left
      i <= rightNum
     ){
    gridCells[j][i].setSetback(1);
  }
}

class Cell { 
  int xpos, ypos, cellW, cellH, index;
  float property, road, dedication, setback, approach_start, parking, driveway, building, walkway, greenary = 0;
  float nothing = 1;
  
  Cell (int x, int y, int w, int h, int i) {  
    xpos = x;
    ypos = y; 
    cellW = w;
    cellH = h;
    index = i;
  }
  
  void setProperty(float property) {
    this.property = property;
  }
  void setRoad(float road){
    this.road = road; 
  }
  void setDedication(float dedication){
    this.dedication=dedication;
  }
  void  setSetback(float setback){
    this.setback=setback;
  }
  
 
  void draw() { 
    stroke(0);
    //noStroke();
    fill(map(this.index,0,rows*cols,0,255));
    if(this.property == 1){
      fill(12,190,32);
    }
    if(this.road == 1){
      fill(62,60,62);
    }
    
    if(this.dedication == 1){
      fill(162,80,162);
    }
    if(this.setback == 1){
      fill(202,40,32);
    }
    
    
    rect(xpos, ypos, cellW, cellH);
    
  } 
  
} 





void CreatePropertiesMap(){
  int propWidth = 80;
  int propDepth = 145;
  
  landSettings.put("max_footprint_percent", 40);
  landSettings.put("width", propWidth);
  landSettings.put("depth", propDepth);
  landSettings.put("property_size",propWidth*propDepth);
  
  landSettings.put("dedication",10);
 
  landSettings.put("setbacks_front", 15);
  landSettings.put("setbacks_back", 10);
  landSettings.put("setbacks_left", 7);
  landSettings.put("setbacks_right", 7);
  
  // Number of parking spaces
  landSettings.put("parking_requirements", 4);
  landSettings.put("handicap_requirements", 6);
  landSettings.put("maneuver",24);
  
  // 1 or 0 to show if there is or is not a road 
  landSettings.put("road_front", 1);
  landSettings.put("road_back", 0);
  landSettings.put("road_left", 0);
  landSettings.put("road_right", 1);
  
  landSettings.put("approach", 0 );
  
  float maxSize = landSettings.get("property_size")*landSettings.get("max_footprint_percent")*.01;
  landSettings.put("max_size", parseInt(maxSize));
  
}



//void setup() {
//  size(640, 460);
  
  
//  println(landSettings);
//  noStroke();
//  background(0);
  
//  int X = landSettings.get("width");
//  int Y = landSettings.get("depth");
//  int[][] corners = {
//    {0,0},
//    {X,0},
//    {0,Y},
//    {X,Y}
//  }; // TL, TR, BR, BL
//  int[][] cornersFootprint = {
//    {0,0},
//    {X,0},
//    {0,Y},
//    {X,Y}
//  };
  
//  int roadWidth = 40; 
//  if(landSettings.get("road_back") == 1){
//    corners[0][1] += roadWidth;
//    corners[1][1] += roadWidth;
//    corners[2][1] += roadWidth;
//    corners[3][1] += roadWidth;
//  }
//  if(landSettings.get("road_left") == 1){
//    corners[0][0] += roadWidth;
//    corners[1][0] += roadWidth;
//    corners[2][0] += roadWidth;
//    corners[3][0] += roadWidth; 
//  }
  
  
//  color roadC = color(132,134,131);
//  if(landSettings.get("road_back") == 1){
//    fill(roadC);
//    rect(0,0,corners[1][0],roadWidth);
//  }
//  if(landSettings.get("road_left") == 1){
//    fill(roadC);
//    rect(0,0,roadWidth,corners[2][1]);
//  }
  
//  if(landSettings.get("road_front") == 1){
//    boolean extend = landSettings.get("road_right") == 1;
//    fill(roadC);
//    rect(0,corners[2][1],corners[3][0]+ (extend?roadWidth:0),roadWidth );
//  }
    
//  if(landSettings.get("road_right") == 1){
//    boolean extend = landSettings.get("road_front") == 1;
//    fill(roadC);
//    rect(corners[1][0],0,roadWidth, corners[3][1] + (extend?roadWidth:0));
//  }
  
  
  
//  int frontSB = landSettings.get("setbacks_front");
//  int backSB = landSettings.get("setbacks_back");
//  int leftSB = landSettings.get("setbacks_left");
//  int rightSB = landSettings.get("setbacks_right");
  
//  // property outline
//  fill(244);
//  rect(
//    corners[0][0],
//    corners[0][1],
//    landSettings.get("width"),
//    landSettings.get("depth"));
    
    
    
//  cornersFootprint[0][0] = corners[0][0]+leftSB;
//  cornersFootprint[0][1] = corners[0][1]+backSB;
  
//  println(cornersFootprint[0][0]);
  
//  cornersFootprint[1][0] = corners[1][0]+leftSB;
//  cornersFootprint[1][1] = corners[1][1]+backSB;
//    //landSettings.get("width")-rightSB-leftSB,
//    //landSettings.get("depth")-frontSB-backSB);
    
    
//  // Building envelope
//  fill(23,211,50);
//  rect(
//    corners[0][0]+leftSB,
//    corners[0][1]+backSB,
//    landSettings.get("width")-rightSB-leftSB,
//    landSettings.get("depth")-frontSB-backSB);
 
//  // Parking
//  Parking parking = new Parking(
//    //cornersFootprint[0][0] ,
//    //cornersFootprint[0][1],
//    corners[0][0] ,
//    corners[0][1],
//    30,
//    landSettings.get("parking_requirements"),
//    landSettings.get("handicap_requirements"),
//    landSettings.get("maneuver")
//   ); 
//  parking.draw();
// //line(cornersFootprint[0][0],cornersFootprint[0][1],cornersFootprint[3][0],cornersFootprint[3][1]);
  
//}



//class Parking {
//  float xpos, ypos, orientation, totalSpots, handicapped, maneuver; 
//  Parking (float x, float y, float o, float t, float h, float m) {  
//    xpos = x;
//    ypos = y; 
//    orientation = o;
//    totalSpots = t;
//    handicapped = h;
//    maneuver = m;
//  }
  
//  void draw(){
  
    
//    int carW = 9;
//    int carH = 19;
//    for(int i = 0; i< totalSpots; i++){
//      Car car = new Car(xpos + carW*i ,ypos, 30); 
//      car.draw();
//    }
//    rect(xpos, ypos+ + carH, totalSpots*carW, maneuver);

//  }
//}
//class Car { 
//  float xpos, ypos, orientation; 
//  Car (float x, float y, float o) {  
//    xpos = x;
//    ypos = y; 
//    orientation = o;
//  }
//  void draw() { 
//    noStroke();
//    fill(126,20,20);
   
//    rect(xpos, ypos, 9, 19);
//    stroke(0);
//    line(xpos, ypos, xpos, ypos+19); 
//    line(9+xpos, ypos,9+xpos, ypos+19); 
//  } 
//} 


//class MaxBuildingFootprint { 
//  float xpos, ypos, orientation, maxArea, maxWidth, maxHeight; 
//   MaxBuildingFootprint (float x, float y, float o, float a, float w, float h) {  
//    xpos = x;
//    ypos = y; 
//    orientation = o;
//    maxArea = a;
//    maxWidth=w;
//    maxHeight=h;
//  }
//  void draw() { 
//    noStroke();
//    fill(126,20,20);
   
//    rect(xpos, ypos, 9, 19);
//    stroke(0);
//    line(xpos, ypos, xpos, ypos+19); 
//    line(9+xpos, ypos,9+xpos, ypos+19); 
//  } 
//} 
