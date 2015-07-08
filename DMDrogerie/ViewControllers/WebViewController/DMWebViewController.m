//
//  DMWebViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/21/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMWebViewController.h"

#import "UIKit+AFNetworking.h"

#import "DMRequestManager.h"

@interface DMWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)NSDictionary* adDict;

@property (weak, nonatomic) IBOutlet UIView *viewBanner;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic, assign)BOOL showPDF;

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
        self.adDict = nil;
        
        self.showPDF = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAdDict:(NSDictionary *)dict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.aktuelnost = nil;
        self.adDict = dict;
        
        self.showPDF = NO;
    }
    return self;
}

- (id)initAndShowPDFWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.aktuelnost = nil;
        self.adDict = nil;
        
        self.showPDF = YES;
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
    
//    "id":"5","slika":"http:\/\/dm-mobile.darijo73.mycpanel.rs\/BanerSlike\/5.jpg","link":"http:\/\/www.dm-drogeriemarkt.rs\/rs_homepage\/lepota\/negakose\/127322\/aktuelno_i.html"
    
    if (self.showPDF) {
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked)];
        [self.navigationItem setLeftBarButtonItem:leftBarButton];
        [self.viewBanner setHidden:YES];
        NSURL* url = [NSURL URLWithString:[[DMRequestManager sharedManager].pdfDict objectForKey:@"link"]];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else{
        if (self.aktuelnost) {
            [self.viewBanner setHidden:YES];
            NSURL* url = [NSURL URLWithString:self.aktuelnost.link];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        else{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked)];
            [self.navigationItem setLeftBarButtonItem:leftBarButton];
            [self.navigationController setNavigationBarHidden:YES];
            [self.imgView setImageWithURL:[NSURL URLWithString:[self.adDict objectForKey:@"slika"]]];
            
            NSURL* url = [NSURL URLWithString:[self.adDict objectForKey:@"link"]];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)buttonCancelClicked{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnShowClicked:(id)sender {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.viewBanner setAlpha:0.0];
    }];
    
}

- (IBAction)btnDissmissClicked:(id)sender {
    [self buttonCancelClicked];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
