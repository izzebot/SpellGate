//
//  gameWord.m
//  AudiOWords
//
//  Created by Ashley Soucar on 9/26/12.
//  Copyright (c) 2012 Spellers. All rights reserved.
//

#import "GameWord.h"

@implementation GameWord

@synthesize letters, theWord, wordImage, sounds;

#pragma mark - initialization methods

+(id)gameWordWithWord:(NSString *)aWord
{
    return [[self alloc] initWithWord:aWord];
}


-(id)initWithWord:(NSString *)aWord
{
    self = [super init];
    if (self){
        self.sounds = [NSMutableDictionary dictionary];
        
        self.theWord = aWord;
        
        self.letters = [[NSMutableArray alloc] initWithCapacity:[aWord length]];
        
        for (int i=0; i < [aWord length]; i++) {
            NSString *iletter  = [NSString stringWithFormat:@"%c", [aWord characterAtIndex:i]];
            [letters addObject:iletter];
        }
        
        self.wordImage = [UIImage imageNamed: [NSString stringWithFormat:@"%@.PNG", aWord]];
        
        
        AVAudioPlayer *pp1 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", aWord] ofType:@"aiff"]] error:nil];
        self.happyPlay = pp1;
        [pp1 setVolume:0.8];
        [pp1 prepareToPlay];
        
        AVAudioPlayer *pp2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sadsound" ofType:@"aiff"]] error:nil];
        self.sadPlay = pp2;
        [pp2 setVolume:0.8];
        [pp2 prepareToPlay];
        

    }
    return self;
}




#pragma mark - sounds

-(void)playHappySound
{
    [self.happyPlay play];
}

-(void)playSadSound
{
    [self.sadPlay play];
}

@end

