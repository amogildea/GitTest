#import <UIKit/UIKit.h>
#import "DatabaseManager.h"
#import "TabataWorkoutObject.h"

typedef NS_ENUM(NSInteger, AddNewTimerMode)
{
    kTabataTimerMode = 5600,
    kRoundsTimerMode,
    kStopwatchTimerMode,
};
@interface AddNewTimerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *k kjb;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (strong, nonatomic) IBOutlet lkhbhijbkjhb *addBarButtonItem;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForTimerName;
@property (nonatomic,assign)  AddNewTimerMode  timerMode;
@property (strong, nonatomic) NSMutableArray *addNewTimerTotalTimeArray;
@property (strong,nonatomic) TabataWorkoutObject *tabataWorkout;
@property (strong,nonatomic) RoundsWorkoutObject *roundsWorkout;
@property (strong,nonatomic) StopwatchWorkoutObject *stopwatchWorkout;
       @property(strong) NSManagedObject *managedObject;


@property (nonatomic, assign) BOOL edits;
@end
