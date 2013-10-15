//
//  DMContentCreator.h
//  DMContentCreator
//
//  Created by Trash on 9/17/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BVReorderTableView/BVReorderTableView.h>
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
@property (nonatomic,strong) NSString *productTempName;
@end


@interface DMContentCreator : UITableViewController<ReorderTableViewDelegate>
@property (nonatomic,strong) NSNumber *featureIdentifier;
@property (nonatomic,strong) NSArray *defaultPlugins,*avaliablePlugins,*sampleLayoutPlugins;
@property (nonatomic,strong) NSURL *baseURL;
@property (nonatomic,copy)   id handler;
@property (nonatomic,strong) UIColor *color ;
@property (nonatomic,assign) BOOL invertedNavigation;
@property (nonatomic,assign) DMContentCreatorBackgroundMode themeMode;
@property (nonatomic,strong) NSString *file,*oauth;
@property (nonatomic,weak) NSArray *tagsList;
+(instancetype)contentCreatorForIPhoneDevice;
+(DMContentCreatorComponents *)sharedComponents;
+(NSString *)generateImageFileFromPath:(NSString *)path extension:(NSString *)extension;
+(NSArray *)fileListForFeautreIdentifier:(NSUInteger)featureIdentifier;
+(BOOL)deleteSaveName:(NSString *)fileToDelete featureIdentifier:(NSUInteger)featureIdentifier;
+(UIImage *)backImage;
-(BOOL)isSaved;
@end

