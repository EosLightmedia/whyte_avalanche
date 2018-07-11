/* DigitalOutputController */

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import </Library/Frameworks/Phidget22.framework/Headers/phidget22.h>
#import "PhidgetInfoBox.h"


@interface DigitalOutputController : NSObject 
{
    PhidgetDigitalOutputHandle ch0;
    PhidgetDigitalOutputHandle ch1;
    PhidgetDigitalOutputHandle ch2;
    PhidgetDigitalOutputHandle ch3;
    PhidgetDigitalOutputHandle ch4;
    PhidgetDigitalOutputHandle ch5;
    PhidgetDigitalOutputHandle ch6;
    PhidgetDigitalOutputHandle ch7;
    PhidgetDigitalOutputHandle ch8;
    PhidgetDigitalOutputHandle ch9;
    PhidgetDigitalOutputHandle ch10;
    PhidgetDigitalOutputHandle ch11;
    PhidgetDigitalOutputHandle ch12;
    PhidgetDigitalOutputHandle ch13;
    PhidgetDigitalOutputHandle ch14;
    PhidgetDigitalOutputHandle ch15;

    PhidgetDigitalOutputHandle phid;

}

//Phidget functions
// - (PhidgetHandle) start;

- (void)start:(int)serialNumber port:(int)hubPort;
- (void)setState:(int)value channel:(int)channelNumber;
- (void)setCurrentLimit:(double)value channel:(int)channelNumber;
- (void)setDutyCycle:(double)value channel:(int)channelNumber;


@end
