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
printf("\n🍎 🍎 🍎 🍎\n%d %s %s,  %s[%d]: " format "\n" "🍊 🍊 🍊 🍊\n\n", __STDC__, __DATE__, __TIME__, __FUNCTION__, __LINE__,  ##__VA_ARGS__)




class Chapter6 {
    
public:
    //二叉树结构体
    typedef struct BinaryTree {
        char value;
        struct BinaryTree *leftChild;
        struct BinaryTree *rightChild;
    }BinaryTree, *BinaryTreeNode;
    //二叉树输入值
    //    char characters[16] = "52##4##36##8##7";
    //    char characters[24] = "ABDH#K###E##CFI###G#J##";
    char characters[10] = "AB#D##";
    //起始变量值
    int number = 0;
    
    
    //函数调用算法
    void chapter6Run();
    
    
    void question57_1(char* questionName, int array[], int value, int size = 6);
    
    /// page275: 56 数组中数字出现的次数
    /// 用来在num的二进制表示中找到最右边是1的位
    /// @param data 数组
    /// @param length 长度
    /// @param num1 数字1
    /// @param num2 数字2
    void findNumsAppearOnce(const char *name, int data[], int length, int *num1, int *num2);
    //返回无符号整型
    unsigned int findFirstBitIs1(int num);
    
    
    /// page272: 55 获取二叉树的深度
    /// @param rootNode 根结点
    int getBinaryTreeDepth(BinaryTree *rootNode);
    
    
    /// P269 算法54: 二叉搜索树的第 K 大节点
    /// @param k 第 k 节点
    /// @param pRoot 根结点指针变量
    BinaryTree *kthNode(BinaryTree *pRoot, unsigned int k);
    
    
    /// P263  算法53： 数字在排序数组中出现的次数
    /// @param array 传递的数组
    /// @param num 指定的值
    /// @param endIndex 数组终止索引
    /// @param startIndex 数组起始索引，默认值为0，放在最后规定
    int getSpecifyNumCount(int *array, int num, int endIndex, int startIndex = 0);
    
    /// 二叉树创建
    /// @param binaryTree 根结点指针
    void createBinaryTree(BinaryTreeNode *binaryTree, int index = 0);
    
    
};



#endif /* Chapter6_hpp */
