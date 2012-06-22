#import "TTStyle.h"

@interface DTCContextMaskStyle : TTStyle {
  UIViewContentMode contentMode;
  BOOL haveSize;
  UIImage *image;
}

+ (DTCContextMaskStyle *)styleWithContentMode:(UIViewContentMode)mode next:(TTStyle*)aNext;
+ (DTCContextMaskStyle *)styleWithSizeAndContentMode:(UIViewContentMode)mode next:(TTStyle*)aNext;
+ (DTCContextMaskStyle *)styleWithSizeAndImage:(UIImage *)anImage
                                   contentMode:(UIViewContentMode)mode
                                          next:(TTStyle*)aNext;

@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic) BOOL haveSize;
@end
