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
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  MAPA" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.selectedLocation.latitude.floatValue
                                                            longitude:self.selectedLocation.longitude.floatValue
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    
    self.view = mapView_;
    
    
    [self performSelector:@selector(setupMap) withObject:nil afterDelay:3.0];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMap{
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.selectedLocation.latitude.floatValue, self.selectedLocation.longitude.floatValue);
    marker.title = self.selectedLocation.street;
    marker.snippet = self.selectedLocation.city;
    marker.icon = [UIImage imageNamed:@"zastavica.png"];
    marker.map = mapView_;
    
    

    
    
    
    
    
    if (mapView_.myLocation) {
        GMSCoordinateBounds* bound = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position coordinate:mapView_.myLocation.coordinate];
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bound
                                                 withPadding:80.0f];
        [mapView_ moveCamera:update];
    }
    else{
        GMSCoordinateBounds* bound = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position coordinate:marker.position];
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bound
                                                 withPadding:80.0f];
        [mapView_ moveCamera:update];
    }
    
}


@end
