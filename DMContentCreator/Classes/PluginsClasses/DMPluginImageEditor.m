//
//  DMPluginImageEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/1/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginImageEditor.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <BlocksKit/BlocksKit.h>
#import <SIAlertView/SIAlertView.h>
#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import "DMContentCreator.h"
#import <UIImage-Resize/UIImage+Resize.h>
#import "DMContentCreatorStyle.h"

@interface DMPluginImageEditor (){
    BOOL isDismissing;
    CZPhotoPickerController *photoPicker;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) DMContentPlugins *plugins;
@end

@implementation DMPluginImageEditor

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
    [self setTitle:_plugins.pluginName];
    UIImage *image = [UIImage imageGlyphNamed:@"fontawesome##picture" height:100.0 color:[UIColor iOS7lightGrayColor]];
    if (_plugins[DMCCImage]) {
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setImage:_plugins[DMCCImage]];
    }else{
        [_imageView setImage:image];
        [_imageView setContentMode:UIViewContentModeCenter];
    }
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_plugins checkIncompleteLists];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    photoPicker = [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        UIImage *img = imageInfoDict[UIImagePickerControllerEditedImage];
        if (img) {
            _plugins[DMCCImage] =[img resizedImageToFitInSize:CGSizeMake(640.0f, 640.0f) scaleIfSmaller:NO];
            [_imageView setImage:_plugins[DMCCImage]];
            [_imageView setContentMode:UIViewContentModeScaleAspectFit];

        }
        [photoPicker dismissAnimated:YES];
    }];
    [photoPicker showFromRect:[[tableView cellForRowAtIndexPath:indexPath] frame]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setPlugins:(DMContentPlugins *)plugins{
    _plugins = plugins;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.contentOffset.y < -170.0f && !isDismissing) {
        isDismissing = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
