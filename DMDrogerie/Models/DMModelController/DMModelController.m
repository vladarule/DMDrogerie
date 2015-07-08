//
//  DMModelController.m
//  DMDrogerie
//
//  Created by Vlada on 3/30/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMModelController.h"

#import "DMRequestManager.h"

#import "DMMainViewController.h"
#import "DMLocationsViewController.h"
#import "DMOffersViewController.h"
#import "DMDiscountsViewController.h"
#import "DMShoppingListViewController.h"
#import "DMPromotionsViewController.h"
#import "DMNailsViewController.h"
#import "DMAboutViewController.h"
#import "DMChooseImageViewController.h"

@interface DMModelController ()

@property (nonatomic, strong)DMMainViewController* vestiVC;
@property (nonatomic, strong)DMDiscountsViewController* popustiVC;
@property (nonatomic, strong)DMOffersViewController* novoVC;
@property (nonatomic, strong)DMPromotionsViewController* promocijeVC;
@property (nonatomic, strong)DMNailsViewController* noktiVC;
@property (nonatomic, strong)DMLocationsViewController* lokacijeVC;
@property (nonatomic, strong)DMShoppingListViewController* shoppingListaVC;
@property (nonatomic, strong)DMAboutViewController* aboutVC;

@property (nonatomic, strong)DMChooseImageViewController* chooseImgVC;

@property (nonatomic, assign)NSInteger currentIndex;

@end

@implementation DMModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        
    }
    return self;
}

- (id )viewControllerAtIndex:(NSUInteger)index {
    
    //     Return the data view controller for the given index.
    
    NSString* mainName;
    NSString* locationsName;
    NSString* offersName;
    NSString* discountName;
    NSString* shoppingName;
    NSString* promotionsName;
    NSString* nailsName;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        mainName = @"DMMainViewController";
        locationsName = @"DMLocationsViewController";
        offersName = @"DMOffersViewController";
        discountName = @"DMDiscountsViewController";
        shoppingName = @"DMShoppingListViewController";
        promotionsName =  @"DMPromotionsViewController";
        nailsName = @"DMNailsViewController";
    }
    else{
        mainName = @"DMMainViewController_iPad";
        locationsName = @"DMLocationsViewController_iPad";
        offersName = @"DMOffersViewController_iPad";
        discountName = @"DMDiscountsViewController_iPad";
        shoppingName = @"DMShoppingListViewController_iPad";
    }
    
    
    
    if (index == 0) {
        if (!self.vestiVC) {
            self.vestiVC = [[DMMainViewController alloc] initWithNibName:mainName bundle:[NSBundle mainBundle] andArray:[[DMRequestManager sharedManager].finalDict objectForKey:@"aktuelnosti"]];
        }
        self.currentIndex = 0;
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.vestiVC];
        return navCon;
    }
    else if (index == 1){
        
        if (!self.popustiVC) {
            self.popustiVC = [[DMDiscountsViewController alloc] initWithNibName:discountName bundle:[NSBundle mainBundle] andArray:[[DMRequestManager sharedManager].finalDict objectForKey:@"popusti"]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.popustiVC];
        self.currentIndex = 1;
        return navCon;
    }
    else if (index == 2){
        
        if (!self.novoVC) {
            self.novoVC = [[DMOffersViewController alloc] initWithNibName:offersName bundle:[NSBundle mainBundle] andArray:[[DMRequestManager sharedManager].finalDict objectForKey:@"ponude"]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.novoVC];
        self.currentIndex = 2;
        return navCon;
    }
    else if (index == 3){
        
        if (!self.promocijeVC) {
            self.promocijeVC = [[DMPromotionsViewController alloc] initWithNibName:promotionsName bundle:[NSBundle mainBundle] andArray:[[DMRequestManager sharedManager].finalDict objectForKey:@"promocije"]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.promocijeVC];
        self.currentIndex = 3;
        return navCon;
    }
    else if (index == 4){
        
        if (!self.chooseImgVC) {
            self.chooseImgVC = [[DMChooseImageViewController alloc] initWithNibName:@"DMChooseImageViewController" bundle:[NSBundle mainBundle]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.chooseImgVC];
        self.currentIndex = 4;
        return navCon;
    }
    else if (index == 5){
        
        if (!self.noktiVC) {
            self.noktiVC = [[DMNailsViewController alloc] initWithNibName:nailsName bundle:[NSBundle mainBundle] andArray:[[DMRequestManager sharedManager].finalDict objectForKey:@"nokti"]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.noktiVC];
        self.currentIndex = 5;
        return navCon;
    }
    else if (index == 6){
        
        if (!self.lokacijeVC) {
            self.lokacijeVC = [[DMLocationsViewController alloc] initWithNibName:locationsName bundle:[NSBundle mainBundle] andArray:[[DMRequestManager sharedManager].finalDict objectForKey:@"lokacije"]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.lokacijeVC];
        self.currentIndex = 6;
        return navCon;
    }
    else if (index == 7){
        
        if (!self.shoppingListaVC) {
            self.shoppingListaVC = [[DMShoppingListViewController alloc] initWithNibName:shoppingName bundle:[NSBundle mainBundle]];
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.shoppingListaVC];
        self.currentIndex = 7;
        return navCon;
    }
    else if (index == 8){
        
        if (!self.aboutVC) {
            self.aboutVC = [[DMAboutViewController alloc] initWithNibName:@"DMAboutViewController" bundle:[NSBundle mainBundle]];;
        }
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:self.aboutVC];
        self.currentIndex = 8;
        return navCon;
    }
    else {
        return nil;
    }
    
    return nil;
    
}

- (NSUInteger)indexOfViewController:(id )viewController {
    
    //     Return the index of the given data view controller.
    //     For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    
    
    if ([viewController isKindOfClass:[DMMainViewController class]]) {
        return 0;
    }
    else if ([viewController isKindOfClass:[DMDiscountsViewController class]]){
        return 1;
    }
    else{
        return 2;
    }

//    else if ([viewController isKindOfClass:[DMOffersViewController class]]){
//        return 2;
//    }
    //
    return 0;
    
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(id )viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(id )viewController];
    if (index == NSNotFound || index == 1) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

@end
