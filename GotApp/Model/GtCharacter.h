//
//  GtCharacter.h
//  GotApp
//
//  Created by Ola Skierbiszewska on 09.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GtCharacter : NSObject

@property (nonatomic, strong) NSNumber *characterId;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *abstract;

@property (nonatomic, strong) NSString *thumbnail;

@property (nonatomic, strong) NSNumber *imageWidth;

@property (nonatomic, strong) NSNumber *imageHeight;

@property (nonatomic, strong) NSString *url;

@property (atomic) BOOL isInFav;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
