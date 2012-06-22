#import "DTCSpreadLineLayout.h"

@implementation DTCSpreadLineLayout

+ (DTCSpreadLineLayout *)centeredLayout {
  DTCSpreadLineLayout *res = [[[self alloc] init] autorelease];
  res->center = YES;
  return res;
}

- (CGSize)layoutSubviews:(NSArray*)subviews forView:(UIView*)view {
  CGRect rContainer = view.frame;
  CGFloat x = 0;
  int subviewCount = 0;
  CGFloat rowHeight = 0;
  CGFloat curWidth = 0;
  for (UIView* subview in subviews) {
    CGRect r = [subview frame];
    subviewCount++;
    curWidth += r.size.width;
    if (r.size.height > rowHeight) {
      rowHeight = r.size.height;
    }
  }
  CGFloat spacing = (rContainer.size.width - curWidth) / (CGFloat)(center ? 2 : subviewCount + 1);
  for (UIView* subview in subviews) {
    CGRect r = [subview frame];
    r.origin.x = x + spacing;
    r.origin.y = (rContainer.size.height - r.size.height) / 2.f;
    x += r.size.width + (center ? 0 : spacing);
    subview.frame = r;
  }
  return rContainer.size;
}

@end
