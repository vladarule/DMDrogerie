//
//  DMCompareViewController.m
//  DMDrogerie
//
//  Created by Vlada on 5/4/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMCompareViewController.h"

#import "MBProgressHUD.h"

#import "DMHairHelpViewController.h"

#import "DMHairImgShareViewController.h"

@interface DMCompareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOriginal;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewFinal;

@property (nonatomic, strong)UIImage* originalImage;
@property (nonatomic, strong)UIImage* finalImage;
@property (weak, nonatomic) IBOutlet UIImageView *separator;

@property (weak, nonatomic) IBOutlet UIView *helperView;
@property (weak, nonatomic) IBOutlet UILabel *lblBefore;
@property (weak, nonatomic) IBOutlet UILabel *lblAfter;

@property (nonatomic, strong)DMHairColorManufacturer* colorManufacturer;
@property (nonatomic, strong)DMHairColor* hairColor;

@end

@implementation DMCompareViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil originalImage:(UIImage *)image finalImage:(UIImage *)final manafacturer:(DMHairColorManufacturer *)man andColor:(DMHairColor *)color{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.originalImage = image;
        self.finalImage = final;
        self.colorManufacturer = man;
        self.hairColor = color;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_hair_help"] style:UIBarButtonItemStyleDone target:self action:@selector(btnHelpClicked)];
    [self.navigationItem setRightBarButtonItem:helpBtn];
    
    [self.imgViewOriginal setImage:self.originalImage];
    [self.imgViewFinal setImage:self.finalImage];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  HAIR COLOR EXPERT" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self.lblBefore setBackgroundColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [self.lblBefore setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.lblBefore setTextColor:[UIColor whiteColor]];
    
    
    [self.lblAfter setBackgroundColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0]];
    [self.lblAfter setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.lblAfter setTextColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnHelpClicked{
    DMHairHelpViewController* hairHelpVC = [[DMHairHelpViewController alloc] initWithNibName:@"DMHairHelpViewController" bundle:[NSBundle mainBundle] andIndex:3];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:hairHelpVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
}

- (IBAction)btnSaveClicked:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.finalImage, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
    
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
        NSLog(@"%@", error.localizedDescription);
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"";
        hud.detailsLabelText = @"Slika je sačuvana";
        hud.margin = 10.f;
        hud.yOffset = 130.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        
    }
}

- (IBAction)btnShareClicked:(id)sender {
    
    
    DMHairImgShareViewController* shareVC = [[DMHairImgShareViewController alloc] initWithNibName:@"DMHairImgShareViewController" bundle:[NSBundle mainBundle] finalImage:self.finalImage manafacturer:self.colorManufacturer andColor:self.hairColor];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:shareVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
//    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.finalImage] applicationActivities:nil];
//    [activityVC setValue:NSLocalizedString(@"DM Srbija", @"") forKey:@"subject"];
//    
//    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
//        //        if (completed) {
//        //           if (activityType.length == 0) {
//        //     }
//        //        }
//    }];
//    
//    NSArray* exclude = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
//    [activityVC setExcludedActivityTypes:exclude];
//    
//    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)btnFinishClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    CGRect rct = self.helperView.frame;
    rct.size.width = currentPoint.x;
    [self.helperView setFrame:rct];
    
    CGPoint point = self.separator.center;
    point.x = currentPoint.x;
    self.separator.center = point;
}


@end
