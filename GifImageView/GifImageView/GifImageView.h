//
//  GifImageView.h
//  GifImageView
//
//  Created by Singro on 7/5/12.
//  Copyright (c) 2012 Singro. All rights reserved.
//
//  Note:
//        ImageIO.framework is needed.
//        This lib is only available on iOS 5


#import <UIKit/UIKit.h>

@interface GifImageView : UIView

- (id)initWithPath:(NSString *)path;

@end
