//
//  DMAppDelegate.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMAppDelegate.h"
#import "DMMainViewController.h"
#import "DMLocationsViewController.h"
#import "DMOffersViewController.h"
#import "DMDiscountsViewController.h"
#import "DMShoppingListViewController.h"
#import "AFNetworking.h"
#import "DMStatistics.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation DMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:@"AIzaSyAVx7cKcWIkDNDmR6avgpJDNgxr-4mrzCM"];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDelegate:self];
    [self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.manager startUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kStatistics: [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]],
                                                              kSavedItems: [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]]}];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bg.png"] forBarMetrics:UIBarMetricsDefault];
//	[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:2.0 forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0],
      NSForegroundColorAttributeName,
      shadow, NSShadowAttributeName,
      [UIFont systemFontOfSize:16.5],
      NSFontAttributeName,
      nil]];
    
    NSString* mainName;
    NSString* locationsName;
    NSString* offersName;
    NSString* discountName;
    NSString* shoppingName;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        mainName = @"DMMainViewController";
        locationsName = @"DMLocationsViewController";
        offersName = @"DMOffersViewController";
        discountName = @"DMDiscountsViewController";
        shoppingName = @"DMShoppingListViewController";
    }
    else{
        mainName = @"DMMainViewController_iPad";
        locationsName = @"DMLocationsViewController_iPad";
        offersName = @"DMOffersViewController_iPad";
        discountName = @"DMDiscountsViewController_iPad";
        shoppingName = @"DMShoppingListViewController_iPad";
    }
    
	DMMainViewController* mainVC = [[DMMainViewController alloc] initWithNibName:mainName bundle:[NSBundle mainBundle]];
    UINavigationController* navCon1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    DMLocationsViewController* locationsVC = [[DMLocationsViewController alloc] initWithNibName:locationsName bundle:[NSBundle mainBundle]];
    UINavigationController* navCon4 = [[UINavigationController alloc] initWithRootViewController:locationsVC];
    
    DMOffersViewController* offersVC = [[DMOffersViewController alloc] initWithNibName:offersName bundle:[NSBundle mainBundle]];
    UINavigationController* navCon3 = [[UINavigationController alloc] initWithRootViewController:offersVC];
    
    DMDiscountsViewController* discountVC = [[DMDiscountsViewController alloc] initWithNibName:discountName bundle:[NSBundle mainBundle]];
    UINavigationController* navCon2 = [[UINavigationController alloc] initWithRootViewController:discountVC];
    
    DMShoppingListViewController* shoppingListVC = [[DMShoppingListViewController alloc] initWithNibName:shoppingName bundle:[NSBundle mainBundle]];
    UINavigationController* navCon5 = [[UINavigationController alloc] initWithRootViewController:shoppingListVC];
    
    
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:navCon1, navCon2, navCon3, navCon4, navCon5, nil]];
    
    NSShadow *shadowT = [[NSShadow alloc] init];
    shadowT.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    shadowT.shadowOffset = CGSizeMake(0, 1);
    NSDictionary* atrributesNormal = @{NSForegroundColorAttributeName: [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0],
                                       NSFontAttributeName: [UIFont systemFontOfSize:12.5],
                                       NSShadowAttributeName: shadowT
                                       };
    
    NSDictionary* atrributesSelected = @{NSForegroundColorAttributeName: [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0],
                                         NSFontAttributeName: [UIFont systemFontOfSize:11.0],
                                         NSShadowAttributeName: shadowT};
    [[UITabBarItem appearance] setTitleTextAttributes:atrributesNormal forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:atrributesSelected forState:UIControlStateSelected];
    
    [[tabBarController tabBar] setBackgroundImage:[UIImage imageNamed:@"tab_background.png"]];
    //	[[tabBarController tabBar] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_selected_button.png"]];
	[[tabBarController tabBar] setTintColor:[UIColor clearColor]];
	[[tabBarController tabBar] setBackgroundColor:[UIColor clearColor]];
    
	UITabBarItem* itemMain = [[tabBarController.tabBar items] objectAtIndex:0];
	UITabBarItem* itemDiscounts = [[tabBarController.tabBar items] objectAtIndex:1];
	UITabBarItem* itemOffers = [[tabBarController.tabBar items] objectAtIndex:2];
	UITabBarItem* itemLocations = [[tabBarController.tabBar items] objectAtIndex:3];
    UITabBarItem* itemShopping = [[tabBarController.tabBar items] objectAtIndex:4];
    
    [itemMain setTitle:NSLocalizedString(@"Aktuelno", @"")];
    [itemDiscounts setTitle:NSLocalizedString(@"Akcija", @"")];
    [itemOffers setTitle:NSLocalizedString(@"Novo", @"")];
    [itemLocations setTitle:NSLocalizedString(@"Prodavnice", @"")];
    [itemShopping setTitle:NSLocalizedString(@"Shopping", @"")];
    
    
    [itemMain setImage:[[UIImage imageNamed:@"aktuelno-normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemMain setSelectedImage:[[UIImage imageNamed:@"actuelno-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [itemDiscounts setImage:[[UIImage imageNamed:@"akcija-normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemDiscounts setSelectedImage:[[UIImage imageNamed:@"akcija-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [itemOffers setImage:[[UIImage imageNamed:@"novo-normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemOffers setSelectedImage:[[UIImage imageNamed:@"novo-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [itemLocations setImage:[[UIImage imageNamed:@"map-normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemLocations setSelectedImage:[[UIImage imageNamed:@"map-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [itemShopping setImage:[[UIImage imageNamed:@"cart-normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [itemShopping setSelectedImage:[[UIImage imageNamed:@"cart-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
	[self.window setRootViewController:tabBarController];
    
    
    [self sendStats];
    
	
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)sendStats{

    
    NSMutableArray* arr = [NSMutableArray array];
    NSData* dt = [[NSUserDefaults standardUserDefaults] objectForKey:kStatistics];
    
    NSMutableArray* mArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:dt]];
    for (DMStatistics* stat in mArr) {
        NSDictionary* dict = @{@"dat": stat.date,
                               @"kat": stat.category,
                               @"id": stat.objectId,
                               @"kor": stat.kor,
                               @"brDod": stat.brDod,
                               @"brPrik": stat.brPrik,
                               @"katPro": stat.productCategory,
                               @"brMap": stat.brMap,
                               @"brTel": stat.brTel};
        
        [arr addObject:dict];
    }
    
    NSMutableURLRequest* req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://dmbih.com/upload_stats_i.php" parameters:nil error:nil];
    
    [req setHTTPMethod:@"POST"];
    
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    

    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:data];
	
    
	AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSString* str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str isEqualToString:@"OK"]) {
            NSLog(@"Save succesufull");
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSArray array]] forKey:kStatistics];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            NSLog(@"Error saving");
        }
	}failure:^(AFHTTPRequestOperation *operation, NSError *error){
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"%@", error.localizedDescription);
	}];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[op start];
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Location manager delegates

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"Broj lokacija %d", locations.count);
    CLLocation* loc = [locations firstObject];
    
    self.currentLocation = loc;
    [self.manager stopUpdatingLocation];
}

@end
