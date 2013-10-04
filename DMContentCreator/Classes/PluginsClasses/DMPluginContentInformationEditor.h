//
//  DMPluginContentInformationEditor.h
//  DMContentCreator
//
//  Created by Trash on 9/27/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMContentPlugins.h"

@interface DMPluginContentInformationEditor : UITableViewController<DMContentPluginProtocol>
@property (nonatomic,strong) DMContentPlugins *plugins;

@end
