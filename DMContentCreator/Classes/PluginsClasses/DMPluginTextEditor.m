//
//  DMPluginTextEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/1/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginTextEditor.h"
#import "DMContentCreator.h"
#import "DMContentCreatorStyle.h"
@interface DMPluginTextEditor (){
    BOOL isDismissing;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,weak) DMContentPlugins *plugins;
@end

@implementation DMPluginTextEditor

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
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    [self.textView setText:_plugins[DMCCText]];
    [self.textView setTextColor:[[DMContentCreator sharedComponents] color]];
    self.title = _plugins.pluginName;
    [_textView becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_textView.text length]) {
        _plugins[DMCCText] = _textView.text;
    }else{
        [_plugins removeObjectForKey:DMCCText];
    }
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


@end
