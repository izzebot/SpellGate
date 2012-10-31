//
//  MainMenuVC.m
//  AudiOWords
//
//  Created by Ashley Soucar on 9/21/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import "MainMenuVC.h"
#import "MainGameVC.h"
#import "AboutVC.h"
#import "LevelsVC.h"
#import "SettingsVC.h"
#import "TutorialVC.h"


@interface MainMenuVC ()


@end

@implementation MainMenuVC
@synthesize bgSound;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //starting the block for the looping bg sound
    NSString *bgsoundFilePath = [[NSBundle mainBundle] pathForResource:@"BackGround" ofType:@"aiff"];
    NSURL *bgsoundFileURL = [NSURL fileURLWithPath:bgsoundFilePath];
    bgSound = [[AVAudioPlayer alloc] initWithContentsOfURL:bgsoundFileURL error:nil];
    bgSound.numberOfLoops = -1; //infinite
    [bgSound setVolume: 1.0];
    [bgSound play];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)startGameButton
{
    MainGameVC *gameVC = [[MainGameVC alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"level"];
    
    [self.view.window setRootViewController:gameVC];
}

- (IBAction)aboutButton
{
    AboutVC *aboutVC = [[AboutVC alloc] init];
    [self.view.window setRootViewController:aboutVC];
}

- (IBAction)levelsButton
{
    LevelsVC *levelVC = [[LevelsVC alloc] init];
    [self.view.window setRootViewController:levelVC];
}

- (IBAction)settingsButton
{
    SettingsVC *settingVC = [[SettingsVC alloc] init];
    [self.view.window setRootViewController:settingVC];
}

-(IBAction)resumeButton{
    //this is where we will put the set level = to last seen level
}

- (IBAction)tutorialButtons
{
    TutorialVC *tutorialVC = [[TutorialVC alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:0 forKey:@"level"];
    
    [self.view.window setRootViewController:tutorialVC];
}
@end
