//
//  MainGameVC.m
//  AudiOWords
//
//  Created by Ashley Soucar on 9/21/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import "MainGameVC.h"
#import "MainMenuVC.h"
#import "GameWord.h"
#import "EndRoundVC.h"
#import <AVFoundation/AVFoundation.h>

@interface MainGameVC ()

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
@property (nonatomic) NSNumber *currLevel;
@property (nonatomic) double score;
@property (nonatomic) int timesWrong;

@property (nonatomic, retain) AVAudioPlayer *cheerPlay;

//array for read from file
@property (nonatomic, retain) NSMutableArray *round_words;
@property (nonatomic, retain) NSMutableArray *round;



@end

@implementation MainGameVC

@synthesize levelWords,backToHome, giveHintButton;
@synthesize bgSound;
@synthesize fliteController;
@synthesize slt;


- (FliteController *)fliteController {
    if (fliteController == nil){
        fliteController = [[FliteController alloc] init];
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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //starting the block for the looping bg sound
    NSString *bgsoundFilePath = [[NSBundle mainBundle] pathForResource:@"MenuSound" ofType:@"aiff"];
    NSURL *bgsoundFileURL = [NSURL fileURLWithPath:bgsoundFilePath];
    bgSound = [[AVAudioPlayer alloc] initWithContentsOfURL:bgsoundFileURL error:nil];
    bgSound.numberOfLoops = -1; //infinite
    [bgSound setVolume: .05];
    [bgSound play];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.currLevel = [prefs objectForKey:@"level"];
    
    self.levelWords = [NSMutableArray array];
    self.currentIndex = 0;
    self.letterIndex = 0;
    self.timesWrong = 1;
    self.score = 0;
    self.letterButtons = [NSMutableArray array];
    self.thisWordsSpelling = [NSMutableArray array];
    
    AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"happycheering" ofType:@"aiff"]] error:nil];
    self.cheerPlay = pp1;
    [pp1 setVolume:7.0];
    [pp1 prepareToPlay];
    
    [self getRoundTasksForLevel:[self.currLevel intValue]];
    
    for (NSString *word in self.round_words) {
        GameWord *firstWord = [GameWord gameWordWithWord:word];
        [self.levelWords addObject:firstWord];
    }
    
    self.currentWord = [levelWords objectAtIndex:self.currentIndex];
    
    [self setupLevelWithWord:self.currentWord];
    
}

- (void)viewDidUnload
{
    [self setBackToHome:nil];
    [self setGiveHintButton:nil];
    [self setWordPicLabel:nil];
    [super viewDidUnload];
    [self.levelWords removeAllObjects];
    self.levelWords = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - game setup

-(void)setupLevelWithWord:(GameWord *)word
{
    
    
    self.isWordSpelled = NO;
    self.wrongLetterBool = NO;
    
    //add pic
    self.target = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width)/2.6,
                                                                (self.view.bounds.size.height)/4,
                                                                250, 250)];
    self.target.image = word.wordImage;
    [self.view addSubview:self.target];
    
    self.wordPicLabel.text = word.theWord;
    [self.wordPicLabel setAlpha:0.1];
    
    //pull letters from gameword
    //create draggable buttons
    //use for loop through letters
    int tempCount = 1;
    NSString *wordWithExtra = [self.round objectAtIndex:self.currentIndex];
    NSMutableArray *tempWord = [[NSMutableArray alloc] initWithCapacity:[wordWithExtra length]];
    
    //Creates the C O W spells Cow object as hint1:
    NSString *hint1= @"";
    for (int i = 0; i<([self.currentWord.letters count]); i++){
        
        hint1 = [hint1 stringByAppendingString:[self.currentWord.letters objectAtIndex:i]];
        hint1 = [hint1 stringByAppendingString:@" "];
    }
    hint1 = [hint1 stringByAppendingString:@"spells "];
    hint1 = [hint1 stringByAppendingString:self.currentWord.theWord];
    
    NSLog(hint1);
    
    //Says the W O R D spells word with voice slt
    [self.fliteController say: hint1 withVoice:self.slt];
    
    for (int i=0; i < [wordWithExtra length]; i++) {
        NSString *iletter  = [NSString stringWithFormat:@"%c", [wordWithExtra characterAtIndex:i]];
        [tempWord addObject:iletter];
    }
    
    for (int i =0; i < ([tempWord count]-1); i++){
        int nElements = ([tempWord count]-i);
        int n =arc4random_uniform(nElements)+i;
        [tempWord exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    for (NSString *lett in tempWord) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:lett forState:UIControlStateNormal];
        
        // add drag listener
        [button addTarget:self action:@selector(wasDragged:withEvent:)
         forControlEvents:UIControlEventTouchDragInside];
        
        [button addTarget:self action:@selector(touchesEnded:withEvent:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [button addTarget:self action:@selector(buttonTouchDownRepeat:event:)
         forControlEvents:UIControlEventTouchDownRepeat];

        // center and size
        button.frame = CGRectMake((self.view.bounds.size.width - 100)/(tempWord.count+1)*tempCount,
                                  (self.view.bounds.size.height - 50)/5*4,
                                  100, 100);
        button.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:50];
        [button setBackgroundImage:[UIImage imageNamed:@"blackbutton.png"] forState:UIControlStateNormal];
        [button.titleLabel setTextColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
        [button setAccessibilityTraits:UIAccessibilityTraitNone];
        
        // add it
        [self.view addSubview:button];
        
        [self.letterButtons addObject:button];
        tempCount++;
        
    }
    
    self.nextLetter = [self.currentWord.letters objectAtIndex:self.letterIndex];
}

#pragma mark - game function

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
    
    if (button.center.x > 350 && button.center.x < 650 &&
        button.center.y > 175 && button.center.y < 475) {
        //play sound for center recognition
    }
}

- (void) buttonTouchDownRepeat:(id)sender event:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    UIButton *tapped = sender;
    if(touch.tapCount == 1 && UIAccessibilityIsVoiceOverRunning())
    {
        [tapped removeFromSuperview];
        tapped.center = CGPointMake(-200, -200);
        [self isCorrectLetter:tapped.titleLabel.text];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for (UIButton *button in self.letterButtons) {
        [button.titleLabel setTextColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
        if (button.center.x > 350 && button.center.x < 650 &&
            button.center.y > 175 && button.center.y < 475) {
            [button removeFromSuperview];
            button.center = CGPointMake(-100, -100);
            [self isCorrectLetter:button.titleLabel.text];
        }
        
        else if ([button accessibilityElementIsFocused]){
            [button removeFromSuperview];
            button.center = CGPointMake(-100, -100);
            [self isCorrectLetter:button.titleLabel.text];
        }
    }

    if (self.wrongLetterBool) {
        [self wrongLetter];
    }
    
    if (self.isWordSpelled) {
        //play win sound
        [self playWinSound];
        self.score += 25/self.timesWrong;
        self.timesWrong = 1;
        [self resetScreen];
        
        //if finished round
        if (self.levelWords.count == self.currentIndex+1) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSData *retrData = [prefs objectForKey:@"levelsAndScores"];
            NSMutableDictionary *levelsAndScores = [NSKeyedUnarchiver unarchiveObjectWithData:retrData];

            if (levelsAndScores != NULL) {
                NSNumber *scoreForLevel = [NSNumber numberWithDouble:self.score];
                [levelsAndScores setObject:scoreForLevel forKey:self.currLevel];
            }
            else{
                levelsAndScores = [NSMutableDictionary dictionaryWithCapacity:20];
                NSNumber *scoreForLevel = [NSNumber numberWithDouble:self.score];
                [levelsAndScores setObject:scoreForLevel forKey:self.currLevel];
            }
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:levelsAndScores];
            [prefs setObject:data forKey:@"levelsAndScores"];
            
            int totalScore = 0;
            for (NSNumber *num in levelsAndScores) {
                totalScore = totalScore + [num intValue];
            }
            
            NSInteger totScore = totalScore;
            
            [prefs setInteger:totScore forKey:@"totalScore"];
            
            EndRoundVC *roundEnded = [[EndRoundVC alloc] init];
            [self.view.window setRootViewController:roundEnded];
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
    self.timesWrong++;
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
    int waitTime = 4;
    wait(&waitTime);
}

#pragma mark - navigation button(s)

- (IBAction)backButton
{
    MainMenuVC *menuVC = [[MainMenuVC alloc] init];
    [self.view.window setRootViewController:menuVC];
}

- (IBAction)hintButton
{
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

#pragma mark - Read In From File

- (void)getRoundTasksForLevel:(int)levNum
{
    NSArray *alphabet = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i", @"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
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
    //starts the level logic
    if(level == 1 || level == 3 || level == 5){
        level_ceilling = level;
    }
    else if(level == 2 || level == 7 || level == 10 || level == 13){
        level_ceilling = 2;
    }
    else if(level == 4 || level == 8 || level == 11 || level == 14){
        level_ceilling = 3;
    }
    else if(level == 6 || level == 9 || level == 12 || level == 15){
        level_ceilling = 6;
    }
    else level_ceilling = 6;
    
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
    //shuffles the array of words_appro_for_level
    for (int i =0; i < ([words_appro_for_level count]-1); i++){
        int nElements = ([words_appro_for_level count]-i);
        int n =arc4random_uniform(nElements)+i;
        [words_appro_for_level exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    //places the first 4 objects in the words_appro_for_level which are randomized due to the shuffle
    for (int i =0; i<4; i++){
        [self.round_words addObject:[words_appro_for_level objectAtIndex:i]];
    }

    //modifies the words based on round
    if(level >= 7 && level <= 9){
        for (int i=0; i<([self.round_words count]); i++){
            int position = (arc4random() %25);
            
            NSString *string = [[NSString alloc] initWithString:[self.round_words objectAtIndex:i]];
            string = [string stringByAppendingString:[alphabet objectAtIndex:position]];
            [self.round addObject:string];
        }
    }
    else if(level >= 10 && level <= 12){
        for (int i=0; i<([self.round_words count]); i++){
            int position = (arc4random() %25);
            int position2 = (arc4random() %25);
            
            NSString *string = [[NSString alloc] initWithString:[self.round_words objectAtIndex:i]];
            string = [string stringByAppendingString:[alphabet objectAtIndex:position]];
            NSString *string2 = [[NSString alloc] initWithString:string];
            string2 = [string2 stringByAppendingString:[alphabet objectAtIndex:position2]];
            [self.round addObject:string2];
        }
    }
    else if(level >= 13 && level <= 15){
        for (int i=0; i<([self.round_words count]); i++){
            int position = (arc4random() %25);
            int position2 = (arc4random() %25);
            int position3 = (arc4random() %25);
            
            NSString *string = [[NSString alloc] initWithString:[self.round_words objectAtIndex:i]];
            string = [string stringByAppendingString:[alphabet objectAtIndex:position]];
            NSString *string2 = [[NSString alloc] initWithString:string];
            string2 = [string2 stringByAppendingString:[alphabet objectAtIndex:position2]];
            NSString *string3 = [[NSString alloc] initWithString:string2];
            string3 = [string3 stringByAppendingString:[alphabet objectAtIndex:position3]];
            [self.round addObject:string3];
        }
    }
    else if(level < 7){
        for (int i=0; i<([self.round_words count]); i++){
            [self.round addObject:[self.round_words objectAtIndex:i]];
        }
    }

    
}



@end
