//
//  GtCharacter.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 09.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "GtCharacter.h"

@implementation GtCharacter

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.characterId = dictionary[@"id"];
        self.title = dictionary[@"title"];
        self.abstract = dictionary[@"abstract"];
        self.imageWidth = ((NSDictionary*)(dictionary[@"original_dimensions"])) [@"width"];
        self.imageHeight = ((NSDictionary*)(dictionary[@"original_dimensions"])) [@"height"];
        self.thumbnail = dictionary[@"thumbnail"];
        self.url = dictionary[@"url"];
        self.thumbnail = [self.thumbnail stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    }
    return self;
}

@end
