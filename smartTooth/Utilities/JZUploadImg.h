//
//  JZUploadImg.h
//  UploadImg
//
//  Created by Demi on 2018/6/11.
//  Copyright © 2018年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNUploadManager.h"
#import "QNUploadOption.h"

typedef NS_ENUM ( NSInteger , uploadWorkType){
    uploadWorksForImage_ = 0,//照片任务
    uploadWorksForVideo_ = 1,//视频任务
    uploadWorksForAudio_ = 2,//录音任务
    uploadWorksForGIFImage_ = 3,//GIF任务
};
typedef void(^uploadState)(NSDictionary *uploadStateDict);

@interface JZUploadImg : NSObject

@property ( nonatomic , copy ) uploadState state;

+(JZUploadImg *)ShareUploadImg;
- (void)uploadFielData:(NSData *)data uploadType:(uploadWorkType)uploadType andConfiguration:(QNConfiguration *)Configuration;

- (void)uploadFielData:(NSData *)data uploadType:(uploadWorkType)uploadType andConfiguration:(QNConfiguration *)Configuration andState:(uploadState)fileState;

@end
