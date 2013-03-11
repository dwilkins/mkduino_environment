#include <Arduino.h>
#include <HardwareSerial.h>

extern "C" void __cxa_pure_virtual(void) {
    while(1);
}

void setup() {
  Serial.begin(115200);
}

void loop() {
}

int main(void)
{
  init();
  setup();
  for (;;)
    loop();
  return 0;
}
