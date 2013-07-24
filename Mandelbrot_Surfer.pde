/**
 * Click on the image to start -- happy exploring!</br>
 * Vote for new features <a href="http://wideopenstudy.blogspot.com/2013/07/mandelbrot-surfer.html">here</a>.
 */

/* The Mandelbrot Set originally by Daniel Shiffman.
 * Modified by Chew Hoe-Kit.
 */ 

/***** GLOBAL CONSTANTS ****************************************/
// Max iteration for each point on complex plane. 
// Higher MAXITER is slower but show more detail at higher zoom 
int MAXITER  = 100;  
int INFINITY = 16.0; // Definition of "infinity" to stop iterating
int ZOOM_STEP = 0.05; // Zoom step each time zoom in or out
int MAX_STEP_PIXELS = 10; // move at most n pixels at a time when stepping
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
// Target origin is the point the view will move to
float target_origin_x = origin_x;
float target_origin_y = origin_y;

// Zoom factor
int zoom = 1;

// Calculate amount we increment x,y for each pixel
float dx = W / (width) / zoom;
float dy = H / (height) / zoom;

boolean view_needs_update = true;

float[] palette = { 
  38.612, 8.602, 216.196
};

/***** GUI Elements **************************************************/
// Visual Controllers
int ctrl_width = 45;
int ctrl_height = height;
int btn_width = 40;
// x, y coordinates of top-left of controller
int ctrl_x = width - ctrl_width; 
int ctrl_y = 0;

Pimage zoomInImage  = loadImage("zoom_in.png");
Pimage zoomOutImage = loadImage("zoom_out.png");
Pimage paletteImage = loadImage("palette.png");
int[] vecPlus  = { 
  ctrl_x, ctrl_y+5, btn_width, btn_width
}; // x,y,w,h
int[] vecMinus = { 
  ctrl_x, ctrl_y+50, btn_width, btn_width
}; // x,y,w,h
int[] vecPalette = {
  ctrl_x, ctrl_y+100, btn_width, btn_width
};
int[] vecView  = { 
  0, 0, ctrl_x, height
}; // x,y,w,h
boolean atPlus;  // True if mouseX and mouseY is in plus Button
boolean atMinus; // True if mouseX and mouseY is in minus Button
boolean atPalette;  // True if mouseX and mouseY is in main view
boolean atView;  // True if mouseX and mouseY is in main view

/***** Processing Behaviour ******************************************/

void setup() {
  size(640, 360); // Size of view port, Synchronize with width, height above
}

void draw() {
  if (mousePressed) {
    updateAtFlags(); // Update atPlus, atMinus flags
    if (atPlus) {
      zoom_in();
    } 
    else if (atMinus) {
      zoom_out();
    } 
    else if (atPalette) {
      random_palette();
    } 
    else if (atView) {
      set_target_origin(mouseX, mouseY);
    }
  }
  // Shift origin if target is different
  if ((origin_x != target_origin_x) || (origin_y != target_origin_y)) {
    step_to_origin();
  }
  if (view_needs_update) {
    update_view(origin_x, origin_y, dx, dy);
    draw_controls();
  }
}

void draw_controls() {
  image(zoomInImage,  vecPlus[0]+4, vecPlus[1]+4);
  image(zoomOutImage, vecMinus[0]+4, vecMinus[1]+4);
  image(paletteImage,  vecPalette[0]+4, vecPalette[1]+4);
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
        pixels[i+j*width] = color(n*palette[0] % 255
          , n*palette[1] % 255, n*palette[2] % 255);
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();
  view_needs_update = false;
}

void zoom_in() {
  zoom_change(ZOOM_STEP);
}

void zoom_out() {
  zoom_change(-ZOOM_STEP);
}

void zoom_change(int n) {
  if (zoom + n >= 1) {
    zoom = zoom * (1+n);
    dx = W / (width) / zoom;
    dy = H / (height) / zoom;
    view_needs_update = true;
    //println("Zoom: "+zoom);
  }
}

// Sets the target origin given posX and posY 
void set_target_origin(int posX, int posY) {
  target_origin_x = origin_x + (posX - center_x) * dx;
  target_origin_y = origin_y + (posY - center_y) * dy;
}

// Steps to origin
void step_to_origin1() {
  origin_x = target_origin_x;
  origin_y = target_origin_y;
  view_needs_update = true;
}

void step_to_origin() {
  float vec_x = target_origin_x - origin_x;
  float vec_y = target_origin_y - origin_y;
  float vec_px = vec_x / dx;
  float vec_py = vec_y / dy;

  int num_steps  = ceil(max(abs(vec_px), abs(vec_py)) / MAX_STEP_PIXELS);
  /*
  println("Vec X: " + vec_x);
   println("Vec Y: " + vec_y);
   println("Vec pX: " + vec_px);
   println("Vec pY: " + vec_py);
   println("Num steps: " + num_steps);
   */

  origin_x = origin_x + vec_x/num_steps;
  origin_y = origin_y + vec_y/num_steps;
  view_needs_update = true;
}

// Set respective flag to true if mouse at the rectangle/button 
void updateAtFlags() {
  atPlus  = (inRect(mouseX, mouseY, vecPlus));
  atMinus = (inRect(mouseX, mouseY, vecMinus));
  atPalette = (inRect(mouseX, mouseY, vecPalette));
  atView  = (inRect(mouseX, mouseY, vecView));
}

// Produce true if posX and posY is in vector 
boolean inRect(int posX, int posY, int[] vec) {
  if ((posX > vec[0]) && (posX < vec[2]+vec[0]) &&
    (posY > vec[1]) && (posY < vec[3]+vec[1]))
    return true;
  else
    return false;
}

void random_palette() {
  palette[0] = random(256); 
  palette[1] = random(256); 
  palette[2] = random(256);
  view_needs_update = true;
  //println(palette);
}

