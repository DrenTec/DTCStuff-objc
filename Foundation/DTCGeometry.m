#import "DTCGeometry.h"

CGSize dtc_sizeFitIn(CGSize container, CGSize child) {
  CGFloat ratio = fminf(container.width / child.width, container.height / child.height);
  return CGSizeMake(child.width * ratio, child.height * ratio);
}

CGSize dtc_sizeFill(CGSize container, CGSize child) {
  CGFloat ratio = fmaxf(container.width / child.width, container.height / child.height);
  return CGSizeMake(child.width * ratio, child.height * ratio);
}

CGSize dtc_rotatedSize(CGSize size, CGFloat angle) {
  CGSize result;
  result.height = size.width * sin(angle) + size.height * cos(angle);
  result.width = size.width * cos(angle) + size.height * sin(angle);
  return result;
}

CGRect dtc_rectIn(CGRect container, CGSize child,
                  DTCAlignment horizontal, DTCAlignment vertical) {
  CGRect result = container;
  result.size = child;
	switch (horizontal) {
    case DTC_ALIGN_CENTER:
      result.origin.x += (container.size.width - child.width) / 2.;
      break;
    case DTC_ALIGN_FAR:
      result.origin.x = (container.origin.x + container.size.width - child.width);
      break;
    case DTC_ALIGN_FILL:
      result.size.width = container.size.width;
      break;
  }
	switch (vertical) {
    case DTC_ALIGN_CENTER:
      result.origin.y += (container.size.height - child.height) / 2.;
      break;
    case DTC_ALIGN_FAR:
      result.origin.y = (container.origin.y + container.size.height - child.height);
      break;
    case DTC_ALIGN_FILL:
      result.size.height = container.size.height;
      break;
  }
  return result;
}

CGRect dtc_rectNextTo(CGRect container, CGSize nextItem, CGFloat spacing,
		                         DTCAlignment horizontal, DTCAlignment vertical) {
  CGRect result = container;
  result.size = nextItem;
  spacing =
  	(nextItem.width > 0 || horizontal == DTC_ALIGN_FILL) &&
  	(nextItem.height > 0 || vertical == DTC_ALIGN_FILL) &&
  	(container.size.width > 0) &&
  	(container.size.height > 0) ? spacing : 0 ;
	switch (horizontal) {
    case DTC_ALIGN_NEAR:
      result.origin.x = container.origin.x - nextItem.width - spacing;
    case DTC_ALIGN_CENTER:
      result.origin.x += (container.size.width - nextItem.width) / 2.;
      break;
    case DTC_ALIGN_FAR:
      result.origin.x += container.size.width + spacing;
      break;
    case DTC_ALIGN_FILL:
      result.size.width = container.size.width;
      break;
  }
	switch (vertical) {
    case DTC_ALIGN_NEAR:
      result.origin.y = container.origin.y - nextItem.height - spacing;
    case DTC_ALIGN_CENTER:
      result.origin.y += (container.size.height - nextItem.height) / 2.;
      break;
    case DTC_ALIGN_FAR:
      result.origin.y += container.size.height + spacing;
      break;
    case DTC_ALIGN_FILL:
      result.size.height = container.size.height;
      break;
  }
  return result;
}