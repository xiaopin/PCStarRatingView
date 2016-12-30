//
//  ViewController.m
//  Demo
//
//  Created by nhope on 2016/12/29.
//  Copyright © 2016年 xiaopin. All rights reserved.
//

#import "ViewController.h"
#import "PCStarRatingView.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet PCStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.starView addTarget:self
                      action:@selector(starValueDidChanged:)
            forControlEvents:UIControlEventValueChanged];
    
    // 要求用户必须给一星的评价
    [self.starView setMinimumValue:1.0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)changeStarColorAction:(UIButton *)sender {
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                     green:arc4random_uniform(256)/255.0
                                      blue:arc4random_uniform(256)/255.0
                                     alpha:1.0];
    [self.starView setStarTintColor:color];
}

- (IBAction)changeStarItemSpacingAction:(UISlider *)sender {
    [self.starView setItemSpacing:sender.value*20];
}

- (IBAction)changeMaximumValueAction:(UIStepper *)sender {
    [self.starView setMaximumValue:sender.value];
}

- (IBAction)changeStarStateAction:(UISegmentedControl *)sender {
    PCStarRatingViewState state = sender.selectedSegmentIndex;
    [self.starView setStarState:state];
}

- (IBAction)changeStarBorderWidthAction:(UISlider *)sender {
    [self.starView setBorderWidth:sender.value];
}

- (IBAction)changeValueButtonAction:(UIButton *)sender {
    float value = [self.textField.text floatValue];
    [self.starView setValue:value];
    [self.textField setText:nil];
    [self.textField resignFirstResponder];
}

- (IBAction)changeStarRadiusTypeAction:(UISegmentedControl *)sender {
    PCStarRatingViewRadiusType type = sender.selectedSegmentIndex;
    [self.starView setRadiusType:type];
}


- (void)starValueDidChanged:(PCStarRatingView *)sender {
    [self.valueLabel setText:[NSString stringWithFormat:@"星星的值:%f", sender.value]];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
