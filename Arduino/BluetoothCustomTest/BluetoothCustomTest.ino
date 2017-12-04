#include <SoftwareSerial.h>
#include <BTCustom.h>

BTCustom BT(10,11);

int homeScore = 0;
int awayScore = 0;

int timeout=800;
char buffer[100];
boolean connected = false;

void setup() {
  Serial.begin(9600);
  Serial.print("Home: 0");
  Serial.println(" Away: 0");

  BT.command(timeout, "AT" ,buffer);
  BT.command(timeout, "AT+NAME?" ,buffer);
  Serial.println(buffer);
        
  Serial.println("----------------------");
  Serial.println("Waiting for remote connection...");

}

void loop() {
  String current = BT.read();
  if (current.length() != 0) {
    if(current == "OK+CONN") {
      Serial.println("Connected");
      connected = true;
    } else if (current == "OK+LOST"){
      Serial.println("Disconnected");
      connected = false;
    } else {
      int index = current.indexOf("|");
      String homeString = current.substring(0, index);
      String awayString = current.substring(index + 1);
      homeScore = homeString.toInt();
      awayScore = awayString.toInt();
      Serial.print("Home: " + homeString);
      Serial.println(" Away: " + awayString);
    }
  }

}
