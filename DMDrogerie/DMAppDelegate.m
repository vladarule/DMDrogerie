//
//  DMAppDelegate.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMAppDelegate.h"
#import "DMStartViewController.h"
#import "AFNetworking.h"
#import "DMStatistics.h"

#import "DMRequestManager.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation DMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [GMSServices provideAPIKey:@"AIzaSyAVx7cKcWIkDNDmR6avgpJDNgxr-4mrzCM"];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     @{@"deviceTokenKey": @"0"}];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDelegate:self];
    [self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.manager startUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kStatistics: [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]],
                                                              kSavedItems: [NSKeyedArchiver archivedDataWithRootObject:[NSArray array]]}];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header_bg.png"] forBarMetrics:UIBarMetricsDefault];
//	[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:2.0 forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
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
    
    
    
    DMStartViewController* startVC = [[DMStartViewController alloc] init];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    
	[self.window setRootViewController:startVC];
    
    
    [self sendStats];
    
	
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenKey"];
    
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);
    
    
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"deviceTokenKey"];
    
    if (![newToken isEqualToString:oldToken]){
        [[DMRequestManager sharedManager] postDeviceToken:newToken withResponse:^(BOOL success, id response, NSError *error) {
//            NSString* str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"s");
        }];
    }

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
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
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
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
    CLLocation* loc = [locations firstObject];
    
    self.currentLocation = loc;
    [self.manager stopUpdatingLocation];
}

@end
