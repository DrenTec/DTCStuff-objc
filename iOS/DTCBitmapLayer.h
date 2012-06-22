#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DTCBitmap.h"
#import "DTCAnimatedView.h"

@interface DTCBitmapLayer : DTCAnimatedViewLayer {
  DTCBitmap *bitmap;
  CGRect bitmapRect;
}

- (CGPoint)pointToBitmapPoint:(CGPoint)point;

@property (retain, nonatomic) DTCBitmap *bitmap;

@end

@interface DTCBitmapLayer (Protected)

- (void)initBitmap;

@end
