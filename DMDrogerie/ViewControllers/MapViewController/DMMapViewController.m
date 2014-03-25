//
//  DMMapViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/17/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DMMapViewController ()



@end

@implementation DMMapViewController

GMSMapView *mapView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(DMLocation *)location{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedLocation = location;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.selectedLocation.latitude.floatValue
                                                            longitude:self.selectedLocation.longitude.floatValue
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.selectedLocation.latitude.floatValue, self.selectedLocation.longitude.floatValue);
    marker.title = self.selectedLocation.street;
    marker.snippet = self.selectedLocation.workingHours;
    marker.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
