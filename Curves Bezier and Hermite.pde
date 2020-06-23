// 2D vector helper class
class point2d {

  float x, y;

  point2d(float x, float y ) {
    this.x=x;
    this.y=y;
  }
}

// Mouse click detection sensitivity
int sens = 12; 

// Draw radius of the control points
int cpRadius = 8;

// Array of our control points
point2d[] points;

void setup() {

  size(1000, 600);
  ellipseMode(RADIUS);

  // Initialize the CP array
  points = new point2d[8];
  points[0] = new point2d(34.0f, 512.0f);
  points[1] = new point2d(109.0f, 204.0f);
  points[2] = new point2d(360.0f, 200.0f);
  points[3] = new point2d(420.0f, 500.0f);
  points[4] = new point2d(623.0f, 510.0f);
  points[5] = new point2d(571.0f, 433.0f);
  points[6] = new point2d(881.0f, 444.0f);
  points[7] = new point2d(823.0f, 111.0f);
}

void draw() { 
  background(240.0f);

  float B1x = 5 * (points[5].x - points[4].x);
  float B1y = 5 * (points[5].y - points[4].y);
  float G0x = points[5].x;
  float G0y = points[5].y;
  float G1x = points[6].x;
  float G1y = points[6].y;
  float R0x = B1x;
  float R0y = B1y;
  float R1x = points[7].x - points[6].x;
  float R1y = points[7].y - points[6].y;
  
  // Draw the bezier curve
  noFill();
  stroke(240.0f, 0.0f, 0.0f);
  strokeWeight(4.0f);

  beginShape();  
  // >> draw here
  for (float t = 0; t <= 1; t+= 0.01) {

    float x, y;

    x = points[0].x * 1 * pow(t, 0) * pow(1-t, 5) + 
      points[1].x * 5 * pow(t, 1) * pow(1-t, 4) +
      points[2].x * 10 * pow(t, 2) * pow(1-t, 3) + 
      points[3].x * 10 * pow(t, 3) * pow(1-t, 2) + 
      points[4].x * 5 * pow(t, 4) * pow(1-t, 1) +
      points[5].x * 1 * pow(t, 5) * pow(1-t, 0);


    y = points[0].y * 1 * pow(t, 0) * pow(1-t, 5) + 
      points[1].y * 5 * pow(t, 1) * pow(1-t, 4) +
      points[2].y * 10 * pow(t, 2) * pow(1-t, 3) + 
      points[3].y * 10 * pow(t, 3) * pow(1-t, 2) + 
      points[4].y * 5 * pow(t, 4) * pow(1-t, 1) +
      points[5].y * 1 * pow(t, 5) * pow(1-t, 0);

    vertex( x, y );
  }
  endShape();

  // Draw the Hermite curve
  noFill();
  strokeWeight(4.0f);
  stroke(0.0f, 240.0f, 0.0f);

  beginShape();
  // >> draw here

  for (float t = 0; t <= 1 + 0.01; t+= 0.01) {

    float x = G0x * ( 2 * (t*t*t) 
      - 3 * (t*t) 
      + 1)

      + G1x * ( -2 *  (t*t*t)
      +  3 * t*t
      )

      + R0x * ( (t*t*t)
      - 2.0 * (t*t)
      + t )
      + R1x * ( (t*t*t)
      -  t *t )
      ;
    float y = G0y * ( 2 * (t*t*t) 
      - 3 * (t*t) 
      + 1)

      + G1y * ( -2 *  (t*t*t)
      +  3 * t*t
      )

      + R0y * ( (t*t*t)
      - 2.0 * (t*t)
      + t )
      + R1y * ( (t*t*t)
      -  t *t )
      ;                  


    vertex(x, y);
  }
  endShape();

  // Control polygon for the bezier curve
  stroke(0.0f, 0.0f, 0.0f);
  strokeWeight(2.0f);
  // >> draw here
  for ( int i = 0; i < 5; i++ ) {
    line(points[ i ].x, points[ i ].y, points[ i + 1 ].x, points[ i + 1 ].y);
  }

  // Tangent of the Hermite curve
  stroke(0.0f, 255.0f, 255.0f);
  strokeWeight(1.0f);
  // >> draw here
  line(G1x, G1y, points[7].x, points[7].y);
  line(G0x, G0y, G0x + B1x, G0y + B1y);

  // Control points
  noStroke();
  fill(0.0f, 0.0f, 255.0f);
  // >> draw here
  for ( int i = 0; i < 8; i++ ) {
    ellipse(points[ i ].x, points[ i ].y, 5, 5);
  }

  // End point of the Bézier curve tangent
  noFill();
  stroke(0, 0f, 0.0f, 255.0f);
  // >> draw here
  ellipse(G0x + B1x, G0y + B1y, 5, 5);
}

////////////////////////////////////////////////////////////////////////////////
// Mouse handling
////////////////////////////////////////////////////////////////////////////////

int getActivePoint(point2d[] t, int sens, int mousex, int mousey) {
  point2d M = new point2d(mousex, mousey);

  for (int i = 0; i < t.length; i++) {
    if ((M.x - t[i].x) * (M.x - t[i].x) + (M.y - t[i].y) * (M.y - t[i].y) < sens * sens)
      return i;
  }
  return -1;
}

// Which CP is being dragged currently
int dragged = -1;

void mousePressed() {
  dragged = getActivePoint(points, sens, mouseX, mouseY);
}

void mouseDragged() {
  if (dragged!=-1) {
    points[dragged].x = mouseX; 
    points[dragged].y = mouseY;

    // This can be used to print out the current position of the control
    // points, so that a desired placement can be stored as the default
    // state in the code
    println("===================================");
    for (int i = 0; i < points.length; ++i) {
      println("points[" + i + "] = new point2d(" + points[i].x + "f, " + points[i].y + "f);");
    }
    println("===================================");
  }
}

void mouseReleased() {
  dragged = -1;
}
