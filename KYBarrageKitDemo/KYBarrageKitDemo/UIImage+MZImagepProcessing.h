//
//  UIImage+MZImagepProcessing.h
//  MZGogalApp
//
//  Created by CocoaRoom on 16/4/7.
//  Copyright © 2016年 美知互动科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MZImagepProcessing)

+ (NSData *)compressiImageWithImage:(UIImage *)source_image;

//获取视频截图
+ (UIImage *)imageWithVideo:(NSURL *)vidoURL;

//修改image的尺寸
+(UIImage*) scaleOriginImage:(UIImage *)image scaleToSize:(CGSize)size;

/**
 等比例压缩图片

 @param sourceImage 原图片
 @param size 压缩的尺寸
 @return 返回压缩后的图片
 */
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 自定义图片的宽度 等比例压缩

 @param sourceImage sourceImage 原图片
 @param defineWidth 自定义图片的宽度
 @return 返回压缩后的图片
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
