//
//  DMContentCreatorStyle.h
//  DMContentCreator
//
//  Created by Trash on 10/1/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMContentCreatorStyle : NSObject
+(UIBarButtonItem *)barButtonItemName:(NSString *)name handler:(void (^)( UIBarButtonItem *weakSender))handler;
+(UIBarButtonItem *)backButtonForNavigation:(UINavigationController *)nav;
+(UIBarButtonItem *)closeButtonWithHandler:(void(^)(UIBarButtonItem *weakSender))handler;

+(void)setNavigationBarStyle:(UINavigationController *)nav;
@end
