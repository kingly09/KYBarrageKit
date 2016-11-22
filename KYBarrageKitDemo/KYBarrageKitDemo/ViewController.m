//
//  ViewController.m
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


#import "ViewController.h"

#import "KYBarrageKit.h"


typedef void(^MultiParmsBlock)(NSString *p1, ...);

@interface ViewController () <KYBarrageManagerDelegate>

@property (strong, nonatomic) KYBarrageManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
   self.view.backgroundColor = [UIColor whiteColor];
  
    _manager = [KYBarrageManager manager];
    _manager.bindingView = self.view;
    _manager.delegate = self;
    _manager.scrollSpeed = 30;
    _manager.memoryMode = KYBarrageMemoryWarningModeHalf;
    _manager.refreshInterval = 1.0;
    [_manager startScroll];
    
    


    

}

- (void)viewWillDisappear:(BOOL)animated {
    [_manager closeBarrage];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
   // When you receive a memory warning，clean the barrage's cache
    [_manager didReceiveMemoryWarning];
}

- (void)dealloc {
    [_manager toDealloc];
}


- (IBAction)sendBarrage:(id)sender {

    //_manager被动接收弹幕
    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@"%d 呵呵哒",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = KYBarrageDisplayLocationTypeTop;
    m.barrageType = KYBarrageDisplayTypeVote;
    
    [_manager showBarrageWithDataSource:m];

}


#pragma mark - BarrageManagerDelegate
- (id)barrageManagerDataSource {
    
    _manager.scrollDirection = KYBarrageScrollDirectRightToLeft;
    _manager.displayLocation = KYBarrageDisplayLocationTypeDefault;

    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@"%d hi",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = KYBarrageDisplayLocationTypeDefault;
    m.barrageType = KYBarrageDisplayTypeImage;
    m.object = [UIImage imageNamed:@"digg_1"];
    return m;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    [[_manager barrageScenes] enumerateObjectsUsingBlock:^(KYBarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
            /* if barrage's type is ` KYBarrageDisplayTypeVote ` or `KYBarrageDisplayTypeImage`, add your code here*/
            NSLog(@"message = %@",obj.model.message.string);
        }
    }];
}

UIColor * RandomColor() {
    float a = (arc4random() % 255) / 255.0;
    float b = (arc4random() % 255) / 255.0;
    float c = (arc4random() % 255) / 255.0;
    
    return [UIColor colorWithRed:a green:b blue:c alpha:1.0];
}




@end
