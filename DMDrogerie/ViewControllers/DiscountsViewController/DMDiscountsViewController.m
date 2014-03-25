//
//  DMDiscountsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMDiscountsViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "DMDiscount.h"
#import "MBProgressHUD.h"



@interface DMDiscountsViewController ()

@property(strong) NSMutableArray* arrDiscounts;//package containing the complete response
@property(strong) NSMutableDictionary *currentDictionary;//current section being parsed
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property(strong) NSMutableString *outstring;

@end

@implementation DMDiscountsViewController

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
    
    
    UISwipeGestureRecognizer* gRecognizerSwipedLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    [gRecognizerSwipedLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [gRecognizerSwipedLeft setDelegate:self];
    
    UISwipeGestureRecognizer* gRecognizerSwipedRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [gRecognizerSwipedRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [gRecognizerSwipedRight setDelegate:self];
    
    [self.mainView addGestureRecognizer:gRecognizerSwipedLeft];
    [self.mainView addGestureRecognizer:gRecognizerSwipedRight];
    
    
    
    
    NSMutableURLRequest* req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:@"http://www.dmbih.com/PopustiData/popusti.xml" parameters:nil error:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    
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


- (void)setupValues{
    DMDiscount* discount = [self.dataSource objectAtIndex:self.selectedIndex];
    [self.lblTitle setText:discount.item];
    [self.lblSubtitle setText:discount.name];
    [self.lblDescription setText:discount.quantity];
//    [self.lblDescription setHidden:YES];
    [self.lblBefore setText:[NSString stringWithFormat:@"Redovna: %@", discount.oldPrice]];
    [self.lblPrice setText:[NSString stringWithFormat:@"%@ KM", discount.nwPrice]];
    [self.lblSaving setText:[NSString stringWithFormat:@"Ustedite: %@", discount.saving]];
    [self.lblActiveTo setText:[NSString stringWithFormat:@"Vrijedi do: %@", discount.activeTo]];
    [self.lblDiscount setText:discount.discount];
    if (discount.ref.intValue == 0) {
        [self.lblRef setHidden:YES];
    }
    else{
        [self.lblRef setHidden:NO];
        [self.lblRef setText:discount.ref];
    }
    
    
    [self.lblIndex setText:[NSString stringWithFormat:@"%d od %d", self.selectedIndex + 1, self.dataSource.count - 1]];
    
    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, discount.image]]];
    
    [self.lblTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [self.lblTitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblSubtitle setFont:[UIFont systemFontOfSize:16]];
    [self.lblSubtitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblDescription setFont:[UIFont systemFontOfSize:15]];
    [self.lblDescription setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblBefore setFont:[UIFont boldSystemFontOfSize:14]];
    [self.lblBefore setMinimumScaleFactor:0.5];
    [self.lblBefore setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblPrice setFont:[UIFont boldSystemFontOfSize:20]];
    [self.lblPrice setTextColor:[UIColor whiteColor]];
    
    [self.lblSaving setFont:[UIFont systemFontOfSize:16]];
    [self.lblSaving setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblActiveTo setFont:[UIFont systemFontOfSize:15]];
    [self.lblActiveTo setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblRef setFont:[UIFont systemFontOfSize:15]];
    [self.lblRef setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblDiscount setFont:[UIFont systemFontOfSize:15]];
    [self.lblDiscount setTextColor:[UIColor redColor]];
    
    
    [self.lblIndex setFont:[UIFont systemFontOfSize:16]];
    [self.lblIndex setTextColor:[UIColor colorWithRed:110.0/255 green:133.0/255 blue:200.0/255 alpha:1.0]];
    
    [self.buttonAddToCart.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.buttonAddToCart setTitleColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.buttonAddToCart setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    [self.buttonAddToCart setTitle:@"Dodaj u shopping listu" forState:UIControlStateNormal];
    
}

- (void)swipedLeft:(UISwipeGestureRecognizer *)gRecognizer{
    
    [self buttonNextClicked:nil];
    
}

- (void)swipedRight:(UISwipeGestureRecognizer *)gRecognizer{
    
    [self buttonPreviousClicked:nil];
    
}

- (IBAction)buttonPreviousClicked:(id)sender {
    
    if (self.selectedIndex > 0) {
        self.selectedIndex--;
        [self setupValues];
    }
    
}

- (IBAction)buttonNextClicked:(id)sender {
    
    if (self.selectedIndex < self.dataSource.count - 1) {
        self.selectedIndex++;
        [self setupValues];
    }
    
}

- (IBAction)buttonAddToCartClicked:(UIButton *)sender {
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedItems];
    
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray* mArr = [NSMutableArray arrayWithArray:arr];
    
    DMDiscount* discount = [self.dataSource objectAtIndex:self.selectedIndex];
    
    [mArr addObject:discount];
    
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:mArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
    
    
    BOOL inStatistics = NO;
    
    NSData* statsData = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* statsArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:statsData]];
    for (DMStatistics* stats in statsArr) {
        if ([stats.objectId isEqualToString:discount.objectId] && [stats.category isEqualToString:@"POP"]) {
            stats.brDod = [NSString stringWithFormat:@"%d", stats.brDod.intValue + 1];
            [statsArr replaceObjectAtIndex:[statsArr indexOfObject:stats] withObject:stats];
            inStatistics = YES;
            break;
        }
    }
    
    if (!inStatistics) {
        NSDate* date = [NSDate date];
        
        NSDateFormatter* formateer = [[NSDateFormatter alloc] init];
        [formateer setDateFormat:@"dd.MM.yyyy."];
        NSString* strDate = [formateer stringFromDate:date];
        DMStatistics* stat = [[DMStatistics alloc] initWithDictionary:@{@"category": @"POP",
                                                                        @"date": strDate,
                                                                        @"objectId": discount.objectId}];
        stat.brDod = [NSString stringWithFormat:@"%d", stat.brDod.intValue + 1];
        
        [statsArr addObject:stat];
    }
    
    NSData *myEncodedStats = [NSKeyedArchiver archivedDataWithRootObject:statsArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedStats forKey:kStatistics];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - AFXMLRequestOperationDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    self.arrDiscounts = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict  {
    
    
    
    self.previousElementName = self.elementName;
    
    if (elementName) {
        self.elementName = elementName;
    }
    
    if([elementName isEqualToString:@"popust"]){
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
    
    
    if([elementName isEqualToString:@"popust"]){
        
        // Initalise the list of weather items if it dosnt exist
        
        DMDiscount* discount = [[DMDiscount alloc] initWithDictionary:self.currentDictionary];
        [self.arrDiscounts addObject:discount];
        self.currentDictionary = nil;
    }
    else if([elementName isEqualToString:@"idPop"] ||
            [elementName isEqualToString:@"naziv"] ||
            [elementName isEqualToString:@"opis"] ||
            [elementName isEqualToString:@"proiz"] ||
            [elementName isEqualToString:@"st_ce"] ||
            [elementName isEqualToString:@"kol"] ||
            [elementName isEqualToString:@"no_ce"] ||
            [elementName isEqualToString:@"ust"] ||
            [elementName isEqualToString:@"pop"] ||
            [elementName isEqualToString:@"akt"] ||
            [elementName isEqualToString:@"sl"] ||
            [elementName isEqualToString:@"ref"]){
        [self.currentDictionary setObject:self.outstring forKey:elementName];
    }

	self.elementName = nil;
}



-(void) parserDidEndDocument:(NSXMLParser *)parser {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.dataSource = [NSArray arrayWithArray:self.arrDiscounts];
    self.selectedIndex = 0;
    [self setupValues];
}

@end
