//
//  DMHairImgShareViewController.h
//  DMDrogerie
//
//  Created by Vlada on 5/26/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMHairColorManufacturer.h"
#import "DMHairColor.h"

@interface DMHairImgShareViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil finalImage:(UIImage *)final manafacturer:(DMHairColorManufacturer *)man andColor:(DMHairColor *)color;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewHair;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewHairColor;
@property (weak, nonatomic) IBOutlet UILabel *lblHairColor;

@end
