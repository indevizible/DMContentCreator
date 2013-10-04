//
//  DMContentCreatorStyle.m
//  DMContentCreator
//
//  Created by Trash on 10/1/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMContentCreatorStyle.h"
#import "DMContentCreator.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <BlocksKit/BlocksKit.h>
#import <LAUtilitiesStaticLib/LAUtilitiesStaticLib.h>
@implementation DMContentCreatorStyle
+(UIBarButtonItem *)backButtonForNavigation:(UINavigationController *)nav{
    if ([[nav viewControllers] count] > 1) {
        return [DMContentCreatorStyle barButtonItemName:@"fontawesome##angle-left" handler:^(UIBarButtonItem *weakSender) {
            [nav popViewControllerAnimated:YES];
        }];
    }
    return nil;
}

+(UIBarButtonItem *)closeButtonWithHandler:(void(^)(UIBarButtonItem *weakSender))handler{
    return [DMContentCreatorStyle barButtonItemName:@"fontawesome##angle-down" handler:handler];
}

+(UIBarButtonItem *)barButtonItemName:(NSString *)name handler:(void (^)( UIBarButtonItem *weakSender))handler{
    UIImage *image =[UIImage imageGlyphNamed:name size:CGSizeMake(25, 25) color:([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] color] : [[DMContentCreator sharedComponents] themeColor])];
    UIButton *toggleNoti = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width , image.size.height)];
    [toggleNoti setImage:image forState:UIControlStateNormal];
    [toggleNoti setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *weakSender = [[UIBarButtonItem alloc] initWithCustomView:toggleNoti];
    [toggleNoti whenTapped:^{
        handler(weakSender);
    }];
    return weakSender;
}
+(void)setNavigationBarStyle:(UINavigationController *)nav{
    nav.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : ([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] color]:[[DMContentCreator sharedComponents] themeColor]),UITextAttributeTextShadowColor:[UIColor clearColor]};
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        nav.navigationBar.translucent = ([[DMContentCreator sharedComponents] themeMode] == DMContentCreatorBackgroundModeLight);
        nav.navigationBar.barTintColor = [[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] themeColor] : [[DMContentCreator sharedComponents] color];
        
    }else{
        UIImage *image = [UIImage imageFromColor:([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] themeColor] : [[DMContentCreator sharedComponents] color]) frame:nav.navigationBar.bounds];
        [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        
    }
    
}
@end
