#import <UIKit/UIKit.h>

@class DTCSplashView;

@protocol DTCSplashViewDelegate <NSObject>
/** Called before the image is about to be animated full screen */
- (BOOL)splashScreen:(DTCSplashView*)view willShow:(BOOL)willShow animated:(BOOL)isAnimated;
@end

@interface DTCSplashView : UIImageView {
  BOOL visible;
  id<DTCSplashViewDelegate> delegate;
  NSTimeInterval animationDuration;
}

@property (nonatomic,assign) id<DTCSplashViewDelegate> delegate;
@property (nonatomic,assign) NSTimeInterval animationDuration;

+ (DTCSplashView *)splashScreen:(NSString *)imageName;

- (void)showOver:(UIWindow *)window animated:(BOOL)withAnimation;
- (void)hideAnimated:(BOOL)withAnimation;

@end
