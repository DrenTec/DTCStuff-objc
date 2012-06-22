
#import "DTCMacros.h"
#import "UIView+DTC.h"
#import "DTCAnimatedView.h"

@implementation DTCAnimatedViewLayer

- (id)init {
  self = [super init];
  if (self) {
    [self setNeedsDisplayOnBoundsChange:YES];
  }
  return self;
}

- (void)dealloc {
  self.active = NO;
  [super dealloc];
}

- (BOOL)active {
  return !!link;
}

- (void)setActive:(BOOL)active {
  if (active == !!link) return;
  if (active) {
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
  } else {
    [link invalidate];
    link = nil;
  }
}

- (void)didResize {
}

- (void)drawInContext:(CGContextRef)ctx {
  CGRect rect = CGContextGetClipBoundingBox(ctx);
  if (width != (NSInteger)rect.size.width || height != (NSInteger)rect.size.height) {
    width = (NSInteger)rect.size.width;
    height = (NSInteger)rect.size.height;
    [self didResize];
  }
}

@end

@implementation DTCAnimatedView

@synthesize animatedLayer;

+ (Class)animatedLayerClass {
  return [DTCAnimatedViewLayer class];
}

- (void)dealloc {
  DTC_KVC_UNWATCH(self, frame);
  self.animatedLayer = nil;
  [super dealloc];
}

- (void)startObservingFrame {
  DTC_KVC_WATCH(self, frame);
}

DTC_VIEW_INIT(startObservingFrame)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  DTC_KVC_IF_KEY_IS(frame, [self didChangeFrame]);
  DTC_KVC_UNKNOWN_KEY_TO_SUPER();
}


- (BOOL)active {
  return self.animatedLayer.active;
}

- (void)setActive:(BOOL)active {
  self.animatedLayer.active = active;
}

-(void)setAnimatedLayer:(DTCAnimatedViewLayer *)newLayer {
  animatedLayer.active = NO;
  [animatedLayer removeFromSuperlayer];
  animatedLayer = newLayer;
  if (animatedLayer) {
    animatedLayer.frame = self.bounds;
    [self.layer addSublayer:animatedLayer];
  }
}

- (void)didChangeFrame {
  self.animatedLayer.frame = self.bounds;
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  if (self.superview) {
    self.animatedLayer = [[[[[self class] animatedLayerClass] alloc] init] autorelease];
  }
  else {
    self.animatedLayer = nil;
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //self.animatedLayer.active = YES;
}

@end
