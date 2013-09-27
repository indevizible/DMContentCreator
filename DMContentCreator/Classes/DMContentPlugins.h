//
//  DMContentPlugins.h
//  DMContentCreator
//
//  Created by Trash on 9/26/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMContentPlugins : NSObject
@property (nonatomic,strong) NSNumber *pluginIdentifier;
@property (nonatomic,strong) NSString *pluginName;
@property (nonatomic,assign) BOOL isStaticPlugin,isDataComplete;
@property (nonatomic,strong) UIImage *thumbnail;

+(instancetype)pluginWithIdentifier:(NSUInteger)pluginIdentifier color:(UIColor *)color;
@end
