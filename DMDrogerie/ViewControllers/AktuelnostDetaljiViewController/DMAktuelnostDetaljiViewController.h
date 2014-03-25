//
//  DMAktuelnostDetaljiViewController.h
//  DMDrogerie
//
//  Created by Vlada on 3/19/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAktuelnost.h"

@interface DMAktuelnostDetaljiViewController : UIViewController

@property (nonatomic, strong)DMAktuelnost* aktuelnost;

@property (weak, nonatomic) IBOutlet UIButton *btnLink;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAktuelnost:(DMAktuelnost *)aktuelnost;
@end
