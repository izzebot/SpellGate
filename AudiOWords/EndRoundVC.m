//
//  EndRoundVC.m
//  AudiOWords
//
//  Created by Ashley Soucar on 10/21/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import "EndRoundVC.h"
#import "MainGameVC.h"

@interface EndRoundVC ()

@end

@implementation EndRoundVC

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
    
    //get score
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"levelsAndScores"];
    NSMutableDictionary *levelScores = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSNumber *level = [prefs objectForKey:@"level"];
    
    int score = [[levelScores objectForKey:level] intValue];
    NSLog([NSString stringWithFormat:@"Level: %d Score: %d", [level intValue], score]);
    
    //determine if score is high enough to continue
    if (score < 85) {
        [self.nextLevel setHidden:YES];
    }
    
    else if ([level intValue] == 15){
        [self.nextLevel setHidden:YES];
        [self.winLabel setHidden:NO];
    }
    else{
        [self.winLabel setHidden:YES];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNextLevel:nil];
    [self setRedoLevel:nil];
    [self setWinLabel:nil];
    [super viewDidUnload];
}
- (IBAction)goToRedoLevel {
    
    MainGameVC *gameVC = [[MainGameVC alloc] init];
    
    [self.view.window setRootViewController:gameVC];
}

- (IBAction)goToNextLevel {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger level = [prefs integerForKey:@"level"];
    level++;
    [prefs setInteger:level forKey:@"level"];
    
     MainGameVC *gameVC = [[MainGameVC alloc] init];
    [self.view.window setRootViewController:gameVC];
}
@end
