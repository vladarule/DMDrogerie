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
@property (weak, nonatomic) IBOutlet UIView *secondView;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;

@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle2;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription2;

@property (weak, nonatomic) IBOutlet UILabel *lblBefore;
@property (weak, nonatomic) IBOutlet UILabel *lblBefore2;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice2;

@property (weak, nonatomic) IBOutlet UILabel *lblSaving;
@property (weak, nonatomic) IBOutlet UILabel *lblSaving2;

@property (weak, nonatomic) IBOutlet UILabel *lblActiveTo;
@property (weak, nonatomic) IBOutlet UILabel *lblActiveTo2;

@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex2;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount2;


@property (weak, nonatomic) IBOutlet UILabel *lblRef;
@property (weak, nonatomic) IBOutlet UILabel *lblRef2;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;

@property (weak, nonatomic) IBOutlet UIButton *buttonAddToCart;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddToCart2;

@property (weak, nonatomic) IBOutlet UILabel *lblKM;
@property (weak, nonatomic) IBOutlet UILabel *lblKm2;



@property (nonatomic, strong)NSArray* dataSource;
@property (nonatomic, assign)int selectedIndex;

@end
