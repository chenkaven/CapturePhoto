//
//  ViewTableCell.h
//  DefinePhoto
//
//  Created by kaven on 2017/4/25.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableModel.h"


typedef void(^isSelectBlock)(TableModel *,NSIndexPath *);
typedef void(^IsChangeBlock)(TableModel *,NSIndexPath *);
@interface ViewTableCell : UITableViewCell

@property(nonatomic,assign)BOOL isCellEdit;
//单元行
@property(nonatomic,assign)NSIndexPath  *indeXPath;
// cell是否是选中状态
@property (copy, nonatomic)isSelectBlock cellSelectBlock;

// cell图片切换状态
@property (copy, nonatomic)IsChangeBlock isChangeBlock;

+(instancetype )setCellModel:(TableModel *)model ViewIndex:(NSIndexPath *)indeXPath Celledit:(BOOL)isCellEdit CellIsSelect:(isSelectBlock)cellSelectBlock;
@end
