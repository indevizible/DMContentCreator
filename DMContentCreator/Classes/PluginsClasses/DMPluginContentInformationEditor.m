//
//  DMPluginContentInformationEditor.m
//  DMContentCreator
//
//  Created by Trash on 9/27/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginContentInformationEditor.h"
#import "DMPluginContentInformationCategoriesSelector.h"
#import "DMPluginContentInformationTagsSelector.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <BlocksKit/BlocksKit.h>
#import <SIAlertView/SIAlertView.h>
#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import "DMContentCreator.h"
#import "DMContentCreatorStyle.h"
#import <UIImage-Resize/UIImage+Resize.h>

#define DMCCTagSystemrKey @"tagsystem"
#define DMCCTagUserKey @"taguser"
#define DMCCProductNameKey @"title"
#define DMCCDetailsKey @"description"
#define DMCCImageThumbnail @"photomain"

@interface DMPluginContentInformationEditor ()<UITextFieldDelegate>{
    BOOL isDismissing,isEdited;
    CZPhotoPickerController *photoPicker;
   
}
@property (nonatomic,weak) NSString *savePath;
@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UILabel *publicLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *systemTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTagLabel;
@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic, assign) NSInteger lastContentOffset;
@end


@implementation DMPluginContentInformationEditor

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_plugins[DMCCTagSystemrKey]) {
        _plugins[DMCCTagSystemrKey] = [NSMutableArray new];
    }
    if (!_plugins[DMCCTagUserKey]) {
        _plugins[DMCCTagUserKey] = [NSMutableArray new];
    }
    
    [_productNameTextField setText:_plugins[DMCCProductNameKey]];
    [_productNameTextField setTextColor:[[DMContentCreator sharedComponents] color]];
    
    [_detailsTextView setText:_plugins[DMCCDetailsKey]];
    [_detailsTextView setTextColor:[[DMContentCreator sharedComponents] color]];
    [self setTitle:_plugins.pluginName];
    [_userTagLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [_systemTagLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    UIImage *image = [UIImage imageGlyphNamed:@"fontawesome##picture" height:100.0 color:[UIColor iOS7lightGrayColor]];
    if (_plugins[DMCCImageThumbnail]) {
        [_thumbnailImage setContentMode:UIViewContentModeScaleAspectFill];
        [_thumbnailImage setImage:[NSKeyedUnarchiver unarchiveObjectWithFile:[self.savePath stringByAppendingPathComponent:_plugins[DMCCImageThumbnail]]]];
    }else{
        [_thumbnailImage setImage:image];
        [_thumbnailImage setContentMode:UIViewContentModeCenter];
    }
    [_thumbnailImage setClipsToBounds:YES];
    
    if (!_plugins[DMCCPublic]) {
        _plugins[DMCCPublic] = @1;
    }
    
    [_publicLabel setTextColor:[[DMContentCreator sharedComponents] color]];
    [_publicSwitch setOn:[_plugins[DMCCPublic] isEqualToNumber:@1]];
    [_publicSwitch setOnTintColor:[[DMContentCreator sharedComponents] color]];
    
    UIBarButtonItem *closeButton = [DMContentCreatorStyle barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.leftBarButtonItem = closeButton;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self gatherData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (fabs(velocity.y)>0.70f) {
        [self.view endEditing:YES];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        photoPicker = [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
            UIImage *img = imageInfoDict[UIImagePickerControllerEditedImage]?imageInfoDict[UIImagePickerControllerEditedImage]:imageInfoDict[UIImagePickerControllerOriginalImage];
            if (img) {
                UIImage *image = [img resizedImageToFitInSize:CGSizeMake(500.0f, 500.0f) scaleIfSmaller:NO];
                NSString *filename = [DMContentCreator generateImageFileFromPath:self.savePath extension:@"UIIMAGE"];
                [NSKeyedArchiver archiveRootObject:image toFile:[self.savePath stringByAppendingPathComponent:filename]];
                if (_plugins[DMCCImageThumbnail]) {
                    [[NSFileManager defaultManager] removeItemAtPath:[self.savePath stringByAppendingPathComponent:_plugins[DMCCImageThumbnail]] error:nil];
                }
                _plugins[DMCCImageThumbnail] = filename;
                [_thumbnailImage setImage:image];
                [_thumbnailImage setContentMode:UIViewContentModeScaleAspectFill];

            }
            [photoPicker dismissAnimated:YES];
        }];
        [photoPicker setAllowsEditing:YES];
        [photoPicker showFromRect:[[tableView cellForRowAtIndexPath:indexPath] frame]];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"categoriesSelector"]) {
        DMPluginContentInformationCategoriesSelector *vc = segue.destinationViewController;
        [vc setSelectedCategories:_plugins[DMCCTagSystemrKey]];
    }else if ([segue.identifier isEqualToString:@"tagsSelector"]){
        DMPluginContentInformationTagsSelector *vc = segue.destinationViewController;
        vc.userTagList = _plugins[DMCCTagUserKey];
    }
}

-(void)gatherData{
    _plugins[DMCCProductNameKey]= _productNameTextField.text;
    _plugins[DMCCDetailsKey] = _detailsTextView.text;
}

- (IBAction)switchPublicChange:(UISwitch *)sender {
    _plugins[DMCCPublic] = sender.on ? @1 : @2;
}

@end
