//
//  DMShoppingListViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/26/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMShoppingListViewController.h"
#import "MBProgressHUD.h"

#import "UITableViewController+CustomCells.h"

#import "DMOffer.h"
#import "DMDiscount.h"
#import "DMCustomItem.h"

@interface DMShoppingListViewController ()

@property (nonatomic, assign)CGRect startingRct;

@property (weak, nonatomic) IBOutlet UIView *viewMiddle;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCartPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteAll;

@property (weak, nonatomic) IBOutlet UIView *viewAddItem;
@property (weak, nonatomic) IBOutlet UITextField *textFieldItemName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldItemPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldItemCount;
@property (weak, nonatomic) IBOutlet UILabel *lblKm;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewItem;


@property (weak, nonatomic) IBOutlet UIView *viewEditItem;
@property (weak, nonatomic) IBOutlet UILabel *lblEditItem;
@property (weak, nonatomic) IBOutlet UILabel *lblEditedItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEditedItemPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblEditItemCount;
@property (weak, nonatomic) IBOutlet UILabel *lblEditItemPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEditedItemCount;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveEditedItem;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteEditedItem;
@property (weak, nonatomic) IBOutlet UIButton *btnAddRemoveFromCart;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseEditedItem;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray* dataSource;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;


@property (nonatomic, assign)int itemIndex;
@property (nonatomic, assign)BOOL shouldMove;

@end

@implementation DMShoppingListViewController

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
    
    [self setupTitles];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  SHOPPING LISTA" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kSavedItems];
    
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    self.dataSource = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    
    [self setupMiddleView];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.startingRct = self.viewBottom.frame;
}

- (void)setupTitles{
    
    
    [self.lblEditedItemTitle setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:17.0]]];
    [self.lblEditedItemTitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.textFieldEditedItemCount setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:17.0]]];
    [self.textFieldEditedItemCount setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblEditedItemPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:17.0]]];
    [self.lblEditedItemPrice setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblEditItem setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:18.0]]];
    [self.lblEditItem setTextColor:[UIColor whiteColor]];
    
    [self.lblEditItemCount setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.lblEditItemCount setTextColor:[UIColor whiteColor]];
    
    [self.lblEditItemPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.lblEditItemPrice setTextColor:[UIColor whiteColor]];
    
    
    [self.lblTotalPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:16.0]]];
    [self.lblTotalPrice setTextColor:[UIColor whiteColor]];
    
    [self.lblCartPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:16.0]]];
    [self.lblCartPrice setTextColor:[UIColor whiteColor]];
    
    [self.btnDeleteAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDeleteAll.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:15.0]]];
    [self.btnDeleteAll setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:22.0], 0, 0)];
    
    [self.lblKm setTextColor:[UIColor whiteColor]];
    [self.lblKm setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:16.0]]];
    
    
    [self.textFieldItemCount setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.textFieldItemPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    [self.textFieldItemName setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:14.0]]];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
	numberToolbar.barStyle = UIBarStyleBlackTranslucent;
	numberToolbar.items = [NSArray arrayWithObjects:
                           //							   [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc] initWithTitle:@"Kraj" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    
    [self.textFieldItemName setPlaceholder:@"Naziv proizvoda"];
    
    [self.textFieldItemPrice setPlaceholder:@"Cijena komad"];
    [self.textFieldItemPrice setTextAlignment:NSTextAlignmentRight];
    [self.textFieldItemPrice setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.textFieldItemPrice setInputAccessoryView:numberToolbar];
    
    [self.textFieldItemCount setPlaceholder:@"Broj komada"];
    [self.textFieldItemCount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.textFieldItemCount setInputAccessoryView:numberToolbar];
    
    [self.textFieldEditedItemCount setKeyboardType:UIKeyboardTypeNumberPad];
    [self.textFieldEditedItemCount setInputAccessoryView:numberToolbar];
    
    [self.btnDeleteAll setTitle:@"Obriši listu" forState:UIControlStateNormal];
    
}


- (void)setupMiddleView{
    float totalPrice = 0.0;
    float cartPrice = 0.0;
    
    for (id obj in self.dataSource) {
        if ([obj isKindOfClass:[DMOffer class]]) {
            DMOffer* offer = (DMOffer *)obj;
            NSString* str = [offer.price stringByReplacingOccurrencesOfString:@"," withString:@"."];
            float price = [str floatValue];
            totalPrice = totalPrice + offer.numberOfItems.intValue * price;
            if ([offer.inCart boolValue]) {
                cartPrice = cartPrice + offer.numberOfItems.intValue * price;
            }
        }
        else if ([obj isKindOfClass:[DMDiscount class]]) {
            DMDiscount* discount = (DMDiscount *)obj;
            NSString* str = [discount.nwPrice stringByReplacingOccurrencesOfString:@"," withString:@"."];
            float price = [str floatValue];
            totalPrice = totalPrice + discount.numberOfItems.intValue * price;
            if ([discount.inCart boolValue]) {
                cartPrice = cartPrice + discount.numberOfItems.intValue * price;
            }
        }
        else if ([obj isKindOfClass:[DMCustomItem class]]) {
            DMCustomItem* item = (DMCustomItem *)obj;
            NSString* str = [item.price stringByReplacingOccurrencesOfString:@"," withString:@"."];
            float price = [str floatValue];
            totalPrice = totalPrice + item.numberOfItems.intValue * price;
            if ([item.inCart boolValue]) {
                cartPrice = cartPrice + item.numberOfItems.intValue * price;
            }
        }
    }
    
    [self.lblTotalPrice setText:[NSString stringWithFormat:@"Cijena ukupno: %@ KM", [NSNumber numberWithFloat:totalPrice]]];
    [self.lblCartPrice setText:[NSString stringWithFormat:@"Cijena u korpi: %@ KM", [NSNumber numberWithFloat:cartPrice]]];
    
}

- (IBAction)btnDeleteAllClicked:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Brisanje kompletne shopping liste" message:@"Da li ste sigurni?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Da", @"Ne", nil];
    [alert show];
    
}

- (void)keyboardDidShow:(NSNotification *)notification {

    if (!self.shouldMove) {
        return;
    }
    
	CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	[UIView animateWithDuration:animationDuration animations:^{
        
        CGRect rct = self.startingRct;
        rct.origin.y = rct.origin.y - keyboardRect.size.height + 54;
        [self.viewBottom setFrame:rct];
    
	} completion:^(BOOL finished) {
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.shouldMove) {
        return;
    }
	CGFloat animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	[UIView animateWithDuration:animationDuration animations:^{
		CGRect rct = self.viewBottom.frame;
        rct.origin.y = rct.origin.y + keyboardRect.size.height - 54;
        [self.viewBottom setFrame:rct];
	}];
}

- (void)showEditedItemView{
    
    id obj = [self.dataSource objectAtIndex:self.itemIndex];
    
    if ([obj isKindOfClass:[DMOffer class]]) {
        DMOffer* offer = (DMOffer *)obj;
        
        [self.lblEditedItemTitle setText:[NSString stringWithFormat:@"%@", offer.title]];
        [self.textFieldEditedItemCount setText:[NSString stringWithFormat:@"%@", offer.numberOfItems]];
        [self.lblEditedItemPrice setText:[NSString stringWithFormat:@"%@ KM", offer.price]];
        if ([offer.inCart boolValue]) {
            [self.btnAddRemoveFromCart setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [Helper getStringFromStr:@"btn_izbaci"]]] forState:UIControlStateNormal];
        }
        else{
            [self.btnAddRemoveFromCart setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [Helper getStringFromStr:@"btn_ubaci"]]] forState:UIControlStateNormal];
        }
    }
    else if ([obj isKindOfClass:[DMDiscount class]]) {
        DMDiscount* discount = (DMDiscount *)obj;
        [self.lblEditedItemTitle setText:[NSString stringWithFormat:@"%@ - %@", discount.item, discount.name]];
        [self.textFieldEditedItemCount setText:[NSString stringWithFormat:@"%@", discount.numberOfItems]];
        [self.lblEditedItemPrice setText:[NSString stringWithFormat:@"%@ KM", discount.nwPrice]];
        
        if ([discount.inCart boolValue]) {
            [self.btnAddRemoveFromCart setImage:[UIImage imageNamed:@"btn_izbaci.png"] forState:UIControlStateNormal];
        }
        else{
            [self.btnAddRemoveFromCart setImage:[UIImage imageNamed:@"btn_ubaci.png"] forState:UIControlStateNormal];
        }
    }
    else if ([obj isKindOfClass:[DMCustomItem class]]) {
        DMCustomItem* item = (DMCustomItem *)obj;
        [self.lblEditedItemTitle setText:[NSString stringWithFormat:@"%@", item.name]];
        [self.textFieldEditedItemCount setText:[NSString stringWithFormat:@"%@", item.numberOfItems]];
        [self.lblEditedItemPrice setText:[NSString stringWithFormat:@"%@ KM", item.price]];
        
        if ([item.inCart boolValue]) {
            [self.btnAddRemoveFromCart setImage:[UIImage imageNamed:@"btn_izbaci.png"] forState:UIControlStateNormal];
        }
        else{
            [self.btnAddRemoveFromCart setImage:[UIImage imageNamed:@"btn_ubaci.png"] forState:UIControlStateNormal];
        }
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.viewEditItem setAlpha:1.0];
    }];
    
    
}

- (void)hideEditedItemView{
    [UIView animateWithDuration:0.3 animations:^{
        [self.viewEditItem setAlpha:0.0];
    }];
}

- (IBAction)btnAddNewItemClicked:(id)sender {
    
    if (self.textFieldItemName.text.length == 0 || self.textFieldItemPrice.text.length == 0 || self.textFieldItemCount.text.intValue == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Niste popunili sva polja!" message:@"Molim popunite sva polja i kliknite na dugme \"Dodaj\"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDictionary* dict = @{@"name": self.textFieldItemName.text,
                           @"price": self.textFieldItemPrice.text,
                           @"numberOfItems": [NSNumber numberWithFloat:self.textFieldItemCount.text.intValue]};
    
    DMCustomItem* item = [[DMCustomItem alloc] initWithDictionary:dict];
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.dataSource];
    [arr addObject:item];
    
    
    self.dataSource = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    [self setupMiddleView];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.textFieldItemCount resignFirstResponder];
    [self.textFieldItemPrice resignFirstResponder];
    [self.textFieldItemName resignFirstResponder];
    
    [self.textFieldItemName setText:@""];
    [self.textFieldItemPrice setText:@""];
    [self.textFieldItemCount setText:@""];
    
}

- (IBAction)btnSaveEditedItemClicked:(id)sender {
    
    id obj = [self.dataSource objectAtIndex:self.itemIndex];
    
    if ([obj isKindOfClass:[DMOffer class]]) {
        DMOffer* offer = (DMOffer *)obj;
        offer.numberOfItems = [NSNumber numberWithInt:self.textFieldEditedItemCount.text.intValue];
        
    }
    else if ([obj isKindOfClass:[DMDiscount class]]) {
        DMDiscount* discount = (DMDiscount *)obj;
        discount.numberOfItems = [NSNumber numberWithInt:self.textFieldEditedItemCount.text.intValue];
    }
    else if ([obj isKindOfClass:[DMCustomItem class]]) {
        DMCustomItem* item = (DMCustomItem *)obj;
        item.numberOfItems = [NSNumber numberWithInt:self.textFieldEditedItemCount.text.intValue];
    }
    
    [self.tableView reloadData];
    [self setupMiddleView];
    
    [self hideEditedItemView];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"";
    hud.detailsLabelText = @"Proizvod zamijenjen";
    hud.margin = 10.f;
    hud.yOffset = 130.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    
}

- (IBAction)btnDeleteEditedItemClicked:(id)sender {
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.dataSource];
    [arr removeObjectAtIndex:self.itemIndex];
    
    
    self.dataSource = [NSArray arrayWithArray:arr];
    [self.tableView reloadData];
    [self setupMiddleView];
    
    [self hideEditedItemView];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"";
    hud.detailsLabelText = @"Proizvod obrisan";
    hud.margin = 10.f;
    hud.yOffset = 130.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

- (IBAction)btnAddRemoveFromCartClicked:(id)sender {
    
    id obj = [self.dataSource objectAtIndex:self.itemIndex];
    
    NSData* statsData = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* statsArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:statsData]];
    
    
    
    
    if ([obj isKindOfClass:[DMOffer class]]) {
        DMOffer* offer = (DMOffer *)obj;
        offer.inCart = [NSNumber numberWithBool:![offer.inCart boolValue]];
        
        if ([offer.inCart boolValue]) {
            [self showToastWithString:@"Proizvod ubačen u korpu"];
            
            NSDate* date = [NSDate date];
            
            NSDateFormatter* formateer = [[NSDateFormatter alloc] init];
            [formateer setDateFormat:@"dd.MM.yyyy."];
            NSString* strDate = [formateer stringFromDate:date];
            DMStatistics* stat = [[DMStatistics alloc] initWithDictionary:@{@"category": @"SHOP",
                                                                            @"date": strDate,
                                                                            @"objectId": offer.objectId}];
            stat.productCategory = @"PON";
            stat.kor = @"1";
            
            [statsArr addObject:stat];
        }
        else{
            [self showToastWithString:@"Proizvod izbačen iz korpe"];
            for (DMStatistics* stat in statsArr) {
                if ([stat.objectId isEqualToString:offer.objectId] && [stat.category isEqualToString:@"SHOP"]) {
                    [statsArr removeObject:stat];
                    break;
                }
            }
        }
        
    }
    else if ([obj isKindOfClass:[DMDiscount class]]) {
        DMDiscount* discount = (DMDiscount *)obj;
        discount.inCart = [NSNumber numberWithBool:![discount.inCart boolValue]];
        if ([discount.inCart boolValue]) {
            
            [self showToastWithString:@"Proizvod ubačen u korpu"];
            NSDate* date = [NSDate date];
            
            NSDateFormatter* formateer = [[NSDateFormatter alloc] init];
            [formateer setDateFormat:@"dd.MM.yyyy."];
            NSString* strDate = [formateer stringFromDate:date];
            DMStatistics* stat = [[DMStatistics alloc] initWithDictionary:@{@"category": @"SHOP",
                                                                            @"date": strDate,
                                                                            @"objectId": discount.objectId}];
            stat.productCategory = @"POP";
            stat.kor = @"1";
            
            [statsArr addObject:stat];
        }
        else{
            [self showToastWithString:@"Proizvod izbačen iz korpe"];
            for (DMStatistics* stat in statsArr) {
                if ([stat.objectId isEqualToString:discount.objectId] && [stat.category isEqualToString:@"SHOP"]) {
                    [statsArr removeObject:stat];
                    break;
                }
            }
        }
    }
    else if ([obj isKindOfClass:[DMCustomItem class]]) {
        DMCustomItem* item = (DMCustomItem *)obj;
        item.inCart = [NSNumber numberWithBool:![item.inCart boolValue]];
        if ([item.inCart boolValue]) {
            [self showToastWithString:@"Proizvod ubačen u korpu"];
        }
        else{
            [self showToastWithString:@"Proizvod izbačen iz korpe"];
        }
    }
    
    [self.tableView reloadData];
    [self setupMiddleView];
    
    [self hideEditedItemView];
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
    
    NSData *myEncodedStats = [NSKeyedArchiver archivedDataWithRootObject:statsArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedStats forKey:kStatistics];
    
    [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showToastWithString:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"";
    hud.detailsLabelText = str;
    hud.margin = 10.f;
    hud.yOffset = 130.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}


- (IBAction)btnCloseEditedItemClicked:(id)sender {
    [self hideEditedItemView];
}

#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [Helper getStringFromStr:@"ShoppingListCellIdentifier"];
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [UITableViewController createCellFromXibWithId:CellIdentifier];
		
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:17.0]]];
        [lblTitle setTextColor:[UIColor colorWithRed:248.0/255 green:1.0/255 blue:0.0/255 alpha:1.0]];
        
        UILabel *lblCount = (UILabel *)[cell viewWithTag:2];
        [lblCount setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:13.5]]];
        [lblCount setTextColor:[UIColor blackColor]];
        
        UILabel *lblPrice = (UILabel *)[cell viewWithTag:3];
        [lblPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:13.5]]];
        [lblPrice setTextColor:[UIColor blackColor]];
        
        UILabel *lblTotalPrice = (UILabel *)[cell viewWithTag:4];
        [lblTotalPrice setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:13.5]]];
        [lblTotalPrice setTextColor:[UIColor blackColor]];
        
        
	}
	
	id obj = [self.dataSource objectAtIndex:indexPath.row];
    
    
	
	UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
	
	UILabel *lblCount = (UILabel *)[cell viewWithTag:2];
	
	UILabel *lblPrice = (UILabel *)[cell viewWithTag:3];
    
    UILabel *lblTotalPrice = (UILabel *)[cell viewWithTag:4];
    
    UIImageView *imgVIew = (UIImageView *)[cell viewWithTag:10];
    
    if ([obj isKindOfClass:[DMOffer class]]) {
        DMOffer* offer = (DMOffer *)obj;
        
        [lblTitle setText:[NSString stringWithFormat:@"%@", offer.title]];
        [lblCount setText:[NSString stringWithFormat:@"Broj komada: %@", offer.numberOfItems]];
        [lblPrice setText:[NSString stringWithFormat:@"Cijena komad: %@ KM", offer.price]];
        
        NSString* str = [offer.price stringByReplacingOccurrencesOfString:@"," withString:@"."];
        float price = [str floatValue];
        float totalPrice = offer.numberOfItems.intValue * price;
        
        
        [lblTotalPrice setText:[NSString stringWithFormat:@"Cijena ukupno: %@ KM", [NSNumber numberWithFloat:totalPrice]]];
        
        if ([offer.inCart boolValue]) {
            [imgVIew setHidden:NO];
        }
        else{
            [imgVIew setHidden:YES];
        }
        
    }
    else if ([obj isKindOfClass:[DMDiscount class]]) {
        DMDiscount* discount = (DMDiscount *)obj;
        [lblTitle setText:[NSString stringWithFormat:@"%@ - %@", discount.item, discount.name]];
        [lblCount setText:[NSString stringWithFormat:@"Broj komada: %@", discount.numberOfItems]];
        [lblPrice setText:[NSString stringWithFormat:@"Cijena komad: %@ KM", discount.nwPrice]];
        
        NSString* str = [discount.nwPrice stringByReplacingOccurrencesOfString:@"," withString:@"."];
        float price = [str floatValue];
        float totalPrice = discount.numberOfItems.intValue * price;
        
        
        [lblTotalPrice setText:[NSString stringWithFormat:@"Cijena ukupno: %@ KM", [NSNumber numberWithFloat:totalPrice]]];
        
        if ([discount.inCart boolValue]) {
            [imgVIew setHidden:NO];
        }
        else{
            [imgVIew setHidden:YES];
        }
    }
    else if ([obj isKindOfClass:[DMCustomItem class]]) {
        DMCustomItem* item = (DMCustomItem *)obj;
        [lblTitle setText:[NSString stringWithFormat:@"%@", item.name]];
        [lblCount setText:[NSString stringWithFormat:@"Broj komada: %@", item.numberOfItems]];
        [lblPrice setText:[NSString stringWithFormat:@"Cijena komad: %@ KM", item.price]];
        
        NSString* str = [item.price stringByReplacingOccurrencesOfString:@"," withString:@"."];
        float price = [str floatValue];
        float totalPrice = item.numberOfItems.intValue * price;
        
        
        [lblTotalPrice setText:[NSString stringWithFormat:@"Cijena ukupno: %@ KM", [NSNumber numberWithFloat:totalPrice]]];
        
        if ([item.inCart boolValue]) {
            [imgVIew setHidden:NO];
        }
        else{
            [imgVIew setHidden:YES];
        }
        
    }
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return 100.0;
    }
    else{
        return 160.0;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.itemIndex = indexPath.row;
    [self showEditedItemView];

}

#pragma mark - TextField delegates


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.textFieldEditedItemCount) {
        self.shouldMove = NO;
    }
    else{
        self.shouldMove = YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return YES;
}

- (void)doneWithNumberPad{
    [self.textFieldItemCount resignFirstResponder];
    [self.textFieldItemPrice resignFirstResponder];
    [self.textFieldEditedItemCount resignFirstResponder];
}

#pragma mark -UIalertVIew delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            self.dataSource = [NSArray array];
            [self.tableView reloadData];
            [self setupMiddleView];
            
            NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
            
            [[NSUserDefaults standardUserDefaults] setObject:myEncodedObject forKey:kSavedItems];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
            
        default:
            break;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return YES;
    }
    
    if (textField == self.textFieldEditedItemCount || textField == self.textFieldItemCount || textField == self.textFieldItemPrice) {
        NSString *validRegEx =@"^[0-9]*$"; //change this regular expression as your requirement
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if (myStringMatchesRegEx)
            return YES;
        else
            return NO;
    }
    else{
        return YES;
    }
    
}


@end
