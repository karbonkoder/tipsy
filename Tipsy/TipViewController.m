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
    self.billTextField.delegate = self;
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
    double billAmountValue = [self getCentValueAsDouble:self.billTextField.text];
    
    double tipAmountValue = billAmountValue * [self.tipArray[self.tipPercent.selectedSegmentIndex] doubleValue] / 100.0f;
    
    double totalAmountValue = billAmountValue + tipAmountValue;
    
    self.tipAmount.text = [self getCurrencyFormattedTextFromDouble:tipAmountValue];

    self.totalAmount.text = [self getCurrencyFormattedTextFromDouble:totalAmountValue];
}

-(NSString *)getCleanCentString:(NSString *)text {
    return [[text componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

-(NSInteger) getCentValue:(NSString *)text {
    return [[self getCleanCentString:text] intValue];
}

-(double) getCentValueAsDouble:(NSString *)text {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSNumber *myNumber = [f numberFromString:[self getCleanCentString:text]];
    return [myNumber doubleValue];
}

-(NSString *) getCurrencyFormattedTextFromDouble:(double)myDoubleNumber {
    NSNumber *formatedValue = [[NSNumber alloc] initWithDouble:myDoubleNumber/ 100.0f];
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [_currencyFormatter stringFromNumber:formatedValue];
}

// Inspired from http://stackoverflow.com/a/24342726/566878
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger centValue = [self getCentValue:textField.text];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    double myDoubleNumber = [self getCentValueAsDouble:textField.text];
    
    if([textField.text length] < 16){
        if (string.length > 0) {
            centValue = centValue * 10 + [string intValue];
            myDoubleNumber = myDoubleNumber * 10 +  [[f numberFromString:string] doubleValue];
        } else {
            centValue = centValue / 10;
            myDoubleNumber = myDoubleNumber/10;
        }
        
        textField.text = [self getCurrencyFormattedTextFromDouble:myDoubleNumber];
        return NO;
    } else {
        textField.text = [self getCurrencyFormattedTextFromDouble:0.0];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Max Bill Amount"
                                                       message: @"Woah! Dude you got some huge bill!"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"OK",nil];
        
        [alert show];
        return NO;
    }
    return YES;
}
@end
