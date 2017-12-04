#include <SoftwareSerial.h>
#include <BTCustom.h>
#include <SimpleTimer.h>

const int rxPin = 10;
const int txPin = 13;
const int latchPin = 8;
const int clockPin = 12;
const int dataPin = 11;
const int buzzerPin = 9;

const int buzzerDuration = 2;
const int buzzerFrequency = 250;

static int homeScore = 0;
static int awayScore = 0;
static int timerMinutes = 0;
static int timerSeconds = 0;

bool countingDown = false;
bool buzzPossible = false;
int timerId;

BTCustom BT(rxPin,txPin);
SimpleTimer timer;

int timeout=800;
char buffer[100];

int numbers[] = {119,36,93,109,46,107,123,37,127,111};

void decreaseTime() {
  if (countingDown) {
    timerSeconds--;
    if (timerSeconds < 0) {
      timerSeconds = 59;
      timerMinutes--;
    }
    if (timerMinutes < 0) {
      timerSeconds = 0;
      timerMinutes = 0;
      if (buzzPossible) {
        tone(buzzerPin, buzzerFrequency, buzzerDuration * 1000);
        buzzPossible = false;
      }
    }
    Serial.print(timerMinutes);
    Serial.print(":");
    Serial.println(timerSeconds);
  }
}

void setup() {
  Serial.begin(9600);

  BT.command(timeout, "AT" ,buffer);
  BT.command(timeout, "AT+NAME?" ,buffer);
  Serial.println(buffer);
  
  pinMode(latchPin, OUTPUT);

  // Set all digits to 0
  digitalWrite(latchPin, 0);
  for (int i = 0; i < 8; i++) {
    shiftOut(numbers[0]);
  }
  digitalWrite(latchPin, 1);

  timer.setInterval(1000, decreaseTime);
}

void loop() {
  timer.run();
  //Read Bluetooth Values
  String current = BT.read();
  if (current.length() != 0) {
    if (current == "OK+CONN") {
      Serial.println("Bluetooth Connected");
    } else if (current == "OK+LOST") {
      Serial.println("Bluetooth Disconnected");
    } else if (current.startsWith("SCORE")) {
      if (current.charAt(6) == 'H' && current.charAt(8) == 'U') {
        Serial.println("Increase Home Score");
        homeScore++;
      } else if (current.charAt(6) == 'H' && current.charAt(8) == 'D') {
        Serial.println("Decrease Home Score");
        homeScore--;
      } else if (current.charAt(6) == 'A' && current.charAt(8) == 'U') {
        Serial.println("Increase Away Score");
        awayScore++;
      } else {
        Serial.println("Decrease Away Score");
        awayScore--;
      }
    } else if (current.startsWith("TIMERSET")) {
      String minuteString = current.substring(9, 11);
      String secondString = current.substring(12, 14);
      timerMinutes = minuteString.toInt();
      timerSeconds = secondString.toInt();
      Serial.println("Setting Timer: " + minuteString + ":" + secondString);
    } else if (current.startsWith("TIMERSTART")) {
      Serial.println("Starting Timer");
      countingDown = true;
      buzzPossible = true;
    } else if (current.startsWith("TIMERSTOP")) {
      Serial.println("Stopping Timer");
      countingDown = false;
      buzzPossible = false;
    }
  }

  if (homeScore > 99) {
    homeScore = 99;
  } else if (homeScore < 0) {
    homeScore = 0;
  }
  if (awayScore > 99) {
    awayScore = 99;
  } else if (awayScore < 0) {
    awayScore = 0;
  }

  // Print out values
  digitalWrite(latchPin, 0);
  shiftOut(numbers[awayScore % 10]);
  shiftOut(numbers[awayScore / 10]);
  shiftOut(numbers[timerSeconds % 10]);
  shiftOut(numbers[timerSeconds / 10]);
  shiftOut(numbers[timerMinutes % 10]);
  shiftOut(numbers[timerMinutes / 10]);
  shiftOut(numbers[homeScore % 10]);
  shiftOut(numbers[homeScore / 10]);
  digitalWrite(latchPin, 1);
}

void shiftOut(byte dataOut) {
  int i=0;
  int pinState;
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  digitalWrite(dataPin, 0);
  digitalWrite(clockPin, 0);
  for (i=7; i>=0; i--)  {
    digitalWrite(clockPin, 0);
    if ( dataOut & (1<<i) ) {
      pinState= 1;
    }
    else {  
      pinState= 0;
    }
    digitalWrite(dataPin, pinState);
    digitalWrite(clockPin, 1);
    digitalWrite(dataPin, 0);
  }
  digitalWrite(clockPin, 0);
}
