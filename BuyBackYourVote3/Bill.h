//
//  Bill.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject

@property (nonatomic, copy) NSString *billTitle;
@property (nonatomic, copy) NSString *billNumber;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) BOOL support; // vs oppose

-(id)initWithTitle:(NSString *)title number:(NSString *)number link:(NSString *)link summary:(NSString *)summary support:(BOOL)support;

@end
