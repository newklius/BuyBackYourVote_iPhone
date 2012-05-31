//
//  FilterViewController.h
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/29/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyGraphViewController.h"

@interface FilterViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *states;
}

@property (weak, nonatomic) NSArray *years;
@property (weak, nonatomic) CompanyGraphViewController *graphController;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *groupingPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seatPicker;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end
