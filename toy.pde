final int NUMBER_OF_POINTS = 100;

PVector[] points;

void setup() {
    //size(320, 180);
    //size(640, 360);
    size(1280, 720);
    noSmooth();
    generate();
}

void generate() {
    points = new PVector[10];
    for(int i = 0; i < points.length; i++) {
        points[i] = new PVector(random(width), random(height));
    }
}

void draw() {
    clear();
    background(255);
    for(int i = 0; i < points.length; i++) {
        point(points[i].x, points[i].y);
    }
    loadPixels();
    for(int i = 0; i < pixels.length; i++) {
        int x = i % width;
        int y = floor(i / width);
        PVector pixel = new PVector(x, y);
        PVector closestPixel = points[0];
        for(int p = 0; p < points.length; p++) {
            float distance = pixel.dist(points[p]);
            if(distance < pixel.dist(closestPixel)) {
                closestPixel = points[p];
            }
        }
        float maxDistance = dist(0, 0, width, height); 
        pixels[i] = color(pixel.dist(closestPixel) / maxDistance * 255);
    }
    for(int p = 0; p < points.length; p++) {
        points[p].x += random(-1, 1);
        points[p].x = max(points[p].x, 0);
        points[p].x = min(points[p].x, width);

        points[p].y += random(-1, 1);
        points[p].y = max(points[p].y, 0);
        points[p].y = min(points[p].y, height);
    }
    updatePixels();
}

void keyPressed() {
    if (key == 'g') {
        generate();
    }
}
