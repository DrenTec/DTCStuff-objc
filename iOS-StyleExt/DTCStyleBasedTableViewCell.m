#import "DTCStyleBasedTableViewCell.h"
#import "DTCModelStyleView.h"
#import "TTGlobalUICommon.h"

@implementation DTCStyleBasedTableItem

@synthesize
  stylePrefix,
	model;

+ (DTCStyleBasedTableItem *)itemWithStyle:(NSString*)aStylePrefix forObject:(id)anObject {
  DTCStyleBasedTableItem *newItem = [[[self alloc] init] autorelease];
  newItem.stylePrefix = aStylePrefix;
  newItem.model = anObject;
  return newItem;
}

- (void)dealloc {
  self.stylePrefix = nil;
  self.model = nil;
  [super dealloc];
}

+ (CGFloat)performFloatReturningSelector:(SEL)selector
                                      on:(NSObject *)object {
  CGFloat (*floatReaderFunc)(id, SEL) = nil;
  floatReaderFunc = (CGFloat (*)(id, SEL))[object methodForSelector:selector];
  if (floatReaderFunc)
    return floatReaderFunc(object, selector);
  return 0;
}

+ (NSString *)getURLOf:(NSObject *)object
           usingPrefix:(NSString *)aStylePrefix {
  if ([object isKindOfClass:self]) {
    return [(DTCStyleBasedTableItem *)object URLValue];
  }
  SEL urlValueSel = aStylePrefix ?
    NSSelectorFromString([aStylePrefix stringByAppendingString:@"URLValue"]) :
    @selector(URLValue);
  if ([object respondsToSelector:urlValueSel])
    return [object performSelector:urlValueSel];
	return nil;
}

+ (TTStyle *)getStyleOf:(NSObject *)object
            usingPrefix:(NSString *)aStylePrefix {
  if ([object isKindOfClass:self]) {
    return [(DTCStyleBasedTableItem *)object style];
  }
  SEL styleSel = aStylePrefix ?
    NSSelectorFromString([aStylePrefix stringByAppendingString:@"Style"]) :
    @selector(tableCellStyle);
  if ([object respondsToSelector:styleSel])
    return [object performSelector:styleSel];
	return nil;
}

+ (CGFloat)getHeightOf:(NSObject *)object
           usingPrefix:(NSString *)aStylePrefix {
  if ([object isKindOfClass:self]) {
    return [(DTCStyleBasedTableItem *)object rowHeight];
  }
  SEL heightSel = @selector(tableCellHeight);
  SEL maxHeightSel = @selector(tableCellMaxHeight);
  if (aStylePrefix) {
    heightSel = NSSelectorFromString([aStylePrefix stringByAppendingString:@"Height"]);
    maxHeightSel = NSSelectorFromString([aStylePrefix stringByAppendingString:@"MaxHeight"]);
  }
  BOOL isMaxHeight = [object respondsToSelector:maxHeightSel];
	CGFloat maxHeight = 78;
  if (isMaxHeight) {
    maxHeight = [self performFloatReturningSelector:maxHeightSel on:object];
  } else if ([object respondsToSelector:heightSel]) {
    return [self performFloatReturningSelector:heightSel on:object];
  } else {
    return 78;
  }
  TTStyle *currentStyle = [self getStyleOf:object usingPrefix:aStylePrefix];
  if (currentStyle) {
    CGSize sz = [DTCModelStyleView calculateSizeFor:object withStyle:currentStyle thatFits:CGSizeMake(TTApplicationFrame().size.width, maxHeight)];
    if (sz.height > 0 && sz.height < maxHeight) {
      return sz.height + 1;
    }
  }
  return maxHeight;
}

- (NSString *)URLValue {
	return [[self class] getURLOf:self.model usingPrefix:self.stylePrefix];  
}

- (TTStyle *)style {
	return [[self class] getStyleOf:self.model usingPrefix:self.stylePrefix];
}

- (CGFloat)rowHeight {
  return [[self class] getHeightOf:self.model usingPrefix:self.stylePrefix];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder*)decoder {
  if (self = [self init]) {
    self.stylePrefix = [decoder decodeObjectForKey:@"stylePrefix"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
  if (self.stylePrefix)
    [encoder encodeObject:self.stylePrefix forKey:@"stylePrefix"];
}

@end


@implementation DTCStyleBasedTableViewCell

@synthesize imageView, modelView;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.modelView = [[[DTCModelStyleView alloc] initWithFrame:CGRectZero] autorelease];
    self.modelView.opaque = YES;
    [self.contentView addSubview:self.modelView];
  }
  return self;
}

- (void) setBackgroundColor:(UIColor *)newColor {
  self.modelView.backgroundColor = newColor;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  return [DTCStyleBasedTableItem getHeightOf:object usingPrefix:nil];
}

- (void)setFrame:(CGRect)newFrame {
  [super setFrame:newFrame];
  newFrame.origin = CGPointZero;
  newFrame.size.height -= 1;
  self.modelView.frame = newFrame;
}

- (void)setObject:(id)obj {
  [modelObject autorelease]; modelObject = [obj retain];
	self.modelView.model = [obj isKindOfClass:[DTCStyleBasedTableItem class]] ?
    [(DTCStyleBasedTableItem*)obj model] : obj;
  TTStyle *style = [DTCStyleBasedTableItem getStyleOf:obj usingPrefix:nil];
  if (style) self.modelView.style = style;
  NSString *url = [DTCStyleBasedTableItem getURLOf:obj usingPrefix:nil];
  self.selectionStyle = url ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
}

- (NSObject*)object {
  return modelObject;
}

- (void)dealloc {
  [self.modelView removeFromSuperview];
  self.modelView = nil;
  [modelObject release];
  modelObject = nil;
  [super dealloc];
}

@end
