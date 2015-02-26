//
//  KYCuteView.m
//  KYCuteViewDemo
//
//  Created by Kitten Yang on 2/26/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "KYCuteView.h"


@implementation KYCuteView{
    
    UIBezierPath *cutePath;
    UIColor *fillColor;
    UIDynamicAnimator *animator;
    UISnapBehavior  *snap;
    
    CADisplayLink *displayLink;
    
    UIView *frontView;
    UIView *backView;
    CGFloat r1; // backView
    CGFloat r2; // frontView
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint oldBackViewCenter;
    CAShapeLayer *shapeLayer;
    
}

//每隔一帧刷新的定时器
-(void)displayLinkAction:(CADisplayLink *)dis{

    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    NSLog(@"%f", acosf(cosDigree));
    r1 = 25 - centerDistance/5;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    

    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    

    backView.frame = CGRectMake(oldBackViewFrame.origin.x, oldBackViewFrame.origin.y, r1*2, r1*2);
    backView.layer.cornerRadius = r1;
    
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    
    if (backView.hidden == NO) {
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColor CGColor];
        [self.layer addSublayer:shapeLayer];
    }
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddPath(context, cutePath.CGPath);
//    [fillColor setFill];
//    CGContextFillPath(context);

    
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self addGesture];
    }
    return self;
}



-(void)setUp{


    shapeLayer = [CAShapeLayer layer];
    
    self.backgroundColor = [UIColor whiteColor];
    frontView = [[UIView alloc]initWithFrame:CGRectMake(100,400, 50, 50)];
    r2 = frontView.bounds.size.width / 2;
    frontView.layer.cornerRadius = r2;
    frontView.backgroundColor = [UIColor redColor];
    
    backView = [[UIView alloc]initWithFrame:frontView.frame];
    r1 = backView.bounds.size.width / 2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = [UIColor redColor];
 
    [self addSubview:backView];
    [self addSubview:frontView];
    
    
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);
    pointP = CGPointMake(x2+r2, y2);
    
    oldBackViewFrame = backView.frame;
    oldBackViewCenter = backView.center;

}


-(void)addGesture{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
    [frontView addGestureRecognizer:pan];

}


-(void)dragMe:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self];

    
    if (ges.state == UIGestureRecognizerStateBegan) {
        backView.hidden = NO;
        fillColor = [UIColor redColor];
        
        if (displayLink == nil) {
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }

    }else if (ges.state == UIGestureRecognizerStateChanged){
        frontView.center = dragPoint;
        if (r1 <= 0) {

            fillColor = [UIColor clearColor];
            [shapeLayer removeFromSuperlayer];
            [displayLink invalidate];
            displayLink = nil;
        }

    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        
        backView.hidden = YES;
        fillColor = [UIColor clearColor];
        [shapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            frontView.center = oldBackViewCenter;
        } completion:^(BOOL finished) {
            
            if (finished) {
                [displayLink invalidate];
                displayLink = nil;
            }
            
        }];
    
    }
    
}





@end
