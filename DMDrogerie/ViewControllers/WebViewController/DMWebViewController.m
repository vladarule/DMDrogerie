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
    
    NSURL* url = [NSURL URLWithString:self.aktuelnost.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
