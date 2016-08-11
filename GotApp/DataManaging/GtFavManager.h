//
//  GtFavManager.h
//  GotApp
//
//  Created by Ola Skierbiszewska on 09.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GtFavManager : NSObject

+ (void)saveCharacterIdToFavorites: (NSNumber*)characterId;

+ (void)removeCharacterIdFromFavorites: (NSNumber*)characterId;

+ (NSArray*)getFavCharacters;

+ (BOOL)isCharacterInFav:(NSNumber *)characterId;

@end
