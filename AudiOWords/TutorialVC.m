//
//  TutorialVC.m
//  AudiOWords
//
//  Created by Ashley Soucar on 9/22/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import "TutorialVC.h"
#import "MainMenuVC.h"
#import "GameWord.h"
#import "EndRoundVC.h"
#import "MainGameVC.h"
#import <AVFoundation/AVFoundation.h>

@interface TutorialVC ()

@property (nonatomic) int count;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer1;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer2;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer3;
@property (nonatomic, retain) AVAudioPlayer *soundPlayer4;

@property (nonatomic, retain) NSMutableArray *textToRead;

@property (nonatomic, retain) NSMutableArray *levelWords;
@property (nonatomic, retain) UIImageView *target;
@property (nonatomic, retain) NSString *nextLetter;
@property (nonatomic) BOOL isWordSpelled;
@property (nonatomic, retain) NSMutableArray *thisWordsSpelling;
@property (nonatomic, retain) GameWord *currentWord;
@property (nonatomic) int currentIndex;
@property (nonatomic, retain) NSMutableArray *letterButtons;

@property (nonatomic) int letterIndex;
@property (nonatomic) BOOL wrongLetterBool;
@property (nonatomic) double score;
@property (nonatomic) NSNumber *currLevel;



@property (nonatomic, retain) AVAudioPlayer *cheerPlay;

//array for read from file
@property (nonatomic, retain) NSMutableArray *round_words;
@property (nonatomic, retain) NSMutableArray *round;


@end

@implementation TutorialVC

@synthesize backButtonImage, backButtonCenter, hintButtonImage, hintButtonCenter, alienImage;

@synthesize fliteController;
@synthesize slt;


- (FliteController *)fliteController {
    if (fliteController == nil){
        fliteController = [[FliteController alloc] init];
        fliteController.duration_stretch = 1.2;
    }
    return fliteController;
}

- (Slt *)slt {
    if (slt == nil){
        slt = [[Slt alloc] init];
    }
    return slt;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.count = 0;
    NSMutableString *testString = [NSMutableString stringWithString:@"test"];

    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.currLevel = [prefs objectForKey:@"level"];
    
    self.levelWords = [NSMutableArray array];
    self.currentIndex = 0;
    self.letterIndex = 0;
    self.score = 100;
    self.letterButtons = [NSMutableArray array];
    self.thisWordsSpelling = [NSMutableArray array];
    
    
    AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"happycheering" ofType:@"aiff"]] error:nil];
    self.cheerPlay = pp1;
    [pp1 prepareToPlay];
    
    AVAudioPlayer *welcome = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Welcome and Home button" ofType:@"aiff"]] error:nil];
    
    self.soundPlayer1 = welcome;
    [welcome prepareToPlay];
    
    AVAudioPlayer *hint = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Hint button" ofType:@"aiff"]] error:nil];
    
    self.soundPlayer2 = hint;
    [hint prepareToPlay];
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        AVAudioPlayer *firstLetter = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Voiceover First Letter" ofType:@"aiff"]] error:nil];
        
        self.soundPlayer3 = firstLetter;
        [firstLetter prepareToPlay];
        
    } else {
        AVAudioPlayer *firstLetter = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Visual First letter" ofType:@"aiff"]] error:nil];
        
        self.soundPlayer3 = firstLetter;
        [firstLetter prepareToPlay];
    }
    
    
    AVAudioPlayer *ending = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Tutorial Ending" ofType:@"aiff"]] error:nil];
    
    self.soundPlayer4 = ending;
    [ending prepareToPlay];
    
    
    
   
    
    [self getRoundTasksForLevel: 1];
    
    for (NSString *word in self.round_words) {
        GameWord *firstWord = [GameWord gameWordWithWord:word];
        [self.levelWords addObject:firstWord];
    }
    
    self.currentWord = [_levelWords objectAtIndex:self.currentIndex];
    [self backButtonExercise];
    
    
}

- (void)viewDidUnload
{
    [self setBackButtonImage:nil];
    [self setBackButtonCenter:nil];
    [self setHintButtonCenter:nil];
    [self setHintButtonImage:nil];
    [self setAlienImage:nil];
    [self setFliteController:nil];
    [self setSlt:nil];
    [super viewDidUnload];
    
}
- (void) backButtonExercise {
    [self playText: [NSMutableString stringWithString: @"Welcome and Home button" ]];
    
    [self.soundPlayer1 play];
    
    [self performSelector:@selector(changeBackButtonCenter) withObject:nil afterDelay:4];
    
    [self playText:[NSMutableString stringWithString: @"nothing" ]];
    
    [self performSelector:@selector(changeBackButtonImage) withObject:nil afterDelay:4.5];
    
}

-(void) hintButtonExercise: (NSMutableString *)testString {
    
    [self performSelector:@selector(changeBackButtonCenter)];
    
    [self.soundPlayer2 play];
    
    [self playText: [NSMutableString stringWithString: @"Hint button" ]];
    
    [self performSelector:@selector(changeHintButtonCenter) withObject:nil afterDelay:1];
    
    [self playText:[NSMutableString stringWithString: @"nothing" ]];
    
    [self performSelector:@selector(changeHintButtonImage) withObject:nil afterDelay:2.3];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)backButton
{
    NSLog([NSMutableString stringWithFormat:@"Back Count: %d",_count]);
    if (_count>2) {
        MainMenuVC *menuVC = [[MainMenuVC alloc] init];
        [self.view.window setRootViewController:menuVC];
    }
    else{
        [self.soundPlayer1 stop];
        NSMutableString *testString = [NSMutableString stringWithString:@"test"];
        [self playText:[NSMutableString stringWithString:@"You found the home button!"] ];
        [self hintButtonExercise:testString];
        
    }
    
}

- (IBAction)hintButton {
    
    if (_count == 5) {
        [self changeHintButtonCenter];
        [self.soundPlayer2 stop];
        NSMutableString *testString = [NSMutableString stringWithString:@"test"];
        [self playText:[NSMutableString stringWithString:@"You found the hint button!"] ];
        [self.soundPlayer3 play];
        sleep(1);
        [self setupLevelWithWord:self.currentWord];
    }
    
    //Creates the C O W spells Cow object as hint1:
    NSString *hint1= @"";
    for (int i = 0; i<([self.currentWord.letters count]); i++){
        
        hint1 = [hint1 stringByAppendingString:[self.currentWord.letters objectAtIndex:i]];
        hint1 = [hint1 stringByAppendingString:@" "];
    }
    hint1 = [hint1 stringByAppendingString:@"spells "];
    hint1 = [hint1 stringByAppendingString:self.currentWord.theWord];
    
    //Says the W O R D spells word with voice slt
    [self.fliteController say: hint1 withVoice:self.slt];
}

- (IBAction)alienButton {
    
 /*  MainGameVC *gameVC = [[MainGameVC alloc] init];
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"level"];
   
  [self.view.window setRootViewController:gameVC];
  */
}

-(void) changeBackButtonImage {
    if (backButtonImage.hidden){
        backButtonImage.hidden = NO;
    } else {
        backButtonImage.hidden = YES;
    }
}

-(void) changeHintButtonImage {
    if (hintButtonImage.hidden){
        hintButtonImage.hidden = NO;
    } else {
        hintButtonImage.hidden = YES;
    }
}

-(void) changeBackButtonCenter {
    if (backButtonCenter.hidden){
        backButtonCenter.hidden = NO;
    } else {
        backButtonCenter.hidden = YES;
    }
}

-(void) changeHintButtonCenter {
    if (hintButtonCenter.hidden){
        hintButtonCenter.hidden = NO;
    } else {
        hintButtonCenter.hidden = YES;
    }
}

-(void) changeAlienImage {
    if (alienImage.hidden) {
        alienImage.hidden = NO;
    } else {
        alienImage.hidden = YES;
    }
    
}

- (void) playText:(NSMutableString *) text {
    _count= _count +1;
    NSLog([NSMutableString stringWithFormat:@"Count: %d", _count]);
    NSLog([NSMutableString stringWithFormat:@"Text: %@", text]);
    
}



-(void)setupLevelWithWord:(GameWord *)word
{
    self.isWordSpelled = NO;
    self.wrongLetterBool = NO;
    [self.soundPlayer3 stop];
    
    //add pic
    self.target = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width)/2.6,
                                                                (self.view.bounds.size.height)/4,
                                                                250, 250)];
    self.target.image = word.wordImage;
    [self.view addSubview:self.target];
    
    //pull letters from gameword
    //create draggable buttons
    //use for loop through letter
    
    int tempCount = 1;
    NSString *wordWithExtra = [self.round objectAtIndex:self.currentIndex];
    NSMutableArray *tempWord = [[NSMutableArray alloc] initWithCapacity:[wordWithExtra length]];
    
    //Creates the C O W spells Cow object as hint1:
    NSString *hint1= @"";
    for (int i = 0; i<([self.currentWord.letters count]); i++){
        
        hint1 = [hint1 stringByAppendingString:@"     "];
        hint1 = [hint1 stringByAppendingString:[self.currentWord.letters objectAtIndex:i]];
        hint1 = [hint1 stringByAppendingString:@"     "];
    }
    hint1 = [hint1 stringByAppendingString:@"spells   "];
    hint1 = [hint1 stringByAppendingString:self.currentWord.theWord];
    hint1 = [hint1 stringByAppendingString:@"   "];
    
    if(self.currentIndex == 0){
        if(UIAccessibilityIsVoiceOverRunning()){
            hint1 = [hint1 stringByAppendingString:@"   double   tap   each   letter"];}
        else{
            hint1 = [hint1 stringByAppendingString:@"   drag   each   letter   to   the   center"];
        }
    
    }
    
    //Says the W O R D spells word with voice slt
    [self.fliteController say: hint1 withVoice:self.slt];
    
    for (int i=0; i < [wordWithExtra length]; i++) {
        NSString *iletter  = [NSString stringWithFormat:@"%c", [wordWithExtra characterAtIndex:i]];
        [tempWord addObject:iletter];
    }
    
    
    for (NSString *lett in tempWord) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:lett forState:UIControlStateNormal];
        
        // add drag listener
        [button addTarget:self action:@selector(wasDragged:withEvent:)
         forControlEvents:UIControlEventTouchDragInside];
        
        [button addTarget:self action:@selector(touchesEnded:withEvent:)
         forControlEvents:UIControlEventTouchUpInside];
        
        
        // center and size
        button.frame = CGRectMake((self.view.bounds.size.width - 100)/(tempWord.count+1)*tempCount,
                                  (self.view.bounds.size.height - 50)/5*4,
                                  100, 100);
        button.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:50];
        [button setBackgroundImage:[UIImage imageNamed:@"blackbutton.png"] forState:UIControlStateNormal];
        [button.titleLabel setTextColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];

        
        // add it
        [self.view addSubview:button];
        
        [self.letterButtons addObject:button];
        tempCount++;
        
    }
    
    self.nextLetter = [self.currentWord.letters objectAtIndex:self.letterIndex];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
    
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;
    
	// move button
	button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIButton *button in self.letterButtons) {
        if (button.center.x > 350 &&
            button.center.x < 650 &&
            button.center.y > 250 &&
            button.center.y < 500) {
            [button removeFromSuperview];
            button.center = CGPointMake(0, 0);
            [self isCorrectLetter:button.titleLabel.text];
        }
    }
    
    if (self.wrongLetterBool) {
        [self wrongLetter];
    }
    
    if (self.isWordSpelled) {
        //play win sound
        [self playWinSound];
        [self resetScreen];
        
        //if finished round
        if (self.levelWords.count == self.currentIndex+1) {
            
            NSMutableString *testString = [NSMutableString stringWithString:@"test"];
            [self playText:testString];
            [self resetScreen];
            [self changeAlienImage];
            [self playText:testString];
            [self.soundPlayer4 play];
            alienImage.enabled = YES;
            
            
        }
        else{
            self.currentIndex++;
            self.currentWord = [self.levelWords objectAtIndex:self.currentIndex];
            [self setupLevelWithWord:self.currentWord];
        }
    }
}
-(void)isCorrectLetter:(NSString *)letter
{
    if ([letter isEqualToString:self.nextLetter]) {
        [self.thisWordsSpelling addObject:letter];
        [self.currentWord playHappySound];
        
        if (self.thisWordsSpelling.count == self.currentWord.letters.count) {
            self.isWordSpelled = YES;
        }
        else{
            self.letterIndex++;
            self.nextLetter = [self.currentWord.letters objectAtIndex:self.letterIndex];
        }
    }
    else{
        [self.currentWord playSadSound];
        self.wrongLetterBool = YES;
    }
    
}

-(void)wrongLetter
{
    self.isWordSpelled = NO;
    [self resetScreen];
    [self setupLevelWithWord:self.currentWord];
}

-(void)resetScreen{
    [self.target removeFromSuperview];
    for (UIButton *button in self.letterButtons) {
        [button removeFromSuperview];
    }
    [self.letterButtons removeAllObjects];
    [self.thisWordsSpelling removeAllObjects];
    self.letterIndex = 0;
    
}

-(void)playWinSound
{
    [self.cheerPlay play];
    //    NSString *happysoundPath = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"happycheering"] ofType:@"aiff"];
    //    NSURL *happysoundURL =[NSURL fileURLWithPath:happysoundPath];
    //    SystemSoundID happysoundFileID;
    //    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)happysoundURL, &happysoundFileID);
    //    AudioServicesPlaySystemSound (happysoundFileID);
}
- (void)getRoundTasksForLevel:(int)levNum
{
    NSMutableArray *words_appro_for_level = [[NSMutableArray alloc] init];
    self.round = [[NSMutableArray alloc] init];
    self.round_words = [[NSMutableArray alloc] init];
    
    //creates a temp variable 'level' that in the actual program will be replaced
    int level = levNum;
    int level_ceilling;
    //creation of the filePath to the word_level list: word_level_list.txt
    NSString *filePath =[[NSBundle mainBundle] pathForResource:@"word_level_list"
                                                        ofType:@"txt"];
    //opens the file word_level_list.txt into a string called fileContents
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    //splits fileContents into an array with each entry looking like 'word #'
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    //limits list to level one words
    
    level_ceilling = level;
    
    //create an array of words from the file that occur at the appropriate level
    for (int i=0; i<([lines count]-1); i++){
        //word line contains the word # pair at each index
        NSString *word_line = [lines objectAtIndex:i];
        
        //word is an array for each line with word at index[0] and level at index[1]
        NSArray *word = [word_line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        word = [word filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF !=''"]];
        
        //Checks if the word belongs in the level, i.e. it must have a level value equal to the current level, eventually we will place additional logic here
        if (level != 0 && [[word objectAtIndex:1] intValue] <= level_ceilling) {
            [words_appro_for_level addObject:[word objectAtIndex:0]];
            //this should add the word to the array if the level is less than or equal
            //NSLog(@"%@",[words_appro_for_level objectAtIndex:([words_appro_for_level count]-1)]);
        }
    }
    
    //places the first 2 objects in the words_appro_for_level which are Bug and Cat
    for (int i =0; i<2; i++){
        [self.round_words addObject:[words_appro_for_level objectAtIndex:i]];
    }
    
    //modifies the words based on round
    
    for (int i=0; i<([self.round_words count]); i++){
        [self.round addObject:[self.round_words objectAtIndex:i]];
    }
    
    
    
}


@end

