//
//  DMContentCreator.h
//  DMContentCreator
//
//  Created by Trash on 9/17/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^successBlock)(id productid);

@interface DMContentCreator : UITableViewController
@property (nonatomic,strong) id featureIdentifier;
@property (nonatomic,strong) NSArray *defaultPlugins,*avaliablePlugins;
@property (nonatomic,strong) NSURL *clientURL;
@property (nonatomic,copy) id handler;
@property (nonatomic,strong) UIColor *color;

+(instancetype)contentCreatorForIPhoneDevice;
@end
