//
//  DMLocation.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMLocation.h"
#include <CoreLocation/CoreLocation.h>

@implementation DMLocation


- (id)initWithDictionary:(NSDictionary *)dict{
	if (self = [super init]) {
        self.objectId = [dict objectForKey:@"idLok"];
        self.street = [dict objectForKey:@"ulica"];
        self.city = [dict objectForKey:@"grad"];
        self.phoneNo = [dict objectForKey:@"brtel"];
        self.workingHours = [dict objectForKey:@"radvr"];
        self.latitude = [dict objectForKey:@"lati"];
        self.longitude = [dict objectForKey:@"longi"];
        self.saturdayHours = [dict objectForKey:@"radS"];
        self.sundayHours = [dict objectForKey:@"radN"];
        self.chief = [dict objectForKey:@"posl"];
        self.prod = [dict objectForKey:@"prod"];
        
        
        
        
        DMAppDelegate* appDelegate = (DMAppDelegate*)[[UIApplication sharedApplication] delegate];
        CLLocation* currentLocation = appDelegate.currentLocation;
        CLLocation* location = [[CLLocation alloc] initWithLatitude:[self.latitude floatValue] longitude:[self.longitude floatValue]];
        
        CLLocationDistance distance = [location distanceFromLocation:currentLocation];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//        [formatter setMaximumIntegerDigits:2];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        self.distance = [formatter stringFromNumber:[NSNumber numberWithFloat:distance/1000]];
        
	}
	return self;
}

@end
