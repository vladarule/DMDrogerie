//
//  DMNailsViewController.h
//  DMDrogerie
//
//  Created by Vlada on 3/16/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMNailsViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andArray:(NSArray *)arr;

@end
