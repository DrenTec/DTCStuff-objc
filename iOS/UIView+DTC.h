
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

- (void)dtc_forSubviewWhen:(BOOL (^)(UIView *view))predicate
                   recurse:(BOOL)recurse
                        do:(void (^)(UIView *view))handler;
/** Call handler for every subview of kind klass (or if klass is nil, every subview) of receiver
  child views.
 */
- (void)dtc_forSubviewOfKind:(Class)klass
                     recurse:(BOOL)recurse
                          do:(void (^)(UIView *view))handler;
/**
 Apply style to obj.

 Style can be:

 - nil: Do nothing
 - NSString: use styleProvider to retreive dictionary
 - NSDictionary: apply each key/value with the following rules:
     - If value is a dictionary:
         - key of format '<<ClassName', recursively apply value to all subviews of class ClassName
         - key of format '<ClassName', apply value to all immediate subviews of class ClassName
         - key of format '$123', apply value to view with tag 123
         - otherwise set recurse with obj = [obj valueForKeyPath:key]
     - If key has ':' characters, consider value an NSArray of arguments and invoke the
       selector from key on obj.
     - If key is 'include': Fetch all entries of value as styles and apply to obj
     - Otherwise use [obj setValue:value forKeyPath:path]
 */
+ (void)dtc_style:(NSObject *)obj
             with:(id)style
    styleProvider:(NSDictionary *(^)(NSString *styleName))styleProvider;
@end
