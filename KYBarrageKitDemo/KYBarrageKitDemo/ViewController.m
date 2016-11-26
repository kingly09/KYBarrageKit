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
    _manager.scrollDirection = KYBarrageScrollDirectRightToLeft;
    _manager.displayLocation = KYBarrageDisplayLocationTypeDefault;

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




#pragma mark - BarrageManagerDelegate
- (id)barrageManagerDataSource {
    
    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@"%d digg",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = _manager.displayLocation;
    m.direction       = _manager.scrollDirection;
    m.barrageType = KYBarrageDisplayTypeImage;
    m.object = [UIImage imageNamed:[NSString stringWithFormat:@"digg_%d",arc4random() % 10]];
    return m;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:self.view];
  [[_manager barrageScenes] enumerateObjectsUsingBlock:^(KYBarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj.layer.presentationLayer hitTest:touchPoint]) {
      /* if barrage's type is ` KYBarrageDisplayTypeVote ` or `KYBarrageDisplayTypeImage`, add your code here*/
      NSLog(@"message = %@",obj.model.message.string);
      
      [obj pause];
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The barrage was clicked ！"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
      [alert addAction:[UIAlertAction
                        actionWithTitle:@"pause for 3 seconds" style:UIAlertActionStyleDefault
                        
                        handler:^(UIAlertAction *action) {
                          
                          int delayInSeconds = 3 ;
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [obj resume];
                          });
                          
                        }]];
      [self presentViewController:alert animated:YES completion:nil];
      
      
    }
  }];
}

UIColor * RandomColor() {
    float a = (arc4random() % 255) / 255.0;
    float b = (arc4random() % 255) / 255.0;
    float c = (arc4random() % 255) / 255.0;
    
    return [UIColor colorWithRed:a green:b blue:c alpha:1.0];
}

- (IBAction)displayLocationAction:(UIButton *)sender{
   
   NSInteger displayLocation = sender.tag - 100;
   if (displayLocation == KYBarrageDisplayLocationTypeDefault) {
      _manager.displayLocation = KYBarrageDisplayLocationTypeDefault;
      
   }else if (displayLocation == KYBarrageDisplayLocationTypeTop) {
      _manager.displayLocation = KYBarrageDisplayLocationTypeTop;
      
   }else if (displayLocation == KYBarrageDisplayLocationTypeCenter) {
      _manager.displayLocation = KYBarrageDisplayLocationTypeCenter;
      
   }else if (displayLocation == KYBarrageDisplayLocationTypeBottom) {
      _manager.displayLocation = KYBarrageDisplayLocationTypeBottom;
      
   }
   
   [self sendBarrage];
}

- (IBAction)scrollDirectionAction:(UIButton *)sender{
   NSInteger  scrollDirection =  sender.tag - 200;
   if (scrollDirection == KYBarrageScrollDirectRightToLeft) {
      _manager.scrollDirection = KYBarrageScrollDirectRightToLeft;
      
   }else if (scrollDirection == KYBarrageScrollDirectLeftToRight) {
      _manager.scrollDirection = KYBarrageScrollDirectLeftToRight;
      
   }else if (scrollDirection == KYBarrageScrollDirectBottomToTop) {
      _manager.scrollDirection = KYBarrageScrollDirectBottomToTop;
      
   }else if (scrollDirection == KYBarrageScrollDirectTopToBottom) {
      _manager.scrollDirection = KYBarrageScrollDirectTopToBottom;
      
   } 
  
   [self sendBarrage];
}



- (void)sendBarrage{
  
    //_manager passive barrage
    
    int a = arc4random() % 100000;
    NSString *str = [NSString stringWithFormat:@"I'm coming %d ",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = _manager.displayLocation;
    m.direction       = _manager.scrollDirection;
    m.barrageType = KYBarrageDisplayTypeDefault;
    [_manager showBarrageWithDataSource:m];

}
- (IBAction)cleanAllBarrages:(id)sender {
     //On the screen the current barrage delete, and stop acquiring new barrage
     [_manager closeBarrage];
}
- (IBAction)pauseAllScroll:(UIButton *)sender {
    
    sender.selected = !sender.selected; 
    
    if (sender.selected == YES) {
       [sender setTitle:@"ReStartAll" forState:UIControlStateNormal];
   }else{
       [sender setTitle:@"pauseAll" forState:UIControlStateNormal];
   }
    // 1. On the screen the barrage is suspended, and stop acquiring new barrage
    // 2. The current barrage on the screen to start rolling, and to obtain a new barrage
    [_manager pauseScroll];
}
- (IBAction)startNewScroll:(id)sender {

   [_manager startScroll];

}



@end
