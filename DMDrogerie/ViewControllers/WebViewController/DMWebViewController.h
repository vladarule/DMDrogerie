//
//  DMWebViewController.h
//  DMDrogerie
//
//  Created by Vlada on 3/21/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAktuelnost.h"

@interface DMWebViewController : UIViewController<UIWebViewDelegate>


@property (nonatomic, strong)DMAktuelnost* aktuelnost;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAktuelnost:(DMAktuelnost *)aktuelnost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAdDict:(NSDictionary *)dict;

- (id)initAndShowPDFWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
