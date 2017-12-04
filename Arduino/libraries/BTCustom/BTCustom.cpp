#include <Arduino.h>
#ifndef BTCustom_h
#define BTCustom_h
#include <BTCustom.h>
#endif


BTCustom::BTCustom(int RXPin, int TXPin) {
    _rx = RXPin;
    _tx = TXPin;
    UART = new SoftwareSerial(_rx, _tx);
    UART->begin(9600);
    timeout=800;

}

bool BTCustom::command(long timeout, char* command, char* temp) {
    long endtime;
    boolean found=false;
    endtime=millis()+timeout;           //
    memset(temp,0,100);                 // clear buffer
    found=true;
    UART->print(command);

    while(!UART->available()){
        if(millis()>endtime) {          // timeout, break
            found=false;
            break;
        }
    }

    if (found) {                        // response is available
        int i=0;
        while(UART->available()) {        // loop and read the data
            char a=UART->read();
            // Serial.print((char)a);   // Uncomment this to see raw data from BLE
            temp[i]=a;                  // save data to buffer
            i++;
            if (i>=100) break;    // prevent buffer overflow, need to break
            delay(1);                       // give it a 2ms delay before reading next character
        }
        return true;
    } else {
        Serial.println("BLE timeout!");
        return false;
    }
}

String BTCustom::read() {
    if(UART->available()) {
        String result = UART->readString();
        return result;
    }
    return "";
}

