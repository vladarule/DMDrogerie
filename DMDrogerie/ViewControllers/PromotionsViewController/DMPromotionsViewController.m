//
//  DMPromotionsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/23/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMPromotionsViewController.h"
#import "DMPromotion.h"
#import "DMPromotionDetailsViewController.h"

#import "UIKit+AFNetworking.h"


#import "UITableViewController+CustomCells.h"

@interface DMPromotionsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;

@end

@implementation DMPromotionsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andArray:(NSArray *)arr
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.dataSource = [NSArray arrayWithArray:arr];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  PROMOCIJE" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:110.0/255 green:102.0/255 blue:180.0/255 alpha:1.0]];
    
//    [self.view setBackgroundColor:[UIColor colorWithRed:57.0/255 green:48.0/255 blue:122.0/255 alpha:1.0]];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)firstBtnClicked:(UIButton *)sender{
    
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    
    DMPromotion* promo = [self.dataSource objectAtIndex:2 * path.row];
    
    DMPromotionDetailsViewController* promoDetailsVC = [[DMPromotionDetailsViewController alloc] initWithNibName:@"DMPromotionDetailsViewController" bundle:[NSBundle mainBundle] andPromotion:promo];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:promoDetailsVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
}

- (void)secondBtnClicked:(UIButton *)sender{
    
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    DMPromotion* promo = [self.dataSource objectAtIndex:2 * path.row + 1];
    DMPromotionDetailsViewController* promoDetailsVC = [[DMPromotionDetailsViewController alloc] initWithNibName:@"DMPromotionDetailsViewController" bundle:[NSBundle mainBundle] andPromotion:promo];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:promoDetailsVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
}

//- (void)thirdBtnClicked:(UIButton *)sender{
//    
//    UITableViewCell* cell;
//    
//    id temp = [[sender superview] superview];
//    
//    if ([temp isKindOfClass:[UITableViewCell class]]) {
//        cell = temp;
//    }
//    else {
//        cell = (UITableViewCell *)[[[sender superview] superview] superview];
//    }
//    
//    NSIndexPath* path = [self.tableView indexPathForCell:cell];
//    DMPromotion* promo = [self.dataSource objectAtIndex:3 * path.row + 2];
//    
//    DMPromotionDetailsViewController* promoDetailsVC = [[DMPromotionDetailsViewController alloc] initWithNibName:@"DMPromotionDetailsViewController" bundle:[NSBundle mainBundle] andPromotion:promo];
//    
//    [self.navigationController pushViewController:promoDetailsVC animated:YES];
//}

#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil(((float)self.dataSource.count) / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [Helper getStringFromStr:@"PromotionsCellIdentifier"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIButton* firstBtn = (UIButton *)[cell viewWithTag:1];
        UIButton* secondBtn = (UIButton *)[cell viewWithTag:2];
//        UIButton* thirdBtn = (UIButton *)[cell viewWithTag:3];
        
        [firstBtn addTarget:self action:@selector(firstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [thirdBtn addTarget:self action:@selector(thirdBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    UIImageView* imgView1 = (UIImageView * )[cell viewWithTag:11];
    UIImageView* imgView2 = (UIImageView * )[cell viewWithTag:12];
    
    UIImageView* wImgView1 = (UIImageView * )[cell viewWithTag:31];
    UIImageView* wImgView2 = (UIImageView * )[cell viewWithTag:32];
    
    UIButton* firstBtn = (UIButton *)[cell viewWithTag:1];
    UIButton* secondBtn = (UIButton *)[cell viewWithTag:2];
//    UIImageView* imgView3 = (UIImageView * )[cell viewWithTag:13];
    
    if (indexPath.row * 2 < self.dataSource.count) {
        [imgView1 setHidden:NO];
        DMPromotion* first = [self.dataSource objectAtIndex:indexPath.row * 2];
        
        [firstBtn setEnabled:YES];
        [wImgView1 setHidden:NO];
        
        NSString* str = [NSString stringWithFormat:@"%@%@", kBaseURL, first.img];
        [imgView1 setImageWithURL:[NSURL URLWithString:str]];
    }
    else{
        [firstBtn setEnabled:NO];
        [wImgView1 setHidden:YES];
        [imgView1 setHidden:YES];
    }
    
    if (indexPath.row * 2 + 1 < self.dataSource.count) {
        [imgView2 setHidden:NO];
        [wImgView2 setHidden:NO];
        DMPromotion* second = [self.dataSource objectAtIndex:indexPath.row * 2 + 1];
        [imgView2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, second.img]]];
        [secondBtn setEnabled:YES];
    }
    else{
        [wImgView2 setHidden:YES];
        [imgView2 setHidden:YES];
        [secondBtn setEnabled:NO];
    }
    
//    if (indexPath.row * 3 + 2 < self.dataSource.count) {
//        [imgView3 setHidden:NO];
//        DMPromotion* third = [self.dataSource objectAtIndex:indexPath.row * 3 + 2];
//        [imgView3 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, third.img]]];
//    }
//    else{
//        [imgView3 setHidden:YES];
//    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return 140.0;
    }
    else{
        return 160.0;
    }
}



@end
