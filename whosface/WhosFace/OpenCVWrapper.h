//
//  OpenCVWrapper.h
//  WhosFace
//
//  Created by Kei on 2017/06/22.
//  Copyright © 2017年 takahashi kei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject
- (id) init;
- (void) createCameraWithParentView:(UIImageView*)parentView;
- (void) start;
- (UIImage *)recognizeFace:(UIImage *)image;
- (UIImage *)rectangleFace:(UIImage *)image;
- (UIImage *)showFace:(UIImage *)image;
@end
