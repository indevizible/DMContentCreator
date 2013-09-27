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
            
        default:
            return [UIImage imageNamed:[@"DMContentCreator.bundle" stringByAppendingPathComponent:[NSString stringWithFormat:@"plugin-thumbnail-%@.png",plugin.pluginIdentifier]]];
            break;
    }
    return nil;
}

-(void)setIsDataComplete:(BOOL)isDataComplete{
    _isDataComplete = isDataComplete;
    _thumbnail = [DMContentPlugins imageForPlugin:self];
}
@end
