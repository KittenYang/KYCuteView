//
//  ViewController.m
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ViewController.h"
#import "KYCuteView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    KYCuteView *kycuteview = [[KYCuteView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:kycuteview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
