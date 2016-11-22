//
//  KYBarrageModel.m
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

#import "KYBarrageModel.h"

@implementation KYBarrageModel

#pragma mark - initialize

- (instancetype)init {
    if (self = [super init]) {
        self.numberID = 0;
        self.message = [[NSMutableAttributedString alloc] initWithString:@""];
        self.author = nil;
        self.object = nil;
       
    }
    return self;
}

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message Author:(nullable id)author Object:(nullable id)object {
    KYBarrageModel *model = [[KYBarrageModel alloc] init];
    model.numberID = numID;
    model.message = message;
    model.author = author;
    model.object = object;
    
    return model;
}

- (instancetype)initWithNumberID:(NSInteger)numID BarrageContent:(NSMutableAttributedString *)message {
    return [self initWithNumberID:numID BarrageContent:message Author:nil Object:nil];
}

- (instancetype)initWithBarrageContent:(NSMutableAttributedString *)message {
    return [self initWithNumberID:0 BarrageContent:message];
}

@end
