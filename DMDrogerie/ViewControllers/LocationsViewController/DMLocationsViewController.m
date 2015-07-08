//
//  DMLocationsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMLocationsViewController.h"
#import "DMLocation.h"
#import "DMStoreDetailsViewController.h"
#import "DMWebViewController.h"

#import "MBProgressHUD.h"
#import "UITableViewController+CustomCells.h"

@interface DMLocationsViewController ()

@property(strong) NSArray* arrLocations;//package containing the complete response

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* dataSource;

@end

@implementation DMLocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andArray:(NSArray *)arr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.arrLocations = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            
            DMLocation* location1 = (DMLocation* )obj1;
            DMLocation* location2 = (DMLocation* )obj2;
            
            
            if (location1.distance.floatValue > location2.distance.floatValue) {
                return NSOrderedDescending;
            }
            else{
                return NSOrderedAscending;
            }
            
        }];
;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  PRODAVNICE" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    UIBarButtonItem* pdfBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(pdfAction)];
    [self.navigationItem setRightBarButtonItem:pdfBtn];
    
    
    [self setupTitles];
    [self setupDataSource];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitles{
    [self setTitle:@"Prodavnice"];
    
    
    [self.lblOnlyOpen setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.lblOnlyOpen setTextColor:[UIColor grayColor]];
    [self.lblOnlyOpen setText:@"Sve prodavnice"];
}

- (void)pdfAction{
    DMWebViewController* webView = [[DMWebViewController alloc] initAndShowPDFWithNibName:@"DMWebViewController" bundle:[NSBundle mainBundle]];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navCon animated:YES completion:nil];
}

- (IBAction)switchValueChanged:(id)sender {
    [self setupDataSource];
    
    if (![sender isOn]) {
        [self.lblOnlyOpen setText:@"Samo otvorene prodavnice"];
    }
    else{
        [self.lblOnlyOpen setText:@"Sve prodavnice"];
    }
}

- (void)setupDataSource{
    if (!self.switchOnlyOpen.isOn) {
        NSMutableArray* arr = [NSMutableArray array];
        for (DMLocation* location in self.arrLocations) {
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit | NSHourCalendarUnit fromDate:[NSDate date]];
            int weekday = [comps weekday];
            if (weekday == 1) {
                if (location.sundayHours.length != 0) {
                    NSArray* strComps = [location.sundayHours componentsSeparatedByString:@"-"];
                    NSString* startHour = [[strComps objectAtIndex:0] substringToIndex:2];
                    NSString* endHour = [[strComps objectAtIndex:1] substringToIndex:2];
                    int hour = [comps hour];
                    if (hour > (startHour.intValue - 1) && hour < endHour.intValue) {
                        [arr addObject:location];
                    }
                }
            }
            else if (weekday == 7) {
                if (location.saturdayHours.length != 0) {
                    NSArray* strComps = [location.saturdayHours componentsSeparatedByString:@"-"];
                    NSString* startHour = [[strComps objectAtIndex:0] substringToIndex:2];
                    NSString* endHour = [[strComps objectAtIndex:1] substringToIndex:2];
                    int hour = [comps hour];
                    if (hour > (startHour.intValue - 1) && hour < endHour.intValue) {
                        [arr addObject:location];
                    }
                }
            }
            else{
                if (location.workingHours.length != 0) {
                    NSArray* strComps = [location.workingHours componentsSeparatedByString:@"-"];
                    NSString* startHour = [[strComps objectAtIndex:0] substringToIndex:2];
                    NSString* endHour = [[strComps objectAtIndex:1] substringToIndex:2];
                    int hour = [comps hour];
                    if (hour > (startHour.intValue - 1) && hour < endHour.intValue) {
                        [arr addObject:location];
                    }
                }
            }
            
        }
        
        self.dataSource = [NSArray arrayWithArray:arr];
    }
    else{
        self.dataSource = [NSArray arrayWithArray:self.arrLocations];
    }
    
    [self.tableView reloadData];
}

- (BOOL)isLocationWorking:(DMLocation* )location{
    BOOL isOpen = NO;
    
    if (location.nrd.length > 0 && location.nsrv.length == 0) {
        return isOpen;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit | NSHourCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    if (weekday == 1) {
        if (location.sundayHours.length != 0) {
            NSArray* strComps = [location.sundayHours componentsSeparatedByString:@"-"];
            NSString* startHour = [[strComps objectAtIndex:0] substringToIndex:2];
            NSString* endHour = [[strComps objectAtIndex:1] substringToIndex:2];
            int hour = [comps hour];
            if (hour > (startHour.intValue - 1) && hour < endHour.intValue) {
                isOpen = YES;
            }
        }
    }
    else if (weekday == 7) {
        if (location.saturdayHours.length != 0) {
            NSArray* strComps = [location.saturdayHours componentsSeparatedByString:@"-"];
            NSString* startHour = [[strComps objectAtIndex:0] substringToIndex:2];
            NSString* endHour = [[strComps objectAtIndex:1] substringToIndex:2];
            int hour = [comps hour];
            if (hour > (startHour.intValue - 1) && hour < endHour.intValue) {
                isOpen = YES;
            }
        }
    }
    else{
        if (location.workingHours.length != 0) {
            NSArray* strComps = [location.workingHours componentsSeparatedByString:@"-"];
            NSString* startHour = [[strComps objectAtIndex:0] substringToIndex:2];
            NSString* endHour = [[strComps objectAtIndex:1] substringToIndex:2];
            int hour = [comps hour];
            if (hour > (startHour.intValue - 1) && hour < endHour.intValue) {
                isOpen = YES;
            }
        }
    }
    
    
    return isOpen;
}


#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [Helper getStringFromStr:@"LocationsCellIdentifier"];
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
		
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        [lblTitle setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:16.0]]];
        [lblTitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
        
        UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
        [lblDescription setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
        [lblDescription setTextColor:[UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1.0]];
        
        UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
        [lblDate setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
        [lblDate setTextColor:[UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1.0]];
        
	}
	
	DMLocation* location = [_dataSource objectAtIndex:indexPath.row];
    
	
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
	[lblTitle setText:location.street];
	
	UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
	[lblDescription setText:location.city];
	
	UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
	[lblDate setText:[NSString stringWithFormat:@"Udaljenost: %@ km", [location.distance stringByReplacingOccurrencesOfString:@"." withString:@","]]];
	
    UIImageView* imgView = (UIImageView *)[cell viewWithTag:10];
    
    if ([self isLocationWorking:location]) {
        [imgView setImage:[UIImage imageNamed:@"Checked.png"]];
    }
    else{
        [imgView setImage:[UIImage imageNamed:@"delet.png"]];
    }
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return 50.0;
    }
    else{
        return 80.0;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DMLocation* loc = [self.dataSource objectAtIndex:indexPath.row];
    
    BOOL inStatistics = NO;
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* mArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    for (DMStatistics* stats in mArr) {
        if ([stats.objectId isEqualToString:loc.objectId] && [stats.category isEqualToString:@"LOK"]) {
            stats.brPrik = [NSString stringWithFormat:@"%d", stats.brPrik.intValue + 1];
            [mArr replaceObjectAtIndex:[mArr indexOfObject:stats] withObject:stats];
            inStatistics = YES;
            break;
        }
    }
    
    if (!inStatistics) {
        NSDate* date = [NSDate date];
        
        NSDateFormatter* formateer = [[NSDateFormatter alloc] init];
        [formateer setDateFormat:@"dd.MM.yyyy."];
        NSString* strDate = [formateer stringFromDate:date];
        
        DMStatistics* stat = [[DMStatistics alloc] initWithDictionary:@{@"category": @"LOK",
                                                                        @"date": strDate,
                                                                        @"objectId": loc.objectId}];
        stat.brPrik = [NSString stringWithFormat:@"%d", stat.brPrik.intValue + 1];
        
        [mArr addObject:stat];
    }
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:mArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kStatistics];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DMStoreDetailsViewController* storeDetailsVC = [[DMStoreDetailsViewController alloc] initWithNibName:[Helper getStringFromStr:@"DMStoreDetailsViewController"] bundle:[NSBundle mainBundle] andLocation:loc];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:storeDetailsVC];
    [self presentViewController:navCon animated:YES completion:nil];
}

@end
