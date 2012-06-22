
@interface NSURL (DTC)

+ (NSURL*)dtc_URLWithScheme:(NSString*)scheme
                       user:(NSString*)user
                   password:(NSString*)password
                       host:(NSString*)host
                       port:(NSNumber*)port
                       path:(NSString*)path
                      query:(NSString*)query;
- (NSDictionary *)dtc_queryParametersWithEncoding:(CFStringEncoding)encoding;
- (NSURL*)dtc_URLByReplacingQuery:(NSDictionary *)params encoding:(CFStringEncoding)encoding;

@end
