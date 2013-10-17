//
//  DMContentCreatorExampleViewController.m
//  DMContentCreator
//
//  Created by Trash on 9/27/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMContentCreatorExampleViewController.h"
#import "DMContentCreator.h"
#import <iOS7Colors/UIColor+iOS7Colors.h>
@interface DMContentCreatorExampleViewController (){
   
    NSArray *systemTags;
    CGFloat hue,bright,sat,alpha;
}
@property (weak, nonatomic) IBOutlet UIButton *btnLight;
@property (weak, nonatomic) IBOutlet UIButton *btnInvLight;
@property (weak, nonatomic) IBOutlet UIButton *btnDark;
@property (weak, nonatomic) IBOutlet UIButton *btnInvDark;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation DMContentCreatorExampleViewController
@synthesize color;
-(id)init{
    self = [super initWithNibName:@"DMContentCreatorExampleViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    color =[UIColor iOS7pinkColor];
    systemTags = @[@{@"tagid": @100,@"name":@"Apple"},
                   @{@"tagid": @101,@"name":@"Banana"},
                   @{@"tagid": @102,@"name":@"Blackcurrant"},
                   @{@"tagid": @103,@"name":@"Blueberry"},
                   @{@"tagid": @104,@"name":@"Coconut"},
                   @{@"tagid": @105,@"name":@"Cherry"},
                   @{@"tagid": @106,@"name":@"Grape"},
                   @{@"tagid": @107,@"name":@"Dragonfruit"},
                   @{@"tagid": @108,@"name":@"Grape"},
                   @{@"tagid": @109,@"name":@"Jackfruit"},
                   @{@"tagid": @110,@"name":@"Apricot"},
                   @{@"tagid": @111,@"name":@"Avocado"},
                   @{@"tagid": @112,@"name":@"Blackberry"},
                   @{@"tagid": @113,@"name":@"Guava"},
                   @{@"tagid": @114,@"name":@"Kiwi fruit"},
                   @{@"tagid": @115,@"name":@"Lemon"},
                   @{@"tagid": @116,@"name":@"Lime"},
                   @{@"tagid": @117,@"name":@"Loquat"},
                   @{@"tagid": @118,@"name":@"Lychee"},
                   @{@"tagid": @119,@"name":@"Cantaloupe"},
                   @{@"tagid": @121,@"name":@"Watermelon"},
                   @{@"tagid": @122,@"name":@"Orange"},
                   @{@"tagid": @123,@"name":@"Papaya"},
                   @{@"tagid": @124,@"name":@"Passionfruit"},
                   @{@"tagid": @125,@"name":@"Peach"},
                   @{@"tagid": @126,@"name":@"Pear"},
                   @{@"tagid": @127,@"name":@"Pineapple"},
                   @{@"tagid": @128,@"name":@"Pomelo"},
                   @{@"tagid": @129,@"name":@"Purple Mangosteen"},
                   @{@"tagid": @130,@"name":@"Raspberry"},
                   @{@"tagid": @131,@"name":@"Rambutan"},
                   @{@"tagid": @132,@"name":@"Redcurrant"},
                   @{@"tagid": @133,@"name":@"Star fruit"},
                   @{@"tagid": @134,@"name":@"Strawberry"},
                   @{@"tagid": @135,@"name":@"Tomato"},
                   ];
    [_btnLight setBackgroundColor:color];
    [_btnInvLight setTitleColor:color forState:UIControlStateNormal];
    [_btnDark setBackgroundColor:color];
    [_btnInvDark setTitleColor:color forState:UIControlStateNormal];
    self.title = @"Select Theme";
    [self.view setBackgroundColor:color];
    [color getHue:&hue saturation:&sat brightness:&bright alpha:&alpha];
    _slider.value = hue;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)light:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [self setVC:viewController];
    [viewController setThemeMode:DMContentCreatorBackgroundModeLight];
    [viewController setInvertedNavigation:NO];
    [viewController setTagsList:systemTags];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)addProduct:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [self setVC:viewController];
    [viewController setThemeMode:DMContentCreatorBackgroundModeLight];
    [viewController setInvertedNavigation:YES];
    [viewController setTagsList:systemTags];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)dark:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [self setVC:viewController];
    [viewController setThemeMode:DMContentCreatorBackgroundModeDark];
    [viewController setInvertedNavigation:NO];
    [viewController setTagsList:systemTags];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)invDark:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [self setVC:viewController];
    [viewController setThemeMode:DMContentCreatorBackgroundModeDark];
    [viewController setInvertedNavigation:YES];
    [viewController setTagsList:systemTags];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)progressDidChange:(UISlider *)sender {
    UIColor *___color = [UIColor colorWithHue:sender.value saturation:sat brightness:bright alpha:alpha];
    color = ___color;
    self.view.backgroundColor = color;
    [_btnLight setBackgroundColor:color];
    [_btnInvLight setTitleColor:color forState:UIControlStateNormal];
    [_btnDark setBackgroundColor:color];
    [_btnInvDark setTitleColor:color forState:UIControlStateNormal];
}

-(void)setVC:(DMContentCreator *)vc{
    [vc setFeatureIdentifier:@1];
    [vc setColor:color];
    [vc setBaseURL:[NSURL URLWithString:@"http://v19.dmconnex.com"]];
    [vc setOauth:@"8c2c4ad7dd9282daf513d345046fb826"];
    
    [vc setDefaultPlugins: @[@6,@7]];
    [vc setSampleLayoutPlugins:@[@14]];
    [vc setAvaliablePlugins:@[@3,@14,@5,@8,@17,@10]];
//    [vc setFile:@"รีีัันรีัััรรัพุรนนดด"];
//    [vc setDefaultPlugins: @[@6,@7]];
//    [vc setSampleLayoutPlugins:@[@4,@8,@3,@10]];
//    [vc setAvaliablePlugins:@[@4,@8,@3,@10,@14,@5]];
}

@end
