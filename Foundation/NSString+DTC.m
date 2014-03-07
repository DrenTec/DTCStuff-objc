#import "NSString+DTC.h"

#define LEGAL_CHARACTERS_TO_ENCODE CFSTR("!*'\"();:@&=+$,/?%#[]% ")

@implementation NSString (DTC)
- (NSString *)dtc_URLEncodedStringIn:(CFStringEncoding)encoding {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              LEGAL_CHARACTERS_TO_ENCODE,
                                                              encoding)
   autorelease];
}
- (NSString *)dtc_URLDecodedStringIn:(CFStringEncoding)encoding {
  CFStringRef result = (CFStringRef)[self stringByReplacingOccurrencesOfString:@"+"
                                                                    withString:@" "];
  result = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                   result,
                                                                   CFSTR(""),
                                                                   encoding);
	
	return [(NSString *)result autorelease];
}

- (NSString *)dtc_stringWithQueryAppended:(NSString *)queryString {
  if (!queryString || [queryString length] == 0) {
    return self;
  }
  return [self stringByAppendingFormat:@"%c%@",
          [self rangeOfString:@"?"].location == NSNotFound ? '?' : '&',
          queryString];
}

+ (NSString *)dtc_URLEncodedFormat:(NSString *)stringFormat
                         arguments:(va_list)args
                          encoding:(CFStringEncoding)encoding {
  __block va_list arguments;
  va_copy(arguments, args);
  NSUInteger matchCount = [stringFormat dtc_countOccurrences:@"%@" options:NSLiteralSearch];
  if (!matchCount) return stringFormat;
  NSMutableArray *argumentsArray = [NSMutableArray arrayWithCapacity:matchCount];
  while (matchCount-->0) {
    [argumentsArray addObject:va_arg(arguments, NSString*)];
  }
  __block NSUInteger i = 0;
  NSString *path = [stringFormat dtc_stringByReplacing:@"%@"
                                               options:NSLiteralSearch
                                     withResultOfBlock:^(NSRange *matchRange) {
                                       return [(NSString *)([argumentsArray objectAtIndex:i++])
                                               dtc_URLEncodedStringIn:encoding];
                                     }];
  va_end(arguments);
  return path;
}

+ (NSString *)dtc_URLEncodedIn:(CFStringEncoding)encoding
                        format:(NSString *)stringFormat, ... {
  va_list arguments;
  va_start(arguments, stringFormat);
	NSString *path = [self dtc_URLEncodedFormat:stringFormat
                                    arguments:arguments
                                     encoding:encoding];
  va_end(arguments);
  return path;
}


- (NSUInteger)dtc_countOccurrences:(NSString *)searchString
                           options:(NSStringCompareOptions)options {
  NSUInteger results = 0;
  NSUInteger originalStringLength = [self length];
  NSRange foundRange = [self rangeOfString:searchString options:options];
  while (foundRange.location != NSNotFound) {
    results += 1;
    foundRange = [self
        rangeOfString:searchString
              options:options
                range:NSMakeRange(foundRange.location + foundRange.length,
                                  originalStringLength - (foundRange.location +
                                                          foundRange.length))];
  }

  return results;
}

- (NSString *)dtc_stringByReplacing:(NSString *)searchString
                            options:(NSStringCompareOptions)options
                  withResultOfBlock:(NSString * (^)(NSRange *matchRange))replacementBlock {
  NSUInteger originalStringLength = [self length];
  NSRange searchRange = NSMakeRange(0, originalStringLength);
  NSRange foundRange = [self rangeOfString:searchString options:options];
  if (foundRange.location == NSNotFound) return self;
  NSMutableString *result = [NSMutableString stringWithCapacity:[self length] * 2];
  do {
    NSRange rangeUpToMatch = NSMakeRange(searchRange.location,
                                         foundRange.location - searchRange.location);
    [result appendString:[self substringWithRange:rangeUpToMatch]];
		NSString *replacement = replacementBlock(&foundRange);
    if (replacement)
      [result appendString:replacement];
    searchRange = NSMakeRange(foundRange.location + foundRange.length,
                              originalStringLength - (foundRange.location + foundRange.length));
    foundRange = [self rangeOfString:searchString
                             options:options
                               range:searchRange];
  } while (foundRange.location != NSNotFound);
  if (searchRange.location < (originalStringLength - 1))
    [result appendString:[self substringWithRange:searchRange]];
  return result;
}

- (NSString *)dtc_stringByReplacingMatches:(void (^)(NSRange *searchRange))matchingBlock
                         withResultOfBlock:(NSString * (^)(NSRange *matchRange))replacementBlock {
  NSUInteger originalStringLength = [self length];
  NSRange searchRange = NSMakeRange(0, originalStringLength);
  NSRange foundRange = searchRange;
  matchingBlock(&foundRange);
  if (foundRange.location == NSNotFound) return self;
  NSMutableString *result = [NSMutableString stringWithCapacity:[self length] * 2];
  do {
    NSRange rangeUpToMatch = NSMakeRange(searchRange.location,
                                         foundRange.location - searchRange.location);
    [result appendString:[self substringWithRange:rangeUpToMatch]];
    NSString *replacement = replacementBlock(&foundRange);
    if (replacement)
      [result appendString:replacement];
    foundRange = searchRange = NSMakeRange(foundRange.location + foundRange.length,
                                           originalStringLength - (foundRange.location + foundRange.length));
    matchingBlock(&foundRange);
  } while (foundRange.location != NSNotFound);
  if (searchRange.location < (originalStringLength - 1))
    [result appendString:[self substringWithRange:searchRange]];
  return result;
}

- (NSString *)dtc_jsEncode {
  NSCharacterSet *forbiddenJSChars = [NSCharacterSet characterSetWithCharactersInString:@"\\\"'"];
  return
    [NSString stringWithFormat:@"'%@'",
      [self dtc_stringByReplacingMatches:^(NSRange *searchRange) {
        *searchRange = [self rangeOfCharacterFromSet:forbiddenJSChars options:NSLiteralSearch range:*searchRange];
      } withResultOfBlock:^(NSRange *matchRange) {
        return [@"\\" stringByAppendingString:[self substringWithRange:*matchRange]];
      }]];
}

@end
