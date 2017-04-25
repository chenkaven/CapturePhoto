//
//  ViewTableCell.m
//  DefinePhoto
//
//  Created by kaven on 2017/4/25.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import "ViewTableCell.h"

@interface ViewTableCell()

@property(nonatomic,strong)TableModel *tabModel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//副标题
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLab;



@end

@implementation ViewTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark -- 初始化Cell


+(instancetype )setCellModel:(TableModel *)model ViewIndex:(NSIndexPath *)indeXPath Celledit:(BOOL)isCellEdit CellIsSelect:(isSelectBlock)cellSelectBlock{
    
    ViewTableCell  *cell = [[[NSBundle mainBundle]loadNibNamed:@"ViewTableCell" owner:self options:nil]lastObject];
    cell.isCellEdit = isCellEdit;
    cell.indeXPath = indeXPath;
    cell.cellSelectBlock = cellSelectBlock;
    [cell setTabModel:model];
    return cell;
}

-(void)setTabModel:(TableModel *)tabModel{

   
    if ([tabModel.imageUrl isKindOfClass:[NSString class]]) {
        
         NSString *imageUrl = [NSString stringWithFormat:@"%@",tabModel.imageUrl];
         [_photoView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:ImageOfName(@"Default1.jpg")];
    }else if([tabModel.imageUrl isKindOfClass:[UIImage class]]){
    
        _photoView.image = tabModel.imageUrl;
    }
   
    _titleLab.text = [NSString stringWithFormat:@"%@",tabModel.title];
    _detailTitleLab.text = [NSString stringWithFormat:@"%@",tabModel.detailTitle];
    //设置0为不选中图片 1:为选中
    if (tabModel.isSelect) {
        
        [_chooseBtn setBackgroundImage:ImageOfName(@"btn_choose_selected") forState:UIControlStateNormal];
    } else {
        
        [_chooseBtn setBackgroundImage:ImageOfName(@"btn_choose_normal") forState:UIControlStateNormal];
    }
    _chooseBtn.userInteractionEnabled = NO;
    _detailTitleLab.numberOfLines= 0;
//    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageBtnAction:)];
//    [_photoView addGestureRecognizer:tap];
}
#pragma mark -- 点击图片
//-(void)touchImageBtnAction:(UIGestureRecognizer *)tap{
// 
//    if (_isChangeBlock) {
//        
//        _isChangeBlock(_tabModel,_indeXPath);
//    }
//}

#pragma mark - set frame (重写frame方法)
-(void)setFrame:(CGRect)frame{
    //按钮的位置-- 离x为宽24 + 10
    frame.size.width = MainScreenWidth + 34;
    
    if (_isCellEdit) {
        
        frame.origin.x = 0;
    } else {
        
        frame.origin.x = - 34;
    }
    [super setFrame:frame];
}
@end
