#import "NSDictionary+DTC.h"
#import "NSString+DTC.h"

@implementation NSDictionary (DTC)

- (NSString*)dtc_queryStringWithEncoding:(CFStringEncoding)encoding {
  NSMutableString *result = [NSMutableString stringWithCapacity:[self count] * 5];
  BOOL firstValue = YES;
  for (NSString *key in self) {
    id value = [self objectForKey:key];
    if (![value isKindOfClass:[NSString class]]) {
      value = [value description];
    }
    [result appendFormat:firstValue ? @"%@=%@" : @"&%@=%@",
     [key dtc_URLEncodedStringIn:encoding],
     [(NSString *)value dtc_URLEncodedStringIn:encoding]];
    firstValue = NO;
  }
  return result;
}

- (NSMutableDictionary *)dtc_dictionaryByMergingIn:(NSDictionary *)overridingDictionary
                                     onConflictUse:(id (^)(id key, id old_value, id new_value))conflict_solver {
  NSMutableDictionary *result = [[self mutableCopy] autorelease];
  for (id key in overridingDictionary) {
    id value = [overridingDictionary objectForKey:key];
    id old_value;
    if (conflict_solver && (old_value = [result objectForKey:key])) {
      value = conflict_solver(key, old_value, value);
    }
    [result setObject:value forKey:key];
  }
  return result;
}

- (NSMutableDictionary *)dtc_dictionaryByMergingIn:(NSDictionary *)overridingDictionary {
  return [self dtc_dictionaryByMergingIn:overridingDictionary
                           onConflictUse:nil];
}
@end
