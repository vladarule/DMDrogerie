//
//  DMPromotionDetailsViewController.h
//  DMDrogerie
//
//  Created by Vlada on 3/14/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPromotion.h"

@interface DMPromotionDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPromotion:(DMPromotion *)promotion;

@end
