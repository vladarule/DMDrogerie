//
//  DMMainViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMMainViewController.h"
#import "DMAktuelnost.h"
#import "DMAktuelnostDetaljiViewController.h"
#import "DMWebViewController.h"

#import "UIKit+AFNetworking.h"

#import "DMRequestManager.h"

#import "UITableViewController+CustomCells.h"
#import "MBProgressHUD.h"


@interface DMMainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblPromoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPromoDesc;



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;

@property (weak, nonatomic) IBOutlet UIView *topNewsView;


@end

@implementation DMMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andArray:(NSArray* )arr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dataSource = [arr sortedArrayUsingComparator:^NSComparisonResult(DMAktuelnost* obj1, DMAktuelnost* obj2){
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
    
    [self.tableView reloadData];
//    [self getData];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  VIJESTI I AKTUELNOSTI" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self.lblPromoTitle setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.lblPromoTitle setTextColor:[UIColor colorWithRed:248.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
    [self.lblPromoTitle setNumberOfLines:2];
    
    [self.lblPromoDesc setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:11.5]]];
    [self.lblPromoDesc setTextColor:[UIColor blackColor]];
    [self.lblPromoDesc setNumberOfLines:5];
    
    
    if (![DMRequestManager sharedManager].promoDict) {
        [self.topNewsView setHidden:YES];
        CGRect fr = self.tableView.frame;
        fr.size.height = fr.size.height + fr.origin.y;
        fr.origin.y = 0;
        
        [self.tableView setFrame:fr];
    }
    else{
        [self.lblPromoTitle setText:[[DMRequestManager sharedManager].promoDict objectForKey:@"naslov"]];
        [self.lblPromoDesc setText:[[DMRequestManager sharedManager].promoDict objectForKey:@"opis"]];
        [self.imgPromo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, [[DMRequestManager sharedManager].promoDict objectForKey:@"slika_mala"]]]];
    }
    

    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
    
    NSDictionary* bannerDict = [DMRequestManager sharedManager].bannerDict;
    if ([[dict objectForKey:@"shouldShow"] boolValue] && bannerDict) {
        DMWebViewController* webView = [[DMWebViewController alloc] initWithNibName:@"DMWebViewController" bundle:[NSBundle mainBundle] andAdDict:bannerDict];
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:webView];
        [self presentViewController:navCon animated:YES completion:^{
            NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mDict setObject:[NSNumber numberWithBool:NO] forKey:@"shouldShow"];
            [[NSUserDefaults standardUserDefaults] setObject:mDict forKey:@"banner"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnHeaderClicked:(id)sender {
    //    {"tab":"4","vrsta":"tab","naslov":"dm Hair Color Expert","opis":"\u017delite novu boju za kose?! Uslikajte se i testirajte kako Vam stoji \u017eeljena nijansa!","det_opis":" ","aktivan_do":"2015-02-28","slika_mala":"PopupSlike\/SlikeMale\/3.png","slika_velika":"","link":""}
    
    if ([[[DMRequestManager sharedManager].promoDict objectForKey:@"vrsta"] isEqualToString:@"tab"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tab_clicked" object:nil];
//        [self.navigationController.tabBarController setSelectedIndex:[[[DMRequestManager sharedManager].promoDict objectForKey:@"tab"] integerValue]];
    }
    else{
//        "naslov": "dm Hair Color Expert",
//        "opis": "Å½elite novu boju za kose?! Uslikajte se i testirajte kako Vam stoji Å¾eljena nijansa!",
//        "det_opis": " ",
//        "aktivan_do": "2015-02-28",
//        "slika_mala": "PopupSlike/SlikeMale/3.png",
//        "slika_velika": "PopupSlike/SlikeVelike/1.jpg",
//        "link": ""
        DMAktuelnost* akt = [[DMAktuelnost alloc] init];
        akt.title = [[DMRequestManager sharedManager].promoDict objectForKey:@"naslov"];
        akt.descr = [[DMRequestManager sharedManager].promoDict objectForKey:@"opis"];
        akt.detailDescription = [[DMRequestManager sharedManager].promoDict objectForKey:@"det_opis"];
        akt.activeTo = [[DMRequestManager sharedManager].promoDict objectForKey:@"aktivan_do"];
        akt.imageSmall = [[DMRequestManager sharedManager].promoDict objectForKey:@"slika_mala"];
        akt.imageBig = [[DMRequestManager sharedManager].promoDict objectForKey:@"slika_velika"];
        akt.link = [[DMRequestManager sharedManager].promoDict objectForKey:@"link"];
        
        DMAktuelnostDetaljiViewController* aktVC = [[DMAktuelnostDetaljiViewController alloc] initWithNibName:[Helper getStringFromStr:@"DMAktuelnostDetaljiViewController"] bundle:[NSBundle mainBundle] andAktuelnost:akt];
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:aktVC];
        
        [self.navigationController presentViewController:navCon animated:YES completion:nil];
        
    }
    
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
	
	DMAktuelnost *akt = [_dataSource objectAtIndex:indexPath.row];
    
	
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
	[lblTitle setText:akt.title];
	
	UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
	[lblDescription setText:akt.descr];
	
	UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
	[lblDate setText:akt.time];
    
    UIImageView* imgView = (UIImageView * )[cell viewWithTag:4];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, akt.imageSmall]]];
	
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
    DMAktuelnost* aktuelnost = [self.dataSource objectAtIndex:indexPath.row];
    
    BOOL inStatistics = NO;
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* mArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    for (DMStatistics* stats in mArr) {
        if ([stats.objectId isEqualToString:aktuelnost.objectId] && [stats.category isEqualToString:@"AKT"]) {
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
        DMStatistics* stat = [[DMStatistics alloc] initWithDictionary:@{@"category": @"AKT",
                                                                        @"date": strDate,
                                                                        @"objectId": aktuelnost.objectId}];
        stat.brPrik = [NSString stringWithFormat:@"%d", stat.brPrik.intValue + 1];
        
        [mArr addObject:stat];
    }
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:mArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kStatistics];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DMAktuelnostDetaljiViewController* aktVC = [[DMAktuelnostDetaljiViewController alloc] initWithNibName:[Helper getStringFromStr:@"DMAktuelnostDetaljiViewController"] bundle:[NSBundle mainBundle] andAktuelnost:aktuelnost];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:aktVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
}

@end
