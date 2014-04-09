#import <Foundation/Foundation.h>

@interface NSInvocation (DTC)

- (void)dtc_setArguments:(NSInteger)count to:(id)value, ...;
- (void)dtc_setArguments:(NSInteger)count toArg:(void *)arg thenList:(va_list)list;
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
