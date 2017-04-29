import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

PImage depthImage;
float depthMin = 250;
float depthMax = 500;

void setup() {
  size(640, 480);
  
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableMirror(true);
  
  depthImage = new PImage(kinect.width, kinect.height);
}

void draw() {
  int[] depthData = kinect.getRawDepth();
  int offset = 0;
  float depthMin = map(mouseX, 0, width, 0, 4500);
  float depthMax = map(mouseY, 0, height, 0, 4500);
  
  for (int y = 0; y < kinect.height; y++) {
    for (int x = 0; x < kinect.width; x++, offset++) {
      int data = depthData[offset];
      
      if (depthMin <= data && data <= depthMax) {
        depthImage.pixels[offset] = color(255, 0, 150);
      }
      else {
        depthImage.pixels[offset] = color(0);
      }
    }
  }
  
  depthImage.updatePixels();
  image(depthImage, 0, 0);
  
  fill(255);
  textSize(16);
  text("min=" + round(depthMin) + ", max=" + round(depthMax), 2, 16);
}