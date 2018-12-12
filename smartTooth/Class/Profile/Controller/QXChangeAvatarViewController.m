//
//  QXChangeAvatarViewController.m
//  SmartTooth
//
//  Created by qinxi on 2018/9/5.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#import "QXChangeAvatarViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "JZUploadImg.h"
#import <TZImagePickerController.h>

@interface QXChangeAvatarViewController ()< UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastScale;
@end

@implementation QXChangeAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
    [self setupNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)initView {
    
    self.view.backgroundColor = [UIColor blackColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 1.0;
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    tapGR.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:tapGR];
    
    //
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight - self.view.width)/2, _scrollView.width, _scrollView.width)];
    _imageView.userInteractionEnabled = true;
    _imageView.clipsToBounds = true;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    JZUserInfo *user = [JZUserInfo unarchiveObject];
    [_imageView setImageWithURL:[NSURL URLWithString:user.head] placeholder:[UIImage imageNamed:AvatarPlaceholder]];
    [_scrollView addSubview:_imageView];
}


- (void)setupNav{
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavigationBarHeight)];
    naviBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:naviBar];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, 60, 44)];
    [backBtn setImage:[UIImage imageNamed:@"white-back-black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backBtn.top, 200, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.centerX = naviBar.centerX;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"个人详情";
    [naviBar addSubview:titleLabel];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 60, backBtn.top, 60, backBtn.height)];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rigthBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:rightBtn];
}

- (void)rigthBtnDidClick{

    __weak typeof(self)weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf  openCamera];
        
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf  openAlbum];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:albumAction];
    [alertController addAction:cameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    for(UIView* v in scrollView.subviews){
        return v;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    for(UIView* imgView in scrollView.subviews){
        imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                     scrollView.contentSize.height * 0.5 + offsetY);
    }
}


- (void)imageZoom:(id)sender{
    [self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    //当手指离开屏幕时,将lastscale设置为1.0
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        _lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
- (void)openCamera{
    
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertController* controller = [UIAlertController alertViewTitle:@"相册权限" message:@"由于拒绝了应用访问相册,所以该功能目前不可使用" cancelButtonTitle:@"取消" otherButtonTitles:@"去设置" handler:^(UIAlertAction * _Nullable action) {
            if ([action.title isEqualToString:@"取消"]) {
                
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                [self.navigationController dismissViewControllerAnimated:true completion:nil];
            }
        }];
        [self.navigationController presentViewController:controller animated:true completion:nil];
        
        return;
    }
    // 判断有没有支持
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openAlbum{
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    ipc.allowsEditing = YES;
//    ipc.delegate = self;
//    [self presentViewController:ipc animated:YES completion:nil];
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.showSelectBtn = NO;
    imagePicker.allowCrop = YES;
    imagePicker.cropRect = CGRectMake(0, (ScreenHeight - ScreenWidth) / 2, ScreenWidth, ScreenWidth);
    imagePicker.allowPickingVideo = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *resultImage = nil;
        if(picker.allowsEditing){
            resultImage = info[UIImagePickerControllerEditedImage];
        }else{
            resultImage = info[UIImagePickerControllerOriginalImage];
        }
        _imageView.image = resultImage;
        //        UIImage *image = [self thumbnailWithImageWithoutScale:resultImage size:CGSizeMake(100, 100)];// 这里是截取成100 100的
        
        [self uploadFile:resultImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = photos[0];
    _imageView.image = image;
    [self uploadFile:image];
}

//保持原始图片的长宽比，生成需要尺寸的图片
//2.保持原来的长宽比，生成一个缩略图
- (void)uploadFile:(UIImage *)image
{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    __weak typeof(self)weakSelf = self;
    [[JZUploadImg ShareUploadImg] uploadFielData:imageData uploadType:uploadWorksForImage_ andConfiguration:nil andState:^(NSDictionary *uploadStateDict) {
        if ([uploadStateDict[@"state"] isEqualToString:@"-2"]) {
            [MBProgressHUD showError:uploadStateDict[@"failureDesc"]];
        }else if ([uploadStateDict[@"state"] isEqualToString:@"1"]){
            NSString *url = [NSString stringWithFormat:@"http://pic.jumodel.cn/%@",uploadStateDict[@"key"]];
            [weakSelf updateRequestHead:url];
        }
    }];
//    [[UFHttpRequest defaultHttpRequest] postRequest:API_UPLOAD_IMAGE alertView:self.view parameters:nil formatData:imageData fileName:@"pic" success:^(id  _Nullable responseObject) {
//        NSString *headUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
//        if (!ISNULL(headUrl)) {
//            [self updateRequestHead:headUrl];
//        }
//    } failure:^(NSError * _Nullable error) {
//
//    }];
}
- (void)updateRequestHead:(NSString *)head {
    JZUserInfo *userInfo = [JZUserInfo unarchiveObject];
    userInfo.head = head;
    [JZUserInfo archiveObject:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeUserInfo" object:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = userInfo.userId;
    param[@"head"] = head;
    [[UFHttpRequest defaultHttpRequest] postRequest:API_USER_UPDATE alertView:nil parameters:param success:^(id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeUserInfoNoti object:nil];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)imageClick:(UITapGestureRecognizer *)tapGR {
    if (_scrollView.zoomScale > 1) {
        [_scrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [tapGR locationInView:_imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.view.width / newZoomScale;
        CGFloat ysize = self.view.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)leftBtnDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
