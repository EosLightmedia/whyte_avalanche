/* PhidggetTemperatureSensorController */

#import <Cocoa/Cocoa.h>
#import </Library/Frameworks/Phidget21.framework/Headers/phidget21.h>

@interface PhidgetAnalogController : NSObject
{
	
	CPhidgetAnalogHandle analog;
	int numOutputs;
}
- (CPhidgetAnalogHandle) createAnalog:(int)number;
- (void)setOutputEnabled:(int) output enableOutput:(int) enabled;
- (void)setVoltage:(int) output  toVoltage:(double) voltage;

- (void)phidgetAnalogAdded:(id)nothing;
- (void)phidgetAnalogRemoved:(id)nothing;
@end
