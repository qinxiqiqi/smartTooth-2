//
//  SPPickerPetClass.m
//  JiangDiet
//
//  Created by 蓝现 on 2017/5/19.
//  Copyright © 2017年 yanghengzhan. All rights reserved.
//

#import "SPPickerPetClass.h"
@interface SPPickerPetClass()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayRoot;
/** 2.当前数组 */
@property (nonatomic, strong, nullable)NSMutableArray *specialChannelArr;


//选中种类
@property (nonatomic, strong, nullable)NSString *channel;
@property (nonatomic, strong, nullable)NSString *channelId;

//
@property (nonatomic, strong, nullable)NSString *firstChannel;


@end
@implementation SPPickerPetClass
#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    __weak SPPickerPetClass *weakSelf = self;

    // 1.获取数据
    [[UFHttpRequest defaultHttpRequest] postRequest:@"http://app-test.116.com.cn/app/chat/specialChannel" alertView:nil parameters:nil success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _arrayRoot = responseObject[@"data"];
            [self.pickerView reloadComponent:0];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    NSDictionary *params = @{@"parentId":@"9e1363e96f524de5b36f4ade544cc184"};
    [[UFHttpRequest defaultHttpRequest] postRequest:@"http://app-test.116.com.cn/app/pet/specialChannel" alertView:nil parameters:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            _specialChannelArr = responseObject[@"data"];
            [self.pickerView reloadComponent:1];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayRoot.count;
    }
    return self.specialChannelArr.count;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        __weak SPPickerPetClass *weakSelf = self;

        NSDictionary *dic = self.arrayRoot[row];
        NSString *firstId = dic[@"id"];
        NSDictionary *params = @{@"parentId":firstId};
        [[UFHttpRequest defaultHttpRequest] postRequest:@"http://app-test.116.com.cn/app/pet/specialChannel" alertView:nil parameters:params success:^(id  _Nullable responseObject) {
            //ename
            if ([responseObject[@"code"] integerValue] == 0) {
                _specialChannelArr = responseObject[@"data"];
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [self reloadData];
                
                
            }
        } failure:^(NSError * _Nullable error) {
            
        }];
        
    }else {
        [self reloadData];
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    
    NSString *text;
    if (component == 0) {
        NSDictionary *dic = self.arrayRoot[row];
        
        text = dic[@"ename"];
    }else if (component == 1){
        NSDictionary *dic = self.specialChannelArr[row];

        text = dic[@"ename"];
    }
    
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    
    
    if ([self.delegate respondsToSelector:@selector(pickerDate:channel:channelid:)]) {
        [self.delegate pickerDate:self channel:_channel channelid:_channelId];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    
    NSDictionary *dic0 = self.arrayRoot[index0];
//    dic[@"ename"]
    if (self.specialChannelArr.count>0) {
        NSDictionary *dic1 = self.specialChannelArr[index1];
        
        _channel = dic1[@"ename"];
        _channelId = dic1[@"id"];

    }else {
        _channel = dic0[@"ename"];
        _channelId = dic0[@"id"];

    }
    
    
}

#pragma mark - --- setters 属性 ---

#pragma mark - --- getters 属性 ---

- (NSMutableArray *)arrayRoot
{
    if (!_arrayRoot) {
        _arrayRoot = @[].mutableCopy;
    }
    return _arrayRoot;
}

- (NSMutableArray *)specialChannelArr
{
    if (!_specialChannelArr) {
        _specialChannelArr = @[].mutableCopy;
    }
    return _specialChannelArr;
}

@end
