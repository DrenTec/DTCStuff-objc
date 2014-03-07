@interface NSString (DTC)

- (NSString *)dtc_URLEncodedStringIn:(CFStringEncoding)encoding;

- (NSString *)dtc_URLDecodedStringIn:(CFStringEncoding)encoding;

/** Replace %@ in stringFormat with each NSString argument, url encode, sequentially */
+ (NSString *)dtc_URLEncodedFormat:(NSString *)stringFormat
                         arguments:(va_list)args
                          encoding:(CFStringEncoding)encoding;

/** Replace %@ in receiver with each NSString argument, url encode, sequentially */
+ (NSString *)dtc_URLEncodedIn:(CFStringEncoding)encoding
                        format:(NSString *)stringFormat, ...;

/** Returns a string with the query string appended, inserting ? or & as appropriate */
- (NSString *)dtc_stringWithQueryAppended:(NSString *)queryString;

/** Return number of occurrences of searchString in receiver */
- (NSUInteger)dtc_countOccurrences:(NSString *)searchString
                           options:(NSStringCompareOptions)options;

/** Return a string by replacing occurrences of searchString with the result of replacementBlock */
- (NSString *)dtc_stringByReplacing:(NSString *)searchString
                            options:(NSStringCompareOptions)options
                  withResultOfBlock:(NSString * (^)(NSRange *matchRange))replacementBlock;

/** Replace all JS unsafe values to escapes and quote the string
 */
- (NSString *)dtc_jsEncode;

@end
