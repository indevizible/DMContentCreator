//
//  DMPluginContentInformationCategoriesSelector.m
//  DMContentCreator
//
//  Created by Trash on 9/30/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginContentInformationCategoriesSelector.h"
#import "DMContentCreator.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <iOS7Colors/UIColor+iOS7Colors.h>
@interface DMPluginContentInformationCategoriesSelector (){
    UIImage *checkedImage,*uncheckedImage;
}

@end

@implementation DMPluginContentInformationCategoriesSelector

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

    checkedImage =[UIImage imageGlyphNamed:@"fontawesome##ok-sign" height:32.0f color:[[DMContentCreator sharedComponents] color]];
    uncheckedImage  = [UIImage imageGlyphNamed:@"fontawesome##ok-circle" height:32.0f color:[UIColor iOS7lightGrayColor]];
    [self.navigationController.navigationBar setTintColor:[[DMContentCreator sharedComponents] themeColor]];
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
    return [[[DMContentCreator sharedComponents] tagsList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL checked = NO;
    for (NSNumber *tagid in _selectedCategories) {
        if ([tagid isEqualToNumber:[[[[DMContentCreator sharedComponents] tagsList] objectAtIndex:indexPath.row] valueForKey:@"tagid"]]) {
            checked = YES;
            break;
        }
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.textLabel setText:[[[[DMContentCreator sharedComponents] tagsList] objectAtIndex:indexPath.row] valueForKey:@"name"]];
    [cell.textLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    
    if ([cell.accessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *__imageView = (UIImageView *)cell.accessoryView;
        [__imageView setImage:(checked? checkedImage:uncheckedImage)];
    }else{
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:(checked? checkedImage:uncheckedImage)]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL checked = NO;
    NSUInteger index = 0;
    NSNumber *selectedTagIdentifier = [[[[DMContentCreator sharedComponents] tagsList] objectAtIndex:indexPath.row] valueForKey:@"tagid"];
    for (NSNumber *tagid in _selectedCategories) {
        index++;
        if ([tagid isEqualToNumber:selectedTagIdentifier]) {
            checked = YES;
            selectedTagIdentifier = tagid;
            break;
        }
    }
    if (checked) {
        [_selectedCategories removeObjectAtIndex:index-1];
    }else{
        [_selectedCategories addObject:selectedTagIdentifier];
    }
    checked = !checked;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.accessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *__imageView = (UIImageView *)cell.accessoryView;
        [__imageView setImage:(checked? checkedImage:uncheckedImage)];
    }else{
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:(checked? checkedImage:uncheckedImage)]];
    }
}
@end
