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
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import "UITableViewController+CustomCells.h"
#import "MBProgressHUD.h"


@interface DMMainViewController ()

@property(strong) NSMutableArray* arrAktuelnosti;//package containing the complete response
@property(strong) NSMutableDictionary *currentDictionary;//current section being parsed
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property(strong) NSMutableString *outstring;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [self getData];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  VIJESTI I AKTUELNOSTI" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.dataSource.count == 0) {
        [self getData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    
    NSMutableURLRequest* req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"http://www.dmbih.com/AktuelnostiData/aktuelnosti.xml" parameters:nil error:nil];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [op setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
		NSLog(@"Success");
        
        NSXMLParser* parser = (NSXMLParser*)responseObject;
        parser.delegate = self;
        [parser parse];
        
	}failure:^(AFHTTPRequestOperation *operation, NSError *error){
		NSLog(@"Error");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error.code == -1009) {
            NSLog(@"No internet");
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Obaveštenje" message:@"Trenutno se ne mogu preuzeti podaci. Molimo Vas pokušajte kasnije" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
	}];
	
	[op start];
}


#pragma mark - AFXMLRequestOperationDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    self.arrAktuelnosti = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict  {
    
    
    
    self.previousElementName = self.elementName;
    
    if (elementName) {
        self.elementName = elementName;
    }
    
    if([elementName isEqualToString:@"aktuelnost"]){
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
    self.outstring = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!self.elementName){
        return;
    }
    
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    if([elementName isEqualToString:@"aktuelnost"]){
        
        // Initalise the list of weather items if it dosnt exist
        
        DMAktuelnost* akt = [[DMAktuelnost alloc] initWithDictionary:self.currentDictionary];
        [self.arrAktuelnosti addObject:akt];
        
        self.currentDictionary = nil;
    }
    else if([elementName isEqualToString:@"idAkt"] ||
            [elementName isEqualToString:@"naslov"] ||
            [elementName isEqualToString:@"opis"] ||
            [elementName isEqualToString:@"det_op"] ||
            [elementName isEqualToString:@"vreme"] ||
            [elementName isEqualToString:@"akt"] ||
            [elementName isEqualToString:@"sl_l"] ||
            [elementName isEqualToString:@"sl_d"] ||
            [elementName isEqualToString:@"linkA"]){
        [self.currentDictionary setObject:self.outstring forKey:elementName];
    }
    
	self.elementName = nil;
}



-(void) parserDidEndDocument:(NSXMLParser *)parser {
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    

    
    self.dataSource = [self.arrAktuelnosti sortedArrayUsingComparator:^NSComparisonResult(DMAktuelnost* obj1, DMAktuelnost* obj2){
        NSDateFormatter* formateer = [[NSDateFormatter alloc] init];
        [formateer setDateFormat:@"dd.MM.yyyy. HH:mm:ss"];
        
        NSDate* dt1 = [formateer dateFromString:obj1.time];
        NSDate* dt2 = [formateer dateFromString:obj2.time];
        
        NSComparisonResult res = [dt2 compare:dt1];
        
        return res;
    }];
    
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
	[lblDescription setText:akt.description];
	
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
    
    [self.navigationController presentViewController:navCon animated:YES completion:nil];
    
}

@end
