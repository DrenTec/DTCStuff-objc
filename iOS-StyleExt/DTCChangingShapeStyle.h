#import "TTStyle.h"
#import "TTShapeStyle.h"

@class TTShapeStyle;

@interface DTCChangingShapeStyle : TTShapeStyle {
	TTShape *soleShape;
	TTShape *firstShape;
  TTShape *middleShape;
  TTShape *lastShape;
}

/**
	Applies a different shape depending on wether the drawing delegate is the last
  or first view.
	@param aFirstShape The shape to use for the first entry
	@param aMiddleShape The shape to use for intermediary entries
	@param aLastShape The shape to use for the last entry
	@param next The next TTStyle in the chain
 */
+ (DTCChangingShapeStyle*)styleWithOnlyShape:(TTShape*)aSoleShape
                                orFirstShape:(TTShape*)aFirstShape
                                 middleShape:(TTShape*)aMiddleShape
                                   lastShape:(TTShape*)aLastShape
                                        next:(TTStyle*)next;
@property (retain, nonatomic) TTShape *soleShape;
@property (retain, nonatomic) TTShape *firstShape;
@property (retain, nonatomic) TTShape *middleShape;
@property (retain, nonatomic) TTShape *lastShape;

@end
