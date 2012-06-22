
#import "DTCStuffPlatform.h"

#if DTC_Platform_OSX
# define DTCBitmapNativeImage NSImage
#elif DTC_Platform_iOS
# define DTCBitmapNativeImage UIImage
#endif

#import <Foundation/Foundation.h>

@interface DTCBitmap : NSObject {
  NSInteger width;
  NSInteger height;
  CGContextRef context;
  unsigned char *bitmap;
}

+ (DTCBitmap *)bitmap;
+ (DTCBitmap *)bitmapOfSize:(CGSize)size;
+ (DTCBitmap *)bitmapWithCopyOf:(DTCBitmapNativeImage *)image;

- (void)clear;
- (void)setWidth:(NSInteger)aWidth height:(NSInteger)aHeight;
- (CGImageRef)copyImage;
- (void)setImage:(DTCBitmapNativeImage *)image;

@property (readonly) CGSize size;
@property (readonly, nonatomic) CGContextRef context;
@property (readonly, nonatomic) unsigned char *bitmap;

@end

@interface DTCBitmap (Protected)

- (void)bitmapDidInit;

@end