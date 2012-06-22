#import "TTTableItem.h"
#import "TTTableViewCell.h"
#import "TTStyle.h"

@class DTCModelStyleView;

/** TTTableItem sub class that displays a model using a style provided by itself */
@interface DTCStyleBasedTableItem : TTTableItem {
  NSString *stylePrefix;
  NSObject *model;
}

@property (nonatomic, copy) NSString *stylePrefix;
@property (nonatomic, retain) NSObject *model;

+ (DTCStyleBasedTableItem *)itemWithStyle:(NSString*)aStylePrefix
                                forObject:(id)anObject;

- (TTStyle *)style;
- (CGFloat)rowHeight;
- (NSString *)URLValue;
+ (NSString *)getURLOf:(NSObject *)object
           usingPrefix:(NSString *)aStylePrefix;
+ (TTStyle *)getStyleOf:(NSObject *)object
            usingPrefix:(NSString *)aStylePrefix;
+ (CGFloat)getHeightOf:(NSObject *)object
           usingPrefix:(NSString *)aStylePrefix;
@end

/** Table cell to render a model object using its own style */
@interface DTCStyleBasedTableViewCell : TTTableViewCell {
	DTCModelStyleView *modelView;
  NSObject *modelObject;
}

@property (retain, nonatomic) DTCModelStyleView *modelView;

@end
