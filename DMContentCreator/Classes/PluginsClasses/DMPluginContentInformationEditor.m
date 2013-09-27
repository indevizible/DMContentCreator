//
//  DMPluginContentInformationEditor.m
//  DMContentCreator
//
//  Created by Trash on 9/27/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginContentInformationEditor.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <BlocksKit/BlocksKit.h>
#import "DMContentCreator.h"
typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;
@interface DMPluginContentInformationEditor (){
    ScrollDirection scrollDirection;
}
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (nonatomic, assign) NSInteger lastContentOffset;
@end


@implementation DMPluginContentInformationEditor

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_plugins) {
        _plugins = [DMContentPlugins pluginWithIdentifier:0 color:[UIColor iOS7lightBlueColor]];
    }
    [DMContentCreator setNavigationBarStyle:self.navigationController];
    UIImage *image = [UIImage imageGlyphNamed:@"fontawesome##picture" height:100.0 color:[UIColor iOS7lightGrayColor]];
    [_thumbnailImage setImage:image];
    
    UIBarButtonItem *closeButton = [self barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIBarButtonItem *saveButton = [self barButtonItemName:@"fontawesome##ok-sign" handler:^(id sender){
        
    }];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (self.lastContentOffset > self.tableView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else
        scrollDirection = ScrollDirectionUp;

    
    self.lastContentOffset = self.tableView.contentOffset.y;
    
    // do whatever you need to with scrollDirection here.
    
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"v : %@",NSStringFromCGPoint(velocity));
    if (fabs(velocity.y)>0.70f) {
        [self.view endEditing:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIBarButtonItem *)barButtonItemName:(NSString *)name handler:(void (^)( UIBarButtonItem *weakSender))handler{
    UIImage *image =[UIImage imageGlyphNamed:name size:CGSizeMake(25, 25) color:_plugins.color];
    UIButton *toggleNoti = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width , image.size.height)];
    [toggleNoti setImage:image forState:UIControlStateNormal];
    [toggleNoti setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *weakSender = [[UIBarButtonItem alloc] initWithCustomView:toggleNoti];
    [toggleNoti whenTapped:^{
        handler(weakSender);
    }];
    return weakSender;
}

@end
