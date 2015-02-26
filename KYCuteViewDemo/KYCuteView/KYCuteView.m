//
//  KYCuteView.m
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYCuteView.h"


@implementation KYCuteView{
    CGRect viewFrame;
    UIView *frontView;
    UIView *backView;
}



-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        viewFrame = frame;
        [self setUp];
        [self addGesture];
    }
    return self;
}



-(void)setUp{
    
    frontView = [[UIView alloc]initWithFrame:self.bounds];
    frontView.layer.cornerRadius = viewFrame.size.width / 2;
    frontView.backgroundColor = [UIColor redColor];
    
    backView = [[UIView alloc]initWithFrame:self.bounds];
    backView.layer.cornerRadius = viewFrame.size.width / 2;
    backView.backgroundColor = [UIColor greenColor];
 
    
    [self addSubview:backView];
    [self addSubview:frontView];
}


-(void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
    [frontView addGestureRecognizer:pan];

}


-(void)dragMe:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self.superview.superview];
    if (ges.state == UIGestureRecognizerStateChanged) {
        frontView.center = dragPoint;
    }
}



@end
