//
//  DMOfferDetailsViewController.h
//  DMDrogerie
//
//  Created by Vlada on 2/12/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMOffer.h"

@interface DMOfferDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblItems;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIButton *buttonAddToCart;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewOffer;


@property (nonatomic, strong)DMOffer* selectedOffer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSelectedOffer:(DMOffer *)selectedOffer;

@end
