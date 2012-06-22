#import "TTStyle.h"

/** Evaluates the text for conditionalField, if empty of \c "0" uses \c nextIfFalse to continue rendering,
 else uses \c nextIfTrue */
@interface DTCSwitchStyle : TTStyle {
  TTStyle *conditionalField;
  TTStyle *nextIfTrue;
  TTStyle *nextIfFalse;
}
@property (nonatomic, retain) TTStyle *conditionalField;
@property (nonatomic, retain) TTStyle *nextIfTrue;
@property (nonatomic, retain) TTStyle *nextIfFalse;

+ (DTCSwitchStyle *)styleTesting:(TTStyle *)aConditionalField
                          ifTrue:(TTStyle *)aNextIfTrue
                         ifEmpty:(TTStyle *)aNextIfFalse;
@end
