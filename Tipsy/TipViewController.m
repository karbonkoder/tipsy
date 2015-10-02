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

@property (strong, nonatomic) NSMutableArray *tipArray;
@end

@implementation TipViewController

@synthesize tipArray = _tipArray;

-(NSMutableArray*) tipArray {
    if (_tipArray == nil) {
        _tipArray = @[@(.15), @(.2), @(.25)].mutableCopy;
    }
    
    return _tipArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readNSUserDefaults];
    [self calculateTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [self readNSUserDefaults];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}

-(void) readNSUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tipArray[0] = [NSNumber numberWithFloat:[defaults floatForKey:@"small"]];
    self.tipArray[1] = [NSNumber numberWithFloat:[defaults floatForKey:@"medium"]];
    self.tipArray[2] = [NSNumber numberWithFloat:[defaults floatForKey:@"large"]];
    
    long defaultSegmentIndex = [defaults integerForKey:@"defaultSegmentIndex"];
    
    [self.tipPercent setTitle:[NSString stringWithFormat:@"%@%%", self.tipArray[0]] forSegmentAtIndex:0];
    [self.tipPercent setTitle:[NSString stringWithFormat:@"%@%%", self.tipArray[1]] forSegmentAtIndex:1];
    [self.tipPercent setTitle:[NSString stringWithFormat:@"%@%%", self.tipArray[2]] forSegmentAtIndex:2];
    
    self.tipPercent.selectedSegmentIndex = defaultSegmentIndex;
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
    
    float tipAmountValue = billAmountValue * [self.tipArray[self.tipPercent.selectedSegmentIndex] floatValue] / 100.0;
    
    float totalAmountValue = billAmountValue + tipAmountValue;
    
    self.tipAmount.text = [NSString stringWithFormat:@"$%0.2f", tipAmountValue];
    
    self.totalAmount.text = [NSString stringWithFormat:@"$%0.2f", totalAmountValue];
}
@end
