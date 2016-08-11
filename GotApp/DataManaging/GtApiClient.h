//
//  GtApiClient.h
//  GotApp
//
//  Created by Ola Skierbiszewska on 11.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GtApiClientDelegate <NSObject>

- (void)retrievedCharacters:(NSArray *)items favCharacters:(NSArray *)favItems andPath:(NSString *)path error:(NSError*) error;

@end

@interface GtApiClient : NSObject

@property (nonatomic, strong) id<GtApiClientDelegate> delegate;

+(instancetype)sharedSingleton;

- (void)getData;

@end
