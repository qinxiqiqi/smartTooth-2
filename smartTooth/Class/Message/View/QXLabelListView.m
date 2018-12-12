//
//  QXLabelListView.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/26.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXLabelListView.h"

@implementation QXLabelListView

- (void)setLabelList:(NSArray *)labelList
{
    //添加标签
    CGFloat leftMargin = self.leftMargin;
    CGFloat topMargin = self.topMargin;
    CGFloat centerMargin = 10;//两个标签的间距
    CGFloat controlH = 17;//标签高
    CGFloat textMargin = 6;//文本左右间距
    NSArray *skillList = labelList;
    CGFloat totalW = leftMargin;//总宽
    CGFloat totalH = topMargin;//总高
    for (int i = 0; i < skillList.count+1; i++) {
        NSString *str = @"";
        if (i == 0) {
            str = @"擅长:";
        } else {
            str = skillList[i - 1];
        }
        CGSize strSize = [str boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(totalW + centerMargin, totalH, strSize.width + textMargin * 2, controlH)];
        
        totalW += (strSize.width + textMargin * 2 + centerMargin);
        if (totalW > self.width) {//换行
            totalH += (controlH + centerMargin);
            btn.frame = CGRectMake(leftMargin, totalH, strSize.width + textMargin * 2, controlH);
            totalW = strSize.width + textMargin * 2 + leftMargin;
        }
        if (i == 0) {
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:UIColorHex(0x333333) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
        } else {
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex(0x517dc0) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.backgroundColor = UIColorHex(0xf4f7ff);
        }
        [self addSubview:btn];
        self.viewHeight = CGRectGetMaxY(btn.frame);
    }
}

+ (CGFloat)getHeightWithLabelList:(NSArray *)labelList leftMargin:(CGFloat)leftMargin topMargin:(CGFloat)topMargin totalWidth:(CGFloat)totalWidth
{
    CGFloat centerMargin = 10;//两个标签的间距
    CGFloat controlH = 17;//标签高
    CGFloat textMargin = 6;//文本左右间距
    CGFloat totalW = leftMargin;//总宽
    CGFloat totalH = topMargin;//总高
    for (int i = 0; i < labelList.count+1; i++) {
        
        NSString *str = @"";
        if (i == 0) {
            str = @"擅长:";
        } else {
            str = labelList[i - 1];
        }
        CGSize strSize = [str boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        totalW += (strSize.width + textMargin * 2 + centerMargin);
        if (totalW > totalWidth) {//换行
            totalW = leftMargin;
            totalH += (controlH + centerMargin);
        }
    }
    totalH+=(controlH + 2 * topMargin);
    return totalH;
}
@end
