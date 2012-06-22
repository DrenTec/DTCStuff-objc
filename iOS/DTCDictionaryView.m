#import "DTCDictionaryView.h"

@implementation DTCDictionaryView
@synthesize
 labelFont,
 valueFont,
 labelColor,
 valueColor,
 dictionary;

#define LABEL_MAX_WIDTH 80.
#define CONTROL_PADDING CGSizeMake(10., 8.)
#define LABEL_SPACING CGSizeMake(10., 6.)

- (CGSize)sizeThatFits:(CGSize)size {
  CGRect contentRect = self.bounds;
  contentRect.size = size;
  CGSize padding = CONTROL_PADDING;
	contentRect = CGRectInset(contentRect, padding.width, padding.height);
	CGSize mySize = contentRect.size;
  CGSize spacing = LABEL_SPACING;
  CGFloat labelMaxWidth = LABEL_MAX_WIDTH - spacing.width / 2.;
  CGFloat valueMaxWidth = mySize.width - LABEL_MAX_WIDTH - spacing.width;
  NSArray *orderedKeys = [[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  for (NSString *key in orderedKeys) {
    NSString *value = [[dictionary objectForKey:key] description];
    CGSize keySize = [key sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    CGSize valueSize = [value sizeWithFont:valueFont constrainedToSize:CGSizeMake(valueMaxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    contentRect.origin.y += fmaxf(valueSize.height, keySize.height) + spacing.height;
  }
  CGSize res = CGSizeMake(size.width, contentRect.origin.y);
  return res;
}

- (void)drawRect:(CGRect)rect {
  CGSize padding = CONTROL_PADDING;
	CGRect contentRect = CGRectInset(self.bounds, padding.width, padding.height);
	CGSize mySize = contentRect.size;
  CGSize spacing = LABEL_SPACING;
  CGFloat labelMaxWidth = LABEL_MAX_WIDTH - spacing.width / 2.;
  CGFloat valueMaxWidth = mySize.width - LABEL_MAX_WIDTH - spacing.width;
  NSArray *orderedKeys = [[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  for (NSString *key in orderedKeys) {
    NSString *value = [[dictionary objectForKey:key] description];
    CGSize keySize = [key sizeWithFont:labelFont constrainedToSize:CGSizeMake(labelMaxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    CGSize valueSize = [value sizeWithFont:valueFont constrainedToSize:CGSizeMake(valueMaxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    CGRect keyRect = CGRectMake(contentRect.origin.x, contentRect.origin.y, labelMaxWidth, CGFLOAT_MAX);
    CGRect valueRect = CGRectMake(contentRect.origin.x + labelMaxWidth + spacing.width, contentRect.origin.y, valueMaxWidth, CGFLOAT_MAX);
    [labelColor setFill];
    [key drawInRect:keyRect withFont:labelFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
    [valueColor setFill];
    [value drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    contentRect.origin.y += fmaxf(valueSize.height, keySize.height) + spacing.height;
  }
}

@end
