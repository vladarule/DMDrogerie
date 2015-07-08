//
//  DMStoreDetailsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/13/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMStoreDetailsViewController.h"
#import "DMMapViewController.h"

@interface DMStoreDetailsViewController ()


@property (weak, nonatomic) IBOutlet UILabel *lblNrd;

- (void)setupTitles;

@end

@implementation DMStoreDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLocation:(DMLocation *)location{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedLocation = location;
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
    [btn setTitle:@"  PRODAVNICA" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
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
    
    [self.lblAdress setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:14.5]]];
    [self.lblAdress setMinimumScaleFactor:0.4];
    [self.lblAdress setTextColor:[UIColor whiteColor]];
    
    [self.lblCity setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblCity setTextColor:[UIColor yellowColor]];
    
    [self.lblChief setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblChief setTextColor:[UIColor whiteColor]];
    
    [self.lblChiefValue setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblChiefValue setTextColor:[UIColor whiteColor]];
    
    [self.lblStoreNo setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblStoreNo setTextColor:[UIColor whiteColor]];
    
    [self.lblWorkihgHours setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.lblWorkihgHours setTextColor:[UIColor whiteColor]];
    
    [self.lblWorkingDays setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:13.0]]];
    [self.lblWorkingDays setTextColor:[UIColor whiteColor]];
    
    [self.lblSaturday setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:13.0]]];
    [self.lblSaturday setTextColor:[UIColor whiteColor]];
    
    [self.lblSunday setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:13.0]]];
    [self.lblSunday setTextColor:[UIColor whiteColor]];
    
    [self.lblWorkingDaysValue setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblWorkingDaysValue setTextColor:[UIColor yellowColor]];
    
    [self.lblSaturdayValue setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblSaturdayValue setTextColor:[UIColor yellowColor]];
    
    [self.lblSundayValue setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblSundayValue setTextColor:[UIColor yellowColor]];
    
    [self.lblNrd setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
    [self.lblNrd setTextColor:[UIColor yellowColor]];
    
    [self.lblAdress setText:self.selectedLocation.street];
    [self.lblCity setText:self.selectedLocation.city];
    [self.lblChief setText:NSLocalizedString(@"Poslovođa/Poslovotkinja:", @"")];
    [self.lblChiefValue setText:self.selectedLocation.chief];
    [self.lblStoreNo setText:[NSString stringWithFormat:@"Broj prodavnice: %@", self.selectedLocation.prod]];
    
    [self.lblWorkihgHours setText:NSLocalizedString(@"RADNO VRIJEME:", @"")];
    [self.lblWorkingDays setText:NSLocalizedString(@"PON-PET", @"")];
    [self.lblSaturday setText:NSLocalizedString(@"SUBOTA", @"")];
    [self.lblSunday setText:NSLocalizedString(@"NEDELJA", @"")];
    
    
    [self.lblWorkingDaysValue setText:self.selectedLocation.workingHours];
    if (self.selectedLocation.workingHours.length == 0) {
        [self.lblWorkingDaysValue setText:@"Ne radi"];
    }
    
    [self.lblSaturdayValue setText:self.selectedLocation.saturdayHours];
    if (self.selectedLocation.saturdayHours.length == 0) {
        [self.lblSaturdayValue setText:@"Ne radi"];
    }
    
    [self.lblSundayValue setText:self.selectedLocation.sundayHours];
    if (self.selectedLocation.sundayHours.length == 0) {
        [self.lblSundayValue setText:@"Ne radi"];
    }
    
    if (self.selectedLocation.nrd.length == 0) {
        [self.lblNrd setText:@""];
    }
    else{
        [self.lblNrd setText:self.selectedLocation.nrd];
    }
    
    [self.buttonPhoneNo.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.5]]];
    [self.buttonPhoneNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonPhoneNo setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:5.0], 0, 0)];
    
    [self.buttonShowOnMap.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.5]]];
    [self.buttonShowOnMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonShowOnMap setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:5.0], 0, 0)];
    
    [self.buttonPhoneNo setTitle:[NSString stringWithFormat:@"Telefon: %@", self.selectedLocation.phoneNo] forState:UIControlStateNormal];
    [self.buttonShowOnMap setTitle:@"Prikaži na mapi" forState:UIControlStateNormal];
    
    
}

- (void)buttonCancelClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonPhoneNoClicked:(id)sender {
    NSData* statsData = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* statsArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:statsData]];
    for (DMStatistics* stats in statsArr) {
        if ([stats.objectId isEqualToString:self.selectedLocation.objectId] && [stats.category isEqualToString:@"LOK"]) {
            stats.brTel = [NSString stringWithFormat:@"%d", stats.brTel.intValue + 1];
            [statsArr replaceObjectAtIndex:[statsArr indexOfObject:stats] withObject:stats];
            break;
        }
    }
    
    NSData *myEncodedStats = [NSKeyedArchiver archivedDataWithRootObject:statsArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedStats forKey:kStatistics];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.selectedLocation.phoneNo]]];
}

- (IBAction)buttonShowOnMapClicked:(id)sender {
    
    NSData* statsData = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* statsArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:statsData]];
    for (DMStatistics* stats in statsArr) {
        if ([stats.objectId isEqualToString:self.selectedLocation.objectId] && [stats.category isEqualToString:@"LOK"]) {
            stats.brMap = [NSString stringWithFormat:@"%d", stats.brMap.intValue + 1];
            [statsArr replaceObjectAtIndex:[statsArr indexOfObject:stats] withObject:stats];
            break;
        }
    }
    
    NSData *myEncodedStats = [NSKeyedArchiver archivedDataWithRootObject:statsArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedStats forKey:kStatistics];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.navigationItem.backBarButtonItem.title = @"";
    [self setTitle:@""];
    DMMapViewController* mapVC = [[DMMapViewController alloc] initWithNibName:@"DMMapViewController" bundle:[NSBundle mainBundle] andLocation:self.selectedLocation];
    [self.navigationController pushViewController:mapVC animated:YES];
    
}


@end
