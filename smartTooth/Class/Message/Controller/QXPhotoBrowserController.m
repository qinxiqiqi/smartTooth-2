//
//  QXPhotoBrowserController.m
//  SmartTooth
//
//  Created by qinxi on 2018/10/23.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXPhotoBrowserController.h"
#import "QXPhotoBrowserCell.h"
#import "YYPhotoBrowseView.h"
#import "AppDelegate.h"
#import "QXPhotoModel.h"
@interface QXPhotoBrowserController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, strong) NSArray *photoItems;
@end

@implementation QXPhotoBrowserController

- (NSMutableArray *)photoViews
{
    if (!_photoViews) {
        _photoViews = [NSMutableArray array];
    }
    return _photoViews;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorHex(0xffffff);
    
    [self setNaviBar];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);
    //设置每个item的大小
    layout.itemSize = CGSizeMake((ScreenWidth - 30)/2, (ScreenWidth - 30)/2 * 3 / 4 + 20);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, ScreenHeight - kNavigationBarHeight) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[QXPhotoBrowserCell class] forCellWithReuseIdentifier:@"QXPhotoBrowserCell"];
    collectionView.backgroundColor = UIColorHex(0xf2f5fa);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
}
- (void)setNaviBar {
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    naviBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 100, kStatusBarHeight, 200, 44)];
    titleLabel.text = @"相册";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = UIColorHex(0x333333);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [naviBar addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"back-black"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:leftBtn];
    
}


#pragma mark - CollectionView delegate
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QXPhotoBrowserCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"QXPhotoBrowserCell" forIndexPath:indexPath];
    QXPhotoModel *model = self.photoList[indexPath.row];
    [cell.thumbImgView setImageWithURL:[NSURL URLWithString:model.url] placeholder:[UIImage imageNamed:@"zsxq_pic"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.photoViews removeAllObjects];
    UIImageView *fromImgView;
    for (int i = 0; i < self.photoList.count
         ; i++) {
        QXPhotoModel *model = [[QXPhotoModel alloc] init];
        QXPhotoBrowserCell *cell = (QXPhotoBrowserCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = cell.thumbImgView;
        NSURL *url = [NSURL URLWithString:model.url];
        item.largeImageURL = url;
        [self.photoViews addObject:item];
        if (i == indexPath.item) {
            fromImgView = cell.thumbImgView;
        }
    }
    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:self.photoViews];
    [groupView presentFromImageView:fromImgView toContainer:self.view animated:YES completion:nil];
}

- (void)backItemClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
