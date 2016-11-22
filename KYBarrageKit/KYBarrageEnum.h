//
//  KYBarrageEnum.h
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

#ifndef KYBarrageEnum_h
#define KYBarrageEnum_h


typedef NS_ENUM(NSInteger, KYBarrageStatusType) {
    KYBarrageStatusTypeNormal = 0,
    KYBarrageStatusTypePause,
    KYBarrageStatusTypeClose,
};

// 弹幕的滚动速度,单位为秒
// scroll speed of barrage,in seconds
typedef NS_ENUM(NSInteger, KYBarrageDisplaySpeedType) {
    KYBarrageDisplaySpeedTypeDefault = 10,
    KYBarrageDisplaySpeedTypeFast = 20,
    KYBarrageDisplaySpeedTypeFaster = 40,
    KYBarrageDisplaySpeedTypeMostFast = 60,
};

//  弹幕滚动的方向
typedef NS_ENUM(NSInteger, KYBarrageScrollDirection) {
    KYBarrageScrollDirectRightToLeft = 0,     /*  <<<<<   */
    KYBarrageScrollDirectLeftToRight = 1,     /*  >>>>>   */
    KYBarrageScrollDirectBottomToTop = 2,     /*  ↑↑↑↑   */
    KYBarrageScrollDirectTopToBottom = 3,     /*  ↓↓↓↓   */
};


// location of barrage, `default` is global page
typedef NS_ENUM(NSInteger, KYBarrageDisplayLocationType) {
    KYBarrageDisplayLocationTypeDefault = 0,
    KYBarrageDisplayLocationTypeTop = 1,
    KYBarrageDisplayLocationTypeCenter = 2,
    KYBarrageDisplayLocationTypeBottom = 3,
    KYBarrageDisplayLocationTypeHidden,
};

//  type of barrage
typedef NS_ENUM(NSInteger, KYBarrageDisplayType) {
    KYBarrageDisplayTypeDefault = 0,  /* only text  */
    KYBarrageDisplayTypeVote,         /* text and vote */
    KYBarrageDisplayTypeImage,        /* text and image */
    KYBarrageDisplayTypeOther,        /* other        */
};

// 收到内存警告的清除策略
typedef NS_ENUM(NSInteger, KYBarrageMemoryWarningMode) {
    KYBarrageMemoryWarningModeHalf = 0, //清除一半
    KYBarrageMemoryWarningModeAll,       //清空缓冲池
};


#endif /* KYBarrageEnum_h */
