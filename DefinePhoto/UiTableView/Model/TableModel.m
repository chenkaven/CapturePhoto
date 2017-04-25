//
//  TableModel.m
//  DefinePhoto
//
//  Created by kaven on 2017/4/25.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import "TableModel.h"

@implementation TableModel

/*set方法，不要写self换成_,要不然循循环引用***/
-(instancetype)init{

    if (self == [super init]) {
        
        _isSelect    = NO;//默认为不选中       
    }
    return self;
}
//-(NSMutableArray *)dataSourse{
//
//    if (_dataSourse == nil) {
//        
//        _dataSourse = [NSMutableArray array];
//        
//        }
//    return _dataSourse;
//}
@end
