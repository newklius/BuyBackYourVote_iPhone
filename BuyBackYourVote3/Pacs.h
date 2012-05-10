//
//  Pacs.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pacs : NSObject

@property (nonatomic, copy) NSString *pacName;
@property (nonatomic, copy) NSString *cycle;
@property (nonatomic, copy) NSString *seat;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *party;
@property (nonatomic, copy) NSNumber *amount;

-(id)initWithName:(NSString *)name cycle:(NSString *)cycle seat:(NSString *)seat state:(NSString *)state party:(NSString *)party amount:(NSNumber *)amount;

@end
