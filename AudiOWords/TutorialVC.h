//
//  TutorialVC.h
//  AudiOWords
//
//  Created by Ashley Soucar on 9/22/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenEars/FliteController.h>
#import <Slt/Slt.h>

@interface TutorialVC : UIViewController{
    FliteController *fliteController;
    Slt *slt;
}
@property (strong, nonatomic) IBOutlet UIButton *backButtonImage;
@property (strong, nonatomic) IBOutlet UIImageView *backButtonCenter;
@property (strong, nonatomic) IBOutlet UIButton *hintButtonImage;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

@property (strong, nonatomic) IBOutlet UIImageView *hintButtonCenter;

@property (strong, nonatomic) IBOutlet UIButton *alienImage;

- (IBAction)backButton;
- (IBAction)hintButton;
- (IBAction)alienButton;

@end
