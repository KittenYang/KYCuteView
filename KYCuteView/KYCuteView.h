//
//  KYCuteView.h
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface KYCuteView : UIView


@property (nonatomic,weak)UIView *containerView;
@property (nonatomic,strong)NSString *bubbleText;
@property (nonatomic,assign)CGFloat viscosity;

-(id)initWithPoint:(CGPoint)point superView:(UIView *)view;
-(void)setUp;
-(void)addGesture;


@end
