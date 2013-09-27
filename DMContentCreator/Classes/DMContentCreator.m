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
@interface DMContentCreator ()<RNGridMenuDelegate>{
    NSString *resourcesBundle;
    
    NSMutableArray *dataSource;
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
    
#warning mocked up data
    _defaultPlugins = @[];
    _avaliablePlugins = @[];
    
#warning end mocked up data
    
    dataSource = [NSMutableArray new];
    if (!_color) {
        [self setColor:[UIColor iOS7orangeColor]];
    }
    for (int i= 0; i<10; i++) {
        [dataSource addObject:[DMContentPlugins pluginWithIdentifier:0 color:_color]];
    }
    
    
    
    if (!self.navigationController || [[self.navigationController viewControllers] count] == 1) {
        UIBarButtonItem *closeButton = [self barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"CLOSE");
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMContentPlugins *plugin = dataSource[indexPath.row];
    [plugin setIsDataComplete:![plugin isDataComplete]];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(UIBarButtonItem *)barButtonItemName:(NSString *)name handler:(void (^)( UIBarButtonItem *weakSender))handler{
    UIImage *image =[UIImage imageGlyphNamed:name size:CGSizeMake(25, 25) color:_color];
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
    RNGridMenuItem *item = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:@"fontawesome##star" height:128 color:_color] title:@"Menu" action:^{
        
    }];
    NSMutableArray *mar = [NSMutableArray new];
    for (int i=0;i<9; i++) {
        [mar addObject:item];
    }
    
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:mar];
    [gridMenu setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
    [gridMenu setItemTextColor:[UIColor iOS7darkGrayColor]];
    [gridMenu setHighlightColor:[_color colorWithAlphaComponent:0.3]];
    [gridMenu showInViewController:self center:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
}

+(instancetype)contentCreatorForIPhoneDevice{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone-DMContentCreator" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"CTCAT"];
}

-(instancetype)instance{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone-DMContentCreator" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"CTCAT"];
}
@end
