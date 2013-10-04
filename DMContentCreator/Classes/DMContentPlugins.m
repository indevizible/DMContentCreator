//
//  DMContentPlugins.m
//  DMContentCreator
//
//  Created by Trash on 9/26/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMContentPlugins.h"
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <WTGlyphFontSet/WTGlyphFontSet.h>
@interface DMContentPlugins()

@end

@implementation DMContentPlugins
+(instancetype)pluginWithIdentifier:(NSUInteger)pluginIdentifier color:(UIColor *)color{
    DMContentPlugins *_plugin = [DMContentPlugins new];
    _plugin.pluginIdentifier = @(pluginIdentifier);
    _plugin.color = color;
    NSString *localizedPluginName = [NSString stringWithFormat:@"DMCONTENTPLUGIN-%u",pluginIdentifier];
    _plugin.pluginName = NSLocalizedString(localizedPluginName, @"Use your local name by localizable.string");
    _plugin.thumbnail = [DMContentPlugins imageForPlugin:_plugin];
    return _plugin;
}

+(UIImage *)imageForPlugin:(DMContentPlugins *)plugin{
    switch ([[plugin pluginIdentifier] unsignedIntegerValue]) {
        case 0:
            return [UIImage imageGlyphNamed:@"fontawesome##info-sign" size:CGSizeMake(50, 50) color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        case 3:
            return  [UIImage imageGlyphNamed:@"fontawesome##th-large" height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        case 14:
        case 4:
            return [UIImage imageGlyphNamed:@"fontawesome##picture" height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        case 6:
            return [UIImage imageGlyphNamed:@"fontawesome##money" height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        case 7:
            return [UIImage imageGlyphNamed:@"fontawesome##calendar" height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        case 8:
            return [UIImage imageGlyphNamed:@"fontawesome##font" height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        case 10:
            return [UIImage imageGlyphNamed:@"fontawesome##play-sign" height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
            break;
        default:
            return [UIImage imageGlyphNamed:@"fontawesome##question-sign" height:50.0f color: [UIColor iOS7lightGrayColor]];
            break;
    }
    return nil;
}

-(void)setIsDataComplete:(BOOL)isDataComplete{
    _isDataComplete = isDataComplete;
    _thumbnail = [DMContentPlugins imageForPlugin:self];
}
-(NSMutableDictionary *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableDictionary new];
    }
    return _dataSource;
}

-(void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key{
    self.dataSource[key] = obj;
}

-(id)objectForKeyedSubscript:(id)key{
    return self.dataSource[key];
}

-(NSMutableArray *)checkIncompleteLists{
    NSDictionary *fieldNameDict = nil;
    NSArray *requiredField;
    switch ([_pluginIdentifier unsignedIntegerValue]) {
        case 0:
            fieldNameDict = @{
                              DMCCProductNameKey:NSLocalizedString(@"DMCCProductNameKey", @"Product name , title of product"),
                              DMCCDetailsKey:NSLocalizedString(@"DMCCDetailsKey", @"Product description, details"),
                              DMCCImageThumbnail:NSLocalizedString(@"DMCCImageThumbnail", @"Thumbnail image (square image)")
                              };
            requiredField = @[DMCCProductNameKey,DMCCImageThumbnail];
            break;
        case 14:
        case 4:
            fieldNameDict = @{DMCCImage: NSLocalizedString(@"DMCCImage", @"Regular Image")};
            requiredField = @[DMCCImage];
            break;
        case 6:
            fieldNameDict = @{DMCRegularPrice: NSLocalizedString(@"DMCRegularPrice", @"Regular price"),
                              DMCSalePrice:NSLocalizedString(@"DMCSalePrice", @"Sale price"),
                              DMCCurrency:NSLocalizedString(@"DMCCurrency", @"Currency")
                              };
            requiredField = @[DMCRegularPrice,DMCCurrency];
            break;
        case 7:
            fieldNameDict = @{DMCBeginDate: NSLocalizedString(@"DMCBeginDate", @"Begin date"),
                              DMCEndDate:NSLocalizedString(@"DMCEndDate", @"End date")};
            requiredField = @[DMCBeginDate,DMCEndDate];
            break;
        case 8:
            fieldNameDict = @{DMCCText: NSLocalizedString(@"DMCCText", @"Regular text")};
            requiredField = @[DMCCText];
            break;
        case 10:
            fieldNameDict = @{DMCCVideo: NSLocalizedString(@"DMCCVideo", @"Video (Youtube)")};
            requiredField = @[DMCCVideo];
        default:
            fieldNameDict =@{DMCGalleryImage1 : NSLocalizedString(@"DMCGalleryImage1", @"")};
            requiredField = @[DMCGalleryImage1];
            break;
    }
    

    NSMutableArray *incompleteFeild = [NSMutableArray new];
    for (id key in requiredField) {
        id data = self[key];
        if ([data isKindOfClass:[NSString class]]) {
            if ([data length]) {
                continue;
            }
        }else if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]){
            if ([data count]) {
                continue;
            }
        }else if ([data isKindOfClass:[UIImage class]] || [data isKindOfClass:[NSNumber class]]){
            continue;
        }
        [incompleteFeild addObject:key];
    }
    NSMutableArray *incompleteLists = [NSMutableArray new];
    for (NSString *key in incompleteFeild) {
        if (fieldNameDict[key]) {
            [incompleteLists addObject:fieldNameDict[key]];
        }else{
            [incompleteLists addObject:key];
        }
    }
    [self setIsDataComplete:[incompleteLists count] ? NO : YES];
    return incompleteLists;
}

-(void)removeObjectForKey:(id)aKey{
    [self.dataSource removeObjectForKey:aKey];
}
@end
