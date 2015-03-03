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
@property (nonatomic,assign)CGFloat bubbleWidth;
@property (nonatomic,assign)CGFloat viscosity;
@property (nonatomic,strong)UIColor *bubbleColor;

-(id)initWithPoint:(CGPoint)point superView:(UIView *)view;
-(void)setUp;
-(void)addGesture;


@end
