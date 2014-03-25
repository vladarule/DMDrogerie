//
//  UITableViewController+CustomCells.h
//  bcebook
//
//  Created by ivan on 10.5.11..
//  Copyright 2011 MobileWasp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIKit+AFNetworking.h"

@interface UITableViewController (CustomCells)
+ (UITableViewCell*) createCellFromXibWithId:(NSString*)cellIdentifier;
@end
