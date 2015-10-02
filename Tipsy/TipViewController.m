//
//  ViewController.m
//  Tipsy
//
//  Created by Ankush Raina on 10/1/15.
//  Copyright © 2015 Ankush Raina. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipPercent;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self calculateTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)tapPressed:(id)sender {
    [self.view endEditing:YES];
    [self calculateTip];
}
- (IBAction)tipPercentChanged:(id)sender {
    [self calculateTip];
}

-(void)calculateTip {
    float billAmountValue = [self.billTextField.text floatValue];
    
    NSArray *tipArray = @[@(.15), @(.2), @(.25)];
    
    float tipAmountValue = billAmountValue * [tipArray[self.tipPercent.selectedSegmentIndex] floatValue];
    
    float totalAmountValue = billAmountValue + tipAmountValue;
    
    self.tipAmount.text = [NSString stringWithFormat:@"$%0.2f", tipAmountValue];
    
    self.totalAmount.text = [NSString stringWithFormat:@"$%0.2f", totalAmountValue];
}
@end
