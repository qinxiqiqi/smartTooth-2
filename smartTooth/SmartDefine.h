//
//  SmartDefine.h
//  SmartTooth
//
//  Created by qinxi on 2018/9/7.
//  Copyright © 2018年 zhineng. All rights reserved.
//

#ifndef SmartDefine_h
#define SmartDefine_h

#define BaseUrl @"http://ceshi.jumodel.cn"

//获取验证码
#define API_LOGIN_GETCODE               BaseUrl@"/app/smsnote/sendsms"
//登录
#define API_USER_LOGIN                  BaseUrl@"/app/user/login"
//更新用户信息
#define API_USER_UPDATE                 BaseUrl@"/app/user/update"
//上传图片
#define API_UPLOAD_IMAGE                BaseUrl@"/open/file/upload/image"

//获取医师列表
#define API_DOCTOR_LIST                 BaseUrl@"/app/cure/getDoctor"
//获取医师详情
#define API_DOCTOR_DETAIL               BaseUrl@"/app/cure/getDoctorInfo"
//获取诊所列表
#define API_CLINIC_LIST                 BaseUrl@"/app/cure/getClinic"
//获取诊所详情
#define API_CLINIC_DETAIL               BaseUrl@"/app/cure/getClinicInfo"
//获取城市
#define API_LOCATION_CITYLIST           BaseUrl@"/app/area/get"
//上传7牛获取token接口
#define API_TOKEN_CQN                   BaseUrl@"/open/api/token/qn"
//诊所相册
#define API_CLINIC_PHOTOBROWSER         BaseUrl@"/app/cure/getPhoto"
//更新牙刷信息
#define API_TOOTH_UPDATE                BaseUrl@"/app/device/update"

#define ChangeUserInfoNoti                @"ChangeUserInfo"



#endif /* SmartDefine_h */
