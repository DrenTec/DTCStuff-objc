#import "NSDate+DTC.h"

@implementation NSDate (DTC)

- (NSDate *)dtc_dateOfDayStartIn:(NSCalendar *)cal {
  NSDateComponents *components = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
  [components setHour:0];
  return [cal dateFromComponents:components];
}
- (NSDate *)dtc_dateOfDayStart {
  return [self dtc_dateOfDayStartIn:[NSCalendar currentCalendar]];
}
- (NSDate *)dtc_dateByAdding:(NSInteger)offset unit:(NSCalendarUnit)unit inCalendar:(NSCalendar *)cal {
  NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
#define DTC_CAL_UNIT_CASE(unit) NS ## unit ## CalendarUnit: [components set ## unit : offset]; break;
  switch (unit) {
    case DTC_CAL_UNIT_CASE(Era);
    case DTC_CAL_UNIT_CASE(Year);
    case DTC_CAL_UNIT_CASE(Month);
    case DTC_CAL_UNIT_CASE(Day);
    case DTC_CAL_UNIT_CASE(Hour);
    case DTC_CAL_UNIT_CASE(Minute);
    case DTC_CAL_UNIT_CASE(Second);
    case DTC_CAL_UNIT_CASE(Week);
    case DTC_CAL_UNIT_CASE(Weekday);
    case DTC_CAL_UNIT_CASE(WeekdayOrdinal);
    default:
      break;
  }
#undef DTC_CAL_UNIT_CASE
  return [cal dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dtc_dateByAdding:(NSInteger)offset unit:(NSCalendarUnit)unit {
  return [self dtc_dateByAdding:offset unit:unit inCalendar:[NSCalendar currentCalendar]];
}

@end
