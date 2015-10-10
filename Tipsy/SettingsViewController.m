//
//  SettingsViewController.m
//  Tipsy
//
//  Created by Ankush Raina on 10/2/15.
//  Copyright © 2015 Ankush Raina. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController()
@property (weak, nonatomic) IBOutlet UITextField *smallText;
@property (weak, nonatomic) IBOutlet UITextField *mediumText;
@property (weak, nonatomic) IBOutlet UITextField *largeText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSegment;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float small = [defaults floatForKey:@"small"];
    float medium = [defaults floatForKey:@"medium"];
    float large = [defaults floatForKey:@"large"];
    long defaultSegmentIndex = [defaults integerForKey:@"defaultSegmentIndex"];
    
    self.smallText.text = [NSString stringWithFormat:@"%0.0f", small];
    self.mediumText.text = [NSString stringWithFormat:@"%0.0f", medium];
    self.largeText.text = [NSString stringWithFormat:@"%0.0f", large];
    
    [self updateTipSegment];
    
    self.tipSegment.selectedSegmentIndex = defaultSegmentIndex;
}

-(void)updateTipSegment {
    [self.tipSegment setTitle:[NSString stringWithFormat:@"%@%%", self.smallText.text] forSegmentAtIndex:0];
    [self.tipSegment setTitle:[NSString stringWithFormat:@"%@%%", self.mediumText.text] forSegmentAtIndex:1];
    [self.tipSegment setTitle:[NSString stringWithFormat:@"%@%%", self.largeText.text] forSegmentAtIndex:2];
}

-(void)updateNSUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:[self.smallText.text floatValue] forKey:@"small"];
    [defaults setFloat:[self.mediumText.text floatValue] forKey:@"medium"];
    [defaults setFloat:[self.largeText.text floatValue] forKey:@"large"];
    
    [defaults setInteger:self.tipSegment.selectedSegmentIndex forKey:@"defaultSegmentIndex"];
    [defaults synchronize];
}

- (IBAction)tapPressed:(id)sender {
    [self updateTipSegment];
    [self updateNSUserDefaults];
}
- (IBAction)tipSegmentPressed:(id)sender {
    [self updateNSUserDefaults];
}

@end
