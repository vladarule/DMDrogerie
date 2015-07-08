//
//  DMHairImgShareViewController.m
//  DMDrogerie
//
//  Created by Vlada on 5/26/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMHairImgShareViewController.h"

#import "UIKit+AFNetworking.h"

@interface DMHairImgShareViewController ()

@property (nonatomic, strong)DMHairColorManufacturer* colorManufacturer;
@property (nonatomic, strong)DMHairColor* hairColor;
@property (nonatomic, strong)UIImage* finalImage;

@property (nonatomic, strong)UIActivityViewController* activityVC;

@end

@implementation DMHairImgShareViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil finalImage:(UIImage *)final manafacturer:(DMHairColorManufacturer *)man andColor:(DMHairColor *)color{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.finalImage = final;
        self.colorManufacturer = man;
        self.hairColor = color;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  HAIR COLOR EXPERT" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    UIBarButtonItem* btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nail_share.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnShareClicked:)];
    
    [self.navigationItem setRightBarButtonItem:btnShare];
    
    [self.imgViewHair setImage:self.finalImage];
    [self.imgViewHairColor setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.colorManufacturer.imgUrl]]];
    [self.lblHairColor setText:self.hairColor.name];
//    
//    NSLog(@"img url tex %@, frame %d %d", self.colorManufacturer.imgUrl, self.imgViewHairColor.frame.origin.x, self.imgViewHairColor.frame.origin.y);
    
    
    self.activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[self snapshot:self.view]] applicationActivities:nil];
    [self.activityVC setValue:NSLocalizedString(@"DM BiH", @"") forKey:@"subject"];
    
    [self.activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        //        if (completed) {
        //           if (activityType.length == 0) {
        //     }
        //        }
    }];
    
    NSArray* exclude = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [self.activityVC setExcludedActivityTypes:exclude];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self presentViewController:self.activityVC animated:YES completion:nil];
    
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)buttonCancelClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnShareClicked:(id)sender{
    [self presentViewController:self.activityVC animated:YES completion:nil];
}

@end
