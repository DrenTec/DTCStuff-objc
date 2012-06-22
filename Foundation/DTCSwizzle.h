#import <objc/runtime.h>
#ifndef DTC_SWIZZLE_H_
# define DTC_SWIZZLE_H_

/** ObjC Runtime dispatch replacement
 @author http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
 @param c Class to alter
 @param origSEL Original selector (whose implementation will be replaced)
 @param overrideSEL Selector for the override. (Used to locate new implementation,
 	 and after the swizzle, to call the original implementation if required).
 */
void DTC_MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL);
#endif