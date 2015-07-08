//
//  DMSelectModelViewController.m
//  DMDrogerie
//
//  Created by Vlada on 5/4/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMSelectModelViewController.h"
#import "UITableViewController+CustomCells.h"

@interface DMSelectModelViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;

@end

@implementation DMSelectModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  HAIR COLOR EXPERT" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    
    self.dataSource = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"hairImages"]];
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
    
    NSDictionary* d = [self.dataSource objectAtIndex:2 * path.row];
    
    [self.delegate selectModelViewControllerDictionarySelected:d];
    
    
    
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
    NSDictionary* d = [self.dataSource objectAtIndex:2 * path.row + 1];
    
    [self.delegate selectModelViewControllerDictionarySelected:d];
    
}

- (void)firstBtnDelete:(UIButton *)sender{
    
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.dataSource];
    [arr removeObjectAtIndex:path.row * 2];
    
    self.dataSource = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"hairImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

- (void)secondBtnDelete:(UIButton *)sender{
    
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.dataSource];
    [arr removeObjectAtIndex:path.row * 2 +1];
    
    self.dataSource = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"hairImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil(((float)self.dataSource.count) / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [Helper getStringFromStr:@"HairModelCellIdentifier"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIButton* firstBtn = (UIButton *)[cell viewWithTag:1];
        UIButton* secondBtn = (UIButton *)[cell viewWithTag:2];
        //        UIButton* thirdBtn = (UIButton *)[cell viewWithTag:3];
        
        [firstBtn addTarget:self action:@selector(firstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [secondBtn addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton* firstDelete = (UIButton *)[cell viewWithTag:91];
        UIButton* secondDelete = (UIButton *)[cell viewWithTag:92];
        //        UIButton* thirdBtn = (UIButton *)[cell viewWithTag:3];
        
        [firstDelete addTarget:self action:@selector(firstBtnDelete:) forControlEvents:UIControlEventTouchUpInside];
        [secondDelete addTarget:self action:@selector(secondBtnDelete:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* firstV = [cell viewWithTag:51];
        firstV.layer.cornerRadius = 5;
        
        UIView* secondV = [cell viewWithTag:52];
        secondV.layer.cornerRadius = 5;
        
    }
    
    UIView* firstV = [cell viewWithTag:51];
    UIView* secondV = [cell viewWithTag:52];
    
    UIImageView* imgViewModel1 = (UIImageView * )[cell viewWithTag:11];
    
    UIImageView* imgViewModel2 = (UIImageView * )[cell viewWithTag:13];
    
    
    UIButton* firstBtn = (UIButton *)[cell viewWithTag:1];
    UIButton* secondBtn = (UIButton *)[cell viewWithTag:2];
    UIButton* firstDelete = (UIButton *)[cell viewWithTag:91];
    UIButton* secondDelete = (UIButton *)[cell viewWithTag:92];
    
    if (indexPath.row * 2 < self.dataSource.count) {
        [imgViewModel1 setHidden:NO];
        NSDictionary* d = [self.dataSource objectAtIndex:indexPath.row * 2];
        
        [firstBtn setEnabled:YES];
        [firstDelete setEnabled:YES];
        [firstV setHidden:NO];
        
        
        [imgViewModel1 setImage:[UIImage imageWithData:[d objectForKey:@"originalImage"]]];

    }
    else{
        [firstBtn setEnabled:NO];
        [firstDelete setEnabled:NO];
        [imgViewModel1 setHidden:YES];
        [firstV setHidden:NO];
    }
    
    if (indexPath.row * 2 + 1 < self.dataSource.count) {
        [imgViewModel2 setHidden:NO];
        NSDictionary* d = [self.dataSource objectAtIndex:indexPath.row * 2 + 1];
        
        [firstBtn setEnabled:YES];
        [secondDelete setEnabled:YES];
        [secondV setHidden:NO];
        
        
        [imgViewModel2 setImage:[UIImage imageWithData:[d objectForKey:@"originalImage"]]];
    }
    else{
        [imgViewModel2 setHidden:YES];
        [secondBtn setEnabled:NO];
        [secondDelete setEnabled:NO];
        [secondV setHidden:YES];
    }
    

    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return 160.0;
    }
    else{
        return 160.0;
    }
}

@end
