//
//  LPS25HB.h
//  Sensorknoten
//
//  Created by Stefan von Burg on 17/05/16.
//  Copyright © 2016 Berner Fachhochschule TI. All rights reserved.
//

#ifndef LPS25HB_h
#define LPS25HB_h

#include "I2C.h" 
#include "add_registry.h"

#define BNP "%d%d%d%d%d%d%d%d"
#define B2N(byte)  \
(byte & 0x80 ? 1 : 0), \
(byte & 0x40 ? 1 : 0), \
(byte & 0x20 ? 1 : 0), \
(byte & 0x10 ? 1 : 0), \
(byte & 0x08 ? 1 : 0), \
(byte & 0x04 ? 1 : 0), \
(byte & 0x02 ? 1 : 0), \
(byte & 0x01 ? 1 : 0)


// WHO_AM_I LPS
void Identify_LPS(void)
{
    uint8_t data;
    data = readRegister(LPS25H_ADDRESS,WHO_AM_I_LPS);
    Serial.print("WHO_AM_I Response LPS :          ");
    Serial.println(data);
}

//Auslesen der Reference Register LPS
void Reference_Reg(int res1, int res2, int res3)
{
    uint8_t data;
    writeRegister(LPS25H_ADDRESS,REF_P_XL,res1);
    writeRegister(LPS25H_ADDRESS,REF_P_L,res2);
    writeRegister(LPS25H_ADDRESS,REF_P_H,res3);
    data = readRegister(LPS25H_ADDRESS, REF_P_XL);
    Serial.print("Reference Pressure LSB :         ");
    Serial.println(data);
    data = readRegister(LPS25H_ADDRESS, REF_P_L);
    Serial.print("Reference Pressure middle part : ");
    Serial.println(data);
    data = readRegister(LPS25H_ADDRESS, REF_P_H);
    Serial.print("Reference Pressure MSB :         ");
    Serial.println(data);
}

//Einstellen der Ausgabe der Auflösung LPS
void Resolution_Set_LPS(int data)// data darf zwischen 0 und 15 sein -> Resolution Configuration Datasheet S.27
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,RES_CONF_REG,data);
    data = readRegister(LPS25H_ADDRESS, RES_CONF_REG);
    Serial.print("Auflösung LPS:                   ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}

//Einstellen der CTRL_REG1 LPS
void CTRL_REG1_Set(int data)// Control Register Legende Datasheet S.28
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,CTRL_REG1,data);
    data = readRegister(LPS25H_ADDRESS, CTRL_REG1);
    Serial.print("Control register 1:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}
//Einstellen der CTRL_REG2 LPS
void CTRL_REG2_Set(int data)// Control Register Legende Datasheet S.29
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,CTRL_REG2,data);
    data = readRegister(LPS25H_ADDRESS, CTRL_REG2);
    Serial.print("Control register 2:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}
//Einstellen der CTRL_REG3 LPS Interrupt Control
void CTRL_REG3_Set(int data)// Interrupt Register Legende Datasheet S.30
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,CTRL_REG3,data);
    data = readRegister(LPS25H_ADDRESS, CTRL_REG3);
    Serial.print("Control register 3:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}
//Einstellen der CTRL_REG4 LPS Interrupt Configuration
void CTRL_REG4_Set(int data)// Interrupt Configuration Legende Datasheet S.31
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,CTRL_REG4,data);
    data = readRegister(LPS25H_ADDRESS, CTRL_REG4);
    Serial.print("Control register 4:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}
//Auslesen des Status register LPS
void Status_LPS()
{
    char *datas     = "00000000\n";
    int data;
    data = readRegister(LPS25H_ADDRESS, STATUS_REG);
    Serial.print("Status register:                 ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}
//Auslesen der Sensordaten
double readTemperature_LPS()
{
    uint8_t data [2];
    double temperature;
    
    data[0] = readRegister(LPS25H_ADDRESS, 0x2B); //LSB
    data[1] = readRegister(LPS25H_ADDRESS, 0x2C); //MSB
    temperature = (int16_t)data[1] << 8 | (uint16_t)data[0];
    temperature = 42.5 +((int16_t)temperature/480.0);
    
    return temperature;
}
double readPressure()
{
    uint8_t data [3];
    double pressure = 0;
    char *datas     = "00000000\n";
    
    data[0] = readRegister(LPS25H_ADDRESS, 0x28); //LSB       PRESSURE_XL_REG
    data[1] = readRegister(LPS25H_ADDRESS, 0x29);  //mid Part PRESSURE_L_REG
    data[2] = readRegister(LPS25H_ADDRESS, 0x2A);  //MSB      PRESSURE_H_REG
    sprintf(datas,BNP, B2N(data[0])); // Dezimal to Binary
    Serial.print("LSB of Pressure:                 ");
    Serial.println(datas);
    sprintf(datas,BNP, B2N(data[1])); // Dezimal to Binary
    Serial.print("MID of Pressure:                 ");
    Serial.println(datas);
    sprintf(datas,BNP, B2N(data[2])); // Dezimal to Binary
    Serial.print("MSB of Pressure:                 ");
    Serial.println(datas);
    pressure = (uint32_t)data[2] << 16 | (uint32_t)data[1] << 8 | (uint32_t)data[0];       //erstellen des 24 Bit 2er Komplement
    pressure = pressure/4069;
    return pressure;
}
//Einstellen der THS_P_L LPS
void THS_P_Lf(int data)// Threshhold value Datasheet S.37
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,THS_P_L,data);
    data = readRegister(LPS25H_ADDRESS, THS_P_L);
    Serial.print("THS_P_L:                         ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);

}
//Einstellen der THS_P_H LPS
void THS_P_Hf(int data)// Threshhold value Datasheet S.37
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,THS_P_H,data);
    data = readRegister(LPS25H_ADDRESS, THS_P_H);
    Serial.print("THS_P_H:                         ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);

}
//Einstellen der RPDS_L LPS
void RPDS_Lf(int data)// Pressure Offset Datasheet S.37
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,RPDS_L,data);
    data = readRegister(LPS25H_ADDRESS, RPDS_L);
    Serial.print("RPDS_L:                          ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
    

}
//Einstellen der RPDS_H LPS
void RPDS_Hf(int data)// Pressure Offset Datasheet S.37
{
    char *datas     = "00000000\n";
    writeRegister(LPS25H_ADDRESS,RPDS_H,data);
    data = readRegister(LPS25H_ADDRESS, RPDS_H);
    Serial.print("RPDS_H:                          ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}

#endif /* LPS25HB_h */
