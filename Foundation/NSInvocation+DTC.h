#import <Foundation/Foundation.h>

@interface NSInvocation (DTC)
/**
 * Set arguments to list. Each argument must have the size of an id. See note on
 * dtc_setArgumentsToArray: for other sizes.
 */
- (void)dtc_setArguments:(NSInteger)count to:(id)value, ...
  NS_REQUIRES_NIL_TERMINATION;
- (void)dtc_setArguments:(NSInteger)count toArg:(void *)arg thenList:(va_list)list;
/**
 *  Set arguments to contents of array. If an argument has a different size than
 *  sizeof(id), it must be in an NSValue. Conversely, for a pointer to an NSValue
 *  put that pointer in another NSValue
 */
- (void)dtc_setArgumentsToArray:(NSArray *)array;

- (void)dtc_handleReturn:(void (^)(NSInteger returnSize, void *pointer))handler;
- (void)dtc_handleNoReturn:(void (^)())voidHandler
                  returnID:(void (^)(id returnValue))idHandler
               returnValue:(void (^)(NSInteger returnSize, void *pointer))valueHandler;

- (void)dtc_invokeOnMainThreadWithTarget:(id)target waitUntilDone:(BOOL)waitUntilDone;
- (NSInvocation *)dtc_invocationToRunMeOnMainThreadWithTarget:(id)target waitUntilDone:(BOOL)sync;
- (NSInvocation *)dtc_invocationToRunMeOnMainWaitUntilDone:(BOOL)sync;


+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                      withSignature:(NSMethodSignature *)signature
                                 on:(id)target
                               with:(NSInteger)argumentCount
                           retained:(BOOL)retainArguments
                              toArg:(void *)argument
                          arguments:(va_list)argumentList;

+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                      withSignature:(NSMethodSignature *)signature
                                 on:(id)target
                          andRetain:(BOOL)retainArguments
                          arguments:(NSArray *)arguments;

+ (NSInvocation *)dtc_invocationForSelectorName:(NSString *)selectorName
                                             of:(id)object
                                             on:(id)target
                                           with:(NSInteger)argumentCount
                                       retained:(BOOL)retainArguments
                                      arguments:(id)arg, ...;

+ (NSInvocation *)dtc_invocationForSelectorName:(NSString *)selectorName
                                             of:(id)object
                                             on:(id)target
                                      andRetain:(BOOL)retainArguments
                                      arguments:(NSArray *)arguments;

+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                                 of:(id)object
                                 on:(id)target
                               with:(NSInteger)argumentCount
                           retained:(BOOL)retainArguments
                          arguments:(id)arg, ...;
@end
