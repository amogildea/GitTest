//
//  AddNewTimerViewController.m
//  TimerPro
//
//  Created by user on 12/13/16.
//  Copyright © 2016 SoftIntercom. All rights reserved.
//

#import "AddNewTimerViewController.h"
#import "CustomHeaderTableViewCellForTimerIntervals.h"
#import "CustomTableViewCellForTimerIntervals.h"
#import "IntervalsTimerPickerView.h"
#import "IntervalsRoundsAmountPickerViewController.h"

@interface AddNewTimerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,IntervalsTimerPickerViewDelegate,IntervalsRoundsAmountPickerViewControllerDelegate>
{
    NSArray *arrayWithIntervalsTitles;
    NSArray *arrayWithIntervalsDescriptionTitles;
}

@end


@implementation AddNewTimerViewController
-(void)switchPlaceHolderTitle{
    switch (_timerMode) {
        case 0:
            [self.textFieldForTimerName setBebasFontPlaceHolderWithType:Bold
                                                         setPlaceholder:@"Enter name tabata workout".localized
                                                                   size:24];
            break;
        case 1:
            [self.textFieldForTimerName setBebasFontPlaceHolderWithType:Bold
                                                         setPlaceholder:@"Enter name rounds workout".localized
                                                                   size:24];
            break;
        case 2:
            [self.textFieldForTimerName setBebasFontPlaceHolderWithType:Bold
                                                         setPlaceholder:@"Enter name stopwatch workout".localized
                                                                   size:24];
            break;
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataTableView.tableFooterView = [UIView new];
    
    [self switchPlaceHolderTitle];
    [self loadDataFromNSUserDefaults];
    self.textFieldForTimerName.delegate = self;
    self.textFieldForTimerName.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.textFieldForTimerName setBebasFontWithType:Bold size:24];
    [self.textFieldForTimerName setText:self.tabataWorkout.tabataTimerWorkoutName];
    [self loadStaticArrayContentInTableView];
    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCellForTimerIntervals" bundle:nil];
    [[self dataTableView] registerNib:nib forCellReuseIdentifier:@"CustomTableViewCellForTimerIntervals"];
    self.title = @"Add new timer".localized;
    [self.navigationController.navigationBar setBebasFontWithSize:25];
//    self.cancelBarButtonItem.title = @"Cancel".localized;
        self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel".localized style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(cancelBarButtonItemAction:)];
    self.addBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Add".localized style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(addBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem =self.cancelBarButtonItem;
    self.navigationItem.rightBarButtonItem =self.addBarButtonItem;
    [self.navigationItem.leftBarButtonItem setBebasFontWithType:Bold
                                                           size:25
                                                          color:RGBColor(124, 124, 124, 1)];
    [self.navigationItem.rightBarButtonItem setBebasFontWithType:Bold
                                                            size:25
                                                           color:RGBColor(152, 255, 69, 1)];
    
    if (_edits == YES) {
        switch (_timerMode) {
            case 0:
                [self updateArrayWithCoreDataTabataValues];
                break;
            case 1:
                [self updateArrayWithCoreDataRoundsValues];
                break;
            case 2:
                [self updateArrayWithCoreDataStopwatchValues];
                break;
            default:
                break;
        }
        
    }
}
-(void)updateArrayWithCoreDataTabataValues{
    [self.addNewTimerTotalTimeArray removeAllObjects];
    [self.addNewTimerTotalTimeArray addObjectsFromArray:[self setTabataWorkoutCellValues:_tabataWorkout]];
}
-(void)updateArrayWithCoreDataRoundsValues{
    [self.addNewTimerTotalTimeArray removeAllObjects];
    [self.addNewTimerTotalTimeArray addObjectsFromArray:[self setRoundsWorkoutCellValues:_roundsWorkout]];
}
-(void)updateArrayWithCoreDataStopwatchValues{
    [self.addNewTimerTotalTimeArray removeAllObjects];
    [self.addNewTimerTotalTimeArray addObjectsFromArray:[self setStopwatchWorkoutCellValues:_stopwatchWorkout]];
}
- (NSArray*)setTabataWorkoutCellValues:(TabataWorkoutObject *)workout{
    
    NSArray *arrayContent;
    arrayContent = [[NSArray alloc]init];
    arrayContent  =@[workout.tabataTimerPrepareTime,
                     workout.tabataTimerWorkTime,
                     workout.tabataTimerRestTime,
                     workout.tabataTimerNrOfRounds,
                     workout.tabataTimerNrOfCycles,
                     workout.tabataTimerRestBetweenCyclesTime
                     ];
    return arrayContent;
}
- (NSArray*)setRoundsWorkoutCellValues:(RoundsWorkoutObject *)workout{
    
    NSArray *content;
    content = [[NSArray alloc]init];
    content  =@[workout.roundsTimerPrepareTime,
                workout.roundsTimerWorkTime,
                workout.roundsTimerRestTime,
                workout.roundsTimerNrOfRounds,
                ];
    return content;
}
-(NSArray*)setStopwatchWorkoutCellValues:(StopwatchWorkoutObject *)workout
{
    NSArray *content;
    content = [[NSArray alloc]init];
    content = @[workout.stopwatchTimerPrepareTime,workout.stopwatchTimerTimeLap];
    return content;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.textFieldForTimerName setTextColor:[UIColor blackColor]];
    [self.textFieldForTimerName setBackgroundColor:[UIColor whiteColor]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.textFieldForTimerName setTextColor:RGBColor(75, 75, 75, 1)];
    [self.textFieldForTimerName setBackgroundColor:RGBColor(32, 32, 32, 1)];
}
- (IBAction)cancelBarButtonItemAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addBarButtonItemAction:(id)sender {
    [self saveDataToCoreData];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadStaticArrayContentInTableView{
    
    arrayWithIntervalsTitles = @[@"Prepare".localized,
                                 @"Work".localized,
                                 @"Rest".localized,
                                 @"Rounds".localized,
                                 @"Cycles".localized,
                                 @"Rest between cycles".localized];
    
    arrayWithIntervalsDescriptionTitles = @[@"Countdown before you start".localized,
                                            @"Do exercises for this long".localized,
                                            @"Rest for this long".localized,
                                            @"One round is work + rest".localized,
                                            @"One cycle is 2 rounds".localized,
                                            @"Recovery interval".localized];

    switch (_timerMode) {
        case 0:
            arrayWithIntervalsTitles = [arrayWithIntervalsTitles subarrayWithRange:NSMakeRange(0, arrayWithIntervalsTitles.count)];
            arrayWithIntervalsDescriptionTitles = [arrayWithIntervalsDescriptionTitles subarrayWithRange:NSMakeRange(0, arrayWithIntervalsDescriptionTitles.count)];
            break;
        case 1:
            arrayWithIntervalsTitles = [arrayWithIntervalsTitles subarrayWithRange:NSMakeRange(0, 4)];
            arrayWithIntervalsDescriptionTitles = [arrayWithIntervalsDescriptionTitles subarrayWithRange:NSMakeRange(0, 4)];
            break;
        case 2:
            arrayWithIntervalsTitles  = @[@"Prepare".localized,
                                         @"Time lap".localized];
            
            arrayWithIntervalsDescriptionTitles = @[@"Countdown before you start".localized,
                                                    @"Clock will make a sound at each lap".localized];
        default:
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrayWithIntervalsTitles.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentfier = @"CustomTableViewCellForTimerIntervals";
    CustomTableViewCellForTimerIntervals *cell = [[self dataTableView] dequeueReusableCellWithIdentifier:cellIdentfier];
    cell.contentView.superview.backgroundColor = RGBColor(29, 29, 29, 1);
    [cell.colorForTimeIntervalImageView setHidden:YES];
    [cell.titleForTimeIntervalLabel setText:arrayWithIntervalsTitles[indexPath.row]];
    [cell.descriptionForTimeIntervalLabel setText:arrayWithIntervalsDescriptionTitles[indexPath.row]];
    
    cell.accessoryView = [[ UIImageView alloc ]
                          initWithImage:[UIImage imageNamed:@"arrowNext"]];
    if (indexPath.row == kRoundsMode || indexPath.row  == kCyclesMode) {
        cell.detailForPickedTimeIntervalLabel.text = [NSString stringWithFormat:@"%ld",[[_addNewTimerTotalTimeArray objectAtIndex:indexPath.row]integerValue]];
    }
    else{
        cell.detailForPickedTimeIntervalLabel.text = [self formattedTimeTableView:[[_addNewTimerTotalTimeArray objectAtIndex:indexPath.row]integerValue]];
    }
    [cell.leadingConstraintTitleForTimeInterval setConstant:0];
    [cell.leadingConstraintImageView setConstant:0];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5){
        
        IntervalsTimerPickerView *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"IntervalsTimerPickerView"];
        vc2.pickerValue = [_addNewTimerTotalTimeArray objectAtIndex:indexPath.row];
        vc2.delegate = self;
        vc2.colorsHidden = YES;
        vc2.displayMode = indexPath.row;
        [self.navigationController pushViewController:vc2 animated:YES];
    }
    else{
        
        IntervalsRoundsAmountPickerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IntervalsRoundsAmountPickerViewController"];
        vc.pickerAmountValue = [_addNewTimerTotalTimeArray objectAtIndex:indexPath.row];
        vc.delegate = self;
        vc.collectionViewHidden = YES;
        vc.pickerMode = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [_textFieldForTimerName resignFirstResponder];
    
    //    static NSString *storyboardIdentifier = @"IntervalsTimerPickerView";
    //    IntervalsTimerPickerView *viewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    //    viewController.displayMode = indexPath.row;
    //    viewController.delegate = self;
    //    viewController.colorsHidden = YES;
    //    viewController.pickerValue = [_addNewTimerTotalTimeArray objectAtIndex:indexPath.row];
    //
    //    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)pickedData:(NSNumber *)pickedValue andPickerDisplayMode:(PickerDisplayMode)displayMode andSelectedColor:(NSNumber *)color{
    
    [_addNewTimerTotalTimeArray removeObjectAtIndex:displayMode];
    [_addNewTimerTotalTimeArray insertObject:pickedValue atIndex:displayMode];
    NSLog(@"%@",_addNewTimerTotalTimeArray);
    [_dataTableView reloadData];
}

-(void)pickedAmountData:(NSNumber *)amountValue andPickerDisplayMode:(PickerMode)pickerMode andSelectedIndexFromCollectionView:(NSNumber *)indexColor{
    
    [_addNewTimerTotalTimeArray removeObjectAtIndex:pickerMode];
    [_addNewTimerTotalTimeArray insertObject:amountValue atIndex:pickerMode];
    NSLog(@"%@",_addNewTimerTotalTimeArray);
    [_dataTableView reloadData];
    
}
- (void) loadDataFromNSUserDefaults{
    NSUserDefaults *loadData = [NSUserDefaults standardUserDefaults];
    //    switch (_timerMode) {
    //        case 0:
    //             _addNewTimerTotalTimeArray = [[NSMutableArray alloc] initWithArray:[loadData objectForKey:@"pickerAddNewTimerTabataTimeIntervalsArray"]];
    //            break;
    //        case 1:
    //             _addNewTimerTotalTimeArray = [[NSMutableArray alloc] initWithArray:[loadData objectForKey:@"pickerAddNewTimerRoundsTimeIntervalsArray"]];
    //            break;
    //        case 2:
    //            _addNewTimerTotalTimeArray = [[NSMutableArray alloc] initWithArray:[loadData objectForKey:@"pickerAddNewTimerStopwatchTimeIntervalsArray"]];
    //            break;
    //        default:
    //            break;
    //    }
    _addNewTimerTotalTimeArray = [[NSMutableArray alloc] initWithArray:[loadData objectForKey:@"pickerAddNewTimerTabataTimeIntervalsArray"]];
}
- (void) saveDataToCoreData{
    
    
    switch (_timerMode) {
        case 0:
            [self saveTabataWorkoutToCoreData];
            break;
        case 1:
            [self saveRoundsWorkoutToCoreData];
            break;
        case 2:
            [self saveStopwatchWorkoutToCoreData];
        default:
            break;
    }
}

-(void)saveTabataWorkoutToCoreData
{
    if (!_edits) {
        self.tabataWorkout = [TabataWorkoutObject new];
    }
    self.tabataWorkout.tabataTimerWorkoutName  = self.textFieldForTimerName.text;
    if([self.textFieldForTimerName.text isEqualToString:@""]){
        
        self.tabataWorkout.tabataTimerWorkoutName = @"Tabata workout".localized;
    }
    self.tabataWorkout.tabataTimerPrepareTime = _addNewTimerTotalTimeArray[0];
    self.tabataWorkout.tabataTimerWorkTime = _addNewTimerTotalTimeArray[1];
    self.tabataWorkout.tabataTimerRestTime = _addNewTimerTotalTimeArray[2];
    self.tabataWorkout.tabataTimerNrOfRounds = _addNewTimerTotalTimeArray[3];
    self.tabataWorkout.tabataTimerNrOfCycles = _addNewTimerTotalTimeArray[4];
    self.tabataWorkout.tabataTimerRestBetweenCyclesTime = _addNewTimerTotalTimeArray[5];
    
    
    if (_edits == YES){
        [[DatabaseManager sharedInstance] updateTabataWorkout:_tabataWorkout];
    } else{
        self.tabataWorkout.tabataTimerWorkoutTimeStamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [[DatabaseManager sharedInstance] insertTabataWorkout:self.tabataWorkout];
    }
}
-(void)saveRoundsWorkoutToCoreData{
    if (!_edits) {
        self.roundsWorkout = [RoundsWorkoutObject new];
    }
    self.roundsWorkout.roundsTimerWorkoutName = self.textFieldForTimerName.text;
    if([self.textFieldForTimerName.text isEqualToString:@""]){
        
        self.roundsWorkout.roundsTimerWorkoutName  = @"Rounds workout".localized;
    }
    self.roundsWorkout.roundsTimerPrepareTime = _addNewTimerTotalTimeArray[0];
    self.roundsWorkout.roundsTimerWorkTime = _addNewTimerTotalTimeArray[1];
    self.roundsWorkout.roundsTimerRestTime = _addNewTimerTotalTimeArray[2];
    self.roundsWorkout.roundsTimerNrOfRounds = _addNewTimerTotalTimeArray[3];
    
    if (_edits == YES) {
        [[DatabaseManager sharedInstance] updateRoundsWorkout:_roundsWorkout];
    }else{
        self.roundsWorkout.roundsTimerTimeStamp = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
        [[DatabaseManager sharedInstance] insertRoundsWorkout:self.roundsWorkout];
    }
}
-(void)saveStopwatchWorkoutToCoreData{
    
    if (!_edits) {
        self.stopwatchWorkout = [StopwatchWorkoutObject new];
    }
    self.stopwatchWorkout.stopwatchTimerWorkoutName = self.textFieldForTimerName.text;
    if([self.textFieldForTimerName.text isEqualToString:@""]){
        
        self.stopwatchWorkout.stopwatchTimerWorkoutName = @"Stopwatch workout".localized;
    }
    self.stopwatchWorkout.stopwatchTimerPrepareTime = _addNewTimerTotalTimeArray[0];
    self.stopwatchWorkout.stopwatchTimerTimeLap = _addNewTimerTotalTimeArray[1];
    if (_edits == YES) {
        [[DatabaseManager sharedInstance]updateStopwatchWorkout:_stopwatchWorkout];
    }else{
        self.stopwatchWorkout.stopwatchTimerTimeStamp = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
        [[DatabaseManager sharedInstance]insertStopwatchWorkout:self.stopwatchWorkout];
    }
}
-(NSString *)formattedTimeTableView:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    if (totalSeconds<60) {
        return [NSString stringWithFormat:@":%02ld",seconds];
    }
    else
        return [NSString stringWithFormat:@"%02ld:%02ld",minutes,seconds];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)setValue:(NSInteger)integerValue{
    value = integerValue;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseMoved)
    {
        BOOL hasHit = NO;
        
        CGPoint touchLocation = [touch locationInView:self];
        
        for (id subview in self.buttonView.subviews)
        {
            if (_animationInProgress) break;
            
            if (![subview isKindOfClass:[PCRapidButton class]]) continue;
            
            PCRapidButton *button = subview;
            CGRect buttonInView = [button convertRect:button.bounds toView:self];
            
            BOOL hitButton = CGRectContainsPoint(buttonInView, touchLocation);
            
            if (!hasHit) hasHit = hitButton;
            
            [UIView animateWithDuration:0.05 animations:^
            {
                [button setHighlighted:hitButton];
            }];
            
            if (hitButton && touch.phase == UITouchPhaseEnded)
            {
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
                return;
            }
            
            if (touch.phase == UITouchPhaseMoved) continue;
        }
        
        if (!hasHit && touch.phase == UITouchPhaseEnded) [self show:NO completionHandler:nil];
        return;
    }
    
    [super touchesMoved:touches withEvent:event];
}

static void OverrideSendEvent(UIWindow *self, SEL _cmd, UIEvent *event)
{
    gOrigSendEvent(self, _cmd, event);
    
    if ([PCRapidSelectionView isInteractive])
    {
        
        UITouch *touch = event.allTouches.anyObject;
        
        if (!_rapidSelectionView)
        {
            _rapidSelectionView = (id)[[[UIApplication sharedApplication] keyWindow] viewWithTag:kPCRapidSelectionViewTag];
        }
        
        if (touch && _rapidSelectionView)
        {
            [_rapidSelectionView touchesMoved:event.allTouches withEvent:event];
            
            if (touch.phase == UITouchPhaseEnded)
            {
                _rapidSelectionView = nil;
            }
            
            return;
        }
    }
}



@end
