//
//  QXTitleImageBtn.h
//  NaHao
//
//  Created by NIT on 2017/10/19.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TitleImageBtnStyle) {
    TitleImageBtnStyleLeftImage,//图片在左边
    TitleImageBtnStyleRightImage,//图片在右边
    TitleImageBtnStyleTopImage,//图片在上边
    TitleImageBtnStyleBottomImage,//图片在下边
    TitleImageBtnStyleSingleImage,//只有图片
    TitleImageBtnStyleSingleTitle//只有文字
};
@interface QXTitleImageBtn : UIButton
@property (strong, nonatomic)UILabel *customTitleLabel;
@property (strong, nonatomic)UIImageView *customImageView;
/**
 *  param
 *  title:文本信息         TitleImageBtnStyleSingleImage设为@""
 *  titleFont:文本字体大小  TitleImageBtnStyleSingleImage设为nil
 *  titleColor:文本颜色    TitleImageBtnStyleSingleImage设为nil
 *  imageName:图片名       TitleImageBtnStyleSingleTitle设为@""
 *  style：视图的风格 图片在那个方向
 *  leftMargin：左边的间隔
 *  centerMargin：中间的间隔
 *  rightMargin：右边的间隔
 *  frame：控件相对于父控件的位置
 *  isAutoWidth：是否根据文本自适应宽度
 */
- (instancetype)initWithTitle:(NSString *)title titleFont:(UIFont*)titleFont titleColor:(UIColor*)titleColor imageName:(NSString *)imageName style:(TitleImageBtnStyle)style leftMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin rightMargin:(CGFloat)rightMargin frame:(CGRect)frame isAutoWidth:(BOOL)isAutoWidth;
@end
