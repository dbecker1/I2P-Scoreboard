#include <SoftwareSerial.h>

SoftwareSerial BTSerial(4,5);
void setup() {
  String setName = String("AT+NAME=MyBTBee\r\n"); //Setting name as 'MyBTBee'
  Serial.begin(9600);
  Serial.println("Starting");
  BTSerial.begin(38400);
  BTSerial.print("AT\r\n"); //Check Status
  delay(500);
  while (BTSerial.available()) {
      Serial.write(BTSerial.read());
    }
  BTSerial.print(setName); //Send Command to change the name
  delay(500);
  while (BTSerial.available()) {
      Serial.write(BTSerial.read());
  }
  Serial.println("Done");
}
void loop() {}
