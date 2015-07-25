//
//  DMHairHelpViewController.m
//  DMDrogerie
//
//  Created by Vlada on 5/19/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMHairHelpViewController.h"

@interface DMHairHelpViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign)NSInteger index;

@end

@implementation DMHairHelpViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andIndex:(NSInteger)ind{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.index = ind;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  POMOĆ" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    
    for (int i = 0; i < 5; i++) {
        UIView* v = [self.scrollView viewWithTag:i+1];
        CGRect f = v.frame;
        f.origin.x = i * self.view.bounds.size.width;
        v.frame = f;
    }
    
    [self.scrollView setContentSize:CGSizeMake(4 * self.view.bounds.size.width, self.scrollView.frame.size.height)];
    
    
    [self.scrollView setContentOffset:CGPointMake(self.index * self.view.bounds.size.width, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonCancelClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
