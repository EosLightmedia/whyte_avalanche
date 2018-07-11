#import "PhidgetAnalogController.h"

int gotAnalogAttach(CPhidgetHandle phid, void *context) {
	NSLog(@"got attach");
	[(id)context performSelectorOnMainThread:@selector(phidgetAnalogAdded:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}
int gotAnalogDetach(CPhidgetHandle phid, void *context) {
 	NSLog(@"got detach");
	[(id)context performSelectorOnMainThread:@selector(phidgetAnalogRemoved:)
								  withObject:nil
							   waitUntilDone:NO];
	return 0;
}

int gotAnalogError(CPhidgetHandle phid, void *context, int errcode, const char *error) {
	// NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *errorData = [[NSDictionary alloc] initWithObjectsAndKeys: 
							[NSNumber numberWithInt:errcode],
							@"errcode", 
							[NSString stringWithUTF8String:error], 
							@"error",
							nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"error_notification_from_phidget" object:nil userInfo:errorData];
	// [pool release];
	return 0;
}

@implementation PhidgetAnalogController

- (CPhidgetAnalogHandle) createAnalog:(int)serial
{
	NSLog(@"From C- Attempting to open Analog Phidget ID %d\n",serial);
	
	CPhidgetAnalog_create(&analog);
	CPhidget_open((CPhidgetHandle)analog, serial);
	
	CPhidget_set_OnAttach_Handler((CPhidgetHandle)analog, gotAnalogAttach, self);
	CPhidget_set_OnDetach_Handler((CPhidgetHandle)analog, gotAnalogDetach, self);
	CPhidget_set_OnError_Handler((CPhidgetHandle)analog, gotAnalogError, self);
	
	NSLog(@"From C - registered phidget analog with ID %d\n",serial);
	return*((&analog));
}

- (void)setVoltage:(int) output  toVoltage:(double) voltage
{
	CPhidgetAnalog_setVoltage(analog, output, voltage);
	// NSLog(@"voltage %f\n", voltage);
}

// - (void)setVoltageMax:(int) output  toVoltage:(int) voltage;
// {
// 	CPhidgetAnalog_setVoltageMax(analog, output, voltage);
// }
//
// - (void)setVoltageMin:(int) output  toVoltage:(int) voltage;
// {
// 	CPhidgetAnalog_setVoltageMin(analog, output, voltage);
// }

- (void)setOutputEnabled:(int) output enableOutput:(int) enabled
{
	CPhidgetAnalog_setEnabled(analog, output, enabled );
}

- (void)phidgetAnalogAdded:(id)nothing
{
	NSLog(@"analog attached");
	int serial;
	CPhidget_getSerialNumber((CPhidgetHandle)analog, &serial);
	NSDictionary *attachData = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:serial],@"serial", nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"attach_notification_from_phidget" object:nil userInfo:attachData];
	

}

- (void)phidgetAnalogRemoved:(id)nothing
{
	NSLog(@"Phidget Analog Detatched");
	
}

 - (void) closePhidgets
{
	CPhidget_close((CPhidgetHandle)analog);
	CPhidget_delete((CPhidgetHandle)analog);
	NSLog(@"Closed Phidgets");
}






@end