//
//  DMContentPlugins.m
//  DMContentCreator
//
//  Created by Trash on 9/26/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMContentPlugins.h"
#import "DMContentCreator.h"
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <WTGlyphFontSet/WTGlyphFontSet.h>
@interface DMContentPlugins()

@end

@implementation DMContentPlugins
+(instancetype)pluginWithIdentifier:(NSUInteger)pluginIdentifier{
    DMContentPlugins *_plugin = [DMContentPlugins new];
    _plugin.pluginIdentifier = @(pluginIdentifier);
    _plugin.color = [[DMContentCreator sharedComponents] color];
    NSString *localizedPluginName = [NSString stringWithFormat:@"DMCONTENTPLUGIN-%u",pluginIdentifier];
    _plugin.pluginName = NSLocalizedString(localizedPluginName, @"Use your local name by localizable.string");
    _plugin.thumbnail = [DMContentPlugins imageForPlugin:_plugin];
    return _plugin;
}

+(UIImage *)imageForPlugin:(DMContentPlugins *)plugin{
    return [UIImage imageGlyphNamed:[DMContentPlugins imageNameForPluginIdentifier:[[plugin pluginIdentifier] unsignedIntegerValue]] height:50.0f color:([plugin isDataComplete] ? plugin.color: [UIColor iOS7lightGrayColor])];
}

+(NSString *)imageNameForPluginIdentifier:(NSUInteger )__plugid{
    switch (__plugid) {
        case 0:
            return @"fontawesome##info-sign";
            break;
        case 3:
            return @"fontawesome##th-large";
        case 4:
        case 14:
            return @"fontawesome##picture";
        case 5:
            return @"fontawesome##map-marker";
        case 6:
            return @"fontawesome##money";
        case 7:
            return @"fontawesome##calendar";
        case 8:
            return @"fontawesome##font";
        case 10:
            return @"fontawesome##play-sign";
        default:
            return @"fontawesome##question-sign";
            break;
    }
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

-(NSMutableDictionary *)generatedDataWithPath:(NSString *)path{
    NSMutableDictionary *ds = [NSMutableDictionary dictionaryWithDictionary:self.dataSource];
    switch ([_pluginIdentifier unsignedIntegerValue]) {
        case 0:
            if (ds[DMCCImageThumbnail]) {
                ds[DMCCImageThumbnail] =  [self base64ImageFromUnarchivePath:[path stringByAppendingPathComponent:ds[DMCCImageThumbnail]]];
            }
            if (ds[DMCCTagSystemrKey]) {
                ds[DMCCTagSystemrKey] = [self dictionaryFromArray:ds[DMCCTagSystemrKey]];
            }
            if (ds[DMCCTagUserKey]) {
                ds[DMCCTagUserKey] = [self dictionaryFromArray:ds[DMCCTagUserKey]];
            }
            break;
        case 3:
        {
            [ds removeAllObjects];
            NSMutableDictionary *cvtData =[NSMutableDictionary dictionaryWithDictionary:self.dataSource];
            if ([cvtData count]) {
                ds[@"imgmids"] = cvtData;
                for (NSString *key in ds[@"imgmids"]) {
                    if (ds[@"imgmids"][key][DMCGalleryPhoto]) {
                        ds[@"imgmids"][key][DMCGalleryPhoto] = [self base64ImageFromUnarchivePath:[path stringByAppendingPathComponent:ds[@"imgmids"][key][DMCGalleryPhoto]]];
                    }
                }
            }
        }
            break;
        case 4:
        case 14:
            if (ds[DMCCImage]) {
                ds[DMCCImage] = [self base64ImageFromUnarchivePath:[path stringByAppendingPathComponent:ds[DMCCImage]]];
            }
            break;
        default:
            break;
    }
    if (![_pluginIdentifier isEqualToNumber:@0]) {
        ds[@"plugid"] = _pluginIdentifier;
    }
    return ds;
}

-(NSString *)base64ImageFromUnarchivePath:(NSString *)path{
    UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSData *data = UIImagePNGRepresentation(image);
    return [data base64Encoding];
}

-(NSMutableDictionary *)dictionaryFromArray:(NSArray *)array{
    NSUInteger i = 0;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id object in array) {
        dic[@(i++)] = object;
    }
    return dic;
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
        case 5:
            fieldNameDict = @{DMCMapLatitude: NSLocalizedString(@"DMCMapLatitude", @"Latitude"),
                              DMCMapLongitude:NSLocalizedString(@"DMCMapLongitude", @"Longitude"),
                              DMCCaption:NSLocalizedString(@"DMCCaption", @"Caption")};
            requiredField = @[DMCMapLongitude,DMCMapLatitude];
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
            break;
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

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.pluginIdentifier = [aDecoder decodeObjectForKey:@"plugid"];
        self.pluginName = [aDecoder decodeObjectForKey:@"plugname"];
        self.isStaticPlugin = [aDecoder decodeBoolForKey:@"isstat"];
        self.isDataComplete = [aDecoder decodeBoolForKey:@"isdc"];
        self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.dataSource = [aDecoder decodeObjectForKey:@"das"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.pluginIdentifier forKey:@"plugid"];
    [aCoder encodeObject:self.pluginName forKey:@"plugname"];
    [aCoder encodeBool:self.isStaticPlugin forKey:@"isstat"];
    [aCoder encodeBool:self.isDataComplete forKey:@"isdac"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:self.dataSource forKey:@"das"];
}
@end
























