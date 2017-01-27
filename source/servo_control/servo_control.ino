// type servo position 0 to 180 in serial monitor
// or for writeMicroseconds, use a value like 1500
// for IDE 0022 and later
// Powering a servo from the arduino usually *DOES NOT WORK*.

String readString,subString;
#include <Servo.h> 
Servo myservob;  // create servo object to control base servo 
Servo myservos;  // create servo object to control shoulder servo
Servo myservof;  // create servo object to control frame servo
int laser = 13;  // laser on pin 13
void setup() {
  Serial.begin(9600);
  myservob.writeMicroseconds(1500); //set initial servo position if desired
  myservob.attach(9, 500, 2300);   //the pin for the servo control, and range if desired
  myservos.writeMicroseconds(1500); //set initial servo position if desired
  myservos.attach(10,500, 2300);   
  myservof.writeMicroseconds(1300); //set initial servo position if desired
  myservof.attach(11,500, 1900);
  pinMode(laser, OUTPUT);          //pin 13 set as output
  Serial.println("servo-test-22-dual-input"); // so I can keep track of what is loaded
}
void loop() {
  while (Serial.available()) {
    char c = Serial.read();  //gets one byte from serial buffer
    readString += c; //makes the string readString
    delay(2);  //slow looping to allow buffer to fill with next character
  }
  

  if (readString.length() >0) {
  int n= readString.length();
  char p=readString[n-1];
  subString = readString.substring(0,n-1) ;
  n = subString.toInt();  //convert readString into a number
    // auto select the servo based on appended alphabet
    if(p == 'b')
    {
      Serial.print("writing BaseAngle: ");
      Serial.println(n);
      myservob.writeMicroseconds(n);
    }else if(p == 's')
    {   
      Serial.print("writing ShoulderAngle: ");
      Serial.println(n);
      myservos.writeMicroseconds(n);
    }else if(p == 'f')
    {   
      Serial.print("writing FrameAngle: ");
      Serial.println(n);
      myservof.writeMicroseconds(n);
    }
    //Switching laser
    if(readString == "ON")
    {
      Serial.print("Turning on laser ");
      digitalWrite(laser, HIGH); //turn on laser
    }else if(readString == "OFF")
    {
      Serial.print("Turning off laser ");
      digitalWrite(laser, LOW); //turn off laser
    }
    readString=""; //empty for next input
  } }

