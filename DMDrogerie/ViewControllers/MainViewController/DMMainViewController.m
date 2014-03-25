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
	}];
	
	[op start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.dataSource = [NSArray arrayWithArray:self.arrAktuelnosti];
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
	static NSString *CellIdentifier = @"AktuelnostiCellIdentifier";
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
	
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        [lblTitle setFont:[UIFont systemFontOfSize:14.0]];
        [lblTitle setTextColor:[UIColor colorWithRed:248.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        [lblTitle setNumberOfLines:2];
        
        UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
        [lblDescription setFont:[UIFont systemFontOfSize:11.5]];
        [lblDescription setTextColor:[UIColor blackColor]];
        [lblDescription setNumberOfLines:5];
        
        UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
        [lblDate setFont:[UIFont systemFontOfSize:9.0]];
        [lblDate setTextColor:[UIColor colorWithRed:147.0/255 green:147.0/255 blue:147.0/255 alpha:1.0]];
	}
	
	DMAktuelnost *akt = [_dataSource objectAtIndex:indexPath.row];
    
	
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
	[lblTitle setText:akt.title];
	
	UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
	[lblDescription setText:akt.description];
	
	UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
	[lblDate setText:akt.activeTo];
    
    UIImageView* imgView = (UIImageView * )[cell viewWithTag:4];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, akt.imageSmall]]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.0;
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
    
    DMAktuelnostDetaljiViewController* aktVC = [[DMAktuelnostDetaljiViewController alloc] initWithNibName:@"DMAktuelnostDetaljiViewController" bundle:[NSBundle mainBundle] andAktuelnost:aktuelnost];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:aktVC];
    
    [self.navigationController presentViewController:navCon animated:YES completion:nil];
    
}

@end
