#import "DTCFieldStyle.h"
#import "DTCMacros.h"

@implementation DTCFieldStyle

@synthesize transformer;

+ (DTCFieldStyle *)usingTransformer:(NSString *(^)(DTCModelStyleView*,id))aTransformer next:(TTStyle*)next {
  DTCFieldStyle *result = [[[self alloc] initWithNext:next] autorelease];
  result.transformer = [[aTransformer copy] autorelease];
  return result;
}

+ (DTCFieldStyle *)usingTransformer:(NSString *(^)(DTCModelStyleView*,id))aTransformer {
  return [self usingTransformer:aTransformer next:nil];
}

+ (DTCFieldStyle *)usingField:(NSString*)aFieldName next:(TTStyle*)next {
  return [self usingTransformer:^(DTCModelStyleView *arg1, id model) {
    NSString *value = [model valueForKey:aFieldName];
    if ([value isKindOfClass:[NSNull class]]) {
      return @"";
    } else if (![value isKindOfClass:[NSString class]]) {
      value = [value description];
    }
    return value;
  } next:next];
}

+ (DTCFieldStyle *)usingField:(NSString*)aFieldName {
  return [self usingField:aFieldName next:nil];
}

+ (DTCFieldStyle *)usingJoined:(NSString*)aSeparator fields:(NSString*)aFirstFieldName, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, aFirstFieldName, NSString *)
  return [self usingTransformer:^(DTCModelStyleView *arg1, id model) {
    NSMutableArray *entries = [NSMutableArray arrayWithCapacity:[items count]];
    for (NSString *fieldName in items) {
      NSString *value = [model valueForKey:fieldName];
      if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
      } else if (![value isKindOfClass:[NSString class]]) {
        value = [value description];
      } else if ([value length] == 0) {
        value = nil;
      }
      if (value)
        [entries addObject:value];
    }
    return (NSString *)[entries componentsJoinedByString:aSeparator];
  }];
}

- (NSString*)textForModel:(id)model inView:(DTCModelStyleView*)view {
  NSString *value = @"";
  if (transformer)
    value = transformer(view, model);
  return value;
}

- (void) dealloc
{
  self.transformer = nil;
  [super dealloc];
}


@end

@implementation DTCStaticTextStyle

+ (DTCFieldStyle *)usingField:(NSString*)aFieldName {
  return [self usingTransformer:^(DTCModelStyleView *arg1, id arg2) {
  	return aFieldName;
  } next:nil];
}

@end