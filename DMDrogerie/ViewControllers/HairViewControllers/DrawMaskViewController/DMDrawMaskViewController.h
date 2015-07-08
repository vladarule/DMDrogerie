//
//  DMDrawMaskViewController.h
//  DMDrogerie
//
//  Created by Vlada on 4/10/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DMDrawMaskViewController : UIViewController{
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andImage:(UIImage *)image andMask:(UIImage *)mask;

@end
