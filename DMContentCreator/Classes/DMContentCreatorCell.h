//
//  DMContentCreatorCell.h
//  DMContentCreator
//
//  Created by Trash on 9/26/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMContentCreatorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *pluginTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pluginDetailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
