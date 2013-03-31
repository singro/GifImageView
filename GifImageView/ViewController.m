//
//  ViewController.m
//  GifImageView
//
//  Created by Singro on 3/31/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"gintama" ofType:@"gif"];
    GifImageView *imageView = [[GifImageView alloc] initWithPath:path];    
    [self.view addSubview:imageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
