//
//  DMPromotionDetailsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/14/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMPromotionDetailsViewController.h"
#import "DMStoreDetailsViewController.h"

#import "DMLocation.h"
#import "DMRequestManager.h"

#import "UIKit+AFNetworking.h"
#import "UITableViewController+CustomCells.h"

@interface DMPromotionDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;

@property (weak, nonatomic) IBOutlet UIImageView *promotionImg;
@property (weak, nonatomic) IBOutlet UILabel *promotionName;
@property (weak, nonatomic) IBOutlet UILabel *lblTxt;

@property (nonatomic, strong)DMPromotion* selectedPromotion;


@end

@implementation DMPromotionDetailsViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPromotion:(DMPromotion *)promotion{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedPromotion = promotion;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  PROMOCIJE" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self.promotionImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.selectedPromotion.img]]];
    [self.promotionName setText:self.selectedPromotion.product];
    
    NSMutableArray* ar = [NSMutableArray array];
    
    for (NSDictionary* dict in self.selectedPromotion.stores) {
        for (DMLocation* location in [DMRequestManager sharedManager].arrayLocations) {
            if ([[dict objectForKey:@"id_pro"] isEqualToString:location.objectId]) {
                NSDictionary* d = @{@"store": location, @"dates": [dict objectForKey:@"dat"]};
                [ar addObject:d];
            }
        }
    }
    
    
    self.dataSource = [NSArray arrayWithArray:ar];
    [self.tableView reloadData];
    
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonCancelClicked:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [Helper getStringFromStr:@"PromotionLocationsCellIdentifier"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
//        cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        [imgView setImage:[UIImage imageNamed:@"dmLogo.png"]];
        
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(84, 5, 200, 30)];
        [lblTitle setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setTextColor:[UIColor blueColor]];
        [lblTitle setNumberOfLines:2];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:12]];
        [lblTitle setTag:1];
        
        UIImageView* dtTime = [[UIImageView alloc] initWithFrame:CGRectMake(84, 29, 16, 16)];
        [dtTime setImage:[UIImage imageNamed:@"icon_date_time"]];
        [dtTime setContentMode:UIViewContentModeScaleAspectFit];
        [dtTime setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
        
        
        
        UILabel* lblDate = [[UILabel alloc] initWithFrame:CGRectMake(110, 32, 200, 20)];
        [lblDate setTextColor:[UIColor lightGrayColor]];
        [lblDate setFont:[UIFont systemFontOfSize:12]];
        [lblDate setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [lblDate setNumberOfLines:0];
        [lblDate setTag:2];
        
        
        [cell addSubview:dtTime];
        [cell addSubview:lblDate];
        
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:imgView];
        [cell addSubview:lblTitle];

        
    }
    
    UILabel* lblTitle = (UILabel *)[cell viewWithTag:1];
    UILabel* lblDate = (UILabel *)[cell viewWithTag:2];
    
    DMLocation* location = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"store"];
    
    NSArray* arr = [NSArray arrayWithArray:[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"dates"]];
    
    [lblTitle setText:[NSString stringWithFormat:@"%@, %@", location.city, location.street]];
    
//    float startY = 27;
//    int tag = 1;
    NSString* dtTime = @"";
    
    for (NSString* str in arr) {
        
        dtTime = [dtTime stringByAppendingString:[NSString stringWithFormat:@"%@\n", str]];
    }
    [lblDate setText:dtTime];
    
    
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSArray* arr = [NSArray arrayWithArray:[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"dates"]];
        
        return 35 + arr.count * 20 + 5;
    }
    else{
        return 120.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DMLocation* location = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"store"];
    DMStoreDetailsViewController* storeDetailsVC = [[DMStoreDetailsViewController alloc] initWithNibName:@"DMStoreDetailsViewController" bundle:[NSBundle mainBundle] andLocation:location];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:storeDetailsVC];
    [self presentViewController:navCon animated:YES completion:nil];
    
}


@end
