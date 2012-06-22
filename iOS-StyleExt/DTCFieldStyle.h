#import "TTStyle.h"

@class DTCModelStyleView;

@interface DTCFieldStyle : TTStyle {
  NSString *(^transformer)(DTCModelStyleView*,id);
}

+ (DTCFieldStyle *)usingField:(NSString*)aFieldName next:(TTStyle*)next;
+ (DTCFieldStyle *)usingField:(NSString*)aFieldName;
+ (DTCFieldStyle *)usingTransformer:(NSString *(^)(DTCModelStyleView*,id))aTransformer;
+ (DTCFieldStyle *)usingJoined:(NSString*)aSeparator fields:(NSString*)aFirstFieldName, ...;

@property (retain, nonatomic) NSString *(^transformer)(DTCModelStyleView*,id);

- (NSString*)textForModel:(id)model inView:(DTCModelStyleView*)view;

@end

@interface DTCStaticTextStyle : DTCFieldStyle {
  
}

@end