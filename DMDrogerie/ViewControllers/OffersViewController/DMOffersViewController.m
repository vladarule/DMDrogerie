//
//  DMOffersViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMOffersViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

#import "DMOffer.h"
#import "DMOfferDetailsViewController.h"

#import "UITableViewController+CustomCells.h"
#import "MBProgressHUD.h"



@interface DMOffersViewController ()

@property(strong) NSMutableArray* arrOffers;//package containing the complete response
@property(strong) NSMutableDictionary *currentDictionary;//current section being parsed
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property(strong) NSMutableString *outstring;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableURLRequest* req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"http://www.dmbih.com/PonudeData/ponude.xml" parameters:nil error:nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
	AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [op setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
		NSLog(@"Success");
        
        NSXMLParser* parser = (NSXMLParser*)responseObject;
        parser.delegate = self;
        [parser parse];
        
	}failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		NSLog(@"Error");
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
    self.arrOffers = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict  {
    
    
    
    self.previousElementName = self.elementName;
    
    if (elementName) {
        self.elementName = elementName;
    }
    
    if([elementName isEqualToString:@"ponuda"]){
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
    
    
    if([elementName isEqualToString:@"ponuda"]){
        
        // Initalise the list of weather items if it dosnt exist
        
        DMOffer* offer = [[DMOffer alloc] initWithDictionary:self.currentDictionary];
        [self.arrOffers addObject:offer];
        
        self.currentDictionary = nil;
    }
    else if([elementName isEqualToString:@"idPon"] ||
            [elementName isEqualToString:@"naslov"] ||
            [elementName isEqualToString:@"opis"] ||
            [elementName isEqualToString:@"det_op"] ||
            [elementName isEqualToString:@"vreme"] ||
            [elementName isEqualToString:@"cen"] ||
            [elementName isEqualToString:@"kol"] ||
            [elementName isEqualToString:@"akt"] ||
            [elementName isEqualToString:@"sl_l"] ||
            [elementName isEqualToString:@"sl_d"]){
        [self.currentDictionary setObject:self.outstring forKey:elementName];
    }
    
	self.elementName = nil;
}



-(void) parserDidEndDocument:(NSXMLParser *)parser {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.dataSource = [NSArray arrayWithArray:self.arrOffers];
    [self.tableView reloadData];
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
	
	DMOffer *offer = [_dataSource objectAtIndex:indexPath.row];
	
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
	[lblTitle setText:offer.title];
	
	UILabel *lblDescription = (UILabel *)[cell viewWithTag:2];
	[lblDescription setText:offer.description];
	
	UILabel *lblDate = (UILabel *)[cell viewWithTag:3];
	[lblDate setText:offer.activeTo];
    
    
    UIImageView* imgView = (UIImageView *)[cell viewWithTag:4];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, offer.imageSmall]]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 110.0;
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
    
    DMOfferDetailsViewController* offerDetVC = [[DMOfferDetailsViewController alloc] initWithNibName:@"DMOfferDetailsViewController" bundle:[NSBundle mainBundle] andSelectedOffer:selOffer];
    
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:offerDetVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
}

@end
