//
//  DMSelectModelViewController.h
//  DMDrogerie
//
//  Created by Vlada on 5/4/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DMSelectModelDelegate <NSObject>

- (void)selectModelViewControllerDidCancel;
- (void)selectModelViewControllerDictionarySelected:(NSDictionary *)dict;

@end

@interface DMSelectModelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id <DMSelectModelDelegate> delegate;

@end
