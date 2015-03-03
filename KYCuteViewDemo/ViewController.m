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
    

    
    KYCuteView *cuteView = [[KYCuteView alloc]initWithPoint:CGPointMake(25, 505) superView:self.view];
    cuteView.bubbleText  = @"13";
    cuteView.viscosity  = 20;
    [cuteView setUp];
    [cuteView addGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
