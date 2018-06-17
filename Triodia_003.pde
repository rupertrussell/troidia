float xCenter = 600 /2;
float yCenter = 600 /2;

float scale = 200;

boolean start = false;

// Toxi's flood fill code, updated to modern Java and Processing and to my taste... :-P
// https://forum.processing.org/one/topic/fill-tool-and-spray-tool-in-a-drawing-program.html#25080000001389423.html
FloodFill1 myFloodFill ;


void setup() {

  size(600, 600); // width x height
  background(255);
  rectMode(CENTER);
  ellipseMode(CENTER);
}



void draw() {
  if (start == false) {
    // shape();
    start = true;


    //for(int count = 0; count < 1500 ; count++){
    // troidia(random(width), random(height), int(random(20)));
    // }

    for (int size = 0; size < 255; size = size + 15) {
      stroke(255-size);
      fill(255-size);
      ellipse(300, 300, 500 - size * 1.5, 500 - size * 1.5 );
    }
  }

  loadPixels();

  myFloodFill = new FloodFill1();
  if (mousePressed) {
    myFloodFill.DoFill(mouseX, mouseY, color(255, 255, 0));
    // println("fill at mouseX " + mouseX + " mouseY " +  mouseY);
    updatePixels();
  }
}

void troidia(float x, float y, float size) {
  ellipse(x, y, size, size);
}

void keyPressed() {
  save("Triodia_003.png");
  exit();
}



// =====================================================================
// I create a class to share variables between the functions...
public class FloodFill1
{
  protected int iw; // Image width
  protected int ih; // Image height
  protected color[] imagePixels;
  protected color backColor; // Color found at given position
  protected color fillColor; // Color to apply
  protected int countPixels = 0;
  // Stack is almost deprecated and slow (synchronized).
  // I would use Deque but that's Java 1.6, excluding current (mid-2009) Macs...
  protected ArrayList stack = new ArrayList();
  //
  public FloodFill1() {
    iw = width;
    ih = height;
    imagePixels = pixels; // Assume loadPixels have been done before
  }
  //
  public FloodFill1(PImage imageToProcess) {
    iw = imageToProcess.width;
    ih = imageToProcess.height;
    imagePixels = imageToProcess.pixels; // Assume loadPixels have been done before if sketch image
  }
  //
  public void DoFill(int startX, int startY, color fc) {
    // start filling
    fillColor = fc;
    backColor = imagePixels[startX + startY * iw];
    // don't run if fill color is the same as background one
    if (fillColor == backColor)
      return;
    stack.add(new PVector(startX, startY));
    while (stack.size () > 0)
    {
      PVector p = (PVector) stack.remove(stack.size() - 1);
      // Go left
      FillScanLine((int) p.x, (int) p.y, -1);
      // Go right
      FillScanLine((int) p.x + 1, (int) p.y, 1);
    }
  }
  //
  protected void FillScanLine(int x, int y, int dir)
  {
    // compute current index in pixel buffer array
    int idx = x + y * iw;
    boolean inColorRunAbove = false;
    boolean inColorRunBelow = false;
    // fill until boundary in current scanline...
    // checking neighbouring pixel rows
    while (x >= 0 && x < iw && imagePixels[idx] == backColor)
    {
      imagePixels[idx] = fillColor;
      countPixels ++;
      if (y > 0) // Not on top line
      {
        if (imagePixels[idx - iw] == backColor)
        {
          if (!inColorRunAbove)
          {
            // The above pixel needs to be flooded too, we memorize the fact.
            // Only once per run of pixels of back color (hence the inColorRunAbove test)
            stack.add(new PVector(x, y-1));
            inColorRunAbove = true;
          }
        } else // End of color run (or none)
        {
          inColorRunAbove = false;
        }
      }
      if (y < ih - 1) // Not on bottom line
      {
        if (imagePixels[idx + iw] == backColor)
        {
          if (!inColorRunBelow)
          {
            // Idem with pixel below, remember to process there
            stack.add(new PVector(x, y + 1));
            inColorRunBelow = true;
          }
        } else // End of color run (or none)
        {
          inColorRunBelow = false;
        }
      }
      // Continue in given direction
      x += dir;
      idx += dir;
    } //
    println("countPixels = " + countPixels);
  } // func
} // class
// ----------------------------------------------------------
