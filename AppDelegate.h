//
//  AppDelegate.h
//  TimerPro
//
//  Created by user on 11/8/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
@property (strong,nonatomic) TabataWorkouts *tabataWorkout;

@end

