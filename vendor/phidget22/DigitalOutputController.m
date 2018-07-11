//
//  DigitalOutputController.m
//  DigitalOutput
//
//  Created by Phidgets on 2015-07-14.
//  Copyright (c) 2015 Phidgets. All rights reserved.
//

#import "DigitalOutputController.h"

@implementation DigitalOutputController

-(void)start:(int)serialNumber port:(int)hubPort{
    PhidgetReturnCode result;
    BOOL isHubPort = NO, remote = NO, errorOccurred = NO;
	
    
    PhidgetDigitalOutput_create(&ch0);
// only set an attach handler for the first channel (assume all the others are attached)
	Phidget_setOnAttachHandler(ch0, gotAttach, (__bridge void*)self);
	Phidget_setOnDetachHandler(ch0, gotDetach, (__bridge void*)self);
	Phidget_setOnErrorHandler(ch0, gotError, (__bridge void*)self);
    
    Phidget_setChannel(ch0, 0);
    Phidget_setDeviceSerialNumber(ch0, serialNumber);
    Phidget_setHubPort(ch0, (int)hubPort);
   	Phidget_setIsHubPortDevice(ch0, isHubPort);
    Phidget_setIsLocal(ch0, 1);
	
    result = Phidget_open(ch0);
    if(result != EPHIDGET_OK){
    	NSLog(@"error opening phidget!");
    }
	
    PhidgetDigitalOutput_create(&ch1);
    Phidget_setDeviceSerialNumber(ch1, serialNumber);  
    Phidget_setHubPort(ch1, (int)hubPort);                 
    Phidget_setChannel(ch1, 1);                 
    Phidget_open(ch1);
	
    PhidgetDigitalOutput_create(&ch2);
    Phidget_setDeviceSerialNumber(ch2, serialNumber);  
    Phidget_setHubPort(ch2, (int)hubPort);                 
    Phidget_setChannel(ch2, 2);                 
    Phidget_open(ch2);
	
    PhidgetDigitalOutput_create(&ch3);
    Phidget_setDeviceSerialNumber(ch3, serialNumber);  
    Phidget_setHubPort(ch3, (int)hubPort);                 
    Phidget_setChannel(ch3, 3);                 
    Phidget_open(ch3);
	
    PhidgetDigitalOutput_create(&ch4);
    Phidget_setDeviceSerialNumber(ch4, serialNumber);  
    Phidget_setHubPort(ch4, (int)hubPort);                 
    Phidget_setChannel(ch4, 4);                 
    Phidget_open(ch4);
	
    PhidgetDigitalOutput_create(&ch5);
    Phidget_setDeviceSerialNumber(ch5, serialNumber);  
    Phidget_setHubPort(ch5, (int)hubPort);                 
    Phidget_setChannel(ch5, 5);                 
    Phidget_open(ch5);
	
    PhidgetDigitalOutput_create(&ch6);
    Phidget_setDeviceSerialNumber(ch6, serialNumber);  
    Phidget_setHubPort(ch6, (int)hubPort);                 
    Phidget_setChannel(ch6, 6);                 
    Phidget_open(ch6);

    PhidgetDigitalOutput_create(&ch7);
    Phidget_setDeviceSerialNumber(ch7, serialNumber);  
    Phidget_setHubPort(ch7, (int)hubPort);                 
    Phidget_setChannel(ch7, 7);                 
    Phidget_open(ch7);
	
    PhidgetDigitalOutput_create(&ch8);
    Phidget_setDeviceSerialNumber(ch8, serialNumber);  
    Phidget_setHubPort(ch8, (int)hubPort);                 
    Phidget_setChannel(ch8, 8);                 
    Phidget_open(ch8);
	
    PhidgetDigitalOutput_create(&ch9);
    Phidget_setDeviceSerialNumber(ch9, serialNumber);  
    Phidget_setHubPort(ch9, (int)hubPort);                 
    Phidget_setChannel(ch9, 9);                 
    Phidget_open(ch9);
	
    PhidgetDigitalOutput_create(&ch10);
    Phidget_setDeviceSerialNumber(ch10, serialNumber);  
    Phidget_setHubPort(ch10, (int)hubPort);                 
    Phidget_setChannel(ch10, 10);                 
    Phidget_open(ch10);
	
    PhidgetDigitalOutput_create(&ch11);
    Phidget_setDeviceSerialNumber(ch11, serialNumber);  
    Phidget_setHubPort(ch11, (int)hubPort);                 
    Phidget_setChannel(ch11, 11);                 
    Phidget_open(ch11);
	
    PhidgetDigitalOutput_create(&ch12);
    Phidget_setDeviceSerialNumber(ch12, serialNumber);  
    Phidget_setHubPort(ch12, (int)hubPort);                 
    Phidget_setChannel(ch12, 12);                 
    Phidget_open(ch12);
	
    PhidgetDigitalOutput_create(&ch13);
    Phidget_setDeviceSerialNumber(ch13, serialNumber);  
    Phidget_setHubPort(ch13, (int)hubPort);                 
    Phidget_setChannel(ch13, 13);                 
    Phidget_open(ch13);
	
    PhidgetDigitalOutput_create(&ch14);
    Phidget_setDeviceSerialNumber(ch14, serialNumber);  
    Phidget_setHubPort(ch14, (int)hubPort);                 
    Phidget_setChannel(ch14, 14);                 
    Phidget_open(ch14);
	
    PhidgetDigitalOutput_create(&ch15);
    Phidget_setDeviceSerialNumber(ch15, serialNumber);  
    Phidget_setHubPort(ch15, (int)hubPort);                 
    Phidget_setChannel(ch15, 15);                 
    Phidget_open(ch15);
}

#pragma mark Event callbacks

static void gotAttach(PhidgetHandle phid, void *context){
   	NSLog(@"got attach %u", phid);
    [(__bridge id)context performSelectorOnMainThread:@selector(onAttachHandler)
                                           withObject:nil
                                        waitUntilDone:NO];
}

static void gotDetach(PhidgetHandle phid, void *context){
    NSLog(@"got detach %u", phid);
    [(__bridge id)context performSelectorOnMainThread:@selector(onDetachHandler)
                                           withObject:nil
                                        waitUntilDone:NO];
}

static void gotError(PhidgetHandle phid, void *context, Phidget_ErrorEventCode errcode, const char *error){
    [(__bridge id)context performSelectorOnMainThread:@selector(errorHandler:)
                                           withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:errcode], [NSString stringWithUTF8String:error], nil]
                                        waitUntilDone:NO];
}

#pragma mark Attach, detach, and error events
- (void)onAttachHandler{
    PhidgetReturnCode result;
    Phidget_DeviceID deviceID;
    Phidget_ChannelSubclass channelSubclass;
    int outputState;
    
    //Get information from channel which will allow us to configure the GUI properly
    result = Phidget_getDeviceID((PhidgetHandle)ch0, &deviceID);
    if(result != EPHIDGET_OK){
        NSLog(@"%u", result);
    }
    result = Phidget_getChannelSubclass((PhidgetHandle)ch0, &channelSubclass);
    if(result != EPHIDGET_OK){
        NSLog(@"%u", result);
    }
    result = PhidgetDigitalOutput_getState(ch0, &outputState);
    if(result != EPHIDGET_OK){
        NSLog(@"%u", result);
    }
		
	NSDictionary *attachData = [[NSDictionary alloc] initWithObjectsAndKeys: 
							[NSNumber numberWithInt:deviceID],
							@"deviceID", 
							[NSNumber numberWithInt:channelSubclass],
							@"channelSubclass",
							[NSNumber numberWithInt:outputState],
							@"outputState",
							nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"attach_notification_from_phidget" object:nil userInfo:attachData];
    
}

- (void)onDetachHandler{
    NSLog(@"on detatch handler");
    PhidgetReturnCode result;
    Phidget_DeviceID deviceID;
    Phidget_ChannelSubclass channelSubclass;
    int outputState;
    
    //Get information from channel which will allow us to configure the GUI properly
    result = Phidget_getDeviceID((PhidgetHandle)ch0, &deviceID);
    if(result != EPHIDGET_OK){
        NSLog(@"%u", result);
    }
		
	NSDictionary *detachData = [[NSDictionary alloc] initWithObjectsAndKeys: 
							[NSNumber numberWithInt:deviceID],
							@"deviceID", 
							nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"detach_notification_from_phidget" object:nil userInfo:detachData];
}

-(void)errorHandler:(NSArray *)errorEventData{
    const char* errorString = [[errorEventData objectAtIndex:1] UTF8String];
    NSLog(@"error is: %s", errorString);
}

-(void)addError:(PhidgetReturnCode)result{
    const char *errorString;
    Phidget_getErrorDescription(result, &errorString);
    NSLog(@"error is: %s", errorString);
}



#pragma mark commands
- (void)setDutyCycle:(double)value channel:(int)channelNumber{
	switch(channelNumber){
		case 0: 
		PhidgetDigitalOutput_setDutyCycle(ch0, value);
		break;
		case 1:
		PhidgetDigitalOutput_setDutyCycle(ch1, value);
		break;
		case 2:
		PhidgetDigitalOutput_setDutyCycle(ch2, value);
		break;
		case 3:
		PhidgetDigitalOutput_setDutyCycle(ch3, value);
		break;
		case 4:
		PhidgetDigitalOutput_setDutyCycle(ch4, value);
		break;
		case 5:
		PhidgetDigitalOutput_setDutyCycle(ch5, value);
		break;
		case 6:
		PhidgetDigitalOutput_setDutyCycle(ch6, value);
		break;
		case 7:
		PhidgetDigitalOutput_setDutyCycle(ch7, value);
		break;
		case 8:
		PhidgetDigitalOutput_setDutyCycle(ch8, value);
		break;
		case 9:
		PhidgetDigitalOutput_setDutyCycle(ch9, value);
		break;
		case 10:
		PhidgetDigitalOutput_setDutyCycle(ch10, value);
		break;
		case 11:
		PhidgetDigitalOutput_setDutyCycle(ch11, value);
		break;
		case 12:
		PhidgetDigitalOutput_setDutyCycle(ch12, value);
		break;
		case 13:
		PhidgetDigitalOutput_setDutyCycle(ch13, value);
		break;
		case 14:
		PhidgetDigitalOutput_setDutyCycle(ch14, value);
		break;
		case 15:
		PhidgetDigitalOutput_setDutyCycle(ch15, value);
		break;
}
}

- (void)setCurrentLimit:(double)value channel:(int)channelNumber{
	switch(channelNumber){
		case 0: 
		PhidgetDigitalOutput_setLEDCurrentLimit(ch0, value);
		break;
		case 1:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch1, value);
		break;
		case 2:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch2, value);
		break;
		case 3:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch3, value);
		break;
		case 4:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch4, value);
		break;
		case 5:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch5, value);
		break;
		case 6:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch6, value);
		break;
		case 7:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch7, value);
		break;
		case 8:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch8, value);
		break;
		case 9:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch9, value);
		break;
		case 10:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch10, value);
		break;
		case 11:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch11, value);
		break;
		case 12:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch12, value);
		break;
		case 13:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch13, value);
		break;
		case 14:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch14, value);
		break;
		case 15:
		PhidgetDigitalOutput_setLEDCurrentLimit(ch15, value);
		break;
	}
}

- (void)setState:(int)value channel:(int)channelNumber{
	// NSLog(@"set value %i on channel %i", value, channelNumber);
	switch(channelNumber){
		case 0: 
		// NSLog(@"case 0");
		PhidgetDigitalOutput_setState(ch0, value);
		break;
		case 1:
		PhidgetDigitalOutput_setState(ch1, value);
		break;
		case 2:
		PhidgetDigitalOutput_setState(ch2, value);
		break;
		case 3:
		PhidgetDigitalOutput_setState(ch3, value);
		break;
		case 4:
		PhidgetDigitalOutput_setState(ch4, value);
		break;
		case 5:
		PhidgetDigitalOutput_setState(ch5, value);
		break;
		case 6:
		PhidgetDigitalOutput_setState(ch6, value);
		break;
		case 7:
		PhidgetDigitalOutput_setState(ch7, value);
		break;
		case 8:
		PhidgetDigitalOutput_setState(ch8, value);
		break;
		case 9:
		PhidgetDigitalOutput_setState(ch9, value);
		break;
		case 10:
		PhidgetDigitalOutput_setState(ch10, value);
		break;
		case 11:
		PhidgetDigitalOutput_setState(ch11, value);
		break;
		case 12:
		PhidgetDigitalOutput_setState(ch12, value);
		break;
		case 13:
		PhidgetDigitalOutput_setState(ch13, value);
		break;
		case 14:
		PhidgetDigitalOutput_setState(ch14, value);
		break;
		case 15:
		PhidgetDigitalOutput_setState(ch15, value);
		break;
	}	
}



@end
