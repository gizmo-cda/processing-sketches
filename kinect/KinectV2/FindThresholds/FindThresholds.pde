import KinectPV2.*;

KinectPV2 kinect;

PImage depthImage;
float depthMin = 250;
float depthMax = 500;
int depth_width = 512;
int depth_height = 424;

void setup() {
  size(512, 424);
  
  kinect = new KinectPV2(this);
  
  kinect.enableDepthImg(true);
  kinect.enableInfraredImg(true);
  kinect.init();
  
  depthImage = new PImage(depth_width, depth_height);
}

void draw() {
  int[] depthData = kinect.getRawDepthData();
  int offset = 0;
  float depthMin = map(mouseX, 0, width, 0, 4500);
  float depthMax = map(mouseY, 0, height, 0, 4500);
  
  for (int y = 0; y < depth_height; y++) {
    for (int x = 0; x < depth_width; x++, offset++) {
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