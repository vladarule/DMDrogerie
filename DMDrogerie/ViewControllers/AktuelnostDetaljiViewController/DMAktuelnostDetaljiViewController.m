//
//  DMAktuelnostDetaljiViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/19/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMAktuelnostDetaljiViewController.h"
#import "DMWebViewController.h"
#import "UIKit+AFNetworking.h"

@interface DMAktuelnostDetaljiViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation DMAktuelnostDetaljiViewController

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  VIJESTI I AKTUELNOSTI" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self setupTitles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTitles{
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

    
    [self.lblTitle setFont:[UIFont boldSystemFontOfSize:[Helper getFontSizeFromSz:17]]];
    [self.lblTitle setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    
    [self.lblDescription setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:15]]];
    [self.lblDescription setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    
    [self.lblDescription setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:13]]];
    [self.lblDescription setTextColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0]];
    [self.lblDescription setMinimumScaleFactor:0.2];
    
    
    [self.lblTitle setText:self.aktuelnost.title];
    [self.lblDescription setText:self.aktuelnost.detailDescription];
    [self.lblDescription sizeToFit];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.lblDescription.frame.size.height + 30)];
    
    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.aktuelnost.imageBig]]];
    
    [self.btnLink.titleLabel setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.5]]];
    [self.btnLink setTitleColor:[UIColor colorWithRed:53.0/255 green:49.0/255 blue:113.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.btnLink setTitleEdgeInsets:UIEdgeInsetsMake(0, [Helper getFontSizeFromSz:18], 0, 0)];
    [self.btnLink setTitle:@"Saznajte više" forState:UIControlStateNormal];
    
    
    if ([self.aktuelnost.link isEqualToString:@"0"] || self.aktuelnost.link.length == 0) {
        [self.btnLink setHidden:YES];
    }
    else{
        [self.btnLink setHidden:NO];
    }
    
}

- (void)buttonCancelClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonLinkClicked:(id)sender {
    self.navigationItem.backBarButtonItem.title = @"";
    [self setTitle:@""];
    
    DMWebViewController* webVC = [[DMWebViewController alloc] initWithNibName:@"DMWebViewController" bundle:[NSBundle mainBundle] andAktuelnost:self.aktuelnost];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

@end
