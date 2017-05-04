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
  float sumX = 0.0;
  float sumY = 0.0;
  float count = 0.0;
  
  for (int y = 0; y < kinect.height; y++) {
    for (int x = 0; x < kinect.width; x++, offset++) {
      int data = depthData[offset];
      
      if (depthMin <= data && data <= depthMax) {
        depthImage.pixels[offset] = color(255, 0, 150);
        sumX += x;
        sumY += y;
        count++;
      }
      else {
        depthImage.pixels[offset] = color(0);
      }
    }
  }
  
  depthImage.updatePixels();
  image(depthImage, 0, 0);
  
  if (count > 0) {
    float averageX = sumX / count;
    float averageY = sumY / count;
    
    fill(150, 0, 255);
    ellipse(averageX, averageY, 32, 32);
  }
}