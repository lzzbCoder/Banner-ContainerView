//
//  ViewController.m
//  T-图片轮播封装版
//
//  Created by L on 15/9/30.
//  Copyright © 2015年 . All rights reserved.
//  注意一点：图片数组不能重复，否则会无限循环重复的图片

#import "ViewController.h"
#import "PPRollingBannerVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"roll"]
        && [segue.destinationViewController isKindOfClass:[PPRollingBannerVC class]]) {
    
        PPRollingBannerVC *vc = (PPRollingBannerVC *)segue.destinationViewController;
        vc.rollingInterval = 1;
        
        vc.rollingImages = @[@"http://hiphotos.baidu.com/lok0414/pic/item/127e9edb318c0e7e10df9b00.jpg?v=tbs"
                             , @"https://c2.staticflickr.com/4/3345/5832660048_55f8b0935b.jpg"
                             , @"http://g.hiphotos.baidu.com/image/pic/item/a044ad345982b2b7b66e0f8f37adcbef77099b83.jpg"
                             , [UIImage imageNamed:@"001"]
                             , [UIImage imageNamed:@"002"]
                             , [UIImage imageNamed:@"003"]
                             , [UIImage imageNamed:@"004"]

                             ];
        
        [vc addBannerTapHandler:^(NSInteger whichIndex) {
            NSLog(@"您现在点击的图片的index = %@", @(whichIndex));
        }];
        
        [vc startRolling];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
