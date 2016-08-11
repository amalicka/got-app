//
//  UIColor+Gt.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 11.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "UIColor+Gt.h"

@implementation UIColor (Gt)

+(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *) gtStarsColor{
    return [self colorFromHexString:@"#FFD700"];
}

@end
