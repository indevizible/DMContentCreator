//
//  DMPluginMapEditor.m
//  DMContentCreator
//
//  Created by Trash on 10/3/13.
//  Copyright (c) 2013 infostant. All rights reserved.
//

#import "DMPluginMapEditor.h"
#import "DMContentCreatorStyle.h"
#import <WTGlyphFontSet/WTGlyphFontSet.h>
#import <BlocksKit/BlocksKit.h>
@interface DMMapEditorAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
   
}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title,*subtitle;
- (id)initWithLocation:(CLLocationCoordinate2D)coord;

// Other methods and properties.
@end

@implementation DMMapEditorAnnotation
@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
@end

@interface DMPluginMapEditor ()<MKMapViewDelegate>
{
 NSString *labelCaption;
}
@property (nonatomic,weak) DMContentPlugins *plugins;
@property  (nonatomic,weak) IBOutlet MKMapView *mapView;
@end

@implementation DMPluginMapEditor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.mapView = (MKMapView *)self.view;
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowsPointsOfInterest:YES];
    [self.mapView setShowsBuildings:YES];
	// Do any additional setup after loading the view.
    [DMContentCreatorStyle setNavigationBarStyle:self.navigationController];
    self.title = _plugins.pluginName;
    self.navigationItem.leftBarButtonItem = [DMContentCreatorStyle closeButtonWithHandler:^(UIBarButtonItem *weakSender) {
        
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"Save" message:[NSString stringWithFormat:@"Do you want to save this location with caption \"%@\" ?",labelCaption]];
        [alertView addButtonWithTitle:@"Don't Save" handler:^{
            [_plugins checkIncompleteLists];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertView setCancelButtonWithTitle:@"Save" handler:^{
            if ([[self.mapView annotations] count]) {
                DMMapEditorAnnotation *annotation = [[self.mapView annotations] objectAtIndex:0];
                _plugins[DMCMapLatitude] = @(annotation.coordinate.latitude);
                _plugins[DMCMapLongitude] = @(annotation.coordinate.longitude);
                _plugins[DMCCaption] = [labelCaption length] ? labelCaption : nil;
            }else{
                _plugins[DMCMapLatitude] = nil;
                _plugins[DMCMapLongitude] = nil;
                _plugins[DMCCaption] = nil;
            }
            [_plugins checkIncompleteLists];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertView show];
    }];
    self.navigationItem.rightBarButtonItem = [DMContentCreatorStyle barButtonItemName:@"fontawesome##location-arrow" handler:^(UIBarButtonItem *weakSender) {
        [self zoomToUserLocation:self.mapView.userLocation];
//        [self.mapView setCenterCoordinate:locationManager.location.coordinate animated:YES];
    }];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    self.navigationController.navigationBar.translucent = NO;
    if (_plugins[DMCMapLatitude] && _plugins[DMCMapLongitude]) {
        DMMapEditorAnnotation *annotation = [[DMMapEditorAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([_plugins[DMCMapLatitude] floatValue], [_plugins[DMCMapLongitude] floatValue])];
        labelCaption = _plugins[DMCCaption];
        
        [annotation setTitle:[labelCaption length] ? labelCaption : @"<Untitled>"];
        annotation.subtitle =[labelCaption length] ? nil :  @"Tap right icon to edit caption";
        [self.mapView addAnnotation:annotation];

    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
}


- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(.01, .01);
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        NSLog(@"Firing Back Button");
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([self.mapView showsUserLocation]) {
//        [self moveOrZoomOrAnythingElse];
        // and of course you can use here old and new location values
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(DMMapEditorAnnotation<MKAnnotation> * )annotation{
    NSLog(@"anno %@",annotation);
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (pav == nil) {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                   reuseIdentifier:@"pin"];
        pav.draggable = YES;
        pav.canShowCallout = YES;
        
        UIImage *image = [UIImage imageGlyphNamed:@"fontawesome##edit" height:16.0f color:[UIColor blackColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        UIButton *editButton = [[UIButton alloc] initWithFrame:imageView.frame];
        [editButton setImage:image forState:UIControlStateNormal];
        [editButton whenTapped:^{
            UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"Caption" message:@"Enter caption for this point"];
            __block UIAlertView *blockAlert = alertView;
            [alertView addButtonWithTitle:@"OK" handler:^{
                labelCaption = [[blockAlert textFieldAtIndex:0] text];
                [annotation setTitle:[labelCaption length] ? labelCaption : @"<Untitled>"];
                annotation.subtitle =[labelCaption length] ? nil :  @"Tap right icon to edit caption";
            }];
            [alertView setCancelButtonWithTitle:@"Cancel" handler:nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
            [[alertView textFieldAtIndex:0] setText:labelCaption];
        }];
        pav.rightCalloutAccessoryView  = editButton;
    }else{
        pav.annotation = annotation;
    }
    return pav;
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    DMMapEditorAnnotation *annotation = [[DMMapEditorAnnotation alloc] initWithLocation:touchMapCoordinate];
    annotation.title = [labelCaption length] ? labelCaption : @"<Untitled>";
    annotation.subtitle =[labelCaption length] ? nil :  @"Tap right icon to edit caption";
    [self.mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}
@end
