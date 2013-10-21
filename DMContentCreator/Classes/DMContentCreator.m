//
//  DMContentCreator.m
//  DMContentCreator
//
//  Created by Trash on 9/17/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMContentCreator.h"
#import <iOS7Colors/UIColor+iOS7Colors.h>
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <BlocksKit/BlocksKit.h>
#import <RNGridMenu/RNGridMenu.h>
#import "DMContentPlugins.h"
#import "DMContentCreatorCell.h"
#import <LAUtilitiesStaticLib/LAUtilitiesStaticLib.h>
#import "DMPluginContentInformationEditor.h"
#import "DMContentCreatorStyle.h"
#import <SIAlertView/SIAlertView.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#define SYSTEM_AVALIABLE_PLUGIN @[@0,@3,@4,@5,@6,@7,@8,@10,@14]
#define DMCTEMPFILE @"__AUTOSAVE__"
#define DMCDATSFILE @"datasource.ds"

@interface DMContentCreator ()<RNGridMenuDelegate>{
    NSString *resourcesBundle;
    Class navigationClass;
    NSMutableArray *dataSource;
    UIStoryboard *mainStoryboard;
    UIStatusBarStyle backupStatusBarStyle;
    NSOperationQueue *queue;
    BOOL isUploading;
    //    UIColor *backupWindowsTintColor;
}
@end

@implementation DMContentCreator

#pragma mark - Plugins protocol

-(void)setDefaultPlugins:(NSArray *)defaultPlugins{
    NSMutableArray *muArr = [NSMutableArray new];
    [muArr addObject:@0];
    for (NSNumber *num in defaultPlugins) {
        if ([self isPluginAvaliable:num]) {
            [muArr addObject:num];
        }
    }
    _defaultPlugins = [NSArray arrayWithArray:muArr];
}

#pragma mark - ViewController Event
- (void)viewDidLoad
{
    [super viewDidLoad];

    queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
     backupStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    resourcesBundle = @"DMContentCreator.bundle";
    [[DMContentCreator sharedComponents] setResourceBundle:resourcesBundle];
    if (self.navigationController) {
        navigationClass = [self.navigationController class];
    }
    [[DMContentCreator sharedComponents] setColor:_color];
    [[DMContentCreator sharedComponents] setThemeColor:(_themeMode == DMContentCreatorBackgroundModeDark ? [UIColor blackColor] : [UIColor whiteColor])];
    [[DMContentCreator sharedComponents] setInvertedNavigation:_invertedNavigation];
    [[DMContentCreator sharedComponents] setThemeMode:_themeMode];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    [[DMContentCreator sharedComponents] setTagsList:self.tagsList];
    
    [self.tableView setBackgroundColor:[[DMContentCreator sharedComponents] themeColor]];
    [self prepareDirectory];
    if ([[self.file lastPathComponent] isEqualToString:DMCTEMPFILE]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self.file  stringByAppendingPathComponent:DMCDATSFILE]]) {
            NSLog(@"ds : %@",[self.file stringByAppendingPathComponent:DMCDATSFILE]);
            dataSource = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.file stringByAppendingPathComponent:DMCDATSFILE]];
        }else{
            dataSource = [NSMutableArray new];
            for (id plugid in _defaultPlugins) {
                [dataSource addObject:[DMContentPlugins pluginWithIdentifier:[plugid unsignedIntegerValue]]];
            }
            for (id plugid in _sampleLayoutPlugins) {
                BOOL found = NO;
                for (NSNumber *av in SYSTEM_AVALIABLE_PLUGIN) {
                    if ([av isEqualToNumber:plugid]) {
                        found = YES;
                        break;
                    }
                }
                if (found) {
                    [dataSource addObject:[DMContentPlugins pluginWithIdentifier:[plugid unsignedIntegerValue]]];
                }
            }

        }
    }else{
        dataSource = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.file stringByAppendingPathComponent:DMCDATSFILE]];
    }
    
    if (!self.navigationController || [[self.navigationController viewControllers] count] == 1) {
        UIBarButtonItem *closeButton = [DMContentCreatorStyle barButtonItemName:@"fontawesome##angle-down" handler:^(id sender){
            UIAlertView *alertSave = [UIAlertView alertViewWithTitle:@"Quit" message:@"Do you want to quiet without save"];
            [alertSave addButtonWithTitle:@"Save" handler:^{
                [self save:^{
                    [self dismissWithAnimated:YES];
                }];
            }];
            [alertSave setCancelButtonWithTitle:@"Don't save" handler:^{
                [self dismissWithAnimated:YES];
                if ([[self.file lastPathComponent] isEqualToString:DMCTEMPFILE]) {
                    [[NSFileManager defaultManager] removeItemAtPath:self.file error:nil];
                }
            }];
            [alertSave setCancelButtonWithTitle:@"Cancel" handler:nil];
            [alertSave show];
        }];
        self.navigationItem.leftBarButtonItem = closeButton;
    }
    
    UIBarButtonItem *taskButton = [DMContentCreatorStyle barButtonItemName:@"fontawesome##tasks" handler:^(id sender){
        if (!isUploading) {
            [self showMenu];
        }
    }];
    self.navigationItem.rightBarButtonItem = taskButton;
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)setSampleLayoutPlugins:(NSArray *)sampleLayoutPlugins{
    NSMutableArray *arr = [NSMutableArray new];
    for (id plugid in sampleLayoutPlugins) {
        BOOL found = NO;
        for (NSNumber *av in SYSTEM_AVALIABLE_PLUGIN) {
            if ([av isEqualToNumber:plugid]) {
                found = YES;
                break;
            }
        }
        if (found) {
            [arr addObject:plugid];
        }
    }
    _sampleLayoutPlugins = arr;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateStatusBar];
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    [self.tableView reloadData];
    [NSKeyedArchiver archiveRootObject:dataSource toFile:[self.file stringByAppendingPathComponent:DMCDATSFILE]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self save:nil];
}


-(NSMutableDictionary *)parameterFromPluginDatasource:(NSArray *)__ds oauth:(NSString *)oauth{
    NSMutableDictionary *product = [NSMutableDictionary new];
    NSMutableArray *ds = [NSMutableArray arrayWithArray:__ds];
    if (oauth) {
        product[@"oauth"] = oauth;
    }
    product[@"fid"] = _featureIdentifier;
    
    DMContentPlugins *infoPlugin = [__ds objectAtIndex:0];
    if ([infoPlugin.pluginIdentifier isEqualToNumber:@0]) {
        [product addEntriesFromDictionary:[infoPlugin generatedDataWithPath:_file]];
        [ds removeObjectAtIndex:0];
        product[@"plugin"] = [NSMutableDictionary new];
        NSUInteger number = 0;
        for (NSUInteger i=0; i<[ds count]; i++) {
            DMContentPlugins *eachPlugin = [ds objectAtIndex:i];
            NSMutableDictionary *generatedData = [eachPlugin generatedDataWithPath:_file];
            if ([generatedData count] > 1) {
                product[@"plugin"][@(number++)] = generatedData;
            }
        }
        return product;
    }
    return nil;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMContentPlugins *plugin = dataSource[indexPath.row];
    UIImage *image = [UIImage imageNamed:[resourcesBundle stringByAppendingPathComponent:@"item-background-gray.png"]];
    UIImage *line =[UIImage imageNamed:[resourcesBundle stringByAppendingPathComponent:@"line.png"]];
    DMContentCreatorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if ([[dataSource objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&
        
        [[dataSource objectAtIndex:indexPath.row] isEqualToString:@"DUMMY"]) {
        [cell.pluginTitleLabel setText:nil];
        [cell.pluginDetailsLabel setTextColor:[UIColor iOS7lightGrayColor]];
        [cell.pluginDetailsLabel setText:nil];
        [cell.thumbnailView setImage:nil];
        [cell setBackgroundView:nil];
        cell.hidden = YES;
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:123];
        [imageView setImage:nil];
        cell.backgroundImage.image = nil;
        [imageView removeFromSuperview];
    }
    else {
        cell.hidden= NO;
        NSString *string = [NSString stringWithFormat:@"DMCCDESCRIPT%02u",[plugin.pluginIdentifier unsignedIntegerValue]];
        [cell.pluginDetailsLabel setText:NSLocalizedString(string, @"detail description")];
        cell.backgroundImage.image = (indexPath.row >= [_defaultPlugins count]) ? image : line;
        [cell.pluginTitleLabel setTextColor:_color];
        NSString *storyboardIdentifier =[NSString stringWithFormat:@"DMEPLG%02u",plugin.pluginIdentifier.unsignedIntegerValue];
        [cell.pluginTitleLabel setText:(([self storyboardName:@"iPhone-DMContentCreator" hasStoryboardIdentifier:storyboardIdentifier]) ? plugin.pluginName : NSLocalizedString(@"DMCUNDEFINEDPLUGIN", @"Undefined plugin"))];
        [cell.pluginDetailsLabel setTextColor:[UIColor iOS7lightGrayColor]];
               [cell.thumbnailView setImage:plugin.thumbnail];
        UILabel *pluginTitleLabel = cell.pluginTitleLabel;
        UILabel *pluginDetailsLabel     = cell.pluginDetailsLabel;
        NSDictionary *dict = NSDictionaryOfVariableBindings(pluginTitleLabel);
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pluginTitleLabel]|" options:0 metrics:nil views:dict]];
        dict = NSDictionaryOfVariableBindings(pluginDetailsLabel);
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pluginDetailsLabel]|" options:0 metrics:nil views:dict]];
    }
    [cell setBackgroundColor:[[DMContentCreator sharedComponents] themeColor]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row >= [[self defaultPlugins ] count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMContentPlugins *plugin = dataSource[indexPath.row];
    NSString *storyboardIdentifier =[NSString stringWithFormat:@"DMEPLG%02u",plugin.pluginIdentifier.unsignedIntegerValue];
    if ([self storyboardName:@"iPhone-DMContentCreator" hasStoryboardIdentifier:storyboardIdentifier]) {
        UIViewController<DMContentPluginProtocol> *editView = [self.storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
        [editView setPlugins:plugin];
        if ([editView respondsToSelector:@selector(setSavePath:)]) {
            [editView setSavePath:self.file];
        }
        UINavigationController *nav = [[[navigationClass class] alloc] initWithRootViewController:editView];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return  (indexPath.row >= [_defaultPlugins count]) ;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    return (proposedDestinationIndexPath.row < [_defaultPlugins count]) ?sourceIndexPath :proposedDestinationIndexPath;
}

#pragma mark - BVReorderTableView Delegate

-(id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [dataSource objectAtIndex:indexPath.row];
    [dataSource replaceObjectAtIndex:indexPath.row withObject:@"DUMMY"];
    return object;
}

-(void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    DMContentPlugins *plugin = [dataSource objectAtIndex:fromIndexPath.row];
    [dataSource removeObjectAtIndex:fromIndexPath.row];
    [dataSource insertObject:plugin atIndex:toIndexPath.row];
}

#pragma mark - General Method

-(void)save:(void(^)(void))saved{
    if (self.isSaved) {
        BOOL success = [NSKeyedArchiver archiveRootObject:dataSource toFile:[self.file stringByAppendingPathComponent:DMCDATSFILE]];
        NSLog(@"success = %u",success);
        if (saved) {
            saved();
        }
    }else{
        DMContentPlugins *infoPlugin =[dataSource objectAtIndex:0];
        if ([infoPlugin[DMCCProductNameKey] length]) {
            NSString *productName = infoPlugin[DMCCProductNameKey];
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[self saveDiretory] stringByAppendingPathComponent:productName]]) {
                NSUInteger duplicateRunNumber = 1;
                while ([[NSFileManager defaultManager] fileExistsAtPath:[[self saveDiretory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %u",productName,++duplicateRunNumber]]]);
                productName =[NSString stringWithFormat:@"%@ %u",productName,duplicateRunNumber];
            }
            NSLog(@"product name : %@",productName);
            NSString *toPath =[[self saveDiretory] stringByAppendingPathComponent:productName];
            [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *fromPath = self.file;
            NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:nil];
            for (NSString *eachFileName in fileList) {
                [[NSFileManager defaultManager] moveItemAtPath:[fromPath stringByAppendingPathComponent:eachFileName] toPath:[toPath stringByAppendingPathComponent:eachFileName] error:nil];
            }
            [[NSFileManager defaultManager] removeItemAtPath:fromPath error:nil];
            _file = toPath;
            NSLog(@"datasource = %@",dataSource);
            [NSKeyedArchiver archiveRootObject:dataSource toFile:[self.file stringByAppendingPathComponent:DMCDATSFILE]];
            if (saved) {
                saved();
            }
        }else{
            UIAlertView *alertProductName = [UIAlertView alertViewWithTitle:@"Product name required" message:@"You must enter product name before save."];
            [alertProductName addButtonWithTitle:@"OK" handler:^{
                [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }];
            [alertProductName show];
        }
    }
    
}

-(BOOL)isSaved{
    return  ![[[self.file pathComponents] lastObject] isEqualToString:DMCTEMPFILE];
}

-(void)showMenu{
    RNGridMenuItem *addItem = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:@"fontawesome##plus-sign" height:100 color: _color] title:@"Add" action:^{
        [self showAddMenu];
    }];
    
    RNGridMenuItem *upload = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:@"fontawesome##upload" height:100 color: _color] title:@"Upload" action:^{
        [self uploadToServer];
    }];
    RNGridMenuItem *save = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:@"fontawesome##save" height:100 color: _color] title:@"Save" action:^{
        [self save:^{
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Saved" andMessage:@"This product saved"];
            [alertView addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
            [alertView show];
        }];
    }];
    NSArray *mar = @[addItem,save,upload];
    
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:mar];
    [gridMenu setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
    [gridMenu setItemTextColor:[UIColor iOS7darkGrayColor]];
    [gridMenu setHighlightColor:[_color colorWithAlphaComponent:0.1]];
    [gridMenu showInViewController:self center:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
}

-(void)showAddMenu{
    NSMutableArray *mar = [NSMutableArray new];
    for (id __plugid in _avaliablePlugins) {
        if ([self isPluginAvaliable:__plugid]) {
            NSUInteger plugid = [__plugid unsignedIntegerValue];
            NSString *localizedPluginName = [NSString stringWithFormat:@"DMCONTENTPLUGIN-%u",plugid];
            RNGridMenuItem *tmpItem = [[RNGridMenuItem alloc] initWithImage:[UIImage imageGlyphNamed:[DMContentPlugins imageNameForPluginIdentifier:plugid] height:100 color: _color] title:NSLocalizedString(localizedPluginName, @"Use your local name by localizable.string") action:^{
                [dataSource addObject:[DMContentPlugins pluginWithIdentifier:plugid]];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[dataSource count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            [mar addObject:tmpItem];
        }
    }
    RNGridMenu *gridMenu = [[RNGridMenu alloc] initWithItems:mar];
    [gridMenu setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
    [gridMenu setItemTextColor:[UIColor iOS7darkGrayColor]];
    [gridMenu setHighlightColor:[_color colorWithAlphaComponent:0.1]];
    [gridMenu showInViewController:self center:CGPointMake(self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f)];
    
}

-(BOOL)isPluginAvaliable:(NSNumber *)__plugid{
    for (NSNumber *num in SYSTEM_AVALIABLE_PLUGIN) {
        if ([__plugid isEqualToNumber:num]) {
            return YES;
        }
    }
    return NO;
}

+(instancetype)contentCreatorForIPhoneDevice{
    return [[UIStoryboard storyboardWithName:@"iPhone-DMContentCreator" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CTCAT"];
}

+(DMContentCreatorComponents *)sharedComponents{
    static dispatch_once_t onceToken;
    static DMContentCreatorComponents *sharedComponents = nil;
    dispatch_once(&onceToken, ^{
        sharedComponents = [DMContentCreatorComponents new];
        sharedComponents.color = [UIColor iOS7lightBlueColor];
        sharedComponents.navigationClass = [UINavigationController class];
    });
    return sharedComponents;
}

-(void)updateStatusBar{
    BOOL isDarkMode = ([[DMContentCreator sharedComponents] themeMode] == DMContentCreatorBackgroundModeDark);
    [[UIApplication sharedApplication] setStatusBarStyle:(([[DMContentCreator sharedComponents] invertedNavigation] && isDarkMode)||(!([[DMContentCreator sharedComponents] invertedNavigation] || isDarkMode)) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault) animated:YES];
}

+(UIImage *)backImage{
    return [UIImage imageGlyphNamed:@"fontawesome#angle-left" size:CGSizeMake(25, 25) color:([[DMContentCreator sharedComponents] invertedNavigation] ? [[DMContentCreator sharedComponents] color] : [[DMContentCreator sharedComponents] themeColor])];
}

-(BOOL)storyboardName:(NSString *)storyboardName hasStoryboardIdentifier:(NSString *)storyboardIdentifier{
    NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] pathForResource:storyboardName ofType:@"storyboardc"] error:nil];
    for (NSString *file in list) {
        NSString *fileName = [file componentsSeparatedByString:@"."][0];
        if ([fileName isEqualToString:storyboardIdentifier]) {
            return YES;
        }
    }
    return NO;
}

-(void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath{
    [dataSource replaceObjectAtIndex:indexPath.row withObject:object];
}

+(NSString *)generateImageFileFromPath:(NSString *)path extension:(NSString *)extension{
    NSString *imageName = nil;
    do {
        imageName = [NSString stringWithFormat:@"%u.%@",arc4random(),extension];
    } while ([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:imageName]]);
    return imageName;
}

-(void)prepareDirectory{
    NSString *librayPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *mainDirName = @"DMCCSAVE";
    NSString *fullMainDirName =[librayPath stringByAppendingPathComponent:mainDirName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullMainDirName]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullMainDirName withIntermediateDirectories:YES attributes:@{NSFileProtectionKey: NSFileProtectionComplete} error:nil];
    }
    
    NSString *featureDirName = [NSString stringWithFormat:@"F%02u",[self.featureIdentifier unsignedIntegerValue]];
    NSString *fullFeatureDirName = [fullMainDirName stringByAppendingPathComponent:featureDirName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullFeatureDirName]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullFeatureDirName withIntermediateDirectories:YES attributes:@{NSFileProtectionKey: NSFileProtectionComplete} error:nil];
    }
    
    if (!_file) {
        _file = [fullFeatureDirName stringByAppendingPathComponent:DMCTEMPFILE];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:self.file withIntermediateDirectories:YES attributes:@{NSFileProtectionKey: NSFileProtectionComplete} error:nil];
}

-(NSString *)saveDiretory{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"DMCCSAVE"] stringByAppendingPathComponent:[NSString stringWithFormat:@"F%02u",[self.featureIdentifier unsignedIntegerValue]]];
}

-(void)uploadToServer{
    //required list
    if ((!_featureIdentifier || !_baseURL || !_oauth)) {
        return;
    }
    
    UIBarButtonItem *closeButton = self.navigationItem.leftBarButtonItem;
   
    NSArray *reqList = nil;
    for (int i = 0; i < [_defaultPlugins count]; i++) {
        DMContentPlugins *eachPlugin = dataSource[i];
        reqList = [eachPlugin checkIncompleteLists];
        if ([reqList count]) {
            break;
        }else{
            reqList = nil;
        }
    }
    if (reqList) {
        UIAlertView *alert = [UIAlertView alertViewWithTitle:@"Some data requied" message:[NSString stringWithFormat:@"Please enter follow list : %@.",[reqList componentsJoinedByString:@", "]]];
        [alert setCancelButtonWithTitle:@"OK" handler:nil];
        [alert show];
    }else{
        isUploading = YES;
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        progress.mode = MBProgressHUDModeAnnularDeterminate;
        progress.progress = 0.0;
        progress.labelText = @"Preparing...";
        __block NSMutableDictionary *param;
        NSBlockOperation *dataGenerator = [NSBlockOperation blockOperationWithBlock:^{
            param = [self parameterFromPluginDatasource:dataSource oauth:_oauth];
        }];
        [dataGenerator setCompletionBlock:^{
            progress.labelText = @"Uploading";
            if (param) {
                AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:self.baseURL];
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[client requestWithMethod:@"POST" path:@"ajax/saveproductmobiledata" parameters:param] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    if (!JSON[@"error"][@"error"]) {
                        self.navigationItem.leftBarButtonItem = closeButton;
                        if ([self.file isEqualToString:DMCTEMPFILE] ) {
                            SIAlertView *alertSuccess = [[SIAlertView alloc] initWithTitle:@"Success !" andMessage:@"This content upload completely."];
                            [alertSuccess addButtonWithTitle:@"Close" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                                [self dismissWithAnimated:YES];
                            }];
                            [alertSuccess show];
                        }else{
                            if ([[[self.file pathComponents] lastObject] isEqualToString:DMCTEMPFILE]) {
                                SIAlertView *alertSuccess = [[SIAlertView alloc] initWithTitle:@"Success !" andMessage: @"This content upload completely !"];
                                [alertSuccess addButtonWithTitle:@"Close" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                                    //delete file
                                    [[NSFileManager defaultManager] removeItemAtPath:self.file error:nil];
                                    [self dismissWithAnimated:YES];
                                }];
                                [alertSuccess show];
                            }else{
                                SIAlertView *alertSuccess = [[SIAlertView alloc] initWithTitle:@"Success !" andMessage: @"This content upload completely, Do you want to delete save ?"];
                                [alertSuccess addButtonWithTitle:@"Delete" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                                    //delete file
                                    [[NSFileManager defaultManager] removeItemAtPath:self.file error:nil];
                                    [self dismissWithAnimated:YES];
                                }];
                                [alertSuccess addButtonWithTitle:@"Close" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                                    [self dismissWithAnimated:YES];
                                }];
                                [alertSuccess show];
                            }
                        }
                    }

                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:error.localizedDescription];
                    [alert addButtonWithTitle:@"OK" type:SIAlertViewButtonTypeDefault handler:nil];
                    [alert show];

                }];
                [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    float percentDone = ((float)((int)totalBytesWritten) / (float)((int)totalBytesExpectedToWrite));
                    progress.progress = percentDone;
                }];
                [queue addOperation:operation];
            }
        }];
        [queue addOperation:dataGenerator];
        UIBarButtonItem *stopButton = [DMContentCreatorStyle barButtonItemName:@"fontawesome##remove-sign" handler:^(UIBarButtonItem *weakSender) {
            SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Stop" andMessage:@"Do you want to stop upload?"];
            [alert addButtonWithTitle:@"Stop" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
                [queue cancelAllOperations];
                [progress hide:YES];
                self.navigationItem.leftBarButtonItem = closeButton;
            }];
            [alert addButtonWithTitle:@"Continue" type:SIAlertViewButtonTypeDefault handler:nil];
            [alert show];
        }];
        self.navigationItem.leftBarButtonItem = stopButton;
    }
   
}

-(void)dismissWithAnimated:(BOOL)animated{
    [self dismissViewControllerAnimated:animated completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:backupStatusBarStyle animated:NO];
    }];
}

+(NSArray *)fileListForFeautreIdentifier:(NSUInteger)featureIdentifier{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"DMCCSAVE"] stringByAppendingPathComponent:[NSString stringWithFormat:@"F%02u",featureIdentifier]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

+(BOOL)deleteSaveName:(NSString *)fileToDelete featureIdentifier:(NSUInteger)featureIdentifier{
   NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"DMCCSAVE"] stringByAppendingPathComponent:[NSString stringWithFormat:@"F%02u",featureIdentifier]] stringByAppendingPathComponent:fileToDelete];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
@end


@implementation DMContentCreatorComponents
@end