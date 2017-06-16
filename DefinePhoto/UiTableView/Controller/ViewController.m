//
//  ViewController.m
//  DefinePhoto
//
//  Created by kaven on 2017/4/21.
//  Copyright © 2017年 kaven. All rights reserved.
//

#import "ViewController.h"
#import "CapturePhotoVC.h"
#import "UIView+Extension.h"
#import "ViewTableCell.h"
#import "TableModel.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "GetSystemInfo.h"
#import "KeyChain.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalSelectBtn;

@property(nonatomic,strong)TableModel  *tabModel;
@property(nonatomic,strong)NSMutableArray *select_Arr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic, assign) BOOL left_firstClick;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    kWeakSelf(self);
    [weakself tabModel];
    [weakself dataArr];
    //设置行高
    [weakself.tableview setRowHeight:120.0f];
    /*无下划线*/
    weakself.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [weakself pandunDataArr];
    NSString  *textfiled1 = @"www.baidu.com";
    NSString  *textfiled2 = @"www.qq.com";
    //归档
    [KeyChain archiverModel:textfiled1 modelKey:@"baidu"];
    [KeyChain archiverModel:textfiled2 modelKey:@"qq"];
   
    
    
}

;-(void)pandunDataArr{
    
    kWeakSelf(self);
    if ([weakself.dataArr count]<= 0) {
        
        [weakself.editBtn setTitle:@"" forState:UIControlStateNormal];
        //编辑按钮不开启用户交互
        weakself.editBtn.userInteractionEnabled = NO;
        [weakself.finishBtn setTitle:@"" forState:UIControlStateNormal];
        //删除按钮不开启用户交互
        weakself.finishBtn.userInteractionEnabled = NO;
        [weakself.totalSelectBtn setTitle:@"" forState:UIControlStateNormal];
        //全选按钮不开启用户交互
        weakself.totalSelectBtn.userInteractionEnabled = NO;
    } else {
        
        if (!weakself.left_firstClick) {
            
            [weakself.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            //编辑按钮不开启用户交互
            weakself.editBtn.userInteractionEnabled = YES;
        } else {
            
            [weakself.editBtn setTitle:@"取消" forState:UIControlStateNormal];
            //编辑按钮不开启用户交互
            weakself.editBtn.userInteractionEnabled = YES;
        }
        
        if ([weakself.select_Arr count] <= 0) {
            
            [weakself.finishBtn setTitle:@"" forState:UIControlStateNormal];
            //删除按钮不开启用户交互
            weakself.finishBtn.userInteractionEnabled = NO;
        if (weakself.left_firstClick) {
            
                [weakself.totalSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
                //全选按钮不开启用户交互
                weakself.totalSelectBtn.userInteractionEnabled = YES;
         } else {
                [weakself.totalSelectBtn setTitle:@"" forState:UIControlStateNormal];
                //全选按钮不开启用户交互
                weakself.totalSelectBtn.userInteractionEnabled = NO;
            }
        }else if ([weakself.select_Arr count] == [weakself.dataArr count]){
            
            NSString *deleteTitle = [NSString stringWithFormat:@"删除%ld",[weakself.select_Arr count]];
            NSString *totalTitle = [NSString stringWithFormat:@"取消全选%ld",[weakself.dataArr count]];
            [weakself.finishBtn setTitle:deleteTitle forState:UIControlStateNormal];
            //删除按钮不开启用户交互
            weakself.finishBtn.userInteractionEnabled = YES;
            [weakself.totalSelectBtn setTitle:totalTitle forState:UIControlStateNormal];
            //全选按钮不开启用户交互
            weakself.totalSelectBtn.userInteractionEnabled = YES;
        } else {
            
            NSString *deleteTitle = [NSString stringWithFormat:@"删除%ld",[weakself.select_Arr count]];
            [weakself.finishBtn setTitle:deleteTitle forState:UIControlStateNormal];
            //删除按钮不开启用户交互
            weakself.finishBtn.userInteractionEnabled = YES;
            [weakself.totalSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
            //全选按钮不开启用户交互
            weakself.totalSelectBtn.userInteractionEnabled = YES;
            
        }
    }
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 下一页
- (IBAction)netBtnAction:(id)sender {
    
    CapturePhotoVC  *PhotoVC = [[CapturePhotoVC alloc]init];
    [self.navigationController pushViewController:PhotoVC animated:YES];
    [self dataArr];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    kWeakSelf(self);
    //静态私有的全局变量
    TableModel  *model = self.dataArr[indexPath.row];
    static NSString *deqeueIdentifier  = @"CellOne";
    ViewTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:deqeueIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        
        cell = [ViewTableCell setCellModel:model ViewIndex:indexPath Celledit:self.left_firstClick CellIsSelect:^(TableModel *tabModel, NSIndexPath *indeXPath) {
                    //更新商品数组
                [self.dataArr replaceObjectAtIndex:indeXPath.row withObject:tabModel];
                if (tabModel.isSelect) {
                    
                    [weakself.select_Arr addObject:tabModel];
                } else {
                    
                    [self.select_Arr removeObject:tabModel];
                }
                [self.tableview reloadData];
            }];
    }
    return cell;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    /*弱引用，防止重用*/
//    kWeakSelf(self);
//    //静态私有的全局变量
//    static NSString *deqeueIdentifier  = @"CellOne";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deqeueIdentifier];
//    if (!cell) {
//
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    cell.textLabel.top = 10 ;
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",weakself.dataArr[indexPath.row]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",weakself.detailSourse[indexPath.row]];
//    /* 不设置行数 */
//    cell.detailTextLabel.numberOfLines = 0;
//    cell.detailTextLabel.bottom = 120 ;
//    NSString *imageUrl = [NSString stringWithFormat:@"%@",weakself.imageArr[indexPath.row]];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:ImageOfName(@"Default1.jpg")];
//    return cell;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TableModel *goodsModel = self.dataArr[indexPath.row];
    if (self.left_firstClick) {
        
        //改变视频选中状态
        goodsModel.isSelect = !goodsModel.isSelect;
        if (goodsModel.isSelect) {
            
            [weakself.select_Arr addObject:goodsModel];
        } else {
            
            [self.select_Arr removeObject:goodsModel];
        }
        [weakself pandunDataArr];
        
    } else {
        
        //进入详情
        NSLog(@"进入详情");
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
        //    NSLog(@"打印图片数组%@",photos);
            goodsModel.imageUrl = [photos firstObject];
            [self.tableview reloadData];
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    }
    
}
#pragma mark -- 懒加载

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [NSMutableArray array];
        TableModel *model1 = [TableModel new];
        model1.title = @"龚(gōng)自珍";
        model1.detailTitle = @"九州生气恃风雷，万马齐喑究可哀。我劝天公重抖擞，不拘一格降人才。";
        model1.imageUrl = @"http://file-cdn.datafans.net/temp/11.jpg_160x160.jpeg";
        TableModel *model2 = [TableModel new];
        model2.title = @"拿破仑";
        model2.detailTitle = @"真正的才智是刚毅的志向。";
        model2.imageUrl = @"http://file-cdn.datafans.net/temp/12.jpg_160x160.jpeg";
        
        TableModel *model3 = [TableModel new];
        model3.title = @"袁中道";
        model3.detailTitle = @"人生贵知心，定交无暮早";
        model3.imageUrl = @"http://file-cdn.datafans.net/temp/13.jpg_160x160.jpeg";
        [_dataArr addObject:model1];
        [_dataArr addObject:model2];
        [_dataArr addObject:model3];
        
    }
    return _dataArr;
}

-(NSMutableArray *)select_Arr{
    
    if (_select_Arr == nil) {
        
        [_select_Arr removeAllObjects];
        
        _select_Arr = [NSMutableArray array];
    }
    return _select_Arr;
}
#pragma mark -- 开启编辑状态
- (IBAction)editBtnAction:(UIButton *)sender {
    //解档
    id obj1 =    [KeyChain unArchiverModelFileKey:@"baidu"];
    id obj2 =    [KeyChain unArchiverModelFileKey:@"qq"];
    NSLog(@"打印object1—%@,打印object2—%@",obj1,obj2);
    kWeakSelf(self);
    //每次选择完都要初始化
    [weakself select_Arr];
    NSString *btnTitle = [NSString stringWithFormat:@"%@", sender.titleLabel.text] ;
    if ([btnTitle isEqualToString:@"编辑"]){
        
       weakself.left_firstClick = YES;
       [sender setTitle:@"取消" forState:UIControlStateNormal];
       [weakself pandunDataArr];
        
    } else {
        
        weakself.left_firstClick = NO;
        [weakself setUnSelectDataArr];
    }
    [self.tableview reloadData];
}
#pragma mark -- 完成
- (IBAction)finishBtnAction:(UIButton *)sender {
    
    kWeakSelf(self);
    [weakself.dataArr removeObjectsInArray:weakself.select_Arr];//根据镜像去删除数据
    //初始化
    [weakself.select_Arr removeAllObjects];
    
    [weakself pandunDataArr];
    
}

- (IBAction)totalSelectBtnAction:(id)sender {
    
    kWeakSelf(self);
    
    NSString *totalBtnTitle = [NSString stringWithFormat:@"%@", _totalSelectBtn.titleLabel.text];
    [weakself.select_Arr removeAllObjects];
    
    if ([totalBtnTitle isEqualToString:@"全选"]) {
        
        [weakself setSelectDataArr];
        
    } else {
        
        [weakself setUnSelectDataArr];
    }
}

#pragma mark -- 判断是否全部勾选


-(void)setSelectDataArr{
    /* 已勾选 */
    kWeakSelf(self);
    for (TableModel *model in weakself.dataArr) {
        
        model.isSelect = YES;
        [weakself.select_Arr  addObject:model];
    }
    [weakself pandunDataArr];
}

-(void)setUnSelectDataArr{
    
    /* 未勾选 */
    kWeakSelf(self);
    
    for (TableModel *model in weakself.dataArr) {
        
        model.isSelect = NO;
    }
    //清空选择数组
    [weakself.select_Arr removeAllObjects];
    [weakself pandunDataArr];
}



@end
