
#import "CircleScene.h"
#import "CirclesView.h"

@interface CircleScene()

@property (strong, nonatomic) SKAction *fadeIn;
@property (strong, nonatomic) SKAction *fadeOut;
@property (strong, nonatomic) NSMutableArray<SKShapeNode *> *visibleNodes;
@property (strong, nonatomic) ScreenSaverDefaults *defaults;
@property (strong, nonatomic) NSColor *darkColor;
@property (strong, nonatomic) NSColor *lightColor;

@end

@implementation CircleScene

#pragma mark Initialization

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.fadeIn = [SKAction fadeInWithDuration:fadeInDuration];
        self.fadeOut = [SKAction fadeOutWithDuration:fadeOutDuration];
        self.visibleNodes = [NSMutableArray new];
        self.darkColor = [NSColor colorWithWhite:0.12 alpha:1];
        self.lightColor = [NSColor colorWithWhite:0.85 alpha:1];
        self.defaults = [ScreenSaverDefaults defaultsForModuleWithName:defaultsIdentifier];
        
        [self commonInit];
    }
    
    return self;
}

#pragma mark Instance Overrides

- (BOOL)acceptsFirstResponder {
    return NO;
}

- (void)didMoveToView:(SKView *)view {
    [self spawnNode];
}

#pragma mark Internal Methods

- (NSColor *)chosenBackgroundColor {
    if ([self.defaults boolForKey:defaultsLightColorsKey]) {
        return self.darkColor;
    } else {
        return self.lightColor;
    }
}

- (NSColor *)chosenCircleColor {
    if ([self.defaults boolForKey:defaultsLightColorsKey]) {
        return self.lightColor;
    } else {
        return self.darkColor;
    }
}

- (void)commonInit {
    self.backgroundColor = [self chosenBackgroundColor];
}

- (void)spawnNode {
    CGFloat radius = (CGFloat)arc4random_uniform(30) + 3;
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    UInt32 width = (UInt32)(self.size.width - circleSizeModifier);
    UInt32 height = (UInt32)(self.size.height - circleSizeModifier);
    CGFloat randomX = (CGFloat)arc4random_uniform(width) + (circleSizeModifier / 2);
    CGFloat randomY = (CGFloat)arc4random_uniform(height) + (circleSizeModifier / 2);
    CGPoint initialPosition = CGPointMake(randomX, randomY);
    circle.position = initialPosition;
    circle.fillColor = [self chosenCircleColor];
    circle.strokeColor = [NSColor clearColor];
    circle.alpha = 0;
    
    CGFloat finalMinX = initialPosition.x - circleSizeModifier;
    CGFloat finalMinY = initialPosition.y - circleSizeModifier;
    UInt32 positionRandomLocation = (UInt32)(circleSizeModifier * 2);
    CGFloat finalX = (CGFloat)arc4random_uniform(positionRandomLocation) + finalMinX;
    CGFloat finalY = (CGFloat)arc4random_uniform(positionRandomLocation) + finalMinY;
    CGPoint finalPosition = CGPointMake(finalX, finalY);
    
    CGFloat initialX = (finalPosition.x - initialPosition.x) * positionRandomMultiplier;
    CGFloat initialY = (finalPosition.y - initialPosition.y) * positionRandomMultiplier;
    CGPoint startingPosition = CGPointMake(initialPosition.x + initialX, initialPosition.y + initialY);
    
    SKAction *initialMove = [SKAction moveTo:startingPosition duration:fadeInDuration];
    SKAction *group1 = [SKAction group:@[self.fadeIn, initialMove]];
    SKAction *finalMove = [SKAction moveTo:finalPosition duration:fadeOutDuration];
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

- (void)updateScene {
    self.backgroundColor = [self chosenBackgroundColor];
    
    NSColor *circleColor = [self chosenCircleColor];
    
    [self.visibleNodes enumerateObjectsUsingBlock:^(SKShapeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.fillColor = circleColor;
    }];
}

@end
