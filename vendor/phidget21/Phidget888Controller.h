/* PhidgetRFIDController */

#import <Cocoa/Cocoa.h>
#import </Library/Frameworks/Phidget21.framework/Headers/phidget21.h>

@interface Phidget888Controller : NSObject 
{
	CPhidgetInterfaceKitHandle ifkit;


	int numOutputs, numInputs, numSensors;
}

//Phidget functions
- (CPhidgetInterfaceKitHandle) createInterfaceKit:(int)number;
- (CPhidgetInterfaceKitHandle) createRemoteInterfaceKit:(int)number;
- (CPhidgetInterfaceKitHandle) createRemoteInterfaceKitLabel:(char *)label;


- (void)phidgetAdded:(id)nothing;
- (void)phidgetRemoved:(id)nothing;
- (void)setOutput:(int)ind toState:(int)state;

@end
