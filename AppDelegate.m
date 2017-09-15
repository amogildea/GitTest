//
//  AppDelegate.m
//  TimerPro
//
//  Created by user on 11/8/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "AppDelegate.h"
#import "TabataTimerViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()<AVAudioSessionDelegate,UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    [Fabric with:@[[Crashlytics class]]];

    
//    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
//    [tbc setSelectedIndex:1];
    [self initUserDefaults];
    [self initiateObservers];
    [self initAudioSession];
    
    self.window.backgroundColor = RGBColor(29, 29, 29, 1);
    
    
    return YES;
}


-(void) initiateObservers{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canRotate) name:shouldRotate object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canNotRotate) name:shouldNotRotate object:nil];
}


- (void) initAudioSession
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES withOptions: 0 error: nil];
  
    if (setCategoryErr)
    {
        NSLog(@"Setting Audio Session Category Error: %@",[setCategoryErr description]);
    }
//    [[AVAudioSession sharedInstance] setDelegate:self];
//    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    if (activationErr)
    {
        NSLog(@"Activating Audio Session Error: %@",[activationErr description]);
    }
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
        
        //        NSArray *arrayWithSettingsData = @[[NSNumber numberWithInteger:2],
        //                                           @"Boxing Bell",
        //                                           [NSNumber numberWithInteger:0],
        //                                           @"00:00"];
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

//@synthesize persistentContainer = _persistentContainer;
//
//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TimerPro"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//
//    return _persistentContainer;
//}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
