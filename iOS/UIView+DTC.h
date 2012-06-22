
#define DTC_VIEW_INIT(method_to_call) \
  - (id)initWithFrame:(CGRect)frame { \
    if (self = [super initWithFrame:frame]) { \
      [self method_to_call]; \
    } \
    return self; \
  } \
  - (id)initWithCoder:(NSCoder *)aDecoder { \
    if (self = [super initWithCoder:aDecoder]) { \
      [self method_to_call]; \
    } \
    return self; \
  }


@interface UIView (DTC)

- (BOOL)dtc_isVisibleAndHasSize;
- (UIImage *)dtc_captureImageRotated:(CGFloat)angle;
- (UIView *)dtc_findChildViewOfKind:(Class)klass maxDepth:(NSInteger)maxDepth;
- (UIView *)dtc_findChildViewOfKind:(Class)klass;
- (UIView *)dtc_findParentViewOfKind:(Class)klass skipSelf:(BOOL)skipSelf maxDistance:(NSInteger)maxDistance;
- (UIView *)dtc_findParentViewOfKind:(Class)klass;

@end
