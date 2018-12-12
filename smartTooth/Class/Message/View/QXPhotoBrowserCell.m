//
//  QXPhotoBrowserCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/23.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXPhotoBrowserCell.h"

@implementation QXPhotoBrowserCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *thumbImgView = [[UIImageView alloc] init];
        self.thumbImgView = thumbImgView;
        [self.contentView addSubview:thumbImgView];
        [thumbImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
            make.left.right.equalTo(self);
        }];
    }
    return self;
}
@end
