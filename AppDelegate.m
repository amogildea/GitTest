#import "AppDelegate.h"
#import "TabataTimerViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()<AVAudioSessionDelegate,UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    [Fabric with:@[[Crashlytics class]]];
    [self initUserDefaults];
    [self initiateObservers];
    [self initAudioSession];
    self.window.backgroundColor = RGBColor(29, 29, 29, 1);
    
    
    return YES;
}

- (void) initAudioSession
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];
}


-(void) canRotate{
    
    [[SettingsManager sharedManager]updateRotation:YES];
}


-(void) canNotRotate{
    
    [[SettingsManager sharedManager]updateRotation:NO];
}


#pragma mark - Set Orientations
- (UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    [[SettingsManager sharedManager]loadSettings];
    if ([[SettingsManager sharedManager]rotation] == YES){
        
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }else{
        
        return UIInterfaceOrientationMaskPortrait;
    }
}


-(void)initSettingsManager
{
    [[SettingsManager sharedManager]updateSound:YES];
    [[SettingsManager sharedManager]updateVoiceAssist:YES];
    [[SettingsManager sharedManager]updateVibro:NO];
    [[SettingsManager sharedManager]updateFlashLight:NO];
    [[SettingsManager sharedManager] updateScreenFlash:NO];
    [[SettingsManager sharedManager]updateDucking:YES];
    [[SettingsManager sharedManager]updateRotation:YES];
    
    [[SettingsManager sharedManager]loadSettings];
}

- (void) initUserDefaults
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstRun"]){
        [self initSettingsManager];
        NSArray *pickerStopwatchTimeIntervalsArray =@[@5,
                                                      @10];
        
        NSArray *stopwatchArrayWithIntervalsColors = @[@timerYellowColor,
                                                        @timerGreenColor];
        NSArray *pickerRoundsTimeIntervalsArray = @[@5,
                                                    @30,
                                                    @15,
                                                    @4];
        
        NSArray *roundsArrayWithIntervalsColors =@[@timerYellowColor,
                                                    @timerGreenColor,
                                                    @timerRedColor,
                                                    @timerBlueColor];
        
        NSArray *pickerTabataTimeIntervalsArray = @[@5,
                                                    @30,
                                                    @15,
                                                    @4,
                                                    @3,
                                                    @30];
        
        NSArray *pickerAddNewTimerTabataTimeIntervalsArray = @[@1,
                                                               @1,
                                                               @1,
                                                               @1,
                                                               @1,
                                                               @1];

        NSDictionary *dictionaryWithSettingsData = @{
                                                     @"soundIndex" : [NSNumber numberWithInteger:AirHorn],
                                                     @"soundTitle" : @"Air Horn",
                                                     @"timeFormatIndex" : [NSNumber numberWithInteger:0],
                                                     @"timeFormatTitle" : @"00:00"
                                                     };
        
        NSArray *tabataArrayWithIntervalsColors = @[@timerYellowColor,
                                                     @timerGreenColor,
                                                     @timerRedColor,
                                                     @timerBlueColor,
                                                     @timerYellowColor,
                                                     @timerGreenColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:pickerStopwatchTimeIntervalsArray forKey:@"pickerStopwatchValues"];
        [[NSUserDefaults standardUserDefaults] setObject:stopwatchArrayWithIntervalsColors forKey:@"colorsStopwatchArray"];
        [[NSUserDefaults standardUserDefaults] setObject:pickerTabataTimeIntervalsArray forKey:kPickerTabataValues];
        [[NSUserDefaults standardUserDefaults] setObject:pickerAddNewTimerTabataTimeIntervalsArray forKey:@"pickerAddNewTimerTabataTimeIntervalsArray"];
        [[NSUserDefaults standardUserDefaults] setObject:tabataArrayWithIntervalsColors forKey:@"colorsTabataArray"];
        [[NSUserDefaults standardUserDefaults] setObject:pickerRoundsTimeIntervalsArray forKey:@"pickerRoundsValues"];
        [[NSUserDefaults standardUserDefaults] setObject:roundsArrayWithIntervalsColors forKey:@"colorsRoundsArray"];
        [[NSUserDefaults standardUserDefaults] setObject:dictionaryWithSettingsData forKey:@"dictionaryWithSettingsData"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstRun"];
        
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

@end
