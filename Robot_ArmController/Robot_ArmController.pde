/*
 *Neil Hazra
 *Send Data to Arduino to drive 5 servos
 *Poll Data from Logitech Joystick
*/
int portNum = 2;

import procontroll.*;
import java.io.*;
import processing.serial.*;

ControllIO controll;
ControllDevice device;
ControllStick stick;
ControllStick stick2;
ControllButton button;
boolean buttonAStatus = false;
Serial port;
int _w,w = 0;
int _x,x = 0;
int _y,y = 0;
int _z,z = 0;
int _r,r = 0;
float e = 0;

void setup() {
  size(550, 100);
  textSize(20);
  controll = ControllIO.getInstance(this);
  println(Serial.list().length);
  for (int i = 0; i<Serial.list().length; i ++)  {
    print(Serial.list()[i]);
    print(" ");
    println(i);
  }
  port = new Serial(this, Serial.list()[portNum], 9600);
  port.bufferUntil('\n');
  port.write("0;0;0;0;0\n" );
  device = controll.getDevice("Logitech Dual Action");
  stick2 = device.getStick("X Axis Y Axis");
  stick = device.getStick("Z Axis Z Rotation");
  stick.setTolerance(0.05f);
  stick.setMultiplier(-90);
  stick2.setTolerance(0.05f);
  stick2.setMultiplier(-90);
  
  device.plug(this, "turnRight", ControllIO.WHILE_PRESS, 6);
  device.plug(this, "turnLeft", ControllIO.WHILE_PRESS, 5);
  device.plug(this, "pollButton",ControllIO.ON_PRESS, 1);
  
  delay(1000); //initialize it
 
  thread("changeW");
  thread("changeX");
  thread("changeY");
  thread("changeZ");
}
void turnRight(){
  e += 1;
  if(e>90)  {
    e=90;
  }
  delay(20);
}
void turnLeft(){
  e += -1;
  if(e<-90)  {
    e=-90;
  }
  delay(20);
}
void incrementW()  {
   _w += 1;
  if(_w>90)  {
    _w = 90;
  }
  delay((int)map(abs(w),0,90,80,10));
}
void decrementW()  {
   _w += -1;
  if(_w < -90)  {
    _w = -90;
  }
  delay((int)map(abs(w),0,90,80,10));
}

void incrementX()  {
   _x += 1;
  if(_x>90)  {
    _x = 90;
  }
  delay((int)map(abs(x),0,90,80,10));
}
void decrementX()  {
   _x += -1;
  if(_x < -75)  {
    _x = -75;
  }
  delay((int)map(abs(x),0,90,80,10));
}

void incrementY()  {
   _y += 1;
  if(_y>90)  {
    _y = 90;
  }
  delay((int)map(abs(y),0,90,80,10));
}
void decrementY()  {
   _y += -1;
  if(_y < -90)  {
    _y = -90;
  }
  delay((int)map(abs(y),0,90,80,10));
}

void incrementZ()  {
   _z += 1;
  if(_z>90)  {
    _z = 90;
  }
  delay((int)map(abs(z),0,90,80,10));
}
void decrementZ()  {
   _z += -1;
  if(_z < -90)  {
    _z = -90;
  }
  delay((int)map(abs(z),0,90,80,10));
}

void changeW()  {
  while(true)  {
  if(w > 0)  {
     incrementW(); 
  }
  if (w < 0)  {
     decrementW(); 
  }
  }
}  
void changeX()  {
  while(true)  {
  if(x > 0)  {
     incrementX(); 
  }
  if (x < 0)  {
     decrementX(); 
  }
  }
}    
  void changeY()  {
  while(true)  {
  if(y > 0)  {
     incrementY(); 
  }
  if (y < 0)  {
     decrementY(); 
  }
  }
}  
void changeZ()  {
  while(true)  {
  if(z > 0)  {
     incrementZ(); 
  }
  if (z < 0)  {
     decrementZ(); 
  }
  }
}  
void pollButton()  {
        buttonAStatus = !buttonAStatus; 
}
void serialEvent(Serial p)  {
  text(p.readString(), 10, 60);
  text("Robotic Arm by Lucas Tjom and Neil Hazra", 10, 30);
}
int boolToInt(boolean a)  {
  int b = 0;
  if(a)  {
    b = -20;
  } else  {
    b = -90;
  }
  return b;
}

void draw() {  
  background(150);
  float a = stick2.getY();
  float b = -stick.getY();
  float c = stick2.getX();
  float d = -stick.getX();
  w = round(a);
  x = round(b);
  y = round(c);
  z = round(d);
/////////////////////////////////////////////////      
  ///////////////////////////////////////////////////////
  String string;
  string = _w +";" + _x + ";" + _y + ";" + _z +";" + e + ";" +  boolToInt(buttonAStatus) + "\n";
  port.write(string);
  delay(55); //Don't lower this value, if arduino suddenly stops receiving, increase this value
}
