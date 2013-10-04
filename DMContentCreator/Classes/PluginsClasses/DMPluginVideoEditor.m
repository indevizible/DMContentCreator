//
//  DMPluginVideoEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/2/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginVideoEditor.h"
#import "DMContentCreatorStyle.h"
#import <BlocksKit/BlocksKit.h>
#import <AFNetworking/AFNetworking.h>
#import <HCYoutubeParser/HCYoutubeParser.h>
@interface DMPluginVideoEditor ()<UIAlertViewDelegate>{
    BOOL isDismissing;
}
@property (weak, nonatomic) IBOutlet UIImageView *videoThubnailView;
@property (nonatomic,weak) DMContentPlugins *plugins;
@end

@implementation DMPluginVideoEditor

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

    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.rightBarButtonItem = [DMContentCreatorStyle barButtonItemName:@"fontawesome##plus-sign" handler:^(UIBarButtonItem *weakSender) {
        [self openEditOption];
    }];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.title = _plugins.pluginName;
    
    if (_plugins[DMCCVideo]) {
        [_videoThubnailView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",_plugins[DMCCVideo]]]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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


#pragma mark - Table View delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self openEditOption];
}

#pragma mark - String Anlysis
-(void)openEditOption{
    UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:@"Youtube™ ID/URL"];
    [actionSheet addButtonWithTitle:@"Paste from Clipboard" handler:^{
        [self setFromUndefinedString:[[UIPasteboard generalPasteboard] string]];
    }];
    [actionSheet addButtonWithTitle:@"Edit" handler:^{
        __block UIAlertView *blockAlert;
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"Youtube™ ID/URL"];
        [alertView setMessage:@"Enter Youtube™ ID/URL below."];
        blockAlert = alertView;
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView setCancelButtonWithTitle:@"Cancel" handler:nil];
        [alertView addButtonWithTitle:@"OK" handler:^{
            [self setFromUndefinedString:[[blockAlert textFieldAtIndex:0] text]];
        }];
        [alertView show];
        if (_plugins[DMCCVideo]) {
            [[alertView textFieldAtIndex:0] setText:_plugins[DMCCVideo]];
        }
    }];
    [actionSheet setCancelButtonWithTitle:@"Cancel" handler:nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

-(void)setFromUndefinedString:(NSString *)string{
    NSURL *tmpURL = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL:tmpURL]) {
        NSString *ytid = [HCYoutubeParser youtubeIDFromYoutubeURL:tmpURL];
        if (ytid) {
            _plugins[DMCCVideo] = ytid;
            [_videoThubnailView setImage:nil];
            [_videoThubnailView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",_plugins[DMCCVideo]]]];
        }else{
            UIAlertView *alert = [UIAlertView alertViewWithTitle:@"Warning" message:@"Invalid Youtube URL"];
            [alert setCancelButtonWithTitle:@"OK" handler:nil];
            [alert show];
        }
    }else{
        _plugins[DMCCVideo] = string;
        [_videoThubnailView setImage:nil];
        [_videoThubnailView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",_plugins[DMCCVideo]]]];
    }
}
@end
