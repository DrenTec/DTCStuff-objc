
#import <Foundation/Foundation.h>

@interface NSData (DTC)

/** Return a string with a hex encoded representation (i.e. 12ab12...) */
- (NSString *)dtc_stringWithHex;

@end
