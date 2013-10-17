//
//  DMPluginDateEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/2/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginDateEditor.h"
#import "DMContentCreatorStyle.h"
#import "DMContentCreator.h"
@interface DMPluginDateEditor (){
    BOOL isDismissing;
    NSCalendar *defaultCalendar;
    NSDateFormatter *dateFormatter,*dateFormatDisplay;
    UIDatePicker *datePicker;
    BOOL isShow;
}
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (nonatomic,strong) DMContentPlugins *plugins;
@end
@implementation DMPluginDateEditor

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isShow = NO;
    defaultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_beginDateLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [_endDateLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.title = _plugins.pluginName;
    datePicker = [UIDatePicker new];
    [datePicker setFrame:CGRectMake(0,self.view.frame.size.height,datePicker.frame.size.width,datePicker.frame.size.height)];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:defaultCalendar];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    dateFormatDisplay = [[NSDateFormatter alloc] init];
    [dateFormatDisplay setCalendar:[NSCalendar currentCalendar]];
    [dateFormatDisplay setDateFormat:@"dd MMMM yyyy"];
    
    
    if (_plugins[DMCBeginDate]) {
        [_beginDateLabel setText:[self textFromDateString:_plugins[DMCBeginDate]]];
    }
    
    if (_plugins[DMCEndDate]) {
        [_endDateLabel setText:[self textFromDateString:_plugins[DMCEndDate]]];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_plugins checkIncompleteLists];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.contentOffset.y < -170.0f && !isDismissing) {
        isDismissing = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
//    NSDate *initDate = [NSDate new];
//    if (indexPath.section == 0 && _plugins[DMCBeginDate]) {
//        initDate = [dateFormatter dateFromString:_plugins[DMCBeginDate]];
//    }else if (_plugins[DMCEndDate]) {
//        initDate = [dateFormatter dateFromString:_plugins[DMCEndDate]];
//    }
//    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:initDate];
//    [datePicker setTintColor:[[DMContentCreator sharedComponents] color]];
//    [datePicker presentInView:self.view withBlock:^(BOOL madeChoice) {
//        if (madeChoice) {
//            if (indexPath.section == 0) {
//                _plugins[DMCBeginDate] = [dateFormatter stringFromDate:datePicker.selectedDate];
//            }else{
//                _plugins[DMCEndDate] = [dateFormatter stringFromDate:datePicker.selectedDate];
//            }
//        }
//        if (_plugins[DMCBeginDate]) {
//            [_beginDateLabel setText:[self textFromDateString:_plugins[DMCBeginDate]]];
//        }
//        
//        if (_plugins[DMCEndDate]) {
//            [_endDateLabel setText:[self textFromDateString:_plugins[DMCEndDate]]];
//        }
//    }];
//    [datePicker.toolbar setBarStyle:UIBarStyleDefault];
    [self slidePickerIn:indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)slidePickerIn:(NSUInteger)section{
    //Position the picker out of site
    NSDate *initDate = [NSDate new];
    if (section == 0 && _plugins[DMCBeginDate]) {
        initDate = [dateFormatter dateFromString:_plugins[DMCBeginDate]];
    }else if (_plugins[DMCEndDate]) {
        initDate = [dateFormatter dateFromString:_plugins[DMCEndDate]];
    }else{
        initDate = [NSDate date];
    }

    
    datePicker.tag = section;
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    if (initDate) {
        [datePicker setDate:initDate animated:YES];
    }
    [self dateChange:datePicker];
     //Add the picker to the view
     [self.view.superview addSubview:datePicker];
    if (!isShow) {
        [UIView animateWithDuration:.666666666 animations:^{
            CGFloat sizeHeight = ((self.view.bounds.size.height)-(datePicker.frame.size.height));
            [datePicker setFrame:CGRectMake(0,sizeHeight,datePicker.frame.size.width,datePicker.frame.size.height)];
            isShow = YES;
        }];
    }
    
}

-(void)dateChange:(UIDatePicker *)__datePicker{
    NSLog(@"date change to %@ : %@",[dateFormatter stringFromDate:__datePicker.date],[dateFormatDisplay stringFromDate:__datePicker.date]);
        if (__datePicker.tag == 0) {
            _plugins[DMCBeginDate] = [dateFormatter stringFromDate:datePicker.date];
        }else{
            _plugins[DMCEndDate] = [dateFormatter stringFromDate:datePicker.date];
        }
    
    if (_plugins[DMCBeginDate]) {
        [_beginDateLabel setText:[self textFromDateString:_plugins[DMCBeginDate]]];
    }
    
    if (_plugins[DMCEndDate]) {
        [_endDateLabel setText:[self textFromDateString:_plugins[DMCEndDate]]];
    }

}



-(NSString *)textFromDateString:(NSString *)date{
    return [[dateFormatDisplay stringFromDate:[dateFormatter dateFromString:date]] copy];
}

@end
