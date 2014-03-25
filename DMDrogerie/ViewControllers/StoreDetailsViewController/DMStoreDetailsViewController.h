//
//  DMStoreDetailsViewController.h
//  DMDrogerie
//
//  Created by Vlada on 2/13/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLocation.h"

@interface DMStoreDetailsViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *lblAdress;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblChief;
@property (weak, nonatomic) IBOutlet UILabel *lblChiefValue;
@property (weak, nonatomic) IBOutlet UILabel *lblStoreNo;

@property (weak, nonatomic) IBOutlet UILabel *lblWorkihgHours;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkingDays;
@property (weak, nonatomic) IBOutlet UILabel *lblSaturday;
@property (weak, nonatomic) IBOutlet UILabel *lblSunday;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkingDaysValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSaturdayValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSundayValue;

@property (weak, nonatomic) IBOutlet UIButton *buttonPhoneNo;
@property (weak, nonatomic) IBOutlet UIButton *buttonShowOnMap;

@property (nonatomic, strong)DMLocation* selectedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(DMLocation *)location;

@end
