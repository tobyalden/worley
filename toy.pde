final int NUMBER_OF_POINTS = 32;
final int MAX_VELOCITY = 10;

final int SIM_WIDTH = 320;
final int SIM_HEIGHT = 180;

PVector[] points;
PVector[] pointVelocities;

void setup() {
    //size(320, 180);
    //size(640, 360);
    //size(1280, 720);
    fullScreen();
    noSmooth();
    generate();
}

void generate() {
    points = new PVector[NUMBER_OF_POINTS];
    pointVelocities = new PVector[NUMBER_OF_POINTS];
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
        for(int p = 0; p < points.length; p++) {
            float distance = pixel.dist(points[p]);
            if(distance < pixel.dist(closestPixel)) {
                closestPixel = points[p];
            }
        }
        float maxDistance = dist(0, 0, SIM_WIDTH, SIM_HEIGHT); 
        canvas.pixels[i] = color(pixel.dist(closestPixel) / maxDistance * 255);
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
    image(canvas, 0, 0);
}

void keyPressed() {
    if (key == 'g') {
        generate();
    }
}
