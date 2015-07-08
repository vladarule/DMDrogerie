//
//  DMCompareViewController.h
//  DMDrogerie
//
//  Created by Vlada on 5/4/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMHairColorManufacturer.h"
#import "DMHairColor.h"

@interface DMCompareViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil originalImage:(UIImage *)image finalImage:(UIImage *)final manafacturer:(DMHairColorManufacturer *)man andColor:(DMHairColor *)color;

@end
