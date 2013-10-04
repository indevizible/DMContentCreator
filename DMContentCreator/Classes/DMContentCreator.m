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
#import "DMPluginContentInformationEditor.h"
#import "DMContentCreatorStyle.h"

@interface DMContentCreator ()<RNGridMenuDelegate>{
    NSString *resourcesBundle;
    Class navigationClass;
    NSMutableArray *dataSource;
    UIStoryboard *mainStoryboard;
    UIStatusBarStyle backupStatusBarStyle;
//    UIColor *backupWindowsTintColor;
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
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    [[DMContentCreator sharedComponents] setTagsList:self.tagsList];
    
    [self.tableView setBackgroundColor:[[DMContentCreator sharedComponents] themeColor]];

    
#warning mocked up data
    _defaultPlugins = @[@0,@1,@3,@4,@5,@6,@7,@8,@10,@11,@13,@14];
    _avaliablePlugins = @[];
    
    dataSource = [NSMutableArray new];
    
    
    for (int i= 0; i< [_defaultPlugins count]; i++) {
        [dataSource addObject:[DMContentPlugins pluginWithIdentifier:[_defaultPlugins[i] unsignedIntegerValue] color:_color]];
    }
    
#warning end mocked up data
   
    if (!self.navigationController || [[self.navigationController viewControllers] count] == 1) {
        UIBarButtonItem *closeButton = [DMContentCreatorStyle barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
             [self restoreValue];
            [self dismissViewControllerAnimated:YES completion:^{
               
            }];
        }];
        self.navigationItem.leftBarButtonItem = closeButton;
    }
    
    UIBarButtonItem *taskButton = [DMContentCreatorStyle barButtonItemName:@"fontawesome##tasks" handler:^(id sender){
        [self showMenu];
    }];
    self.navigationItem.rightBarButtonItem = taskButton;
   self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateStatusBar];
    
    self.navigationController.navigationBar.translucent = YES;
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    [self.tableView reloadData];
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
    NSString *storyboardIdentifier =[NSString stringWithFormat:@"DMEPLG%02u",plugin.pluginIdentifier.unsignedIntegerValue];
    if ([self storyboardName:@"iPhone-DMContentCreator" hasStoryboardIdentifier:storyboardIdentifier]) {
        [cell.pluginTitleLabel setText:plugin.pluginName];
    }else{
        [cell.pluginTitleLabel setText:NSLocalizedString(@"DMCUNDEFINEDPLUGIN", @"Undefined plugin")];
    }
    
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
    NSString *storyboardIdentifier =[NSString stringWithFormat:@"DMEPLG%02u",plugin.pluginIdentifier.unsignedIntegerValue];
    if ([self storyboardName:@"iPhone-DMContentCreator" hasStoryboardIdentifier:storyboardIdentifier]) {
        UIViewController<DMContentPluginProtocol> *editView = [self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
        [editView setPlugins:plugin];
        UINavigationController *nav = [[[navigationClass class] alloc] initWithRootViewController:editView];
        [self presentViewController:nav animated:YES completion:nil];

    }
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

+(DMContentCreatorComponents *)sharedComponents{
    static dispatch_once_t onceToken;
    static DMContentCreatorComponents *sharedComponents = nil;
    dispatch_once(&onceToken, ^{
        sharedComponents = [DMContentCreatorComponents new];
        sharedComponents.color = [UIColor iOS7lightBlueColor];
        sharedComponents.navigationClass = [UINavigationController class];
    });
    return sharedComponents;
}



-(void)updateStatusBar{
    backupStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
//    backupWindowsTintColor = [self.view.window tintColor];
    BOOL isDarkMode = ([[DMContentCreator sharedComponents] themeMode] == DMContentCreatorBackgroundModeDark);
    [[UIApplication sharedApplication] setStatusBarStyle:(([[DMContentCreator sharedComponents] invertedNavigation] && isDarkMode)||(!([[DMContentCreator sharedComponents] invertedNavigation] || isDarkMode)) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault) animated:YES];
//    [self.view.window setTintColor:[[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] color]:[[DMContentCreator sharedComponents] themeColor]];
    
}

-(void)restoreValue{
    [[UIApplication sharedApplication] setStatusBarStyle:backupStatusBarStyle animated:YES];
//    [self.view.window setTintColor:backupWindowsTintColor];
}


+(UIImage *)backImage{
    return [UIImage imageGlyphNamed:@"fontawesome#angle-left" size:CGSizeMake(25, 25) color:([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] color] : [[DMContentCreator sharedComponents] themeColor])];
}

-(BOOL)storyboardName:(NSString *)storyboardName hasStoryboardIdentifier:(NSString *)storyboardIdentifier{
    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] pathForResource:storyboardName ofType:@"storyboardc"] error:nil];
    for (NSString *file in list) {
        NSString *fileName = [file componentsSeparatedByString:@"."][0];
        if ([fileName isEqualToString:storyboardIdentifier]) {
            return YES;
        }
    }
    return NO;
}
@end

@implementation DMContentCreatorComponents
@end