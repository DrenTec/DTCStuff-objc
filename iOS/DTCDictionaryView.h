/** Display key value pairs in a column */
@interface DTCDictionaryView : UIView {
	UIFont *labelFont;
  UIFont *valueFont;
  UIColor *labelColor;
  UIColor *valueColor;
  NSDictionary *dictionary;
}

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic, retain) UIFont *labelFont;
@property (nonatomic, retain) UIFont *valueFont;
@property (nonatomic, retain) UIColor *labelColor;
@property (nonatomic, retain) UIColor *valueColor;

@end
