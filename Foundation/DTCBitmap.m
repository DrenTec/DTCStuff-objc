#import "DTCBitmap.h"

@implementation DTCBitmap

+ (DTCBitmap *)bitmap {
  return [[[self alloc] init] autorelease];
}

+ (DTCBitmap *)bitmapOfSize:(CGSize)size {
  DTCBitmap *instance = [self bitmap];
  [instance setWidth:(NSInteger)size.width height:(NSInteger)size.height];
  return instance;
}

+ (DTCBitmap *)bitmapWithCopyOf:(DTCBitmapNativeImage *)image {
  DTCBitmap *instance = [self bitmap];
  [instance setImage:image];
  return instance;
}

- (void)dealloc {
  [self clear];
  [super dealloc];
}

- (void)initBitmap {
  [self clear];
  if (width > 0 && height > 0) {
    bitmap = malloc(height * width * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(bitmap, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
  }
}

- (CGSize)size {
  return CGSizeMake(width, height);
}

- (CGContextRef)context {
  if (!context) [self initBitmap];
  return context;
}

- (unsigned char *)bitmap {
  if (!bitmap) [self initBitmap];
  return bitmap;
}

- (void)clear {
  if (context)
    CGContextRelease(context);
  context = NULL;
  free(bitmap);
  bitmap = NULL;
}

- (void)setWidth:(NSInteger)aWidth height:(NSInteger)aHeight {
  if (bitmap && aWidth == width && aHeight == height)
    return;
  width = aWidth;
  height = aHeight;
  [self clear];
}

- (CGImageRef)copyImage {
  if (!context) return NULL;
  return CGBitmapContextCreateImage(context);
}

- (void)setImage:(DTCBitmapNativeImage *)image {
  if (width == 0 || height == 0) {
    CGSize size = image.size;
    [self setWidth:(NSInteger)size.width height:(NSInteger)size.height];
  }
  if (!context) [self initBitmap];
  if (!context) return;
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, 0, height);
  CGContextScaleCTM(context, 1.0, -1.0);
#if DTC_Platform_iOS
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
#elif DTC_Platform_OSX
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImageForProposedRect:NULL context:nil hints:nil]);
#endif
  
  CGContextRestoreGState(context);
}

@end

@implementation DTCBitmap (Protected)

- (void)bitmapDidInit {}

@end
