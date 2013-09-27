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
    UIColor *color;
}

@end

@implementation DMContentCreatorExampleViewController

-(id)init{
    self = [super initWithNibName:@"DMContentCreatorExampleViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    color =[UIColor iOS7lightBlueColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)light:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [viewController setColor:color];
    [viewController setThemeMode:DMContentCreatorBackgroundModeLight];
    [viewController setInvertedNavigation:NO];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)addProduct:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [viewController setColor:color];
    [viewController setThemeMode:DMContentCreatorBackgroundModeLight];
    [viewController setInvertedNavigation:YES];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)dark:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [viewController setColor:color];
    [viewController setThemeMode:DMContentCreatorBackgroundModeDark];
    [viewController setInvertedNavigation:NO];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (IBAction)invDark:(id)sender {
    DMContentCreator *viewController = [DMContentCreator contentCreatorForIPhoneDevice];
    [viewController setColor:color];
    [viewController setThemeMode:DMContentCreatorBackgroundModeDark];
    [viewController setInvertedNavigation:YES];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

@end
