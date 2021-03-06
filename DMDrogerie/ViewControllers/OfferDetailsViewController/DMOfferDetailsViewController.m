//
//  DMOfferDetailsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/12/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMOfferDetailsViewController.h"
#import "UIKit+AFNetworking.h"
#import "MBProgressHUD.h"

@interface DMOfferDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgDm;

- (void)setupTitles;


@end

@implementation DMOfferDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSelectedOffer:(DMOffer *)selectedOffer{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.selectedOffer = selectedOffer;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  NOVO" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    UIBarButtonItem* btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nail_share.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnShareClicked)];
    
    [self.navigationItem setRightBarButtonItem:btnShare];
    
    [self setupTitles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitles{
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    [self.lblName setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:19.0]]];
    [self.lblName setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblPrice setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:16.0]]];
    [self.lblPrice setTextColor:[UIColor whiteColor]];
    
    [self.lblItems setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.lblItems setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblDescription setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:11.5]]];
    [self.lblDescription setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    [self.lblDescription setMinimumScaleFactor:0.2];
    
    [self.buttonAddToCart.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.buttonAddToCart setTitleColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.buttonAddToCart setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:18.0], 0, 0)];
    [self.buttonAddToCart setTitle:@"Dodaj u shopping listu" forState:UIControlStateNormal];
    
    
    [self.lblName setText:self.selectedOffer.title];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@", self.selectedOffer.price]];
    [self.lblItems setText:self.selectedOffer.quantity];
    [self.lblDescription setText:self.selectedOffer.detailDescription];
    
    [self.imgViewOffer setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.selectedOffer.imageBig]]];
    
    if ([self.selectedOffer.isNew boolValue]) {
        [self.imgDm setHidden:NO];
    }
    else{
        [self.imgDm setHidden:YES];
    }
}

- (void)btnShareClicked{
    NSURL* URL = [NSURL URLWithString:self.selectedOffer.link];
    
    
    
    
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[NSString stringWithFormat:@"Novo u DM-u %@", self.selectedOffer.title], URL] applicationActivities:nil];
    [activityVC setValue:NSLocalizedString(@"DM BiH", @"") forKey:@"subject"];
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
    
    }];
    
    
    
    NSArray* exclude = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [activityVC setExcludedActivityTypes:exclude];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)buttonCancelClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonAddtoCartClicked:(id)sender {
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedItems];
    
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray* mArr = [NSMutableArray arrayWithArray:arr];
    [mArr addObject:self.selectedOffer];
    
    
   NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:mArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
    
    
    NSData* statsData = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* statsArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:statsData]];
    for (DMStatistics* stats in statsArr) {
        if ([stats.objectId isEqualToString:self.selectedOffer.objectId] && [stats.category isEqualToString:@"PON"]) {
            stats.brDod = [NSString stringWithFormat:@"%d", stats.brDod.intValue + 1];
            [statsArr replaceObjectAtIndex:[statsArr indexOfObject:stats] withObject:stats];
            break;
        }
    }
    
    NSData *myEncodedStats = [NSKeyedArchiver archivedDataWithRootObject:statsArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedStats forKey:kStatistics];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"";
    hud.detailsLabelText = [NSString stringWithFormat:@"Proizvod %@ dodat u shopping listu", self.selectedOffer.title];
    hud.margin = 10.f;
    hud.yOffset = 120.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}


@end
