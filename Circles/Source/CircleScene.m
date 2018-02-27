
#import "CircleScene.h"

@interface CircleScene()

@property (strong, nonatomic) SKAction *fadeIn;
@property (strong, nonatomic) SKAction *fadeOut;
@property (strong, nonatomic) NSMutableArray<SKShapeNode *> *visibleNodes;
@property (strong, nonatomic) ScreenSaverDefaults *defaults;
@property (strong, nonatomic) NSColor *darkColor;
@property (strong, nonatomic) NSColor *lightColor;

@end

@implementation CircleScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.fadeIn = [SKAction fadeInWithDuration:4];
        self.fadeOut = [SKAction fadeOutWithDuration:2];
        self.visibleNodes = [NSMutableArray new];
        self.darkColor = [NSColor colorWithWhite:0.12 alpha:1];
        self.lightColor = [NSColor colorWithWhite:0.85 alpha:1];
        self.defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"Circles"];
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.backgroundColor = [self chosenBackgroundColor];
}

- (void)updateScene {
    self.backgroundColor = [self chosenBackgroundColor];
    
    NSColor *circleColor = [self chosenCircleColor];
    
    [self.visibleNodes enumerateObjectsUsingBlock:^(SKShapeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.fillColor = circleColor;
    }];
}

- (NSColor *)chosenBackgroundColor {
    if ([self.defaults boolForKey:@"lightCircles"]) {
        return self.darkColor;
    } else {
        return self.lightColor;
    }
}

- (NSColor *)chosenCircleColor {
    if ([self.defaults boolForKey:@"lightCircles"]) {
        return self.lightColor;
    } else {
        return self.darkColor;
    }
}

- (void)didMoveToView:(SKView *)view {
    [self spawnNode];
}

- (void)spawnNode {
    CGFloat radius = (CGFloat)arc4random_uniform(30) + 3;
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    UInt32 width = (UInt32)self.size.width - 50;
    UInt32 height = (UInt32)self.size.height - 50;
    CGFloat randomX = (CGFloat)arc4random_uniform(width) + 25;
    CGFloat randomY = (CGFloat)arc4random_uniform(height) + 25;
    CGPoint initialPosition = CGPointMake(randomX, randomY);
    circle.position = initialPosition;
    circle.fillColor = [self chosenCircleColor];
    circle.strokeColor = [NSColor clearColor];
    circle.alpha = 0;
    
    CGFloat finalMinX = initialPosition.x - 50;
    CGFloat finalMinY = initialPosition.y - 50;
    CGFloat finalX = (CGFloat)arc4random_uniform(100) + finalMinX;
    CGFloat finalY = (CGFloat)arc4random_uniform(100) + finalMinY;
    CGPoint finalPosition = CGPointMake(finalX, finalY);
    
    CGFloat initialX = (finalPosition.x - initialPosition.x) * 0.6;
    CGFloat initialY = (finalPosition.y - initialPosition.y) * 0.6;
    CGPoint startingPosition = CGPointMake(initialPosition.x + initialX, initialPosition.y + initialY);
    
    SKAction *initialMove = [SKAction moveTo:startingPosition duration:4];
    SKAction *group1 = [SKAction group:@[self.fadeIn, initialMove]];
    SKAction *finalMove = [SKAction moveTo:finalPosition duration:2];
    SKAction *group2 = [SKAction group:@[self.fadeOut, finalMove]];
    SKAction *sequence = [SKAction sequence:@[group1, group2]];
    
    [self addChild:circle];
    [self.visibleNodes addObject:circle];
    [circle runAction:sequence completion:^{
        [self.visibleNodes removeObject:circle];
        [circle removeFromParent];
    }];
    
    [self performSelector:@selector(spawnNode) withObject:nil afterDelay:0.3];
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

@end
