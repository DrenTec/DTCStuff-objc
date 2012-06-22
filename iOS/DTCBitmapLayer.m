#import "DTCBitmapLayer.h"
#import "DTCGeometry.h"

@implementation DTCBitmapLayer (Protected)

- (void)initBitmap {
  self.bitmap = [[[DTCBitmap alloc] init] autorelease];
}

@end

@implementation DTCBitmapLayer

@synthesize bitmap;

- (id)init {
  self = [super init];
  if (self) {
    [self setNeedsDisplayOnBoundsChange:YES];
    [self initBitmap];
  }
  return self;
}

- (void)dealloc {
  self.bitmap = nil;
  [super dealloc];
}

- (CGPoint)pointToBitmapPoint:(CGPoint)point {
  if (CGRectIsNull(bitmapRect)) return CGPointZero;
  CGSize bitmapSize = bitmap.size;
  if (CGSizeEqualToSize(bitmapSize, CGSizeZero)) return CGPointZero;
  point.x -= bitmapRect.origin.x;
  point.y -= bitmapRect.origin.y;
  if (CGSizeEqualToSize(bitmapSize, bitmapRect.size)) return point;
  point.x = (point.x * bitmapSize.width) / bitmapRect.size.width;
  point.y = (point.y * bitmapSize.height) / bitmapRect.size.height;
//  point.y = bitmapSize.height - point.y;
  return point;
}

- (void)drawInContext:(CGContextRef)ctx {
  CGRect rect = CGContextGetClipBoundingBox(ctx);
  CGImageRef image = [bitmap copyImage];
  if (!image) {
    bitmapRect = CGRectZero;
    return;
  }
  CGSize imageSize = bitmap.size;
  CGSize newSize = dtc_sizeFitIn(rect.size, imageSize);
  bitmapRect = dtc_rectIn(rect, newSize, DTC_ALIGN_CENTER, DTC_ALIGN_CENTER);
//  CGContextSaveGState(ctx);
//  CGContextTranslateCTM(ctx, 0, newSize.height);
//  CGContextScaleCTM(ctx, 1.0, -1.0);
  CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
  CGContextDrawImage(ctx, bitmapRect, image);
//  CGContextRestoreGState(ctx);
  CGImageRelease(image);
}

@end
