#import "DTCStackStyle.h"
#import "TTStyleContext.h"
#import "DTCMacros.h"

@implementation DTCStackStyle

@synthesize
 vertical,
 spacing,
 stackInternalAlignment,
 variableItemIndex,
 styles;

- (id)initWithNext:(TTStyle *)next {
  if (self = [super initWithNext:next]) {
    variableItemIndex = -1;
  }
  return self;
}

+ (DTCStackStyle*)styleToStackVertically:(BOOL)isVertical
                             withSpacing:(CGFloat)aSpacing
                       internallyAligned:(DTCAlignment)anAlignment
                            resizingItem:(NSInteger)anItemIndex
                           forStyleArray:(NSArray *)aStyleArray {
  DTCStackStyle* style = [[[self alloc] initWithNext:nil] autorelease];
  style.vertical = isVertical;
  style.spacing = aSpacing;
  style.stackInternalAlignment = anAlignment;
  style.variableItemIndex = anItemIndex;
  style.styles = aStyleArray;
  return style;
}
+ (DTCStackStyle*)styleToStackVertically:(BOOL)isVertical
                             withSpacing:(CGFloat)aSpacing
                       internallyAligned:(DTCAlignment)anAlignment
                            resizingItem:(NSInteger)anItemIndex
                               forStyles:(id)firstStyle, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, firstStyle, id)
  return [self styleToStackVertically:isVertical withSpacing:aSpacing
                    internallyAligned:anAlignment resizingItem:anItemIndex
                        forStyleArray:items];
}

+ (DTCStackStyle*)styleToStackVertically:(BOOL)isVertical
                             withSpacing:(CGFloat)aSpacing
                       internallyAligned:(DTCAlignment)anAlignment
                               forStyles:(id)firstStyle, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, firstStyle, id)
  return [self styleToStackVertically:isVertical withSpacing:aSpacing
                    internallyAligned:anAlignment resizingItem:-1
                        forStyleArray:items];
}

+ (DTCStackStyle *)leftAlignedColumnSpaced:(CGFloat)aSpacing
                            resizeableItem:(NSInteger)aResizable
                                      next:(id)firstStyle, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, firstStyle, id)
  return [self styleToStackVertically:YES
                          withSpacing:aSpacing
                    internallyAligned:DTC_ALIGN_LEFT
                         resizingItem:aResizable
                        forStyleArray:items];
}
+ (DTCStackStyle *)leftAlignedColumnSpaced:(CGFloat)aSpacing
                                      next:(id)firstStyle, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, firstStyle, id)
  return [self styleToStackVertically:YES
                          withSpacing:aSpacing
                    internallyAligned:DTC_ALIGN_LEFT
                         resizingItem:-1
                        forStyleArray:items];
}
+ (DTCStackStyle *)centerAlignedRowSpaced:(CGFloat)aSpacing
                           resizeableItem:(NSInteger)aResizable
                                     next:(id)firstStyle, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, firstStyle, id)
  return [self styleToStackVertically:NO
                          withSpacing:aSpacing
                    internallyAligned:DTC_ALIGN_CENTER
                         resizingItem:aResizable
                        forStyleArray:items];
}
+ (DTCStackStyle *)centerAlignedRowSpaced:(CGFloat)aSpacing
                                     next:(id)firstStyle, ... {
  DTC_VARARGS_UNTIL_NIL_TO_ARRAY(items, firstStyle, id)
  return [self styleToStackVertically:NO
                          withSpacing:aSpacing
                    internallyAligned:DTC_ALIGN_CENTER
                         resizingItem:-1
                        forStyleArray:items];
}

- (CGSize)addToSize:(CGSize)size context:(TTStyleContext*)context {
  NSAssert(!self.next, @"Theres a next on a stack style !");
  CGSize cellSize = size;
  NSUInteger styleCount = [self.styles count];
  CGSize styleSizes[styleCount];
  for (NSUInteger i = 0; i < styleCount; i++) {
    styleSizes[i] = [(TTStyle*)[self.styles objectAtIndex:i] addToSize:CGSizeZero context:context];
  }
  CGSize maxSize = CGSizeZero;
  CGSize sumSize = CGSizeZero;
  for (NSUInteger i = 0; i < styleCount; i++) {
    CGSize curSize = styleSizes[i];
    if (curSize.width > 0 && curSize.height > 0) {
      if (sumSize.width > 0 || sumSize.height > 0) {
        if (vertical) {
          sumSize.height += spacing;
        } else {
          sumSize.width += spacing;
        }
      }
      if (curSize.width > maxSize.width) maxSize.width = curSize.width;
      if (curSize.height > maxSize.height) maxSize.height = curSize.height;
      sumSize.width += curSize.width;
      sumSize.height += curSize.height;
    }
  }
  cellSize.width += (vertical ? maxSize : sumSize).width;
  cellSize.height += (vertical ? sumSize : maxSize).height;
  return cellSize;
}

- (void)draw:(TTStyleContext*)context {
  CGRect contextFrameRect = context.frame;
  CGRect contextContentRect = context.contentFrame;
  NSArray *childStyles = self.styles;
  NSUInteger styleCount = [childStyles count];
  CGSize styleSizes[styleCount];
  CGSize sumSize = CGSizeZero;
  CGSize curSize = CGSizeZero;
  NSInteger i = 0;
  for (TTStyle *style in childStyles) {
		curSize = styleSizes[i++] = [style addToSize:CGSizeZero context:context];
    if (curSize.width > 0 && curSize.height > 0 && (sumSize.width > 0 || sumSize.height > 0)) {
      if (vertical) {
        sumSize.height += spacing;
      } else {
        sumSize.width += spacing;
      }
    }
    sumSize.width += curSize.width;
    sumSize.height += curSize.height;
  }
  i = 0;
  CGSize runningSumSize = CGSizeZero;
  for (TTStyle *style in childStyles) {
    curSize = styleSizes[i];
#ifndef __clang_analyzer__
    // Clang complains because iterated array is dissassociated from the styleSizes array
    if (curSize.width > 0 && curSize.height > 0) {
#endif
      if (runningSumSize.width > 0 || runningSumSize.height > 0) {
        if (vertical) {
          runningSumSize.height += spacing;
        } else {
          runningSumSize.width += spacing;
        }
      }
      CGRect remainingFrameRect = contextFrameRect;
      CGRect remainingContentRect = contextContentRect;
      if (vertical) {
        remainingFrameRect.origin.y += runningSumSize.height;
        remainingContentRect.origin.y += runningSumSize.height;
        remainingFrameRect.size.height -= runningSumSize.height;
        remainingContentRect.size.height -= runningSumSize.height;
      } else {
        remainingFrameRect.origin.x += runningSumSize.width;
        remainingContentRect.origin.x += runningSumSize.width;
        remainingFrameRect.size.width -= runningSumSize.width;
        remainingContentRect.size.width -= runningSumSize.width;
      }
      CGSize partContentSize = curSize;
      if (i == variableItemIndex) {
        if (vertical) {
          curSize.height += contextFrameRect.size.height - sumSize.height;
          partContentSize.height += contextFrameRect.size.height - sumSize.height;
        } else {
          curSize.width += contextFrameRect.size.width - sumSize.width;
          partContentSize.width += contextContentRect.size.width - sumSize.width;
        }
      }
      CGRect partFrameRect = dtc_rectIn(remainingFrameRect, curSize,
                                        vertical ? stackInternalAlignment : DTC_ALIGN_NEAR,
                                        vertical ? DTC_ALIGN_NEAR : stackInternalAlignment);
      CGRect partContentRect = dtc_rectIn(remainingContentRect, partContentSize,
                                          vertical ? stackInternalAlignment : DTC_ALIGN_NEAR,
                                          vertical ? DTC_ALIGN_NEAR : stackInternalAlignment);
      [context setFrame:partFrameRect];
      [context setContentFrame:partContentRect];
      [style draw:context];
      runningSumSize.width += curSize.width;
      runningSumSize.height += curSize.height;
    }
    i++;
  }
  [context setFrame:contextFrameRect];
  [context setContentFrame:contextContentRect];
}

- (void)dealloc {
  self.styles = nil;
  [super dealloc];
}

@end
