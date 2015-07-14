//
//  DMStartViewController.m
//  DMDrogerie
//
//  Created by Vlada on 2/16/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMStartViewController.h"

#import "DMModelController.h"

#import "DMMainViewController.h"
#import "DMLocationsViewController.h"
#import "DMOffersViewController.h"
#import "DMDiscountsViewController.h"
#import "DMShoppingListViewController.h"
#import "DMPromotionsViewController.h"
#import "DMNailsViewController.h"
#import "DMAboutViewController.h"

#import "DMAppDelegate.h"


#import "DMRequestManager.h"

@interface DMStartViewController ()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageViewController* pageViewController;
@property (strong, nonatomic) DMModelController *modelCon;
@property (nonatomic, strong)NSArray* tabNormalImages;
@property (nonatomic, strong)NSArray* tabSelectedImages;

@end

@implementation DMStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabClicked:) name:@"tab_clicked" object:nil];
    
    
    
    
    [[DMRequestManager sharedManager] getDataWithResponse:^(BOOL success, NSDictionary *response, NSError *error) {
        if (success) {
//            [self createTabBarControllerWithData:response];
            self.modelCon = [[DMModelController alloc] init];
            
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.bounds.size.width, 49)];
            [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
            [self.scrollView setBackgroundColor:[UIColor colorWithRed:53.0/255 green:48.0/255 blue:117.0/255 alpha:1.0]];
            [self.scrollView setDelegate:self];
            
            NSArray* tabNames = @[@"Vijesti", @"Akcija", @"Novo", @"Promocije", @"Frizure", @"Nokti", @"Prodavnice", @"Shopping", @"Info"];
            self.tabNormalImages = @[[UIImage imageNamed:@"vesti_norm"], [UIImage imageNamed:@"procenat_norm"], [UIImage imageNamed:@"novo_norm"], [UIImage imageNamed:@"promocije_norm"], [UIImage imageNamed:@"frizure_norm"], [UIImage imageNamed:@"nokti_norm"], [UIImage imageNamed:@"mapa_norm"], [UIImage imageNamed:@"shop_norm"], [UIImage imageNamed:@"info_norm"]];
            self.tabSelectedImages = @[[UIImage imageNamed:@"vesti_sel"], [UIImage imageNamed:@"procenat_sel"], [UIImage imageNamed:@"novo_sel"], [UIImage imageNamed:@"promocije_sel"], [UIImage imageNamed:@"frizure_sel"], [UIImage imageNamed:@"nokti_sel"], [UIImage imageNamed:@"mapa_sel"], [UIImage imageNamed:@"shop_sel"], [UIImage imageNamed:@"info_sel"]];
            
            for (int i = 0; i < 9; i++) {
                
                
                UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(i * 64, 0, 64, 49)];
                
                [btn setTag:i + 1];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0] forState:UIControlStateNormal];
                
                UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.origin.x, 0, 64, 35)];
                [imgView setContentMode:UIViewContentModeCenter];
                
                
                [imgView setTag:i + 101];
                
                UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, 35, 64, 15)];
                
                [lbl setFont:[UIFont systemFontOfSize:12.5]];
                [lbl setTextAlignment:NSTextAlignmentCenter];
                [lbl setText:[tabNames objectAtIndex:i]];
                [lbl setTag:i + 201];
                
                
                if (i == 0) {
                    [btn setSelected:YES];
                    [imgView setImage:[self.tabSelectedImages objectAtIndex:i]];
                    [lbl setTextColor:[UIColor whiteColor]];
                }
                else{
                    [btn setSelected:NO];
                    [imgView setImage:[self.tabNormalImages objectAtIndex:i]];
                    [lbl setTextColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0]];
                }
                
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.scrollView addSubview:imgView];
                [self.scrollView addSubview:lbl];
                [self.scrollView addSubview:btn];
            }
            
            [self.scrollView setContentSize:CGSizeMake(tabNames.count * 64, 49)];
            [self.view addSubview:self.scrollView];
            [self createPageViewController];
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Griješka" message:@"Molimo pokušajte ponovo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
//    [self performSelector:@selector(createTabBarController) withObject:nil afterDelay:5];
}

- (void)tabClicked:(id)note{
    UIButton* btn = (UIButton *)[self.scrollView viewWithTag:[[[DMRequestManager sharedManager].promoDict objectForKey:@"tab"] integerValue] + 1];
    
    [self btnClicked:btn];
    
//    id startingViewController = [self.modelCon viewControllerAtIndex:[[[DMRequestManager sharedManager].promoDict objectForKey:@"tab"] integerValue]];
//    NSArray *viewControllers = @[startingViewController];
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"Will begin dragiing");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"Did scroll");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Finished");
}

- (void)btnClicked:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView* imgView = (UIImageView *)view;

            if (imgView.tag < 200 && imgView.tag > 100) {
                [imgView setImage:[self.tabNormalImages objectAtIndex:imgView.tag - 101]];
            }
            
        }
        else if ([view isKindOfClass:[UILabel class]]){
            UILabel* lbl = (UILabel *)view;
            [lbl setTextColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1.0]];
        }
        else if ([view isKindOfClass:[UIButton class]]){
            UIButton* btn = (UIButton *)view;
            [btn setSelected:NO];
        }
    }
    
    [sender setSelected:YES];
    
    NSUInteger tag = sender.tag;
    
    UIImageView* imgV = (UIImageView *)[self.scrollView viewWithTag:tag + 100];
    UILabel* lblT = (UILabel *)[self.scrollView viewWithTag:tag + 200];
    [lblT setTextColor:[UIColor whiteColor]];
    [imgV setImage:[self.tabSelectedImages objectAtIndex:tag - 1]];
    
    id startingViewController = [self.modelCon viewControllerAtIndex:sender.tag - 1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn1Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn2Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn3Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:2];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn4Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:3];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn5Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:4];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn6Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:5];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn7Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:6];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (IBAction)btn8Clicked:(id)sender {
    id startingViewController = [self.modelCon viewControllerAtIndex:7];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


- (void)createPageViewController{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    
    id startingViewController = [self.modelCon viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.dataSource = nil;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view bringSubviewToFront:self.scrollView];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    
    //    CGRect pageViewRect = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60);
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    

//    for (UIScrollView *view in self.pageViewController.view.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]] && view.tag != 28) {
//            view.scrollEnabled = NO;
//        }
//    }
    
//    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

//- (void)createTabBarControllerWithData:(NSDictionary *)dict{
//    NSString* mainName;
//    NSString* locationsName;
//    NSString* offersName;
//    NSString* discountName;
//    NSString* shoppingName;
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        mainName = @"DMMainViewController";
//        locationsName = @"DMLocationsViewController";
//        offersName = @"DMOffersViewController";
//        discountName = @"DMDiscountsViewController";
//        shoppingName = @"DMShoppingListViewController";
//    }
//    else{
//        mainName = @"DMMainViewController_iPad";
//        locationsName = @"DMLocationsViewController_iPad";
//        offersName = @"DMOffersViewController_iPad";
//        discountName = @"DMDiscountsViewController_iPad";
//        shoppingName = @"DMShoppingListViewController_iPad";
//    }
//    
//    DMMainViewController* mainVC = [[DMMainViewController alloc] initWithNibName:mainName bundle:[NSBundle mainBundle] andArray:[dict objectForKey:@"aktuelnosti"]];
//    UINavigationController* navCon1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
//    
//    DMLocationsViewController* locationsVC = [[DMLocationsViewController alloc] initWithNibName:locationsName bundle:[NSBundle mainBundle] andArray:[dict objectForKey:@"lokacije"]];
//    UINavigationController* navCon4 = [[UINavigationController alloc] initWithRootViewController:locationsVC];
//    
//    DMOffersViewController* offersVC = [[DMOffersViewController alloc] initWithNibName:offersName bundle:[NSBundle mainBundle] andArray:[dict objectForKey:@"ponude"]];
//    UINavigationController* navCon3 = [[UINavigationController alloc] initWithRootViewController:offersVC];
//    
//    DMDiscountsViewController* discountVC = [[DMDiscountsViewController alloc] initWithNibName:discountName bundle:[NSBundle mainBundle] andArray:[dict objectForKey:@"popusti"]];
//    UINavigationController* navCon2 = [[UINavigationController alloc] initWithRootViewController:discountVC];
//    
//    DMShoppingListViewController* shoppingListVC = [[DMShoppingListViewController alloc] initWithNibName:shoppingName bundle:[NSBundle mainBundle]];
//    UINavigationController* navCon5 = [[UINavigationController alloc] initWithRootViewController:shoppingListVC];
//    
//    DMPromotionsViewController* promotionsVC = [[DMPromotionsViewController alloc] initWithNibName:@"DMPromotionsViewController" bundle:[NSBundle mainBundle] andArray:[dict objectForKey:@"promocije"]];
//    UINavigationController* navCon6 = [[UINavigationController alloc] initWithRootViewController:promotionsVC];
//    
//    DMNailsViewController* nailsVC = [[DMNailsViewController alloc] initWithNibName:@"DMNailsViewController" bundle:[NSBundle mainBundle] andArray:[dict objectForKey:@"nokti"]];
//    UINavigationController* navCon7 = [[UINavigationController alloc] initWithRootViewController:nailsVC];
//    
//
//    DMAboutViewController* aboutVC = [[DMAboutViewController alloc] initWithNibName:@"DMAboutViewController" bundle:[NSBundle mainBundle]];
//    UINavigationController* navCon8 = [[UINavigationController alloc] initWithRootViewController:aboutVC];
//    
//    
//    
////    UITabBarController* tabBarController = [[UITabBarController alloc] init];
////    [tabBarController setViewControllers:[NSArray arrayWithObjects:navCon1, navCon2, navCon3, navCon6, navCon8, nil]];
////    
////    NSShadow *shadowT = [[NSShadow alloc] init];
////    shadowT.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
////    shadowT.shadowOffset = CGSizeMake(0, 1);
////    NSDictionary* atrributesNormal = @{NSForegroundColorAttributeName: [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0],
////                                       NSFontAttributeName: [UIFont systemFontOfSize:12.5],
////                                       NSShadowAttributeName: shadowT
////                                       };
////    
////    NSDictionary* atrributesSelected = @{NSForegroundColorAttributeName: [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0],
////                                         NSFontAttributeName: [UIFont systemFontOfSize:11.0],
////                                         NSShadowAttributeName: shadowT};
////    [[UITabBarItem appearance] setTitleTextAttributes:atrributesNormal forState:UIControlStateNormal];
////    [[UITabBarItem appearance] setTitleTextAttributes:atrributesSelected forState:UIControlStateSelected];
////    
////    
////    [[tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:@"tab_background.png"]];
////    //	[[tabBarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_selected_button.png"]];
////    [[tabBarController tabBar] setTintColor:[UIColor clearColor]];
////    [[tabBarController tabBar] setBackgroundColor:[UIColor clearColor]];
////    
////    UITabBarItem* itemMain = [[tabBarController.tabBar items] objectAtIndex:0];
////    UITabBarItem* itemDiscounts = [[tabBarController.tabBar items] objectAtIndex:1];
////    UITabBarItem* itemOffers = [[tabBarController.tabBar items] objectAtIndex:2];
////    UITabBarItem* itemLocations = [[tabBarController.tabBar items] objectAtIndex:3];
////    UITabBarItem* itemShopping = [[tabBarController.tabBar items] objectAtIndex:4];
////    
////    
////    
////    [itemMain setTitle:NSLocalizedString(@"Vesti", @"")];
////    [itemDiscounts setTitle:NSLocalizedString(@"Popusti", @"")];
////    [itemOffers setTitle:NSLocalizedString(@"Novo", @"")];
////    [itemLocations setTitle:NSLocalizedString(@"Nokti", @"")];
////    [itemShopping setTitle:NSLocalizedString(@"Promocije", @"")];
////    
////    
////    
////    
////    
////    [itemMain setImage:[[UIImage imageNamed:@"vesti_norm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    [itemMain setSelectedImage:[[UIImage imageNamed:@"vesti_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    
////    [itemDiscounts setImage:[[UIImage imageNamed:@"procenat_norm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    [itemDiscounts setSelectedImage:[[UIImage imageNamed:@"procenat_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    
////    [itemOffers setImage:[[UIImage imageNamed:@"novo_norm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    [itemOffers setSelectedImage:[[UIImage imageNamed:@"novo_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    
////    [itemLocations setImage:[[UIImage imageNamed:@"nokti_norm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    [itemLocations setSelectedImage:[[UIImage imageNamed:@"nokti_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    
////    [itemShopping setImage:[[UIImage imageNamed:@"promocije_norm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    [itemShopping setSelectedImage:[[UIImage imageNamed:@"promocije_norm.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
////    
////    
////    DMAppDelegate* appDelegate = (DMAppDelegate *)[[UIApplication sharedApplication] delegate];
////    [appDelegate.window setRootViewController:tabBarController];
//}
//
////- (DMModelController *)modelCon {
////    // Return the model controller object, creating it if necessary.
////    // In more complex implementations, the model controller may be passed to the view controller.
////    if (!self.modelCon) {
////        self.modelCon = [[DMModelController alloc] init];
////    }
////    return self.modelCon;
////}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    
//    if ([[previousViewControllers objectAtIndex:0] isKindOfClass:[LatestViewController class]] && completed) {
////        [self.segmentedControl setSelectedSegmentIndex:1];
//    }
//    else if ([[previousViewControllers objectAtIndex:0] isKindOfClass:[CollectionsViewController class]] && completed){
////        [self.segmentedControl setSelectedSegmentIndex:0];
//    }
//    else{
//        NSLog(@"Jblg");
//    }
    
    
    
}

@end
