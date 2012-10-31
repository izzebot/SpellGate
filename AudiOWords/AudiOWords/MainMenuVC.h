//
//  MainMenuVC.h
//  AudiOWords
//
//  Created by Ashley Soucar on 9/21/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MainMenuVC : UIViewController{
    AVAudioPlayer *bgSound;
}
@property (strong, nonatomic) AVAudioPlayer *bgSound;

- (IBAction)startGameButton;
- (IBAction)aboutButton;
- (IBAction)levelsButton;
- (IBAction)settingsButton;
- (IBAction)tutorialButtons;
- (IBAction)resumeButton;

@end
