#import "DTCAlignStyle.h"
#import "TTStyleContext.h"

#define DTC_ALIGN_STYLE_DEFAULT_SPACING 5

@implementation DTCAlignStyle
@synthesize minSize, spacing, vertical, styleToPlace;
- (id)init {
  if ((self = [super init])) {
    minSize = CGSizeZero;
  }
  return self;
}

+ (TTStyle*)styleToPlaceVerticaly:(BOOL)isVertical
                      withSpacing:(CGFloat)spacingz
                             next:(TTStyle*)next, ... {
  va_list args;
  TTStyle* cur = next;
  TTStyle* second = nil;
  va_start(args, next);
  while (cur) {
    if (second) {
      second = [DTCAlignStyle styleToPlace:second vertically:isVertical withSpacing:spacingz andAtLeast:CGSizeZero
                                      next:cur];
    }
    else
      second = cur;
    cur = va_arg(args, TTStyle*);
  }
  va_end(args);
  return second ?: cur;
}

+ (DTCAlignStyle*)styleToPlace:(TTStyle*)stylez
                    vertically:(BOOL)verticalz
                   withSpacing:(CGFloat)spacingz
                    andAtLeast:(CGSize)minSizez
                          next:(TTStyle*)next {
  DTCAlignStyle* style = [[[self alloc] initWithNext:next] autorelease];
  style.styleToPlace = stylez;
  style.vertical = verticalz;
  style.spacing = spacingz;
  style.minSize = minSizez;
  return style;
}

+ (DTCAlignStyle*)styleToPlace:(TTStyle*)stylez leftOf:(TTStyle*)next {
  return [self styleToPlace:stylez
                 vertically:NO
                withSpacing:DTC_ALIGN_STYLE_DEFAULT_SPACING
                 andAtLeast:CGSizeZero
                       next:next];
}
+ (DTCAlignStyle*)styleToPlace:(TTStyle*)stylez above:(TTStyle*)next {
  return [self styleToPlace:stylez
                 vertically:YES
                withSpacing:DTC_ALIGN_STYLE_DEFAULT_SPACING
                 andAtLeast:CGSizeZero
                       next:next];
}

- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  CGSize placedSize = !styleToPlace ? CGSizeZero :
  	[styleToPlace addToSize:CGSizeZero context:context];
  CGSize nextSize = !_next ? CGSizeZero :
    [_next addToSize:CGSizeZero context:context];
  BOOL areBothRendering =
    placedSize.width > 0 && placedSize.height > 0 &&
    nextSize.width > 0 && nextSize.height > 0;
  CGSize totalSize;
  if (vertical) {
    totalSize.width = placedSize.width > nextSize.width ? placedSize.width : nextSize.width;
    totalSize.height = placedSize.height + nextSize.height + (areBothRendering ? spacing : 0);
  } else {
    totalSize.width = placedSize.width + nextSize.width + (areBothRendering ? spacing : 0);
    totalSize.height = placedSize.height > nextSize.height ? placedSize.height : nextSize.height;
  }
  if (minSize.width > 0 && totalSize.width < minSize.width) totalSize.width = minSize.width;
  if (minSize.height > 0 && totalSize.height < minSize.height) totalSize.height = minSize.height;
  size.width += totalSize.width;
  size.height += totalSize.height;
  return size;
}

- (void)draw:(TTStyleContext*)context {
  if (!styleToPlace || !_next) {
    [styleToPlace draw:context];
    [_next draw:context];
    return;
  }
  CGSize totalSize;
  CGSize placedSize = !styleToPlace ? CGSizeZero :
  	[styleToPlace addToSize:CGSizeZero context:context];
  CGSize nextSize = !_next ? CGSizeZero :
  	[_next addToSize:CGSizeZero context:context];
  BOOL areBothRendering =
  placedSize.width > 0 && placedSize.height > 0 &&
  nextSize.width > 0 && nextSize.height > 0;
  if (vertical) {
    totalSize.width = placedSize.width > nextSize.width ? placedSize.width : nextSize.width;
    totalSize.height = placedSize.height + nextSize.height + (areBothRendering ? spacing : 0);
  } else {
    totalSize.width = placedSize.width + nextSize.width + (areBothRendering ? spacing : 0);
    totalSize.height = placedSize.height > nextSize.height ? placedSize.height : nextSize.height;
  }
  CGRect contextFrameRect = context.frame;
  CGRect contextRect = context.contentFrame;
  CGRect partFrameRect = contextFrameRect;
  CGRect partRect = contextRect;
  if (vertical) {
    partRect.size.height = contextRect.size.height * (placedSize.height / totalSize.height);
		partFrameRect.size.height = contextFrameRect.size.height * (placedSize.height / totalSize.height);
    [context setFrame:partFrameRect];
    [context setContentFrame:partRect];
    [styleToPlace draw:context];
    partRect.origin.y += partRect.size.height + spacing;
    partRect.size.height = contextRect.size.height - partRect.size.height - spacing;
    partFrameRect.origin.y += partFrameRect.size.height + spacing;
    partFrameRect.size.height = contextFrameRect.size.height - partFrameRect.size.height - spacing;
  } else {
    partRect.size.width = (contextRect.size.width * placedSize.width) / totalSize.width;
		partFrameRect.size.width = contextFrameRect.size.width * (placedSize.width / totalSize.width);
    [context setFrame:partFrameRect];
    [context setContentFrame:partRect];
    [styleToPlace draw:context];
    partRect.origin.x += partRect.size.width + spacing;
    partRect.size.width = contextRect.size.width - partRect.size.width - spacing;
    partFrameRect.origin.x += partFrameRect.size.width + spacing;
    partFrameRect.size.width = contextFrameRect.size.width - partFrameRect.size.width - spacing;
  }
	[context setFrame:partFrameRect];
  [context setContentFrame:partRect];
  [_next draw:context];
	[context setFrame:contextFrameRect];
  [context setContentFrame:contextRect];
}


- (void)dealloc {
  self.styleToPlace = nil;
  [super dealloc];
}

@end
