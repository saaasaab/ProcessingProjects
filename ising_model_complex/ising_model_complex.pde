

float[][] A;
float[][] Anext;
float[][] energies;

float scale = 4;
int rows, columns;
int energyLimit;
int maxEnergy;

float beta = .004;

float dist = 2;
boolean addGradient = true;


void getMaxEnergy() {
  if (dist <= 1) {
    maxEnergy = 4;
    energyLimit=4;
  } else if (dist <= 1.5) {
    maxEnergy = 8;
    energyLimit=7;
  } else if (dist <= 2) {
    maxEnergy = 12;
    energyLimit=10;
  } else if (dist <= 2.5) {
    maxEnergy = 20;
    energyLimit=16;
  } else if (dist <= 3) {
    maxEnergy = 28;
    energyLimit= 22;
  }
}
void setup() {
  frameRate(20);
  size(800, 800);
  colorMode(HSB, 360, 255, 255);
  getMaxEnergy();

  rows = int(height/scale);
  columns = int(width/scale);

  A = new float[rows][columns];
  Anext = new float[rows][columns];
  energies= new float[rows][columns];

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < columns; c++) {
      A[r][c]= Anext[r][c]=-1;
      energies[r][c] = 0;

      float prob = random(100);
      if (prob < 50) {
        A[r][c]=Anext[r][c]=1;
      }
    }
  }
}

void draw() {
  if(addGradient){
    colorMode(HSB, 360, 255, 255);
  }
  else{
    colorMode(RGB);
  }
  beta = map(mouseX, 0, width, 0, .2);
  dist = float(int(map(mouseY, 0, height, .75, 2)*3.5))/2;
  getMaxEnergy();
  //energyLimit = maxEnergy-1;

  println(dist, " ", energyLimit);
  background(0);
  noStroke();
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < columns; c++) {

      if (addGradient) {
        fill(int(map(energies[r][c], -maxEnergy, maxEnergy, 30, 330)), 200, 200);
      } 
      else {
        if (A[r][c] == 1 ) {
          fill(215, 118, 105);
        } else {
          fill(113, 188, 221);
        }
      }

      rect(c*scale, r*scale, scale, scale);
    }
  }
  noStroke();
  update();
}

void update() {
  float totalEnergy = 0;
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < columns; c++) {

      float energy =

        // Dist = 1
        // up down left right
        A[wrap(r-1, rows)][wrap(c, columns)]
        + A[wrap(r+1, rows)][wrap(c, columns)]
        + A[wrap(r, rows)][wrap(c-1, columns)]
        + A[wrap(r, rows)][wrap(c+1, columns)];

      if (dist >= 1.5) {
        // Dist = 1.5
        // Diagonals
        energy +=
          A[wrap(r-1, rows)][wrap(c-1, columns)]
          + A[wrap(r-1, rows)][wrap(c+1, columns)]
          + A[wrap(r+1, rows)][wrap(c-1, columns)]
          + A[wrap(r+1, rows)][wrap(c+1, columns)];
      }

      // Dist = 2
      // 2 up down left right
      if (dist >= 2) {
        energy +=
          A[wrap(r-2, rows)][wrap(c, columns)]
          + A[wrap(r+2, rows)][wrap(c, columns)]
          + A[wrap(r, rows)][wrap(c-2, columns)]
          + A[wrap(r, rows)][wrap(c+2, columns)];
      }

      // Dist = 2.5
      // 2 up down left right - with one up
      if (dist >= 2.5) {
        energy +=
          A[wrap(r-2, rows)][wrap(c-1, columns)]
          + A[wrap(r-2, rows)][wrap(c+1, columns)]
          + A[wrap(r+2, rows)][wrap(c-1, columns)]
          + A[wrap(r+2, rows)][wrap(c+1, columns)]
          + A[wrap(r-1, rows)][wrap(c-2, columns)]
          + A[wrap(r+1, rows)][wrap(c-2, columns)]
          + A[wrap(r-1, rows)][wrap(c+2, columns)]
          + A[wrap(r+1, rows)][wrap(c+2, columns)];
      }

      // Dist = 3
      // 2 up down left right - with two up
      if (dist >= 3) {
        energy +=
          A[wrap(r-2, rows)][wrap(c-2, columns)]
          + A[wrap(r-2, rows)][wrap(c+2, columns)]
          + A[wrap(r+2, rows)][wrap(c-2, columns)]
          + A[wrap(r+2, rows)][wrap(c+2, columns)]
          + A[wrap(r-2, rows)][wrap(c-2, columns)]
          + A[wrap(r+2, rows)][wrap(c-2, columns)]
          + A[wrap(r-2, rows)][wrap(c+2, columns)]
          + A[wrap(r+2, rows)][wrap(c+2, columns)];
      }



      energies[r][c] = energy;

      float megaEnergy = -1 * A[r][c] * energy;
      //println(pow(2.71828,-energy * beta));
      if (megaEnergy > 0) {
        Anext[r][c] = -1*A[r][c];
      } else if (random(1) > pow(2.71828, 2* megaEnergy * beta)
        && energy < energyLimit
        && energy >-energyLimit
        ) {
        Anext[r][c] = -1*A[r][c];
      }


      totalEnergy = energy + totalEnergy;
    }
  }

  //float M = 1.0 / (rows * columns) * totalEnergy;
  //println(totalEnergy, " ", M);


  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < columns; c++) {
      A[r][c] = Anext[r][c];
    }
  }
}



int wrap(int v, int limit) {
  return((v+limit)%limit);
}
