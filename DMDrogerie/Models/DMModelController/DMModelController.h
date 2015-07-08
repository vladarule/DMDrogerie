//
//  DMModelController.h
//  DMDrogerie
//
//  Created by Vlada on 3/30/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DMModelController : NSObject<UIPageViewControllerDataSource>

- (id )viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(id )viewController;

@end
