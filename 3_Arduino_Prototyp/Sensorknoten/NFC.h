//
//  NFC.h
//  Sensorknoten
//
//  Created by Stefan von Burg on 24/05/16.
//  Copyright © 2016 Berner Fachhochschule TI. All rights reserved.
//

#ifndef NFC_h
#define NFC_h

#include "I2C.h"
#include "add_registry.h"

static bool writeBufferRegister(uint8_t slaveAddress, byte regToWrite, const uint8_t* dataToWrite, uint16_t dataLen) {
    Wire.beginTransmission(slaveAddress);
    
    if (!Wire.write(regToWrite))
        return false;
    
    if (Wire.write(dataToWrite, dataLen)!= dataLen)
        return false;
    
    if (Wire.endTransmission()!=0) //Stop transmitting
        return false;
    
    return true;
}

bool NT3H1101_C::readManufacturingData(uint8_t nfcPageBuffer[]) {
    return readRegisters(_address, MANUFACTURING_DATA_REG, NFC_PAGE_SIZE, nfcPageBuffer);
}

bool NT3H1101_C::readUID(uint8_t nfcPageBuffer[]) {
    return readRegisters(_address, MANUFACTURING_DATA_REG, UID_SIZE, nfcPageBuffer);
}

bool NT3H1101_C::readUserPage(uint8_t userPagePtr, uint8_t nfcPageBuffer[]) {
    uint8_t reg = USER_START_REG+userPagePtr;
    
    // if the requested page is out of the register exit with error
    if (reg > USER_END_REG) {
        return false;
    }
    
    return  readRegisters(_address, reg, NFC_PAGE_SIZE, nfcPageBuffer);
    
}

bool NT3H1101_C::writeUserPage(uint8_t userPagePtr, const uint8_t nfcPageBuffer[]) {
    
    
    uint8_t reg = USER_START_REG+userPagePtr;
    
    if (reg > USER_END_REG) {
        return false;
    }
    
    bool ret = writeBufferRegister(_address, reg, nfcPageBuffer, NFC_PAGE_SIZE);
    if (ret)
        delay(100); // give some time to NC for store the buffer
    
    return ret;
}

#endif /* NFC_h */
