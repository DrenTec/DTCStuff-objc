#import "TTStyle.h"
#import "DTCGeometry.h"

@interface DTCAlignStyle : TTStyle {
	TTStyle *styleToPlace;
  BOOL vertical;
  CGFloat spacing;
  CGSize minSize;
}

+ (DTCAlignStyle*)styleToPlace:(TTStyle*)stylez
                    vertically:(BOOL)verticalz
                   withSpacing:(CGFloat)spacingz
                    andAtLeast:(CGSize)minSizez
                          next:(TTStyle*)next;
+ (TTStyle*)styleToPlaceVerticaly:(BOOL)isVertical
                      withSpacing:(CGFloat)spacingz
                             next:(TTStyle*)next, ...;
@property (assign, nonatomic) CGSize minSize;
@property (assign, nonatomic) CGFloat spacing;
@property (assign, nonatomic) BOOL vertical;
@property (retain, nonatomic) TTStyle *styleToPlace;
@end
