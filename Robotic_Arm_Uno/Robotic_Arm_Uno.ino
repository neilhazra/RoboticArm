/*
 *Neil Hazra
 *Send Data via Processing: 5 floats, semicolon delimiter, add semicolons till reading newe line
 */
#include <Servo.h> 
const int precision = 3;
const int dataSizeConst = 6;
const int maxSize = 30;
float processedData[dataSizeConst];
int dataSize;
char incommingData[maxSize];
char _incommingData[maxSize];
unsigned long startingTime = 0;

Servo servo1;
Servo servo2;
Servo servo3;
Servo servo4;
Servo servo5;
Servo servo6;
Servo servo7;
void setup() {
  Serial.begin(9600);
  pinMode(19, INPUT_PULLUP); //resister for Bluetooth 
  servo1.attach(A0);
  servo2.attach(A1);
  servo3.attach(A2);
  servo4.attach(A3);
  servo5.attach(A4);
  servo6.attach(A5);
  
  servo4.write(180-180);
  servo2.write(180);
  servo3.write(15);
  servo1.write(131);
  servo5.write(70);
  servo6.write(180);
}
void serialEvent()  {
   Serial.readStringUntil('\n').toCharArray(incommingData,maxSize);
   saveData();
   convertData();
   setServos();
}
void loop() {
  /*if(Serial.available())  { 
   Serial.readStringUntil('\n').toCharArray(incommingData,maxSize);
   saveData();
   convertData();
   setServos();  
  }
  */
}
void setServos()  {
  servo4.write(180-processedData[0]);
  servo2.write(processedData[0]);
  servo3.write(processedData[1]);
  servo1.write(processedData[2]);
  servo5.write(processedData[5]);
  servo6.write(processedData[3]);
}
void convertData()  {
  for(int i = 0; i<dataSizeConst; i++)  {
    processedData[i] = processedData[i]+90;
    Serial.print(processedData[i]);
    Serial.print(" ");
  }
  Serial.println();
}
void saveData()  {
    for(int i = 0; i<50; i++)  {
      _incommingData[i] = incommingData[i];
    }
   char *p = _incommingData;
   char *str;
   char *data[dataSizeConst];
   int i = 0;
   while ((str = strtok_r(p, ";", &p)) != NULL)   {// delimiter is the semicolon
     data[i] = str;
     i++;
   }
   dataSize = i;
   for(int _i = 0; _i<i; _i++)  {
     processedData[_i] = atof(data[_i]);
   }
}
float mapf(float x, float in_min, float in_max, float out_min, float out_max)
{
  //return (x - in_min) * (out_max - out_min + 1) / (in_max - in_min + 1) + out_min;
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
