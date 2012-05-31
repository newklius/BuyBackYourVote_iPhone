//
//  BillDetailViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BillDetailViewController.h"
#import "Bill.h"

@interface BillDetailViewController ()

@end

@implementation BillDetailViewController

@synthesize titleLabel;
@synthesize positionLabel;
@synthesize numberLabel;
@synthesize linkLabel;
@synthesize summaryText;

@synthesize bill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*titleLabel.text = bill.billTitle;
    if (bill.support) {
        positionLabel.text = @"Support";
    }
    else {
        positionLabel.text = @"Oppose";
    }
    numberLabel.text = bill.billNumber;
    // make the link a textfield or a URL somehow or axe it
    summaryText.text = bill.summary;*/
}

- (void)viewDidUnload
{
    [self setSummaryText:nil];
    [self setTitleLabel:nil];
    [self setPositionLabel:nil];
    [self setNumberLabel:nil];
    [self setLinkLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
