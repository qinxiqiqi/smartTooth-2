//
//  Pinyin.m
//  Pinjiang
//
//  Created by VincentYin on 16/1/22.
//  Copyright © 2016年 LeBron Jiang. All rights reserved.
//
#import "Pinyin.h"

char pinyinFirstLetter(unsigned short hanzi)
{
    //先判断英文
    int index = hanzi - YINGYUDA_START;
    if (index >= 0 && index <= YINGYU_COUNT) {
        return yingyudaArray[index];
    }
    
    index = hanzi - YINGYUXIAO_START;
    if (index > 0 && index <= YINGYU_COUNT) {
        return yingyuxiaoArray[index];
    }
    index = hanzi - HANZI_START;
    if (index >= 0 && index <= HANZI_COUNT)
    {
        return firstLetterArray[index];
    }
    else
    {
        return '#';
    }
}
