//
//  Helper.m
//  DMDrogerie
//
//  Created by Vlada on 3/25/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (float)getFontSizeFromSz:(float)size{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return size;
    }
    else{
        return size * 1.6;
    }    
}

+ (NSString *)getStringFromStr:(NSString *)str{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return str;
    }
    else{
        return [str stringByAppendingString:@"_iPad"];
    }
}

@end
