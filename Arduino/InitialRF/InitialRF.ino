#include <RCSwitch.h>

RCSwitch mySwitch = RCSwitch();
int noCount = 0;
int score;
void setup() {
  Serial.begin(9600);
  mySwitch.enableReceive(0);  // Receiver on interrupt 0 => that is pin #2
  score = 0;
}

void loop() {
  if (mySwitch.available() && noCount > 30) {
    int value = mySwitch.getReceivedValue();
    mySwitch.resetAvailable();
    
    Serial.println(value);
    noCount = 0;
    
  }  else {
    noCount++;
  }
}
