//
//  DMPluginGalleryEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/3/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginGalleryEditor.h"
#import "DMContentCreatorStyle.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <BlocksKit/BlocksKit.h>
#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import <UIImage-Resize/UIImage+Resize.h>
#define DMCGalleryImage(index) @[DMCGalleryImage1,DMCGalleryImage2,DMCGalleryImage3,DMCGalleryImage4][index]
@interface DMPluginGalleryEditor (){
    BOOL isDismissing;
    NSArray *pluginData;
    UIImage *tmpImage;
    NSArray *imageViewList,*captionList;
    CZPhotoPickerController *photoPicker;
}
@property (nonatomic,weak) DMContentPlugins *plugins;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UITextField *caption1;
@property (weak, nonatomic) IBOutlet UITextField *caption2;
@property (weak, nonatomic) IBOutlet UITextField *caption3;
@property (weak, nonatomic) IBOutlet UITextField *caption4;

@end
@implementation DMPluginGalleryEditor


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        [self prepareData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.title =  _plugins.pluginName;
    tmpImage = [UIImage imageGlyphNamed:@"fontawesome##picture" height:100.0 color:[UIColor iOS7lightGrayColor]];
    //setDefaultImage
    [_imageView1 setImage:tmpImage];
    [_imageView2 setImage:tmpImage];
    [_imageView3 setImage:tmpImage];
    [_imageView4 setImage:tmpImage];
    
    imageViewList = @[_imageView1,_imageView2,_imageView3,_imageView4];
    captionList = @[_caption1,_caption2,_caption3,_caption4];
    for (int i=0; i<4; i++) {
        if (!_plugins[DMCGalleryImage(i)]) {
            _plugins[DMCGalleryImage(i)] = [NSMutableDictionary new];
        }
        [self setImageForIndex:i withCaption:YES];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.contentOffset.y < -170.0f && !isDismissing) {
        isDismissing = YES;
        [self prepareData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_plugins[DMCGalleryImage(indexPath.section)][DMCGalleryPhoto]) {
        UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:nil];
        [actionSheet addButtonWithTitle:@"Remove image" handler:^{
            [_plugins[DMCGalleryImage(indexPath.section)] removeObjectForKey:DMCGalleryPhoto];
            [self setImageForIndex:indexPath.section withCaption:NO];
        }];
        [actionSheet addButtonWithTitle:@"Replace image" handler:^{
            [self setImageWithIndex:indexPath.section];
        }];
        [actionSheet setCancelButtonWithTitle:@"Cancel" handler:nil];
        [actionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
    }else{
        [self setImageWithIndex:indexPath.section];
    }
}

-(void)setImageWithIndex:(NSUInteger )index{
    photoPicker = [[CZPhotoPickerController alloc] initWithPresentingViewController:self withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        NSLog(@"image : %@",imageInfoDict);
        UIImage *img = imageInfoDict[UIImagePickerControllerEditedImage] ? imageInfoDict[UIImagePickerControllerEditedImage] : imageInfoDict[UIImagePickerControllerOriginalImage];
        if (img) {
            _plugins[DMCGalleryImage(index)][DMCGalleryPhoto] =[[img resizedImageToFitInSize:CGSizeMake(640.0f, 640.0f) scaleIfSmaller:NO] copy];
        }
        
        [self setImageForIndex:index withCaption:NO];
        [photoPicker dismissAnimated:YES];
    }];
    [photoPicker showFromBarButtonItem:self.navigationItem.leftBarButtonItem];
}

-(void)setImageForIndex:(NSUInteger )i withCaption:(BOOL)enableCaption{
    if (_plugins[DMCGalleryImage(i)][DMCGalleryPhoto]) {
        [[imageViewList objectAtIndex:i] setImage:_plugins[DMCGalleryImage(i)][DMCGalleryPhoto]];
        [[imageViewList objectAtIndex:i] setContentMode:UIViewContentModeScaleAspectFill];
        if (enableCaption) {
             [[captionList objectAtIndex:i] setText:_plugins[DMCGalleryImage(i)][DMCCaption]];
        }
    }else{
        [[imageViewList objectAtIndex:i] setImage:tmpImage];
        [[imageViewList objectAtIndex:i] setContentMode:UIViewContentModeCenter];
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (fabs(velocity.y)>0.70f) {
        [self.view endEditing:YES];
    }
}

-(void)prepareData{
    for (NSUInteger i=0; i<4; i++) {
        if ([[[captionList objectAtIndex:i] text] length] && _plugins[DMCGalleryImage(i)][DMCGalleryPhoto]) {
            _plugins[DMCGalleryImage(i)][DMCCaption] = [[captionList objectAtIndex:i] text];
        }else{
            [_plugins[DMCGalleryImage(i)] removeObjectForKey:DMCCaption];
        }
    }
    for (NSUInteger i = 0; i<4; i++) {
        if (_plugins[DMCGalleryImage(i)]) {
            if (_plugins[DMCGalleryImage(i)][DMCGalleryPhoto]) {
                continue;
            }
        }
        //find next
        for (NSUInteger j = i; j<4; j++) {
            if (_plugins[DMCGalleryImage(j)]) {
                if (_plugins[DMCGalleryImage(j)][DMCGalleryPhoto]) {
                    _plugins[DMCGalleryImage(i)] = _plugins[DMCGalleryImage(j)];
                    [_plugins removeObjectForKey:DMCGalleryImage(j)];
                    break;
                }
            }
        }
    }
    for (NSUInteger i = 0; i<4; i++) {
        if (![_plugins[DMCGalleryImage(i)] count]) {
            [_plugins removeObjectForKey:DMCGalleryImage(i)];
        }
    }
    NSLog(@"%@",_plugins.dataSource);
    [_plugins checkIncompleteLists];
}



@end
