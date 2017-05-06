import KinectPV2.*;

KinectPV2 kinect;

PImage depthImage;
float depthMin = 492;
float depthMax = 679;
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
  float sumX = 0.0;
  float sumY = 0.0;
  float count = 0.0;
  
  for (int y = 0; y < depth_height; y++) {
    for (int x = 0; x < depth_width; x++, offset++) {
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