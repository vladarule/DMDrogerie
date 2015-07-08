//
//  DMOffersViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMOffersViewController.h"
#import "UIKit+AFNetworking.h"

#import "DMOffer.h"
#import "DMOfferDetailsViewController.h"

#import "UITableViewController+CustomCells.h"
#import "MBProgressHUD.h"



@interface DMOffersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;


@end

@implementation DMOffersViewController

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
        
        self.dataSource = [arr sortedArrayUsingComparator:^NSComparisonResult(DMOffer* obj1, DMOffer* obj2){
            NSDateFormatter* formateer = [[NSDateFormatter alloc] init];
            [formateer setDateFormat:@"dd.MM.yyyy. HH:mm:ss"];
            
            NSDate* dt1 = [formateer dateFromString:obj1.time];
            NSDate* dt2 = [formateer dateFromString:obj2.time];
            
            NSComparisonResult res = [dt2 compare:dt1];
            
            return res;
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  NOVO" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [Helper getStringFromStr:@"AktuelnostiCellIdentifier"];
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
        
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        [lblTitle setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
        [lblTitle setTextColor:[UIColor colorWithRed:248.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        [lblTitle setNumberOfLines:2];
        
        UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
        [lblDescription setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:11.5]]];
        [lblDescription setTextColor:[UIColor blackColor]];
        [lblDescription setNumberOfLines:5];
        
        UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
        [lblDate setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:9.0]]];
        [lblDate setTextColor:[UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1.0]];
	}
	
	DMOffer *offer = [_dataSource objectAtIndex:indexPath.row];
	
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
	[lblTitle setText:offer.title];
	
	UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
	[lblDescription setText:offer.descr];
	
	UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
	[lblDate setText:offer.time];
    
    
    UIImageView* imgView = (UIImageView *)[cell viewWithTag:4];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, offer.imageSmall]]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return 110.0;
    }
    else{
        return 160.0;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    DMOffer* selOffer = [self.dataSource objectAtIndex:indexPath.row];
    
    BOOL inStatistics = NO;
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* mArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    for (DMStatistics* stats in mArr) {
        if ([stats.objectId isEqualToString:selOffer.objectId] && [stats.category isEqualToString:@"PON"]) {
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
        
        DMStatistics* stat = [[DMStatistics alloc] initWithDictionary:@{@"category": @"PON",
                                                                        @"date": strDate,
                                                                        @"objectId": selOffer.objectId}];
        stat.brPrik = [NSString stringWithFormat:@"%d", stat.brPrik.intValue + 1];
       
        [mArr addObject:stat];
    }
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:mArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kStatistics];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DMOfferDetailsViewController* offerDetVC = [[DMOfferDetailsViewController alloc] initWithNibName:[Helper getStringFromStr:@"DMOfferDetailsViewController"] bundle:[NSBundle mainBundle] andSelectedOffer:selOffer];
    
    
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:offerDetVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
}

@end
