import processing.serial.*;

int serialInCount = 0;
String serialRead = "";
Serial serialPort;
float xoff = 0.0f, yoff = 300.0f, zoff = 600.0f;
float accX, accY, accZ, magX, magY, magZ;
boolean simulate = false;
boolean debug = false;


void setup() {
  size(800, 600, OPENGL);
  frameRate(30);
  smooth(8);
  serialPort = new Serial(this, Serial.list()[3], 115200);
}

void draw() {
  background(0);
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(radians(map(accX, -9.78f, 9.78f, 0, 360)));
  rotateY(radians(map(accY, -9.78f, 9.78f, 0, 180)));
  rotateZ(radians(map(accZ, -9.78f, 9.78f, 0, 180)));
  noFill();
  stroke(255);
  box(200);
  popMatrix();
	if (debug) {println(accX);}
  if (simulate) {serialEvent(serialPort);}
}


String serialSimulator() {
  //       accX accY  accZ magX   magY    magZ
  float accX, accY, accZ, magX, magY, magZ;
  accX = map(noise(xoff += 0.03f),0.0, 1.0, -10.0, 10.0);
  accY = map(noise(yoff += 0.03f),0.0, 1.0, -10.0, 10.0);
  accZ = map(noise(zoff += 0.03f),0.0, 1.0, -10.0, 10.0);
	magX = 0.0;
	magY = 0.0;
	magZ = 0.0;
  return "" + accX + ":" + accY + ":" + accZ + ":0.36:-42.00:-123.27";
}

void serialEvent(Serial serialPort) {
  String serialIn = "";
  String [] serialxyz = new String [6];
  int serialAvail;
  if (!simulate) {serialAvail = serialPort.available();}
  else {serialAvail = 1;}
  if (serialAvail > 0) {
    if (!simulate) {serialIn = serialPort.readStringUntil(10);}
    if (simulate) {serialIn = serialSimulator();}
    if (serialIn != null) {
      try {
        serialxyz = serialIn.split(":");
        accX = Float.parseFloat(serialxyz[0]);
        accY = Float.parseFloat(serialxyz[1]);
        accZ = Float.parseFloat(serialxyz[2]);
        magX = Float.parseFloat(serialxyz[3]);
        magY = Float.parseFloat(serialxyz[4]);
        magZ = Float.parseFloat(serialxyz[5]);
        if (debug) {
          println("accX: " + accX);
          println("accY: " + accY);
          println("accZ: " + accZ);
          println("magX: " + magX);
          println("magY: " + magY);
          println("magZ: " + magZ);
        }

      } catch (Exception e) {
        println("I cought: " + e);
      }
    }
  }
}
