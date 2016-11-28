//
//  KYBarrageManager.m
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

#import "KYBarrageManager.h"
#define Weakself __weak typeof(self) weakSelf = self


@interface KYBarrageManager ()

@property (assign, nonatomic) KYBarrageStatusType currentStatus;

@property (strong, nonatomic) NSMutableArray *cachePool;

@property (strong, nonatomic) NSMutableArray *barrageScene;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation KYBarrageManager

#pragma mark - create manager

// singleton 
static KYBarrageManager *instance;

+ (instancetype)shareManager {
    if (!instance) {
        instance = [[KYBarrageManager alloc] init];
    }
    return instance;
}

+ (instancetype)manager {
    return [[KYBarrageManager alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollSpeed = KYBarrageDisplaySpeedTypeDefault;
        _displayLocation = KYBarrageDisplayLocationTypeDefault;
        _cachePool = [NSMutableArray array];
        _barrageScene = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    if ([_timer isValid]){
      [_timer invalidate];
      _timer = nil;
    } 
    
    if (_cachePool.count > 0) {
       [_cachePool removeAllObjects];
    }
   
    if (_barrageScene.count > 0) {
      [_barrageScene removeAllObjects];
    }
    
    NSLog(@"BarrageManager dealloc~");
}

- (NSMutableArray *)barrageCache {
    return _cachePool;
}

- (NSMutableArray<KYBarrageScene *> *)barrageScenes {
    return _barrageScene;
}

- (void)setRefreshInterval:(NSTimeInterval)refreshInterval {
    _refreshInterval = refreshInterval;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_refreshInterval target:self selector:@selector(buildBarrageScene) userInfo:nil repeats:true];
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - method

- (void)buildBarrageScene {
    /* build barrage model */
    if (![_delegate  respondsToSelector:@selector(barrageManagerDataSource)]) {
        return;
    }
    id data = [_delegate barrageManagerDataSource];
    if (!data) {
        return;
    }
    [self showWithData:data];
}

- (void)showBarrageWithDataSource:(id)data {
    if (!data) {
        return;
    }
    [self showWithData:data];
}

- (void)showWithData:(id)data {
    /*
     1. determine receiver's type 
     2. determine build a new scene OR Taken from the buffer pool inside 
     */
    _currentStatus = KYBarrageStatusTypeNormal;
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data isKindOfClass:[KYBarrageModel class]]) {
                //only a KYBarrageModel
                KYBarrageModel *model = data;
                model = [self sync_BarrageManagerConfigure:model];
                //Check whether the buffer pool is empty.
                if (_cachePool.count < 1) {
                    // nil
                    KYBarrageScene *scene = [[KYBarrageScene alloc] initWithFrame:CGRectZero Model:model];
                    [_barrageScene addObject:scene];
                    [_bindingView addSubview:scene];
                    Weakself;
                    scene.animationDidStopBlock = ^(KYBarrageScene *scene_){
                        [weakSelf.cachePool addObject:scene_];
                        [weakSelf.barrageScene removeObject:scene_];
                        [scene_ removeFromSuperview];
                    };
                    [scene scroll];
                    
                }else {
                    //From the buffer pool to Scene, it will be removed from the buffer pool
                    //                    NSLog(@"get from cache");
                    KYBarrageScene *scene =  _cachePool.firstObject;
                    [_barrageScene addObject:scene];
                    [_cachePool removeObjectAtIndex:0];
                    scene.model = model;
                    
                    [_bindingView addSubview:scene];
                    [scene scroll];
                }
            }else {
                // more than one barrage
                NSArray <KYBarrageModel *> *modelArray = data;
                [modelArray enumerateObjectsUsingBlock:^(KYBarrageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    KYBarrageModel *model = [self sync_BarrageManagerConfigure:obj];
                    //Check whether the buffer pool is empty.
                    if (_cachePool.count < 1) {
                        // nil
                        KYBarrageScene *scene = [[KYBarrageScene alloc] initWithFrame:CGRectZero Model:model];
                        [_barrageScene addObject:scene];
                        [_bindingView addSubview:scene];
                        Weakself;
                        scene.animationDidStopBlock = ^(KYBarrageScene *scene_){
                            [weakSelf.cachePool addObject:scene_];
                            [weakSelf.barrageScene removeObject:scene_];
                            [scene_ removeFromSuperview];
                        };
                        [scene scroll];
                        
                    }else {
                        //From the buffer pool to Scene, it will be removed from the buffer pool
                        
                        KYBarrageScene *scene =  _cachePool.firstObject;
                        [_barrageScene addObject:scene];
                        [_cachePool removeObjectAtIndex:0];
                        scene.model = model;
                        
                        [_bindingView addSubview:scene];
                        [scene scroll];
                    }
                }];
            }
        });
    }
}

-(KYBarrageModel *) sync_BarrageManagerConfigure:(KYBarrageModel *)model {
    model.speed = _scrollSpeed;
    model.direction = _scrollDirection;
    model.bindView = _bindingView;
    return model;
}

#pragma mark - Barrage Scroll / Pause / Cloese

- (void)startScroll {
    [_timer setFireDate:[NSDate date]];
}

- (void)pauseScroll {
    if (_currentStatus == KYBarrageStatusTypeClose) {
        [self startScroll];
        return;
    }
    if (_currentStatus == KYBarrageStatusTypeNormal) {
        //On the screen the barrage is suspended, and stop acquiring new barrage
        [_timer setFireDate:[NSDate distantFuture]];

        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KYBarrageScene *scene = obj;
            [scene pause];
        }];
        _currentStatus = KYBarrageStatusTypePause;
    }else if (_currentStatus == KYBarrageStatusTypePause) {
       //The current barrage on the screen to start rolling, and to obtain a new barrage
        [_timer setFireDate:[NSDate date]];
        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KYBarrageScene *scene = obj;
            [scene resume];
        }];
        _currentStatus = KYBarrageStatusTypeNormal;
    }
}

- (void)closeBarrage {
    if (_currentStatus == KYBarrageStatusTypeNormal || _currentStatus == KYBarrageStatusTypePause)  {
        _currentStatus = KYBarrageStatusTypeClose;
        // On the screen the current barrage delete, and stop acquiring new barrage
        [_timer setFireDate:[NSDate distantFuture]];

        [self.barrageScenes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KYBarrageScene *scene = obj;
            [scene close];
        }];
   }
//    }else if (_currentStatus == KYBarrageStatusTypeClose || _currentStatus == KYBarrageStatusTypePause) {
//        _currentStatus = KYBarrageStatusTypeNormal;
//        [_timer setFireDate:[NSDate date]];
//    }
}

- (void)toDealloc {
    
    if ([_timer isValid]){
      [_timer invalidate];
      _timer = nil;
    } 
    
    if (_cachePool.count > 0) {
       [_cachePool removeAllObjects];
    }
   
    if (_barrageScene.count > 0) {
      [_barrageScene removeAllObjects];
    }

}

- (void)didReceiveMemoryWarning {
    switch (_memoryMode) {
        case KYBarrageMemoryWarningModeHalf:
            [self cleanHalfCache];
            break;
        case KYBarrageMemoryWarningModeAll:
            [self cleanAllCache];
            break;
        default:
            break;
    }
}

- (void)cleanHalfCache {
    NSRange range = NSMakeRange(0, _cachePool.count / 2);
    [_cachePool removeObjectsInRange:range];
}

- (void)cleanAllCache {
    [_cachePool removeAllObjects];
}



@end
