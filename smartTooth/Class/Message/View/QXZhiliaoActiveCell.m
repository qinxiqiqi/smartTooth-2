//
//  QXZhiliaoActiveCell.m
//  SmartTooth
//
//  Created by qinxi on 2018/8/12.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXZhiliaoActiveCell.h"
#import "QXActiveCollectionCell.h"
@interface QXZhiliaoActiveCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation QXZhiliaoActiveCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    QXZhiliaoActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QXZhiliaoActiveCell"];
    if (!cell) {
        cell = [[QXZhiliaoActiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QXZhiliaoActiveCell"];
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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kCollectionItemW, kActiveCollectionItemH);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kActiveCollectionItemH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"QXActiveCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"QXActiveCollectionCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:collectionView];
}

#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QXActiveCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"QXActiveCollectionCell" forIndexPath:indexPath];
    return cell;
}
@end
