//
//  ViewController.m
//  record-oc
//
//  Created by langker on 16/5/21.
//  Copyright © 2016年 langker. All rights reserved.
//

#import "ViewController.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "SCSiriWaveformView.h"
@interface ViewController () <RecordingDelegate, PlayingDelegate>
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) BOOL isPlaying;

@end

SCSiriWaveformView *waveformView;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWaveFormView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)record:(id)sender {
    [RecorderManager sharedManager].delegate = self;
    [[RecorderManager sharedManager] startRecording];
}
- (IBAction)play:(id)sender {
    [PlayerManager sharedManager].delegate = nil;
    [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
}
- (IBAction)stop:(id)sender {
    [[RecorderManager sharedManager] stopRecording];
}
-(void)initWaveFormView {
    waveformView = [[SCSiriWaveformView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    waveformView.waveColor = [UIColor whiteColor];
    waveformView.primaryWaveLineWidth = 3.0;
    waveformView.secondaryWaveLineWidth = 1.0;
    [self.view addSubview:waveformView];
}
#pragma mark - Recording & Playing Delegate

- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    self.isRecording = NO;
    self.filename = filePath;
}

- (void)recordingTimeout {
    self.isRecording = NO;
}

- (void)recordingStopped {
    self.isRecording = NO;
}

- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
}

- (void)levelMeterChanged:(float)levelMeter {
    [waveformView updateWithLevel:levelMeter];
}

- (void)playingStoped {
    self.isPlaying = NO;
}

@end
