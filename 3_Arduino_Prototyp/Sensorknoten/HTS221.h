//
//  HTS221.h
//  Sensorknoten
//
//  Created by Stefan von Burg on 17/05/16.
//  Copyright © 2016 Berner Fachhochschule TI. All rights reserved.
//

#ifndef HTS221_h
#define HTS221_h

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

bool storeCalibration(void);
int16_t T0_out, T1_out, T0_degC_x8_u16, T1_degC_x8_u16, T0_degC, T1_degC;
uint16_t H0_T0_out, H1_T0_out,H0_rh, H1_rh;
double temperature;
double humidity;




// WHO_AM_I HTS
void Identify_HTS(void)
{
    uint8_t data;
    data = readRegister(HTS221_ADDRESS,WHO_AM_I_HTS);
    Serial.print("WHO_AM_I Response HTS :          ");
    Serial.println(data);
}

//Einstellen der Ausgabe der Auflösung HTS
void Resolution_Set(int data)// Resolution Configuration Datasheet S.18
{
    char *datas     = "00000000\n";
    writeRegister(HTS221_ADDRESS,AVERAGE_REG ,data);
    data = readRegister(HTS221_ADDRESS,AVERAGE_REG);
    Serial.print("Hum and Temp resolution :        ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}

//Einstellen der CTRL_REG1 HTS
void CTRL_REG1_Set_HTS(int data)// Control Register Legende Datasheet S.19
{
    char *datas     = "00000000\n";
    writeRegister(HTS221_ADDRESS,CTRL_REG1 ,data);
    data = readRegister(HTS221_ADDRESS, CTRL_REG1);
    Serial.print("Control register 1:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}

//Einstellen der CTRL_REG2 HTS
void CTRL_REG2_Set_HTS(int data)// Control Register Legende Datasheet S.21
{
    char *datas     = "00000000\n";
    writeRegister(HTS221_ADDRESS,CTRL_REG2 ,data);
    data = readRegister(HTS221_ADDRESS, CTRL_REG2);
    Serial.print("Control register 2:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
 
}

//Einstellen der CTRL_REG3 HTS
void CTRL_REG3_Set_HTS(int data)// Control Register Legende Datasheet S.22
{
    char *datas     = "00000000\n";
    data = readRegister(HTS221_ADDRESS, CTRL_REG3);
    Serial.print("Control register 3:              ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}

//Auslesen des Status register LPS
void Status_HTS(void)
{
    char *datas     = "00000000\n";
    int data;
    data = readRegister(HTS221_ADDRESS, STATUS_REG);
    Serial.print("Status register:                 ");
    sprintf(datas,BNP, B2N(data)); // Dezimal to Binary
    Serial.println(datas);
}

//Auslesen der Sensordaten
bool storeCalibration(void)
{
        uint8_t buffer[4], tmp;

    // TEMP
    
        /*1. Read from 0x32 & 0x33 registers the value of coefficients T0_d egC_x8 and T1_de gC_x8*/
        buffer[0] = readRegister(HTS221_ADDRESS,0x32);
        buffer[1] = readRegister(HTS221_ADDRESS,0x33);
       
        /*2. Read from 0x35 register the value of the MSB bits of T1_deg C and T0_deg C */
        tmp = readRegister(HTS221_ADDRESS,0x35);
    
        /*Calculate the T0_deg C and T1_degC values*/
        T0_degC_x8_u16 = (((uint16_t)(tmp & 0x03)) << 8) | ((uint16_t)buffer[0]);
        T1_degC_x8_u16 = (((uint16_t)(tmp & 0x0C)) << 6) | ((uint16_t)buffer[1]);
        T0_degC = T0_degC_x8_u16>>3;
        T1_degC = T1_degC_x8_u16>>3;
    
        /*3. Read from 0x3C & 0x3D registers the value of T0_OUT*/
        /*4. Read from 0x3E & 0x3F registers the value of T1_OUT*/
    
        buffer[0] = readRegister(HTS221_ADDRESS,0x3C);
        buffer[1] = readRegister(HTS221_ADDRESS,0x3D);
        buffer[2] = readRegister(HTS221_ADDRESS,0x3E);
        buffer[3] = readRegister(HTS221_ADDRESS,0x3F);
    
        T0_out = (((uint16_t)buffer[1])<<8) | (uint16_t)buffer[0];
        T1_out = (((uint16_t)buffer[3])<<8) | (uint16_t)buffer[2];
    
    // HUMY
    
        /* 1. Read H0_rH and H1_rH coefficients*/
        buffer[0] = readRegister(HTS221_ADDRESS,0x30);
        buffer[1] = readRegister(HTS221_ADDRESS,0x31);
        H0_rh = buffer[0]>>1;
        H1_rh = buffer[1]>>1;
    
        /*2. Read H0_T0_OUT */
        buffer[0] = readRegister(HTS221_ADDRESS,0x36);
        buffer[1] = readRegister(HTS221_ADDRESS,0x37);
    
        H0_T0_out = (((uint16_t) buffer[1])<<8) | (uint16_t)buffer[0];
    
        /*3. Read H1_T0_OUT */
        buffer[0] = readRegister(HTS221_ADDRESS,0x3A);
        buffer[1] = readRegister(HTS221_ADDRESS,0x3B);
    
        H1_T0_out = (((uint16_t) buffer[1])<<8) | (uint16_t)buffer[0];
    
}


double readTemperature_HTS()
{
        int16_t T_out;
        double tmp;
        uint8_t buffer[2];
    
        /* Read from 0x2A & 0x2B registers the value T_OUT (ADC_OUT).*/
        buffer[0] = readRegister(HTS221_ADDRESS,0x2A);// LSB
        buffer[1] = readRegister(HTS221_ADDRESS,0x2B);// MSB
        T_out = (((uint16_t)buffer[1])<<8) | (uint16_t)buffer[0];
    
        /* Compute the Temperature value by linea r interpolation*/
        tmp = ((uint32_t)(T_out - T0_out)) * ((uint32_t)(T1_degC - T0_degC));
        temperature = tmp /(T1_out - T0_out) + T0_degC;
        return temperature;
    
}

double readHumidity()
{
        uint16_t H_out;
        double tmp;
        uint8_t buffer[2];
    
        /*4. Read H_T_OUT */
        buffer[0] = readRegister(HTS221_ADDRESS,0x28);// LSB
        buffer[1] = readRegister(HTS221_ADDRESS,0x29);// MSB
    
        H_out = (((int16_t)buffer[1])<<8) | (uint16_t)buffer[0];
    
        tmp = (int16_t)H1_rh - (int16_t)H0_rh;
    
        // Calculate humidity
        tmp = (((int16_t)H_out - (int16_t)H0_T0_out) * tmp)/((int16_t)H1_T0_out - (int16_t)  H0_T0_out);
        humidity = (int16_t)(tmp + H0_rh);

        /* Saturation condition*/
        if(humidity>1000 ){
            humidity = 1000;
        }
        return humidity;
    
}


#endif /* HTS221_h */
