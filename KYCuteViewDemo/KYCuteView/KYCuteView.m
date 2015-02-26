//
//  KYCuteView.m
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYCuteView.h"


@implementation KYCuteView{
    UIDynamicAnimator *animator;
    UISnapBehavior  *snap;
    
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
    
    frontView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    frontView.layer.cornerRadius = 50;
    frontView.backgroundColor = [UIColor redColor];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    backView.layer.cornerRadius = 50;
    backView.backgroundColor = [UIColor greenColor];
 
    
    [self addSubview:backView];
    [self addSubview:frontView];
}


-(void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
    [frontView addGestureRecognizer:pan];

}


-(void)dragMe:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self];
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:

            break;
        case UIGestureRecognizerStateChanged:
            frontView.center = dragPoint;
            break;
        case UIGestureRecognizerStateEnded:
            animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
            snap = [[UISnapBehavior alloc]initWithItem:frontView snapToPoint:backView.center];
            [animator addBehavior:snap];
            break;
            
        case UIGestureRecognizerStateCancelled:
            animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
            snap = [[UISnapBehavior alloc]initWithItem:frontView snapToPoint:backView.center];
            [animator addBehavior:snap];
            break;
        default:
            break;
    }
}



@end
