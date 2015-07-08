//
//  DMChooseImageViewController.m
//  DMDrogerie
//
//  Created by Vlada on 4/6/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMChooseImageViewController.h"
#import "DMDrawMaskViewController.h"
#import "DMSelectModelViewController.h"

#import "DMHairHelpViewController.h"

@interface DMChooseImageViewController () <DMSelectModelDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong)UIImage* selectedImage;

@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UIView *helperView;
@property (weak, nonatomic) IBOutlet UIView *helperViewMask;

@property (strong, nonatomic) UIImageView *maskImageView;
@end

@implementation DMChooseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.selectedImage = [UIImage imageNamed:@"model.jpg"];
    

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    
    [self initializeImgViewWithImage:self.selectedImage andMaskImg:[UIImage imageNamed:@"maska.png"]];
    
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_hair_help"] style:UIBarButtonItemStyleDone target:self action:@selector(btnHelpClicked)];
    [self.navigationItem setRightBarButtonItem:helpBtn];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  HAIR COLOR EXPERT" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];
}

- (void)btnHelpClicked{
    DMHairHelpViewController* hairHelpVC = [[DMHairHelpViewController alloc] initWithNibName:@"DMHairHelpViewController" bundle:[NSBundle mainBundle]];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:hairHelpVC];
    
    [self presentViewController:navCon animated:YES completion:nil];
}

- (void)initializeImgViewWithImage:(UIImage *)img andMaskImg:(UIImage* )mask{
    
    for (UIGestureRecognizer* r in self.imageView.gestureRecognizers) {
        [self.imageView removeGestureRecognizer:r];
    }
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.helperView.frame.size.width, self.helperView.frame.size.height)];
    [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView setMultipleTouchEnabled:YES];
    [self.imageView setImage:img];
    
    [self.helperView addSubview:self.imageView];
    
    [self.maskImageView removeFromSuperview];
    self.maskImageView = nil;
    
    self.maskImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    [self.maskImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.maskImageView setImage:mask];
    [self.maskImageView setContentMode:UIViewContentModeScaleAspectFit];
    
//    [self.maskImageView setHidden:YES];

    [self.helperViewMask addSubview:self.maskImageView];
//    [self.helperViewMask setHidden:YES];
    
    
    [self.view addSubview:self.helperViewMask];

    [self.view sendSubviewToBack:self.helperViewMask];
    

    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [self.imageView addGestureRecognizer:pinchGesture];
    
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [rotationGesture setDelegate:self];
    [self.imageView addGestureRecognizer:rotationGesture];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:panRecognizer];
}

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (IBAction)btnCameraClicked:(id)sender {
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

- (IBAction)btnGaleryClicked:(id)sender {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)btnModelClicked:(id)sender {
    
    self.selectedImage = [UIImage imageNamed:@"model.jpg"];
    [self initializeImgViewWithImage:self.selectedImage andMaskImg:[UIImage imageNamed:@"maska.png"]];
    
}

- (IBAction)btnSablonClicked:(id)sender {
    
    DMSelectModelViewController* selectModelVC = [[DMSelectModelViewController alloc] initWithNibName:@"DMSelectModelViewController" bundle:[NSBundle mainBundle]];
    selectModelVC.delegate = self;
    
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:selectModelVC];
    [self presentViewController:navCon animated:YES completion:nil];
    
}

- (IBAction)btnNextClicked:(id)sender {
    
//    [self.maskImageView setHidden:NO];
    DMDrawMaskViewController* drawVC = [[DMDrawMaskViewController alloc] initWithNibName:@"DMDrawMaskViewController" bundle:[NSBundle mainBundle] andImage:[self snapshot:self.helperView] andMask:[self snapshot:self.helperViewMask]];
//    [self.maskImageView setHidden:YES];
    UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:drawVC];
    [self presentViewController:navCon animated:YES completion:nil];
    
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        self.maskImageView.transform = CGAffineTransformRotate([self.maskImageView transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        
        self.maskImageView.transform = CGAffineTransformScale([self.maskImageView transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

-(void)move:(UIPanGestureRecognizer *)gesture
{
    [self adjustAnchorPointForGestureRecognizer:gesture];
    
    if (gesture.state==UIGestureRecognizerStateChanged)
    {
        //We're moving!
        UIView *aRootView = self.helperView;
        CGPoint currentOrigin = [gesture translationInView:aRootView];
        self.imageView.center = CGPointMake(self.imageView.center.x + currentOrigin.x, self.imageView.center.y + currentOrigin.y);
        
        self.maskImageView.center = CGPointMake(self.maskImageView.center.x + currentOrigin.x, self.maskImageView.center.y + currentOrigin.y);
        
        [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
        
        self.maskImageView.layer.anchorPoint = CGPointMake(locationInView.x / self.maskImageView.bounds.size.width, locationInView.y / self.maskImageView.bounds.size.height);
        self.maskImageView.center = locationInSuperview;
    }
}

#pragma mark - ImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.selectedImage = info[UIImagePickerControllerOriginalImage];
    [self initializeImgViewWithImage:self.selectedImage andMaskImg:[UIImage new]];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark = SelctMdoel delegates

- (void)selectModelViewControllerDictionarySelected:(NSDictionary *)dict{
    
    [self initializeImgViewWithImage:[UIImage imageWithData:[dict objectForKey:@"originalImage"]] andMaskImg:[UIImage imageWithData:[dict objectForKey:@"maskImage"]]];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
