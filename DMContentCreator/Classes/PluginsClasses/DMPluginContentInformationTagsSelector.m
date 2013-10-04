//
//  DMPluginContentInformationTagsSelector.m
//  DMContentCreator
//
//  Created by Trash on 9/30/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginContentInformationTagsSelector.h"
#import "DMContentCreator.h"

@interface DMPluginContentInformationTagsSelector ()<UITextViewDelegate>{
    NSUInteger countChange;
}

@property (strong, nonatomic) IBOutlet UITextView *tagView;

@end

@implementation DMPluginContentInformationTagsSelector


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"_user : %@",_userTagList);
    [_tagView setText:[@"#" stringByAppendingString:[_userTagList componentsJoinedByString:@" #"]]];
    [_tagView setTextColor:[[DMContentCreator sharedComponents] color]];
    [self.navigationController.navigationBar setTintColor:[[DMContentCreator sharedComponents] themeColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_tagView becomeFirstResponder];
}

- (IBAction)adfsadfs:(id)sender {
    
}

-(void)textViewDidChange:(UITextView *)textView{
    [self.userTagList removeAllObjects];
    NSArray *arrSeparated   = [[textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""]  componentsSeparatedByString:@"#"];
    for (NSString *str in arrSeparated) {
        if ([str length]) {
            [self.userTagList addObject:[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]) {
        [self refreshTextView];
    }
    return YES;
}

-(void)refreshTextView{
    [_tagView setText:[@"#" stringByAppendingString:[_userTagList componentsJoinedByString:@" #"]]];
    [_tagView setTextColor:[[DMContentCreator sharedComponents] color]];
    [_tagView becomeFirstResponder];
}
@end
