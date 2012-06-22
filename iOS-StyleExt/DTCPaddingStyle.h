#import "TTStyle.h"

@interface DTCPaddingStyle : TTStyle {
	UIEdgeInsets padding;
}

@property (nonatomic, assign) UIEdgeInsets padding;

+ (DTCPaddingStyle*)styleWithPadding:(UIEdgeInsets)aPadding next:(TTStyle*)next;

@end
