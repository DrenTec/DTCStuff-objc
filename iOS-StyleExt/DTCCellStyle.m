#import "DTCCellStyle.h"

@implementation DTCCellStyle

@synthesize
maxSize,
alignmentH,
alignmentV;

+ (DTCCellStyle*)styleWithSize:(CGSize)aMaxSize
                withHAlignment:(DTCAlignment)aHAlignment
                withVAlignment:(DTCAlignment)aVAlignment
                          next:(TTStyle*)next {
  DTCCellStyle* style = [[[self alloc] initWithNext:next] autorelease];
  style.maxSize = aMaxSize;
  style.alignmentH = aHAlignment;
  style.alignmentV = aVAlignment;
  return style;
}

- (id)init {
  if ((self = [super init])) {
    maxSize = CGSizeZero;
  }
  return self;
}

- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  CGRect contentFrameOriginal = context.contentFrame;
  CGRect contentFrame = contentFrameOriginal;
  if (maxSize.width > 0) contentFrame.size.width = maxSize.width;
  context.contentFrame = contentFrame;
  CGSize cellSize = [self.next addToSize:CGSizeZero context:context];
  context.contentFrame = contentFrameOriginal;
  if (maxSize.width > 0) cellSize.width = maxSize.width;
  if (maxSize.height > 0) cellSize.height = maxSize.height;
  cellSize.width += size.width;
  cellSize.height += size.height;
  return cellSize;
}

- (void)draw:(TTStyleContext*)context {
  CGSize cellSize = [self.next addToSize:CGSizeZero context:context];
  CGRect contextFrameRect = context.frame;
  CGRect contextContentRect = context.contentFrame;
  if (maxSize.width > 0) cellSize.width = maxSize.width;
  if (maxSize.height > 0) cellSize.height = maxSize.height;
  CGRect partFrameRect = dtc_rectIn(contextFrameRect, cellSize, alignmentH, alignmentV);
  CGRect partContentRect = dtc_rectIn(contextContentRect, cellSize, alignmentH, alignmentV);
	[context setFrame:partFrameRect];
  [context setContentFrame:partContentRect];
  context.didDrawContent = YES;
  [_next draw:context];
	[context setFrame:contextFrameRect];
  [context setContentFrame:contextContentRect];
}

@end
