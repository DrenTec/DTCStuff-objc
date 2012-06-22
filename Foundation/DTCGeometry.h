typedef int DTCAlignment;

#define DTC_ALIGN_LEAVE 	0
#define DTC_ALIGN_NEAR 		1
#define DTC_ALIGN_CENTER 	2
#define DTC_ALIGN_FAR 		3
#define DTC_ALIGN_FILL 		4

#define DTC_ALIGN_LEFT 	 DTC_ALIGN_NEAR
#define DTC_ALIGN_RIGHT  DTC_ALIGN_FAR
#define DTC_ALIGN_TOP 	 DTC_ALIGN_NEAR
#define DTC_ALIGN_BOTTOM DTC_ALIGN_FAR

/**
 Returns the size to use to proportionally fit the child in the container
 @param container The parent container size
 @param child Size of the child item to place within container
 @returns the size to use to proportionally fit the child in the container
 */
CGSize dtc_sizeFitIn(CGSize container, CGSize child);

/**
 Returns the size to use to proportionally fill the child in the container
 @param container The parent container size
 @param child Size of the child item to place within container
 @returns the size to use to proportionally fill the child in the container
 */
CGSize dtc_sizeFill(CGSize container, CGSize child);

/**
 Returns the size that contains the original size rotated by angle
 @param size Original size before rotation
 @param angle Radian angle number
 */
CGSize dtc_rotatedSize(CGSize size, CGFloat angle);

/**
  Returns a rectangle placed within container
  @param container The parent container to use to align the child
  @param child Size of the child item to place within container
  @param horizontal Vertical alignment
  @param vertical Horizontal alignment
  @returns a rectangle in containers coordinate system
 */
CGRect dtc_rectIn(CGRect container, CGSize child,
                  DTCAlignment horizontally, DTCAlignment vertically);

/**
	Returns a rectangle outside of the container, at the specified edges.
  Spacing is added if the child and the container have size.
	@param container Rectangle next to which to place the item
	@param nextItem Size of the item to place next to the container
	@param spacing Optional spacing to add when both have size. (Not used for FILL alignment)
	@param horizontal Vertical edge to place
	@param vertical Horizontal edge to place
	@returns a rectangle in containers coordinate system
 */
CGRect dtc_rectNextTo(CGRect container, CGSize nextItem, CGFloat spacing,
		                         DTCAlignment horizontal, DTCAlignment vertical);
