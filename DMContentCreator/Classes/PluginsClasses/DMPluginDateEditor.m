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
#import <BSModalPickerView/BSModalDatePickerView.h>
@interface DMPluginDateEditor (){
    BOOL isDismissing;
    NSCalendar *defaultCalendar;
    NSDateFormatter *dateFormatter,*dateFormatDisplay;
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
    defaultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_beginDateLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [_endDateLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.title = _plugins.pluginName;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:defaultCalendar];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    dateFormatDisplay = [[NSDateFormatter alloc] init];
    [dateFormatDisplay setCalendar:[NSCalendar currentCalendar]];
    [dateFormatDisplay setDateFormat:@"dd MMM yyyy"];
    
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
    NSDate *initDate = [NSDate new];
    if (indexPath.section == 0 && _plugins[DMCBeginDate]) {
        initDate = [dateFormatter dateFromString:_plugins[DMCBeginDate]];
    }else if (_plugins[DMCEndDate]) {
        initDate = [dateFormatter dateFromString:_plugins[DMCEndDate]];
    }
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:initDate];
    [datePicker setTintColor:[[DMContentCreator sharedComponents] color]];
    [datePicker presentInView:self.view withBlock:^(BOOL madeChoice) {
        if (madeChoice) {
            if (indexPath.section == 0) {
                _plugins[DMCBeginDate] = [dateFormatter stringFromDate:datePicker.selectedDate];
            }else{
                _plugins[DMCEndDate] = [dateFormatter stringFromDate:datePicker.selectedDate];
            }
        }
        if (_plugins[DMCBeginDate]) {
            [_beginDateLabel setText:[self textFromDateString:_plugins[DMCBeginDate]]];
        }
        
        if (_plugins[DMCEndDate]) {
            [_endDateLabel setText:[self textFromDateString:_plugins[DMCEndDate]]];
        }
    }];
    [datePicker.toolbar setBarStyle:UIBarStyleDefault];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)textFromDateString:(NSString *)date{
    return [[dateFormatDisplay stringFromDate:[dateFormatter dateFromString:date]] copy];
}

@end
