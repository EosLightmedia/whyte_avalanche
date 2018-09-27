//
//  AppController.m
//  
//
//  Created by Shaun August on 10-10-25.
//  Copyright Eos Lightmedia 2010 . All rights reserved.
//

#import "Phidget888Controller.h"


//Event callback functions for C, which in turn call a method on the GUI object in it's thread context

int gotIFKitAttach(CPhidgetHandle phid, void *context) {
	NSLog(@"got attach");
	[(id)context performSelectorOnMainThread:@selector(phidgetAdded:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}


 int gotIFKitDetach(CPhidgetHandle phid, void *context) {
 	NSLog(@"got detach");
	[(id)context performSelectorOnMainThread:@selector(phidgetRemoved:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}

int gotIFKitSensorChange(CPhidgetInterfaceKitHandle phid, void *context, int ind, int val) {
	int serial;
	NSLog(@"got sensor");
	CPhidget_getSerialNumber((CPhidgetHandle)phid, &serial);
	NSDictionary *dictionaryTest = [[NSDictionary alloc] initWithObjectsAndKeys: 
									[NSNumber numberWithInt:ind],
									@"analog", 
									[NSNumber numberWithInt:val], 
									@"value", 
									[NSNumber numberWithInt:serial],
									@"serial",
									nil];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"sensor_notification_from_phidget" object:nil userInfo:dictionaryTest];
	
	return 0;
}

int gotIFKitInputChange(CPhidgetInterfaceKitHandle phid, void *context, int ind, int val) {
	int serial;
	CPhidget_getSerialNumber((CPhidgetHandle)phid, &serial);
	NSDictionary *inputData = [[NSDictionary alloc] initWithObjectsAndKeys: 
							[NSNumber numberWithInt:ind],
							@"input", 
							[NSNumber numberWithInt:val], 
							@"value",
							[NSNumber numberWithInt:serial],
							@"serial",
							nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"input_notification_from_phidget" object:nil userInfo:inputData];
	return 0;
}

int gotIFKitError(CPhidgetHandle phid, void *context, int errcode, const char *error) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *errorData = [[NSDictionary alloc] initWithObjectsAndKeys: 
							[NSNumber numberWithInt:errcode],
							@"errcode", 
							[NSString stringWithUTF8String:error], 
							@"error",
							nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"error_notification_from_phidget" object:nil userInfo:errorData];
	return 0;
}

@implementation Phidget888Controller

- (CPhidgetInterfaceKitHandle) createInterfaceKit:(int)serial
{

	NSLog(@"From C- Attempting to open phidget ID %d\n",serial);
	
	CPhidgetInterfaceKit_create(&ifkit);
	CPhidget_open((CPhidgetHandle)ifkit, serial);
	
	CPhidgetInterfaceKit_set_OnSensorChange_Handler(ifkit, gotIFKitSensorChange, self);
	CPhidgetInterfaceKit_set_OnInputChange_Handler(ifkit, gotIFKitInputChange, self);
	
	CPhidget_set_OnAttach_Handler((CPhidgetHandle)ifkit, gotIFKitAttach, self);
	CPhidget_set_OnDetach_Handler((CPhidgetHandle)ifkit, gotIFKitDetach, self);
	CPhidget_set_OnError_Handler((CPhidgetHandle)ifkit, gotIFKitError, self);
	
	NSLog(@"From C - registered phidget with ID %d\n",serial);
	return*((&ifkit));
}

- (CPhidgetInterfaceKitHandle) createRemoteInterfaceKit:(int)serial
{	
	NSLog(@"From C- Attempting to open remote phidget0 ID %d\n",serial);

	CPhidgetInterfaceKit_create(&ifkit);
	CPhidget_openRemote((CPhidgetHandle)ifkit, serial, NULL, NULL);
	
	CPhidgetInterfaceKit_set_OnSensorChange_Handler(ifkit, gotIFKitSensorChange, self);
	CPhidgetInterfaceKit_set_OnInputChange_Handler(ifkit, gotIFKitInputChange, self);

	CPhidget_set_OnAttach_Handler((CPhidgetHandle)ifkit, gotIFKitAttach, self);
	CPhidget_set_OnDetach_Handler((CPhidgetHandle)ifkit, gotIFKitDetach, self);
	CPhidget_set_OnError_Handler((CPhidgetHandle)ifkit, gotIFKitError, self);
	
	NSLog(@"From C - registered phidget with ID %d\n",serial);
	return*((&ifkit));	
}

- (CPhidgetInterfaceKitHandle) createRemoteInterfaceKitLabel:(char *)label
{	
	NSLog(@"From C- Attempting to open remote phidget0 ID %s\n",label);
	// int serial = number;
	//char server = NULL;
	//char password = NULL;
	CPhidgetInterfaceKit_create(&ifkit);
	CPhidget_openLabelRemote((CPhidgetHandle)ifkit, label, NULL, NULL);
	
	CPhidgetInterfaceKit_set_OnSensorChange_Handler(ifkit, gotIFKitSensorChange, self);
	CPhidgetInterfaceKit_set_OnInputChange_Handler(ifkit, gotIFKitInputChange, self);

	CPhidget_set_OnAttach_Handler((CPhidgetHandle)ifkit, gotIFKitAttach, self);
	CPhidget_set_OnDetach_Handler((CPhidgetHandle)ifkit, gotIFKitDetach, self);
	CPhidget_set_OnError_Handler((CPhidgetHandle)ifkit, gotIFKitError, self);
	
	NSLog(@"From C - registered phidget with ID %s\n",label);
	return*((&ifkit));	
}

- (void)setOutput:(int) ind toState:(int) state;
{
	 NSLog(@"From C - output %d at %d\n",ind, state);//f 2000
	
	
	CPhidgetInterfaceKit_setOutputState(ifkit, ind, state);
}

- (void)phidgetAdded:(id)nothing
{
	int serial;
	CPhidget_getSerialNumber((CPhidgetHandle)ifkit, &serial);
	
	NSDictionary *attachData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:serial],@"serial", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"attach_notification_from_phidget" object:nil userInfo:attachData];
}	


- (void)phidgetRemoved:(id)nothing
{
	NSLog(@"Phidget Detached");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"detach_notification_from_phidget" object:nil userInfo:@"detached"];
}

 - (void) closePhidgets
{
	CPhidget_close((CPhidgetHandle)ifkit);
	CPhidget_delete((CPhidgetHandle)ifkit);
	NSLog(@"Closed Phidgets");
}


@end

