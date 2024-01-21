
float scale = 3;
int rows, columns;
int energyLimit = 7;
int maxEnergy = 8;
float beta = .004;

float dist = 1;
boolean addGradient = false;

Grid Ag;

void setup() {
  size(600, 600);
  rows = int(height/scale);
  columns = int(width/scale);

  Ag = new Grid(rows, columns);
  Ag.initialize();

  energyLimit = maxEnergy-2;
}

void draw() {
  beta = map(mouseX, 0, width, 0, .2);

  background(0);
  noStroke();

  Ag.updateIsingModel();
  Ag.displayIsingModel();
}

int wrap(int v, int limit) {
  return((v+limit)%limit);
}

class Grid {
  int rows;
  float cols;

  float[][] curr;
  float[][] next;

  Grid(int r, float c) {
    rows = r;
    cols = c;
  }

  float[][] mask = {
    { 1, 1, 1},
    { 1, 0, 1 },
    { 1, 1, 1},
  };

  void initialize() {
    curr = new float[rows][columns];
    next = new float[rows][columns];

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        curr[r][c]= next[r][c]=-1;

        float prob = random(100);
        if (prob < 50) {
          curr[r][c]=next[r][c]=1;
        }
      }
    }
  }

  void updateIsingModel() {
    float totalEnergy = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        float energy = calculateIsingEnergy(r, c, 1.5) ;
        float megaEnergy = -1 * curr[r][c] * energy;

        if (megaEnergy > 0) {
          next[r][c] = -1* curr[r][c];
        } else if (random(1) > pow(2.71828, 2* megaEnergy * beta)
          && energy < energyLimit
          && energy >-energyLimit
          ) {
          next[r][c] = -1*curr[r][c];
        }
        totalEnergy = energy + totalEnergy;
      }
    }

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        curr[r][c] = next[r][c];
      }
    }
  }


  void displayIsingModel() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (curr[r][c] == 1 ) {
          fill(215, 118, 105);
        } else {
          fill(113, 188, 221);
        }
        rect(c*scale, r*scale, scale, scale);
      }
    }
  }

  float calculateIsingEnergy(int r, int c, float dist) {
    int maskW = mask[0].length;
    int maskH = mask.length;
    float energy = 0;

    for (int mr = 0; mr < maskH; mr++) {
      for (int mc = 0; mc < maskW; mc++) {
        if ( mask[mr][mc] == 0) continue;

        if (mask[mr][mc] <= dist) {
          int offsetX = mr - floor(maskW/2);  // This will map the convolution to the correct grid element
          int offsetY = mc - floor(maskH/2);
          energy += curr[wrap(r+offsetY, rows)][wrap(c+offsetX, columns)];
        }
      }
    }

    return energy;
  }
}
