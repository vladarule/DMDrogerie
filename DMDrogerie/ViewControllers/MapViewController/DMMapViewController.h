//
//  DMMapViewController.h
//  DMDrogerie
//
//  Created by Vlada on 3/17/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "DMLocation.h"

@interface DMMapViewController : UIViewController


@property (nonatomic, strong)DMLocation* selectedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(DMLocation *)location;

@end
