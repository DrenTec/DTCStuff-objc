#import "NSInvocation+DTC.h"
#import "NSMethodSignature+DTC.h"
#import <objc/runtime.h>

@implementation NSInvocation (DTC)

- (void)dtc_setArguments:(NSInteger)count toArg:(void *)arg thenList:(va_list)list {
  va_list arguments;
  va_copy(arguments, list);
  if (count)
    [self setArgument:&arg atIndex:2];
  for (NSInteger i = 1; i < count; i++) {
    id value = va_arg(arguments, id);
    [self setArgument:&value atIndex:i + 2];
  }
  va_end(arguments);
}

- (void)dtc_setArguments:(NSInteger)count to:(id)value, ... {
  va_list arguments;
  va_start(arguments, value);
  [self dtc_setArguments:count toArg:value thenList:arguments];
  va_end(arguments);
}

- (void)dtc_setArgumentsToArray:(NSArray *)array {
  NSInteger i = 2;
  for (id object in array) {
    id value = object;
    if ([object isKindOfClass:[NSValue class]]) {
      const char *types = [(NSValue *)object objCType];
      NSUInteger size = 0;
      NSGetSizeAndAlignment(types, NULL, &size);
      void *data = malloc(size);
      [(NSValue *)object getValue:data];
      [self setArgument:data atIndex:i++];
      free(data);
    } else {
      if ([object isKindOfClass:[NSNull class]]) {
        value = nil;
      }
      [self setArgument:&value atIndex:i++];
    }
  }
}

- (void)dtc_handleReturn:(void (^)(NSInteger returnSize, void *pointer))handler {
  NSInteger returnKind = [self.methodSignature dtc_returnKind];
  if (returnKind == 0) {
    handler(0, NULL);
  } else if (returnKind == -1) {
    id value;
    [self getReturnValue:&value];
    handler(-1, value);
  } else {
    void *buffer = malloc(returnKind);
    [self getReturnValue:buffer];
    handler(returnKind, buffer);
    free(buffer);
  }
}

- (void)dtc_handleNoReturn:(void (^)())voidHandler
                  returnID:(void (^)(id returnValue))idHandler
               returnValue:(void (^)(NSInteger returnSize, void *pointer))valueHandler {
  [self dtc_handleReturn:^(NSInteger returnSize, void *pointer) {
    if (returnSize == -1) {
      if (idHandler) idHandler((id)pointer);
    } else if (returnSize == 0) {
      if (voidHandler) voidHandler();
    } else if (valueHandler) {
      valueHandler(returnSize, pointer);
    }
  }];
}

static inline NSMethodSignature *dtc_getSignatureFromObjectAndSelector(id object, SEL selector) {
  NSMethodSignature *signature = [object methodSignatureForSelector:selector];
  if (!signature) {
    if (class_isMetaClass(object_getClass(object)))
      signature = [NSMethodSignature dtc_signatureFromClass:(Class)object
                                                   selector:selector
                                          preferClassMethod:YES
                                          searchNonPrefered:YES];
  }
  if (!signature) {
    NSLog(@"Warning: signature for %@ not found on %@.", NSStringFromSelector(selector), object);
    signature = [NSMethodSignature methodSignatureForSelector:@selector(selector)];
  }
  return signature;
}

- (void)dtc_invokeOnMainThreadWithTarget:(id)target waitUntilDone:(BOOL)waitUntilDone {
  [self performSelectorOnMainThread:@selector(invokeWithTarget:) withObject:target ?: self.target waitUntilDone:waitUntilDone];
}

- (NSInvocation *)dtc_invocationToRunMeOnMainWaitUntilDone:(BOOL)sync {
  return [self dtc_invocationToRunMeOnMainThreadWithTarget:nil waitUntilDone:sync];
}

- (NSInvocation *)dtc_invocationToRunMeOnMainThreadWithTarget:(id)target waitUntilDone:(BOOL)sync {
  [self retainArguments];
  return [[self class] dtc_invocationFor:@selector(dtc_invokeOnMainThreadWithTarget:waitUntilDone:)
                                      of:self
                                      on:self
                                    with:2
                                retained:YES
                               arguments:target ?: self.target, sync];
}

+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                      withSignature:(NSMethodSignature *)signature
                                 on:(id)target {

  if (!signature) {
    NSLog(@"Warning: signature for %@ not found.", selector ? NSStringFromSelector(selector) : @"<nil selector>");
    signature = [NSMethodSignature methodSignatureForSelector:@selector(selector)];
  }
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  [invocation setSelector:selector];
  if (target)
    [invocation setTarget:target];
  return invocation;

}

+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                      withSignature:(NSMethodSignature *)signature
                                 on:(id)target
                               with:(NSInteger)argumentCount
                           retained:(BOOL)retainArguments
                              toArg:(void *)argument
                          arguments:(va_list)argumentList {
  NSInvocation *invocation = [self dtc_invocationFor:selector
                                       withSignature:signature
                                                  on:target];
  if (argumentCount == -1)
    argumentCount = [invocation.methodSignature numberOfArguments] - 2;
  if (argumentCount)
    [invocation dtc_setArguments:argumentCount toArg:argument thenList:argumentList];
  if (retainArguments)
    [invocation retainArguments];
  return invocation;
}

+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                      withSignature:(NSMethodSignature *)signature
                                 on:(id)target
                          andRetain:(BOOL)retainArguments
                          arguments:(NSArray *)arguments {
  NSInvocation *invocation = [self dtc_invocationFor:selector
                                       withSignature:signature
                                                  on:target];
  if ([arguments count])
    [invocation dtc_setArgumentsToArray:arguments];
  if (retainArguments)
    [invocation retainArguments];
  return invocation;
}

+ (NSInvocation *)dtc_invocationForSelectorName:(NSString *)selectorName
                                             of:(id)object
                                             on:(id)target
                                           with:(NSInteger)argumentCount
                                       retained:(BOOL)retainArguments
                                      arguments:arg, ... {
  va_list arguments;
  va_start(arguments, arg);
  SEL selector = NSSelectorFromString(selectorName);
  if (!selector) {
    NSLog(@"Warning: invalid selector name '%@'.", selectorName);
    return nil;
  }
  NSInvocation *invocation = [NSInvocation dtc_invocationFor:selector
                                               withSignature:dtc_getSignatureFromObjectAndSelector(object, selector)
                                                          on:target
                                                        with:argumentCount
                                                    retained:retainArguments
                                                       toArg:arg
                                                   arguments:arguments];
  va_end(arguments);
  return invocation;
}

+ (NSInvocation *)dtc_invocationForSelectorName:(NSString *)selectorName
                                             of:(id)object
                                             on:(id)target
                                      andRetain:(BOOL)retainArguments
                                      arguments:(NSArray *)arguments {
  SEL selector = NSSelectorFromString(selectorName);
  if (!selector) {
    NSLog(@"Warning: invalid selector name '%@'.", selectorName);
    return nil;
  }
  NSInvocation *invocation = [NSInvocation dtc_invocationFor:selector
                                               withSignature:dtc_getSignatureFromObjectAndSelector(object, selector)
                                                          on:target
                                                   andRetain:retainArguments
                                                   arguments:arguments];
  return invocation;
}

+ (NSInvocation *)dtc_invocationFor:(SEL)selector
                                 of:(id)object
                                 on:(id)target
                               with:(NSInteger)argumentCount
                           retained:(BOOL)retainArguments
                          arguments:arg, ... {
  va_list arguments;
  va_start(arguments, arg);
  NSInvocation *invocation = [NSInvocation dtc_invocationFor:selector
                                               withSignature:dtc_getSignatureFromObjectAndSelector(object, selector)
                                                          on:target
                                                        with:argumentCount
                                                    retained:retainArguments
                                                       toArg:arg
                                                   arguments:arguments];
  va_end(arguments);
  return invocation;
}

@end