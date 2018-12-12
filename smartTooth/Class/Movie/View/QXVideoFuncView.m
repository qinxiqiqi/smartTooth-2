//
//  QXVideoFuncView.m
//  smartTooth
//
//  Created by qinxi on 2018/11/24.
//  Copyright © 2018年 ttzx. All rights reserved.
//

#import "QXVideoFuncView.h"
#import <ReplayKit/ReplayKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface QXVideoFuncView()<RPPreviewViewControllerDelegate>

@end

@implementation QXVideoFuncView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self hideView];
    }
    return self;
}

- (void)initView {
    UIButton *recordBtn = [[UIButton alloc] init];
    [recordBtn setImage:[UIImage imageNamed:@"video_record_normal"] forState:UIControlStateNormal];
    [recordBtn setImage:[UIImage imageNamed:@"video_record_select"] forState:UIControlStateSelected];
    [recordBtn setTitleColor:UIColorHex(0x2f71ff) forState:UIControlStateNormal];
    recordBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    recordBtn.layer.cornerRadius = 30;
    recordBtn.layer.masksToBounds = YES;
    [self addSubview:recordBtn];
    [recordBtn addTarget:self action:@selector(recordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-30);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
    
    UIButton *photoBtn = [[UIButton alloc] init];
    [photoBtn setImage:[UIImage imageNamed:@"video_photo"] forState:UIControlStateNormal];
    photoBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    photoBtn.layer.cornerRadius = 30;
    photoBtn.layer.masksToBounds = YES;
    [self addSubview:photoBtn];
    [photoBtn addTarget:self action:@selector(photoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(recordBtn.mas_top).offset(-30);
        make.width.mas_offset(60);
        make.height.mas_offset(60);
    }];
}


- (void)recordBtnClicked:(UIButton *)sender {
    if (sender.isSelected) {//结束录制
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                //处理发生的错误，如磁盘空间不足而停止等
            }
            if (previewViewController) {
                //设置预览页面到代理
                previewViewController.previewControllerDelegate = self;
                [self.viewController presentViewController:previewViewController animated:YES completion:nil];
            }
        }];
        sender.selected = NO;
        return;

        
    } else {//开始录制
        if ([RPScreenRecorder sharedRecorder].available) {
            NSLog(@"OK");
            sender.selected = YES;
            //如果支持，就使用下面的方法可以启动录制回放
            [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError * _Nullable error) {
                NSLog(@"%@", error);
                //处理发生的错误，如设用户权限原因无法开始录制等
            }];
        } else {
            NSLog(@"录制回放功能不可用");
        }

    }
}

- (void)photoBtnClicked:(UIButton *)sender {
//    sender.selected = !sender.isSelected;
//    if (self.didClickRotationAction) {
//        self.didClickRotationAction(sender);
//    }
    [self savePhoto];
}
// 保存图片到相册功能，ALAssetsLibraryiOS9.0 以后用photoliabary 替代，
-(void)savePhoto
{
    UIImage * image = [self captureImageFromView:self];
    ALAssetsLibrary * library = [ALAssetsLibrary new];
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [MBProgressHUD showSuccess:@"保存成功"];
        } else {
            [MBProgressHUD showError:error.localizedFailureReason];
        }
    }];
}
//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)showView
{
    self.isShow = YES;
    self.hidden = NO;
}
- (void)hideView
{
    self.isShow = NO;
    self.hidden = YES;
}


- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
{
    [previewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes
{
    
}
@end
