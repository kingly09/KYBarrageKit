//
//  KYBarrageManager.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "KYBarrageModel.h"
#import "KYBarrageScene.h"

NS_ASSUME_NONNULL_BEGIN


@protocol KYBarrageManagerDelegate <NSObject>

// Data Sources of barrage, type can be ` NSArray <KYBarrageModel *> ` or a KYBarrageModel
- (id)barrageManagerDataSource;

@end

@interface KYBarrageManager : NSObject

//  barrage's singleton
+ (instancetype)shareManager;

+ (instancetype)manager;

// Barrage pool, can be taken out from the next     barrage's cache
- (NSMutableArray <KYBarrageScene *> *)barrageCache;

// Is displayed on the screen of the barrage
- (NSMutableArray <KYBarrageScene *> *)barrageScenes;

// barrage's ViewController
@property (weak, nonatomic) id <KYBarrageManagerDelegate> delegate;

// the view of show barrage 
@property (weak, nonatomic) UIView *bindingView;

@property (assign, nonatomic) NSInteger scrollSpeed;

// get barrages on time,
@property (assign, nonatomic) NSTimeInterval refreshInterval;

@property (assign, nonatomic) NSInteger displayLocation;

@property (assign, nonatomic) NSInteger scrollDirection;

// Text limited length
@property (assign, nonatomic) NSInteger textLengthLimit;

// Clear policy for receiving memory warning
@property (assign, nonatomic) NSInteger memoryMode;

//Take the initiative to obtain barrage
- (void)startScroll;

//Passive receiving a barrage of data
/* data's type is ` KYBarrageModel ` or ` NSArray <KYBarrageModel *> `*/
- (void)showBarrageWithDataSource:(id)data;

// pause or resume barrage
- (void)pauseScroll;

// close barrage
- (void)closeBarrage;

// Receive memory warning, can remove a barrage of buffer pool, the buffer pool can also remove half
- (void)didReceiveMemoryWarning;

// Prevent memory leaks
- (void)toDealloc;

@end

NS_ASSUME_NONNULL_END
