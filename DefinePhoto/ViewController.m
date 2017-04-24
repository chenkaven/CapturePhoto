//
//  ViewController.m
//  DefinePhoto
//
//  Created by kaven on 2017/4/21.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import "ViewController.h"
#import "CapturePhotoVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 下一页
- (IBAction)netBtnAction:(id)sender {
    
    CapturePhotoVC  *PhotoVC = [[CapturePhotoVC alloc]init];
    [self.navigationController pushViewController:PhotoVC animated:YES];
}

@end
