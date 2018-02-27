
#import "ParticleView.h"
#import "CircleScene.h"

@interface ParticleView()

@property (strong, nonatomic) CircleScene *circleScene;

@end

@implementation ParticleView

- (void)addCircleScene {
    self.circleScene = [[CircleScene alloc] initWithSize:self.bounds.size];
    [self presentScene:self.circleScene];
}

- (void)updateScene {
    [self.circleScene updateScene];
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

@end
