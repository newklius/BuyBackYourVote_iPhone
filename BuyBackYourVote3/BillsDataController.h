//
//  BillsDataController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bill;

@interface BillsDataController : NSObject

@property (nonatomic, copy) NSMutableArray *billsList;

- (NSUInteger)countOfBillsList;
- (Bill *)objectInBillsListAtIndex:(NSUInteger)index;
- (void)addBillWithTitle:(NSString *)title number:(NSString *)number link:(NSString *)link summary:(NSString *)summary support:(BOOL)support;

@end
