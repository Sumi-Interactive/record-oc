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
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

SCSiriWaveformView *waveformView;

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"hfurie");
    [super viewDidLoad];
    [self initWaveFormView];
    self.isRecording = NO;
    self.isPlaying = NO;
    [RecorderManager sharedManager].delegate = self;
    [PlayerManager sharedManager].delegate = self;
    NSLog(@"fewbhj");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)record:(id)sender {
    if (self.isRecording) {
        [[RecorderManager sharedManager] stopRecording];
        [self.recordButton setTitle:@"record" forState:UIControlStateNormal];
        [self.playButton setEnabled:true];
    } else {
        [[RecorderManager sharedManager] startRecording];
        [self.recordButton setTitle:@"stop" forState:UIControlStateNormal];
        [self.playButton setEnabled:false];
    }
    self.isRecording = !self.isRecording;
}
- (IBAction)play:(id)sender {
    if (self.isRecording) {
        [[PlayerManager sharedManager] stopPlaying];
        [self.playButton setTitle:@"play" forState:UIControlStateNormal];
        [self.recordButton setEnabled:true];
    } else {
        [[PlayerManager sharedManager] playAudioWithFileName:self.filename delegate:self];
        [self.playButton setTitle:@"stop" forState:UIControlStateNormal];
        [self.recordButton setEnabled:false];
    }
    self.isPlaying = !self.isPlaying;
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
    NSLog(@"qwe:%@",filePath);
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.playButton setTitle:@"play" forState:UIControlStateNormal];
        [self.recordButton setEnabled:true];
    });
}
@end
