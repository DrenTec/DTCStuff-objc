
#import "TTStyle.h"
#import "TTStyleContext.h"
#import "DTCGeometry.h"

/** Places the next style aligned in the content frame, using its requested size.
 Reports a fixed size for non-0 dimensions. */
@interface DTCCellStyle : TTStyle {
	CGSize maxSize;
  DTCAlignment alignmentH;
  DTCAlignment alignmentV;
}

+ (DTCCellStyle*)styleWithSize:(CGSize)aMaxSize
                withHAlignment:(DTCAlignment)aHAlignment
                withVAlignment:(DTCAlignment)aVAlignment
                          next:(TTStyle*)next;

@property (nonatomic, assign) CGSize maxSize;
@property (nonatomic, assign) DTCAlignment alignmentH;
@property (nonatomic, assign) DTCAlignment alignmentV;
@end
