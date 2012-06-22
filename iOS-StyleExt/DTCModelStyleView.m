#import "DTCModelStyleView.h"
#import "DTCFieldStyle.h"
#import "DTCMacros.h"
#import "TTStyleContext.h"
#import "TTURLRequestDelegate.h"
#import "TTURLRequest.h"
#import "TTURLCache.h"
#import "TTURLImageResponse.h"
#import "TTImageStyle.h"

@interface DTCModelStyleView (Private) <TTURLRequestDelegate>
- (void)setPendingImages:(NSMutableDictionary*)dico;
- (void)setObject:(id)object forUrl:(NSString*)url;
- (void)cancelPendingRequests;
@end

@implementation DTCModelStyleView (Private)

- (void)setPendingImages:(NSMutableDictionary*)dico {
  [pendingImages autorelease];
  pendingImages = [dico retain];
}

- (NSMutableDictionary *)pendingImages {
  if (!pendingImages) {
    pendingImages = [[NSMutableDictionary alloc] initWithCapacity:1];
  }
  return pendingImages;
}

- (void)setObject:(id)object forUrl:(NSString*)url {
  [[self pendingImages] setObject:object forKey:url];
}

- (void)cancelPendingRequests {
  if (!pendingImages || [pendingImages count] == 0) return;
  for (id request in [pendingImages objectEnumerator]) {
    if ([request isKindOfClass:[TTURLRequest class]]) {
      [request cancel];
    }
  }
  [pendingImages removeAllObjects];
}

@end


@implementation DTCModelStyleView

static DTCModelStyleView *DTCModelStyleView_staticMeasuringInstance = nil;

@synthesize model;

+ (CGSize)calculateSizeFor:(NSObject *)model withStyle:(TTStyle*)style thatFits:(CGSize)sizeToFit {
  if (!DTCModelStyleView_staticMeasuringInstance) {
    DTCAssert(self == [DTCModelStyleView class], @"You cannot use this class method on sublasses");
    DTCModelStyleView_staticMeasuringInstance = [[DTCModelStyleView alloc] initWithFrame:CGRectZero];
  }
  DTCModelStyleView_staticMeasuringInstance.model = model;
  DTCModelStyleView_staticMeasuringInstance.style = style;
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  context.frame = context.contentFrame = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
  context.delegate = DTCModelStyleView_staticMeasuringInstance;
  context.font = nil;
  CGSize resultSize = [style addToSize:CGSizeZero context:context];
  DTCModelStyleView_staticMeasuringInstance.model = nil;
  DTCModelStyleView_staticMeasuringInstance.style = nil;
  return resultSize;
}

- (void) dealloc
{
  [self cancelPendingRequests];
  self.model = nil;
  [self setPendingImages:nil];
  [super dealloc];
}

- (UIImage *)loadImage:(NSString*)urlPath {
  if (self == DTCModelStyleView_staticMeasuringInstance) {
    return nil;
  }
  id pending = [pendingImages objectForKey:urlPath];
  if ([pending isKindOfClass:[UIImage class]]) {
    return pending;
  } else if ([pending isKindOfClass:[TTURLRequest class]]) {
    return nil;
  }
  UIImage* image = [[TTURLCache sharedCache] imageForURL:urlPath];
  if (image) {
    [self setObject:image forUrl:urlPath];
    return image;
  } else {
    TTURLRequest* request = [TTURLRequest requestWithURL:urlPath delegate:self];
    request.response = [[[TTURLImageResponse alloc] init] autorelease];
    [self setObject:request forUrl:urlPath];
    if ([request send])
      return [pendingImages objectForKey:urlPath];
  }
  return nil;
}

- (void)setModel:(NSObject *)newModel {
  if (model == newModel) {
    return;
  }
  [self cancelPendingRequests];
  [model autorelease];
  model = [newModel retain];
  [self setNeedsDisplay];
}

- (NSString *)textForLayerWithStyle:(TTStyle *)style {
  DTCFieldStyle *part = [style firstStyleOfClass:[DTCFieldStyle class]];
  if (!part)
    return @"!No Field!";
  return [part textForModel:(id)model inView:self];
}

- (UIImage*)imageForLayerWithStyle:(TTStyle*)style {
  DTCFieldStyle *part = [style firstStyleOfClass:[DTCFieldStyle class]];
  NSString *imageName = [part textForModel:(id)model inView:self];
  if ([[imageName lowercaseString] hasPrefix:@"http"]) {
    UIImage *image = [self loadImage:imageName];
    if (image)
      return image;
    imageName = nil;
  }
  if (!imageName && [style isKindOfClass:[TTImageStyle class]])
    return ((TTImageStyle*)style).defaultImage;
  return [UIImage imageNamed:imageName];
}

#pragma mark -
#pragma mark TTURLRequestDelegate

- (void)requestDidFinishLoad:(TTURLRequest*)request {
  TTURLImageResponse* response = request.response;
  [self setObject:response.image forUrl:request.urlPath];
  [self setNeedsDisplay];
}

- (void)request:(TTURLRequest*)request didFailLoadWithError:(NSError*)error {
  [pendingImages removeObjectForKey:request.urlPath];
}

- (void)requestDidCancelLoad:(TTURLRequest*)request {
  [pendingImages removeObjectForKey:request.urlPath];
}

@end
