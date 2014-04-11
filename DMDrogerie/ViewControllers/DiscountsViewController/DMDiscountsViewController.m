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
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  AKCIJA" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    
    UISwipeGestureRecognizer* gRecognizerSwipedLeft1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    [gRecognizerSwipedLeft1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [gRecognizerSwipedLeft1 setDelegate:self];
    
    UISwipeGestureRecognizer* gRecognizerSwipedRight1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [gRecognizerSwipedRight1 setDirection:UISwipeGestureRecognizerDirectionRight];
    [gRecognizerSwipedRight1 setDelegate:self];
    
    UISwipeGestureRecognizer* gRecognizerSwipedLeft2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    [gRecognizerSwipedLeft2 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [gRecognizerSwipedLeft2 setDelegate:self];
    
    UISwipeGestureRecognizer* gRecognizerSwipedRight2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    [gRecognizerSwipedRight2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [gRecognizerSwipedRight2 setDelegate:self];
    
    [self.mainView addGestureRecognizer:gRecognizerSwipedLeft1];
    [self.mainView addGestureRecognizer:gRecognizerSwipedRight1];
    
    [self.secondView addGestureRecognizer:gRecognizerSwipedLeft2];
    [self.secondView addGestureRecognizer:gRecognizerSwipedRight2];
    
    [self setupTitles];
    
    [self.secondView setTag:-1];
    [self.mainView setTag:-1];
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
        if (error.code == -1009) {
            NSLog(@"No internet");
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Obaveštenje" message:@"Trenutno se ne mogu preuzeti podaci. Molimo Vas pokušajte kasnije" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
	}];
	
	[op start];
}

- (void)setupTitles{
    
    [self.lblTitle setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:18]]];
    [self.lblTitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblSubtitle setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:16]]];
    [self.lblSubtitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblDescription setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:13.5]]];
    [self.lblDescription setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblBefore setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:11.5]]];
    [self.lblBefore setMinimumScaleFactor:0.5];
    [self.lblBefore setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblPrice setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:20]]];
    [self.lblPrice setTextColor:[UIColor whiteColor]];
    
    [self.lblKM setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:16]]];
    [self.lblKM setTextColor:[UIColor whiteColor]];
    
    [self.lblSaving setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:15]]];
    [self.lblSaving setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblActiveTo setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14]]];
    [self.lblActiveTo setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblRef setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14]]];
    [self.lblRef setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblDiscount setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:15]]];
    [self.lblDiscount setTextColor:[UIColor redColor]];
    
    
    [self.lblIndex setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:16]]];
    [self.lblIndex setTextColor:[UIColor colorWithRed:110.0/255 green:133.0/255 blue:200.0/255 alpha:1.0]];
    
    
    [self.lblTitle2 setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:18]]];
    [self.lblTitle2 setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblSubtitle2 setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:16]]];
    [self.lblSubtitle2 setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblDescription2 setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:13.5]]];
    [self.lblDescription2 setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblBefore2 setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:11.5]]];
    [self.lblBefore2 setMinimumScaleFactor:0.5];
    [self.lblBefore2 setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblPrice2 setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:20]]];
    [self.lblPrice2 setTextColor:[UIColor whiteColor]];
    
    [self.lblKm2 setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:16]]];
    [self.lblKm2 setTextColor:[UIColor whiteColor]];
    
    [self.lblSaving2 setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:15]]];
    [self.lblSaving2 setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblActiveTo2 setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14]]];
    [self.lblActiveTo2 setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblRef2 setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14]]];
    [self.lblRef2 setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    
    [self.lblDiscount2 setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:15]]];
    [self.lblDiscount2 setTextColor:[UIColor redColor]];

    
    
    [self.buttonAddToCart.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12]]];
    [self.buttonAddToCart setTitleColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.buttonAddToCart setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:20], 0, 0)];
    [self.buttonAddToCart setTitle:@"Dodaj u shopping listu" forState:UIControlStateNormal];
    
    [self.buttonAddToCart2.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12]]];
    [self.buttonAddToCart2 setTitleColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.buttonAddToCart2 setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:20], 0, 0)];
    [self.buttonAddToCart2 setTitle:@"Dodaj u shopping listu" forState:UIControlStateNormal];
    
    
    
}

- (void)setupValues{
    DMDiscount* discount = [self.dataSource objectAtIndex:self.selectedIndex];
    if (self.mainView.tag < 0) {
        [self.lblTitle setText:discount.item];
        [self.lblSubtitle setText:discount.name];
        [self.lblDescription setText:[NSString stringWithFormat:@"%@\n%@", discount.description, discount.quantity]];
        CGRect descRect = self.lblDescription.frame;
        descRect.size.width = 165;
        [self.lblDescription setFrame:descRect];
        [self.lblDescription sizeToFit];
        //    [self.lblDescription setHidden:YES];
        [self.lblBefore setText:[NSString stringWithFormat:@"Redovna: %@ KM", discount.oldPrice]];
        [self.lblPrice setText:[NSString stringWithFormat:@"%@", discount.nwPrice]];
        [self.lblSaving setText:[NSString stringWithFormat:@"Uštedite: %@ KM", discount.saving]];
        [self.lblActiveTo setText:[NSString stringWithFormat:@"Vrijedi do: %@", discount.activeTo]];
        [self.lblDiscount setText:discount.discount];
        if (discount.ref.intValue == 0) {
            [self.lblRef setHidden:YES];
            CGRect rct1 = self.lblRef.frame;
            CGRect rct2 = rct1;
            rct2.origin.y = rct1.origin.y + rct1.size.height;
            [self.lblSaving setFrame:rct1];
            [self.lblActiveTo setFrame:rct2];
        }
        else{
            CGRect rct1 = self.lblRef.frame;
            rct1.origin.y = rct1.origin.y + rct1.size.height;
            CGRect rct2 = rct1;
            rct2.origin.y = rct1.origin.y + rct1.size.height;
            [self.lblSaving setFrame:rct1];
            [self.lblActiveTo setFrame:rct2];
            [self.lblRef setHidden:NO];
            [self.lblRef setText:discount.ref];
        }
        
        
        [self.lblIndex setText:[NSString stringWithFormat:@"%d od %d", self.selectedIndex + 1, self.dataSource.count]];
        
        [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, discount.image]]];
    }
    else{
        [self.lblTitle2 setText:discount.item];
        [self.lblSubtitle2 setText:discount.name];
        [self.lblDescription2 setText:[NSString stringWithFormat:@"%@\n%@", discount.description, discount.quantity]];
        CGRect descRect = self.lblDescription2.frame;
        descRect.size.width = 165;
        [self.lblDescription2 setFrame:descRect];
        [self.lblDescription2 sizeToFit];
        //    [self.lblDescription setHidden:YES];
        [self.lblBefore2 setText:[NSString stringWithFormat:@"Redovna: %@ KM", discount.oldPrice]];
        [self.lblPrice2 setText:[NSString stringWithFormat:@"%@", discount.nwPrice]];
        [self.lblSaving2 setText:[NSString stringWithFormat:@"Uštedite: %@ KM", discount.saving]];
        [self.lblActiveTo2 setText:[NSString stringWithFormat:@"Vrijedi do: %@", discount.activeTo]];
        [self.lblDiscount2 setText:discount.discount];
        if (discount.ref.intValue == 0) {
            [self.lblRef2 setHidden:YES];
            CGRect rct1 = self.lblRef2.frame;
            CGRect rct2 = rct1;
            rct2.origin.y = rct1.origin.y + rct1.size.height;
            [self.lblSaving2 setFrame:rct1];
            [self.lblActiveTo2 setFrame:rct2];
        }
        else{
            CGRect rct1 = self.lblRef2.frame;
            rct1.origin.y = rct1.origin.y + rct1.size.height;
            CGRect rct2 = rct1;
            rct2.origin.y = rct1.origin.y + rct1.size.height;
            [self.lblSaving2 setFrame:rct1];
            [self.lblActiveTo2 setFrame:rct2];
            [self.lblRef2 setHidden:NO];
            [self.lblRef2 setText:discount.ref];
        }
        
        
        [self.lblIndex setText:[NSString stringWithFormat:@"%d od %d", self.selectedIndex + 1, self.dataSource.count]];
        
        [self.imgView2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, discount.image]]];
    }
    
    
    
    
    
    
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
    }
    else{
        self.selectedIndex = self.dataSource.count - 1;
    }
    
    
    [self setupValues];
    if (self.mainView.tag < 0) {
        self.mainView.tag = 0;
        self.secondView.tag = -1;
        CGRect mainRct = CGRectMake(- self.mainView.frame.size.width, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
        [self.mainView setFrame:mainRct];
        CGRect secondRct = self.secondView.frame;
        secondRct.origin.x = secondRct.origin.x + secondRct.size.width;
        mainRct.origin.x = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.mainView setFrame:mainRct];
            [self.secondView setFrame:secondRct];
        }];
    }
    else{
        self.secondView.tag = 0;
        self.mainView.tag = -1;
        CGRect mainRct = self.mainView.frame;
        CGRect secondRct = CGRectMake(- self.secondView.frame.size.width, 0, self.secondView.frame.size.width, self.secondView.frame.size.height);
        [self.secondView setFrame:secondRct];
        mainRct.origin.x = mainRct.origin.x + mainRct.size.width;
        secondRct.origin.x = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.mainView setFrame:mainRct];
            [self.secondView setFrame:secondRct];
        }];
    }
    
}

- (IBAction)buttonNextClicked:(id)sender {
    
    if (self.selectedIndex < self.dataSource.count - 1) {
        self.selectedIndex++;
    }
    else{
        self.selectedIndex = 0;
    }
    
    [self setupValues];
    if (self.mainView.tag < 0) {
        self.mainView.tag = 0;
        self.secondView.tag = -1;
        CGRect mainRct = CGRectMake(self.mainView.frame.size.width, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
        [self.mainView setFrame:mainRct];
        CGRect secondRct = self.secondView.frame;
        secondRct.origin.x = secondRct.origin.x - secondRct.size.width;
        mainRct.origin.x = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.mainView setFrame:mainRct];
            [self.secondView setFrame:secondRct];
        }];
    }
    else{
        self.secondView.tag = 0;
        self.mainView.tag = -1;
        CGRect mainRct = self.mainView.frame;
        CGRect secondRct = CGRectMake(self.secondView.frame.size.width, 0, self.secondView.frame.size.width, self.secondView.frame.size.height);
        [self.secondView setFrame:secondRct];
        mainRct.origin.x = mainRct.origin.x - mainRct.size.width;
        secondRct.origin.x = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.mainView setFrame:mainRct];
            [self.secondView setFrame:secondRct];
        }];
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"";
    hud.detailsLabelText = [NSString stringWithFormat:@"Proizvod %@ - %@ dodan u shopping listu", discount.item, discount.name];
    hud.margin = 10.f;
    hud.yOffset = 120.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
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
    [self.mainView setTag:0];
}

@end
