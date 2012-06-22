@interface NSDate (DTC)
- (NSDate *)dtc_dateOfDayStartIn:(NSCalendar *)cal;
- (NSDate *)dtc_dateOfDayStart;
- (NSDate *)dtc_dateByAdding:(NSInteger)offset unit:(NSCalendarUnit)unit inCalendar:(NSCalendar *)cal;
- (NSDate *)dtc_dateByAdding:(NSInteger)offset unit:(NSCalendarUnit)unit;
@end
