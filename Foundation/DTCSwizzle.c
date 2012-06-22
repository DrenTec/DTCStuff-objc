#include "DTCSwizzle.h"

void DTC_MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL)
{
  Method origMethod = class_getInstanceMethod(c, origSEL);
  Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
  if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)))
  {
    class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
  }
  else
  {
    method_exchangeImplementations(origMethod, overrideMethod);
  }
}