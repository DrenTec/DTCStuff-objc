#import "TTStyle.h"
#import "DTCGeometry.h"

/** Places a list of styles in a row or column, using item requested size */
@interface DTCStackStyle : TTStyle {
  BOOL vertical;
  CGFloat spacing;
  DTCAlignment stackInternalAlignment;
  NSInteger variableItemIndex;
  NSArray *styles;
}

+ (DTCStackStyle*)styleToStackVertically:(BOOL)isVertical
                             withSpacing:(CGFloat)aSpacing
                       internallyAligned:(DTCAlignment)anAlignment
                            resizingItem:(NSInteger)anItemIndex
                           forStyleArray:(NSArray *)aStyleArray;
+ (DTCStackStyle*)styleToStackVertically:(BOOL)isVertical
                             withSpacing:(CGFloat)aSpacing
                       internallyAligned:(DTCAlignment)anAlignment
                            resizingItem:(NSInteger)anItemIndex
                               forStyles:(id)firstStyle, ...;
+ (DTCStackStyle*)styleToStackVertically:(BOOL)isVertical
                             withSpacing:(CGFloat)aSpacing
                       internallyAligned:(DTCAlignment)anAlignment
                               forStyles:(id)firstStyle, ...;

+ (DTCStackStyle *)centerAlignedRowSpaced:(CGFloat)aSpacing next:(id)firstStyle, ...;
+ (DTCStackStyle *)centerAlignedRowSpaced:(CGFloat)aSpacing resizeableItem:(NSInteger)aResizable next:(id)firstStyle, ...;
+ (DTCStackStyle *)leftAlignedColumnSpaced:(CGFloat)aSpacing next:(id)firstStyle, ...;
+ (DTCStackStyle *)leftAlignedColumnSpaced:(CGFloat)aSpacing resizeableItem:(NSInteger)aResizable next:(id)firstStyle, ...;

@property (nonatomic, assign) BOOL vertical;
/** Spacing between non empty items */
@property (nonatomic, assign) CGFloat spacing;
/** If this is a vertical stack, specifies horizontal item alignment and vice versa */
@property (nonatomic, assign) DTCAlignment stackInternalAlignment;
/** If this is a valid index, the item at this index will be redimensionned to
 adapt to the current frame */
@property (nonatomic, assign) NSInteger variableItemIndex;
@property (nonatomic, retain) NSArray *styles;

@end
