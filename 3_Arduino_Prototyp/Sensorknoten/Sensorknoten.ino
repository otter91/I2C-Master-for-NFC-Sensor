//
// Sensorknoten
//
// BSc Thesis
// Developed with [embedXcode](http://embedXcode.weebly.com)
//
// Author 		Stefan von Burg
// 				Berner Fachhochschule TI
//
// Date			11/05/16 18:00
// Version		1.0
//
// Copyright	© Stefan von Burg, 2016
// Licence		Open Source
//
// See         ReadMe.txt for references
//


// Core library for code-sense - IDE-based

#include <Wire.h>
#include "HTS221.h"
#include "I2C.h"
#include "LPS25HB.h"
#include "add_registry.h"
#include <SmeNfc.h>


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


#define SME_2_1(a)


bool nfcOk;
byte buffer[UID_SIZE];

void setup()
{
    Wire.begin();         // create a wire object
    Serial.begin(9600);
    // just clear the buffer
    for (int i = 0; i < UID_SIZE; i++) {
        buffer[i] = 0;
    }
    
}

void loop()
{
    double pres     = 0;
    double temp_LPS = 0;
    double humy     = 0;
    double temp_HTS = 0;
    char *VALA      = "0";  
    uint8_t registers[16];
    uint8_t registers2[16];
    uint8_t registers3[16];
    char *datas     = "00000000\n";
    
    
//LPS25HB PART
    Serial.println("\nLPS25HB");
    // WHO_AM_I LPS
    Identify_LPS();
    
    //Auslesen der Reference Register LPS
    Reference_Reg(0,0,0);
    
    //Einstellen der Ausgabe der Auflösung LPS
    Resolution_Set_LPS(0x0F); // data darf zwischen 0x00 und 0x0F sein -> Resolution Configuration
    
    //Einstellen der CTRL_REG1 LPS
    CTRL_REG1_Set(0x90);// Control Register Legende Datasheet S.28
    
    //Einstellen der CTRL_REG2 LPS
    CTRL_REG2_Set(0x00);// Control Register Legende Datasheet S.29
    
    //Einstellen der CTRL_REG3 LPS Interrupt Control
    CTRL_REG3_Set(0x00);// Interrupt Register Legende Datasheet S.30
    
    //Einstellen der CTRL_REG4 LPS Interrupt Configuration
    CTRL_REG4_Set(0x00);// Interrupt Configuration Legende Datasheet S.31
    
    //Auslesen des Status register LPS
    Status_LPS();

    //Auslesen der Sensordaten
    temp_LPS = readTemperature_LPS();
    pres = readPressure();
   
    
    //Einstellen der THS_P_L LPS
    THS_P_Lf(0x00);// Threshhold value Datasheet S.37
  
    //Einstellen der THS_P_H LPS
    THS_P_Hf(0x00);// Threshhold value Datasheet S.37

    //Einstellen der RPDS_L LPS
    RPDS_Lf(0x00);// Pressure Offset Datasheet S.37

    //Einstellen der RPDS_H LPS
    RPDS_Hf(0x00);// Pressure Offset Datasheet S.37

//HTS221 PART
    Serial.println("\nHTS221");
    // WHO_AM_I HTS
    Identify_HTS();

    //Einstellen der Ausgabe der Auflösung HTS
    Resolution_Set(AVERAGE_DEFAULT);// Resolution Configuration Datasheet S.18

    //Einstellen der CTRL_REG1 HTS
    CTRL_REG1_Set_HTS(0x81);// Control Register Legende Datasheet S.19
    
    //Einstellen der CTRL_REG2 HTS
    CTRL_REG2_Set_HTS(0x00);// Control Register Legende Datasheet S.21
    
    //Einstellen der CTRL_REG3 HTS
    CTRL_REG3_Set_HTS(0x00);// Control Register Legende Datasheet S.22
    
    //Auslesen des Status register LPS
    Status_HTS();
    
    //Auslesen der Sensordaten
    storeCalibration();
    temp_HTS = readTemperature_HTS();
    humy = readHumidity();
    
//NT3H1101/NT3H1201
    Serial.println("\nNT3H1101");
    
    //Dec. 0
    Serial.println("Serialnumber Block");
    readRegisters(0x04, 0x00, 16, registers);
    for(int x = 0 ; x < 10 ; x++) {
        Serial.print(x);
        Serial.print("                                ");
        sprintf(datas,BNP, B2N(registers[x])); // Dezimal to Binary
        Serial.println(datas);
    }
    for(int x = 10 ; x < 16 ; x++) {
        Serial.print(x);
        Serial.print("                               ");
        sprintf(datas,BNP, B2N(registers[x])); // Dezimal to Binary
        Serial.println(datas);
    }
    
    //Dec. Configuration
    Serial.println("Configuration");
    readRegisters(0x04, 0x3A, 16, registers2);
    for(int x = 0 ; x < 8 ; x++) {
        Serial.print(x);
        Serial.print("                                ");
        sprintf(datas,BNP, B2N(registers2[x])); // Dezimal to Binary
        Serial.println(datas);
    }

    
    //Session registers
    Serial.println("Session Registers");
    readRegisters(0x04, 0xFE, 16, registers3);
    for(int x = 0 ; x < 8 ; x++) {
        Serial.print(x);
        Serial.print("                                ");
        sprintf(datas,BNP, B2N(registers3[x])); // Dezimal to Binary
        Serial.println(datas);
    }

    
//Ausgabe PART
    Serial.println("\nAusgabe");
    //Ausgabe der Messdaten auf Serial Monitor
    
    Serial.print("Temperature HTS :                ");
    Serial.print(temp_HTS);
    Serial.println(" °celsius ");
    Serial.print("Humidity :                       ");
    Serial.print(humy);
    Serial.println(" % ");
    Serial.print("Temperature LPS :                ");
    Serial.print(temp_LPS);
    Serial.println(" °celsius");
    Serial.print("Pressure :                       ");
    Serial.print(pres);
    Serial.println(" mbar");
    
    //Zusammenfügen des Ausgabe Strings für NFC
    
    snprintf(VALA, (size_t)255, "HTS %d ° %d %%\nLPS %d ° %d mb",(int16_t)temp_HTS,(int16_t)humy,(int16_t)temp_LPS,(int16_t)pres);
    
    //Senden des Strings über NFC
    
    if (smeNfcDriver.readUID(buffer)) {
        smeNfc.storeText(NDEFFirstPos, VALA);
        
        nfcOk = true;
    }
    
    delay(2000);
}





