//
//  DMDrawMaskViewController.m
//  DMDrogerie
//
//  Created by Vlada on 4/10/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMDrawMaskViewController.h"
#import "DMApplyColorViewController.h"
#import "DMHairHelpViewController.h"

#import "MBProgressHUD.h"

@interface DMDrawMaskViewController ()


@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong)UIImage* selectedImage;
@property (nonatomic, strong)UIImage* selectedMaskImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewModel;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDraw;
@property (weak, nonatomic) IBOutlet UIImageView *circleView;

@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd;
@property (weak, nonatomic) IBOutlet UIImageView *imgRemove;
@property (weak, nonatomic) IBOutlet UILabel *lblRemove;


@end

@implementation DMDrawMaskViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(UIImage *)image andMask:(UIImage *)mask{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedImage = image;
        self.selectedMaskImage = mask;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    [self.imgViewModel setContentMode:UIViewContentModeCenter];
//    [self.imgViewDraw setContentMode:UIViewContentModeCenter];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  HAIR COLOR EXPERT" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    [self.imgViewModel setImage:self.selectedImage];
    [self.imgViewDraw setImage:self.selectedMaskImage];
    
    red = 0.11764705882352941;
    green = 0;
    blue = 1.0;
    brush = 30.0;
    opacity = 0.60;
    
    [self.slider setMinimumValue:1.0];
    [self.slider setMaximumValue:50.0];
    [self.slider setValue:30.0];

    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(buttonCancelClicked:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    // Give the layer the same bounds as your image view
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.circleView bounds].size.width,
                                      [self.circleView bounds].size.height)];
    // Position the circle anywhere you like, but this will center it
    // In the parent layer, which will be your image view's root layer
    [circleLayer setPosition:CGPointMake([self.circleView bounds].size.width/2.0f,
                                         [self.circleView bounds].size.height/2.0f)];
    // Create a circle path.
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:
                          CGRectMake(0.0f, 0.0f, [self.circleView bounds].size.width, [self.circleView bounds].size.height)];
    // Set the path on the layer
    [circleLayer setPath:[path CGPath]];
    // Set the stroke color
    [circleLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    // Set the stroke line width
    [circleLayer setLineWidth:2.0f];
    
    // Add the sublayer to the image view's layer tree
    [[self.circleView layer] addSublayer:circleLayer];
    
    [self btnAddClicked:nil];
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_hair_help"] style:UIBarButtonItemStyleDone target:self action:@selector(btnHelpClicked)];
    [self.navigationItem setRightBarButtonItem:helpBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonCancelClicked:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnHelpClicked{
    DMHairHelpViewController* hairHelpVC = [[DMHairHelpViewController alloc] initWithNibName:@"DMHairHelpViewController" bundle:[NSBundle mainBundle]andIndex:1];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:hairHelpVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
}

- (IBAction)valueChanged:(id)sender {
    brush = self.slider.value;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, self.slider.value/30, self.slider.value/30);
    self.circleView.transform = transform;
}

- (IBAction)btnAddClicked:(id)sender {
    
    [self.lblAdd setTextColor:[UIColor whiteColor]];
    [self.lblRemove setTextColor:[UIColor lightGrayColor]];
    
    [self.imgAdd setImage:[UIImage imageNamed:@"btn_dodaj_selected"]];
    [self.imgRemove setImage:[UIImage imageNamed:@"btn_oduzmi"]];
    
    opacity = 0.60;
}

- (IBAction)btnDeleteClicked:(id)sender {
    
    [self.lblAdd setTextColor:[UIColor lightGrayColor]];
    [self.lblRemove setTextColor:[UIColor whiteColor]];
    
    [self.imgAdd setImage:[UIImage imageNamed:@"btn_dodaj"]];
    [self.imgRemove setImage:[UIImage imageNamed:@"btn_oduzmi_selected"]];
    
    opacity = 0.0;
    
}

- (IBAction)btnDeleteAllClicked:(id)sender {
    
    [self.imgViewDraw setImage:nil];
    
}

- (IBAction)btnSaveClicked:(id)sender {
    
    
    
    
    NSDictionary* dict = @{@"originalImage": UIImagePNGRepresentation(self.selectedImage), @"maskImage": UIImagePNGRepresentation(self.imgViewDraw.image)};
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"hairImages"]];
    [arr addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"hairImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"";
    hud.detailsLabelText = NSLocalizedString(@"Šablon sačuvan", @"");
    hud.margin = 10.f;
    hud.yOffset = 120.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
    return;
    
}

- (IBAction)btnnextClicked:(id)sender {
    self.navigationItem.backBarButtonItem.title = @"";
    [self setTitle:@""];
    DMApplyColorViewController* applyColorVC = [[DMApplyColorViewController alloc] initWithNibName:@"DMApplyColorViewController" bundle:[NSBundle mainBundle] andImage:self.selectedImage andMask:self.imgViewDraw.image];
    
    [self.navigationController pushViewController:applyColorVC animated:YES];
    
}




///////////// Ne treba mi za sada

//-(UIImage*)maskImage:(UIImage *)img withImage:(UIImage*)maskImage
//{
//    /// Create a bitmap context with valid alpha
//    const size_t originalWidth = (size_t)(img.size.width * 1.0);
//    const size_t originalHeight = (size_t)(img.size.height * 1.0);
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    
//    CGContextRef bmContext = CGBitmapContextCreate(nil, img.size.width, img.size.height, 8, 0, colorSpace, kCGBitmapByteOrderDefault);
//    if (!bmContext)
//    return nil;
//    
//    /// Image quality
//    CGContextSetShouldAntialias(bmContext, true);
//    CGContextSetAllowsAntialiasing(bmContext, true);
//    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
//    
//    /// Image mask
//    CGImageRef cgMaskImage = maskImage.CGImage;
//    CGImageRef mask = CGImageMaskCreate((size_t)maskImage.size.width, (size_t)maskImage.size.height, CGImageGetBitsPerComponent(cgMaskImage), CGImageGetBitsPerPixel(cgMaskImage), CGImageGetBytesPerRow(cgMaskImage), CGImageGetDataProvider(cgMaskImage), NULL, false);
//    
//    /// Draw the original image in the bitmap context
//    const CGRect r = (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = originalWidth, .size.height = originalHeight};
//    CGContextClipToMask(bmContext, r, cgMaskImage);
//    CGContextDrawImage(bmContext, r, img.CGImage);
//    
//    /// Get the CGImage object
//    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(bmContext);
//    /// Apply the mask
//    CGImageRef maskedImageRef = CGImageCreateWithMask(imageRefWithAlpha, mask);
//    
//    UIImage* result = [UIImage imageWithCGImage:maskedImageRef scale:1.0 orientation:img.imageOrientation];
//    
//    /// Cleanup
//    CGImageRelease(maskedImageRef);
//    CGImageRelease(imageRefWithAlpha);
//    CGContextRelease(bmContext);
//    CGImageRelease(mask);
//    
//    return result;
//}

#pragma mark - Drawing methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.imgViewDraw];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.imgViewDraw];
    
    UIGraphicsBeginImageContext(self.imgViewDraw.frame.size);
    [self.imgViewDraw.image drawInRect:CGRectMake(0, 0, self.imgViewDraw.frame.size.width, self.imgViewDraw.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    if (opacity < 0.2) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 0.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeClear);
    }
    else{
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeDestinationAtop);
    }
    
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imgViewDraw.image = UIGraphicsGetImageFromCurrentImageContext();
//    [self.imgViewDraw setAlpha:0.7];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.imgViewDraw.frame.size);
//        [self.imgViewDraw.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.imgViewDraw.image drawInRect:CGRectMake(0, 0, self.imgViewDraw.frame.size.width, self.imgViewDraw.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeDestinationAtop);
        
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.imgViewDraw.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}


@end
