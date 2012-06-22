#import "DTCMacros.h"
#import "NSURL+DTC.h"
#import "NSString+DTC.h"
#import "NSDictionary+DTC.h"

@implementation NSURL (DTC)

+ (NSURL*)dtc_URLWithScheme:(NSString*)scheme
                       user:(NSString*)user
                   password:(NSString*)password
                       host:(NSString*)host
                       port:(NSNumber*)port
                       path:(NSString*)path
                      query:(NSString*)query {
  NSMutableString *absolute = [NSMutableString stringWithFormat:@"%@://", scheme];
  if (user || password) {
    if (user) [absolute appendString:user];
    if (password) [absolute appendFormat:@":%@"];
    [absolute appendString:@"@"];
  }
  [absolute appendString:host];
  if (port) [absolute appendFormat:@":%@", port];
  [absolute appendFormat:@"%@%@",
   path && [path hasPrefix:@"/"] ? @"" : @"/",
   path ?: @""];
  if (query && [query length] > 0)
    [absolute appendFormat:@"?%@", query];
	return [NSURL URLWithString:absolute];
}

- (NSDictionary *)dtc_queryParametersWithEncoding:(CFStringEncoding)encoding {
  NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
  if ([pairs count] == 0) return nil;
  NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[pairs count]];
  for (NSString *pair in pairs) {
    NSUInteger pairLength = [pair length];
    if (pairLength == 0) continue;
    NSRange separator = [pair rangeOfString:@"=" options:NSLiteralSearch];
    if (separator.location == 0) continue;
    NSString *key = separator.location == NSNotFound ?
     pair : [pair substringToIndex:separator.location];
    key = [key dtc_URLDecodedStringIn:encoding];
    if (separator.location == NSNotFound || separator.location == pairLength - 1) {
      if ([result objectForKey:key]) continue;
      [result setObject:@"" forKey:key];
      continue;
    }
    NSString *value = [[pair substringFromIndex:separator.location + 1]
                       dtc_URLDecodedStringIn:encoding];
    DTCAssert(![result objectForKey:key], @"Error: key '%@' present twice in %@", key, self);
    [result setObject:value forKey:key];
  }
  return result;
}

- (NSURL*)dtc_URLByReplacingQuery:(NSDictionary *)params encoding:(CFStringEncoding)encoding {
  NSDictionary *existingParameters = [self dtc_queryParametersWithEncoding:encoding];
  NSString *queryString = nil;
	if (existingParameters && [existingParameters count] > 0 && params && [params count] > 0) {
    NSMutableDictionary *merged = [[existingParameters mutableCopy] autorelease];
    for (id key in params) {
      [merged setObject:[params objectForKey:key] forKey:key];
    }
    queryString = [merged dtc_queryStringWithEncoding:encoding];
  } else {
    if (!existingParameters || [existingParameters count] == 0) {
      existingParameters = params;
    }
    queryString = [existingParameters dtc_queryStringWithEncoding:encoding];
  }
  if ([self baseURL]) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",
                                 self.path,
                                 queryString && [queryString length] > 0 ? @"?" : @"",
                                 queryString ?: @""]
                  relativeToURL:self.baseURL];
  }
  return [NSURL dtc_URLWithScheme:self.scheme
                             user:self.user
                         password:self.password
                             host:self.host
                             port:self.port
                             path:self.path
                            query:queryString];
}

@end
