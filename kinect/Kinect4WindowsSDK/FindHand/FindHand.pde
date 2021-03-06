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
// between and including depthMin and depthMax will be displayed. These values
// range from 0 to 255, inclusive. It is expected that depthMin <= depthMax.
float depthMin = 17;
float depthMax = 26;


void setup() {
  size(640, 480);
  
  // Create a new instance of the Kinect class
  kinect = new Kinect(this);
  
  // Create an image to be used to display the depth data we're interested in
  depthImage = new PImage(640, 480);
}


void draw() {
  // Grab depth data as an image. Note that this returns a greyscale image, but
  // it is encoded in ARGB (Alpha, Red, Green, and Blue)
  PImage depthData = kinect.GetDepth();

  // We use an offset to keep track of the current pixel to visit in the
  // depthData image
  int offset = 0;

  // We want to find the average x and y position for all pixels we're
  // interested in. We do this by summing all x values and all y values
  // separately. We then divide each sum by the total number of pixels that were
  // summed giving us our average position.
  
  // Initialize our summations to zero
  float sumX = 0.0;
  float sumY = 0.0;

  // Initialize our pixels-of-interest count to zero
  float count = 0.0;
  
  // Loop through all pixels moving left-to-right, then top-to-bottom
  for (int y = 0; y < depthData.height; y++) {
    for (int x = 0; x < depthData.width; x++, offset++) {
      // Grab the current depth value via depthData.pixels[offset]. Each pixel
      // is a 32-bit value. Traveling from MSB to LSB, the first 8 bits are the
      // A (alpha) value, the next three groups of 8 bits are the R (red),
      // G (green), and B (blue) values, respectively. Since we know the image
      // is greyscale, we know that R == G == B. We simply grab the bits for the
      // blue channel using '& 0xFF'.
      //
      // The depth values come in with an unintuitive ordering; smaller values
      // are further away. To make this range more natural, we invert the
      // distance value by subtracting it from the maximum value. Now 255 is the
      // furthest distance and 0 is the closest.
      int data = 255 - (depthData.pixels[offset] & 0xFF);
      
      // Check if the current pixel's depth is within our minimum and maximum
      // closed interval
      if (depthMin <= data && data <= depthMax) {
        // It is so plot a purple pixel in our output image
        depthImage.pixels[offset] = color(255, 0, 150);

        // Since this pixel is of interest to us, add the current x and y
        // coordinates to our x and y sums
        sumX += x;
        sumY += y;

        // Increment the total count of pixels that we've found interesting
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
  
  // if we saw at least one pixel of interest...
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
