//
//  FilterViewController.m
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/29/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController
@synthesize years, graphController, seatPicker, groupingPicker, picker;

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
    states = [NSArray arrayWithObjects:@"All states",@"AK",@"AL",@"AR",@"AZ",@"CA",@"CO",@"CT",@"DC",@"DE",@"FL",@"GA",@"HI",@"IA",@"ID",@"IL",@"IN",@"KS",@"KY",@"LA",@"MA",@"MD",@"ME",@"MI",@"MN",@"MO",@"MS",@"MT",@"NC",@"ND",@"NE",@"NH",@"NJ",@"NM",@"NV",@"NY",@"OH",@"OK",@"OR",@"PA",@"RI",@"SC",@"SD",@"TN",@"TX",@"UT",@"VA",@"VT",@"WA",@"WI",@"WV",@"WY",nil];
    int grouping;
    if ([self.graphController.groupingFilter isEqualToString:@"party"]) {
        grouping = 0;
    } else { // candidate
        grouping = 1;
    }
    self.groupingPicker.selectedSegmentIndex = grouping;
    int seat;
    if (![self.graphController.seatFilter isMemberOfClass:[NSString class]]) {
        seat = 3;
    } else if ([self.graphController.seatFilter isEqualToString:@"President"]) {
        seat = 0;
    } else if ([self.graphController.seatFilter isEqualToString:@"House"]) {
        seat = 1;
    } else { // Senate
        seat = 2;
    }
    self.seatPicker.selectedSegmentIndex = seat;
    [self.picker selectRow:[states indexOfObject:self.graphController.stateFilter] inComponent:0 animated:NO];
    [self.picker selectRow:[self.graphController.years indexOfObject:self.graphController.yearFilter] inComponent:1 animated:NO];
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return [states count];
    else
        return [self.graphController.years count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
        return [states objectAtIndex:row];
    else
        return [NSString stringWithFormat:@"%d", [[self.graphController.years objectAtIndex:row] intValue]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    NSString *grouping;
    switch (self.groupingPicker.selectedSegmentIndex) {
        case 0:
            grouping = @"party";
            break;
        case 1:
            grouping = @"candidate";
            break;
    }
    NSString *seat;
    switch (self.seatPicker.selectedSegmentIndex) {
        case 0:
            seat = @"President";
            break;
        case 1:
            seat = @"House";
            break;
        case 2:
            seat = @"Senate";
            break;
        case 3:
            seat = nil;
            break;
    }
    self.graphController.groupingFilter = grouping;
    self.graphController.seatFilter = seat;
    int stateIndex = [self.picker selectedRowInComponent:0];
    if (stateIndex == 0)
        self.graphController.stateFilter = nil;
    else
        self.graphController.stateFilter = [states objectAtIndex:stateIndex];
    [self.graphController loadContributionsWithYear:[years objectAtIndex:[self.picker selectedRowInComponent:1]]];
}

@end
