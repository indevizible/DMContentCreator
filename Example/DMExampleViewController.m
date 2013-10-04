//
//  DMExampleViewController.m
//  DMContentCreator
//
//  Created by Trash on 9/30/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMExampleViewController.h"
#import "DMContentCreatorExampleViewController.h"
#import <iOS7Colors/UIColor+iOS7Colors.h>
@interface DMExampleViewController (){
    NSArray *dataSource;
}

@end

@implementation DMExampleViewController

-(id)init{
    self = [super initWithNibName:@"DMExampleViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    dataSource = @[
                   [UIColor iOS7redColor],
                   [UIColor iOS7orangeColor],
                   [UIColor iOS7yellowColor],
                   [UIColor iOS7greenColor],
                   [UIColor iOS7lightBlueColor],
                   [UIColor iOS7darkBlueColor],
                   [UIColor iOS7pinkColor],
                   [UIColor iOS7darkGrayColor],
                   [UIColor blackColor]];

    CGFloat hue,sat,brightness,alpha;
    [[UIColor iOS7redColor] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    [[UIColor iOS7orangeColor] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    [[UIColor iOS7yellowColor] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    [[UIColor iOS7greenColor] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    [[UIColor iOS7lightBlueColor] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    [[UIColor iOS7darkBlueColor] getHue:&hue saturation:&sat brightness:&brightness alpha:&alpha];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setBackgroundColor:dataSource[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DMContentCreatorExampleViewController *example = [DMContentCreatorExampleViewController new];
    [example setColor:dataSource[indexPath.row]];
    [self.navigationController pushViewController:example animated:YES];
}


@end
