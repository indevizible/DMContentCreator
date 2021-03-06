//
//  DMPluginPriceEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/2/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//
#import "DMContentCreator.h"
#import "DMPluginPriceEditor.h"
#import "DMContentCreatorStyle.h"
typedef enum {
    DMCCCurrencyTHB = 1,
    DMCCurrencyUSD = 2
}DMCCCurrencyIdentifier;
@interface DMPluginPriceEditor (){
    BOOL isDismissing;
    NSArray *currencyList;
    __weak IBOutlet UISegmentedControl *currencySelector;
}
@property (weak, nonatomic) IBOutlet UITextField *regularTextField;
@property (weak, nonatomic) IBOutlet UITextField *saleTextField;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (nonatomic,weak) DMContentPlugins *plugins;
@end

@implementation DMPluginPriceEditor

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
    currencyList = @[ @"T​HAI BAHT ( ฿ )", @"United States dollar ( $ )"];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    _regularTextField.textColor = _saleTextField.textColor = _currencyLabel.textColor = [[DMContentCreator sharedComponents] color];
    if (!_plugins[DMCCurrency]) {
        _plugins[DMCCurrency] = @1;
    }
    
    _regularTextField.text = _plugins[DMCRegularPrice];
    _saleTextField.text = _plugins[DMCSalePrice];
    
    self.title = _plugins.pluginName;
    [currencySelector setTintColor:[[DMContentCreator sharedComponents] color]];
    [currencySelector setSelectedSegmentIndex:[_plugins[DMCCurrency] unsignedIntegerValue]-1];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated ];
    
    _plugins[DMCRegularPrice] = _regularTextField.text;
    _plugins[DMCSalePrice] = _saleTextField.text;
    
    if ([_plugins[DMCRegularPrice] length] == 0) {
        [_plugins removeObjectForKey:DMCRegularPrice];
    }
    
    if ([_plugins[DMCSalePrice] length] == 0) {
        [_plugins removeObjectForKey:DMCSalePrice];
    }
    
    NSArray *list = [_plugins checkIncompleteLists];
    NSLog(@"%@",list);
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


//#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)whenCurrencyChange:(UISegmentedControl *)sender {
    _plugins[DMCCurrency] = @(sender.selectedSegmentIndex + 1);
}
@end
