#include "ArduinoBLE.h"
#include "LSM6DS3.h"
#include "Wire.h"

LSM6DS3 myIMU(I2C_MODE, 0x6A); //I2C device address 0x6A
BLEService sensorService("19B10000-E8F2-537E-4F6C-D104768A1214"); // BLE Service
BLEStringCharacteristic sensorChar("19B10001-E8F2-537E-4F6C-D104768A1214", BLERead | BLENotify, 200); 

float prevAccelX = 0;
float prevAccelY = 0;
float prevAccelZ = 0;

void setup() {
  Serial.begin(9600);  
  while (!Serial); 

  if (myIMU.begin() != 0) {
    Serial.println("Device error");
  } else {
    Serial.println("Device OK!");
  }
  
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");
    while (1);
  }

  BLE.setLocalName("IMU Sensor");
  BLE.setAdvertisedService(sensorService);
  
  sensorService.addCharacteristic(sensorChar);
  BLE.addService(sensorService);
  BLE.advertise();

  Serial.println("Bluetooth device active, waiting for connections...");
}

void loop() {
  BLEDevice central = BLE.central();

  if (central) {
    Serial.print("Connected to central: ");
    Serial.println(central.address());
    while (central.connected()) {
      float accelX = myIMU.readFloatAccelX();
      float accelY = myIMU.readFloatAccelY();
      float accelZ = myIMU.readFloatAccelZ() - 1.0;
      
      float deltaAccelX = accelX - prevAccelX;
      float deltaAccelY = accelY - prevAccelY;
      float deltaAccelZ = accelZ - prevAccelZ;
      
      prevAccelX = accelX;
      prevAccelY = accelY;
      prevAccelZ = accelZ;
      
      float gyroX = myIMU.readFloatGyroX();
      float gyroY = myIMU.readFloatGyroY();
      float gyroZ = myIMU.readFloatGyroZ();

      float impactMagnitude = sqrt(deltaAccelX * deltaAccelX + deltaAccelY * deltaAccelY + deltaAccelZ * deltaAccelZ);

      String sensorData = "Accelerometer: X=" + String(accelX) + " Y=" + String(accelY) + " Z=" + String(accelZ) + "\n";
      sensorData += "Gyroscope: X=" + String(gyroX) + " Y=" + String(gyroY) + " Z=" + String(gyroZ) + "\n";
      sensorData += "Impact Magnitude: " + String(impactMagnitude);
      
      sensorChar.writeValue(sensorData);
      Serial.println(sensorData);

      delay(1000);
    }
    
    Serial.print("Disconnected from central: ");
    Serial.println(central.address());
  }
}