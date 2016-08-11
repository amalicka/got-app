//
//  GtFavManager.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 09.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "GtFavManager.h"

@implementation GtFavManager

+ (void)saveCharacterIdToFavorites: (NSNumber*)characterId{
    NSMutableArray *iDs = [[NSMutableArray alloc] init];
    [self makeIdsArrayIfNotExist];
    [iDs addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"favIds"]];
    if(![iDs containsObject: characterId]){
        [iDs addObject:characterId];
        [[NSUserDefaults standardUserDefaults] setObject: [iDs copy] forKey: @"favIds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)removeCharacterIdFromFavorites: (NSNumber*)characterId{
    NSMutableArray *iDs = [[NSMutableArray alloc] init];
    [self makeIdsArrayIfNotExist];
    [iDs addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"favIds"]];
    if([iDs containsObject: characterId]){
        [iDs removeObject:characterId];
        [[NSUserDefaults standardUserDefaults] setObject: [iDs copy] forKey: @"favIds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray*)getFavCharacters{
    [self makeIdsArrayIfNotExist];
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"favIds"];
}

+ (void)makeIdsArrayIfNotExist{
    if(![[NSUserDefaults standardUserDefaults] objectForKey: @"favIds"]){
        [[NSUserDefaults standardUserDefaults] setObject: [[NSArray alloc] init] forKey: @"favIds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)isCharacterInFav:(NSNumber *)characterId{
    NSMutableArray *iDs = [[NSMutableArray alloc] init];
    [self makeIdsArrayIfNotExist];
    [iDs addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"favIds"]];
    return [iDs containsObject: characterId];
}


@end
