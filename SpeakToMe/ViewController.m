//
//  ViewController.m
//  SpeakToMe
//
//  Created by Mykola Vyshynskyi on 31.10.15.
//  Copyright © 2015 Mykola Vyshynskyi. All rights reserved.
//

#import "ViewController.h"

#define TEXT_FONT [UIFont systemFontOfSize:20]

@import AVFoundation;

@interface ViewController () <AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *speakBtn;

@property (readwrite, nonatomic, copy) NSString *utteranceString;
@property (readwrite, nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

- (IBAction)rateValueChanged:(UISegmentedControl *)sender;
- (IBAction)speakBtnAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.layer.borderColor = self.speakBtn.tintColor.CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 4;
    
    self.speakBtn.layer.borderColor = self.speakBtn.tintColor.CGColor;
    self.speakBtn.layer.borderWidth = 1;
    self.speakBtn.layer.cornerRadius = 4;

    self.utteranceString = self.textView.text;
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    self.speechSynthesizer.delegate = self;
    
    [self resetText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:animated];
}

#pragma mark - Private

- (void)resetText
{
    NSMutableParagraphStyle *rtlParagraph = [NSMutableParagraphStyle new];
    rtlParagraph.baseWritingDirection = NSWritingDirectionRightToLeft;
 
    NSDictionary *textAttributes = @{NSFontAttributeName: TEXT_FONT,
                                     NSParagraphStyleAttributeName: rtlParagraph};
    
    self.textView.attributedText = [[NSMutableAttributedString alloc] initWithString:self.utteranceString attributes:textAttributes];
    
    [self.textView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - IBActions

- (IBAction)rateValueChanged:(UISegmentedControl *)sender
{
    
}

- (IBAction)speakBtnAction:(id)sender
{
    self.utteranceString = self.textView.text;
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.utteranceString];
    
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"he-IL"];
    utterance.rate = self.rateSlider.value;
    utterance.preUtteranceDelay = 0.2f;
    utterance.postUtteranceDelay = 0.2f;
    
    [self.speechSynthesizer speakUtterance:utterance];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
willSpeakRangeOfSpeechString:(NSRange)characterRange
                utterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));

    NSMutableParagraphStyle *rtlParagraph = [NSMutableParagraphStyle new];
    rtlParagraph.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    NSDictionary *textAttributes = @{NSFontAttributeName: TEXT_FONT,
                                     NSParagraphStyleAttributeName: rtlParagraph};

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self.utteranceString attributes:textAttributes];
    [mutableAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor blueColor] range:characterRange];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:characterRange];
    
    self.textView.attributedText = mutableAttributedString;
    
    [self.textView scrollRangeToVisible:characterRange];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
  didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer
 didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
    
    [self resetText];
}

@end
