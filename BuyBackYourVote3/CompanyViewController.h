//
//  CompanyViewController.h
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/25/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@protocol CompanyViewController <NSObject>
@required
- (void)loadFromCompany:(Company *)comp;
@end



@interface CompanyViewController : UITableViewController <CompanyViewController> {
    NSMutableData *responseData;
}

@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSDictionary *parent;
@property (nonatomic, strong) NSArray *informationItems;
@property (nonatomic, weak) Company *company;
@property (nonatomic, weak) UIImageView *logoImage;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end
