void setup() {
  size(100, 300);
}

void draw() {
  for (int i = 1; i <=3; i++) {
    for (int j = 1; j <=3; j++) {
      for (int k = 1; k <=3; k++) {
        for(int l = 1; l <=3; l++){
          tekenKaart(i, j, k, l);
          saveFrame("kaart-"+i+j+k+l+".png");
        }
      }
    }
  }
  exit();
}

void tekenKaart(int hoeveel, int vorm, int kleur, int bg) {
  background(255);
  switch(kleur) {
  case 1: 
    fill(255, 0, 0); 
    break;
  case 2: 
    fill(0, 255, 0); 
    break;
  case 3: 
    fill(0, 0, 255); 
    break;
  }
  switch(bg) {
  case 1: 
    background(255, 106, 0); 
    break;
  case 2: 
    background(16, 106, 0); 
    break;
  case 3: 
    background(104, 106, 213); 
    break;
  }
  if (vorm == 1) {
    rectMode(CENTER);
    for (int i = 1; i <= hoeveel; i++) {
      rect(width/2, height/3*i-50, width-20, 60);
    }
  } else if (vorm == 2) {
    ellipseMode(CENTER);
    for (int i = 1; i <= hoeveel; i++) {
      ellipse(width/2, height/3*i-50, width-20, 60);
    }
  } else if (vorm == 3) {
    int br = width/3;
    int centerX = width/2;
    for (int i = 1; i <= hoeveel; i++) {
      int centerY = height/3*i-50;
      triangle(centerX-br, centerY+br, centerX+br, centerY+br, centerX, centerY-br);
    }
  }
}

