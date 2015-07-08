//
//  DMNailsViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/16/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMNailsViewController.h"
#import "DMNailImgShareViewController.h"

#import "DMNailColor.h"

#import "UIKit+AFNetworking.h"

#import "MBProgressHUD.h"

#import <QuartzCore/QuartzCore.h>

@interface DMNailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewHand;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)NSArray* dataSource;

@property (nonatomic, strong)UIButton* selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgNail;

@property (weak, nonatomic) IBOutlet UIView *viewFavs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSourceTable;
@property (nonatomic, strong)DMNailColor* nailColor;
@property (nonatomic, strong)NSDictionary* selectedColor;

@property (nonatomic, assign)BOOL showingFavoriteColors;
@property (weak, nonatomic) IBOutlet UILabel *lblFavs;

@end

@implementation DMNailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andArray:(NSArray *)arr{
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
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  NAIL SALON" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    self.nailColor = [self.dataSource firstObject];
    

    UIView* ftView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:ftView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 10, 60)];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    [self setupScrollView];
    
    
    UIBarButtonItem* btnShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nail_share.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnShareClicked:)];
    
    UIBarButtonItem* btnFavs = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nail_show_favs.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showFavorites)];
    
    [self.navigationItem setRightBarButtonItems:@[btnFavs, btnShare] animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupScrollView{

    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    [self.imgNail setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.nailColor.manufacturerLogo]]];
    
    for (int i = 0; i < self.nailColor.colors.count; i++) {
        NSDictionary* dict = [self.nailColor.colors objectAtIndex:i];
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(i * 42, 0, 40, 40)];
        [btn setBackgroundColor:[self getColorFromArray:[dict objectForKey:@"kod"]]];
        [btn addTarget:self action:@selector(btnColorClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i + 1];
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1.0;
        btn.clipsToBounds = YES;
        [self.scrollView addSubview:btn];
        [self.scrollView setContentSize:CGSizeMake(btn.frame.origin.x + 40, 60)];
    }
    
    UIButton* btn = (UIButton *)[self.scrollView viewWithTag:1];
    [self btnColorClicked:btn];
}

- (void)showFavorites{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"nailFavorites"]];
    self.showingFavoriteColors = YES;
    self.dataSourceTable = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    
    
    [self.lblFavs setText:NSLocalizedString(@"Omiljene boje", @"")];
    [self.viewFavs setHidden:NO];
    [self.scrollView setUserInteractionEnabled:NO];
    [self.view bringSubviewToFront:self.viewFavs];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)btnChooseManufacturerClicked:(id)sender {
    self.showingFavoriteColors = NO;
    
    
    [self.tableView reloadData];
    
    
    [self.lblFavs setText:@"Izaberite proizvodjača"];
    [self.viewFavs setHidden:NO];
    [self.scrollView setUserInteractionEnabled:NO];
    [self.view bringSubviewToFront:self.viewFavs];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)btnCloseFavViewClicked:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.viewFavs setHidden:YES];
    [self.scrollView setUserInteractionEnabled:YES];
}

- (IBAction)btnAddToFavsClicked:(id)sender {
    
    
    NSDictionary* dict = @{@"manufacturerName": self.nailColor.manufacturerName, @"manufacturerLogo": self.nailColor.manufacturerLogo, @"colorDict": self.selectedColor};
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"nailFavorites"]];
    
    if ([arr containsObject:dict]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"";
        hud.detailsLabelText = NSLocalizedString(@"Boja se vec nalazi u omiljenim", @"");
        hud.margin = 10.f;
        hud.yOffset = 120.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        return;
    }
    [arr addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"nailFavorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)btnRemoveFromFavsClicked:(id)sender {
    
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    
    
    NSDictionary* dict = [self.dataSourceTable objectAtIndex:path.row];
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"nailFavorites"]];
    [arr removeObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"nailFavorites"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.dataSourceTable = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    
}

- (void)btnShareClicked:(UIBarButtonItem *)sender{
    DMNailImgShareViewController* mailShareVC = [[DMNailImgShareViewController alloc] initWithNibName:@"DMNailImgShareViewController" bundle:[NSBundle mainBundle] image:[self snapshot:self.imgViewHand] andColorDict:@{@"manufacturerName": self.nailColor.manufacturerName, @"manufacturerLogo": self.nailColor.manufacturerLogo, @"colorDict": self.selectedColor}];
    
    [self presentViewController:mailShareVC animated:YES completion:nil];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)pb_takeSnapshot {

    UIGraphicsBeginImageContextWithOptions(self.imgViewHand.frame.size, NO, [UIScreen mainScreen].scale);
    
    [self.imgViewHand drawViewHierarchyInRect:self.imgViewHand.frame afterScreenUpdates:YES];
    
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)btnColorClicked:(UIButton *)sender{
    
    if (self.selectedBtn.tag == sender.tag) {
        return;
    }
    
    self.selectedColor = [self.nailColor.colors objectAtIndex:sender.tag - 1];
    
    CGRect rct = self.selectedBtn.frame;
    rct.size.height = 40;
    
    
    CGRect rct2 = sender.frame;
    rct2.size.height = 60;
    
    [UIView animateWithDuration:0.15 animations:^{
        [sender setFrame:rct2];
        [self.selectedBtn setFrame:rct];
    } completion:^(BOOL finished) {
        self.selectedBtn = sender;
        [self.imgViewHand setBackgroundColor:sender.backgroundColor];
        float x = sender.frame.origin.x + 20 - self.view.frame.size.width/2;
        if (x < 0) {
            x = 0;
        }
        else if (x > self.scrollView.contentSize.width - self.view.frame.size.width){
            x = self.scrollView.contentSize.width - self.view.frame.size.width;
        }
        
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    }];
    
    
    
    
}

- (UIColor *)getColorFromArray:(NSArray *)array{
    float red = [[array objectAtIndex:0] floatValue];
    float green = [[array objectAtIndex:1] floatValue];
    float blue = [[array objectAtIndex:2] floatValue];
    float alpha = [[array objectAtIndex:3] floatValue];
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
    
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
    
    self.nailColor = [self.dataSource objectAtIndex:path.row * 2];
    
    [self setupScrollView];
    
    [self btnCloseFavViewClicked:nil];
    
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
    
    self.nailColor = [self.dataSource objectAtIndex:path.row * 2 + 1];
    
    [self setupScrollView];
    
    [self btnCloseFavViewClicked:nil];
}

#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showingFavoriteColors) {
        return self.dataSourceTable.count;
    }else{
        return ceil(((float)self.dataSource.count) / 2.0);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [Helper getStringFromStr:@"NailsCellIdentifier"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIImageView* imgViewType = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [imgViewType setTag:1];
        imgViewType.clipsToBounds = YES;
        imgViewType.layer.cornerRadius = 5;
        
        UIImageView* imgViewColor = [[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 40, 40)];
        [imgViewColor setTag:2];
        imgViewColor.layer.cornerRadius = 5;
        
        UILabel* colorName = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 110, 40)];
        [colorName setTextColor:[UIColor blueColor]];
        [colorName setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
        [colorName setTag:3];
        
        UIButton* btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(230, 10, 40, 40)];
        [btnDelete setImage:[UIImage imageNamed:@"nail_delete_fav"] forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(btnRemoveFromFavsClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setTag:4];
        
        
        UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 100, 100)];
        [btn1 addTarget:self action:@selector(firstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTag:11];
        
        UIImageView* imgView1 = [[UIImageView alloc] initWithFrame:btn1.frame];
        [imgView1 setTag:21];
        
        
        UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 10, 100, 100)];
        [btn2 addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTag:12];
        
        UIImageView* imgView2 = [[UIImageView alloc] initWithFrame:btn2.frame];
        [imgView2 setTag:22];
        
        
        [cell addSubview:imgViewType];
        [cell addSubview:imgViewColor];
        [cell addSubview:colorName];
        [cell addSubview:btnDelete];
        
        [cell addSubview:btn1];
        [cell addSubview:btn2];
        [cell addSubview:imgView1];
        [cell addSubview:imgView2];
        
    }

    
    UIImageView* imgViewType = (UIImageView *)[cell viewWithTag:1];
    UIImageView* imgViewColor = (UIImageView *)[cell viewWithTag:2];
    UILabel* colorName = (UILabel *)[cell viewWithTag:3];
    UIButton* btnDelete = (UIButton *)[cell viewWithTag:4];
    
    UIButton* btn1 = (UIButton *)[cell viewWithTag:11];
    
    UIButton* btn2 = (UIButton *)[cell viewWithTag:12];
    UIImageView* imgView1 = (UIImageView *)[cell viewWithTag:21];
    UIImageView* imgView2 = (UIImageView *)[cell viewWithTag:22];
    
    if (self.showingFavoriteColors) {
        [imgViewType setHidden:NO];
        [imgViewColor setHidden:NO];
        [colorName setHidden:NO];
        [btnDelete setHidden:NO];
        [btnDelete setEnabled:YES];
        
        [btn1 setHidden:YES];
        [btn1 setEnabled:NO];
        [btn2 setHidden:YES];
        [btn2 setEnabled:NO];
        [imgView1 setHidden:YES];
        [imgView2 setHidden:YES];
        
        NSDictionary* dict = [self.dataSourceTable objectAtIndex:indexPath.row];
        
        [imgViewType setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, [dict objectForKey:@"manufacturerLogo"]]]];
        
        UIColor* c = [self getColorFromArray:[[dict objectForKey:@"colorDict"] objectForKey:@"kod"]];
        [imgViewColor setBackgroundColor:c];
        
        [colorName setText:[[dict objectForKey:@"colorDict"] objectForKey:@"naziv"]];
    }
    else{
        [imgViewType setHidden:YES];
        [imgViewColor setHidden:YES];
        [colorName setHidden:YES];
        [btnDelete setHidden:YES];
        [btnDelete setEnabled:NO];
        
        
        
        if (indexPath.row * 2 < self.dataSource.count) {
            
            [btn1 setHidden:NO];
            [btn1 setEnabled:YES];
            [imgView1 setHidden:NO];
            
            DMNailColor* first = [self.dataSource objectAtIndex:indexPath.row * 2];
            [imgView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, first.manufacturerLogo]]];
            
        }
        else{
            [btn1 setHidden:YES];
            [btn1 setEnabled:NO];
            [imgView1 setHidden:YES];
        }
        
        if (indexPath.row * 2 + 1 < self.dataSource.count) {
            [btn2 setHidden:NO];
            [btn2 setEnabled:YES];
            [imgView2 setHidden:NO];
            
            DMNailColor* second = [self.dataSource objectAtIndex:indexPath.row * 2 + 1];
            [imgView2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, second.manufacturerLogo]]];
        }
        else{
            [btn2 setHidden:YES];
            [btn2 setEnabled:NO];
            [imgView2 setHidden:YES];
        }
        
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showingFavoriteColors) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            return 60.0;
        }
        else{
            return 160.0;
        }
    }
    else{
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            return 120.0;
        }
        else{
            return 160.0;
        }
    }
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showingFavoriteColors) {
        NSDictionary* dict = [self.dataSourceTable objectAtIndex:indexPath.row];
        
        [self.imgViewHand setBackgroundColor:[self getColorFromArray:[[dict objectForKey:@"colorDict"] objectForKey:@"kod"]]];
        [self btnCloseFavViewClicked:nil];
        
        DMNailImgShareViewController* mailShareVC = [[DMNailImgShareViewController alloc] initWithNibName:@"DMNailImgShareViewController" bundle:[NSBundle mainBundle] image:[self snapshot:self.imgViewHand] andColorDict:dict];
        
        [self presentViewController:mailShareVC animated:YES completion:^{
            
            UIButton* btn = (UIButton *)[self.scrollView viewWithTag:self.selectedBtn.tag];
            self.selectedBtn = nil;
            [self btnColorClicked:btn];
        }];
        
    }
    
}


@end
