#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface DTCAnimatedViewLayer : CALayer {
  CADisplayLink *link;
  NSInteger width;
  NSInteger height;
}

@property (assign, nonatomic) BOOL active;

- (void)didResize;

@end

@interface DTCAnimatedView : UIView

+ (Class)animatedLayerClass;

@property (assign, nonatomic) BOOL active;
@property (retain, nonatomic) DTCAnimatedViewLayer *animatedLayer;

- (void)didChangeFrame;

@end
