//
//  MainGameVC.h
//  AudiOWords
//
//  Created by Ashley Soucar on 9/21/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenEars/FliteController.h>
#import <Slt/Slt.h>

@interface MainGameVC : UIViewController{
    AVAudioPlayer *bgSound;
    FliteController *fliteController;
    Slt *slt;
}
@property (strong, nonatomic) AVAudioPlayer *bgSound;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@property (strong, nonatomic) IBOutlet UIButton *backToHome;
@property (strong, nonatomic) IBOutlet UIButton *giveHintButton;
@property (strong, nonatomic) IBOutlet UILabel *wordPicLabel;

- (IBAction)backButton;
- (IBAction)hintButton;

@end
