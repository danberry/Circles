
#import "CirclesView.h"
#import "ParticleView.h"

@interface CirclesView()

@property (strong, nonatomic) ParticleView *particleView;
@property (strong, nonatomic) IBOutlet NSPanel *configSheet;
@property (strong, nonatomic) IBOutlet NSPopUpButton *appearanceButton;
@property (strong, nonatomic) ScreenSaverDefaults *defaults;

@end

@implementation CirclesView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        if (self.particleView == nil) {
            self.defaults = [ScreenSaverDefaults defaultsForModuleWithName:@"Circles"];
            [self.defaults registerDefaults:@{@"lightCircles": @YES}];
            self.particleView = [[ParticleView alloc] initWithFrame:self.bounds];
            [self.particleView addCircleScene];
            [self addSubview:self.particleView];
        }
    }
    return self;
}

- (BOOL)hasConfigureSheet {
    return YES;
}

- (NSWindow *)configureSheet {
    if (self.configSheet == nil) {
        BOOL loaded = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"Config" owner:self topLevelObjects:nil];
        if (!loaded) {
            NSBeep();
        } else {
            if ([self.defaults boolForKey:@"lightCircles"]) {
                [self.appearanceButton selectItemAtIndex:0];
            } else {
                [self.appearanceButton selectItemAtIndex:1];
            }
        }
    }
    
    return self.configSheet;
}

- (IBAction)cancelClick:(id)sender {
    [[NSApplication sharedApplication] endSheet:self.configSheet];
}

- (IBAction)okClicked:(id)sender {
    [[NSApplication sharedApplication] endSheet:self.configSheet];
}

- (IBAction)appearanceChanged:(NSPopUpButton *)sender {
    BOOL lightCirclesSelected = [sender indexOfSelectedItem] == 0;
    
    [self.defaults setBool:lightCirclesSelected forKey:@"lightCircles"];
    [self.defaults synchronize];
    [self.particleView updateScene];
}

+ (BOOL)performGammaFade {
    return NO;
}

@end
