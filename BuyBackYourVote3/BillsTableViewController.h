//
//  BillsTableViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillsDataController;

@interface BillsTableViewController : UITableViewController
@property (strong, nonatomic) BillsDataController *billsDataController;
@end
