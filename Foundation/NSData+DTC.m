#import "NSData+DTC.h"

@implementation NSData (DTC)
- (NSString *)dtc_stringWithHex {
  NSUInteger len = [self length];
  NSMutableString *result = [NSMutableString stringWithCapacity:len * 2];
  unsigned char *data = (unsigned char *)[self bytes];
	NSUInteger i;
  for (i = 0; i < len; i++) {
    [result appendFormat:@"%02x", data[i]];
  }
  return result;
}
@end
