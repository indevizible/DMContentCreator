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
@interface DMContentCreator ()

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

    if (!_color) {
        [self setColor:[UIColor iOS7darkBlueColor]];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item-background-gray.png"]];
    [cell setBackgroundView:backgroundView];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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

+(instancetype)contentCreatorForIPhoneDevice{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone-DMContentCreator" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"CTCAT"];
}

-(instancetype)instance{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"iPhone-DMContentCreator" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"CTCAT"];
}
@end
