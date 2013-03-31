//
//  GifImageView.m
//  GifImageView
//
//  Created by Singro on 7/5/12.
//  Copyright (c) 2012 Singro. All rights reserved.
//

#import "GifImageView.h"
#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#else
#define toCF (CFTypeRef)
#endif

@interface GifImageView() {
    UIImageView *imageView;
    NSTimer *timer;
    NSInteger dt;
    NSArray *images;
    NSArray *durations;
}

- (NSArray *)ImageArrayWithData:(NSData *)data;
- (NSArray *)DurationArrayWithData:(NSData *)data;
- (void)showAnimation;

@end

@implementation GifImageView

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        
        NSString *pathExtension = [path pathExtension];   // get image extension
        
        if ([pathExtension isEqualToString:@"gif"]) {     // play animation for gif
            images = [self ImageArrayWithData:[NSData dataWithContentsOfFile:path]];
            durations = [self DurationArrayWithData:[NSData dataWithContentsOfFile:path]];
            dt = 0;
            timer = [[NSTimer alloc]init];
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showAnimation) userInfo:nil repeats:YES];
            imageView = [[UIImageView alloc] initWithImage:[images objectAtIndex:0]];
            [self addSubview:imageView];
        } else {                                          // Show image for other format
            UIImage *otherImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
            imageView = [[UIImageView alloc] initWithImage:otherImage];
            [self addSubview:imageView];
        }
        
        
    }
    return self;
}

// Convert & store images in gif
- (NSArray *)ImageArrayWithData:(NSData *)data {
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF data, NULL);
    if (!source) return nil;
    size_t count = CGImageSourceGetCount(source);
    //    NSLog(@"count:%zd", count);
    NSMutableArray *images_ = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage)
            return nil;
        [images_ addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    return [images_ mutableCopy];
}

// Get a list of animation duration
- (NSArray *)DurationArrayWithData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    NSMutableArray *departDurations = [NSMutableArray arrayWithArray:nil];
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES){
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes
                                                                        length:3]
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if(frameDescriptorRange.location!=NSNotFound){
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location+4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer];
            double delay = (buffer[0] | buffer[1] << 8);
            [departDurations addObject:[NSNumber numberWithDouble:delay]];
            //NSLog(@"delay: %f", delay);
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }else{
            break;
        }
    }
    NSMutableArray *durations_ = [NSMutableArray arrayWithArray:nil];
    double total = 0;
    for (int i = departDurations.count - 1; i >= 0; i --) {
        total += [[departDurations objectAtIndex:i] doubleValue];
        [durations_ addObject:[NSNumber numberWithDouble:total]];
    }
    return [durations_ mutableCopy];
}

// Show gif animation
- (void)showAnimation {
    dt ++;
    //NSLog(@"images:%@\ndurations:%@\ndt:%d", myimages, mydurations, dt);
    for (int i = 1; i < images.count; i++) {
        if (dt == [[durations objectAtIndex:i-1] intValue]) {
            imageView.image = [images objectAtIndex:i];
        }
    }
    // repeat
    if (dt > [[durations objectAtIndex:([durations count] - 1)] intValue]) {
        dt = 0;
        imageView.image = [images objectAtIndex:0];
    }
}


@end
