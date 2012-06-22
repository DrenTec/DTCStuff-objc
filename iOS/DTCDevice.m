#import "DTCDevice.h"

#include <sys/sysctl.h>

#define DTC_USERDEFAULT_UID @"com.drentec.dtcios.UID"

@interface DTCDevice (Private)

@end

@implementation DTCDevice (Private)

@end

@implementation DTCDevice

+ (NSString *)stringWithSysCtlInfoNamed:(char *)name
{
  size_t size;
  sysctlbyname(name, NULL, &size, NULL, 0);
  char *buf = malloc(size);
  sysctlbyname(name, buf, &size, NULL, 0);
  NSString *result = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
  free(buf);
  return result;
}

+ (NSString *)platform
{
  return [self stringWithSysCtlInfoNamed:"hw.machine"];
}

+ (NSString*)preferredLocales {
	return [[[NSLocale preferredLanguages] subarrayWithRange:NSMakeRange(0, 2)] componentsJoinedByString:@"/"];
}

+ (NSString*)UID {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *result = [defaults stringForKey:DTC_USERDEFAULT_UID];
  if (!result || [result length] == 0) {
    CFUUIDRef uid = CFUUIDCreate(kCFAllocatorSystemDefault);
    result = (NSString *)CFUUIDCreateString(kCFAllocatorSystemDefault, uid);
    CFRelease(uid);
    [result autorelease];
    [defaults setValue:result forKey:DTC_USERDEFAULT_UID];
    [defaults synchronize];
  }
  return result;
}

+ (NSMutableDictionary *)info {
  UIDevice *device = [UIDevice currentDevice];
  NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
  UIScreen *screen = [UIScreen mainScreen];
  NSDictionary *screenSize = (NSDictionary *)CGSizeCreateDictionaryRepresentation(screen.bounds.size);
  NSNumber *screenScale = [NSNumber numberWithFloat:screen.scale];
  NSMutableDictionary *screenDict = [[screenSize mutableCopy] autorelease];
  [screenDict setObject:screenScale forKey:@"Scale"];
  [screenSize release];
  return [NSMutableDictionary dictionaryWithObjectsAndKeys:
          [device name],                                          @"DeviceName",
          [self UID],                                             @"DeviceUID",
          [device model],                                         @"DeviceModel",
          [self platform],                                        @"DevicePlatform",
          [device systemVersion],                                 @"DeviceVersion",
          [self preferredLocales],                                @"DeviceLocales",
          screenDict,                                             @"DeviceScreen",
          [plist objectForKey:(NSString*)kCFBundleVersionKey],    @"AppVersion",
          [plist objectForKey:(NSString*)kCFBundleNameKey],       @"AppName",
          [plist objectForKey:(NSString*)kCFBundleIdentifierKey], @"AppID",
          nil];
}

@end
