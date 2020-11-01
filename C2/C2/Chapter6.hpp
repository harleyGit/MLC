//
//  Chapter6.hpp
//  C2
//
//  Created by Harely Huang on 2020/10/28.
//

#ifndef Chapter6_hpp
#define Chapter6_hpp

#include <stdio.h>

/**
 *打印格式1
 */
#define PrintFormat1(format, ...) \
printf("🍎 🍎 🍎 🍎"\
"\n"\
"文件名: %s"\
"\n"\
"ANSI标准: %d 时间：%s %s  行数: %d 函数:%s \n"\
"参数值：" format "\n", __FILE__, __STDC__, __DATE__, __TIME__,  __LINE__, __FUNCTION__, ##__VA_ARGS__)

/**
 *打印格式2
 */
#define PrintFormat2(format, ...) \
printf("🍎 🍎 🍎 🍎\n%d %s %s,  %s[%d]: " format "\n" "🍊 🍊 🍊 🍊\n\n", __STDC__, __DATE__, __TIME__, __FUNCTION__, __LINE__,  ##__VA_ARGS__)




class Chapter6 {
    
    //二叉树结构体
    typedef struct BinaryTree {
        char value;
        struct BinaryTree *leftChild;
        struct BinaryTree *rightChild;
    }BinaryTree;
    
    //二叉树输入值
    char characters[3] = "01";//"012#456##9";
    //起始变量值
    int number = 0;
    
public:
    /// P263  算法53： 数字在排序数组中出现的次数
    /// @param array 传递的数组
    /// @param num 指定的值
    /// @param endIndex 数组终止索引
    /// @param startIndex 数组起始索引，默认值为0，放在最后规定
    int getSpecifyNumCount(int *array, int num, int endIndex, int startIndex = 0);
    
    
    //函数调用算法
    void chapter6Run();
    
    
    /// P269 算法54: 二叉搜索树的第 K 大节点
    /// @param index 第 index 节点
    /// @param rootNode 根结点指针变量
    int  binaryTreeNodeSearch(int index, BinaryTree *rootNode);
    
    
    /// 二叉树创建
    /// @param binaryTree 根结点指针
    void createBinaryTree(BinaryTree *binaryTree, int index = 0);
    
};



#endif /* Chapter6_hpp */
