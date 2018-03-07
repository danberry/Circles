
#import "CirclesView.h"
#import "ParticleView.h"

@interface CirclesView()

#pragma mark IBOutlets

@property (strong, nonatomic) IBOutlet NSPanel *configSheet;
@property (strong, nonatomic) IBOutlet NSPopUpButton *appearanceButton;

#pragma mark Private Properties

@property (strong, nonatomic) ParticleView *particleView;
@property (strong, nonatomic) ScreenSaverDefaults *defaults;

@end

@implementation CirclesView

#pragma mark Initialization

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        if (self.particleView == nil) {
            self.defaults = [ScreenSaverDefaults defaultsForModuleWithName:defaultsIdentifier];
            [self.defaults registerDefaults:@{defaultsLightColorsKey: @YES}];
            self.particleView = [[ParticleView alloc] initWithFrame:self.bounds];
            [self.particleView addCircleScene];
            [self addSubview:self.particleView];
        }
    }
    return self;
}

#pragma mark Class Methods

+ (BOOL)performGammaFade {
    return NO;
}

#pragma mark Instance Overrides

- (NSWindow *)configureSheet {
    if (self.configSheet == nil) {
        BOOL loaded = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"Config" owner:self topLevelObjects:nil];
        if (!loaded) {
            NSBeep();
        } else {
            if ([self.defaults boolForKey:defaultsLightColorsKey]) {
                [self.appearanceButton selectItemAtIndex:0];
            } else {
                [self.appearanceButton selectItemAtIndex:1];
            }
        }
    }
    
    return self.configSheet;
}

- (BOOL)hasConfigureSheet {
    return YES;
}

#pragma mark IBActions

- (IBAction)appearanceChanged:(NSPopUpButton *)sender {
    BOOL lightCirclesSelected = [sender indexOfSelectedItem] == 0;
    
    [self.defaults setBool:lightCirclesSelected forKey:defaultsLightColorsKey];
    [self.defaults synchronize];
    [self.particleView updateScene];
}

- (IBAction)cancelClick:(id)sender {
    [[NSApplication sharedApplication] endSheet:self.configSheet];
}

- (IBAction)okClicked:(id)sender {
    [[NSApplication sharedApplication] endSheet:self.configSheet];
}

@end
