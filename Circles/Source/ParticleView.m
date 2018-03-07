
#import "ParticleView.h"
#import "CircleScene.h"

@interface ParticleView()

@property (strong, nonatomic) CircleScene *circleScene;

@end

@implementation ParticleView

#pragma mark Instance Overrides

- (BOOL)acceptsFirstResponder {
    return NO;
}

#pragma mark Public Methods

- (void)addCircleScene {
    self.circleScene = [[CircleScene alloc] initWithSize:self.bounds.size];
    [self presentScene:self.circleScene];
}

- (void)updateScene {
    [self.circleScene updateScene];
}

@end
