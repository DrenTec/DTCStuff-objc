@interface NSString (DTC)

- (NSString *)dtc_URLEncodedStringIn:(CFStringEncoding)encoding;

- (NSString *)dtc_URLDecodedStringIn:(CFStringEncoding)encoding;

+ (NSString *)dtc_URLEncodedFormat:(NSString *)stringFormat
                         arguments:(va_list)args
                          encoding:(CFStringEncoding)encoding;

+ (NSString *)dtc_URLEncodedIn:(CFStringEncoding)encoding
                        format:(NSString *)stringFormat, ...;

- (NSString *)dtc_stringByReplacing:(NSString *)searchString
                            options:(NSStringCompareOptions)options
                  withResultOfBlock:(NSString * (^)(NSRange *matchRange))replacementBlock;

@end
