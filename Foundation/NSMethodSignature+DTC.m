#import "NSMethodSignature+DTC.h"
#import <objc/runtime.h>

@implementation NSMethodSignature (DTC)

+ (NSMethodSignature *)dtc_signatureFromClass:(Class)klass
                                     selector:(SEL)selector
                            preferClassMethod:(BOOL)preferClassMethod
                            searchNonPrefered:(BOOL)searchNonPrefered {
  Method method = preferClassMethod
  ? class_getClassMethod(klass, selector)
  : class_getInstanceMethod(klass, selector);
  if (searchNonPrefered && !method)
    method = (!preferClassMethod)
    ? class_getClassMethod(klass, selector)
    : class_getInstanceMethod(klass, selector);
  const char *types = method_getTypeEncoding(method);
  return types ? [NSMethodSignature signatureWithObjCTypes:types] : nil;
}

- (NSInteger)dtc_returnKind {
  NSUInteger returnSize = [self methodReturnLength];
  if (returnSize == 0)
    return 0;
  NSString *returnName = [NSString stringWithCString:[self methodReturnType] encoding:NSASCIIStringEncoding];
  if ([@"@" isEqualToString:returnName])
    return -1;
  return returnSize;
}

@end