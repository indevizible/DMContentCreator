//
//  DMContentCreator.h
//  DMContentCreator
//
//  Created by Trash on 9/17/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMContentPlugins.h"
typedef  enum {
    DMContentCreatorBackgroundModeLight,
    DMContentCreatorBackgroundModeDark,
}DMContentCreatorBackgroundMode;


typedef void(^successBlock)(id productid);

@interface DMContentCreatorComponents : NSObject
@property (nonatomic,strong) UIColor *color , *themeColor;
@property (nonatomic,assign) Class navigationClass;
@property (nonatomic,strong) UIStoryboard *storyboard;
@property (nonatomic,strong) NSString *resourceBundle;
@property (nonatomic,assign) DMContentCreatorBackgroundMode themeMode;
@property (nonatomic,assign) BOOL invertedNavigation;
@property (nonatomic,strong) NSArray *tagsList;
@end


@interface DMContentCreator : UITableViewController
@property (nonatomic,strong) id featureIdentifier;
@property (nonatomic,strong) NSArray *defaultPlugins,*avaliablePlugins;
@property (nonatomic,strong) NSURL *clientURL;
@property (nonatomic,copy)   id handler;
@property (nonatomic,strong) UIColor *color ;
@property (nonatomic,assign) BOOL invertedNavigation;
@property (nonatomic,assign) DMContentCreatorBackgroundMode themeMode;
@property (nonatomic,weak) NSArray *tagsList;
+(instancetype)contentCreatorForIPhoneDevice;
+(DMContentCreatorComponents *)sharedComponents;

+(UIImage *)backImage;
@end

