//
//  DMPluginContentInformationEditor.m
//  DMContentCreator
//
//  Created by Trash on 9/27/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginContentInformationEditor.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <BlocksKit/BlocksKit.h>
#import "DMContentCreator.h"
typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;
@interface DMPluginContentInformationEditor ()<UITextFieldDelegate>{
    ScrollDirection scrollDirection;
    BOOL isDismissing,isEdited;
}
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *systemTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTagLabel;
@property (nonatomic, assign) NSInteger lastContentOffset;
@end


@implementation DMPluginContentInformationEditor

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
    
    if (!_plugins) {
        _plugins = [DMContentPlugins pluginWithIdentifier:0 color:[UIColor iOS7lightBlueColor]];
    }
    [self setTitle:_plugins.pluginName];
    [_userTagLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [_systemTagLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [DMContentCreator setNavigationBarStyle:self.navigationController];
    UIImage *image = [UIImage imageGlyphNamed:@"fontawesome##picture" height:100.0 color:[UIColor iOS7lightGrayColor]];
    [_thumbnailImage setImage:image];
    
    UIBarButtonItem *closeButton = [DMContentCreator barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIBarButtonItem *saveButton = [DMContentCreator barButtonItemName:@"fontawesome##ok-sign" handler:^(id sender){
        
    }];
    self.navigationItem.rightBarButtonItem = saveButton;
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (fabs(velocity.y)>0.70f) {
        [self.view endEditing:YES];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"change : %@",string);
    return YES;
}
@end
