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
int width = 640;  // Synchronize with size() below
int height = 360; // Synchronize with size() below
int center_x = width / 2;
int center_y = height / 2;

/***** Global Variables ****************************************/
// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
// float xmin = -1.5; float ymin = -.1; float wh = 0.15;
// Origin / Center of image
float origin_x = -0.5;
float origin_y =  0.0; 

// Zoom factor
float zoom = 1;

// Calculate amount we increment x,y for each pixel
float dx = W / (width) / zoom;
float dy = H / (height) / zoom;

// Visual Controllers
int ctrl_width = 40;
int ctrl_height = height;
int btn_width = 40;
// x, y coordinates of top-left of controller
int ctrl_x = width - ctrl_width; 
int ctrl_y = 0;

boolean view_needs_update = true;

// GUI Elements
int[] plus  = { ctrl_x-5, ctrl_y+5 , btn_width, btn_width };
int[] minus = { ctrl_x-5, ctrl_y+50, btn_width, btn_width };
Button btn_plus  = new Button("plus" , ctrl_x-5, ctrl_y+5 , btn_width, btn_width);
Button btn_minus = new Button("minus", ctrl_x-5, ctrl_y+50, btn_width, btn_width);

void setup() {
  size(640, 360); // Size of view port
                  // Synchronize with width, height settings above
  //shift_origin(-ctrl_width/2,0);
  //background(255);
  //noLoop();
}

void draw() {
  if (view_needs_update) {
    update_view(origin_x, origin_y, dx, dy);
    draw_controls();
  }
}

void mousePressed()
{
  if (btn_plus.mousePressed()) {
    zoom_change(+0.05);
  } else if (btn_minus.mousePressed()) {
    zoom_change(-0.05);
  } else {
    shift_origin(-mouseX+center_x, -mouseY+center_y);
  }
}

void mouseDragged() {
  //zoom_change(+0.5);
  shift_origin(0.1,0);
}

void draw_controls() {
  fill(128,128,128,128);
  //stroke(255,255,255,255);
  strokeWeight(0);
  //rect(width-ctrl_width,0,ctrl_width,height-1);
  // draw plus-control
  //rect(ctrl_x-5, ctrl_y+5, btn_width, btn_width, 10,10,0,0);
  // draw minus-control
  //rect(ctrl_x-5, ctrl_y+50, btn_width, btn_width, 0,0,10,10);
  btn_plus.display();   
  btn_minus.display();   
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
    zoom = zoom * (1+n);
    dx = W / (width) / zoom;
    dy = H / (height) / zoom;
    view_needs_update = true;
    println(zoom);
  }
}

void shift_origin(int x_pixels, int y_pixels) {
  origin_x = origin_x - x_pixels * dx; // Move origin by x_pixels
  origin_y = origin_y - y_pixels * dy;
  view_needs_update = true;
}

