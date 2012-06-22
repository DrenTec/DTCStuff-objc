#ifndef DTC_MACROS_H__
# define DTC_MACROS_H__

# define DTC_DBG_CGRECT(r) [NSString stringWithFormat:@"%f;%f -> %fx%f", (r).origin.x, (r).origin.y, (r).size.width, (r).size.height]
# ifdef DEBUG
#  define DTCLog(dbg, ...) NSLog(@"In %s:\n\t%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:(dbg), ## __VA_ARGS__])
# else
#  define DTCLog(dbg, ...)
# endif

# define DTCAssert(cond, msg, ...) do { \
		if (!(cond)) { \
			NSAssert(NO, ([NSString stringWithFormat:@"Assertion failure in %s: " msg, __PRETTY_FUNCTION__, ## __VA_ARGS__])); \
		} } while (0)

# define DTC_YEARS_TO_DAYS(d)   (365.25 * (d))
# define DTC_YEARS_TO_MONTHS(d) (12. * (d))
# define DTC_YEARS_TO_WEEKS(d)  (52. * (d))
# define DTC_YEARS_TO_SECS(d)   (31556926. * (d))
# define DTC_MONTHS_TO_DAYS(d)  (DTC_YEARS_TO_DAYS(d) / DTC_YEARS_TO_MONTHS(1))
# define DTC_MONTHS_TO_WEEKS(d) (DTC_YEARS_TO_WEEKS(d) / DTC_YEARS_TO_MONTHS(1))
# define DTC_MONTHS_TO_SECS(d)  (DTC_YEARS_TO_SECS(d) / DTC_YEARS_TO_MONTHS(1))
# define DTC_WEEKS_TO_DAYS(d)   (7. * (d))
# define DTC_WEEKS_TO_SECS(d)   (DTC_DAYS_TO_SECS(DTC_WEEKS_TO_DAYS(d)))
# define DTC_DAYS_TO_SECS(d)    (24. * DTC_HOURS_TO_SECS(d))
# define DTC_HOURS_TO_SECS(d)   (60. * DTC_MINUTES_TO_SECS(d))
# define DTC_MINUTES_TO_SECS(d) (60. * (d))

#define DTC_IN_RANGE_INCLUSIVE(VAL,LOW,HIGH) \
  ((VAL) >= (LOW) && (VAL) <= (HIGH))
#define DTC_IN_RANGE_EXCLUSIVE(VAL,LOW,HIGH) \
  ((VAL) > (LOW) && (VAL) < (HIGH))
#define DTC_CLAMP(VAL,LOW,HIGH) \
  ((VAL) < (LOW) ? (LOW) : ((VAL) > (HIGH) ? (HIGH) : (VAL)))

#define DTC_SCALE(VAL,OLOW,OHIGH,NLOW,NHIGH) \
  ( \
    ( \
      ( \
        ((VAL) - (OLOW)) \
        * \
        ((NHIGH) - (NLOW)) \
      ) \
      / \
      ((OHIGH) -(OLOW)) \
    ) \
    + \
    (NLOW) \
  )

#define DTC_HIGHPASS(k,v1,v2) ((v1) * (k) + (v2) * (1.-(k)))

# define DTC_HEXCOL(r,g,b)   [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.]
# define DTC_HEXCOLOR(c)      DTC_HEXCOL(((c)>>16) & 0xff, ((c)>>8) & 0xff, (c) & 0xff)

# define DTC_NEWERROR(domain, msg, error_code)  \
    [NSError errorWithDomain:(domain) \
                        code:(error_code) \
                    userInfo:[NSDictionary dictionaryWithObject:(msg) \
                                                         forKey:@"error_msg"]]

#  define DTC_REPTIMER_FIELD_NAME(NAME) \
  _dtctimerFor ## NAME
#  define DTC_REPTIMER_PROPERTY_NAME(NAME) \
  is ## NAME ## Active
#  define DTC_REPTIMER_GETTER(NAME,FIELD_NAME) \
  - (BOOL)DTC_REPTIMER_PROPERTY_NAME(NAME) { \
    return !!(FIELD_NAME);  \
  }
  
#  define DTC_REPTIMER_SETTER(NAME,FIELD_NAME,TRIGGER_SELECTOR_NAME,PERIOD) \
  - (void)setIs ## NAME ## Active:(BOOL)new ## NAME ## IsActive { \
    if (!!(new ## NAME ## IsActive) == !!(FIELD_NAME)) return; \
    [self willChangeValueForKey:@"is" #NAME "Active"]; \
    if (FIELD_NAME) { \
      [(FIELD_NAME) invalidate]; \
      [(FIELD_NAME) release]; \
      (FIELD_NAME) = nil; \
    } \
    if (new ## NAME ## IsActive) { \
      (FIELD_NAME) = [[NSTimer scheduledTimerWithTimeInterval:PERIOD \
                                                       target:self \
                                                     selector:@selector(TRIGGER_SELECTOR_NAME:) \
                                                     userInfo:nil \
                                                      repeats:YES] retain]; \
    } \
    [self didChangeValueForKey:@"is" #NAME "Active"]; \
  }
#  define DTC_REPTIMER_TRIGGER_NAME(NAME) \
  timer ## NAME ## Triggered
#  define DTC_REPTIMER_TRIGGER_DECL(NAME) \
  - (void)DTC_REPTIMER_TRIGGER_NAME(NAME):(NSTimer *)theTimer
/** Declares the NSTimer field that is used by DTC_REPTIMER */
#  define DTC_REPTIMER_FIELD_DECL(NAME) \
  NSTimer *DTC_REPTIMER_FIELD_NAME(NAME)
/** Declares the property that will be defined by DTC_REPTIMER */
#  define DTC_REPTIMER_PROPERTY_DECL(NAME) \
  @property (assign) BOOL DTC_REPTIMER_PROPERTY_NAME(NAME)
/** Defines a timer with it's controlling property. Should be immediately followed
  by the trigger block */
#  define DTC_REPTIMER(NAME,PERIOD) \
  DTC_REPTIMER_GETTER(NAME,DTC_REPTIMER_FIELD_NAME(NAME)) \
  DTC_REPTIMER_SETTER(NAME,DTC_REPTIMER_FIELD_NAME(NAME),DTC_REPTIMER_TRIGGER_NAME(NAME),PERIOD) \
  DTC_REPTIMER_TRIGGER_DECL(NAME)
/** Make a one argument call of SELECTOR on TARGET, if it it responds to it */
#  define DTC_SAFE_MSG1(TARGET,SELECTOR,ARG1) \
	{ \
    if ((TARGET) && [(TARGET) respondsToSelector:(SELECTOR)]) \
      [(TARGET) performSelector:(SELECTOR) withObject:(ARG1)]; \
	}
/** Make a two argument call of SELECTOR on TARGET, if it it responds to it */
#  define DTC_SAFE_MSG2(TARGET,SELECTOR,ARG1,ARG2) \
	{ \
		if ((TARGET) && [(TARGET) respondsToSelector:(SELECTOR)]) \
			[(TARGET) performSelector:(SELECTOR) withObject:(ARG1) withObject:(ARG2)]; \
	}

/* KVO helper macros */
# define DTC_KVC_WATCH(TARGET,KEY)	\
	[(TARGET) addObserver:self forKeyPath:(@ # KEY) options:0 context:nil];
# define DTC_KVC_UNWATCH(TARGET,KEY)	\
	[(TARGET) removeObserver:self forKeyPath:(@ # KEY)];
# define DTC_KVC_WATCHERS() \
	- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
# define DTC_KVC_IF_KEY_IS(KEY, REACTION) \
	if ([@ # KEY isEqual:keyPath]) { REACTION; return; }
# define DTC_KVC_UNKNOWN_KEY_TO_SUPER() \
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context]

/** Gather var arg arguments into an NSMutableArray */
# define DTC_VARARGS_UNTIL_NIL_TO_ARRAY(arrayVarName, firstArgument, argumentType) \
  NSMutableArray *arrayVarName = nil; \
  if (firstArgument) { \
    arrayVarName = [NSMutableArray arrayWithCapacity:3]; \
    va_list arrayVarName ## _vaargs; \
    va_start(arrayVarName ## _vaargs, firstArgument); \
    argumentType arrayVarName ## _next_item = firstArgument; \
    while (arrayVarName ## _next_item) { \
      [arrayVarName addObject:arrayVarName ## _next_item]; \
      arrayVarName ## _next_item = va_arg(arrayVarName ## _vaargs, argumentType); \
    } \
    va_end(arrayVarName ## _vaargs); \
  }

#endif