// import the Kinect classes from the Kinect4WinSDK. Note that we are importing
// SkeletonData since it is referenced in the event handler methods, but we
// don't use that class directly in this example
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;

// Declare a reference to our Kinect controller
Kinect kinect;

// Declare a reference to an image that we will use to display depth data
PImage depthImage;

// Define the minimum and maximum distances that we wish to display. All values
// between and including depthMin and depthMax will be displayed.
float depthMin = 17;
float depthMax = 26;


void setup() {
  size(640, 480);
  
  // Create a new instance of the Kinect class passing in a reference to this
  // sketch so that it can be used for event handling (see below)
  kinect = new Kinect(this);
  
  // Create an image to be used to display the depth data we're interested in
  depthImage = new PImage(640, 480);
}


void draw() {
  // Grab depth data as an image. Note that this returns a greyscale image, but
  // it is encoded in ARGB (Alpha, Red, Green, and Blue)
  PImage depthData = kinect.GetDepth();

  // We use an offset to visit each pixel in the depthData image
  int offset = 0;

  // Initialize our summations of the x and y values of the depth pixels we are
  // interested in
  float sumX = 0.0;
  float sumY = 0.0;

  // Initialize the count of pixels we are interested in
  float count = 0.0;
  
  // Loop through all pixels moving left-to-right, then top-to-bottom
  for (int y = 0; y < depthData.height; y++) {
    for (int x = 0; x < depthData.width; x++, offset++) {
      // Grab the depth value
      //
      // Each pixel is a 32-bit value. The first // 8 bits are the A (alpha)
      // value, the next three groups of 8 bits are the // R (red), G (green),
      // and B (blue) values, respectively. Since we know // the image is
      // greyscale, we know that R == G == B. We simply grab the // bits for the
      // blue channel using '& 0xFF'.
      //
      // The depth values come in with a somewhat strange ordering; smaller
      // values are further away. To make this range more natural, we invert
      // the distance value be subtracting it from the maximum value. Now 255 is
      // the furthest distance
      int data = 255 - (depthData.pixels[offset] & 0xFF);
      
      // Check if the current pixel's depth is between our minimum and maximum
      // values of interest
      if (depthMin <= data && data <= depthMax) {
        // They are, so plot a purple pixel in our output image
        depthImage.pixels[offset] = color(255, 0, 150);

        // Since this pixel is of interest to use, add the current x and y
        // coordinates to our x and y sums
        sumX += x;
        sumY += y;

        // Increment the number of pixels we were interested in
        count++;
      }
      else {
        // This pixel is not interesting, so plot a black pixel here
        depthImage.pixels[offset] = color(0);
      }
    }
  }
  
  // Apply the pixel changes to the original image and plot it to the screen
  depthImage.updatePixels();
  image(depthImage, 0, 0);
  
  // if we say at least one pixel of interest...
  if (count > 0) {
    // ...find the average X and Y value of all pixels of interest
    float averageX = sumX / count;
    float averageY = sumY / count;
    
    // and plot a lighter purple circle over that average position
    fill(150, 0, 255);
    ellipse(averageX, averageY, 32, 32);
  }
}

//
// The following methods seem to be required by the Kinect4WindowsSDK library.
// If we do not define these, the sketch will crash.
//

void appearEvent(SkeletonData _s) 
{
}

void disappearEvent(SkeletonData _s) 
{
}

void moveEvent(SkeletonData _b, SkeletonData _a)
{
}
