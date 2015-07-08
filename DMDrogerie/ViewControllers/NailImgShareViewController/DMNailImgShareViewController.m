//
//  DMNailImgShareViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/21/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMNailImgShareViewController.h"

#import "UIKit+AFNetworking.h"

@interface DMNailImgShareViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHand;
@property (strong, nonatomic)UIImage* imgToShare;

@property (nonatomic, strong)UIImage* nailImg;
@property (nonatomic, strong)NSDictionary* colorDict;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewManufacturer;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewColor;
@property (weak, nonatomic) IBOutlet UILabel *lblManufacturer;
@property (weak, nonatomic) IBOutlet UILabel *lblColor;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (nonatomic, strong)UIActivityViewController* activityVC;

@end

@implementation DMNailImgShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)img andColorDict:(NSDictionary *)dict{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.nailImg = img;
        self.colorDict = dict;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.imgHand setImage:self.nailImg];
    
    
    
//    [self.imgViewColor setBackgroundColor:[self getColorFromArray:[NSArray arrayWithArray:[[self.colorDict objectForKey:@"colorDict"] objectForKey:@"kod"]]]];
    [self.lblColor setText:[[self.colorDict objectForKey:@"colorDict"] objectForKey:@"naziv"]];
    [self.lblManufacturer setText:[self.colorDict objectForKey:@"manufacturerName"]];
    NSString* imgURl = [self.colorDict objectForKey:@"manufacturerLogo"];
    [self.imgViewManufacturer setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, imgURl]]];
    
    [self.btnCancel setHidden:YES];
    [self.btnShare setHidden:YES];
    
    self.imgToShare = [self snapshot:self.view];
    
    [self.btnCancel setHidden:NO];
    [self.btnShare setHidden:NO];
    
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

- (IBAction)btnCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShareClicked:(id)sender {
    
    
    [self presentViewController:self.activityVC animated:YES completion:nil];
}

- (UIColor *)getColorFromArray:(NSArray *)array{
    float red = [[array objectAtIndex:0] floatValue];
    float green = [[array objectAtIndex:1] floatValue];
    float blue = [[array objectAtIndex:2] floatValue];
    float alpha = [[array objectAtIndex:3] floatValue];
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
    
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
