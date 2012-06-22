#ifndef DTCSTUFFPLATFORM_H_
#define DTCSTUFFPLATFORM_H_

#include "TargetConditionals.h"

#if TARGET_OS_IPHONE
# define DTC_Platform_iOS 1
#elif TARGET_IPHONE_SIMULATOR
# define DTC_Platform_iOS 1
#elif TARGET_OS_MAC
# define DTC_Platform_OSX 1
#else
# error Unexpected target
#endif


#endif // DTCSTUFFPLATFORM_H_