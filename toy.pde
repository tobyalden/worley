final int MAX_VELOCITY = 1;
final int SHIFT_THRESHOLD = 255;

final int SIM_WIDTH = 160;
final int SIM_HEIGHT = 90;
//final int SIM_WIDTH = 320;
//final int SIM_HEIGHT = 180;
//final int SIM_WIDTH = 1920;
//final int SIM_HEIGHT = 1080;

int numberOfPoints;
PVector[] points;
PVector[] pointVelocities;
int shifter;
boolean isShiftingUp;

void setup() {
    fullScreen();
    noSmooth();
    colorMode(HSB);
    shifter = 0;
    isShiftingUp = true;
    numberOfPoints = 75;
    generate();
}

void generate() {
    numberOfPoints++;
    points = new PVector[numberOfPoints];
    pointVelocities = new PVector[numberOfPoints];
    for(int i = 0; i < points.length; i++) {
        points[i] = new PVector(random(SIM_WIDTH), random(SIM_HEIGHT));
        pointVelocities[i] = new PVector(
            random(-MAX_VELOCITY, MAX_VELOCITY),
            random(-MAX_VELOCITY, MAX_VELOCITY)
        );
    }
}

void draw() {
    clear();
    background(255);
    for(int i = 0; i < points.length; i++) {
        point(points[i].x, points[i].y);
    }
    PImage canvas = createImage(SIM_WIDTH, SIM_HEIGHT, RGB);
    for(int i = 0; i < canvas.pixels.length; i++) {
        int x = i % SIM_WIDTH;
        int y = floor(i / SIM_WIDTH);
        PVector pixel = new PVector(x, y);
        PVector closestPixel = points[0];
        PVector secondClosestPixel = points[0];
        PVector thirdClosestPixel = points[0];
        for(int p = 0; p < points.length; p++) {
            float distance = pixel.dist(points[p]);
            if(distance < pixel.dist(closestPixel)) {
                closestPixel = points[p];
            }
            else if(distance < pixel.dist(secondClosestPixel)) {
                secondClosestPixel = points[p];
            }
            else if(distance < pixel.dist(thirdClosestPixel)) {
                thirdClosestPixel = points[p];
            }
        }
        float maxDistance = dist(0, 0, SIM_WIDTH, SIM_HEIGHT); 
        canvas.pixels[i] = color(
            pixel.dist(closestPixel) * 4 / maxDistance * 255
            //pixel.dist(closestPixel) * 2 / maxDistance * 255,
            //pixel.dist(closestPixel) * 1 / maxDistance * 255
            //pixel.dist(secondClosestPixel) * 2 / maxDistance * 255 - shifter * 0.2,
            //pixel.dist(thirdClosestPixel)/ maxDistance * 255  - shifter * 0.1
        );
    }
    for(int p = 0; p < points.length; p++) {
        points[p].x += pointVelocities[p].x;
        points[p].x = max(points[p].x, 0);
        points[p].x = min(points[p].x, SIM_WIDTH);
        if(points[p].x == 0 || points[p].x == SIM_WIDTH) {
          pointVelocities[p].x *= -1;
        }
        points[p].y += pointVelocities[p].y;
        points[p].y = max(points[p].y, 0);
        points[p].y = min(points[p].y, SIM_HEIGHT);
        if(points[p].y == 0 || points[p].y == SIM_HEIGHT) {
          pointVelocities[p].y *= -1;
        }
    }

    scale(height / SIM_HEIGHT);

    PImage flipped = createImage(canvas.width, canvas.height, RGB);
    for(int i = 0; i < flipped.pixels.length; i++) {
    int srcX = i % flipped.width;
    int dstX = flipped.width - srcX - 1;
    int y = i / flipped.width;
    flipped.pixels[y * flipped.width + dstX] = canvas.pixels[i];
}
    image(canvas, 0, 0);
    blendMode(MULTIPLY);
    image(flipped, 0, 0);

    if(isShiftingUp) {
      shifter++;
      if(shifter > SHIFT_THRESHOLD) {
        shifter = SHIFT_THRESHOLD;
        isShiftingUp = false;
      }
    }
    else {
      shifter--;
      if(shifter < 0) {
        shifter = 0;
        isShiftingUp = true;
      }
    }
}

void keyPressed() {
    if (key == 'g') {
        generate();
    }
}
