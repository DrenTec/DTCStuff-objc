#import "TTStyle.h"
#import "TTView.h"

/** Hosts a model and advanced style, executes image requests */
@interface DTCModelStyleView : TTView {
	NSObject *model;
  NSMutableDictionary *pendingImages;
}

+ (CGSize)calculateSizeFor:(NSObject *)model withStyle:(TTStyle*)style thatFits:(CGSize)sizeToFit;

@property (retain, nonatomic) NSObject *model;

@end
