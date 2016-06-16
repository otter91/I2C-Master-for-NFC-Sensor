//
//  I2C.h
//  Sensorknoten
//
//  Created by Stefan von Burg on 11/05/16.
//  Copyright © 2016 Berner Fachhochschule TI. All rights reserved.
//

#ifndef I2C_h
#define I2C_h

#include <Wire.h>         //I2C lib from Arduino

// Read a single byte from addressToRead and return it as a byte
uint8_t readRegister(uint8_t slaveAddress, uint8_t regToRead)
{
    Wire.beginTransmission(slaveAddress);
    Wire.write(regToRead);
    Wire.endTransmission(false); //endTransmission but keep the connection active
    uint8_t byte =1;
    Wire.requestFrom(slaveAddress, byte); //Ask for 1 byte, once done, bus is released by default

    while(!Wire.available()) ; //Wait for the data to come back
    return Wire.read(); //Return this one byte
}

// Read multiple Bytes from Register
static bool readRegisters(uint8_t slaveAddress, uint8_t regToRead, uint8_t bytesToRead, uint8_t * dest)
{
    Wire.beginTransmission(slaveAddress);
    Wire.write(regToRead);
    Wire.endTransmission(false); //endTransmission but keep the connection active
    
    uint8_t bytes = Wire.requestFrom(slaveAddress, bytesToRead); //Ask for bytes, once done, bus is released by default
    
    // return with error if not readsy
    if (bytes ==0)
        return false;
    
    while(Wire.available() < bytesToRead); //Hang out until we get the # of bytes we expect
    
    for(int x = 0 ; x < bytesToRead ; x++) {
        dest[x] = Wire.read();
    }
    
    Wire.endTransmission(true);
    
    return true; //
}

// Writes a single byte (dataToWrite) into regToWrite
bool writeRegister(uint8_t slaveAddress, uint8_t regToWrite, uint8_t dataToWrite)
{
    Wire.beginTransmission(slaveAddress);
    
    if (!Wire.write(regToWrite)) {
        return false;
    }
    if (!Wire.write(dataToWrite)) {
        return false;
    }
    
    uint8_t errorNo = Wire.endTransmission(); //Stop transmitting
    return (errorNo == 0);
}

#endif /* I2C_h */
