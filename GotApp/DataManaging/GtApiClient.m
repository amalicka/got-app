//
//  GtApiClient.m
//  GotApp
//
//  Created by Ola Skierbiszewska on 11.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import "GtApiClient.h"
#import "StringConstants.h"
#import "GtCharacter.h"
#import "GtFavManager.h"

@implementation GtApiClient

+(instancetype)sharedSingleton{
    static GtApiClient *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GtApiClient alloc] init];
    });
    return instance;
}

- (void)getData{
    GtApiClient __weak *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *url = [NSURL URLWithString:kMainUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          GtApiClient __strong *strongSelf = weakSelf;
                                          if (error != nil) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if(strongSelf.delegate){
                                                      [strongSelf.delegate retrievedCharacters:nil favCharacters:nil andPath:nil error:[NSError errorWithDomain:@"Gt" code:400 userInfo: @{kErrorInfo : AS(@"errorGettingData")}]];
                                                  }
                                              });
                                              
                                          }
                                          else {
                                              NSError *errorJ = nil;
                                              NSDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJ];
                                              if(error != nil){
                                                  if(strongSelf.delegate){
                                                      [strongSelf.delegate retrievedCharacters:nil favCharacters:nil andPath:nil error:[NSError errorWithDomain:@"Gt" code:400 userInfo: @{kErrorInfo : AS(@"errorGettingData")}]];
                                                  }
                                              }else{
                                                  NSString *basePath;
                                                  NSMutableArray *parsedCharacters = [[NSMutableArray alloc] init];
                                                  NSMutableArray *favCharacters = [[NSMutableArray alloc] init];
                                                  if([json valueForKey: kBasepath]){
                                                      basePath = [json valueForKey: kBasepath];
                                                  }
                                                  if([json valueForKey: kItems]){
                                                      NSArray *arr = [json valueForKey: kItems];
                                                      for(NSDictionary *dict in arr){
                                                          GtCharacter *character = [[GtCharacter alloc] initWithDictionary:dict];
                                                          if(character){
                                                              if([GtFavManager isCharacterInFav:character.characterId]){
                                                                  character.isInFav = YES;
                                                                  [favCharacters addObject:character];
                                                              }else{
                                                                  character.isInFav = NO;
                                                              }
                                                              [parsedCharacters addObject:character];
                                                          }
                                                      }
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          if(strongSelf.delegate){
                                                              [strongSelf.delegate retrievedCharacters:parsedCharacters favCharacters:favCharacters andPath:basePath error:nil];
                                                          }
                                                      });
                                                  }
                                              }
                                          }
                                      }];
        [task resume];
    });
}

@end
