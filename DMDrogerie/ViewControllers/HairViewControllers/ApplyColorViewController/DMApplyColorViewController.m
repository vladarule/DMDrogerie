//
//  DMApplyColorViewController.m
//  DMDrogerie
//
//  Created by Vlada on 4/21/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMApplyColorViewController.h"
#import "DMCompareViewController.h"
#import "DMHairHelpViewController.h"

#import "DMRequestManager.h"
#import "DMHairColorManufacturer.h"

#import "UIKit+AFNetworking.h"
#import "MBProgressHUD.h"

@interface DMApplyColorViewController ()

@property (nonatomic, strong)UIImage* selectedImage;
@property (nonatomic, strong)UIImage* selectedMaskImage;
@property (nonatomic, strong)UIImage* clippedImage;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewMask;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewModel;

@property (weak, nonatomic) IBOutlet UIView *viewColors;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)NSArray* dataSource;

@property (nonatomic, strong)DMHairColorManufacturer* manufacturer;
@property (nonatomic, strong)DMHairColor* hairColor;

@property (nonatomic, strong)UIColor* clr;
@property (weak, nonatomic) IBOutlet UIView *helperView;

@property (nonatomic, assign)NSInteger bri;

@property (weak, nonatomic) IBOutlet UIButton *btnManufacturer;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewManufacturer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewFavs;



@end

@implementation DMApplyColorViewController

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
//    [self.imgViewMask setContentMode:UIViewContentModeCenter];
    
    
//    [self.imgViewMask setBackgroundColor:[UIColor redColor]];
    [self.imgViewModel setImage:self.selectedImage];
    
    [self.imgViewMask setFrame:self.imgViewModel.frame];
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_hair_help"] style:UIBarButtonItemStyleDone target:self action:@selector(btnHelpClicked)];
    [self.navigationItem setRightBarButtonItem:helpBtn];

    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  HAIR COLOR EXPERT" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
    
    self.clippedImage = [self clipImage];
    
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 15, self.view.bounds.size.width - 10, 40)];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
    [self.scrollView setDelegate:self];
    [self.viewColors addSubview:self.scrollView];
    
    
    NSLog(@"Manafacturers %lu", (unsigned long)[DMRequestManager sharedManager].arrayHairColors.count);
    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:0];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.blondColors];
    
    [self.imgViewManufacturer setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.manufacturer.imgUrl]]];
    
    [self setupScrollView];
    

    
//    NSArray* arr = [NSArray arrayWithArray:[self getRGBAsFromImage:selectedPartImg atX:0 andY:0 count:selectedPartImg.size.width * selectedPartImg.size.height]];
    NSArray* arr = [NSArray arrayWithArray:[self getPixelArray:self.clippedImage xCoordinate:0 yCoordinate:0]];
    
    
    
    
    int brojObradjenihPiksela = 0;
    long double brightnessUkupno = 0;
    for (UIColor* color in arr) {
        long double br = [self getBrOfPixel:color];
        brojObradjenihPiksela++;
        brightnessUkupno = brightnessUkupno + br;
    }
    
    self.bri = (int)(brightnessUkupno/brojObradjenihPiksela);
    
    
    DMHairColor* c = [self.dataSource firstObject];
    self.hairColor = c;
    
//    [self.imgViewMask setImage:[self coloredImage:self.selectedMaskImage withColor:c.color]];
    
    UIImage* finalImg = [self blendImage:[self convertToGrayscaleImage:self.clippedImage] withImage:[self coloredImage:self.selectedMaskImage withColor:c.color]];
    [self.imgViewMask setImage:finalImg];
    
    float colorBrigtnes = [self getBrOfPixel:c.color];
    float vrednostOsvetljaja = - 1.05769f * self.bri + 138.0f;
    
    float granicaPotamni = -30.0;
    float granicaProsvetli = 30;
    
    float m = (granicaProsvetli - granicaPotamni) / 255.0;
    float vrednostOsvetljajaDodatni = m * colorBrigtnes + granicaPotamni;
    
    NSLog(@"Vrednost osvetljaja %f", vrednostOsvetljaja);
    NSLog(@"Vrednost osvetljaja dodatni %f", vrednostOsvetljajaDodatni);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCloseClicked:(id)sender {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.viewFavs setHidden:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    
}

- (IBAction)btnManufacturerClicked:(id)sender {
    
    if ([DMRequestManager sharedManager].arrayHairColors.count > 1) {
        
        
        [self.tableView reloadData];
        
        
        [self.lblTitle setText:@"Izaberite proizvodjača"];
        [self.viewFavs setHidden:NO];
        [self.scrollView setUserInteractionEnabled:NO];
        [self.view bringSubviewToFront:self.viewFavs];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"";
        hud.detailsLabelText = @"Trenutno nema ponuda drugih proizvođača farbi za kosu.";
        hud.margin = 10.f;
        hud.yOffset = 130.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
    }
    
}


- (void)btnHelpClicked{
    DMHairHelpViewController* hairHelpVC = [[DMHairHelpViewController alloc] initWithNibName:@"DMHairHelpViewController" bundle:[NSBundle mainBundle] andIndex:2];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:hairHelpVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
}

-(UIImage *)coloredImage:(UIImage *)firstImage withColor:(UIColor *)color {
//    UIColor *color = <# UIColor #>;
//    UIImage *image = <# UIImage #>;// Image to mask with
    UIGraphicsBeginImageContextWithOptions(firstImage.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, firstImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, firstImage.size.width, firstImage.size.height), [firstImage CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, firstImage.size.width, firstImage.size.height));
    
    UIImage* coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

- (UIImage *)blendImage:(UIImage *)botImage withImage:(UIImage *)topImage{
  
    
    CGSize newSize = botImage.size;
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    // Use existing opacity as is
    [botImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    [topImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setupScrollView{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
//    [self.imgNail setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.nailColor.manufacturerLogo]]];
    

    
    for (int i = 0; i < self.dataSource.count; i++) {
        DMHairColor* clr = [self.dataSource objectAtIndex:i];
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(i * 45, 0, 40, 40)];
        [btn setBackgroundColor:clr.color];
        [btn addTarget:self action:@selector(btnColorClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i + 1];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [self.scrollView addSubview:btn];
        [self.scrollView setContentSize:CGSizeMake(btn.frame.origin.x + 40, 40)];
    }
    
}
- (void)btnColorClicked:(UIButton *)sender{
    
    NSLog(@"Color clicked");
    
    DMHairColor* hairCol = [self.dataSource objectAtIndex:sender.tag - 1];
    self.hairColor = hairCol;
    
    UIImage* finalImg = [self blendImage:[self convertToGrayscaleImage:self.clippedImage] withImage:[self coloredImage:self.selectedMaskImage withColor:hairCol.color]];
    [self.imgViewMask setImage:finalImg];
//    [self.imgViewMask setImage:[self coloredImage:self.selectedMaskImage withColor:hairCol.color]];
    
}

- (double)getBrOfPixel:(UIColor *)color{
    CGFloat redQ;
    CGFloat greenQ;
    CGFloat blueQ;
    CGFloat alphaQ;
    BOOL success = [color getRed:&redQ green:&greenQ blue:&blueQ alpha:&alphaQ];
    if (success) {
//        NSLog(@"Succ");
    }
    else{
        NSLog(@"Error");
    }
    
    
    redQ = redQ * 255.0;
    greenQ = greenQ * 255.0;
    blueQ = blueQ * 255.0;
    
    return sqrtl(redQ * redQ * 0.241 + greenQ * greenQ * 0.691 + blueQ * blueQ * 0.68);
}

- (NSArray *)getPixelArray:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    NSMutableArray *result = [NSMutableArray array];
    
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    

    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    NSLog(@"Img size = %f", image.size.width * image.size.height);
    
    for (int i = 0; i < image.size.height * image.size.width * 4; ++i) {
        
        
        UInt8 red = data[pixelInfo];         // If you need this info, enable it
        UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
        UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
        UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
        
    
        if (alpha > 0.0) {
            UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
            [result addObject:color];
            if (result.count == 500) {
                self.clr = color;
            }
        }
        
        pixelInfo += 4;
        
    }
    CFRelease(pixelData);
    
     // The pixel color info
    
    
    return result;

    
}


//- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
//{
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
//    
//    // First get the image into your data buffer
//    CGImageRef imageRef = [image CGImage];
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    CGColorSpaceRelease(colorSpace);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
//    CGContextRelease(context);
//    
//    // Now your rawData contains the image data in the RGBA8888 pixel format.
//    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
//    for (int i = 0 ; i < count ; ++i)
//    {
//        CGFloat redC   = (rawData[byteIndex]     * 1.0) / 255.0;
//        CGFloat greenC = (rawData[byteIndex + 1] * 1.0) / 255.0;
//        CGFloat blueC  = (rawData[byteIndex + 2] * 1.0) / 255.0;
//        CGFloat alphaC = (rawData[byteIndex + 3] * 1.0) / 255.0;
//        byteIndex += bytesPerPixel;
//        
//        
//        if (alphaC > 0) {
//            UIColor *acolor = [UIColor colorWithRed:redC green:greenC blue:blueC alpha:alphaC];
//            [result addObject:acolor];
//        }
//
//        
//    }
//    
//    free(rawData);
//    
//    return result;
//}

- (UIImage* )clipImage{
    
    UIGraphicsBeginImageContextWithOptions(self.imgViewModel.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, self.imgViewModel.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGImageRef maskImage = [self.selectedMaskImage CGImage];
    CGContextClipToMask(context, self.imgViewModel.bounds, maskImage);
    
    CGContextTranslateCTM(context, 0.0, self.imgViewModel.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    [[self.imgViewModel image] drawInRect:self.imgViewModel.bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (UIImage *)convertToGrayscaleImage:(UIImage *)img {
    CGSize size = [img size];
    int width = size.width;
    int height = size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [img CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[3] + 0.59 * rgbaPixel[2] + 0.11 * rgbaPixel[1];
            
            // set the pixels to gray
            rgbaPixel[3] = gray;
            rgbaPixel[2] = gray;
            rgbaPixel[1] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

- (IBAction)btnBlondColorsClicked:(id)sender {
//    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:0];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.blondColors];
    
    [self setupScrollView];
}

- (IBAction)btnRedColorsClicked:(id)sender {
//    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:0];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.redColors];
    
    [self setupScrollView];
    
}

- (IBAction)btnBrownColorsClicked:(id)sender {
//    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:0];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.brownColors];
    
    [self setupScrollView];
}

- (IBAction)btnDarkColorsClicked:(id)sender {
//    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:0];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.darkColors];
    
    [self setupScrollView];
}

- (IBAction)btnRecColorsClicked:(id)sender {
    int cat = 0;
    
    if (self.bri < 61) {
        cat = 1;
    }
    else if (self.bri < 121){
        cat = 2;
    }
    else if (self.bri < 181){
        cat = 3;
    }
    else{
        cat = 4;
    }
    
    NSMutableArray* arr = [NSMutableArray array];
    
    

    for (DMHairColorManufacturer* man in [DMRequestManager sharedManager].arrayHairColors) {
        for (DMHairColor* c in man.redColors) {
            if (cat == c.category) {
                [arr addObject:c];
            }
        }
        for (DMHairColor* c in man.darkColors) {
            if (cat == c.category) {
                [arr addObject:c];
            }
        }
        for (DMHairColor* c in man.blondColors) {
            if (cat == c.category) {
                [arr addObject:c];
            }
        }
        for (DMHairColor* c in man.brownColors) {
            if (cat == c.category) {
                [arr addObject:c];
            }
        }
    }
    
    self.dataSource = [NSArray arrayWithArray:arr];
    [self setupScrollView];
    
}

- (IBAction)btnFinishClicked:(id)sender {
    [self.imgViewManufacturer setHidden:YES];
    
    self.navigationItem.backBarButtonItem.title = @"";
    [self setTitle:@""];
    DMCompareViewController* compareVc = [[DMCompareViewController alloc] initWithNibName:@"DMCompareViewController" bundle:[NSBundle mainBundle] originalImage:self.selectedImage finalImage:[self snapshot:self.helperView] manafacturer:self.manufacturer andColor:self.hairColor];
    [self.navigationController pushViewController:compareVc animated:YES];
    
    [self.imgViewManufacturer setHidden:NO];
    
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)firstBtnClicked:(UIButton *)sender{
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    
    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:path.row * 2];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.blondColors];
    
    [self.imgViewManufacturer setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.manufacturer.imgUrl]]];
    
    [self setupScrollView];
    
    
    
    //    NSArray* arr = [NSArray arrayWithArray:[self getRGBAsFromImage:selectedPartImg atX:0 andY:0 count:selectedPartImg.size.width * selectedPartImg.size.height]];
    NSArray* arr = [NSArray arrayWithArray:[self getPixelArray:self.clippedImage xCoordinate:0 yCoordinate:0]];
    
    
    
    
    int brojObradjenihPiksela = 0;
    long double brightnessUkupno = 0;
    for (UIColor* color in arr) {
        long double br = [self getBrOfPixel:color];
        brojObradjenihPiksela++;
        brightnessUkupno = brightnessUkupno + br;
    }
    
    self.bri = (int)(brightnessUkupno/brojObradjenihPiksela);
    
    
    DMHairColor* c = [self.dataSource firstObject];
    self.hairColor = c;
    
    //    [self.imgViewMask setImage:[self coloredImage:self.selectedMaskImage withColor:c.color]];
    
    UIImage* finalImg = [self blendImage:[self convertToGrayscaleImage:self.clippedImage] withImage:[self coloredImage:self.selectedMaskImage withColor:c.color]];
    [self.imgViewMask setImage:finalImg];
    
    float colorBrigtnes = [self getBrOfPixel:c.color];
    float vrednostOsvetljaja = - 1.05769f * self.bri + 138.0f;
    
    float granicaPotamni = -30.0;
    float granicaProsvetli = 30;
    
    float m = (granicaProsvetli - granicaPotamni) / 255.0;
    float vrednostOsvetljajaDodatni = m * colorBrigtnes + granicaPotamni;
    
    
    
    [self btnCloseClicked:nil];
    

    
}

- (void)secondBtnClicked:(UIButton *)sender{
    UITableViewCell* cell;
    
    id temp = [[sender superview] superview];
    
    if ([temp isKindOfClass:[UITableViewCell class]]) {
        cell = temp;
    }
    else {
        cell = (UITableViewCell *)[[[sender superview] superview] superview];
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    
    
    self.manufacturer = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:path.row * 2 + 1];
    self.dataSource = [NSArray arrayWithArray:self.manufacturer.blondColors];
    
    [self.imgViewManufacturer setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.manufacturer.imgUrl]]];
    
    [self setupScrollView];
    
    
    
    //    NSArray* arr = [NSArray arrayWithArray:[self getRGBAsFromImage:selectedPartImg atX:0 andY:0 count:selectedPartImg.size.width * selectedPartImg.size.height]];
    NSArray* arr = [NSArray arrayWithArray:[self getPixelArray:self.clippedImage xCoordinate:0 yCoordinate:0]];
    
    
    
    
    int brojObradjenihPiksela = 0;
    long double brightnessUkupno = 0;
    for (UIColor* color in arr) {
        long double br = [self getBrOfPixel:color];
        brojObradjenihPiksela++;
        brightnessUkupno = brightnessUkupno + br;
    }
    
    self.bri = (int)(brightnessUkupno/brojObradjenihPiksela);
    
    
    DMHairColor* c = [self.dataSource firstObject];
    self.hairColor = c;
    
    //    [self.imgViewMask setImage:[self coloredImage:self.selectedMaskImage withColor:c.color]];
    
    UIImage* finalImg = [self blendImage:[self convertToGrayscaleImage:self.clippedImage] withImage:[self coloredImage:self.selectedMaskImage withColor:c.color]];
    [self.imgViewMask setImage:finalImg];
    
    float colorBrigtnes = [self getBrOfPixel:c.color];
    float vrednostOsvetljaja = - 1.05769f * self.bri + 138.0f;
    
    float granicaPotamni = -30.0;
    float granicaProsvetli = 30;
    
    float m = (granicaProsvetli - granicaPotamni) / 255.0;
    float vrednostOsvetljajaDodatni = m * colorBrigtnes + granicaPotamni;
    
    
    
    [self btnCloseClicked:nil];
}

#pragma mark - UITabeleViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ceil(((float)[DMRequestManager sharedManager].arrayHairColors.count) / 2.0);

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [Helper getStringFromStr:@"NailsCellIdentifier"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIImageView* imgViewType = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [imgViewType setTag:1];
        imgViewType.clipsToBounds = YES;
        imgViewType.layer.cornerRadius = 5;
        
        UIImageView* imgViewColor = [[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 40, 40)];
        [imgViewColor setTag:2];
        imgViewColor.layer.cornerRadius = 5;
        
        UILabel* colorName = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 110, 40)];
        [colorName setTextColor:[UIColor blueColor]];
        [colorName setFont:[UIFont systemFontOfSize:[Helper getFontSizeFromSz:12.0]]];
        [colorName setTag:3];
        
        
        
        UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 100, 100)];
        [btn1 addTarget:self action:@selector(firstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTag:11];
        
        UIImageView* imgView1 = [[UIImageView alloc] initWithFrame:btn1.frame];
        [imgView1 setTag:21];
        
        
        UIButton* btn2 = [[UIButton alloc] initWithFrame:CGRectMake(150, 10, 100, 100)];
        [btn2 addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTag:12];
        
        UIImageView* imgView2 = [[UIImageView alloc] initWithFrame:btn2.frame];
        [imgView2 setTag:22];
        
        
        [cell addSubview:imgViewType];
        [cell addSubview:imgViewColor];
        [cell addSubview:colorName];
        
        [cell addSubview:btn1];
        [cell addSubview:btn2];
        [cell addSubview:imgView1];
        [cell addSubview:imgView2];
        
    }
    
    
    UIImageView* imgViewType = (UIImageView *)[cell viewWithTag:1];
    UIImageView* imgViewColor = (UIImageView *)[cell viewWithTag:2];
    UILabel* colorName = (UILabel *)[cell viewWithTag:3];
    
    UIButton* btn1 = (UIButton *)[cell viewWithTag:11];
    
    UIButton* btn2 = (UIButton *)[cell viewWithTag:12];
    UIImageView* imgView1 = (UIImageView *)[cell viewWithTag:21];
    UIImageView* imgView2 = (UIImageView *)[cell viewWithTag:22];
    
        [imgViewType setHidden:YES];
        [imgViewColor setHidden:YES];
        [colorName setHidden:YES];

        
        
        
        if (indexPath.row * 2 < [DMRequestManager sharedManager].arrayHairColors.count) {
            
            [btn1 setHidden:NO];
            [btn1 setEnabled:YES];
            [imgView1 setHidden:NO];
            
            DMHairColorManufacturer* first = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:indexPath.row * 2];
            [imgView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, first.imgUrl]]];
            
        }
        else{
            [btn1 setHidden:YES];
            [btn1 setEnabled:NO];
            [imgView1 setHidden:YES];
        }
        
        if (indexPath.row * 2 + 1 < [DMRequestManager sharedManager].arrayHairColors.count) {
            [btn2 setHidden:NO];
            [btn2 setEnabled:YES];
            [imgView2 setHidden:NO];
            
            DMHairColorManufacturer* second = [[DMRequestManager sharedManager].arrayHairColors objectAtIndex:indexPath.row * 2 + 1];
            [imgView2 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, second.imgUrl]]];
        }
        else{
            [btn2 setHidden:YES];
            [btn2 setEnabled:NO];
            [imgView2 setHidden:YES];
        }
        
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            return 120.0;
        }
        else{
            return 160.0;
        }
    
    
}



@end
