//
//  Chapter6.cpp
//  C2
//
//  Created by Harely Huang on 2020/10/28.
//

#include "Chapter6.hpp"
#include <stdio.h>
#include <stdlib.h>
#include "math.h"
#include "string.h"




void Chapter6:: chapter6Run() {
    
    /*
    int array[7] = {1, 1, 2, 3, 4, 4, 4};
    int index = this->getSpecifyNumCount( array, 1, 6);
    PrintFormat1("%d", index);
    */
    
    PrintFormat2("%s 💣 💣 💣 💣 💣 💣 💣 💣 💣 💣 💣 💣", "=============================");
    //结构体指针需要申请内存空间才可以使用
    BinaryTree *binaryTree = (BinaryTree *)malloc(sizeof(BinaryTree));
//    PrintFormat2("BinaryTree 字节数为：%lu", sizeof(binaryTree));
//    binaryTree->value = '0';
//    PrintFormat2("赋值前：value: %c, leftNode:%p, rightNode: %p", binaryTree->value, binaryTree->leftChild, binaryTree->rightChild);
//
    this->createBinaryTree(binaryTree);
//    PrintFormat2("赋值后：value: %c, leftNode:%p, rightNode: %p", binaryTree->value, binaryTree->leftChild, binaryTree->rightChild);
    int nodeValue = this->binaryTreeNodeSearch(3, binaryTree);
    PrintFormat2("第 3 大节点value = %d", nodeValue);
    
    
    
    
}

//实现处把默认值省略
int Chapter6:: getSpecifyNumCount(int *array, int num, int endIndex, int startIndex) {
    
    //数组违法，不存在
    if (endIndex < startIndex) {
        return  -1;
    }
    
    //sizeof() 获取数组元素个数
    int middle = (endIndex + startIndex)/2;
    
    if (*(array + middle) == num) {//指针获取数组的值
        //array 表示是数组的首位地址
        //*(array+middle - 1) 取第 middle - 1 位元素
        //(*(array+middle - 1) < num && middle > 0) 表示当数组元素为中间时我们要取到最开始的元素，所以要进行判断
        //middle == 0 当数组是第 0 位时，那它就是第一位
        if ((*(array+middle - 1) < num && middle > 0) || middle == 0) {
            return  middle;
        }else {
            //当索引是中间或者最后相同的元素时
            endIndex = middle - 1;
        }
    }else if (*(array+middle) > num) {
        //取上限的下一位，因为middle已经比过了
        endIndex = middle - 1;
    }else if(*(array+middle) < num) {
        //取下限的上一位，因为middle已经比过了
        startIndex = middle + 1;
    }
    
    return  getSpecifyNumCount(array, num, endIndex, startIndex);
}


//创建二叉树
void Chapter6:: createBinaryTree(BinaryTree *binaryTree, int index) {
    char data = characters[index];
    
//    binaryTree->value = 'a';
//    BinaryTree *leftNode = (BinaryTree*)malloc(sizeof(BinaryTree));
//    leftNode->value = 'b';
//    binaryTree->leftChild = leftNode;
//
//    BinaryTree *rightNode = (BinaryTree*)malloc(sizeof(BinaryTree));
//    leftNode->value = 'c';
//    binaryTree->rightChild = rightNode;
    
    if (data == '#' || data == '\0') {
        binaryTree = NULL;
        
        return ;
    }else {
        if (binaryTree == NULL) {
            binaryTree = (BinaryTree*)malloc(sizeof(BinaryTree));
        }
        if (!binaryTree) {
            exit(OVERFLOW);
        }

        binaryTree->value = data;
        createBinaryTree(binaryTree->leftChild,++index);
//        createBinaryTree(binaryTree->rightChild, ++index);
    }
    
}


int  Chapter6:: binaryTreeNodeSearch(int index, BinaryTree *rootNode) {
    
    if ( rootNode == NULL) {
        return  0;
    }
    
    binaryTreeNodeSearch((index-1), rootNode->leftChild);
    
    PrintFormat2("%d", rootNode->value);
    if ((index-1) < 0) {
        PrintFormat2("第 K 大节点值是：%d", rootNode->value);
        return  rootNode->value;
    }
    
    binaryTreeNodeSearch((index-1), rootNode->rightChild);
    
    
    return  0;
}


