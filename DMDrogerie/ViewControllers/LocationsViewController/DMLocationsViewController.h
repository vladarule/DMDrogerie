//
//  DMLocationsViewController.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLocationsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblOnlyOpen;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnlyOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andArray:(NSArray *)arr;

@end
