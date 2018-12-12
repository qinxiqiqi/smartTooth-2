//
//  QXLocationCell.m
//  NaHao
//
//  Created by NIT on 2017/10/31.
//  Copyright © 2017年 beifanghudong. All rights reserved.
//

#import "QXLocationCell.h"
#import "QXTitleImageBtn.h"
#import "LocationManager.h"
@interface QXLocationCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *locationLabel;
@property (nonatomic, weak) QXTitleImageBtn *reloadBtn;
//添加一个一秒钟响应60次的定时器
@property(nonatomic,strong)CADisplayLink *link;
@end
@implementation QXLocationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXLocationCell"];
    if (!cell) {
        cell = [[QXLocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXLocationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    CGFloat cellH = 35;
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth, cellH/2)];
//    self.titleLabel = titleLabel;
//    titleLabel.text = @"当前位置";
//    titleLabel.font = [UIFont systemFontOfSize:13];
//    titleLabel.textColor = UIColorHex(0x555e5b);
//    [self.contentView addSubview:titleLabel];
    
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 108, cellH)];
    self.locationLabel = locationLabel;
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = UIColorHex(0x333333);
    locationLabel.layer.borderWidth = 1;
    locationLabel.layer.borderColor = UIColorHex(0xe5e5e5).CGColor;
    locationLabel.backgroundColor = UIColorHex(0xf5f5f5);
    locationLabel.layer.cornerRadius = 2;
    locationLabel.layer.masksToBounds = YES;
    locationLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:locationLabel];
    
//    QXTitleImageBtn *reloadBtn = [[QXTitleImageBtn alloc]initWithTitle:@"重新加载" titleFont:[UIFont systemFontOfSize:13] titleColor:UIColorHex(0xc9c9c9) imageName:@"重新加载" style:TitleImageBtnStyleLeftImage leftMargin:0 centerMargin:3 rightMargin:15 frame:CGRectMake(ScreenWidth - 90, locationLabel.y, 90, cellH/2) isAutoWidth:NO];
//    self.reloadBtn = reloadBtn;
//    [reloadBtn addTarget:self action:@selector(reloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:reloadBtn];
}
//赋值当前的位置
- (void)setCurrentLocation:(NSString *)currentLocation
{
    _currentLocation = currentLocation;
    self.locationLabel.text = currentLocation;
}
//点击刷新按钮
- (void)reloadBtnClicked:(QXTitleImageBtn *)sender
{
    [self.link invalidate];//先暂停在开启
    //开启旋转动画
    // 手动将定时器添加到事件循环中
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotation)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self startLocation];
}

// 此方法一秒钟会被调用60次
-(void)rotation
{
    //1秒钟 转一圈  转2π
    //1秒钟 调用60次  每次转多少？ 2π/60
    self.reloadBtn.customImageView.layer.transform = CATransform3DRotate(self.reloadBtn.customImageView.layer.transform,2*M_PI/60, 0, 0, 1);
}
- (void)dealloc
{
    //定时器暂停
    [self.link invalidate];
    self.reloadBtn.customImageView.layer.transform = CATransform3DIdentity;
}
//开启定位
- (void)startLocation
{
    LocationManager *manager = [LocationManager shareManager];
    [manager beginLocation];//开启定位
    manager.locationGet = ^(NSString *location,NSString *detail) {//获取位置
        //定时器暂停
        [self.link invalidate];
        self.reloadBtn.customImageView.layer.transform = CATransform3DIdentity;
        
        if (location.length > 0) {
            //存储本次定位结果
            NSString *city = [location substringToIndex:location.length - 1];
            JZUserInfo *user = [JZUserInfo unarchiveObject];
            user.location = city;
            [JZUserInfo archiveObject:user];
            //更新页面
            self.locationLabel.text = detail;
        }
    };
}
@end
