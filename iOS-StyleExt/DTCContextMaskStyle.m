#import "DTCContextMaskStyle.h"
#import "Three20Style+Additions.h"

@implementation DTCContextMaskStyle
@synthesize contentMode, image, haveSize;
+ (DTCContextMaskStyle *)styleWithContentMode:(UIViewContentMode)mode next:(TTStyle*)aNext {
  DTCContextMaskStyle *result = [[[self alloc] initWithNext:aNext] autorelease];
  result.contentMode = mode;
  return result;
}
+ (DTCContextMaskStyle *)styleWithSizeAndImage:(UIImage *)anImage
                                   contentMode:(UIViewContentMode)mode
                                          next:(TTStyle*)aNext {
  DTCContextMaskStyle *result = [[[self alloc] initWithNext:aNext] autorelease];
  result.contentMode = mode;
  result.haveSize = YES;
  result.image = anImage;
  return result;
}
+ (DTCContextMaskStyle *)styleWithSizeAndContentMode:(UIViewContentMode)mode next:(TTStyle*)aNext {
  return [self styleWithSizeAndImage:nil contentMode:mode next:aNext];
}
- (UIImage*)imageForContext:(TTStyleContext*)context {
  UIImage* maskImage = self.image;
  if (!maskImage && [context.delegate respondsToSelector:@selector(imageForLayerWithStyle:)]) {
    maskImage = [context.delegate imageForLayerWithStyle:self];
  }
  return maskImage;
}
- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  UIImage *mask;
  if (haveSize && (mask = [self imageForContext:context])) {
    CGSize imageSize = [mask size];
    size.width += imageSize.width;
    size.height += imageSize.height;
  }
  return _next ? [self.next addToSize:size context:context] : size;
}
- (void)draw:(TTStyleContext*)context {
  UIImage *mask = [self imageForContext:context];
  if (mask) {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGRect frameRectBackup = context.frame;
    CGRect frameRect = context.frame;
    CGRect boundingRect = CGContextGetClipBoundingBox(ctx);
    CGFloat yOffset = boundingRect.size.height;
    CGContextTranslateCTM(ctx, 0, yOffset);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    frameRect.origin.y = yOffset - frameRect.size.height - frameRect.origin.y;
    context.frame = frameRect;
    CGRect maskRect = [mask convertRect:frameRect withContentMode:contentMode];
    CGContextClipToMask(ctx, maskRect, mask.CGImage);
    [self.next draw:context];
    CGContextRestoreGState(ctx);
    context.frame = frameRectBackup;
  } else {
    return [self.next draw:context];
  }
}

@end
