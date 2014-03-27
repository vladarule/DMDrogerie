//
//  DMDiscountsViewController.h
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDiscountsViewController : UIViewController<NSXMLParserDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIView *mainView;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblBefore;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblSaving;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveTo;

@property (weak, nonatomic) IBOutlet UILabel *lblIndex;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblRef;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *buttonAddToCart;
@property (weak, nonatomic) IBOutlet UILabel *lblKM;



@property (nonatomic, strong)NSArray* dataSource;
@property (nonatomic, assign)int selectedIndex;

@end
