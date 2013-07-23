/**
 * The Mandelbrot Set
 * Originally by Daniel Shiffman.
 * Modified by Chew Hoe-Kit  
 * 
 * Simple rendering of the Mandelbrot set.
 */

/***** GLOBAL PARAMETERS ****************************************/
int MAXITER  = 100;  // Max iteration for each point on complex plane
int INFINITY = 16.0; // Definition of "infinity" to stop iterating

// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
// float xmin = -1.5; float ymin = -.1; float wh = 0.15;
float xmin = -3.0;
float ymin = -1.25;
float w = 5.0;
float h = 2.5;

// width of controller
int ctrl_width = 0;
// height of controller
int ctrl_height = 0;
// width of image
int img_width = width - ctrl_width;
// height of image
int img_height = height;

size(640, 360);
noLoop();
background(255);

// Make sure we can write to the pixels[] array.
// Only need to do this once since we don't do any other drawing.
loadPixels();

// x goes from xmin to xmax
float xmax = xmin + w;
// y goes from ymin to ymax
float ymax = ymin + h;

// Calculate amount we increment x,y for each pixel
float dx = (xmax - xmin) / (width);
float dy = (ymax - ymin) / (height);

// Start y
float y = ymin;
for (int j = 0; j < height; j++) {
  // Start x
  float x = xmin;
  for (int i = 0;  i < width; i++) {

    // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
    float a = x;
    float b = y;
    int n = 0;
    while (n < MAXITER) {
      float aa = a * a;
      float bb = b * b;
      float twoab = 2.0 * a * b;
      a = aa - bb + x;
      b = twoab + y;
      // Infinty in our finite world is simple, let's just consider it 16
      if (aa + bb > INFINITY) {
        break;  // Bail
      }
      n++;
    }

    // We color each pixel based on how long it takes to get to infinity
    // If we never got there, let's pick the color black
    if (n == MAXITER) {
      pixels[i+j*width] = color(0);
    }
    else {
      // Gosh, we could make fancy colors here if we wanted
      // pixels[i+j*width] = color(n*16 % 255);
       pixels[i+j*width] = color(n*16 % 255, n*32 % 255, n*64 % 255);
    }
    x += dx;
  }
  y += dy;
}
updatePixels();

