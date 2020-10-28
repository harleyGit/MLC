//
//  Chapter6.hpp
//  C2
//
//  Created by Harely Huang on 2020/10/28.
//

#ifndef Chapter6_hpp
#define Chapter6_hpp

#include <stdio.h>

#define PrintFormat1(format, ...) \
printf("🍎 🍎 🍎 🍎"\
"\n"\
"文件名: %s"\
"\n"\
"ANSI标准: %d 时间：%s %s  行数: %d 函数:%s \n"\
"参数值：" format "\n", __FILE__, __STDC__, __DATE__, __TIME__,  __LINE__, __FUNCTION__, ##__VA_ARGS__)

#define PrintFormat2(format, ...) \
printf("🍎 🍎 🍎 🍎\n%d %s %s,  %s[%d]: " format "\n" "🍊 🍊 🍊 🍊\n\n", __STDC__, __DATE__, __TIME__, __FUNCTION__, __LINE__,  ##__VA_ARGS__)


class Chapter6 {
    
public:
    /// 算法： 数字在排序数组中出现的次数
    /// @param array 传递的数组
    /// @param num 指定的值
    /// @param endIndex 数组终止索引
    /// @param startIndex 数组起始索引，默认值为0，放在最后规定
    int getSpecifyNumCount(int *array, int num, int endIndex, int startIndex = 0);
    
    //函数调用算法
    void chapter6Run();
    
};



#endif /* Chapter6_hpp */
