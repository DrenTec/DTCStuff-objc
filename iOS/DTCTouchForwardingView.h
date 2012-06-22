/** This simple transparent view forwards all touch events to another UIView */
@interface DTCTouchForwardingView : UIView {
	IBOutlet UIView *target;
}

@end
