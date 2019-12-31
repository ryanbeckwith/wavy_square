class WavyLine
{
  float x1, y1, x2, y2;
  float speed, xCurrent, yCurrent;
  float ellipseWidth1, ellipseHeight1, ellipseWidth2, ellipseHeight2;
  float startAngle1, startAngle2;
  float lenCurrent, len, heightFactor, dotSize;
  boolean started, drawDot;
  
  void wavyLineDefaults()
  {
    xCurrent = x1;
    yCurrent = y1;
    len = dist(x1, y1, x2, y2);
    lenCurrent = dist(x1, y1, xCurrent, yCurrent);
    ellipseWidth1 = 100;
    ellipseHeight1 = 100;
    ellipseWidth2 = 100;
    ellipseHeight2 = 100;
    startAngle1 = atan((y2 - y1) / (x2 - x1));
    startAngle2 = startAngle1 + PI;
    dotSize = 10.0;
    started = false;
    drawDot = true;
  }
  
  WavyLine()
  {
    x1 = width/2.0 - 200;
    x2 = width/2.0 + 200;
    y1 = height/2.0 + 50;
    y2 = height/2.0 - 50;
    speed = 10;
    heightFactor = 10.0;
    wavyLineDefaults();
  }
  
  WavyLine(float xPos1, float yPos1, float xPos2, float yPos2, float spd, float hFactor)
  {
    x1 = xPos1;
    y1 = yPos1;
    x2 = xPos2;
    y2 = yPos2;
    speed = spd;
    heightFactor = hFactor;
    wavyLineDefaults();
  }
  
  WavyLine(float xPos1, float yPos1, float xPos2, float yPos2, float hFactor)
  {
    x1 = xPos1;
    y1 = yPos1;
    x2 = xPos2;
    y2 = yPos2;
    heightFactor = hFactor;
    wavyLineDefaults();
    speed = 10;
  }
  
  void accurateSpeed(float speedFactor)
  {
    speed = len / frameRate / speedFactor;
  }
  
  void display()
  {
    //line(x1, y1, x2, y2);
    if (!started)
    {
      line(x1, y1, x2, y2);
    }
    else
    {
      float xArc1 = (xCurrent + x1) / 2.0;
      float yArc1 = (yCurrent + y1) / 2.0;
      float xArc2 = (xCurrent + x2) / 2.0;
      float yArc2 = (yCurrent + y2) / 2.0;
      
      lenCurrent = dist(x1, y1, xCurrent, yCurrent);
      
      ellipseWidth1 = lenCurrent;
      ellipseWidth2 = len - ellipseWidth1;
      
      ellipseHeight1 = len / heightFactor * exp(-1 * pow((lenCurrent - len / 2.0) / (len / 4.0), 2));
      ellipseHeight2 = ellipseHeight1;
      
      pushMatrix();
      translate(xArc1, yArc1);
      rotate(startAngle1);
      arc(0, 0, ellipseWidth1, ellipseHeight1, 0, PI);
      popMatrix();
      pushMatrix();
      translate(xArc2, yArc2);
      rotate(startAngle2);
      arc(0, 0, ellipseWidth2, ellipseHeight2, 0, PI);
      popMatrix();
      
      if (drawDot)
      {
        fill(255);
        circle(xCurrent, yCurrent, dotSize);
        noFill();
      }
      
      if (lenCurrent + speed < len)
      {
        xCurrent += speed / len * (x2 - x1);
        yCurrent += speed / len * (y2 - y1);
      }
      else
      {
        xCurrent = x1;
        yCurrent = y1;
      }
    }
  }
}

ArrayList<WavyLine> wavyLines = new ArrayList<WavyLine>();
ArrayList<WavyLine> wavyLines2 = new ArrayList<WavyLine>();
boolean spacePressed = false;
boolean beingDragged = false;
boolean wPressed = false;
float squareSide = 600;
float eHeight = 10.0;
float r, g, b;

void setup()
{
  size(1600, 950);
  background(0);
  stroke(255);
  strokeWeight(1);
  noFill();
  r = 255;
  g = 255;
  b = 255;
  
  for (int i = 0; i <= squareSide; i += 20)
  {
    wavyLines.add(new WavyLine((width / 2.0 - squareSide / 2.0) + i, (height / 2.0 - squareSide / 2.0), (width / 2.0 + squareSide / 2.0), (height / 2.0 - squareSide / 2.0) + i, eHeight));
    wavyLines.add(new WavyLine((width / 2.0 + squareSide / 2.0), (height / 2.0 - squareSide / 2.0) + i, (width / 2.0 + squareSide / 2.0) - i, (height / 2.0 + squareSide / 2.0), eHeight));
    wavyLines.add(new WavyLine((width / 2.0 + squareSide / 2.0) - i, (height / 2.0 + squareSide / 2.0), (width / 2.0 - squareSide / 2.0), (height / 2.0 + squareSide / 2.0) - i, eHeight));
    wavyLines.add(new WavyLine((width / 2.0 - squareSide / 2.0), (height / 2.0 + squareSide / 2.0) - i, (width / 2.0 - squareSide / 2.0) + i, (height / 2.0 - squareSide / 2.0), eHeight));
  }
  for (int i = 0; i <= wavyLines.size(); i++)
  {
    for (int j = i + 1; j < wavyLines.size(); j++)
    {
      wavyLines2.add(new WavyLine(wavyLines.get(i).xCurrent, wavyLines.get(i).yCurrent, wavyLines.get(j).xCurrent, wavyLines.get(j).yCurrent, 10));
    }  
  }
}
  
void draw()
{
  background(0);
  line(width / 2.0 - squareSide / 2.0, height / 2.0 - squareSide / 2.0, width / 2.0 + squareSide / 2.0, height / 2.0 - squareSide / 2.0);
  line(width / 2.0 + squareSide / 2.0, height / 2.0 - squareSide / 2.0, width / 2.0 + squareSide / 2.0, height / 2.0 + squareSide / 2.0);
  line(width / 2.0 + squareSide / 2.0, height / 2.0 + squareSide / 2.0, width / 2.0 - squareSide / 2.0, height / 2.0 + squareSide / 2.0);
  line(width / 2.0 - squareSide / 2.0, height / 2.0 + squareSide / 2.0, width / 2.0 - squareSide / 2.0, height / 2.0 - squareSide / 2.0);
  for (int i = 0; i < wavyLines.size(); i++)
  {
    stroke(r, g, b, wavyLines.get(i).ellipseHeight1 / wavyLines.get(i).len * wavyLines.get(i).heightFactor * 200.0);
    //text("Line " + i + ": " + wavyLines.get(i).speed, width - 150, 50 + i * 15);
    if (spacePressed)
    {
      wavyLines.get(i).started = true;
    }
    if (!beingDragged)
    {
      wavyLines.get(i).accurateSpeed(10.0);
    }
    else
    {
      wavyLines.get(i).speed = 0;
    }
    if (wPressed)
    {
      strokeWeight(2);
    }
    wavyLines.get(i).display();
  }
  
  for (int i = 0; i < wavyLines2.size(); i++)
  {
    //wavyLines2.get(i).drawDot = false;
    wavyLines2.get(i).dotSize = 5;
    if (spacePressed)
    {
      wavyLines2.get(i).started = true;
    }
    if (!beingDragged)
    {
      wavyLines2.get(i).accurateSpeed(10.0);
    }
    else
    {
      wavyLines2.get(i).speed = 0;
    }
    if (wPressed)
    {
      strokeWeight(2);
    }
    //wavyLines2.get(i).display();
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    spacePressed = true;
  }
  if (key == 'w')
  {
    wPressed = true;
  }
}

void keyReleased()
{
  if (key == 'w')
  {
    wPressed = false;
  }
}

void mouseDragged()
{
  beingDragged = true;
  for (int i = 0; i < wavyLines.size(); i++)
  {
    wavyLines.get(i).heightFactor = mouseY / 100.0;
  }
  for (int i = 0; i < wavyLines2.size(); i++)
  {
    wavyLines2.get(i).heightFactor = mouseY / 100.0;
  }
}

void mouseReleased()
{
  beingDragged = false;
}
