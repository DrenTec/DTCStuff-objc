
#import "TTStyleContext.h"
#import "DTCChangingShapeStyle.h"

@implementation DTCChangingShapeStyle
@synthesize soleShape, firstShape, middleShape, lastShape;

- (void)dealloc {
  self.soleShape = nil;
	self.firstShape = nil;
  self.middleShape = nil;
  self.lastShape = nil;
  [super dealloc];
}

+ (DTCChangingShapeStyle*)styleWithOnlyShape:(TTShape*)aSoleShape
                                orFirstShape:(TTShape*)aFirstShape
                                 middleShape:(TTShape*)aMiddleShape
                                   lastShape:(TTShape*)aLastShape
                                        next:(TTStyle*)next {
  DTCChangingShapeStyle* style = [[[self alloc] initWithNext:next] autorelease];
  style.shape = style.soleShape = aSoleShape ?: aMiddleShape ?: aFirstShape;
  style.firstShape = aFirstShape ?: aMiddleShape ?: aSoleShape;
  style.middleShape = aMiddleShape ?: aSoleShape ?: aFirstShape ?: aLastShape;
  style.lastShape = aLastShape ?: aMiddleShape ?: aSoleShape;
  return style;
}

- (TTShape*)shapeForView:(UIView *)view {
  NSArray *siblings = [[view superview] subviews];
  NSUInteger count;
  if (!siblings || (count = [siblings count]) < 2)
    return self.soleShape;
	if ([siblings objectAtIndex:0] == view)
    return self.firstShape;
	if ([siblings objectAtIndex:count - 1] == view)
    return self.lastShape;
  return self.middleShape;
}

- (void)draw:(TTStyleContext*)context {
  UIView *targetView = (UIView *)(context.delegate);
  if ([targetView isKindOfClass:[UIView class]]) {
    self.shape = [self shapeForView:targetView];
  }
	[super draw:context];
}

- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  UIView *targetView = (UIView *)(context.delegate);
  if ([targetView isKindOfClass:[UIView class]]) {
    self.shape = [self shapeForView:targetView];
  }
  return [super addToSize:size context:context];  
}
@end
