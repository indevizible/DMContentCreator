//
//  DMContentCreator.m
//  DMContentCreator
//
//  Created by Trash on 9/17/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMContentCreator.h"
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <BlocksKit/BlocksKit.h>
#import <RNGridMenu/RNGridMenu.h>
#import "DMContentPlugins.h"
#import "DMContentCreatorCell.h"
#import <LAUtilitiesStaticLib/LAUtilitiesStaticLib.h>

@interface DMContentCreator ()<RNGridMenuDelegate>{
    NSString *resourcesBundle;
    Class navigationClass;
    NSMutableArray *dataSource;
    UIStoryboard *mainStoryboard;

}

@end

@implementation DMContentCreator

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
    resourcesBundle = @"DMContentCreator.bundle";
    [[DMContentCreator sharedComponents] setResourceBundle:resourcesBundle];
    if (self.navigationController) {
        navigationClass = [self.navigationController class];
    }
    
    [[DMContentCreator sharedComponents] setColor:_color];
    [[DMContentCreator sharedComponents] setThemeColor:(_themeMode == DMContentCreatorBackgroundModeDark ? [UIColor blackColor] : [UIColor whiteColor])];
    [[DMContentCreator sharedComponents] setInvertedNavigation:_invertedNavigation];
    [[DMContentCreator sharedComponents] setThemeMode:_themeMode];
    [DMContentCreator setNavigationBarStyle:self.navigationController];
   
    
    [self.tableView setBackgroundColor:[[DMContentCreator sharedComponents] themeColor]];

    
#warning mocked up data
    _defaultPlugins = @[];
    _avaliablePlugins = @[];
    
    dataSource = [NSMutableArray new];
    
    
    for (int i= 0; i<10; i++) {
        [dataSource addObject:[DMContentPlugins pluginWithIdentifier:0 color:_color]];
    }
    
    
    
#warning end mocked up data
    
   
    if (!self.navigationController || [[self.navigationController viewControllers] count] == 1) {
        UIBarButtonItem *closeButton = [self barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        self.navigationItem.leftBarButtonItem = closeButton;
    }
    
    UIBarButtonItem *taskButton = [self barButtonItemName:@"fontawesome##tasks" handler:^(id sender){
        [self showMenu];
    }];
    self.navigationItem.rightBarButtonItem = taskButton;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMContentPlugins *plugin = dataSource[indexPath.row];
    DMContentCreatorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:[resourcesBundle stringByAppendingPathComponent:@"item-background-gray.png"]];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
    [cell.pluginTitleLabel setTextColor:_color];
    [cell.pluginTitleLabel setText:plugin.pluginName];
    [cell.pluginDetailsLabel setTextColor:[UIColor iOS7lightGrayColor]];
    [cell setBackgroundView:backgroundView];
    [cell.thumbnailView setImage:plugin.thumbnail];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    DMContentPlugins *plugin = dataSource[indexPath.row];
    [plugin setIsDataComplete:![plugin isDataComplete]];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    UIViewController *editView = [self.storyboard instantiateViewControllerWithIdentifier:@"DMEPLG00"];
    UINavigationController *nav = [[[navigationClass class] alloc] initWithRootViewController:editView];
    [self presentViewController:nav animated:YES completion:nil];
}

-(UIBarButtonItem *)barButtonItemName:(NSString *)name handler:(void (^)( UIBarButtonItem *weakSender))handler{
    UIImage *image =[UIImage imageGlyphNamed:name size:CGSizeMake(25, 25) color:(_invertedNavigation ? _color : [[DMContentCreator sharedComponents] themeColor])];
    UIButton *toggleNoti = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width , image.size.height)];
    [toggleNoti setImage:image forState:UIControlStateNormal];
    [toggleNoti setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *weakSender = [[UIBarButtonItem alloc] initWithCustomView:toggleNoti];
    [toggleNoti whenTapped:^{
        handler(weakSender);
    }];
    return weakSender;
}

-(void)showMenu{
    RNGridMenuItem *item = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:@"fontawesome##star" height:100 color: _color] title:@"LightContent" action:^{
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
    RNGridMenuItem *itemdar = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:@"fontawesome##star" height:100 color: _color] title:@"Default" action:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
    NSMutableArray *mar = [NSMutableArray new];
    for (int i=0;i<9; i++) {
        [mar addObject:(i%2? item : itemdar)];
    }
    
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:mar];
    [gridMenu setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
    [gridMenu setItemTextColor:[UIColor iOS7darkGrayColor]];
    [gridMenu setHighlightColor:[_color colorWithAlphaComponent:0.1]];
    [gridMenu showInViewController:self center:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
}

+(instancetype)contentCreatorForIPhoneDevice{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone-DMContentCreator" bundle:[NSBundle mainBundle]];
    return [storyBoard instantiateViewControllerWithIdentifier:@"CTCAT"];
}

+(DMContentCreatorCoponents *)sharedComponents{
    static dispatch_once_t onceToken;
    static DMContentCreatorCoponents *sharedComponents = nil;
    dispatch_once(&onceToken, ^{
        sharedComponents = [DMContentCreatorCoponents new];
        sharedComponents.color = [UIColor iOS7lightBlueColor];
        sharedComponents.navigationClass = [UINavigationController class];
    });
    return sharedComponents;
}

+(void)setNavigationBarStyle:(UINavigationController *)nav{
     nav.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : ([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] color]:[[DMContentCreator sharedComponents] themeColor]),UITextAttributeTextShadowColor:[UIColor clearColor]};
    
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
    nav.navigationBar.translucent = ([[DMContentCreator sharedComponents] themeMode] == DMContentCreatorBackgroundModeLight);
    BOOL isDarkMode = ([[DMContentCreator sharedComponents] themeMode] == DMContentCreatorBackgroundModeDark);
    [[UIApplication sharedApplication] setStatusBarStyle:(([[DMContentCreator sharedComponents] invertedNavigation] && isDarkMode)||(!([[DMContentCreator sharedComponents] invertedNavigation] || isDarkMode)) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault)];
    nav.navigationBar.barTintColor = [[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] themeColor] : [[DMContentCreator sharedComponents] color];

}else{
    UIImage *image = [UIImage imageFromColor:([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] themeColor] : [[DMContentCreator sharedComponents] color]) frame:nav.navigationBar.bounds];
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    

}
    
}
@end

@implementation DMContentCreatorCoponents
@end