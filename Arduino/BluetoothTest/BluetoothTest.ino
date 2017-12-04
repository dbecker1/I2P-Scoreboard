#include <SoftwareSerial.h>

SoftwareSerial BLE_Shield(4,5);

void setup() {
  BLE_Shield.begin(9600);
  Serial.begin(4800);
}

void loop() {
  if (BLE_Shield.available()) {
    Serial.println(BLE_Shield.read());
  }
}
