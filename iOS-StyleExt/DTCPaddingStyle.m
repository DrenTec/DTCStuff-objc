
#import "DTCPaddingStyle.h"
#import "TTStyleContext.h"

@implementation DTCPaddingStyle

@synthesize padding;

+ (DTCPaddingStyle*)styleWithPadding:(UIEdgeInsets)aPadding next:(TTStyle*)next {
  DTCPaddingStyle* style = [[[self alloc] initWithNext:next] autorelease];
  style.padding = aPadding;
  return style;
}

- (id)init {
  if ((self = [super init])) {
    padding = UIEdgeInsetsZero;
  }
  return self;
}

- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  CGRect contextFrameRect = context.frame;
  CGRect contextContentRect = context.contentFrame;
  CGRect partFrameRect = contextFrameRect;
  CGRect partContentRect = contextFrameRect;
  partFrameRect.origin.x += padding.left;
  partFrameRect.origin.y += padding.top;
  partFrameRect.size.width -= padding.left + padding.right;
  partFrameRect.size.height -= padding.top + padding.bottom;
  partContentRect.origin.x += padding.left;
  partContentRect.origin.y += padding.top;
  partContentRect.size.width -= padding.left + padding.right;
  partContentRect.size.height -= padding.top + padding.bottom;
	[context setFrame:partFrameRect];
  [context setContentFrame:partContentRect];
  CGSize cellSize = [self.next addToSize:size context:context];
	[context setFrame:contextFrameRect];
  [context setContentFrame:contextContentRect];
  cellSize.width += padding.left + padding.right;
  cellSize.height += padding.top + padding.bottom;
  return cellSize;
}

- (void)draw:(TTStyleContext*)context {
  CGRect contextFrameRect = context.frame;
  CGRect contextContentRect = context.contentFrame;
  CGRect partFrameRect = contextFrameRect;
  CGRect partContentRect = contextFrameRect;
  partFrameRect.origin.x += padding.left;
  partFrameRect.origin.y += padding.top;
  partFrameRect.size.width -= padding.left + padding.right;
  partFrameRect.size.height -= padding.top + padding.bottom;
  partContentRect.origin.x += padding.left;
  partContentRect.origin.y += padding.top;
  partContentRect.size.width -= padding.left + padding.right;
  partContentRect.size.height -= padding.top + padding.bottom;
	[context setFrame:partFrameRect];
  [context setContentFrame:partContentRect];
  [_next draw:context];
	[context setFrame:contextFrameRect];
  [context setContentFrame:contextContentRect];
}


@end
