#import "UIView+DTC.h"
#import "DTCGeometry.h"
#import <QuartzCore/QuartzCore.h>
#import "NSInvocation+DTC.h"

@implementation UIView (DTC)

- (void)takeHorizontalOf:(CGRect)rect {
  CGRect myRect = self.frame;
  myRect.origin.x = rect.origin.x;
  myRect.size.width = rect.size.width;
  self.frame = myRect;
}

- (void)takeVerticalOf:(CGRect)rect {
  CGRect myRect = self.frame;
  myRect.origin.y = rect.origin.y;
  myRect.size.height = rect.size.height;
  self.frame = myRect;
}

- (void)takeSuperviewWidth {
  CGRect superRect = self.superview.frame;
  superRect.origin.x = 0;
  [self takeHorizontalOf:superRect];
}

- (void)stackUnder:(CGRect)rect {
  CGRect myRect = self.frame;
  myRect.origin.x = rect.origin.x;
  myRect.origin.y = rect.origin.y + rect.size.height;
  myRect.size.width = rect.size.width;
  self.frame = myRect;
}

- (UIView *)dtc_findChildViewOfKind:(Class)klass maxDepth:(NSInteger)maxDepth {
  NSInteger nextDepth = maxDepth == -1 ? -1 : maxDepth - 1;
  for (UIView *view in self.subviews) {
    if ([view isKindOfClass:klass])
      return view;
    if (maxDepth == -1 || maxDepth > 0) {
      UIView *result = [view dtc_findChildViewOfKind:klass maxDepth:nextDepth];
      if (result) return result;
    }
  }
  return nil;
}

- (UIView *)dtc_findChildViewOfKind:(Class)klass {
  return [self dtc_findChildViewOfKind:klass maxDepth:-1];
}

- (UIView *)dtc_findParentViewOfKind:(Class)klass skipSelf:(BOOL)skipSelf maxDistance:(NSInteger)maxDistance {
  UIView *parent = self;
  if (skipSelf) parent = parent.superview;
  while ([parent isKindOfClass:[UIView class]] && (maxDistance == -1 || maxDistance > 0)) {
    if ([parent isKindOfClass:klass]) {
      return parent;
    }
    if (maxDistance != -1) --maxDistance;
    parent = parent.superview;
  }
  return nil;
}

- (UIView *)dtc_findParentViewOfKind:(Class)klass {
  return [self dtc_findParentViewOfKind:klass skipSelf:NO maxDistance:-1];
}

- (BOOL)dtc_isVisibleAndHasSize {
  if (self.hidden) return NO;
  CGRect bounds = self.bounds;
  return bounds.size.width > 0 && bounds.size.height > 0;
}

- (UIImage *)dtc_captureImageRotated:(CGFloat)angle
{
  CGSize viewSize = self.bounds.size;
  CGSize rotatedSize = viewSize;
  if (angle != 0) {
    rotatedSize = dtc_rotatedSize(viewSize, angle);
  }
  UIGraphicsBeginImageContextWithOptions(rotatedSize, self.opaque, 0.0);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  if (angle != 0) {
    CGContextTranslateCTM(ctx, rotatedSize.width / 2., rotatedSize.height / 2.);
    CGContextRotateCTM(ctx, angle);
    CGContextTranslateCTM(ctx, -viewSize.width / 2., -viewSize.height / 2.);
  }
  [self.layer renderInContext:ctx];
  UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

- (void)dtc_forSubviewWhen:(BOOL (^)(UIView *view))predicate
                   recurse:(BOOL)recurse
                        do:(void (^)(UIView *view))handler {
  for (UIView *childView in self.subviews) {
    if ([childView conformsToProtocol:@protocol(UILayoutSupport)])
      continue;
    if (predicate(childView))
      handler(childView);
    if (recurse)
      [childView dtc_forSubviewWhen:predicate
                            recurse:YES
                                 do:handler];
  }
}
- (void)dtc_forSubviewOfKind:(Class)klass
                     recurse:(BOOL)recurse
                          do:(void (^)(UIView *view))handler {
  [self dtc_forSubviewWhen:^BOOL(UIView *childView) { return !klass || [childView isKindOfClass:klass]; }
                   recurse:recurse
                        do:handler];
}

+ (void)dtc_style:(NSObject *)obj
             with:(id)style
    styleProvider:(NSDictionary *(^)(NSString *styleName))styleProvider {
  if ([style isKindOfClass:[NSString class]])
    style = styleProvider(style);
  if (!style)
    return;
  for (NSString *key in style) {
    id value = [style objectForKey:key];
    id object = nil;
    if ([value isKindOfClass:[NSDictionary class]]) {
      if ([key hasPrefix:@"<"]) {
        NSString *className = [key substringFromIndex:1];
        BOOL recursive = NO;
        if ([className hasPrefix:@"<"]) {
          recursive = YES;
          className = [className substringFromIndex:1];
        }
        Class class = NSClassFromString(className);
        if (!class) {
          NSLog(@"Error in style: class name '%@' not found", className);
        } else if (![obj isKindOfClass:[UIView class]]) {
          NSLog(@"Error in style: cannot search for instances of '%@', because the root object is not a UIView (its a %@)", className, obj);
        } else {
          [(UIView *)obj dtc_forSubviewOfKind:class
                                      recurse:recursive
                                           do:^(UIView *view) {
                                             [UIView dtc_style:view with:value styleProvider:styleProvider];
                                           }];
        }
      }
      else {
        if ([key hasPrefix:@"$"]) {
          NSInteger tagNumber = [[key substringFromIndex:1] integerValue];
          object = [(UIView *)obj viewWithTag:tagNumber];
        } else {
          object = [obj valueForKeyPath:key];
        }
        [UIView dtc_style:object with:value styleProvider:styleProvider];
      }
    } else {
      if ([key isEqualToString:@"include"]) {
        NSArray *items = [value isKindOfClass:[NSArray class]] ? (NSArray*)value : [NSArray arrayWithObject:value];
        for (id includedStyle in items)
          [UIView dtc_style:obj with:includedStyle styleProvider:styleProvider];
      } else if ([key rangeOfString:@":"].location != NSNotFound) {
        if (![value isKindOfClass:[NSArray class]]) {
          NSLog(@"Warning: style method call '%@' performed on non array", key);
          value = [NSArray arrayWithObject:value];
        }
        [[NSInvocation dtc_invocationForSelectorName:key
                                                  of:obj
                                                  on:obj
                                           andRetain:NO
                                           arguments:(NSArray *)value] invoke];
      } else {
        [obj setValue:value forKeyPath:key];
      }
    }
  }
}

@end
