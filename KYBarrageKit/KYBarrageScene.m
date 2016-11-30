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
#import <QuartzCore/QuartzCore.h>
#import "KYBarrageManager.h"

@interface KYBarrageScene(){

        UIImageView *vipImageView;
}
@end

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

- (void)dealloc {
//    NSLog(@"scene dealloc");
}

- (void)setupUI {
    // text
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:_titleLabel];
    
    // button
    _voteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    _voteButton.hidden = true;
    _voteButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_voteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_voteButton setTitle:@"Vote" forState:UIControlStateNormal];
  
    [self addSubview:_voteButton];
    
    //imageView
    _imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y, 30, 30)];
    _imageView.hidden = true;
    [self addSubview:_imageView];
    
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

- (void)setModel:(KYBarrageModel *)model {
    _model = model;
    [self calculateFrame];
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

#pragma mark - Frame
- (void)calculateFrame {
    /* 1. setup UI  */
    _titleLabel.attributedText = _model.message;

    /* 2. determine barrage's type  */
    switch (_model.barrageType) {
        case KYBarrageDisplayTypeVote:
            // - voting type -
            _imageView.hidden = YES;
            [_titleLabel sizeToFit];
            _voteButton.hidden = false;
            [_voteButton sizeToFit];
            CGRect frame = _voteButton.frame;
            frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + 5;
            frame.origin.y = CGRectGetMinY(_titleLabel.frame);
            frame.size.height = CGRectGetHeight(_titleLabel.frame);
            _voteButton.frame = frame;
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_titleLabel.frame) + CGRectGetWidth(_voteButton.frame), CGRectGetHeight(_titleLabel.frame));
          
            break;
         case KYBarrageDisplayTypeImage:
         
            _voteButton.hidden = YES;
            /* text and image */
            if (_model.object !=nil) {
               UIImage *img = (UIImage *)_model.object;
               _imageView.image = img;
            }
            
            
            [_imageView.layer setMasksToBounds:YES];
            _imageView.layer.cornerRadius = 15;
            
            _imageView.hidden = false;
            [_imageView sizeToFit];
            
             CGRect imageframe = _imageView.frame;
             imageframe.size.width  = _model.ky_hight > 0?_model.ky_hight:30.0;
             imageframe.size.height = _model.ky_hight > 0?_model.ky_hight:30.0;
             
            _imageView.frame = imageframe;
                        
            [_titleLabel sizeToFit];
             CGRect titleLabelframe = _titleLabel.frame;
             titleLabelframe.origin.x = CGRectGetMaxX(_imageView.frame) + 5;
             titleLabelframe.origin.y = CGRectGetMinY(_imageView.frame) + (_imageView.frame.size.height - titleLabelframe.size.height)/2;
             _titleLabel.frame = titleLabelframe;
      
            
            self.bounds = CGRectMake(0, 0, CGRectGetWidth(_imageView.frame) + CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_imageView.frame));
             
            break;
          
      case KYBarrageDisplayTypeCustomView:
      {
        _voteButton.hidden = YES;
        /* text and image */
        if (_model.object !=nil) {
          UIImage *img = (UIImage *)_model.object;
          _imageView.image = img;
        }
        
      
        _imageView.hidden = false;
        [_imageView sizeToFit];
        
        CGRect imageframe = _imageView.frame;
        imageframe.size.width  = _model.ky_hight > 0?_model.ky_hight:30.0;
        imageframe.size.height = _model.ky_hight > 0?_model.ky_hight:30.0;
        
        _imageView.frame = imageframe;
        
        [_titleLabel sizeToFit];
        CGRect titleLabelframe = _titleLabel.frame;
        titleLabelframe.origin.x = CGRectGetMaxX(_imageView.frame) + 5;
        titleLabelframe.origin.y = CGRectGetMinY(_imageView.frame) + (_imageView.frame.size.height - titleLabelframe.size.height)/2;
        _titleLabel.frame = titleLabelframe;
        
         _imageView.clipsToBounds = YES;
         _imageView.layer.cornerRadius = 15;
         
        if (_model.barrageUser.userId > 0) {
          
          vipImageView = [[UIImageView alloc] init];
          vipImageView.frame = CGRectMake(20, 20, 12, 12);
          NSString *vImgStr = [NSString new];
          vImgStr = @"ic_small";
          if (_model.barrageUser.vip > 0) {
            vipImageView.hidden = NO;
            
            if (_model.barrageUser.vipFrom == 0) {
              
              vImgStr = [vImgStr stringByAppendingString:@"_red"];
            }else if (_model.barrageUser.vipFrom == 1){
              
              vImgStr = [vImgStr stringByAppendingString:@"_blue"];
            }
            vipImageView.image = [UIImage imageNamed:vImgStr];
          }else{
            vipImageView.hidden = YES;
          }
          
          [self addSubview:vipImageView];
          
        }
        
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(_imageView.frame) + CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_imageView.frame));
        
        }
        break;
        
      case KYBarrageDisplayTypeOther:
            // - other types -
            _voteButton.hidden = true;
            _imageView.hidden = true;
            [_titleLabel sizeToFit];
            self.bounds = _titleLabel.bounds;
          
            break;
        default:
            // --BarrageDisplayTypeDefault--
            _voteButton.hidden = true;
            _imageView.hidden = true;
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
            sourceFrame = CGRectMake(0, 0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds)/3.0);
            break;
        case KYBarrageDisplayLocationTypeCenter:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds)/3.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds)/3.0);
            break;
        case KYBarrageDisplayLocationTypeBottom:
            sourceFrame = CGRectMake(0, CGRectGetHeight(model.bindView.bounds)/3.0* 2.0, CGRectGetWidth(model.bindView.bounds), CGRectGetHeight(model.bindView.bounds)/3.0);
            break;
        default:
            break;
    }

    float random = RandomBetween(CGRectGetMinY(sourceFrame), CGRectGetMaxY(sourceFrame) - CGRectGetHeight(self.bounds));
    if (random  == CGRectGetMinY(sourceFrame) ) {
        random += CGRectGetHeight(self.bounds);
    }
    
    switch (model.direction) {
        case KYBarrageScrollDirectRightToLeft:
            originPoint = CGPointMake(CGRectGetMaxX(sourceFrame), random);
            break;
        case KYBarrageScrollDirectLeftToRight:
            originPoint = CGPointMake(-CGRectGetWidth(self.bounds),random);
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
        NSLog(@"_voteButton click~~~");
    }
    if ([_imageView pointInside:point withEvent:event]) {
        NSLog(@"_imageView click~~~");
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
    
    if (result < smallerNumber) {
      return smallerNumber;
    }
    //Return result
    return result;
}

//Return to the center of a Frame
CGPoint CenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


@end
