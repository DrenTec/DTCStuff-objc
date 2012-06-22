/** Simple interface for retreiving common device information */
@interface DTCDevice : NSObject

/** Returns a '/' separated list (should not conflict with BCP 47) */
+ (NSString*)preferredLocales;

/** Returns an application specific device ID (COD, stored in NSUserDefaults) */
+ (NSString*)UID;

/** Returns a mutable autoreleased dictionary with app and device information */
+ (NSMutableDictionary *)info;

/** Returns a string describing the exact platform generation (i.e. iPhone4,1 )
 @author https://github.com/erica/uidevice-extension/blob/master/UIDevice-Hardware.m */
+ (NSString *)platform;

@end
