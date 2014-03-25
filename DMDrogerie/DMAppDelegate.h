//
//  DMAppDelegate.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#define kBaseURL @"http://www.dmbih.com/"
#define kSavedItems @"kSavedItems"
#define kStatistics @"kStatistics"

@interface DMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong)CLLocationManager* manager;
@property (nonatomic, strong)CLLocation* currentLocation;

@end
