//
//  CompanyTabViewController.h
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/24/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"

@interface CompanyTabViewController : UITabBarController

@property (copy, nonatomic) NSString *companyURL;
@property (copy, nonatomic) NSString *companyName;
@property (nonatomic, strong) Company *company;
@property (nonatomic, weak) UIBarButtonItem *filterButton;

@end
