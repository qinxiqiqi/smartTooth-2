//
//  QXZhiliaoClinicCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXZhiliaoClinicCell.h"
#import "QXClinicCollectionCell.h"
#import "QXClinicModel.h"
@interface QXZhiliaoClinicCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIImageView *backImg;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *descLabel;
@end

@implementation QXZhiliaoClinicCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXZhiliaoClinicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXZhiliaoClinicCell"];
    if (!cell) {
        cell = [[QXZhiliaoClinicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXZhiliaoClinicCell"];
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
    UIImageView *thumbImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 9 / 16)];
    self.backImg = thumbImg;
    thumbImg.userInteractionEnabled = YES;
    thumbImg.contentMode = UIViewContentModeScaleAspectFill;
    thumbImg.clipsToBounds = YES;
    [self.contentView addSubview:thumbImg];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clinicBtnDidClicked:)];
    [thumbImg addGestureRecognizer:tapGR];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(10, thumbImg.height - 20 - 63, 180, 63)];
    self.coverView = coverView;
    coverView.userInteractionEnabled = NO;
    coverView.backgroundColor = UIColorHex(0x0060f0);
    coverView.alpha = 0.2;
    [self.contentView addSubview:coverView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(coverView.left, coverView.top, 4, coverView.height)];
    lineView.backgroundColor = UIColorHex(0x0060f0);
    [self.contentView addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(coverView.left + 14, coverView.top + 10, coverView.width - 14, 22)];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = UIColorHex(0xffffff);
    [self.contentView addSubview:nameLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 4, nameLabel.width, 17)];
    self.descLabel = descLabel;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = UIColorHex(0xffffff);
    [self.contentView addSubview:descLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, kclinicCollectionItemH);
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, thumbImg.bottom, ScreenWidth, kclinicCollectionItemH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"QXClinicCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QXClinicCollectionCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:collectionView];
}
- (void)setClinicModel:(QXClinicModel *)clinicModel
{
    _clinicModel = clinicModel;
    [self.backImg setImageWithURL:[NSURL URLWithString:clinicModel.img] placeholder:[UIImage imageNamed:@"yazhensuo_pic"]];
    self.nameLabel.text = notNil(clinicModel.cname);
    self.descLabel.text = notNil(clinicModel.dp_cname);
    
    CGSize nameSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth - self.nameLabel.left, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nameLabel.font} context:nil].size;
    CGSize descSize = [self.descLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth - self.nameLabel.left, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.descLabel.font} context:nil].size;
    self.nameLabel.width = nameSize.width;
    self.descLabel.width = descSize.width;
    if (nameSize.width > descSize.width) {
        if (nameSize.width > 63) {
            self.coverView.width = nameSize.width + 20;
        }
    } else {
        if (descSize.width > 63) {
            self.coverView.width = descSize.width + 20;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _clinicModel.doctors.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QXClinicCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"QXClinicCollectionCell" forIndexPath:indexPath];
    cell.doctor = _clinicModel.doctors[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clinicCell:didClickDoctorBtn:)]) {
        [self.delegate clinicCell:self didClickDoctorBtn:_clinicModel.doctors[indexPath.item]];
    }
}


- (void)clinicBtnDidClicked:(UITapGestureRecognizer *)tapGR {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clinicCell:didClickClinicBtn:)]) {
        [self.delegate clinicCell:self didClickClinicBtn:_clinicModel];
    }
}

@end
