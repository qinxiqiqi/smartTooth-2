//
//  STPickerSingle.m
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/16.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import "STPickerSingle.h"
#import "SPChannelModel.h"

@interface STPickerSingle()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;
@property (nonatomic, strong, nullable)NSString *selectedChannel;

@end

@implementation STPickerSingle

#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [super setupUI];
    
    __weak STPickerSingle *weakSelf = self;

    _titleUnit = @"";
    _arrayData = @[].mutableCopy;
    _heightPickerComponent = 44;
    _widthPickerComponent = 32;

    NSDictionary *params = @{@"parentId":@"d8ed2b8fa9774bb69949f21d5b04fcaf"};
    
    [[UFHttpRequest defaultHttpRequest]getRequest: @"http://app-test.116.com.cn/app/chat/specialChannel" alertView:nil parameters:params success:^(id  _Nullable responseObject) {
        
        if (ISNULL(responseObject)) {
            return ;
        }

        NSDictionary* resultDic = responseObject;
        
        if ([resultDic[@"code"] integerValue] == 0) {
            
            NSArray* dataDic =  responseObject[@"data"];
            
            if (ISNULL(dataDic)|| dataDic.count == 0) {
                return;
            }
            
            
            //            NSDictionary *dic = responseObject[@"data"];
            for (NSDictionary *littleDic in responseObject[@"data"]) {
                
                SPChannelModel *model = [SPChannelModel mj_objectWithKeyValues:littleDic];
                [_arrayData addObject:model];
                
            }
            [self.pickerView reloadAllComponents];
            SPChannelModel *model = self.arrayData[0];
            
            self.selectedTitle = model.name;
            self.selectedChannel = model.channelId;
            
            
            
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];

    [self.pickerView setDelegate: self ];
    [self.pickerView setDataSource: self];
}


#pragma mark - --- delegate 视图委托 ---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayData.count;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    
    return ScreenWidth;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SPChannelModel *model = self.arrayData[row];
    
    self.selectedTitle = model.name;
    self.selectedChannel = model.channelId;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    SPChannelModel *model = self.arrayData[row];

    UILabel *label = [[UILabel alloc]init];
    [label setText:model.name];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    
    
    if ([self.delegate respondsToSelector:@selector(pickerSingle:selectedTitle:selectId:)]) {
        [self.delegate pickerSingle:self selectedTitle:self.selectedTitle selectId:self.selectedChannel];
    }
    
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

- (void)setArrayData:(NSMutableArray<NSString *> *)arrayData
{
    _arrayData = arrayData;
    _selectedTitle = arrayData.firstObject;
    [self.pickerView reloadAllComponents];
}

- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}

#pragma mark - --- getters 属性 ---
@end

