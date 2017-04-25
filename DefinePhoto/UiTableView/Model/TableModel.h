//
//  TableModel.h
//  DefinePhoto
//
//  Created by kaven on 2017/4/25.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableModel : NSObject

//标题
@property(nonatomic,copy)NSString *title;
//副标题
@property(nonatomic,copy)NSString *detailTitle;
//图片地址
@property(nonatomic,copy)id imageUrl;

@property (assign, nonatomic)BOOL isSelect;//判断是否选中订单

//@property(nonatomic,copy)NSMutableArray  *dataSourse;


@end
