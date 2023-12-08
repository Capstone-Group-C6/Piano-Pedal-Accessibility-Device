/*

  Piano Pedal Replication Device Firmware V3

*/

#include <ArduinoBLE.h>

#define NUMPEDALS 3

static int MPIO0 = 36; //labelled on board as 16 
static int MPIO1 = 37; //labelled on board as 17
static int MPIO2 = 38; //labelled on board as 5
static int MPIO3 = 39; //labelled on board as 18
static int MPIO4 = 40; //labelled on board as 19

static int pedal0 = 8; //labelled on board as 14
static int pedal1 = 19; //labelled on board as 27
static int pedal2 = 20; //labelled on board as 12

void setPedalAndLED(int pedalNum, uint8_t state) {
  switch (pedalNum) {
    case 0:
      digitalWrite(pedal0, state);
      digitalWrite(MPIO0, state);
      break;
    case 1:
      digitalWrite(pedal1, state);
      digitalWrite(MPIO1, state);
      break;
    case 2:
      digitalWrite(pedal2, state);
      digitalWrite(MPIO2, state);
      break;
  }
}

void resetPedalsAndLEDs() {
  for (int i = 0; i < NUMPEDALS; i++) {
    setPedalAndLED(i, LOW);
  }
}

void setup() {
  Serial.begin(115200);
  while (!Serial);
  Serial.println("PPAD - Replication Device");

  // configure the multi-purpose IOs as outputs
  pinMode(MPIO0, OUTPUT);
  pinMode(MPIO1, OUTPUT);
  pinMode(MPIO2, OUTPUT);
  pinMode(MPIO3, OUTPUT);
  pinMode(MPIO4, OUTPUT);

  // configure the pedals as outputs
  pinMode(pedal0, OUTPUT);
  pinMode(pedal1, OUTPUT);
  pinMode(pedal2, OUTPUT);

  // initialize the Bluetooth® Low Energy hardware
  BLE.begin();
  Serial.println("Starting BLE...");
  

  // start scanning for peripherals
  BLE.scanForUuid("ac6c445f-58e8-4c22-a2fc-191199030025");
}

void loop() {
  // check if a peripheral has been discovered
  BLEDevice peripheral = BLE.available();

  if (peripheral) {
    Serial.print("Found ");
    Serial.print(peripheral.address());
    Serial.print(" '");
    Serial.print(peripheral.localName());
    Serial.print("' ");
    Serial.print(peripheral.advertisedServiceUuid());
    Serial.println();

    // stop scanning
    BLE.stopScan();

    controlLed(peripheral);

    // peripheral disconnected, start scanning again
    BLE.scanForUuid("ac6c445f-58e8-4c22-a2fc-191199030025");
  }
}

void controlLed(BLEDevice peripheral) {
  // connect to the peripheral
  Serial.println("Connecting ...");

  if (peripheral.connect()) {
    Serial.println("Connected");
    digitalWrite(MPIO3, HIGH);
  } else {
    Serial.println("Failed to connect!");
    return;
  }

  // discover peripheral attributes
  Serial.println("Discovering attributes ...");
  if (peripheral.discoverAttributes()) {
    Serial.println("Attributes discovered");
  } else {
    Serial.println("Attribute discovery failed!");
    peripheral.disconnect();
    return;
  }

  BLECharacteristic pianoCharacteristic = peripheral.characteristic("3d04e7ac-13f2-4713-ae66-d67b80a4c5a3");

  if (!pianoCharacteristic) {
    Serial.println("Peripheral does not have the characteristic!");
    peripheral.disconnect();
    return;
  }

  while (peripheral.connected()) {
    // while the peripheral is connected

    // Subscribe to the ppad characteristic
    pianoCharacteristic.subscribe();
    
    while(peripheral.connected()) {
      if(pianoCharacteristic.valueUpdated()){
        byte value = 0;
        char* valPointer = (char*) &value;
        pianoCharacteristic.readValue(value);
        
        // If value is in character format, convert to byte
        if (value >= 8)
          value = (byte) atoi((char*) valPointer);

        Serial.println(value, BIN); // show the binary value 

        if (value & 0b00000100) {
          setPedalAndLED(0, HIGH);
        } else {
          setPedalAndLED(0, LOW);
        }

        if (value & 0b00000010) {
          setPedalAndLED(1, HIGH);
        } else {
          setPedalAndLED(1, LOW);
        }

        if (value & 0b00000001) {
          setPedalAndLED(2, HIGH);
        } else {
          setPedalAndLED(2, LOW);
        }
      }
    }
  }

  digitalWrite(MPIO3, LOW);
  resetPedalsAndLEDs();
  Serial.println("Peripheral disconnected");
}
