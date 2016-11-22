//
//  KYBarrageScene.m
//  KYBarrageKitDemo
//
//  Created by kingly on 2016/11/22.
//  Copyright © 2016年 KYBarrageKit  Software (https://github.com/kingly09/KYBarrageKit) by kingly inc.

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE. All rights reserved.
//

#import "KYBarrageScene.h"


@implementation KYBarrageScene

- (instancetype)initWithModel:(KYBarrageModel *)model {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Model:(KYBarrageModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
       self.model = model;
    }
    return self;
}

// Add to SuperView and start scrolling
- (void)scroll {

    //calculate time of scroll barrage
    CGFloat distance = 0.0;
    CGPoint goalPoint = CGPointZero;
    switch (_model.direction) {
        case KYBarrageScrollDirectRightToLeft:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case KYBarrageScrollDirectLeftToRight:
            distance = CGRectGetWidth(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetWidth(_model.bindView.bounds) + CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));
            break;
        case KYBarrageScrollDirectBottomToTop:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), -CGRectGetHeight(self.frame));
            break;
        case KYBarrageScrollDirectTopToBottom:
            distance = CGRectGetHeight(_model.bindView.bounds);
            goalPoint = CGPointMake(CGRectGetMinX(self.frame), CGRectGetHeight(self.frame) + CGRectGetMaxY(_model.bindView.bounds));
            break;
        default:
            break;
    }
    NSTimeInterval time = distance / _model.speed;
    
    CGRect goalFrame = self.frame;
    goalFrame.origin = goalPoint;
        
    // Layer execution animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.removedOnCompletion = true;
    animation.autoreverses = false;
    animation.fillMode = kCAFillModeForwards;
    
    [animation setToValue:[NSValue valueWithCGPoint:CenterPoint(goalFrame)]];
    [animation setDuration:time];
    [self.layer addAnimation:animation forKey:@"kAnimation_BarrageScene"];
}

- (void)dealloc {
//    NSLog(@"scene dealloc");
}

- (void)setupUI {
    // text
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_titleLabel];
    
    // button
    _voteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    _voteButton.hidden = true;
    _voteButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_voteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_voteButton setTitle:@"Vote" forState:UIControlStateNormal];
    [self addSubview:_voteButton];
}

- (void)pause {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resume {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    self.layer.speed = 1.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

- (void)close {
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}


#pragma mark - 计算Frame
- (void)calculateFrame {
    /* 1. setup UI (基础UI设置) */
    _titleLabel.attributedText = _model.message;
//    _titleLabel.textColor = _model.textColor;

    /* 2. determine barrage's type  (判断弹幕类型) */
    switch (_model.barrageType) {
        case KYBarrageDisplayTypeVote:
            // - voting type -
            [_titleLabel sizeToFit];
            _voteButton.hidden = false;
            [_voteButton sizeToFit];
            CGRect frame = _voteButton.frame;
            frame.origin.x = CGRectGetMaxX(_titleLabel.frame);
            frame.origin.y = CGRectGetMinY(_titleLabel.frame);
            frame.size.height = CGRectGetHeight(_titleLabel.frame);
            _voteButton.frame = frame;
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + CGRectGetWidth(_voteButton.frame), CGRectGetHeight(_titleLabel.frame));
            break;
         case KYBarrageDisplayTypeImage:
            /* text and image */
            
            [_titleLabel sizeToFit];
            _voteButton.hidden = false;
            [_voteButton sizeToFit];
            CGRect imageframe = _voteButton.frame;
            imageframe.origin.x = CGRectGetMaxX(_titleLabel.frame);
            imageframe.origin.y = CGRectGetMinY(_titleLabel.frame);
            imageframe.size.height = CGRectGetHeight(_titleLabel.frame);
            _voteButton.frame = imageframe;
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + CGRectGetWidth(_voteButton.frame), CGRectGetHeight(_titleLabel.frame));
            break;
            
        case KYBarrageDisplayTypeOther:
            // - other types -
            
            break;
        default:
            // --BarrageDisplayTypeDefault--
            
            _voteButton.hidden = true;
            [_titleLabel sizeToFit];
            self.bounds = _titleLabel.bounds;
            break;
    }
    
    //Calculate a barrage of random position
    self.frame = [self calculateBarrageSceneFrameWithModel:_model];
}

//MARK: The calculation of random barrage Frame
-(CGRect) calculateBarrageSceneFrameWithModel:(KYBarrageModel *)model {
    CGPoint originPoint;
    CGRect sourceFrame = CGRectZero;
    switch (model.displayLocation) {
        case KYBarrageDisplayLocationTypeDefault:
            sourceFrame = model.bindView.bounds;
            break;
        case KYBarrageDisplayLocationTypeTop:
            sourceFrame = CGRectMake(0, 0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        case KYBarrageDisplayLocationTypeCenter:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds) / 3.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        case KYBarrageDisplayLocationTypeBottom:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds) / 3.0 * 2.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds) / 3.0);
            break;
        default:
            break;
    }
    switch (model.direction) {
        case KYBarrageScrollDirectRightToLeft:
            originPoint = CGPointMake(CGRectGetMaxX(sourceFrame), RandomBetween(0, CGRectGetHeight(sourceFrame) - CGRectGetHeight(self.bounds)));
            break;
        case KYBarrageScrollDirectLeftToRight:
            originPoint = CGPointMake(-CGRectGetWidth(self.bounds), RandomBetween(0, CGRectGetHeight(sourceFrame) - CGRectGetHeight(self.bounds)));
            break;
        case KYBarrageScrollDirectBottomToTop:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), CGRectGetMaxY(sourceFrame) + CGRectGetHeight(self.bounds));
            break;
        case KYBarrageScrollDirectTopToBottom:
            originPoint = CGPointMake(RandomBetween(0, CGRectGetWidth(sourceFrame)), -CGRectGetHeight(self.bounds));
            break;
        default:
            break;
    }
    
    CGRect frame = self.frame;
    frame.origin = originPoint;
    
    return frame;
}


#pragma mark - AnimatonDelegate

// stop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        __weak typeof(self) SELF = self;
        
        if (_animationDidStopBlock) {
            _animationDidStopBlock(SELF);
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if ([_voteButton pointInside:point withEvent:event]) {
        NSLog(@"click~~~");
    }
    return [super hitTest:point withEvent:event];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}

#pragma mark - Other Method
// return a ` float ` Between `smallerNumber ` and ` largerNumber `
float RandomBetween(float smallerNumber, float largerNumber) {
    //Set the exact number of bits
    int precision = 100;
    //First get the difference between them.
    float subtraction = largerNumber - smallerNumber;
    //Absolute value
    subtraction = ABS(subtraction);
    //Multiplied by the number of bits
    subtraction *= precision;
    //Random between the difference
    float randomNumber = arc4random() % ((int)subtraction+1);
    //Random results divided by the number of bits of precision
    randomNumber /= precision;
    //Add a random value to a smaller value.
    float result = MIN(smallerNumber, largerNumber) + randomNumber;
    //Return result
    return result;
}

//Return to the center of a Frame
CGPoint CenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


@end
