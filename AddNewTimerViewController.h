//
//  AddNewTimerViewController.h
//  TimerPro
//
//  Created by user on 12/13/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#import "TabataWorkoutObject.h"

typedef NS_ENUM(NSInteger, AddNewTimerMode)
{
    kTabataTimerMode = 0,
    kRoundsTimerMode,
    kStopwatchTimerMode,
};
@interface AddNewTimerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *dataTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForTimerName;
@property (nonatomic,assign)  AddNewTimerMode  timerMode;
@property (strong, nonatomic) NSMutableArray *addNewTimerTotalTimeArray;
@property (strong,nonatomic) TabataWorkoutObject *tabataWorkout;
@property (strong,nonatomic) RoundsWorkoutObject *roundsWorkout;
@property (strong,nonatomic) StopwatchWorkoutObject *stopwatchWorkout;
       @property(strong) NSManagedObject *managedObject;


@property (nonatomic, assign) BOOL edits;
@end
