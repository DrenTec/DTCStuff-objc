#import "DTCTouchForwardingView.h"
#import "UIView+DTC.h"

@implementation DTCTouchForwardingView

- (void)initialization {
  self.opaque = NO;
  self.backgroundColor = [UIColor clearColor];
  self.userInteractionEnabled = YES;
}
DTC_VIEW_INIT(initialization)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [target touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [target touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [target touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [target touchesCancelled:touches withEvent:event];
}
@end
