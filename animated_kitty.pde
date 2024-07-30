// Object instancing for fishes 

float cameraTime = 0; // Keeping track of time where camera moves
float time = 0; // Overall Time
float timeIncrement = 1.0/60.0;

float zAdjustmentFish = 0; // Timing for Fish to leave frame
float zAdjustmentCat = 0; // Timing for Cat to leave frame

float legRotation = 0;
float[] fishOffsets = new float[3];

float[][] cameraPositions = {
  {0, 0.0, -85, 0.0, 0.0, 0},
  {-85, 0.0, -85, 0.0, 0.0, 0},
  {-85, 0.0, 0, 0.0, 0.0, 0},
  {-85, 0.0, 85, 0, 0.0, 0},
  {0, 0.0, 85, 0, 0.0, 0}
};

void setup() {
  size (800, 800, P3D);  
  for (int i = 0; i < fishOffsets.length; i++) {
    fishOffsets[i] = random(50);  
  }
  noStroke();   
}

void draw() {
  resetMatrix();  

  background(#A2F5FF); 

  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  
  if(cameraTime < 12) {  
    cameraTime += timeIncrement;
  }
  // Adjust the index calculation 
  int currentPosIndex = min(int((cameraPositions.length - 1) * cameraTime / 12.0), cameraPositions.length - 2);
  int nextPosIndex = currentPosIndex + 1;
  
  // Calculating difference between cameraPositions for smooth animation
  float diff = (cameraTime / 12.0) * (cameraPositions.length - 1) - currentPosIndex;
  
  float camX = cameraPositions[currentPosIndex][0] + (cameraPositions[nextPosIndex][0] - cameraPositions[currentPosIndex][0]) * diff;
  float camY = cameraPositions[currentPosIndex][1] + (cameraPositions[nextPosIndex][1] - cameraPositions[currentPosIndex][1]) * diff;
  float camZ = cameraPositions[currentPosIndex][2] + (cameraPositions[nextPosIndex][2] - cameraPositions[currentPosIndex][2]) * diff;
  float targetX = cameraPositions[currentPosIndex][3] + (cameraPositions[nextPosIndex][3] - cameraPositions[currentPosIndex][3]) * diff;
  float targetY = cameraPositions[currentPosIndex][4] + (cameraPositions[nextPosIndex][4] - cameraPositions[currentPosIndex][4]) * diff;
  float targetZ = cameraPositions[currentPosIndex][5] + (cameraPositions[nextPosIndex][5] - cameraPositions[currentPosIndex][5]) * diff;

  camera(camX, camY, camZ, targetX, targetY, targetZ, 0, 1, 0);
  
  // Keeping track of overall time
  time += timeIncrement;
  
  // ambient light source
  ambientLight (102, 102, 102);

  // two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, 0.5, 0.4, 0);
  directionalLight (102, 102, 102, 0, 0, -1);

  // Start Cat Object
  pushMatrix();
  scale(1.2);
  
  // Exit Animation for Cat
  if (time > 14) {
    zAdjustmentCat += 1;
  }
  translate(0,-4,-20 + zAdjustmentCat);
  
  fill(0, 0, 0);  // Black color
  specular(100, 100, 100);
  shininess (10.0);
  
  // Draw Body
  pushMatrix();
  translate(0, 3, 0);  
  cylinder(9, 18, 32);
  popMatrix();

  // Draw Head
  pushMatrix();
  translate(0, -2, 0); 
  sphere(10);
  drawEyes();
  drawNose();
  popMatrix();

  // Draw Ears
  drawEar(-4, -13, 0);  // Left ear
  drawEar(4, -13, 0);  // Right ear
  
  // Draw Arms
  drawArm(-4.3, 9, 8.3);  // Left Arm
  drawArm(4.3, 9 , 8.3);   // Right Arm
  
  // Draw Legs
  legRotation += 0.15;
  drawLeg(-4.5, 21, 0);  // Left Leg
  drawLeg(4.5, 21, 0);   // Right Leg
  
  // Draw Tail
  drawTail(0, 15, -10);
  
  // Draw Whiskers
  drawWhiskers();
  
  // Draw Collar
  drawCollar();
 
                        ///////////////////Fish Instancing//////////////////
                        
  drawFish(-30, 0, 100, 0.2, fishOffsets[0]);
  drawFish(0, 0, 140, 0.2, fishOffsets[1]);
  drawFish(30, 0, 100, 0.2, fishOffsets[2]);
  
  // Creating Plane
  pushMatrix();
  pointLight(255, 255, 255, 0, 10, 0);
  fill(#FFD579);
  shininess (0.6);
  translate(0, 27, 0);
  rotateX(PI); 
  box(1000 + zAdjustmentCat, 1, 1000 + zAdjustmentCat);  
  popMatrix();
  
  // End rotation 
  popMatrix();
}

// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}

// Helper for drawing a cone
void cone(float radius, float height) {
  //side surface of cone
  beginShape(TRIANGLES);
  for (float a = 0; a < TWO_PI; a += PI/8) {
    float x = radius * cos(a);
    float z = radius * sin(a);
    float x2 = radius * cos(a + PI/8);
    float z2 = radius * sin(a + PI/8);
    vertex(0, 0, 0);
    vertex(x, -height, z);
    vertex(x2, -height, z2);
  }
  endShape();
  
  // Base of the cone
  beginShape(TRIANGLE_FAN);
  vertex(0, -height, 0);  // center point
  for (float a = 0; a <= TWO_PI + 1; a += PI/8) {
    float x = radius * cos(a);
    float z = radius * sin(a);
    vertex(x, -height, z);
  }
  endShape();
}

// Helper for drawing Cat ears
void drawEar(float x, float y, float rotationZ) {
  fill(0);
  pushMatrix();
  translate(x, y, 0);  
  rotateZ(rotationZ);
  rotateX(PI);
  translate(0, 3, 0);  
  cone(4, 8); 
  popMatrix();
}

// Helper for drawing Cat arms
void drawArm(float x, float y, float z) {
  fill(0);
  pushMatrix();
  translate(x, y, z);  
  rotateX(PI/3); 
  scale(1, 1.8, 1.2); 
  sphere(2.5);  
  popMatrix();
}

// Helper for drawing Cat legs
void drawLeg(float x, float y, float z) {
  fill(0);
  pushMatrix();
  translate(x, y, z);  
  
  // Animating Cat Legs
  if (x < 0) {  // If it's the left leg
    rotateX(sin(legRotation) * PI / 5); 
  } else {  // If it's the right leg
    rotateX(sin(legRotation + PI) * PI / 5);  
  }
  
  scale(1.5, 2.2, 1.5); 
  sphere(2.7);  
  popMatrix();
}

// Helper for drawing Cat tail
void drawTail(float x, float y, float z) {
  fill(0);
  pushMatrix();
  translate(x, y -3, z);  
  rotateX(PI/6);
  rotateZ(sin(cameraTime * 4) * PI/7);
  scale(1, 6, 1); 
  sphere(1.5); 
  popMatrix();
}

// Helper for drawing Cat whiskers
void drawWhiskers() {
  // Set of whiskers on the left
  for (int i = 0; i < 3; i++) {
    drawWhisker(-9, -3 + (i*1.5), 3, -7, i);
  }

  // Set of whiskers on the right
  for (int i = 0; i < 3; i++) {
    drawWhisker(9, -3 + (i*1.5), 3, 7, i);
  }
}

// Helper for drawing a single whisker
void drawWhisker(float x, float y, float z, float angleY, float iteration) {
  pushMatrix();
  translate(x, y, z);
  rotateY(angleY);
  rotateX(PI/2 + (iteration * -0.2));  
  fill(80);
  noStroke();
  cylinder(0.3, 3, 16); 
  popMatrix();
}

// Helper function for drawing eyes
void drawEyes() {
  fill(255); 
  pushMatrix();
  translate(-3.5, -2, 7.5);  // Position for left eye
  sphere(2); 
  popMatrix();

  pushMatrix();
  translate(3.5, -2, 7.5);  // Position for right eye
  sphere(2);  
  popMatrix();
  
  fill(0); 
  pushMatrix();
  translate(-3.5, -2, 8.5);  // Position for left pupil
  sphere(1.2);  
  popMatrix();
  
  pushMatrix();
  translate(3.5, -2, 8.5);  // Position for left pupil
  sphere(1.2); 
  popMatrix();
}

// Helper function for drawing the nose
void drawNose() {
  fill(255, 120, 163);  // Set color to pink
  pushMatrix();
  translate(0, -0.2, 9); 
  scale(1.5,1,1);
  sphere(1.25);  
  popMatrix();
}

// Helper for drawing Cat collar
void drawCollar() {
  fill(163, 38, 29);  // Set color to red
  pushMatrix();
  translate(0, 4.5, 0);
  rotateX(PI);
  cylinder(9.1, 2, 32);  
  popMatrix();
}

// Fish Object Instancing
void drawFish(float x, float y, float z, float speed, float offset) {
  pushMatrix();
  scale(0.4);
  
  // Fish Exit Animation
  if (time > 13) {
    zAdjustmentFish += 1;
  }
  translate(x + sin(frameCount * speed + offset) * 5, y + 40, z + zAdjustmentFish); // Fish Movement
  fill(100, 200, 255); // Color Blue
  shininess (6.0);

  // Fish body 
  pushMatrix();
  rotateY(PI/2);
  scale(1.5, 1, 1);
  sphere(10); 
  popMatrix();

  // Fish tail 
  pushMatrix();
  scale(1,2,1);
  translate(0, 0, -9); 
  rotateX(PI/2);
  cone(5, 15); 
  popMatrix();
  
  popMatrix();
}
