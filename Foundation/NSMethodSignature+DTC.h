#import <Foundation/Foundation.h>

@interface NSMethodSignature (DTC)
+ (NSMethodSignature *)dtc_signatureFromClass:(Class)klass
                                     selector:(SEL)selector
                            preferClassMethod:(BOOL)preferClassMethod
                            searchNonPrefered:(BOOL)searchNonPrefered;
/**
 Return the nature of the type of the return value of this method signature.
 
 - -1: Object is an id
 -  0: No return (void)
 - >0: Size of return value
 */
- (NSInteger)dtc_returnKind;
@end