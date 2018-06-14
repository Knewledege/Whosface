//
//  OpenCVWrapper.m
//  WhosFace
//
//  Created by Kei on 2017/06/22.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIkit.h>
#import "OpenCVWrapper.h"

using namespace cv;
using namespace std;

@interface OpenCVWrapper() <CvVideoCameraDelegate> {
    
    CvVideoCamera *cvCamera;
    cv::CascadeClassifier cascade;
}

@end

@implementation OpenCVWrapper

- (id)init {
    self = [super init];
    
    // 分類器の読み込み
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
    std::string cascadeName = (char *)[path UTF8String];
    
    if(!cascade.load(cascadeName)) {
        return nil;
    }
    
    return self;
}

-(void)processImage:(cv::Mat&)image {
    
    
}

- (UIImage *)recognizeFace:(UIImage *)image {
    /*
     // UIImage -> cv::Mat変換
     CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
     CGFloat cols = image.size.width;
     CGFloat rows = image.size.height;
     
     cv::Mat mat(rows, cols, CV_8UC4);
     
     CGContextRef contextRef = CGBitmapContextCreate(mat.data,
     cols,
     rows,
     8,
     mat.step[0],
     colorSpace,
     kCGImageAlphaNoneSkipLast |
     kCGBitmapByteOrderDefault);
     
     CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
     CGContextRelease(contextRef);
     
     // 顔検出
     std::vector<cv::Rect> faces;
     cascade.detectMultiScale(mat, faces,
     1.1, 5,
     CV_HAAR_SCALE_IMAGE,
     cv::Size(30, 30));
     
     // 顔の位置に丸を描く
     std::vector<cv::Rect>::const_iterator r = faces.begin();
     for(; r != faces.end(); ++r) {
     cv::Point center;
     int radius;
     center.x = cv::saturate_cast<int>((r->x + r->width*0.01));
     center.y = cv::saturate_cast<int>((r->y + r->height*0.01));
     radius = cv::saturate_cast<int>((r->width + r->height));
     cv::circle(mat, center, radius, cv::Scalar(10,10,255), 3, 2, 0 );
     }
     
     
     // cv::Mat -> UIImage変換
     UIImage *resultImage = MatToUIImage(mat);
     
     return resultImage;
     
     */
    Mat image_gray;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    
    cv::Mat img(rows, cols, CV_8UC4);
    
    
    CGContextRef contextRef = CGBitmapContextCreate(img.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    img.step[0],
                                                    colorSpace,
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    
    
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(img, faces,
                             1.1, 9,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30, 30));
    
    if(faces.empty()){
    }else{
        // 顔の囲む
        std::vector<cv::Rect>::const_iterator r = faces.begin();
        for(; r != faces.end(); ++r) {
            cv::Point left;
            cv::Point right;
            left.x = cv::saturate_cast<int>(r->x);
            left.y = cv::saturate_cast<int>(r->y);
            right.x = cv::saturate_cast<int>((r->x+r->width));
            right.y = cv::saturate_cast<int>((r->y+r->height));
            //Point1 が左上,Point2が右下
            cv::rectangle(img, cv::Point(left.x,left.y), cv::Point(right.x,right.y), cv::Scalar(0,0,0),2,2,.9);
        
        }
    }
    
    UIImage *resultImage = MatToUIImage(img);
    
    return resultImage;
    
}

- (UIImage *)rectangleFace:(UIImage *)image {
    
    UIImage *resultImage;
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    
    cv::Mat img(rows, cols, CV_8UC4);
    
    
    CGContextRef contextRef = CGBitmapContextCreate(img.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    img.step[0],
                                                    colorSpace,
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(img, faces,
                             1.1, 9,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30, 30));
     cv::Mat Faceimg;
    if(faces.empty()){
        return nil;
    }else{
        // 顔の囲む
        std::vector<cv::Rect>::const_iterator r = faces.begin();
        for(; r != faces.end(); ++r) {
            cv::Mat cut_img(img,cv::Rect((r->x-5),(r->y-2),(r->width+2),(r->height+15)));
            //cv::Mat Faceimg;
            cv::cvtColor(cut_img,Faceimg, CV_BGR2RGB);
            resultImage = MatToUIImage(Faceimg);
        }
        return resultImage;
    }

}
    
    
- (UIImage *)showFace:(UIImage *)image {
    
    
    UIImage *resultImage;
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    
    cv::Mat img(rows, cols, CV_8UC4);
    
    
    CGContextRef contextRef = CGBitmapContextCreate(img.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    img.step[0],
                                                    colorSpace,
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(img, faces,
                             1.1, 9,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30, 30));
    cv::Mat Faceimg;
    if(faces.empty()){
        return nil;
    }else{
        // 顔の囲む
        std::vector<cv::Rect>::const_iterator r = faces.begin();
        for(; r != faces.end(); ++r) {
            cv::Mat cut_img(img,cv::Rect((r->x-2),(r->y-5),(r->width+2),(r->height+15)));
            //cv::Mat Faceimg;
            cv::cvtColor(cut_img,Faceimg, CV_BGRA2BGR);
            resultImage = MatToUIImage(Faceimg);
        }
        return resultImage;
    }

    
}
    
- (void) createCameraWithParentView:(UIImageView*)parentView{
    
    cvCamera = [[CvVideoCamera alloc] initWithParentView:parentView];
    
    cvCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    cvCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    cvCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    cvCamera.defaultFPS = 30;
    cvCamera.grayscaleMode = NO;
    
    cvCamera.delegate = self;
    
}

- (void)start {
    
    [cvCamera start];
    
}
@end
