@interface NSDictionary (DTC)
- (NSString*)dtc_queryStringWithEncoding:(CFStringEncoding)encoding;
- (NSMutableDictionary *)dtc_dictionaryByMergingIn:(NSDictionary *)overridingDictionary
                                     onConflictUse:(id (^)(id key, id old_value, id new_value))conflict_solver;
- (NSMutableDictionary *)dtc_dictionaryByMergingIn:(NSDictionary *)overridingDictionary;
@end
