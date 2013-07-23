/**
 * The Mandelbrot Set
 * Originally by Daniel Shiffman.
 * Modified by Chew Hoe-Kit  
 * 
 * Simple rendering of the Mandelbrot set.
 */

/***** GLOBAL CONSTANTS ****************************************/
int MAXITER  = 100;  // Max iteration for each point on complex plane
int INFINITY = 16.0; // Definition of "infinity" to stop iterating
float W = 5.0;  // Width that x values traverse
float H = 2.5;  // Height that y values traverse
int width = 640;
int height = 360;

/***** Global Variables ****************************************/
// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
// float xmin = -1.5; float ymin = -.1; float wh = 0.15;
// Origin / Center of image
float orig_x = -0.5;
float orig_y =  0.0; 

// Zoom factor
float zoom = 1;

// Calculate amount we increment x,y for each pixel
float dx = W / (width) / zoom;
float dy = H / (height) / zoom;

// Visual Controllers
boolean view_needs_update = true;

void setup() {
  size(640, 360); // Size of view port
  //background(255);
  //noLoop();
}

void draw() {
  if (view_needs_update) {
    update_view(orig_x, orig_y, dx, dy);
  }
}

void mouseReleased() {
  zoom_change(+0.5);
}

// Update view of Mandelbrot image
void update_view(float orig_x, float orig_y, float dx, float dy) {
  // Make sure we can write to the pixels[] array.
  // Only need to do this once since we don't do any other drawing.
  loadPixels();
  
  float xmin = orig_x - (width * dx)/2;
  float ymin = orig_y - (height * dy)/2;
  
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
        // pixels[i+j*] = color(n*16 % 255);
         pixels[i+j*width] = color(n*16 % 255, n*32 % 255, n*64 % 255);
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();
  view_needs_update = false;
}

void zoom_change(int n) {
  if (zoom + n >= 1) {
    zoom = zoom + n;
    dx = W / (width) / zoom;
    dy = H / (height) / zoom;
    view_needs_update = true;
  }
}

