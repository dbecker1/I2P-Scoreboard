#include "Arduino.h"
#include <SoftwareSerial.h>

class BTCustom
{
    public:
        BTCustom(int RXPin, int TXPin);
        bool command(long timeout, char* command, char* temp);
        String read();
    private:
        int _rx;
        int _tx;
        int timeout;
        SoftwareSerial * UART;
};