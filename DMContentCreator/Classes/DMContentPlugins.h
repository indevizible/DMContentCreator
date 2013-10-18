//
//  DMContentPlugins.h
//  DMContentCreator
//
//  Created by Trash on 9/26/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DMCCTagSystemrKey @"tagsystem"
#define DMCCTagUserKey @"taguser"
#define DMCCProductNameKey @"title"
#define DMCCDetailsKey @"description"
#define DMCCImageThumbnail @"photomain"
#define DMCCPublic @"status"
#define DMCCImage @"photomain"
#define DMCCText  @"text"
#define DMCCVideo @"embed"
#define DMCRegularPrice @"price"
#define DMCSalePrice @"saleprice"
#define DMCCurrency  @"curid"
#define DMCBeginDate @"startdate"
#define DMCEndDate @"enddate"
#define DMCGalleryImage1 @0
#define DMCGalleryImage2 @1
#define DMCGalleryImage3 @2
#define DMCGalleryImage4 @3
#define DMCGalleryPhoto @"photomain"
#define DMCCaption @"detail"
#define DMCMapLatitude @"lat"
#define DMCMapLongitude @"lng"

@interface DMContentPlugins : NSObject<NSCoding>
@property (nonatomic,strong) NSNumber *pluginIdentifier;
@property (nonatomic,strong) NSString *pluginName;
@property (nonatomic,assign) BOOL isStaticPlugin,isDataComplete;
@property (nonatomic,strong) UIImage *thumbnail;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) NSMutableDictionary *dataSource;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key NS_AVAILABLE(10_8, 6_0);
- (id)objectForKeyedSubscript:(id)key NS_AVAILABLE(10_8, 6_0);
- (void)removeObjectForKey:(id)aKey;
+(instancetype)pluginWithIdentifier:(NSUInteger)pluginIdentifier;
+(NSString *)imageNameForPluginIdentifier:(NSUInteger )__plugid;
-(NSMutableArray *)checkIncompleteLists;
-(NSMutableDictionary *)generatedDataWithPath:(NSString *)path;
@end
@protocol DMContentPluginProtocol
-(void)setPlugins:(DMContentPlugins *)plugins;
@optional
-(void)setSavePath:(NSString *)savePath;
@end