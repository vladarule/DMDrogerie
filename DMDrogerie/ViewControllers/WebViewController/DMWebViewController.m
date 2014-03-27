//
//  DMWebViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/21/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMWebViewController.h"

@interface DMWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DMWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAktuelnost:(DMAktuelnost *)aktuelnost
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.aktuelnost = aktuelnost;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
//    [btn setTitle:@"  SHOPPING LISTA" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    NSURL* url = [NSURL URLWithString:self.aktuelnost.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
