
#import "DTCSplashView.h"

@implementation DTCSplashView

@synthesize delegate;
@synthesize animationDuration;

+ (DTCSplashView *)splashScreen:(NSString *)imageName {
  CGRect frame = [UIScreen mainScreen].bounds;
//  frame.origin.y -= 20;
//  frame.size.height += 20;
  DTCSplashView *result = [[[self alloc] initWithFrame:frame] autorelease];
  result.contentMode = UIViewContentModeScaleToFill;
  result.image = [UIImage imageNamed:imageName];
  return result;
}

- (void)splashScreenAnimation:(BOOL)shouldShow {
  self.alpha = shouldShow ? 1.0 : 0;
  //    splashScreen.transform = CGAffineTransformMakeScale(5, 5);
}

- (void)show:(UIWindow *)parentWindow animated:(BOOL)withAnimation {
  withAnimation = withAnimation && animationDuration > 0;
  if (!!visible == !!parentWindow) return;
  if ((visible = !!parentWindow)) {
    [parentWindow addSubview:self];
  }
  [delegate splashScreen:self willShow:visible animated:withAnimation];
  if (withAnimation) {
    if (visible) {
      [self splashScreenAnimation:NO];
    }
    [UIView transitionWithView:self
                      duration:animationDuration
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{ [self splashScreenAnimation:visible]; }
                    completion:^(BOOL finished){ if (!visible) [self removeFromSuperview]; }];
  } else {
    [self splashScreenAnimation:visible];
    if (!visible) [self removeFromSuperview];
  }
}

- (void)showOver:(UIWindow *)window animated:(BOOL)withAnimation {
  [self show:window animated:withAnimation];
}

- (void)hideAnimated:(BOOL)withAnimation {
  [self show:nil animated:withAnimation];
}

@end
