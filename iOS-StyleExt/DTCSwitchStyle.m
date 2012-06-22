#import "DTCSwitchStyle.h"
#import "TTStyleContext.h"

@implementation DTCSwitchStyle

@synthesize conditionalField;
@synthesize nextIfTrue;
@synthesize nextIfFalse;

+ (DTCSwitchStyle *)styleTesting:(TTStyle *)aConditionalField
                          ifTrue:(TTStyle *)aNextIfTrue
                         ifEmpty:(TTStyle *)aNextIfFalse {
  DTCSwitchStyle* style = [[[self alloc] initWithNext:nil] autorelease];
  style.conditionalField = aConditionalField;
  style.nextIfTrue = aNextIfTrue;
  style.nextIfFalse = aNextIfFalse;
  return style;
}

- (BOOL)testCondition:(TTStyleContext*)context {
  NSString *text = nil;
  if ([(id<NSObject>)context.delegate respondsToSelector:@selector(textForLayerWithStyle:)]) {
    text = [context.delegate textForLayerWithStyle:self.conditionalField];
  }
  return text && [text length] > 0 && ![text isEqual:@"0"];
}

- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  return [([self testCondition:context] ? self.nextIfTrue : self.nextIfFalse) addToSize:size context:context];
}

- (void)draw:(TTStyleContext*)context {
  [([self testCondition:context] ? self.nextIfTrue : self.nextIfFalse) draw:context];
}

@end
