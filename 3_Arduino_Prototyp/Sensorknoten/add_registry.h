//
//  add_registry.h
//  Sensorknoten
//
//  Created by Stefan von Burg on 11/05/16.
//  Copyright © 2016 Berner Fachhochschule TI. All rights reserved.
//

#ifndef add_registry_h
#define add_registry_h


// deviceaddress of sensors

#define NFC_ADDRESS         0x55 // NFC Writable
#define HTS221_ADDRESS      0x5F // HTS221
#define LPS25H_ADDRESS      0x5C // LPS25HB

//subadress of NFC

#define USER_END_REG        0x38 // just the first 8 bytes for the 1K
#define CONFIG_REG          0x3A

#define NXPNFC_ADDRESS        85 // 0x4 is the default for every NXP io ho visto 85

#define MANUFACTURING_DATA_REG 0x0
#define USER_START_REG       0x1
#define NT3H1101_DEF           1 // just for Arduino debug

#define USER_END_REG        0x38 // just the first 8 bytes for the 1K
#define CONFIG_REG          0x3A

#define SRAM_START_REG      0xF8
#define SRAM_END_REG        0xFB // just the first 8 bytes

//subadress of HTS221 (Humidity)

#define WHO_AM_I_HTS        0x0F
#define WHO_AM_I_RETURN_HTS 0xBC // This read-only register contains the device identifier, set to BCh

#define AVERAGE_REG         0x10 // To configure humidity/temperature average.
#define AVERAGE_DEFAULT     0x1B

#define CTRL_REG1           0x20
#define POWER_UP            0x80
#define BDU_SET_HTS         0x4
#define ODR0_SET_HTS        0x1  // setting sensor reading period 1Hz

#define CTRL_REG2           0x21
#define CTRL_REG3           0x22
#define REG_DEFAULT         0x00

#define STATUS_REG          0x27
#define TEMPERATURE_READY   0x1
#define HUMIDITY_READY      0x2

#define HUMIDITY_L_REG      0x28
#define HUMIDITY_H_REG      0x29
#define TEMP_L_REG_HTS      0x2A
#define TEMP_H_REG_HTS      0x2B

#define CALIB_START         0x30
#define CALIB_END           0x3F
/*
 #define CALIB_T0_DEGC_X8    0x32
 #define CALIB_T1_DEGC_X8    0x33
 #define CALIB_T1_T0_MSB     0x35
 #define CALIB_T0_OUT_L      0x3C
 #define CALIB_T0_OUT_H      0x3D
 #define CALIB_T1_OUT_L      0x3E
 #define CALIB_T1_OUT_H      0x3F
 */

//subadress of LPS25HB (Pressure)

#define WHO_AM_I_LPS        0x0F // Device ID REG
#define WHO_AM_I_RETURN_LPS 0xBD // Contains the device ID (this is not a Register)

#define RES_CONF_REG        0x10 // Pressure and Temperature internal average configuration.
#define RES_CONF_DEFAULT    0x05

#define CTRL_REG1           0x20
#define POWER_UP            0x80
#define BDU_SET_LPS         0x04
#define ODR0_SET_LPS        0x10 // 1 read each second

#define CTRL_REG2           0x21
#define CTRL_REG3           0x22
#define CTRL_REG4           0x23
#define REG_DEFAULT         0x00

#define STATUS_REG          0x27
#define TEMPERATURE_READY   0x1
#define PRESSURE_READY      0x2

#define REF_P_XL            0x08 // Referemce Pressure (LSB data)
#define REF_P_L             0x09 // Referemce Pressure (Middle Part)
#define REF_P_H             0x0A // Referemce Pressure (MSB Part)

#define PRESSURE_XL_REG     0x28
#define PRESSURE_L_REG      0x29
#define PRESSURE_H_REG      0x2A
#define TEMP_L_REG_LPS      0x2B
#define TEMP_H_REG_LPS      0x2C

#define THS_P_L             0x30
#define THS_P_H             0x31
#define RPDS_L              0x39
#define RPDS_H              0x3A



#endif /* add_registry_h */
